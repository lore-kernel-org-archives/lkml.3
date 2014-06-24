Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386AbaFXOmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:42:19 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34757 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184AbaFXOlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:41:17 -0400
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH v6 3/6] KEYS: make partial key id matching as a dedicated function
Date: Tue, 24 Jun 2014 10:40:49 -0400
Message-Id: <1403620852-16476-4-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1403620852-16476-1-git-send-email-zohar@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062414-3532-0000-0000-000002B013B8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Kasatkin <d.kasatkin@samsung.com>

To avoid code duplication this patch refactors asymmetric_key_match(),
making partial ID string match a separate function.

This patch also implicitly fixes a bug in the code.  asymmetric_key_match()
allows to match the key by its subtype. But subtype matching could be
undone if asymmetric_key_id(key) would return NULL. This patch first
checks for matching spec and then for its value.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
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
1.8.1.4

