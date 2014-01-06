Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbaAFTeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 14:34:13 -0500
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:6087
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755682AbaAFTeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 14:34:09 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(z579ehzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336h1155h)
X-WSS-ID: 0MYZVNW-08-963-02
X-M-MSG: 
Subject: [PATCH 1/6] crypto: ccp - Apply appropriate gfp_t type to memory
 allocations
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Mon, 6 Jan 2014 13:33:59 -0600
Message-ID: <20140106193359.26918.68911.stgit@tlendack-t1.amdoffice.net>
In-Reply-To: <20140106193353.26918.5804.stgit@tlendack-t1.amdoffice.net>
References: <20140106193353.26918.5804.stgit@tlendack-t1.amdoffice.net>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix some memory allocations to use the appropriate gfp_t type based
on the CRYPTO_TFM_REQ_MAY_SLEEP flag.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |    5 ++++-
 drivers/crypto/ccp/ccp-crypto-sha.c      |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
index 64dd35e..398832c 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
@@ -61,6 +61,7 @@ static int ccp_do_cmac_update(struct ahash_request *req, unsigned int nbytes,
 	unsigned int block_size =
 		crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
 	unsigned int len, need_pad, sg_count;
+	gfp_t gfp;
 	int ret;
 
 	if (!ctx->u.aes.key_len)
@@ -99,7 +100,9 @@ static int ccp_do_cmac_update(struct ahash_request *req, unsigned int nbytes,
 	 * possible data pieces (buffer, input data, padding)
 	 */
 	sg_count = (nbytes) ? sg_nents(req->src) + 2 : 2;
-	ret = sg_alloc_table(&rctx->data_sg, sg_count, GFP_KERNEL);
+	gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+		GFP_KERNEL : GFP_ATOMIC;
+	ret = sg_alloc_table(&rctx->data_sg, sg_count, gfp);
 	if (ret)
 		return ret;
 
diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index b0881df..0571940 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -128,6 +128,7 @@ static int ccp_do_sha_update(struct ahash_request *req, unsigned int nbytes,
 	unsigned int block_size =
 		crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
 	unsigned int len, sg_count;
+	gfp_t gfp;
 	int ret;
 
 	if (!final && ((nbytes + rctx->buf_count) <= block_size)) {
@@ -156,7 +157,9 @@ static int ccp_do_sha_update(struct ahash_request *req, unsigned int nbytes,
 	 * possible data pieces (hmac ipad, buffer, input data)
 	 */
 	sg_count = (nbytes) ? sg_nents(req->src) + 2 : 2;
-	ret = sg_alloc_table(&rctx->data_sg, sg_count, GFP_KERNEL);
+	gfp = req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP ?
+		GFP_KERNEL : GFP_ATOMIC;
+	ret = sg_alloc_table(&rctx->data_sg, sg_count, gfp);
 	if (ret)
 		return ret;
 


