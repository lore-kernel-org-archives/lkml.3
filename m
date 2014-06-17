Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbaFQI6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 04:58:22 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56609 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609AbaFQI5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 04:57:47 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-1a-53a003083c68
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, dhowells@redhat.com, jwboyer@redhat.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v2 1/3] KEYS: make key id matching as a dedicated function
Date: Tue, 17 Jun 2014 11:56:57 +0300
Message-id: <3513a5dbfe2fc84eb07006a0fd4b9c929972edc1.1402994752.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <cover.1402994752.git.d.kasatkin@samsung.com>
References: <cover.1402994752.git.d.kasatkin@samsung.com>
In-reply-to: <cover.1402994752.git.d.kasatkin@samsung.com>
References: <cover.1402994752.git.d.kasatkin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmluLIzCtJLcpLzFFi42I5/e/4ZV0O5gXBBvdmSVrc+ruX2eJd028W
	iwPvnrBYzN71kMXi8q45bBYfeh6xWXxaMYnZgd1j2ollLB4PDm1m8Xi/7yqbR9+WVYwenzfJ
	BbBGcdmkpOZklqUW6dslcGXs+G5R8EC8YulHiwbGHuEuRk4OCQETiZWnzjNC2GISF+6tZ+ti
	5OIQEljKKHFnVQcThNPJJHF9z3ewKjYBPYkNzT/YQRIiAm2MEm1bn7GBJJgFvCRO/v3GDmIL
	A9k727ewgNgsAqoS3x/+BqvhFYiTuNfwgxlinZzEyWOTWbsYOTg4BawkTi+SAgkLCVhKnFw6
	gRmH8ARG/gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQgLwyw7GxcesDjEKcDAq8fBG
	XJofLMSaWFZcmXuIUYKDWUmEV+gVUIg3JbGyKrUoP76oNCe1+BAjEwenVANj/4ZT3CwH/Ev0
	9HilL1yqvRbrVV126LbBNNO8rR0qc9IMNbdFbLpTsTsnTDPxqcipwKUzv/OITzu5/82MVy+y
	FCIMg1SWXDj9rzRoxe7SGw162gdealYdOrxwQ6WjRdeisuJLNX83zLp9Sf7suzpmobLv3pue
	hxffZeP0SDiRXuP+62veG7OJSizFGYmGWsxFxYkAZebX7B4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Key id matching will also be used in the following patch.
To avoid code duplication this patch moves functionality
to a separate function.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 crypto/asymmetric_keys/asymmetric_keys.h |  2 ++
 crypto/asymmetric_keys/asymmetric_type.c | 50 ++++++++++++++++++++------------
 2 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/crypto/asymmetric_keys/asymmetric_keys.h b/crypto/asymmetric_keys/asymmetric_keys.h
index 515b634..a63c551 100644
--- a/crypto/asymmetric_keys/asymmetric_keys.h
+++ b/crypto/asymmetric_keys/asymmetric_keys.h
@@ -9,6 +9,8 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
+int asymmetric_keyid_match(const char *kid, const char *id);
+
 static inline const char *asymmetric_key_id(const struct key *key)
 {
 	return key->type_data.p[1];
diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index b77eb53..1fd1d30 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -23,6 +23,34 @@ static LIST_HEAD(asymmetric_key_parsers);
 static DECLARE_RWSEM(asymmetric_key_parsers_sem);
 
 /*
+ * Match asymmetric key id with partial match
+ * @id:		key id to match in a form "id:<id>"
+ */
+int asymmetric_keyid_match(const char *kid, const char *id)
+{
+	size_t idlen, kidlen;
+
+	if (!kid || !id)
+		return 0;
+
+	/* make it possible to use id as in the request: "id:<id>" */
+	if (strncmp(id, "id:", 3) == 0)
+		id += 3;
+
+	/* Anything after here requires a partial match on the ID string */
+	idlen = strlen(id);
+	kidlen = strlen(kid);
+	if (idlen > kidlen)
+		return 0;
+
+	kid += kidlen - idlen;
+	if (strcasecmp(id, kid) != 0)
+		return 0;
+
+	return 1;
+}
+
+/*
  * Match asymmetric keys on (part of) their name
  * We have some shorthand methods for matching keys.  We allow:
  *
@@ -34,9 +62,8 @@ static int asymmetric_key_match(const struct key *key, const void *description)
 {
 	const struct asymmetric_key_subtype *subtype = asymmetric_key_subtype(key);
 	const char *spec = description;
-	const char *id, *kid;
+	const char *id;
 	ptrdiff_t speclen;
-	size_t idlen, kidlen;
 
 	if (!subtype || !spec || !*spec)
 		return 0;
@@ -55,23 +82,8 @@ static int asymmetric_key_match(const struct key *key, const void *description)
 	speclen = id - spec;
 	id++;
 
-	/* Anything after here requires a partial match on the ID string */
-	kid = asymmetric_key_id(key);
-	if (!kid)
-		return 0;
-
-	idlen = strlen(id);
-	kidlen = strlen(kid);
-	if (idlen > kidlen)
-		return 0;
-
-	kid += kidlen - idlen;
-	if (strcasecmp(id, kid) != 0)
-		return 0;
-
-	if (speclen == 2 &&
-	    memcmp(spec, "id", 2) == 0)
-		return 1;
+	if (speclen == 2 && memcmp(spec, "id", 2) == 0)
+		return asymmetric_keyid_match(asymmetric_key_id(key), id);
 
 	if (speclen == subtype->name_len &&
 	    memcmp(spec, subtype->name, speclen) == 0)
-- 
1.9.1

