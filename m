Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaJCJKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 05:10:13 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52507 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaJCJKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 05:10:07 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-fd-542e67eb0b76
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, dhowells@redhat.com,
        jmorris@namei.org, rusty@rustcorp.com.au, keyrings@linux-nfs.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 2/4] KEYS: provide pure subject key identifier (fingerprint) as
 key id
Date: Fri, 03 Oct 2014 12:09:55 +0300
Message-id: <c7fc6e50a7854d537eef85ede24ba0792212ce59.1412327306.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1412327306.git.d.kasatkin@samsung.com>
References: <cover.1412327306.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1412327306.git.d.kasatkin@samsung.com>
References: <cover.1412327306.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t/xq7qv0/VCDH7NZ7O49Xcvs8W7pt8s
	Fl+W1lmsW7+YyWL2rocsFi9nzGO3uLxrDpvFh55HbBY3p11gsfi0YhKzA5fHzll32T2mnVjG
	4vHg0GYWj90LPjN59HxP9ni/7yqbx4oNJ5g9+rasYvT4vEkugDOKyyYlNSezLLVI3y6BK2Pq
	koPMBcc1K5Z//8LSwPheqYuRk0NCwETi3Zp2RghbTOLCvfVsXYxcHEICSxklLvxdwwSSEBLo
	ZJL4+UINxGYT0JPY0PyDHaRIROAoo8S0M9dZQRLMAukSnyb1soPYwgIREp/XXgNrZhFQlTg3
	pwmshlcgTuLC1OtQ2+QkTh6bDBbnFLCS2HJ1AxvEMkuJ9f0r2HGJT2DkX8DIsIpRNLU0uaA4
	KT3XSK84Mbe4NC9dLzk/dxMjJJC/7mBceszqEKMAB6MSD++HG7ohQqyJZcWVuYcYJTiYlUR4
	T8fphQjxpiRWVqUW5ccXleakFh9iZOLglGpgPFmYc+v4JgUfO7b1N+YEP/0pveue8oFm+9hC
	vScnpkkJ7zppek7y5dNjdomfTghE7ZFdaxHSdfjkVd7SdcxAndu4Z2xm9n229peGudGML+d3
	lvBJinTnizMrxMU26mobzsnc9j2mhGXfG4mNSdJ/3xYs/rIxxXHqbZ2svZ3foz0zDL7M0/+t
	xFKckWioxVxUnAgAdRvZjEICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Earlier KEYs code used pure subject key identifies for
searching keys. Latest merged code removed that and broke
compatibility with integrity subsytem signatures and original
format of module signatures.

This patch returns back fingerprint and partial matching.

Reported-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 crypto/asymmetric_keys/asymmetric_type.c  | 23 ++++++++++++++++++++++-
 crypto/asymmetric_keys/x509_cert_parser.c |  6 ++++++
 crypto/asymmetric_keys/x509_parser.h      |  1 +
 crypto/asymmetric_keys/x509_public_key.c  |  2 ++
 include/keys/asymmetric-type.h            |  2 +-
 5 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index 29983cb..9c83129 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -45,7 +45,8 @@ struct asymmetric_key_id *asymmetric_key_generate_id(const void *val_1,
 		return ERR_PTR(-ENOMEM);
 	kid->len = len_1 + len_2;
 	memcpy(kid->data, val_1, len_1);
-	memcpy(kid->data + len_1, val_2, len_2);
+	if (val_2)
+		memcpy(kid->data + len_1, val_2, len_2);
 	return kid;
 }
 EXPORT_SYMBOL_GPL(asymmetric_key_generate_id);
@@ -66,6 +67,23 @@ bool asymmetric_key_id_same(const struct asymmetric_key_id *kid1,
 EXPORT_SYMBOL_GPL(asymmetric_key_id_same);
 
 /**
+ * asymmetric_key_id_partial - Return true if two asymmetric keys IDs
+ * partially match
+ * @kid_1, @kid_2: The key IDs to compare
+ */
+bool asymmetric_key_id_partial(const struct asymmetric_key_id *kid1,
+			       const struct asymmetric_key_id *kid2)
+{
+	if (!kid1 || !kid2)
+		return false;
+	if (kid1->len < kid2->len)
+		return false;
+	return memcmp(kid1->data + (kid1->len - kid2->len),
+		      kid2->data, kid2->len) == 0;
+}
+EXPORT_SYMBOL_GPL(asymmetric_key_id_partial);
+
+/**
  * asymmetric_match_key_ids - Search asymmetric key IDs
  * @kids: The list of key IDs to check
  * @match_id: The key ID we're looking for
@@ -79,6 +97,8 @@ bool asymmetric_match_key_ids(const struct asymmetric_key_ids *kids,
 		return true;
 	if (asymmetric_key_id_same(kids->id[1], match_id))
 		return true;
+	if (asymmetric_key_id_partial(kids->id[2], match_id))
+		return true;
 	return false;
 }
 EXPORT_SYMBOL_GPL(asymmetric_match_key_ids);
@@ -261,6 +281,7 @@ static void asymmetric_key_free_preparse(struct key_preparsed_payload *prep)
 	if (kids) {
 		kfree(kids->id[0]);
 		kfree(kids->id[1]);
+		kfree(kids->id[2]);
 		kfree(kids);
 	}
 	kfree(prep->description);
diff --git a/crypto/asymmetric_keys/x509_cert_parser.c b/crypto/asymmetric_keys/x509_cert_parser.c
index 96151b2..7cf36fe 100644
--- a/crypto/asymmetric_keys/x509_cert_parser.c
+++ b/crypto/asymmetric_keys/x509_cert_parser.c
@@ -48,6 +48,7 @@ void x509_free_certificate(struct x509_certificate *cert)
 		kfree(cert->subject);
 		kfree(cert->id);
 		kfree(cert->skid);
+		kfree(cert->skid_only);
 		kfree(cert->authority);
 		kfree(cert->sig.digest);
 		mpi_free(cert->sig.rsa.s);
@@ -442,6 +443,11 @@ int x509_process_extension(void *context, size_t hdrlen,
 			return PTR_ERR(kid);
 		ctx->cert->skid = kid;
 		pr_debug("subjkeyid %*phN\n", kid->len, kid->data);
+		kid = asymmetric_key_generate_id(v, vlen, NULL, 0);
+		if (IS_ERR(kid))
+			return PTR_ERR(kid);
+		ctx->cert->skid_only = kid;
+		pr_debug("subjkeyid %*phN\n", kid->len, kid->data);
 		return 0;
 	}
 
diff --git a/crypto/asymmetric_keys/x509_parser.h b/crypto/asymmetric_keys/x509_parser.h
index 4e1a384..a0b3052 100644
--- a/crypto/asymmetric_keys/x509_parser.h
+++ b/crypto/asymmetric_keys/x509_parser.h
@@ -21,6 +21,7 @@ struct x509_certificate {
 	char		*subject;		/* Name of certificate subject */
 	struct asymmetric_key_id *id;		/* Issuer + serial number */
 	struct asymmetric_key_id *skid;		/* Subject key identifier */
+	struct asymmetric_key_id *skid_only;	/* Subject key identifier only*/
 	struct asymmetric_key_id *authority;	/* Authority key identifier */
 	struct tm	valid_from;
 	struct tm	valid_to;
diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 1d9a4c5..a0673c9 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -302,6 +302,7 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 		goto error_free_desc;
 	kids->id[0] = cert->id;
 	kids->id[1] = cert->skid;
+	kids->id[2] = cert->skid_only;
 
 	/* We're pinning the module by being linked against it */
 	__module_get(public_key_subtype.owner);
@@ -315,6 +316,7 @@ static int x509_key_preparse(struct key_preparsed_payload *prep)
 	cert->pub = NULL;
 	cert->id = NULL;
 	cert->skid = NULL;
+	cert->skid_only = NULL;
 	desc = NULL;
 	ret = 0;
 
diff --git a/include/keys/asymmetric-type.h b/include/keys/asymmetric-type.h
index 044ab0d..54fb119 100644
--- a/include/keys/asymmetric-type.h
+++ b/include/keys/asymmetric-type.h
@@ -45,7 +45,7 @@ struct asymmetric_key_id {
 };
 
 struct asymmetric_key_ids {
-	void		*id[2];
+	void		*id[3];
 };
 
 extern bool asymmetric_key_id_same(const struct asymmetric_key_id *kid1,
-- 
1.9.1

