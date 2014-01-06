Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbaAFTem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 14:34:42 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:31078
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756168AbaAFTee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 14:34:34 -0500
X-Forefront-Antispam-Report: CIP:165.204.84.222;KIP:(null);UIP:(null);IPV:NLI;H:atltwp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah2222h224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h22d0h2336h1155h)
X-WSS-ID: 0MYZVOJ-08-96N-02
X-M-MSG: 
Subject: [PATCH 5/6] crypto: ccp - Cleanup hash invocation calls
To: <linux-crypto@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
From: Tom Lendacky <thomas.lendacky@amd.com>
CC: <linux-kernel@vger.kernel.org>
Date: Mon, 6 Jan 2014 13:34:23 -0600
Message-ID: <20140106193423.26918.55048.stgit@tlendack-t1.amdoffice.net>
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

Cleanup the ahash digest invocations to check the init
return code and make use of the finup routine.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes-cmac.c |    2 +-
 drivers/crypto/ccp/ccp-crypto-sha.c      |    8 ++++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
index a52b97a..8e162ad 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-cmac.c
@@ -198,7 +198,7 @@ static int ccp_aes_cmac_digest(struct ahash_request *req)
 	if (ret)
 		return ret;
 
-	return ccp_do_cmac_update(req, req->nbytes, 1);
+	return ccp_aes_cmac_finup(req);
 }
 
 static int ccp_aes_cmac_setkey(struct crypto_ahash *tfm, const u8 *key,
diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index d30f6c8..3867290 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -248,9 +248,13 @@ static int ccp_sha_finup(struct ahash_request *req)
 
 static int ccp_sha_digest(struct ahash_request *req)
 {
-	ccp_sha_init(req);
+	int ret;
 
-	return ccp_do_sha_update(req, req->nbytes, 1);
+	ret = ccp_sha_init(req);
+	if (ret)
+		return ret;
+
+	return ccp_sha_finup(req);
 }
 
 static int ccp_sha_setkey(struct crypto_ahash *tfm, const u8 *key,


