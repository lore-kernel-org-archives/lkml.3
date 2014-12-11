Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757887AbaLKQll (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 11:41:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753789AbaLKQlj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 11:41:39 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <548172DE.9090007@samsung.com>
References: <548172DE.9090007@samsung.com> <20141126141709.3944.66589.stgit@warthog.procyon.org.uk> <20141126141753.3944.22213.stgit@warthog.procyon.org.uk>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: dhowells@redhat.com, rusty@rustcorp.com.au, mmarek@suse.cz,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com
Subject: Re: [PATCH 4/5] MODSIGN: Provide a utility to append a PKCS#7 signature to a module [ver #2]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10248.1418316079.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Thu, 11 Dec 2014 16:41:19 +0000
Message-ID: <10249.1418316079@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:

> sign-file.c produce lots of annoying noise.

Compiling it manually with -Wformat-security found those problems you listed
and add -W found yet another problem.  Differential patch attached.  I've
folded it into the patch that adds sign-file.c.

David
---
diff --git a/scripts/sign-file.c b/scripts/sign-file.c
index 3f9bedbd185f..7941f499ddba 100755
--- a/scripts/sign-file.c
+++ b/scripts/sign-file.c
@@ -62,12 +62,12 @@ static void display_openssl_errors(int l)
 }
 
 
-#define ERR(cond, ...)				  \
+#define ERR(cond, fmt, ...)			  \
 	do {					  \
 		bool __cond = (cond);		  \
 		display_openssl_errors(__LINE__); \
 		if (__cond) {			  \
-			err(1, ## __VA_ARGS__);	  \
+			err(1, fmt, ## __VA_ARGS__);	\
 		}				  \
 	} while(0)
 
@@ -133,7 +133,7 @@ int main(int argc, char **argv)
 	 * across as we read it.
 	 */
 	bd = BIO_new_file(dest_name, "wb");
-	ERR(!bd, dest_name);
+	ERR(!bd, "%s", dest_name);
 
 	/* Digest the module data. */
 	OpenSSL_add_all_digests();
@@ -149,7 +149,7 @@ int main(int argc, char **argv)
 			   PKCS7_NOCERTS | PKCS7_PARTIAL | PKCS7_BINARY | PKCS7_DETACHED | PKCS7_STREAM);
 	ERR(!pkcs7, "PKCS7_sign");
 
-	ERR(PKCS7_sign_add_signer(pkcs7, x509, private_key, digest_algo, PKCS7_NOCERTS | PKCS7_BINARY) < 0,
+	ERR(!PKCS7_sign_add_signer(pkcs7, x509, private_key, digest_algo, PKCS7_NOCERTS | PKCS7_BINARY),
 	    "PKCS7_sign_add_signer");
 	ERR(PKCS7_final(pkcs7, bm, PKCS7_NOCERTS | PKCS7_BINARY) < 0,
 	    "PKCS7_final");
@@ -159,31 +159,31 @@ int main(int argc, char **argv)
 
 		ERR(asprintf(&pkcs7_name, "%s.pkcs7", module_name) < 0, "asprintf");
 		b = BIO_new_file(pkcs7_name, "wb");
-		ERR(!b, pkcs7_name);
-		ERR(i2d_PKCS7_bio_stream(b, pkcs7, NULL, 0) < 0, pkcs7_name);
+		ERR(!b, "%s", pkcs7_name);
+		ERR(i2d_PKCS7_bio_stream(b, pkcs7, NULL, 0) < 0, "%s", pkcs7_name);
 		BIO_free(b);
 	}
 
 	/* Append the marker and the PKCS#7 message to the destination file */
-	ERR(BIO_reset(bm) < 0, module_name);
+	ERR(BIO_reset(bm) < 0, "%s", module_name);
 	while ((n = BIO_read(bm, buf, sizeof(buf))),
 	       n > 0) {
-		ERR(BIO_write(bd, buf, n) < 0, dest_name);
+		ERR(BIO_write(bd, buf, n) < 0, "%s", dest_name);
 	}
-	ERR(n < 0, module_name);
+	ERR(n < 0, "%s", module_name);
 	module_size = BIO_number_written(bd);
 
-	ERR(i2d_PKCS7_bio_stream(bd, pkcs7, NULL, 0) < 0, dest_name);
+	ERR(i2d_PKCS7_bio_stream(bd, pkcs7, NULL, 0) < 0, "%s", dest_name);
 	pkcs7_size = BIO_number_written(bd) - module_size;
 	sig_info.sig_len = htonl(pkcs7_size);
-	ERR(BIO_write(bd, &sig_info, sizeof(sig_info)) < 0, dest_name);
-	ERR(BIO_write(bd, magic_number, sizeof(magic_number) - 1) < 0, dest_name);
+	ERR(BIO_write(bd, &sig_info, sizeof(sig_info)) < 0, "%s", dest_name);
+	ERR(BIO_write(bd, magic_number, sizeof(magic_number) - 1) < 0, "%s", dest_name);
 
-	ERR(BIO_free(bd) < 0, dest_name);
+	ERR(BIO_free(bd) < 0, "%s", dest_name);
 
 	/* Finally, if we're signing in place, replace the original. */
 	if (replace_orig)
-		ERR(rename(dest_name, module_name) < 0, dest_name);
+		ERR(rename(dest_name, module_name) < 0, "%s", dest_name);
 
 	return 0;
 }
