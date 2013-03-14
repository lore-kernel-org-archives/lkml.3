Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab3CNMee (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 08:34:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25627 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab3CNMec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 08:34:32 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] X.509: Remove certificate date checks
To: rusty@rustcorp.com.au, torvalds@linux-foundation.org
From: David Howells <dhowells@redhat.com>
Cc: keyrings@linux-nfs.org, Josh Boyer <jwboyer@redhat.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alexander Holler <holler@ahsoftware.de>,
        David Woodhouse <dwmw2@infradead.org>
Date: Thu, 14 Mar 2013 12:34:13 +0000
Message-ID: <20130314123413.13286.62117.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the certificate date checks that are performed when a certificate is
parsed.  There are two checks: a valid from and a valid to.  The first check is
causing a lot of problems with system clocks that don't keep good time and the
second places an implicit expiry date upon the kernel when used for module
signing, so do we really need them?

Signed-off-by: David Howells <dhowells@redhat.com>
cc: David Woodhouse <dwmw2@infradead.org>
cc: Rusty Russell <rusty@rustcorp.com.au>
cc: Josh Boyer <jwboyer@redhat.com>
cc: Alexander Holler <holler@ahsoftware.de>
cc: stable@vger.kernel.org
---

 crypto/asymmetric_keys/x509.asn1          |    4 +-
 crypto/asymmetric_keys/x509_cert_parser.c |   64 -----------------------------
 crypto/asymmetric_keys/x509_parser.h      |    2 -
 crypto/asymmetric_keys/x509_public_key.c  |   46 ---------------------
 4 files changed, 2 insertions(+), 114 deletions(-)

diff --git a/crypto/asymmetric_keys/x509.asn1 b/crypto/asymmetric_keys/x509.asn1
index bf32b3d..b448099 100644
--- a/crypto/asymmetric_keys/x509.asn1
+++ b/crypto/asymmetric_keys/x509.asn1
@@ -35,8 +35,8 @@ AttributeValueAssertion ::= SEQUENCE {
 	}
 
 Validity ::= SEQUENCE {
-	notBefore		Time ({ x509_note_not_before }),
-	notAfter		Time ({ x509_note_not_after })
+	notBefore		Time,
+	notAfter		Time
 	}
 
 Time ::= CHOICE {
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 7fabc4c..3987508 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -430,67 +430,3 @@ int x509_process_extension(void *context, size_t hdrlen,
 
 	return 0;
 }
-
-/*
- * Record a certificate time.
- */
-static int x509_note_time(struct tm *tm,  size_t hdrlen,
-			  unsigned char tag,
-			  const unsigned char *value, size_t vlen)
-{
-	const unsigned char *p = value;
-
-#define dec2bin(X) ((X) - '0')
-#define DD2bin(P) ({ unsigned x = dec2bin(P[0]) * 10 + dec2bin(P[1]); P += 2; x; })
-
-	if (tag == ASN1_UNITIM) {
-		/* UTCTime: YYMMDDHHMMSSZ */
-		if (vlen != 13)
-			goto unsupported_time;
-		tm->tm_year = DD2bin(p);
-		if (tm->tm_year >= 50)
-			tm->tm_year += 1900;
-		else
-			tm->tm_year += 2000;
-	} else if (tag == ASN1_GENTIM) {
-		/* GenTime: YYYYMMDDHHMMSSZ */
-		if (vlen != 15)
-			goto unsupported_time;
-		tm->tm_year = DD2bin(p) * 100 + DD2bin(p);
-	} else {
-		goto unsupported_time;
-	}
-
-	tm->tm_year -= 1900;
-	tm->tm_mon  = DD2bin(p) - 1;
-	tm->tm_mday = DD2bin(p);
-	tm->tm_hour = DD2bin(p);
-	tm->tm_min  = DD2bin(p);
-	tm->tm_sec  = DD2bin(p);
-
-	if (*p != 'Z')
-		goto unsupported_time;
-
-	return 0;
-
-unsupported_time:
-	pr_debug("Got unsupported time [tag %02x]: '%*.*s'\n",
-		 tag, (int)vlen, (int)vlen, value);
-	return -EBADMSG;
-}
-
-int x509_note_not_before(void *context, size_t hdrlen,
-			 unsigned char tag,
-			 const void *value, size_t vlen)
-{
-	struct x509_parse_context *ctx = context;
-	return x509_note_time(&ctx->cert->valid_from, hdrlen, tag, value, vlen);
-}
-
-int x509_note_not_after(void *context, size_t hdrlen,
-			unsigned char tag,
-			const void *value, size_t vlen)
-{
-	struct x509_parse_context *ctx = context;
-	return x509_note_time(&ctx->cert->valid_to, hdrlen, tag, value, vlen);
-}
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index f86dc5f..8ee6f8e 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -18,8 +18,6 @@ struct x509_certificate {
 	char		*subject;		/* Name of certificate subject */
 	char		*fingerprint;		/* Key fingerprint as hex */
 	char		*authority;		/* Authority key fingerprint as hex */
-	struct tm	valid_from;
-	struct tm	valid_to;
 	enum pkey_algo	pkey_algo : 8;		/* Public key algorithm */
 	enum pkey_algo	sig_pkey_algo : 8;	/* Signature public key algorithm */
 	enum pkey_hash_algo sig_hash_algo : 8;	/* Signature hash algorithm */
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 06007f0..0d1fcfb 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -106,7 +106,6 @@ error_no_sig:
 static int x509_key_preparse(struct key_preparsed_payload *prep)
 {
 	struct x509_certificate *cert;
-	struct tm now;
 	size_t srlen, sulen;
 	char *desc = NULL;
 	int ret;
@@ -118,14 +117,6 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	pr_devel("Cert Issuer: %s\n", cert->issuer);
 	pr_devel("Cert Subject: %s\n", cert->subject);
 	pr_devel("Cert Key Algo: %s\n", pkey_algo[cert->pkey_algo]);
-	pr_devel("Cert Valid From: %04ld-%02d-%02d %02d:%02d:%02d\n",
-		 cert->valid_from.tm_year + 1900, cert->valid_from.tm_mon + 1,
-		 cert->valid_from.tm_mday, cert->valid_from.tm_hour,
-		 cert->valid_from.tm_min,  cert->valid_from.tm_sec);
-	pr_devel("Cert Valid To: %04ld-%02d-%02d %02d:%02d:%02d\n",
-		 cert->valid_to.tm_year + 1900, cert->valid_to.tm_mon + 1,
-		 cert->valid_to.tm_mday, cert->valid_to.tm_hour,
-		 cert->valid_to.tm_min,  cert->valid_to.tm_sec);
 	pr_devel("Cert Signature: %s + %s\n",
 		 pkey_algo[cert->sig_pkey_algo],
 		 pkey_hash_algo[cert->sig_hash_algo]);
@@ -137,43 +128,6 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 		goto error_free_cert;
 	}
 
-	time_to_tm(CURRENT_TIME.tv_sec, 0, &now);
-	pr_devel("Now: %04ld-%02d-%02d %02d:%02d:%02d\n",
-		 now.tm_year + 1900, now.tm_mon + 1, now.tm_mday,
-		 now.tm_hour, now.tm_min,  now.tm_sec);
-	if (now.tm_year < cert->valid_from.tm_year ||
-	    (now.tm_year == cert->valid_from.tm_year &&
-	     (now.tm_mon < cert->valid_from.tm_mon ||
-	      (now.tm_mon == cert->valid_from.tm_mon &&
-	       (now.tm_mday < cert->valid_from.tm_mday ||
-		(now.tm_mday == cert->valid_from.tm_mday &&
-		 (now.tm_hour < cert->valid_from.tm_hour ||
-		  (now.tm_hour == cert->valid_from.tm_hour &&
-		   (now.tm_min < cert->valid_from.tm_min ||
-		    (now.tm_min == cert->valid_from.tm_min &&
-		     (now.tm_sec < cert->valid_from.tm_sec
-		      ))))))))))) {
-		pr_warn("Cert %s is not yet valid\n", cert->fingerprint);
-		ret = -EKEYREJECTED;
-		goto error_free_cert;
-	}
-	if (now.tm_year > cert->valid_to.tm_year ||
-	    (now.tm_year == cert->valid_to.tm_year &&
-	     (now.tm_mon > cert->valid_to.tm_mon ||
-	      (now.tm_mon == cert->valid_to.tm_mon &&
-	       (now.tm_mday > cert->valid_to.tm_mday ||
-		(now.tm_mday == cert->valid_to.tm_mday &&
-		 (now.tm_hour > cert->valid_to.tm_hour ||
-		  (now.tm_hour == cert->valid_to.tm_hour &&
-		   (now.tm_min > cert->valid_to.tm_min ||
-		    (now.tm_min == cert->valid_to.tm_min &&
-		     (now.tm_sec > cert->valid_to.tm_sec
-		      ))))))))))) {
-		pr_warn("Cert %s has expired\n", cert->fingerprint);
-		ret = -EKEYEXPIRED;
-		goto error_free_cert;
-	}
-
 	cert->pub->algo = x509_public_key_algorithms[cert->pkey_algo];
 	cert->pub->id_type = PKEY_ID_X509;
 

