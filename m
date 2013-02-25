Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838Ab3BYRn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 12:43:56 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:42919 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab3BYRnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 12:43:52 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH] crypto: Ignore validity dates of X.509 certificates by default
Date: Mon, 25 Feb 2013 18:40:26 +0100
Message-Id: <1361814026-4734-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't see any real use case where checking the validity dates of X.509
certificates at parsing time adds any security gain. In contrast, doing so
makes MODSIGN unusable on systems without a RTC (or systems with a possible
wrong date in a existing RTC or systems where the RTC is read after the keys
got loaded).

So just disable checking the dates in the parser by default.

(In fact I even think the check in the parser should be deleted at all,
because those dates should be checked at the time of usage and not at
parsing time, if someone really cares about these dates.)

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 crypto/asymmetric_keys/Kconfig           | 10 ++++++++++
 crypto/asymmetric_keys/x509_public_key.c |  4 ++++
 2 files changed, 14 insertions(+)

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 6d2c2ea..333976f 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -35,4 +35,14 @@ config X509_CERTIFICATE_PARSER
 	  data and provides the ability to instantiate a crypto key from a
 	  public key packet found inside the certificate.
 
+config X509_CERTIFICATE_PARSER_IGNORE_DATES
+	bool "Ignore validity dates of X.509 certificates in the parser"
+	depends on X509_CERTIFICATE_PARSER
+	default y
+	help
+	  Ignore the validity dates in X.509 certificates (Not Before
+	  and Not After) when they get parsed. Otherwise loading them will
+	  fail when the time is set wrong (which is e.g. a problem at startup
+	  on systems without a RTC).
+
 endif # ASYMMETRIC_KEY_TYPE
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 06007f0..c9a73e2 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -106,7 +106,9 @@ error_no_sig:
 static int x509_key_preparse(struct key_preparsed_payload *prep)
 {
 	struct x509_certificate *cert;
+#if !defined(CONFIG_X509_CERTIFICATE_PARSER_IGNORE_DATES)
 	struct tm now;
+#endif
 	size_t srlen, sulen;
 	char *desc = NULL;
 	int ret;
@@ -137,6 +139,7 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 		goto error_free_cert;
 	}
 
+#if !defined(CONFIG_X509_CERTIFICATE_PARSER_IGNORE_DATES)
 	time_to_tm(CURRENT_TIME.tv_sec, 0, &now);
 	pr_devel("Now: %04ld-%02d-%02d %02d:%02d:%02d\n",
 		 now.tm_year + 1900, now.tm_mon + 1, now.tm_mday,
@@ -173,6 +176,7 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 		ret = -EKEYEXPIRED;
 		goto error_free_cert;
 	}
+#endif
 
 	cert->pub->algo = x509_public_key_algorithms[cert->pkey_algo];
 	cert->pub->id_type = PKEY_ID_X509;
-- 
1.8.1.2

