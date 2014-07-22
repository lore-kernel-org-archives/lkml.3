Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323AbaGVWJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:09:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:26886 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932294AbaGVWJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:09:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,712,1400050800"; 
   d="scan'208";a="547426920"
Subject: [PATCH v5 2/7] crypto: SHA1 multibuffer crypto hash infrastructure
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tadeusz Struk <tadeusz.struk@intel.com>, tkhai@yandex.ru,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <cover.1406033477.git.tim.c.chen@linux.intel.com>
References: <cover.1406033477.git.tim.c.chen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Jul 2014 15:09:32 -0700
Message-ID: <1406066972.2970.804.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces the multi-buffer crypto daemon which is responsible
for submitting crypto jobs in a work queue to the responsible multi-buffer
crypto algorithm.  The idea of the multi-buffer algorihtm is to put
data streams from multiple jobs in a wide (AVX2) register and then
take advantage of SIMD instructions to do crypto computation on several
buffers simultaneously.

The multi-buffer crypto daemon is also responsbile for flushing the
remaining buffers to complete the computation if no new buffers arrive
for a while.

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 crypto/Kconfig                 |  30 ++
 crypto/Makefile                |   1 +
 crypto/mcryptd.c               | 672 +++++++++++++++++++++++++++++++++++++++++
 include/crypto/internal/hash.h |   9 +
 include/crypto/mcryptd.h       | 112 +++++++
 5 files changed, 824 insertions(+)
 create mode 100644 crypto/mcryptd.c
 create mode 100644 include/crypto/mcryptd.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index ce4012a..5d3c711 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -157,6 +157,20 @@ config CRYPTO_CRYPTD
 	  converts an arbitrary synchronous software crypto algorithm
 	  into an asynchronous algorithm that executes in a kernel thread.
 
+config CRYPTO_MCRYPTD
+	tristate "Software async multi-buffer crypto daemon"
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_HASH
+	select CRYPTO_MANAGER
+	select CRYPTO_WORKQUEUE
+	help
+	  This is a generic software asynchronous crypto daemon that
+	  provides the kernel thread to assist multi-buffer crypto
+	  algorithms for submitting jobs and flushing jobs in multi-buffer
+	  crypto algorithms.  Multi-buffer crypto algorithms are executed
+	  in the context of this kernel thread and drivers can post
+	  their crypto request asyncrhously and process by this daemon.
+
 config CRYPTO_AUTHENC
 	tristate "Authenc support"
 	select CRYPTO_AEAD
@@ -547,6 +561,22 @@ config CRYPTO_SHA1_PPC
 	  This is the powerpc hardware accelerated implementation of the
 	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2).
 
+config CRYPTO_SHA1_MB
+	tristate "SHA1 digest algorithm (x86_64 Multi-Buffer, Experimental)"
+	depends on X86 && 64BIT
+	select CRYPTO_SHA1
+	select CRYPTO_HASH
+	select CRYPTO_MCRYPTD
+	help
+	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2) implemented
+	  using multi-buffer technique.  This algorithm computes on
+	  multiple data lanes concurrently with SIMD instructions for
+	  better throughput.  It should not be enabled by default but
+	  used when there is significant amount of work to keep the keep
+	  the data lanes filled to get performance benefit.  If the data
+	  lanes remain unfilled, a flush operation will be initiated to
+	  process the crypto jobs, adding a slight latency.
+
 config CRYPTO_SHA256
 	tristate "SHA224 and SHA256 digest algorithm"
 	select CRYPTO_HASH
diff --git a/crypto/Makefile b/crypto/Makefile
index 38e64231..27dbbad 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -60,6 +60,7 @@ obj-$(CONFIG_CRYPTO_GCM) += gcm.o
 obj-$(CONFIG_CRYPTO_CCM) += ccm.o
 obj-$(CONFIG_CRYPTO_PCRYPT) += pcrypt.o
 obj-$(CONFIG_CRYPTO_CRYPTD) += cryptd.o
+obj-$(CONFIG_CRYPTO_MCRYPTD) += mcryptd.o
 obj-$(CONFIG_CRYPTO_DES) += des_generic.o
 obj-$(CONFIG_CRYPTO_FCRYPT) += fcrypt.o
 obj-$(CONFIG_CRYPTO_BLOWFISH) += blowfish_generic.o
diff --git a/crypto/mcryptd.c b/crypto/mcryptd.c
new file mode 100644
index 0000000..622d6b4
--- /dev/null
+++ b/crypto/mcryptd.c
@@ -0,0 +1,672 @@
+/*
+ * Software multibuffer async crypto daemon.
+ *
+ * Copyright (c) 2014 Tim Chen <tim.c.chen@linux.intel.com>
+ *
+ * Adapted from crypto daemon.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#include <crypto/algapi.h>
+#include <crypto/internal/hash.h>
+#include <crypto/internal/aead.h>
+#include <crypto/mcryptd.h>
+#include <crypto/crypto_wq.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/scatterlist.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/hardirq.h>
+
+#define MCRYPTD_MAX_CPU_QLEN 100
+#define MCRYPTD_BATCH 9
+
+static void *mcryptd_alloc_instance(struct crypto_alg *alg, unsigned int head,
+				   unsigned int tail);
+
+struct mcryptd_flush_list {
+	struct list_head list;
+	struct mutex lock;
+};
+
+struct mcryptd_flush_list __percpu *mcryptd_flist;
+
+struct hashd_instance_ctx {
+	struct crypto_shash_spawn spawn;
+	struct mcryptd_queue *queue;
+};
+
+static void mcryptd_queue_worker(struct work_struct *work);
+
+void mcryptd_arm_flusher(struct mcryptd_alg_cstate *cstate, unsigned long delay)
+{
+	struct mcryptd_flush_list *flist;
+
+	if (!cstate->flusher_engaged) {
+		/* put the flusher on the flush list */
+		flist = per_cpu_ptr(mcryptd_flist, smp_processor_id());
+		mutex_lock(&flist->lock);
+		list_add_tail(&cstate->flush_list, &flist->list);
+		cstate->flusher_engaged = true;
+		cstate->next_flush = jiffies + delay;
+		queue_delayed_work_on(smp_processor_id(), kcrypto_wq,
+			&cstate->flush, delay);
+		mutex_unlock(&flist->lock);
+	}
+}
+EXPORT_SYMBOL(mcryptd_arm_flusher);
+
+static int mcryptd_init_queue(struct mcryptd_queue *queue,
+			     unsigned int max_cpu_qlen)
+{
+	int cpu;
+	struct mcryptd_cpu_queue *cpu_queue;
+
+	queue->cpu_queue = alloc_percpu(struct mcryptd_cpu_queue);
+	pr_debug("mqueue:%p mcryptd_cpu_queue %p\n", queue, queue->cpu_queue);
+	if (!queue->cpu_queue)
+		return -ENOMEM;
+	for_each_possible_cpu(cpu) {
+		cpu_queue = per_cpu_ptr(queue->cpu_queue, cpu);
+		pr_debug("cpu_queue #%d %p\n", cpu, queue->cpu_queue);
+		crypto_init_queue(&cpu_queue->queue, max_cpu_qlen);
+		INIT_WORK(&cpu_queue->work, mcryptd_queue_worker);
+	}
+	return 0;
+}
+
+static void mcryptd_fini_queue(struct mcryptd_queue *queue)
+{
+	int cpu;
+	struct mcryptd_cpu_queue *cpu_queue;
+
+	for_each_possible_cpu(cpu) {
+		cpu_queue = per_cpu_ptr(queue->cpu_queue, cpu);
+		BUG_ON(cpu_queue->queue.qlen);
+	}
+	free_percpu(queue->cpu_queue);
+}
+
+static int mcryptd_enqueue_request(struct mcryptd_queue *queue,
+				  struct crypto_async_request *request,
+				  struct mcryptd_hash_request_ctx *rctx)
+{
+	int cpu, err;
+	struct mcryptd_cpu_queue *cpu_queue;
+
+	cpu = get_cpu();
+	cpu_queue = this_cpu_ptr(queue->cpu_queue);
+	rctx->tag.cpu = cpu;
+
+	err = crypto_enqueue_request(&cpu_queue->queue, request);
+	pr_debug("enqueue request: cpu %d cpu_queue %p request %p\n",
+		 cpu, cpu_queue, request);
+	queue_work_on(cpu, kcrypto_wq, &cpu_queue->work);
+	put_cpu();
+
+	return err;
+}
+
+/* Called in workqueue context, do one real cryption work (via
+ * req->complete) and reschedule itself if there are more work to
+ * do. */
+static void mcryptd_queue_worker(struct work_struct *work)
+{
+	struct mcryptd_cpu_queue *cpu_queue;
+	struct crypto_async_request *req, *backlog;
+	int i;
+
+	/*
+	 * Need to loop through more than once for multi-buffer to
+	 * be effective.
+	 */
+
+	cpu_queue = container_of(work, struct mcryptd_cpu_queue, work);
+	i = 0;
+	while (i < MCRYPTD_BATCH || single_task_running()) {
+		/*
+		 * preempt_disable/enable is used to prevent
+		 * being preempted by mcryptd_enqueue_request()
+		 */
+		local_bh_disable();
+		preempt_disable();
+		backlog = crypto_get_backlog(&cpu_queue->queue);
+		req = crypto_dequeue_request(&cpu_queue->queue);
+		preempt_enable();
+		local_bh_enable();
+
+		if (!req)
+			return;
+
+		if (backlog)
+			backlog->complete(backlog, -EINPROGRESS);
+		req->complete(req, 0);
+		if (!cpu_queue->queue.qlen)
+			return;
+		++i;
+	}
+	if (cpu_queue->queue.qlen)
+		queue_work(kcrypto_wq, &cpu_queue->work);
+}
+
+void mcryptd_flusher(struct work_struct *__work)
+{
+	struct	mcryptd_alg_cstate	*alg_cpu_state;
+	struct	mcryptd_alg_state	*alg_state;
+	struct	mcryptd_flush_list	*flist;
+	int	cpu;
+
+	cpu = smp_processor_id();
+	alg_cpu_state = container_of(to_delayed_work(__work),
+				     struct mcryptd_alg_cstate, flush);
+	alg_state = alg_cpu_state->alg_state;
+	if (alg_cpu_state->cpu != cpu)
+		pr_debug("mcryptd error: work on cpu %d, should be cpu %d\n",
+				cpu, alg_cpu_state->cpu);
+
+	if (alg_cpu_state->flusher_engaged) {
+		flist = per_cpu_ptr(mcryptd_flist, cpu);
+		mutex_lock(&flist->lock);
+		list_del(&alg_cpu_state->flush_list);
+		alg_cpu_state->flusher_engaged = false;
+		mutex_unlock(&flist->lock);
+		alg_state->flusher(alg_cpu_state);
+	}
+}
+EXPORT_SYMBOL_GPL(mcryptd_flusher);
+
+static inline struct mcryptd_queue *mcryptd_get_queue(struct crypto_tfm *tfm)
+{
+	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
+	struct mcryptd_instance_ctx *ictx = crypto_instance_ctx(inst);
+
+	return ictx->queue;
+}
+
+static void *mcryptd_alloc_instance(struct crypto_alg *alg, unsigned int head,
+				   unsigned int tail)
+{
+	char *p;
+	struct crypto_instance *inst;
+	int err;
+
+	p = kzalloc(head + sizeof(*inst) + tail, GFP_KERNEL);
+	if (!p)
+		return ERR_PTR(-ENOMEM);
+
+	inst = (void *)(p + head);
+
+	err = -ENAMETOOLONG;
+	if (snprintf(inst->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		    "mcryptd(%s)", alg->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
+		goto out_free_inst;
+
+	memcpy(inst->alg.cra_name, alg->cra_name, CRYPTO_MAX_ALG_NAME);
+
+	inst->alg.cra_priority = alg->cra_priority + 50;
+	inst->alg.cra_blocksize = alg->cra_blocksize;
+	inst->alg.cra_alignmask = alg->cra_alignmask;
+
+out:
+	return p;
+
+out_free_inst:
+	kfree(p);
+	p = ERR_PTR(err);
+	goto out;
+}
+
+static int mcryptd_hash_init_tfm(struct crypto_tfm *tfm)
+{
+	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
+	struct hashd_instance_ctx *ictx = crypto_instance_ctx(inst);
+	struct crypto_shash_spawn *spawn = &ictx->spawn;
+	struct mcryptd_hash_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct crypto_shash *hash;
+
+	hash = crypto_spawn_shash(spawn);
+	if (IS_ERR(hash))
+		return PTR_ERR(hash);
+
+	ctx->child = hash;
+	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
+				 sizeof(struct mcryptd_hash_request_ctx) +
+				 crypto_shash_descsize(hash));
+	return 0;
+}
+
+static void mcryptd_hash_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct mcryptd_hash_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	crypto_free_shash(ctx->child);
+}
+
+static int mcryptd_hash_setkey(struct crypto_ahash *parent,
+				   const u8 *key, unsigned int keylen)
+{
+	struct mcryptd_hash_ctx *ctx   = crypto_ahash_ctx(parent);
+	struct crypto_shash *child = ctx->child;
+	int err;
+
+	crypto_shash_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_shash_set_flags(child, crypto_ahash_get_flags(parent) &
+				      CRYPTO_TFM_REQ_MASK);
+	err = crypto_shash_setkey(child, key, keylen);
+	crypto_ahash_set_flags(parent, crypto_shash_get_flags(child) &
+				       CRYPTO_TFM_RES_MASK);
+	return err;
+}
+
+static int mcryptd_hash_enqueue(struct ahash_request *req,
+				crypto_completion_t complete)
+{
+	int ret;
+
+	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct mcryptd_queue *queue =
+		mcryptd_get_queue(crypto_ahash_tfm(tfm));
+
+	rctx->complete = req->base.complete;
+	req->base.complete = complete;
+
+	ret = mcryptd_enqueue_request(queue, &req->base, rctx);
+
+	return ret;
+}
+
+static void mcryptd_hash_init(struct crypto_async_request *req_async, int err)
+{
+	struct mcryptd_hash_ctx *ctx = crypto_tfm_ctx(req_async->tfm);
+	struct crypto_shash *child = ctx->child;
+	struct ahash_request *req = ahash_request_cast(req_async);
+	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
+	struct shash_desc *desc = &rctx->desc;
+
+	if (unlikely(err == -EINPROGRESS))
+		goto out;
+
+	desc->tfm = child;
+	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	err = crypto_shash_init(desc);
+
+	req->base.complete = rctx->complete;
+
+out:
+	local_bh_disable();
+	rctx->complete(&req->base, err);
+	local_bh_enable();
+}
+
+static int mcryptd_hash_init_enqueue(struct ahash_request *req)
+{
+	return mcryptd_hash_enqueue(req, mcryptd_hash_init);
+}
+
+static void mcryptd_hash_update(struct crypto_async_request *req_async, int err)
+{
+	struct ahash_request *req = ahash_request_cast(req_async);
+	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
+
+	if (unlikely(err == -EINPROGRESS))
+		goto out;
+
+	err = shash_ahash_mcryptd_update(req, &rctx->desc);
+	if (err) {
+		req->base.complete = rctx->complete;
+		goto out;
+	}
+
+	return;
+out:
+	local_bh_disable();
+	rctx->complete(&req->base, err);
+	local_bh_enable();
+}
+
+static int mcryptd_hash_update_enqueue(struct ahash_request *req)
+{
+	return mcryptd_hash_enqueue(req, mcryptd_hash_update);
+}
+
+static void mcryptd_hash_final(struct crypto_async_request *req_async, int err)
+{
+	struct ahash_request *req = ahash_request_cast(req_async);
+	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
+
+	if (unlikely(err == -EINPROGRESS))
+		goto out;
+
+	err = shash_ahash_mcryptd_final(req, &rctx->desc);
+	if (err) {
+		req->base.complete = rctx->complete;
+		goto out;
+	}
+
+	return;
+out:
+	local_bh_disable();
+	rctx->complete(&req->base, err);
+	local_bh_enable();
+}
+
+static int mcryptd_hash_final_enqueue(struct ahash_request *req)
+{
+	return mcryptd_hash_enqueue(req, mcryptd_hash_final);
+}
+
+static void mcryptd_hash_finup(struct crypto_async_request *req_async, int err)
+{
+	struct ahash_request *req = ahash_request_cast(req_async);
+	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
+
+	if (unlikely(err == -EINPROGRESS))
+		goto out;
+
+	err = shash_ahash_mcryptd_finup(req, &rctx->desc);
+
+	if (err) {
+		req->base.complete = rctx->complete;
+		goto out;
+	}
+
+	return;
+out:
+	local_bh_disable();
+	rctx->complete(&req->base, err);
+	local_bh_enable();
+}
+
+static int mcryptd_hash_finup_enqueue(struct ahash_request *req)
+{
+	return mcryptd_hash_enqueue(req, mcryptd_hash_finup);
+}
+
+static void mcryptd_hash_digest(struct crypto_async_request *req_async, int err)
+{
+	struct mcryptd_hash_ctx *ctx = crypto_tfm_ctx(req_async->tfm);
+	struct crypto_shash *child = ctx->child;
+	struct ahash_request *req = ahash_request_cast(req_async);
+	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
+	struct shash_desc *desc = &rctx->desc;
+
+	if (unlikely(err == -EINPROGRESS))
+		goto out;
+
+	desc->tfm = child;
+	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;  /* check this again */
+
+	err = shash_ahash_mcryptd_digest(req, desc);
+
+	if (err) {
+		req->base.complete = rctx->complete;
+		goto out;
+	}
+
+	return;
+out:
+	local_bh_disable();
+	rctx->complete(&req->base, err);
+	local_bh_enable();
+}
+
+static int mcryptd_hash_digest_enqueue(struct ahash_request *req)
+{
+	return mcryptd_hash_enqueue(req, mcryptd_hash_digest);
+}
+
+static int mcryptd_hash_export(struct ahash_request *req, void *out)
+{
+	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
+
+	return crypto_shash_export(&rctx->desc, out);
+}
+
+static int mcryptd_hash_import(struct ahash_request *req, const void *in)
+{
+	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
+
+	return crypto_shash_import(&rctx->desc, in);
+}
+
+static int mcryptd_create_hash(struct crypto_template *tmpl, struct rtattr **tb,
+			      struct mcryptd_queue *queue)
+{
+	struct hashd_instance_ctx *ctx;
+	struct ahash_instance *inst;
+	struct shash_alg *salg;
+	struct crypto_alg *alg;
+	int err;
+
+	salg = shash_attr_alg(tb[1], 0, 0);
+	if (IS_ERR(salg))
+		return PTR_ERR(salg);
+
+	alg = &salg->base;
+	pr_debug("crypto: mcryptd hash alg: %s\n", alg->cra_name);
+	inst = mcryptd_alloc_instance(alg, ahash_instance_headroom(),
+					sizeof(*ctx));
+	err = PTR_ERR(inst);
+	if (IS_ERR(inst))
+		goto out_put_alg;
+
+	ctx = ahash_instance_ctx(inst);
+	ctx->queue = queue;
+
+	err = crypto_init_shash_spawn(&ctx->spawn, salg,
+				      ahash_crypto_instance(inst));
+	if (err)
+		goto out_free_inst;
+
+	inst->alg.halg.base.cra_flags = CRYPTO_ALG_ASYNC;
+
+	inst->alg.halg.digestsize = salg->digestsize;
+	inst->alg.halg.base.cra_ctxsize = sizeof(struct mcryptd_hash_ctx);
+
+	inst->alg.halg.base.cra_init = mcryptd_hash_init_tfm;
+	inst->alg.halg.base.cra_exit = mcryptd_hash_exit_tfm;
+
+	inst->alg.init   = mcryptd_hash_init_enqueue;
+	inst->alg.update = mcryptd_hash_update_enqueue;
+	inst->alg.final  = mcryptd_hash_final_enqueue;
+	inst->alg.finup  = mcryptd_hash_finup_enqueue;
+	inst->alg.export = mcryptd_hash_export;
+	inst->alg.import = mcryptd_hash_import;
+	inst->alg.setkey = mcryptd_hash_setkey;
+	inst->alg.digest = mcryptd_hash_digest_enqueue;
+
+	err = ahash_register_instance(tmpl, inst);
+	if (err) {
+		crypto_drop_shash(&ctx->spawn);
+out_free_inst:
+		kfree(inst);
+	}
+
+out_put_alg:
+	crypto_mod_put(alg);
+	return err;
+}
+
+static struct mcryptd_queue mqueue;
+
+static int mcryptd_create(struct crypto_template *tmpl, struct rtattr **tb)
+{
+	struct crypto_attr_type *algt;
+
+	algt = crypto_get_attr_type(tb);
+	if (IS_ERR(algt))
+		return PTR_ERR(algt);
+
+	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
+	case CRYPTO_ALG_TYPE_DIGEST:
+		return mcryptd_create_hash(tmpl, tb, &mqueue);
+	break;
+	}
+
+	return -EINVAL;
+}
+
+static void mcryptd_free(struct crypto_instance *inst)
+{
+	struct mcryptd_instance_ctx *ctx = crypto_instance_ctx(inst);
+	struct hashd_instance_ctx *hctx = crypto_instance_ctx(inst);
+
+	switch (inst->alg.cra_flags & CRYPTO_ALG_TYPE_MASK) {
+	case CRYPTO_ALG_TYPE_AHASH:
+		crypto_drop_shash(&hctx->spawn);
+		kfree(ahash_instance(inst));
+		return;
+	default:
+		crypto_drop_spawn(&ctx->spawn);
+		kfree(inst);
+	}
+}
+
+static struct crypto_template mcryptd_tmpl = {
+	.name = "mcryptd",
+	.create = mcryptd_create,
+	.free = mcryptd_free,
+	.module = THIS_MODULE,
+};
+
+struct mcryptd_ahash *mcryptd_alloc_ahash(const char *alg_name,
+					u32 type, u32 mask)
+{
+	char mcryptd_alg_name[CRYPTO_MAX_ALG_NAME];
+	struct crypto_ahash *tfm;
+
+	if (snprintf(mcryptd_alg_name, CRYPTO_MAX_ALG_NAME,
+		     "mcryptd(%s)", alg_name) >= CRYPTO_MAX_ALG_NAME)
+		return ERR_PTR(-EINVAL);
+	tfm = crypto_alloc_ahash(mcryptd_alg_name, type, mask);
+	if (IS_ERR(tfm))
+		return ERR_CAST(tfm);
+	if (tfm->base.__crt_alg->cra_module != THIS_MODULE) {
+		crypto_free_ahash(tfm);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return __mcryptd_ahash_cast(tfm);
+}
+EXPORT_SYMBOL_GPL(mcryptd_alloc_ahash);
+
+int shash_ahash_mcryptd_digest(struct ahash_request *req,
+			       struct shash_desc *desc)
+{
+	int err;
+
+	err = crypto_shash_init(desc) ?:
+	      shash_ahash_mcryptd_finup(req, desc);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(shash_ahash_mcryptd_digest);
+
+int shash_ahash_mcryptd_update(struct ahash_request *req,
+			       struct shash_desc *desc)
+{
+	struct crypto_shash *tfm = desc->tfm;
+	struct shash_alg *shash = crypto_shash_alg(tfm);
+
+	/* alignment is to be done by multi-buffer crypto algorithm if needed */
+
+	return shash->update(desc, NULL, 0);
+}
+EXPORT_SYMBOL_GPL(shash_ahash_mcryptd_update);
+
+int shash_ahash_mcryptd_finup(struct ahash_request *req,
+			      struct shash_desc *desc)
+{
+	struct crypto_shash *tfm = desc->tfm;
+	struct shash_alg *shash = crypto_shash_alg(tfm);
+
+	/* alignment is to be done by multi-buffer crypto algorithm if needed */
+
+	return shash->finup(desc, NULL, 0, req->result);
+}
+EXPORT_SYMBOL_GPL(shash_ahash_mcryptd_finup);
+
+int shash_ahash_mcryptd_final(struct ahash_request *req,
+			      struct shash_desc *desc)
+{
+	struct crypto_shash *tfm = desc->tfm;
+	struct shash_alg *shash = crypto_shash_alg(tfm);
+
+	/* alignment is to be done by multi-buffer crypto algorithm if needed */
+
+	return shash->final(desc, req->result);
+}
+EXPORT_SYMBOL_GPL(shash_ahash_mcryptd_final);
+
+struct crypto_shash *mcryptd_ahash_child(struct mcryptd_ahash *tfm)
+{
+	struct mcryptd_hash_ctx *ctx = crypto_ahash_ctx(&tfm->base);
+
+	return ctx->child;
+}
+EXPORT_SYMBOL_GPL(mcryptd_ahash_child);
+
+struct shash_desc *mcryptd_shash_desc(struct ahash_request *req)
+{
+	struct mcryptd_hash_request_ctx *rctx = ahash_request_ctx(req);
+	return &rctx->desc;
+}
+EXPORT_SYMBOL_GPL(mcryptd_shash_desc);
+
+void mcryptd_free_ahash(struct mcryptd_ahash *tfm)
+{
+	crypto_free_ahash(&tfm->base);
+}
+EXPORT_SYMBOL_GPL(mcryptd_free_ahash);
+
+
+static int __init mcryptd_init(void)
+{
+	int err, cpu;
+	struct mcryptd_flush_list *flist;
+
+	mcryptd_flist = alloc_percpu(struct mcryptd_flush_list);
+	for_each_possible_cpu(cpu) {
+		flist = per_cpu_ptr(mcryptd_flist, cpu);
+		INIT_LIST_HEAD(&flist->list);
+		mutex_init(&flist->lock);
+	}
+
+	err = mcryptd_init_queue(&mqueue, MCRYPTD_MAX_CPU_QLEN);
+	if (err) {
+		free_percpu(mcryptd_flist);
+		return err;
+	}
+
+	err = crypto_register_template(&mcryptd_tmpl);
+	if (err) {
+		mcryptd_fini_queue(&mqueue);
+		free_percpu(mcryptd_flist);
+	}
+
+	return err;
+}
+
+static void __exit mcryptd_exit(void)
+{
+	mcryptd_fini_queue(&mqueue);
+	crypto_unregister_template(&mcryptd_tmpl);
+	free_percpu(mcryptd_flist);
+}
+
+subsys_initcall(mcryptd_init);
+module_exit(mcryptd_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Software async multibuffer crypto daemon");
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 9b6f32a..3b4af1d 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -117,6 +117,15 @@ int shash_ahash_update(struct ahash_request *req, struct shash_desc *desc);
 int shash_ahash_finup(struct ahash_request *req, struct shash_desc *desc);
 int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc);
 
+int shash_ahash_mcryptd_update(struct ahash_request *req,
+			       struct shash_desc *desc);
+int shash_ahash_mcryptd_final(struct ahash_request *req,
+			      struct shash_desc *desc);
+int shash_ahash_mcryptd_finup(struct ahash_request *req,
+			      struct shash_desc *desc);
+int shash_ahash_mcryptd_digest(struct ahash_request *req,
+			       struct shash_desc *desc);
+
 int crypto_init_shash_ops_async(struct crypto_tfm *tfm);
 
 static inline void *crypto_ahash_ctx(struct crypto_ahash *tfm)
diff --git a/include/crypto/mcryptd.h b/include/crypto/mcryptd.h
new file mode 100644
index 0000000..c23ee1f
--- /dev/null
+++ b/include/crypto/mcryptd.h
@@ -0,0 +1,112 @@
+/*
+ * Software async multibuffer crypto daemon headers
+ *
+ *    Author:
+ *             Tim Chen <tim.c.chen@linux.intel.com>
+ *
+ *    Copyright (c) 2014, Intel Corporation.
+ */
+
+#ifndef _CRYPTO_MCRYPT_H
+#define _CRYPTO_MCRYPT_H
+
+#include <linux/crypto.h>
+#include <linux/kernel.h>
+#include <crypto/hash.h>
+
+struct mcryptd_ahash {
+	struct crypto_ahash base;
+};
+
+static inline struct mcryptd_ahash *__mcryptd_ahash_cast(
+	struct crypto_ahash *tfm)
+{
+	return (struct mcryptd_ahash *)tfm;
+}
+
+struct mcryptd_cpu_queue {
+	struct crypto_queue queue;
+	struct work_struct work;
+};
+
+struct mcryptd_queue {
+	struct mcryptd_cpu_queue __percpu *cpu_queue;
+};
+
+struct mcryptd_instance_ctx {
+	struct crypto_spawn spawn;
+	struct mcryptd_queue *queue;
+};
+
+struct mcryptd_hash_ctx {
+	struct crypto_shash *child;
+	struct mcryptd_alg_state *alg_state;
+};
+
+struct mcryptd_tag {
+	/* seq number of request */
+	unsigned seq_num;
+	/* arrival time of request */
+	unsigned long arrival;
+	unsigned long expire;
+	int	cpu;
+};
+
+struct mcryptd_hash_request_ctx {
+	struct list_head waiter;
+	crypto_completion_t complete;
+	struct mcryptd_tag tag;
+	struct crypto_hash_walk walk;
+	u8 *out;
+	int flag;
+	struct shash_desc desc;
+};
+
+struct mcryptd_ahash *mcryptd_alloc_ahash(const char *alg_name,
+					u32 type, u32 mask);
+struct crypto_shash *mcryptd_ahash_child(struct mcryptd_ahash *tfm);
+struct shash_desc *mcryptd_shash_desc(struct ahash_request *req);
+void mcryptd_free_ahash(struct mcryptd_ahash *tfm);
+void mcryptd_flusher(struct work_struct *work);
+
+enum mcryptd_req_type {
+	MCRYPTD_NONE,
+	MCRYPTD_UPDATE,
+	MCRYPTD_FINUP,
+	MCRYPTD_DIGEST,
+	MCRYPTD_FINAL
+};
+
+struct mcryptd_alg_cstate {
+	unsigned long next_flush;
+	unsigned next_seq_num;
+	bool	flusher_engaged;
+	struct  delayed_work flush;
+	int	cpu;
+	struct  mcryptd_alg_state *alg_state;
+	void	*mgr;
+	spinlock_t work_lock;
+	struct list_head work_list;
+	struct list_head flush_list;
+};
+
+struct mcryptd_alg_state {
+	struct mcryptd_alg_cstate __percpu *alg_cstate;
+	unsigned long (*flusher)(struct mcryptd_alg_cstate *cstate);
+};
+
+/* return delay in jiffies from current time */
+static inline unsigned long get_delay(unsigned long t)
+{
+	long delay;
+
+	delay = (long) t - (long) jiffies;
+	if (delay <= 0)
+		return 0;
+	else
+		return (unsigned long) delay;
+}
+
+void mcryptd_arm_flusher(struct mcryptd_alg_cstate *cstate, unsigned long delay);
+
+#endif
-- 
1.7.11.7



