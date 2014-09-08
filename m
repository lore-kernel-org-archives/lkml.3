Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577AbaIHPic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:38:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531AbaIHPi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:38:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 07/13] PKCS#7: Clean up the signed info freeing and fix the
 parser cleanup
From: David Howells <dhowells@redhat.com>
To: rusty@rustcorp.com.au
Cc: keyrings@linux-nfs.org, jwboyer@redhat.com, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        pjones@redhat.com, vgoyal@redhat.com
Date: Mon, 08 Sep 2014 16:38:20 +0100
Message-ID: <20140908153820.28301.74512.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140908153704.28301.41578.stgit@warthog.procyon.org.uk>
References: <20140908153704.28301.41578.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a function to free pkcs7_signed_info structs and use it in the parser
and pkcs7_message struct freeing routines.

This also exposes a missing pkcs7_message free in the parser cleanup which is
also dealt with.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/pkcs7_parser.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 42e56aa7d277..459d2077c61b 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.c
+++ b/crypto/asymmetric_keys/pkcs7_parser.c
@@ -31,6 +31,18 @@ struct pkcs7_parse_context {
 	unsigned	sinfo_index;
 };
 
+/*
+ * Free a signed information block.
+ */
+static void pkcs7_free_signed_info(struct pkcs7_signed_info *sinfo)
+{
+	if (sinfo) {
+		mpi_free(sinfo->sig.mpi[0]);
+		kfree(sinfo->sig.digest);
+		kfree(sinfo);
+	}
+}
+
 /**
  * pkcs7_free_message - Free a PKCS#7 message
  * @pkcs7: The PKCS#7 message to free
@@ -54,9 +66,7 @@ void pkcs7_free_message(struct pkcs7_message *pkcs7)
 		while (pkcs7->signed_infos) {
 			sinfo = pkcs7->signed_infos;
 			pkcs7->signed_infos = sinfo->next;
-			mpi_free(sinfo->sig.mpi[0]);
-			kfree(sinfo->sig.digest);
-			kfree(sinfo);
+			pkcs7_free_signed_info(sinfo);
 		}
 		kfree(pkcs7);
 	}
@@ -95,21 +105,21 @@ struct pkcs7_message *pkcs7_parse_message(const void *data, size_t datalen)
 	if (ret < 0)
 		goto error_decode;
 
+out:
 	while (ctx->certs) {
 		struct x509_certificate *cert = ctx->certs;
 		ctx->certs = cert->next;
 		x509_free_certificate(cert);
 	}
-	mpi_free(ctx->sinfo->sig.mpi[0]);
-	kfree(ctx->sinfo->sig.digest);
-	kfree(ctx->sinfo);
+	pkcs7_free_signed_info(ctx->sinfo);
 	kfree(ctx);
 	return msg;
 
 error_decode:
-	mpi_free(ctx->sinfo->sig.mpi[0]);
-	kfree(ctx->sinfo->sig.digest);
-	kfree(ctx->sinfo);
+	pkcs7_free_message(msg);
+	msg = ERR_PTR(ret);
+	goto out;
+
 error_no_sinfo:
 	kfree(ctx);
 error_no_ctx:

