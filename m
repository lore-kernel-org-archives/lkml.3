Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbaJCPzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:55:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260AbaJCPy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:54:57 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
References: <6d32cecfb3c3f5d041900ce1866bc15134832991.1412327306.git.d.kasatkin@samsung.com> <cover.1412327306.git.d.kasatkin@samsung.com> <cover.1412327306.git.d.kasatkin@samsung.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: dhowells@redhat.com, zohar@linux.vnet.ibm.com,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, jmorris@namei.org,
        rusty@rustcorp.com.au, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com
Subject: [PATCH] X.509: If available, use the raw subjKeyId to form the key description
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2340.1412351669.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Fri, 03 Oct 2014 16:54:29 +0100
Message-ID: <2341.1412351669@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Module signing matches keys by comparing against the key description exactly.
However, the way the key description gets constructed got changed to be
composed of the subject name plus the certificate serial number instead of the
subject name and the subjectKeyId.  I changed this to avoid problems with
certificates that don't *have* a subjectKeyId.

Instead, if available, use the raw subjectKeyId to form the key description
and only use the serial number if the subjectKeyId doesn't exist.

Reported-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---
 x509_cert_parser.c |    2 ++
 x509_parser.h      |    2 ++
 x509_public_key.c  |    9 +++++++--
 3 files changed, 11 insertions(+), 2 deletions(-)


diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 96151b2b91a2..393706f33fa5 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -435,6 +435,8 @@ int x509_process_extension(void *context, size_t hdrlen,
 		v += 2;
 		vlen -= 2;
 
+		ctx->cert->raw_skid_size = vlen;
+		ctx->cert->raw_skid = v;
 		kid = asymmetric_key_generate_id(v, vlen,
 						 ctx->cert->raw_subject,
 						 ctx->cert->raw_subject_size);
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index 4e1a384901ed..3f0f0f081621 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -34,6 +34,8 @@ struct x509_certificate {
 	const void	*raw_issuer;		/* Raw issuer name in ASN.1 */
 	const void	*raw_subject;		/* Raw subject name in ASN.1 */
 	unsigned	raw_subject_size;
+	unsigned	raw_skid_size;
+	const void	*raw_skid;		/* Raw subjectKeyId in ASN.1 */
 	unsigned	index;
 	bool		seen;			/* Infinite recursion prevention */
 	bool		verified;
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 1d9a4c555376..8bffb06b2683 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -279,8 +279,13 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 
 	/* Propose a description */
 	sulen = strlen(cert->subject);
-	srlen = cert->raw_serial_size;
-	q = cert->raw_serial;
+	if (cert->raw_skid) {
+		srlen = cert->raw_skid_size;
+		q = cert->raw_skid;
+	} else {
+		srlen = cert->raw_serial_size;
+		q = cert->raw_serial;
+	}
 	if (srlen > 1 && *q == 0) {
 		srlen--;
 		q++;

