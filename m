Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757670Ab3EGEGK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:06:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4049 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760174Ab3EGD6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:52 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=6al00s3m2sIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=5TYjbGW-CAkA:10 a=AxE2Au23AAAA:8 a=VwQbUJbxAAAA:8 a=FNyBlpCuAAAA:8 a=07RQwra97pehUm3UO-YA:9 a=jgOP9pWWim0A:10 a=jeBq3FmKZ4MA:10 a=n0CUu2D80XzH9k-B:21 a=l7MiMG2MFag3m6R9:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035845.577192493@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [028/126] crypto: gcm - fix assumption that assoc has one segment
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0028-crypto-gcm-fix-assumption-that-assoc-has-one-segment.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jussi Kivilinna <jussi.kivilinna@iki.fi>

[ Upstream commit d3dde52209ab571e4e2ec26c66f85ad1355f7475 ]

rfc4543(gcm(*)) code for GMAC assumes that assoc scatterlist always contains
only one segment and only makes use of this first segment. However ipsec passes
assoc with three segments when using 'extended sequence number' thus in this
case rfc4543(gcm(*)) fails to function correctly. Patch fixes this issue.

Reported-by: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
Tested-by: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 crypto/gcm.c |   17 ++++++++++++++---
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
1.7.10.4


