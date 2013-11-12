Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab3KLRqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 12:46:35 -0500
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:14487
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754796Ab3KLRq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 12:46:28 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VPS3(zzc8kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h1155h)
X-WSS-ID: 0MW5VZK-07-EBS-02
X-M-MSG: 
Subject: [PATCH 04/10] crypto: crypto API interface to the CCP device driver
To: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <herbert@gondor.hengli.com.au>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Tue, 12 Nov 2013 11:46:22 -0600
Message-ID: <20131112174622.19746.45221.stgit@tlendack-t1.amdoffice.net>
In-Reply-To: <20131112174558.19746.47262.stgit@tlendack-t1.amdoffice.net>
References: <20131112174558.19746.47262.stgit@tlendack-t1.amdoffice.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These routines provide the support for the interface between the crypto API
and the AMD CCP. This includes insuring that requests associated with a
given tfm on the same cpu are processed in the order received.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-main.c |  432 ++++++++++++++++++++++++++++++++++
 drivers/crypto/ccp/ccp-crypto.h      |  191 +++++++++++++++
 2 files changed, 623 insertions(+)
 create mode 100644 drivers/crypto/ccp/ccp-crypto-main.c
 create mode 100644 drivers/crypto/ccp/ccp-crypto.h

diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
new file mode 100644
index 0000000..2636f04
--- /dev/null
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -0,0 +1,432 @@
+/*
+ * AMD Cryptographic Coprocessor (CCP) crypto API support
+ *
+ * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ *
+ * Author: Tom Lendacky <thomas.lendacky@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/ccp.h>
+#include <linux/scatterlist.h>
+#include <crypto/internal/hash.h>
+
+#include "ccp-crypto.h"
+
+MODULE_AUTHOR("Tom Lendacky <thomas.lendacky@amd.com>");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1.0.0");
+MODULE_DESCRIPTION("AMD Cryptographic Coprocessor crypto API support");
+
+
+/* List heads for the supported algorithms */
+static LIST_HEAD(hash_algs);
+static LIST_HEAD(cipher_algs);
+
+/* For any tfm, requests for that tfm on the same CPU must be returned
+ * in the order received.  With multiple queues available, the CCP can
+ * process more than one cmd at a time.  Therefore we must maintain
+ * a cmd list to insure the proper ordering of requests on a given tfm/cpu
+ * combination.
+ */
+struct ccp_crypto_cpu_queue {
+	struct list_head cmds;
+	struct list_head *backlog;
+	unsigned int cmd_count;
+};
+#define CCP_CRYPTO_MAX_QLEN	50
+
+struct ccp_crypto_percpu_queue {
+	struct ccp_crypto_cpu_queue __percpu *cpu_queue;
+};
+static struct ccp_crypto_percpu_queue req_queue;
+
+struct ccp_crypto_cmd {
+	struct list_head entry;
+
+	struct ccp_cmd *cmd;
+
+	/* Save the crypto_tfm and crypto_async_request addresses
+	 * separately to avoid any reference to a possibly invalid
+	 * crypto_async_request structure after invoking the request
+	 * callback
+	 */
+	struct crypto_async_request *req;
+	struct crypto_tfm *tfm;
+
+	/* Used for held command processing to determine state */
+	int ret;
+
+	int cpu;
+};
+
+struct ccp_crypto_cpu {
+	struct work_struct work;
+	struct completion completion;
+	struct ccp_crypto_cmd *crypto_cmd;
+	int err;
+};
+
+
+static inline bool ccp_crypto_success(int err)
+{
+	if (err && (err != -EINPROGRESS) && (err != -EBUSY))
+		return false;
+
+	return true;
+}
+
+/*
+ * ccp_crypto_cmd_complete must be called while running on the appropriate
+ * cpu and the caller must have done a get_cpu to disable preemption
+ */
+static struct ccp_crypto_cmd *ccp_crypto_cmd_complete(
+	struct ccp_crypto_cmd *crypto_cmd, struct ccp_crypto_cmd **backlog)
+{
+	struct ccp_crypto_cpu_queue *cpu_queue;
+	struct ccp_crypto_cmd *held = NULL, *tmp;
+
+	*backlog = NULL;
+
+	cpu_queue = this_cpu_ptr(req_queue.cpu_queue);
+
+	/* Held cmds will be after the current cmd in the queue so start
+	 * searching for a cmd with a matching tfm for submission.
+	 */
+	tmp = crypto_cmd;
+	list_for_each_entry_continue(tmp, &cpu_queue->cmds, entry) {
+		if (crypto_cmd->tfm != tmp->tfm)
+			continue;
+		held = tmp;
+		break;
+	}
+
+	/* Process the backlog:
+	 *   Because cmds can be executed from any point in the cmd list
+	 *   special precautions have to be taken when handling the backlog.
+	 */
+	if (cpu_queue->backlog != &cpu_queue->cmds) {
+		/* Skip over this cmd if it is the next backlog cmd */
+		if (cpu_queue->backlog == &crypto_cmd->entry)
+			cpu_queue->backlog = crypto_cmd->entry.next;
+
+		*backlog = container_of(cpu_queue->backlog,
+					struct ccp_crypto_cmd, entry);
+		cpu_queue->backlog = cpu_queue->backlog->next;
+
+		/* Skip over this cmd if it is now the next backlog cmd */
+		if (cpu_queue->backlog == &crypto_cmd->entry)
+			cpu_queue->backlog = crypto_cmd->entry.next;
+	}
+
+	/* Remove the cmd entry from the list of cmds */
+	cpu_queue->cmd_count--;
+	list_del(&crypto_cmd->entry);
+
+	return held;
+}
+
+static void ccp_crypto_complete_on_cpu(struct work_struct *work)
+{
+	struct ccp_crypto_cpu *cpu_work =
+		container_of(work, struct ccp_crypto_cpu, work);
+	struct ccp_crypto_cmd *crypto_cmd = cpu_work->crypto_cmd;
+	struct ccp_crypto_cmd *held, *next, *backlog;
+	struct crypto_async_request *req = crypto_cmd->req;
+	struct ccp_ctx *ctx = crypto_tfm_ctx(req->tfm);
+	int cpu, ret;
+
+	cpu = get_cpu();
+
+	if (cpu_work->err == -EINPROGRESS) {
+		/* Only propogate the -EINPROGRESS if necessary */
+		if (crypto_cmd->ret == -EBUSY) {
+			crypto_cmd->ret = -EINPROGRESS;
+			req->complete(req, -EINPROGRESS);
+		}
+
+		goto e_cpu;
+	}
+
+	/* Operation has completed - update the queue before invoking
+	 * the completion callbacks and retrieve the next cmd (cmd with
+	 * a matching tfm) that can be submitted to the CCP.
+	 */
+	held = ccp_crypto_cmd_complete(crypto_cmd, &backlog);
+	if (backlog) {
+		backlog->ret = -EINPROGRESS;
+		backlog->req->complete(backlog->req, -EINPROGRESS);
+	}
+
+	/* Transition the state from -EBUSY to -EINPROGRESS first */
+	if (crypto_cmd->ret == -EBUSY)
+		req->complete(req, -EINPROGRESS);
+
+	/* Completion callbacks */
+	ret = cpu_work->err;
+	if (ctx->complete)
+		ret = ctx->complete(req, ret);
+	req->complete(req, ret);
+
+	/* Submit the next cmd */
+	while (held) {
+		ret = ccp_enqueue_cmd(held->cmd);
+		if (ccp_crypto_success(ret))
+			break;
+
+		/* Error occurred, report it and get the next entry */
+		held->req->complete(held->req, ret);
+
+		next = ccp_crypto_cmd_complete(held, &backlog);
+		if (backlog) {
+			backlog->ret = -EINPROGRESS;
+			backlog->req->complete(backlog->req, -EINPROGRESS);
+		}
+
+		kfree(held);
+		held = next;
+	}
+
+	kfree(crypto_cmd);
+
+e_cpu:
+	put_cpu();
+
+	complete(&cpu_work->completion);
+}
+
+static void ccp_crypto_complete(void *data, int err)
+{
+	struct ccp_crypto_cmd *crypto_cmd = data;
+	struct ccp_crypto_cpu cpu_work;
+
+	INIT_WORK(&cpu_work.work, ccp_crypto_complete_on_cpu);
+	init_completion(&cpu_work.completion);
+	cpu_work.crypto_cmd = crypto_cmd;
+	cpu_work.err = err;
+
+	schedule_work_on(crypto_cmd->cpu, &cpu_work.work);
+
+	/* Keep the completion call synchronous */
+	wait_for_completion(&cpu_work.completion);
+}
+
+static int ccp_crypto_enqueue_cmd(struct ccp_crypto_cmd *crypto_cmd)
+{
+	struct ccp_crypto_cpu_queue *cpu_queue;
+	struct ccp_crypto_cmd *active = NULL, *tmp;
+	int cpu, ret;
+
+	cpu = get_cpu();
+	crypto_cmd->cpu = cpu;
+
+	cpu_queue = this_cpu_ptr(req_queue.cpu_queue);
+
+	/* Check if the cmd can/should be queued */
+	if (cpu_queue->cmd_count >= CCP_CRYPTO_MAX_QLEN) {
+		ret = -EBUSY;
+		if (!(crypto_cmd->cmd->flags & CCP_CMD_MAY_BACKLOG))
+			goto e_cpu;
+	}
+
+	/* Look for an entry with the same tfm.  If there is a cmd
+	 * with the same tfm in the list for this cpu then the current
+	 * cmd cannot be submitted to the CCP yet.
+	 */
+	list_for_each_entry(tmp, &cpu_queue->cmds, entry) {
+		if (crypto_cmd->tfm != tmp->tfm)
+			continue;
+		active = tmp;
+		break;
+	}
+
+	ret = -EINPROGRESS;
+	if (!active) {
+		ret = ccp_enqueue_cmd(crypto_cmd->cmd);
+		if (!ccp_crypto_success(ret))
+			goto e_cpu;
+	}
+
+	if (cpu_queue->cmd_count >= CCP_CRYPTO_MAX_QLEN) {
+		ret = -EBUSY;
+		if (cpu_queue->backlog == &cpu_queue->cmds)
+			cpu_queue->backlog = &crypto_cmd->entry;
+	}
+	crypto_cmd->ret = ret;
+
+	cpu_queue->cmd_count++;
+	list_add_tail(&crypto_cmd->entry, &cpu_queue->cmds);
+
+e_cpu:
+	put_cpu();
+
+	return ret;
+}
+
+/**
+ * ccp_crypto_enqueue_request - queue an crypto async request for processing
+ *				by the CCP
+ *
+ * @req: crypto_async_request struct to be processed
+ * @cmd: ccp_cmd struct to be sent to the CCP
+ */
+int ccp_crypto_enqueue_request(struct crypto_async_request *req,
+			       struct ccp_cmd *cmd)
+{
+	struct ccp_crypto_cmd *crypto_cmd;
+	gfp_t gfp;
+	int ret;
+
+	gfp = req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
+
+	crypto_cmd = kzalloc(sizeof(*crypto_cmd), gfp);
+	if (!crypto_cmd)
+		return -ENOMEM;
+
+	/* The tfm pointer must be saved and not referenced from the
+	 * crypto_async_request (req) pointer because it is used after
+	 * completion callback for the request and the req pointer
+	 * might not be valid anymore.
+	 */
+	crypto_cmd->cmd = cmd;
+	crypto_cmd->req = req;
+	crypto_cmd->tfm = req->tfm;
+
+	cmd->callback = ccp_crypto_complete;
+	cmd->data = crypto_cmd;
+
+	if (req->flags & CRYPTO_TFM_REQ_MAY_BACKLOG)
+		cmd->flags |= CCP_CMD_MAY_BACKLOG;
+	else
+		cmd->flags &= ~CCP_CMD_MAY_BACKLOG;
+
+	ret = ccp_crypto_enqueue_cmd(crypto_cmd);
+	if (!ccp_crypto_success(ret))
+		kfree(crypto_cmd);
+
+	return ret;
+}
+
+struct scatterlist *ccp_crypto_sg_table_add(struct sg_table *table,
+					    struct scatterlist *sg_add)
+{
+	struct scatterlist *sg, *sg_last = NULL;
+
+	for (sg = table->sgl; sg; sg = sg_next(sg))
+		if (!sg_page(sg))
+			break;
+	BUG_ON(!sg);
+
+	for (; sg && sg_add; sg = sg_next(sg), sg_add = sg_next(sg_add)) {
+		sg_set_page(sg, sg_page(sg_add), sg_add->length,
+			    sg_add->offset);
+		sg_last = sg;
+	}
+	BUG_ON(sg_add);
+
+	return sg_last;
+}
+
+static int ccp_register_algs(void)
+{
+	int ret;
+
+	ret = ccp_register_aes_algs(&cipher_algs);
+	if (ret)
+		return ret;
+
+	ret = ccp_register_aes_cmac_algs(&hash_algs);
+	if (ret)
+		return ret;
+
+	ret = ccp_register_aes_xts_algs(&cipher_algs);
+	if (ret)
+		return ret;
+
+	ret = ccp_register_sha_algs(&hash_algs);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static void ccp_unregister_algs(void)
+{
+	struct ccp_crypto_ahash_alg *ahash_alg, *ahash_tmp;
+	struct ccp_crypto_ablkcipher_alg *ablk_alg, *ablk_tmp;
+
+	list_for_each_entry_safe(ahash_alg, ahash_tmp, &hash_algs, entry) {
+		crypto_unregister_ahash(&ahash_alg->alg);
+		list_del(&ahash_alg->entry);
+		kfree(ahash_alg);
+	}
+
+	list_for_each_entry_safe(ablk_alg, ablk_tmp, &cipher_algs, entry) {
+		crypto_unregister_alg(&ablk_alg->alg);
+		list_del(&ablk_alg->entry);
+		kfree(ablk_alg);
+	}
+}
+
+static int ccp_init_queues(void)
+{
+	struct ccp_crypto_cpu_queue *cpu_queue;
+	int cpu;
+
+	req_queue.cpu_queue = alloc_percpu(struct ccp_crypto_cpu_queue);
+	if (!req_queue.cpu_queue)
+		return -ENOMEM;
+
+	for_each_possible_cpu(cpu) {
+		cpu_queue = per_cpu_ptr(req_queue.cpu_queue, cpu);
+		INIT_LIST_HEAD(&cpu_queue->cmds);
+		cpu_queue->backlog = &cpu_queue->cmds;
+		cpu_queue->cmd_count = 0;
+	}
+
+	return 0;
+}
+
+static void ccp_fini_queue(void)
+{
+	struct ccp_crypto_cpu_queue *cpu_queue;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		cpu_queue = per_cpu_ptr(req_queue.cpu_queue, cpu);
+		BUG_ON(!list_empty(&cpu_queue->cmds));
+	}
+	free_percpu(req_queue.cpu_queue);
+}
+
+static int ccp_crypto_init(void)
+{
+	int ret;
+
+	ret = ccp_init_queues();
+	if (ret)
+		return ret;
+
+	ret = ccp_register_algs();
+	if (ret) {
+		ccp_unregister_algs();
+		ccp_fini_queue();
+	}
+
+	return ret;
+}
+
+static void ccp_crypto_exit(void)
+{
+	ccp_unregister_algs();
+	ccp_fini_queue();
+}
+
+module_init(ccp_crypto_init);
+module_exit(ccp_crypto_exit);
diff --git a/drivers/crypto/ccp/ccp-crypto.h b/drivers/crypto/ccp/ccp-crypto.h
new file mode 100644
index 0000000..45f17c3
--- /dev/null
+++ b/drivers/crypto/ccp/ccp-crypto.h
@@ -0,0 +1,191 @@
+/*
+ * AMD Cryptographic Coprocessor (CCP) crypto API support
+ *
+ * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ *
+ * Author: Tom Lendacky <thomas.lendacky@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __CCP_CRYPTO_H__
+#define __CCP_CRYPTO_H__
+
+
+#include <linux/list.h>
+#include <linux/wait.h>
+#include <linux/pci.h>
+#include <linux/ccp.h>
+#include <linux/crypto.h>
+#include <crypto/algapi.h>
+#include <crypto/aes.h>
+#include <crypto/ctr.h>
+#include <crypto/hash.h>
+#include <crypto/sha.h>
+
+
+#define CCP_CRA_PRIORITY	300
+
+struct ccp_crypto_ablkcipher_alg {
+	struct list_head entry;
+
+	u32 mode;
+
+	struct crypto_alg alg;
+};
+
+struct ccp_crypto_ahash_alg {
+	struct list_head entry;
+
+	const u32 *init;
+	u32 type;
+	u32 mode;
+
+	/* Child algorithm used for HMAC, CMAC, etc */
+	char child_alg[CRYPTO_MAX_ALG_NAME];
+
+	struct ahash_alg alg;
+};
+
+static inline struct ccp_crypto_ablkcipher_alg *
+	ccp_crypto_ablkcipher_alg(struct crypto_tfm *tfm)
+{
+	struct crypto_alg *alg = tfm->__crt_alg;
+
+	return container_of(alg, struct ccp_crypto_ablkcipher_alg, alg);
+}
+
+static inline struct ccp_crypto_ahash_alg *
+	ccp_crypto_ahash_alg(struct crypto_tfm *tfm)
+{
+	struct crypto_alg *alg = tfm->__crt_alg;
+	struct ahash_alg *ahash_alg;
+
+	ahash_alg = container_of(alg, struct ahash_alg, halg.base);
+
+	return container_of(ahash_alg, struct ccp_crypto_ahash_alg, alg);
+}
+
+
+/***** AES related defines *****/
+struct ccp_aes_ctx {
+	/* Fallback cipher for XTS with unsupported unit sizes */
+	struct crypto_ablkcipher *tfm_ablkcipher;
+
+	/* Cipher used to generate CMAC K1/K2 keys */
+	struct crypto_cipher *tfm_cipher;
+
+	enum ccp_engine engine;
+	enum ccp_aes_type type;
+	enum ccp_aes_mode mode;
+
+	struct scatterlist key_sg;
+	unsigned int key_len;
+	u8 key[AES_MAX_KEY_SIZE];
+
+	u8 nonce[CTR_RFC3686_NONCE_SIZE];
+
+	/* CMAC key structures */
+	struct scatterlist k1_sg;
+	struct scatterlist k2_sg;
+	unsigned int kn_len;
+	u8 k1[AES_BLOCK_SIZE];
+	u8 k2[AES_BLOCK_SIZE];
+};
+
+struct ccp_aes_req_ctx {
+	struct scatterlist iv_sg;
+	u8 iv[AES_BLOCK_SIZE];
+
+	/* Fields used for RFC3686 requests */
+	u8 *rfc3686_info;
+	u8 rfc3686_iv[AES_BLOCK_SIZE];
+
+	struct ccp_cmd cmd;
+};
+
+struct ccp_aes_cmac_req_ctx {
+	unsigned int null_msg;
+	unsigned int final;
+
+	unsigned int hash_cnt;
+	unsigned int hash_rem;
+
+	struct sg_table data_sg;
+
+	struct scatterlist iv_sg;
+	u8 iv[AES_BLOCK_SIZE];
+
+	struct scatterlist buf_sg;
+	unsigned int buf_count;
+	u8 buf[AES_BLOCK_SIZE];
+
+	struct scatterlist pad_sg;
+	unsigned int pad_count;
+	u8 pad[AES_BLOCK_SIZE];
+
+	struct ccp_cmd cmd;
+};
+
+/***** SHA related defines *****/
+#define MAX_SHA_CONTEXT_SIZE	SHA256_DIGEST_SIZE
+#define MAX_SHA_BLOCK_SIZE	SHA256_BLOCK_SIZE
+
+struct ccp_sha_ctx {
+	unsigned int key_len;
+	u8 key[MAX_SHA_BLOCK_SIZE];
+	u8 ipad[MAX_SHA_BLOCK_SIZE];
+	u8 opad[MAX_SHA_BLOCK_SIZE];
+	struct crypto_ahash *hmac_tfm;
+};
+
+struct ccp_sha_req_ctx {
+	enum ccp_sha_type type;
+
+	u64 msg_bits;
+
+	unsigned int first;
+	unsigned int final;
+
+	unsigned int hash_cnt;
+	unsigned int hash_rem;
+
+	struct sg_table data_sg;
+
+	struct scatterlist ctx_sg;
+	u8 ctx[MAX_SHA_CONTEXT_SIZE];
+
+	struct scatterlist buf_sg;
+	unsigned int buf_count;
+	u8 buf[MAX_SHA_BLOCK_SIZE];
+
+	/* HMAC support field */
+	struct scatterlist pad_sg;
+
+	/* CCP driver command */
+	struct ccp_cmd cmd;
+};
+
+/***** Common Context Structure *****/
+struct ccp_ctx {
+	int (*complete)(struct crypto_async_request *req, int ret);
+
+	union {
+		struct ccp_aes_ctx aes;
+		struct ccp_sha_ctx sha;
+	} u;
+};
+
+int ccp_crypto_enqueue_request(struct crypto_async_request *req,
+			       struct ccp_cmd *cmd);
+struct scatterlist *ccp_crypto_sg_table_add(struct sg_table *table,
+					    struct scatterlist *sg_add);
+
+int ccp_register_aes_algs(struct list_head *head);
+int ccp_register_aes_cmac_algs(struct list_head *head);
+int ccp_register_aes_xts_algs(struct list_head *head);
+int ccp_register_sha_algs(struct list_head *head);
+
+#endif


