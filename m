Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937499Ab3DJW7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:59:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937469Ab3DJWuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:50:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [ 21/29] crypto: gcm - fix assumption that assoc has one segment
Date: Wed, 10 Apr 2013 15:49:39 -0700
Message-Id: <20130410224806.244331282@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224804.061806042@linuxfoundation.org>
References: <20130410224804.061806042@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 crypto/gcm.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -44,6 +44,7 @@ struct crypto_rfc4543_ctx {
 
 struct crypto_rfc4543_req_ctx {
 	u8 auth_tag[16];
+	u8 assocbuf[32];
 	struct scatterlist cipher[1];
 	struct scatterlist payload[2];
 	struct scatterlist assoc[2];
@@ -1142,9 +1143,19 @@ static struct aead_request *crypto_rfc45
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


