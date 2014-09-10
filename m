Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbaIJVWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:22:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763AbaIJVW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:22:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 5/6] PKCS#7: Provide a single place to do signed info block
 freeing
From: David Howells <dhowells@redhat.com>
To: jmorris@namei.org
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 10 Sep 2014 22:22:22 +0100
Message-ID: <20140910212222.10752.32954.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140910212154.10752.23343.stgit@warthog.procyon.org.uk>
References: <20140910212154.10752.23343.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code to free a signed info block is repeated several times, so move the
code to do it into a function of its own.  This gives us a place to add clean
ups for stuff that gets added to pkcs7_signed_info.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
---

 crypto/asymmetric_keys/pkcs7_parser.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/crypto/asymmetric_keys/pkcs7_parser.c b/crypto/asymmetric_keys/pkcs7_parser.c
index 42e56aa7d277..4c4ea35c338b 100644
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
@@ -100,16 +110,12 @@ struct pkcs7_message *pkcs7_parse_message(const void *data, size_t datalen)
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
+	pkcs7_free_signed_info(ctx->sinfo);
 error_no_sinfo:
 	kfree(ctx);
 error_no_ctx:

