Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaAXWSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 17:18:24 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:11463
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752205AbaAXWSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 17:18:20 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(z579ehzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh1de097hz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h1155h)
X-WSS-ID: 0MZXFA9-07-4F4-02
X-M-MSG: 
Subject: [PATCH 3/4] crypto: ccp - Use a single queue for proper ordering of
 tfm requests
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Fri, 24 Jan 2014 16:18:08 -0600
Message-ID: <20140124221807.1894.85352.stgit@tlendack-t1.amdoffice.net>
In-Reply-To: <20140124221750.1894.48517.stgit@tlendack-t1.amdoffice.net>
References: <20140124221750.1894.48517.stgit@tlendack-t1.amdoffice.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move to a single queue to serialize requests within a tfm. When
testing using IPSec with a large number of network connections
the per cpu tfm queuing logic was not working properly.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-main.c |  164 ++++++++++------------------------
 1 file changed, 48 insertions(+), 116 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
index b3f22b0..010fded 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -38,23 +38,20 @@ MODULE_PARM_DESC(sha_disable, "Disable use of SHA - any non-zero value");
 static LIST_HEAD(hash_algs);
 static LIST_HEAD(cipher_algs);
 
-/* For any tfm, requests for that tfm on the same CPU must be returned
- * in the order received.  With multiple queues available, the CCP can
- * process more than one cmd at a time.  Therefore we must maintain
- * a cmd list to insure the proper ordering of requests on a given tfm/cpu
- * combination.
+/* For any tfm, requests for that tfm must be returned on the order
+ * received.  With multiple queues available, the CCP can process more
+ * than one cmd at a time.  Therefore we must maintain a cmd list to insure
+ * the proper ordering of requests on a given tfm.
  */
-struct ccp_crypto_cpu_queue {
+struct ccp_crypto_queue {
 	struct list_head cmds;
 	struct list_head *backlog;
 	unsigned int cmd_count;
 };
-#define CCP_CRYPTO_MAX_QLEN	50
+#define CCP_CRYPTO_MAX_QLEN	100
 
-struct ccp_crypto_percpu_queue {
-	struct ccp_crypto_cpu_queue __percpu *cpu_queue;
-};
-static struct ccp_crypto_percpu_queue req_queue;
+static struct ccp_crypto_queue req_queue;
+static spinlock_t req_queue_lock;
 
 struct ccp_crypto_cmd {
 	struct list_head entry;
@@ -71,8 +68,6 @@ struct ccp_crypto_cmd {
 
 	/* Used for held command processing to determine state */
 	int ret;
-
-	int cpu;
 };
 
 struct ccp_crypto_cpu {
@@ -91,25 +86,21 @@ static inline bool ccp_crypto_success(int err)
 	return true;
 }
 
-/*
- * ccp_crypto_cmd_complete must be called while running on the appropriate
- * cpu and the caller must have done a get_cpu to disable preemption
- */
 static struct ccp_crypto_cmd *ccp_crypto_cmd_complete(
 	struct ccp_crypto_cmd *crypto_cmd, struct ccp_crypto_cmd **backlog)
 {
-	struct ccp_crypto_cpu_queue *cpu_queue;
 	struct ccp_crypto_cmd *held = NULL, *tmp;
+	unsigned long flags;
 
 	*backlog = NULL;
 
-	cpu_queue = this_cpu_ptr(req_queue.cpu_queue);
+	spin_lock_irqsave(&req_queue_lock, flags);
 
 	/* Held cmds will be after the current cmd in the queue so start
 	 * searching for a cmd with a matching tfm for submission.
 	 */
 	tmp = crypto_cmd;
-	list_for_each_entry_continue(tmp, &cpu_queue->cmds, entry) {
+	list_for_each_entry_continue(tmp, &req_queue.cmds, entry) {
 		if (crypto_cmd->tfm != tmp->tfm)
 			continue;
 		held = tmp;
@@ -120,47 +111,45 @@ static struct ccp_crypto_cmd *ccp_crypto_cmd_complete(
 	 *   Because cmds can be executed from any point in the cmd list
 	 *   special precautions have to be taken when handling the backlog.
 	 */
-	if (cpu_queue->backlog != &cpu_queue->cmds) {
+	if (req_queue.backlog != &req_queue.cmds) {
 		/* Skip over this cmd if it is the next backlog cmd */
-		if (cpu_queue->backlog == &crypto_cmd->entry)
-			cpu_queue->backlog = crypto_cmd->entry.next;
+		if (req_queue.backlog == &crypto_cmd->entry)
+			req_queue.backlog = crypto_cmd->entry.next;
 
-		*backlog = container_of(cpu_queue->backlog,
+		*backlog = container_of(req_queue.backlog,
 					struct ccp_crypto_cmd, entry);
-		cpu_queue->backlog = cpu_queue->backlog->next;
+		req_queue.backlog = req_queue.backlog->next;
 
 		/* Skip over this cmd if it is now the next backlog cmd */
-		if (cpu_queue->backlog == &crypto_cmd->entry)
-			cpu_queue->backlog = crypto_cmd->entry.next;
+		if (req_queue.backlog == &crypto_cmd->entry)
+			req_queue.backlog = crypto_cmd->entry.next;
 	}
 
 	/* Remove the cmd entry from the list of cmds */
-	cpu_queue->cmd_count--;
+	req_queue.cmd_count--;
 	list_del(&crypto_cmd->entry);
 
+	spin_unlock_irqrestore(&req_queue_lock, flags);
+
 	return held;
 }
 
-static void ccp_crypto_complete_on_cpu(struct work_struct *work)
+static void ccp_crypto_complete(void *data, int err)
 {
-	struct ccp_crypto_cpu *cpu_work =
-		container_of(work, struct ccp_crypto_cpu, work);
-	struct ccp_crypto_cmd *crypto_cmd = cpu_work->crypto_cmd;
+	struct ccp_crypto_cmd *crypto_cmd = data;
 	struct ccp_crypto_cmd *held, *next, *backlog;
 	struct crypto_async_request *req = crypto_cmd->req;
 	struct ccp_ctx *ctx = crypto_tfm_ctx(req->tfm);
-	int cpu, ret;
-
-	cpu = get_cpu();
+	int ret;
 
-	if (cpu_work->err == -EINPROGRESS) {
+	if (err == -EINPROGRESS) {
 		/* Only propogate the -EINPROGRESS if necessary */
 		if (crypto_cmd->ret == -EBUSY) {
 			crypto_cmd->ret = -EINPROGRESS;
 			req->complete(req, -EINPROGRESS);
 		}
 
-		goto e_cpu;
+		return;
 	}
 
 	/* Operation has completed - update the queue before invoking
@@ -178,7 +167,7 @@ static void ccp_crypto_complete_on_cpu(struct work_struct *work)
 		req->complete(req, -EINPROGRESS);
 
 	/* Completion callbacks */
-	ret = cpu_work->err;
+	ret = err;
 	if (ctx->complete)
 		ret = ctx->complete(req, ret);
 	req->complete(req, ret);
@@ -203,52 +192,28 @@ static void ccp_crypto_complete_on_cpu(struct work_struct *work)
 	}
 
 	kfree(crypto_cmd);
-
-e_cpu:
-	put_cpu();
-
-	complete(&cpu_work->completion);
-}
-
-static void ccp_crypto_complete(void *data, int err)
-{
-	struct ccp_crypto_cmd *crypto_cmd = data;
-	struct ccp_crypto_cpu cpu_work;
-
-	INIT_WORK(&cpu_work.work, ccp_crypto_complete_on_cpu);
-	init_completion(&cpu_work.completion);
-	cpu_work.crypto_cmd = crypto_cmd;
-	cpu_work.err = err;
-
-	schedule_work_on(crypto_cmd->cpu, &cpu_work.work);
-
-	/* Keep the completion call synchronous */
-	wait_for_completion(&cpu_work.completion);
 }
 
 static int ccp_crypto_enqueue_cmd(struct ccp_crypto_cmd *crypto_cmd)
 {
-	struct ccp_crypto_cpu_queue *cpu_queue;
 	struct ccp_crypto_cmd *active = NULL, *tmp;
-	int cpu, ret;
-
-	cpu = get_cpu();
-	crypto_cmd->cpu = cpu;
+	unsigned long flags;
+	int ret;
 
-	cpu_queue = this_cpu_ptr(req_queue.cpu_queue);
+	spin_lock_irqsave(&req_queue_lock, flags);
 
 	/* Check if the cmd can/should be queued */
-	if (cpu_queue->cmd_count >= CCP_CRYPTO_MAX_QLEN) {
+	if (req_queue.cmd_count >= CCP_CRYPTO_MAX_QLEN) {
 		ret = -EBUSY;
 		if (!(crypto_cmd->cmd->flags & CCP_CMD_MAY_BACKLOG))
-			goto e_cpu;
+			goto e_lock;
 	}
 
 	/* Look for an entry with the same tfm.  If there is a cmd
-	 * with the same tfm in the list for this cpu then the current
-	 * cmd cannot be submitted to the CCP yet.
+	 * with the same tfm in the list then the current cmd cannot
+	 * be submitted to the CCP yet.
 	 */
-	list_for_each_entry(tmp, &cpu_queue->cmds, entry) {
+	list_for_each_entry(tmp, &req_queue.cmds, entry) {
 		if (crypto_cmd->tfm != tmp->tfm)
 			continue;
 		active = tmp;
@@ -259,21 +224,21 @@ static int ccp_crypto_enqueue_cmd(struct ccp_crypto_cmd *crypto_cmd)
 	if (!active) {
 		ret = ccp_enqueue_cmd(crypto_cmd->cmd);
 		if (!ccp_crypto_success(ret))
-			goto e_cpu;
+			goto e_lock;
 	}
 
-	if (cpu_queue->cmd_count >= CCP_CRYPTO_MAX_QLEN) {
+	if (req_queue.cmd_count >= CCP_CRYPTO_MAX_QLEN) {
 		ret = -EBUSY;
-		if (cpu_queue->backlog == &cpu_queue->cmds)
-			cpu_queue->backlog = &crypto_cmd->entry;
+		if (req_queue.backlog == &req_queue.cmds)
+			req_queue.backlog = &crypto_cmd->entry;
 	}
 	crypto_cmd->ret = ret;
 
-	cpu_queue->cmd_count++;
-	list_add_tail(&crypto_cmd->entry, &cpu_queue->cmds);
+	req_queue.cmd_count++;
+	list_add_tail(&crypto_cmd->entry, &req_queue.cmds);
 
-e_cpu:
-	put_cpu();
+e_lock:
+	spin_unlock_irqrestore(&req_queue_lock, flags);
 
 	return ret;
 }
@@ -387,50 +352,18 @@ static void ccp_unregister_algs(void)
 	}
 }
 
-static int ccp_init_queues(void)
-{
-	struct ccp_crypto_cpu_queue *cpu_queue;
-	int cpu;
-
-	req_queue.cpu_queue = alloc_percpu(struct ccp_crypto_cpu_queue);
-	if (!req_queue.cpu_queue)
-		return -ENOMEM;
-
-	for_each_possible_cpu(cpu) {
-		cpu_queue = per_cpu_ptr(req_queue.cpu_queue, cpu);
-		INIT_LIST_HEAD(&cpu_queue->cmds);
-		cpu_queue->backlog = &cpu_queue->cmds;
-		cpu_queue->cmd_count = 0;
-	}
-
-	return 0;
-}
-
-static void ccp_fini_queue(void)
-{
-	struct ccp_crypto_cpu_queue *cpu_queue;
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		cpu_queue = per_cpu_ptr(req_queue.cpu_queue, cpu);
-		BUG_ON(!list_empty(&cpu_queue->cmds));
-	}
-	free_percpu(req_queue.cpu_queue);
-}
-
 static int ccp_crypto_init(void)
 {
 	int ret;
 
-	ret = ccp_init_queues();
-	if (ret)
-		return ret;
+	spin_lock_init(&req_queue_lock);
+	INIT_LIST_HEAD(&req_queue.cmds);
+	req_queue.backlog = &req_queue.cmds;
+	req_queue.cmd_count = 0;
 
 	ret = ccp_register_algs();
-	if (ret) {
+	if (ret)
 		ccp_unregister_algs();
-		ccp_fini_queue();
-	}
 
 	return ret;
 }
@@ -438,7 +371,6 @@ static int ccp_crypto_init(void)
 static void ccp_crypto_exit(void)
 {
 	ccp_unregister_algs();
-	ccp_fini_queue();
 }
 
 module_init(ccp_crypto_init);


