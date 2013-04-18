Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967538Ab3DRJiB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:38:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40057 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578Ab3DRJRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:17:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 13/72] crypto: gcm - fix assumption that assoc has one segment
Date: Thu, 18 Apr 2013 10:15:58 +0100
Message-Id: <1366276617-3553-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jussi Kivilinna <jussi.kivilinna@iki.fi>

commit d3dde52209ab571e4e2ec26c66f85ad1355f7475 upstream.

rfc4543(gcm(*)) code for GMAC assumes that assoc scatterlist always contains
only one segment and only makes use of this first segment. However ipsec passes
assoc with three segments when using 'extended sequence number' thus in this
case rfc4543(gcm(*)) fails to function correctly. Patch fixes this issue.

Reported-by: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
Tested-by: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 crypto/gcm.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 1a25263..b97b186 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -44,6 +44,7 @@ struct crypto_rfc4543_ctx {
 
 struct crypto_rfc4543_req_ctx {
 	u8 auth_tag[16];
+	u8 assocbuf[32];
 	struct scatterlist cipher[1];
 	struct scatterlist payload[2];
 	struct scatterlist assoc[2];
@@ -1142,9 +1143,19 @@ static struct aead_request *crypto_rfc4543_crypt(struct aead_request *req,
 	scatterwalk_crypto_chain(payload, dst, vdst == req->iv + 8, 2);
 	assoclen += 8 + req->cryptlen - (enc ? 0 : authsize);
 
-	sg_init_table(assoc, 2);
-	sg_set_page(assoc, sg_page(req->assoc), req->assoc->length,
-		    req->assoc->offset);
+	if (req->assoc->length == req->assoclen) {
+		sg_init_table(assoc, 2);
+		sg_set_page(assoc, sg_page(req->assoc), req->assoc->length,
+			    req->assoc->offset);
+	} else {
+		BUG_ON(req->assoclen > sizeof(rctx->assocbuf));
+
+		scatterwalk_map_and_copy(rctx->assocbuf, req->assoc, 0,
+					 req->assoclen, 0);
+
+		sg_init_table(assoc, 2);
+		sg_set_buf(assoc, rctx->assocbuf, req->assoclen);
+	}
 	scatterwalk_crypto_chain(assoc, payload, 0, 2);
 
 	aead_request_set_tfm(subreq, ctx->child);
-- 
1.8.1.2

