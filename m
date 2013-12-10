Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab3LJQjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 11:39:11 -0500
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:35776
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754980Ab3LJQiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 11:38:51 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336h1155h)
X-WSS-ID: 0MXLNFE-07-EIV-02
X-M-MSG: 
Subject: [PATCH 3/3] crypto: ccp - Remove user triggerable pr_err calls
To: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <herbert@gondor.apana.org.au>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Tue, 10 Dec 2013 10:38:44 -0600
Message-ID: <20131210163844.24304.39872.stgit@tlendack-t1.amdoffice.net>
In-Reply-To: <20131210163827.24304.36256.stgit@tlendack-t1.amdoffice.net>
References: <20131210163827.24304.36256.stgit@tlendack-t1.amdoffice.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the pr_err calls that are issued during parameter
checking in some AES operations. This will eliminate the
possibility of filling up syslog through these paths.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |    4 +---
 drivers/crypto/ccp/ccp-crypto-aes-xts.c  |   12 +++---------
 drivers/crypto/ccp/ccp-crypto-aes.c      |   12 +++---------
 3 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
index 5b9cd98..64dd35e 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
@@ -63,10 +63,8 @@ static int ccp_do_cmac_update(struct ahash_request *req, unsigned int nbytes,
 	unsigned int len, need_pad, sg_count;
 	int ret;
 
-	if (!ctx->u.aes.key_len) {
-		pr_err("AES key not set\n");
+	if (!ctx->u.aes.key_len)
 		return -EINVAL;
-	}
 
 	if (nbytes)
 		rctx->null_msg = 0;
diff --git a/drivers/crypto/ccp/ccp-crypto-aes-xts.c b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
index d100b48..0237ab5 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-xts.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-xts.c
@@ -125,20 +125,14 @@ static int ccp_aes_xts_crypt(struct ablkcipher_request *req,
 	unsigned int unit;
 	int ret;
 
-	if (!ctx->u.aes.key_len) {
-		pr_err("AES key not set\n");
+	if (!ctx->u.aes.key_len)
 		return -EINVAL;
-	}
 
-	if (req->nbytes & (AES_BLOCK_SIZE - 1)) {
-		pr_err("AES request size is not a multiple of the block size\n");
+	if (req->nbytes & (AES_BLOCK_SIZE - 1))
 		return -EINVAL;
-	}
 
-	if (!req->info) {
-		pr_err("AES IV not supplied");
+	if (!req->info)
 		return -EINVAL;
-	}
 
 	for (unit = 0; unit < ARRAY_SIZE(unit_size_map); unit++)
 		if (!(req->nbytes & (unit_size_map[unit].size - 1)))
diff --git a/drivers/crypto/ccp/ccp-crypto-aes.c b/drivers/crypto/ccp/ccp-crypto-aes.c
index c0befdb..e46490d 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes.c
@@ -76,24 +76,18 @@ static int ccp_aes_crypt(struct ablkcipher_request *req, bool encrypt)
 	unsigned int iv_len = 0;
 	int ret;
 
-	if (!ctx->u.aes.key_len) {
-		pr_err("AES key not set\n");
+	if (!ctx->u.aes.key_len)
 		return -EINVAL;
-	}
 
 	if (((ctx->u.aes.mode == CCP_AES_MODE_ECB) ||
 	     (ctx->u.aes.mode == CCP_AES_MODE_CBC) ||
 	     (ctx->u.aes.mode == CCP_AES_MODE_CFB)) &&
-	    (req->nbytes & (AES_BLOCK_SIZE - 1))) {
-		pr_err("AES request size is not a multiple of the block size\n");
+	    (req->nbytes & (AES_BLOCK_SIZE - 1)))
 		return -EINVAL;
-	}
 
 	if (ctx->u.aes.mode != CCP_AES_MODE_ECB) {
-		if (!req->info) {
-			pr_err("AES IV not supplied");
+		if (!req->info)
 			return -EINVAL;
-		}
 
 		memcpy(rctx->iv, req->info, AES_BLOCK_SIZE);
 		iv_sg = &rctx->iv_sg;


