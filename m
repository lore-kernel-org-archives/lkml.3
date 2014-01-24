Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaAXWSb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 17:18:31 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:51542
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753317AbaAXWSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 17:18:24 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh1de097hz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h1155h)
X-WSS-ID: 0MZXFAE-08-485-02
X-M-MSG: 
Subject: [PATCH 4/4] crypto: ccp - Perform completion callbacks using a tasklet
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Fri, 24 Jan 2014 16:18:14 -0600
Message-ID: <20140124221814.1894.4001.stgit@tlendack-t1.amdoffice.net>
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

Change from scheduling work to scheduling a tasklet to perform
the callback operations.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-dev.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index c3bc212..2c78161 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -30,6 +30,11 @@ MODULE_LICENSE("GPL");
 MODULE_VERSION("1.0.0");
 MODULE_DESCRIPTION("AMD Cryptographic Coprocessor driver");
 
+struct ccp_tasklet_data {
+	struct completion completion;
+	struct ccp_cmd *cmd;
+};
+
 
 static struct ccp_device *ccp_dev;
 static inline struct ccp_device *ccp_get_device(void)
@@ -192,17 +197,23 @@ static struct ccp_cmd *ccp_dequeue_cmd(struct ccp_cmd_queue *cmd_q)
 	return cmd;
 }
 
-static void ccp_do_cmd_complete(struct work_struct *work)
+static void ccp_do_cmd_complete(unsigned long data)
 {
-	struct ccp_cmd *cmd = container_of(work, struct ccp_cmd, work);
+	struct ccp_tasklet_data *tdata = (struct ccp_tasklet_data *)data;
+	struct ccp_cmd *cmd = tdata->cmd;
 
 	cmd->callback(cmd->data, cmd->ret);
+	complete(&tdata->completion);
 }
 
 static int ccp_cmd_queue_thread(void *data)
 {
 	struct ccp_cmd_queue *cmd_q = (struct ccp_cmd_queue *)data;
 	struct ccp_cmd *cmd;
+	struct ccp_tasklet_data tdata;
+	struct tasklet_struct tasklet;
+
+	tasklet_init(&tasklet, ccp_do_cmd_complete, (unsigned long)&tdata);
 
 	set_current_state(TASK_INTERRUPTIBLE);
 	while (!kthread_should_stop()) {
@@ -220,8 +231,10 @@ static int ccp_cmd_queue_thread(void *data)
 		cmd->ret = ccp_run_cmd(cmd_q, cmd);
 
 		/* Schedule the completion callback */
-		INIT_WORK(&cmd->work, ccp_do_cmd_complete);
-		schedule_work(&cmd->work);
+		tdata.cmd = cmd;
+		init_completion(&tdata.completion);
+		tasklet_schedule(&tasklet);
+		wait_for_completion(&tdata.completion);
 	}
 
 	__set_current_state(TASK_RUNNING);


