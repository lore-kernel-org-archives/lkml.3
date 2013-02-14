Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760509Ab3BNNar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 08:30:47 -0500
Received: from mail-ia0-f173.google.com ([209.85.210.173]:47016 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757643Ab3BNNap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 08:30:45 -0500
From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
To: rusty@rustcorp.com.au, dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, Chun-Yi Lee <jlee@suse.com>,
        Josh Boyer <jwboyer@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v2] X.509: Support parse long form of length octets in Authority Key Identifier
Date: Thu, 14 Feb 2013 21:29:46 +0800
Message-Id: <1360848586-2448-1-git-send-email-jlee@suse.com>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chun-Yi Lee <jlee@suse.com>

Per X.509 spec in 4.2.1.1 section, the structure of Authority Key
Identifier Extension is:

   AuthorityKeyIdentifier ::= SEQUENCE {
      keyIdentifier             [0] KeyIdentifier           OPTIONAL,
      authorityCertIssuer       [1] GeneralNames            OPTIONAL,
      authorityCertSerialNumber [2] CertificateSerialNumber OPTIONAL  }

   KeyIdentifier ::= OCTET STRING

When a certificate also provides
authorityCertIssuer and authorityCertSerialNumber then the length of
AuthorityKeyIdentifier SEQUENCE is likely to long form format.
e.g.
   The example certificate demos/tunala/A-server.pem in openssl source:

X509v3 Authority Key Identifier:
    keyid:49:FB:45:72:12:C4:CC:E1:45:A1:D3:08:9E:95:C4:2C:6D:55:3F:17
    DirName:/C=NZ/L=Wellington/O=Really Irresponsible Authorisation Authority (RIAA)/OU=Cert-stamping/CN=Jackov al-Trades/emailAddress=none@fake.domain
    serial:00

Current parsing rule of OID_authorityKeyIdentifier only take care the
short form format, it causes load certificate to modsign_keyring fail:

[   12.061147] X.509: Extension: 47
[   12.075121] MODSIGN: Problem loading in-kernel X.509 certificate (-74)

So, this patch add the parsing rule for support long form format against
Authority Key Identifier.

v2:
 - Removed comma from author's name.
 - Moved 'Short Form length' comment inside the if-body.
 - Changed the type of sub to size_t.
 - Use ASN1_INDEFINITE_LENGTH rather than writing 0x80 and 127.
 - Moved the key_len's value assignment before alter v.
 - Fixed the typo of octets.
 - Add 2 to v before entering the loop for calculate the length.
 - Removed the comment of check vlen.

Cc: David Howells <dhowells@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Josh Boyer <jwboyer@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Chun-Yi Lee <jlee@suse.com>
---
 crypto/asymmetric_keys/x509_cert_parser.c |   55 ++++++++++++++++++++++++----
 1 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 7fabc4c..59ab6d2 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -373,6 +373,9 @@ int rsa_extract_mpi(void *context, size_t hdrlen,
 	return 0;
 }
 
+/* The keyIdentifier in AuthorityKeyIdentifier SEQUENCE is tag(CONT,PRIM,0) */
+#define SEQ_TAG_KEYID (ASN1_CONT << 6)
+
 /*
  * Process certificate extensions that are used to qualify the certificate.
  */
@@ -407,21 +410,57 @@ int x509_process_extension(void *context, size_t hdrlen,
 	}
 
 	if (ctx->last_oid == OID_authorityKeyIdentifier) {
+		size_t key_len;
+
 		/* Get hold of the CA key fingerprint */
 		if (vlen < 5)
 			return -EBADMSG;
-		if (v[0] != (ASN1_SEQ | (ASN1_CONS << 5)) ||
-		    v[1] != vlen - 2 ||
-		    v[2] != (ASN1_CONT << 6) ||
-		    v[3] != vlen - 4)
+
+		/* Authority Key Identifier must be a Constructed SEQUENCE */
+		if (v[0] != (ASN1_SEQ | (ASN1_CONS << 5)))
 			return -EBADMSG;
-		v += 4;
-		vlen -= 4;
 
-		f = kmalloc(vlen * 2 + 1, GFP_KERNEL);
+		/* Authority Key Identifier is not indefinite length */
+		if (unlikely(vlen == ASN1_INDEFINITE_LENGTH))
+			return -EBADMSG;
+
+		if (vlen < ASN1_INDEFINITE_LENGTH) {
+			/* Short Form length */
+			if (v[1] != vlen - 2 ||
+			    v[2] != SEQ_TAG_KEYID ||
+			    v[3] != vlen - 4)
+				return -EBADMSG;
+
+			key_len = v[3];
+			v += 4;
+		} else {
+			/* Long Form length */
+			size_t seq_len = 0;
+			size_t sub = v[1] - ASN1_INDEFINITE_LENGTH;
+
+			if (sub > 2)
+				return -EBADMSG;
+
+			/* calculate the length from subsequent octets */
+			v += 2;
+			for (i = 0; i < sub; i++) {
+				seq_len <<= 8;
+				seq_len |= v[i];
+			}
+
+			if (seq_len != vlen - 2 - sub ||
+			    v[sub] != SEQ_TAG_KEYID ||
+			    v[sub + 1] > vlen - 4 - sub)
+				return -EBADMSG;
+
+			key_len = v[sub + 1];
+			v += (sub + 2);
+		}
+
+		f = kmalloc(key_len * 2 + 1, GFP_KERNEL);
 		if (!f)
 			return -ENOMEM;
-		for (i = 0; i < vlen; i++)
+		for (i = 0; i < key_len; i++)
 			sprintf(f + i * 2, "%02x", v[i]);
 		pr_debug("authority   %s\n", f);
 		ctx->cert->authority = f;
-- 
1.6.4.2

