Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaBXOm0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:42:26 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:49148
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752687AbaBXOmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:42:22 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh1de097hz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
X-WSS-ID: 0N1I8UC-08-O7H-02
X-M-MSG: 
Subject: [PATCH 3/3] crypto: ccp - Account for CCP backlog processing
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Mon, 24 Feb 2014 08:42:14 -0600
Message-ID: <20140224144214.16181.69265.stgit@tlendack-t1.amdoffice.net>
In-Reply-To: <20140224144156.16181.81272.stgit@tlendack-t1.amdoffice.net>
References: <20140224144156.16181.81272.stgit@tlendack-t1.amdoffice.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the crypto layer is able to queue up a command for processing
by the CCP on the initial call to ccp_crypto_enqueue_request and
the CCP returns -EBUSY, then if the backlog flag is not set the
command needs to be freed and not added to the active command list.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-main.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-main.c b/drivers/crypto/ccp/ccp-crypto-main.c
index 7d98635..20dc848 100644
--- a/drivers/crypto/ccp/ccp-crypto-main.c
+++ b/drivers/crypto/ccp/ccp-crypto-main.c
@@ -205,6 +205,7 @@ static int ccp_crypto_enqueue_cmd(struct ccp_crypto_cmd *crypto_cmd)
 {
 	struct ccp_crypto_cmd *active = NULL, *tmp;
 	unsigned long flags;
+	bool free_cmd = true;
 	int ret;
 
 	spin_lock_irqsave(&req_queue_lock, flags);
@@ -231,7 +232,10 @@ static int ccp_crypto_enqueue_cmd(struct ccp_crypto_cmd *crypto_cmd)
 	if (!active) {
 		ret = ccp_enqueue_cmd(crypto_cmd->cmd);
 		if (!ccp_crypto_success(ret))
-			goto e_lock;
+			goto e_lock;	/* Error, don't queue it */
+		if ((ret == -EBUSY) &&
+		    !(crypto_cmd->cmd->flags & CCP_CMD_MAY_BACKLOG))
+			goto e_lock;	/* Not backlogging, don't queue it */
 	}
 
 	if (req_queue.cmd_count >= CCP_CRYPTO_MAX_QLEN) {
@@ -244,9 +248,14 @@ static int ccp_crypto_enqueue_cmd(struct ccp_crypto_cmd *crypto_cmd)
 	req_queue.cmd_count++;
 	list_add_tail(&crypto_cmd->entry, &req_queue.cmds);
 
+	free_cmd = false;
+
 e_lock:
 	spin_unlock_irqrestore(&req_queue_lock, flags);
 
+	if (free_cmd)
+		kfree(crypto_cmd);
+
 	return ret;
 }
 
@@ -262,7 +271,6 @@ int ccp_crypto_enqueue_request(struct crypto_async_request *req,
 {
 	struct ccp_crypto_cmd *crypto_cmd;
 	gfp_t gfp;
-	int ret;
 
 	gfp = req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL : GFP_ATOMIC;
 
@@ -287,11 +295,7 @@ int ccp_crypto_enqueue_request(struct crypto_async_request *req,
 	else
 		cmd->flags &= ~CCP_CMD_MAY_BACKLOG;
 
-	ret = ccp_crypto_enqueue_cmd(crypto_cmd);
-	if (!ccp_crypto_success(ret))
-		kfree(crypto_cmd);
-
-	return ret;
+	return ccp_crypto_enqueue_cmd(crypto_cmd);
 }
 
 struct scatterlist *ccp_crypto_sg_table_add(struct sg_table *table,


