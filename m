Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbaIJVWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:22:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824AbaIJVWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:22:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 6/6] PKCS#7: Fix the parser cleanup to drain parsed out
 X.509 certs
From: David Howells <dhowells@redhat.com>
To: jmorris@namei.org
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 10 Sep 2014 22:22:28 +0100
Message-ID: <20140910212228.10752.27885.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140910212154.10752.23343.stgit@warthog.procyon.org.uk>
References: <20140910212154.10752.23343.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the parser cleanup code to drain parsed out X.509 certs in the case that
the decode fails and we jump to error_decode.

The function is rearranged so that the same cleanup code is used in the success
case as the error case - just that the message descriptor under construction is
only released if it is still pointed to by the context struct at that point.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---

 crypto/asymmetric_keys/pkcs7_parser.c |   39 ++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 4c4ea35c338b..1e9861da7ee4 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -81,47 +81,46 @@ EXPORT_SYMBOL_GPL(pkcs7_free_message);
 struct pkcs7_message *pkcs7_parse_message(const void *data, size_t datalen)
 {
 	struct pkcs7_parse_context *ctx;
-	struct pkcs7_message *msg;
-	long ret;
+	struct pkcs7_message *msg = ERR_PTR(-ENOMEM);
+	int ret;
 
-	ret = -ENOMEM;
-	msg = kzalloc(sizeof(struct pkcs7_message), GFP_KERNEL);
-	if (!msg)
-		goto error_no_sig;
 	ctx = kzalloc(sizeof(struct pkcs7_parse_context), GFP_KERNEL);
 	if (!ctx)
-		goto error_no_ctx;
+		goto out_no_ctx;
+	ctx->msg = kzalloc(sizeof(struct pkcs7_message), GFP_KERNEL);
+	if (!ctx->msg)
+		goto out_no_msg;
 	ctx->sinfo = kzalloc(sizeof(struct pkcs7_signed_info), GFP_KERNEL);
 	if (!ctx->sinfo)
-		goto error_no_sinfo;
+		goto out_no_sinfo;
 
-	ctx->msg = msg;
 	ctx->data = (unsigned long)data;
 	ctx->ppcerts = &ctx->certs;
 	ctx->ppsinfo = &ctx->msg->signed_infos;
 
 	/* Attempt to decode the signature */
 	ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen);
-	if (ret < 0)
-		goto error_decode;
+	if (ret < 0) {
+		msg = ERR_PTR(ret);
+		goto out;
+	}
+
+	msg = ctx->msg;
+	ctx->msg = NULL;
 
+out:
 	while (ctx->certs) {
 		struct x509_certificate *cert = ctx->certs;
 		ctx->certs = cert->next;
 		x509_free_certificate(cert);
 	}
 	pkcs7_free_signed_info(ctx->sinfo);
+out_no_sinfo:
+	pkcs7_free_message(ctx->msg);
+out_no_msg:
 	kfree(ctx);
+out_no_ctx:
 	return msg;
-
-error_decode:
-	pkcs7_free_signed_info(ctx->sinfo);
-error_no_sinfo:
-	kfree(ctx);
-error_no_ctx:
-	pkcs7_free_message(msg);
-error_no_sig:
-	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(pkcs7_parse_message);
 

