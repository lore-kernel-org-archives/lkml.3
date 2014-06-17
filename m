Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967435AbaFQWHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:07:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54740 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965940AbaFQVwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:52:06 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 120/212] dm crypt: fix cpu hotplug crash by removing per-cpu structure
Date: Tue, 17 Jun 2014 14:43:34 -0700
Message-Id: <1403041506-13646-121-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 610f2de3559c383caf8fbbf91e9968102dff7ca0 upstream.

The DM crypt target used per-cpu structures to hold pointers to a
ablkcipher_request structure.  The code assumed that the work item keeps
executing on a single CPU, so it didn't use synchronization when
accessing this structure.

If a CPU is disabled by writing 0 to /sys/devices/system/cpu/cpu*/online,
the work item could be moved to another CPU.  This causes dm-crypt
crashes, like the following, because the code starts using an incorrect
ablkcipher_request:

 smpboot: CPU 7 is now offline
 BUG: unable to handle kernel NULL pointer dereference at 0000000000000130
 IP: [<ffffffffa1862b3d>] crypt_convert+0x12d/0x3c0 [dm_crypt]
 ...
 Call Trace:
  [<ffffffffa1864415>] ? kcryptd_crypt+0x305/0x470 [dm_crypt]
  [<ffffffff81062060>] ? finish_task_switch+0x40/0xc0
  [<ffffffff81052a28>] ? process_one_work+0x168/0x470
  [<ffffffff8105366b>] ? worker_thread+0x10b/0x390
  [<ffffffff81053560>] ? manage_workers.isra.26+0x290/0x290
  [<ffffffff81058d9f>] ? kthread+0xaf/0xc0
  [<ffffffff81058cf0>] ? kthread_create_on_node+0x120/0x120
  [<ffffffff813464ac>] ? ret_from_fork+0x7c/0xb0
  [<ffffffff81058cf0>] ? kthread_create_on_node+0x120/0x120

Fix this bug by removing the per-cpu definition.  The structure
ablkcipher_request is accessed via a pointer from convert_context.
Consequently, if the work item is rescheduled to a different CPU, the
thread still uses the same ablkcipher_request.

This change may undermine performance improvements intended by commit
c0297721 ("dm crypt: scale to multiple cpus") on select hardware.  In
practice no performance difference was observed on recent hardware.  But
regardless, correctness is more important than performance.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/dm-crypt.c | 61 ++++++++++-----------------------------------------
 1 file changed, 12 insertions(+), 49 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 81b0fa6..8c148f4 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -19,7 +19,6 @@
 #include <linux/crypto.h>
 #include <linux/workqueue.h>
 #include <linux/backing-dev.h>
-#include <linux/percpu.h>
 #include <linux/atomic.h>
 #include <linux/scatterlist.h>
 #include <asm/page.h>
@@ -45,6 +44,7 @@ struct convert_context {
 	unsigned int idx_out;
 	sector_t cc_sector;
 	atomic_t cc_pending;
+	struct ablkcipher_request *req;
 };
 
 /*
@@ -113,15 +113,7 @@ struct iv_tcw_private {
 enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID };
 
 /*
- * Duplicated per-CPU state for cipher.
- */
-struct crypt_cpu {
-	struct ablkcipher_request *req;
-};
-
-/*
- * The fields in here must be read only after initialization,
- * changing state should be in crypt_cpu.
+ * The fields in here must be read only after initialization.
  */
 struct crypt_config {
 	struct dm_dev *dev;
@@ -152,12 +144,6 @@ struct crypt_config {
 	sector_t iv_offset;
 	unsigned int iv_size;
 
-	/*
-	 * Duplicated per cpu state. Access through
-	 * per_cpu_ptr() only.
-	 */
-	struct crypt_cpu __percpu *cpu;
-
 	/* ESSIV: struct crypto_cipher *essiv_tfm */
 	void *iv_private;
 	struct crypto_ablkcipher **tfms;
@@ -194,11 +180,6 @@ static void clone_init(struct dm_crypt_io *, struct bio *);
 static void kcryptd_queue_crypt(struct dm_crypt_io *io);
 static u8 *iv_of_dmreq(struct crypt_config *cc, struct dm_crypt_request *dmreq);
 
-static struct crypt_cpu *this_crypt_config(struct crypt_config *cc)
-{
-	return this_cpu_ptr(cc->cpu);
-}
-
 /*
  * Use this to access cipher attributes that are the same for each CPU.
  */
@@ -914,16 +895,15 @@ static void kcryptd_async_done(struct crypto_async_request *async_req,
 static void crypt_alloc_req(struct crypt_config *cc,
 			    struct convert_context *ctx)
 {
-	struct crypt_cpu *this_cc = this_crypt_config(cc);
 	unsigned key_index = ctx->cc_sector & (cc->tfms_count - 1);
 
-	if (!this_cc->req)
-		this_cc->req = mempool_alloc(cc->req_pool, GFP_NOIO);
+	if (!ctx->req)
+		ctx->req = mempool_alloc(cc->req_pool, GFP_NOIO);
 
-	ablkcipher_request_set_tfm(this_cc->req, cc->tfms[key_index]);
-	ablkcipher_request_set_callback(this_cc->req,
+	ablkcipher_request_set_tfm(ctx->req, cc->tfms[key_index]);
+	ablkcipher_request_set_callback(ctx->req,
 	    CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
-	    kcryptd_async_done, dmreq_of_req(cc, this_cc->req));
+	    kcryptd_async_done, dmreq_of_req(cc, ctx->req));
 }
 
 /*
@@ -932,7 +912,6 @@ static void crypt_alloc_req(struct crypt_config *cc,
 static int crypt_convert(struct crypt_config *cc,
 			 struct convert_context *ctx)
 {
-	struct crypt_cpu *this_cc = this_crypt_config(cc);
 	int r;
 
 	atomic_set(&ctx->cc_pending, 1);
@@ -944,7 +923,7 @@ static int crypt_convert(struct crypt_config *cc,
 
 		atomic_inc(&ctx->cc_pending);
 
-		r = crypt_convert_block(cc, ctx, this_cc->req);
+		r = crypt_convert_block(cc, ctx, ctx->req);
 
 		switch (r) {
 		/* async */
@@ -953,7 +932,7 @@ static int crypt_convert(struct crypt_config *cc,
 			reinit_completion(&ctx->restart);
 			/* fall through*/
 		case -EINPROGRESS:
-			this_cc->req = NULL;
+			ctx->req = NULL;
 			ctx->cc_sector++;
 			continue;
 
@@ -1052,6 +1031,7 @@ static struct dm_crypt_io *crypt_io_alloc(struct crypt_config *cc,
 	io->sector = sector;
 	io->error = 0;
 	io->base_io = NULL;
+	io->ctx.req = NULL;
 	atomic_set(&io->io_pending, 0);
 
 	return io;
@@ -1077,6 +1057,8 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 	if (!atomic_dec_and_test(&io->io_pending))
 		return;
 
+	if (io->ctx.req)
+		mempool_free(io->ctx.req, cc->req_pool);
 	mempool_free(io, cc->io_pool);
 
 	if (likely(!base_io))
@@ -1505,8 +1487,6 @@ static int crypt_wipe_key(struct crypt_config *cc)
 static void crypt_dtr(struct dm_target *ti)
 {
 	struct crypt_config *cc = ti->private;
-	struct crypt_cpu *cpu_cc;
-	int cpu;
 
 	ti->private = NULL;
 
@@ -1518,13 +1498,6 @@ static void crypt_dtr(struct dm_target *ti)
 	if (cc->crypt_queue)
 		destroy_workqueue(cc->crypt_queue);
 
-	if (cc->cpu)
-		for_each_possible_cpu(cpu) {
-			cpu_cc = per_cpu_ptr(cc->cpu, cpu);
-			if (cpu_cc->req)
-				mempool_free(cpu_cc->req, cc->req_pool);
-		}
-
 	crypt_free_tfms(cc);
 
 	if (cc->bs)
@@ -1543,9 +1516,6 @@ static void crypt_dtr(struct dm_target *ti)
 	if (cc->dev)
 		dm_put_device(ti, cc->dev);
 
-	if (cc->cpu)
-		free_percpu(cc->cpu);
-
 	kzfree(cc->cipher);
 	kzfree(cc->cipher_string);
 
@@ -1601,13 +1571,6 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 	if (tmp)
 		DMWARN("Ignoring unexpected additional cipher options");
 
-	cc->cpu = __alloc_percpu(sizeof(*(cc->cpu)),
-				 __alignof__(struct crypt_cpu));
-	if (!cc->cpu) {
-		ti->error = "Cannot allocate per cpu state";
-		goto bad_mem;
-	}
-
 	/*
 	 * For compatibility with the original dm-crypt mapping format, if
 	 * only the cipher name is supplied, use cbc-plain.
-- 
1.9.1

