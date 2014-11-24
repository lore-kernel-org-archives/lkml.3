Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbaKXQO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 11:14:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbaKXQOY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 11:14:24 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <14276.1416833541@warthog.procyon.org.uk>
References: <14276.1416833541@warthog.procyon.org.uk> <5472F806.8000403@samsung.com> <20141120165351.5264.61930.stgit@warthog.procyon.org.uk> <546F3742.9010702@samsung.com>
Cc: dhowells@redhat.com, Dmitry Kasatkin <d.kasatkin@samsung.com>,
        mmarek@suse.cz, rusty@rustcorp.com.au, vgoyal@redhat.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        zohar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] MODSIGN: Use PKCS#7 for module signatures
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <31430.1416845619.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Mon, 24 Nov 2014 16:13:39 +0000
Message-ID: <31431.1416845619@warthog.procyon.org.uk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> > Actually after cleaning the tree and re-signing the modules, I get following
> > 
> > Unrecognized character \x7F; marked by <-- HERE after <-- HERE near
> > column 1 at ./scripts/sign-file line 1.
> > make[1]: *** [arch/x86/crypto/aes-x86_64.ko] Error 255
> 
> warthog>grep -r sign-file Makefile 
> mod_sign_cmd = perl $(srctree)/scripts/sign-file $(CONFIG_MODULE_SIG_HASH) $(MODSECKEY) $(MODPUBKEY)
> 
> Because of that.  I need to remove the 'perl' bit.

It's a little more involved than that.  The X.509 cert being passed to the
program is binary, whereas the one I've been testing with is PEM encoded - and
libssl has separate routines that don't work out for themselves which encoding
is in force.  Proposed changes below.

David
---
diff --git a/Makefile b/Makefile
index b77de27e58fc..8d5624bf96db 100644
--- a/Makefile
+++ b/Makefile
@@ -859,7 +859,7 @@ ifdef CONFIG_MODULE_SIG_ALL
 MODSECKEY = ./signing_key.priv
 MODPUBKEY = ./signing_key.x509
 export MODPUBKEY
-mod_sign_cmd = perl $(srctree)/scripts/sign-file $(CONFIG_MODULE_SIG_HASH) $(MODSECKEY) $(MODPUBKEY)
+mod_sign_cmd = scripts/sign-file $(CONFIG_MODULE_SIG_HASH) $(MODSECKEY) $(MODPUBKEY)
 else
 mod_sign_cmd = true
 endif
diff --git a/scripts/sign-file.c b/scripts/sign-file.c
index 3f9bedbd185f..ff5e78348de0 100755
--- a/scripts/sign-file.c
+++ b/scripts/sign-file.c
@@ -61,14 +61,24 @@ static void display_openssl_errors(int l)
 	}
 }
 
+static void drain_openssl_errors(void)
+{
+	const char *file;
+	int line;
+
+	if (ERR_peek_error() == 0)
+		return;
+	while (ERR_get_error_line(&file, &line)) {}
+}
 
-#define ERR(cond, ...)				  \
-	do {					  \
-		bool __cond = (cond);		  \
-		display_openssl_errors(__LINE__); \
-		if (__cond) {			  \
-			err(1, ## __VA_ARGS__);	  \
-		}				  \
+
+#define ERR(cond, ...)					\
+	do {						\
+		bool __cond = (cond);			\
+		display_openssl_errors(__LINE__);	\
+		if (__cond) {				\
+			err(1, ## __VA_ARGS__);		\
+		}					\
 	} while(0)
 
 int main(int argc, char **argv)
@@ -126,8 +136,15 @@ int main(int argc, char **argv)
 
 	b = BIO_new_file(x509_name, "rb");
 	ERR(!b, "%s", x509_name);
-        x509 = PEM_read_bio_X509(b, NULL, NULL, NULL);
+	x509 = d2i_X509_bio(b, NULL); /* Binary encoded X.509 */
+	if (!x509) {
+		BIO_reset(b);
+		x509 = PEM_read_bio_X509(b, NULL, NULL, NULL); /* PEM encoded X.509 */
+		if (x509)
+			drain_openssl_errors();
+	}
 	BIO_free(b);
+	ERR(!x509, "%s", x509_name);
 
 	/* Open the destination file now so that we can shovel the module data
 	 * across as we read it.
