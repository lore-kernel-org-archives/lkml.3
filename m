Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab3KDQi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:38:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab3KDQi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:38:57 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 2/9] KEYS: Provide a generic instantiation function
To: d.kasatkin@samsung.com, zohar@us.ibm.com
From: David Howells <dhowells@redhat.com>
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Nov 2013 16:22:31 +0000
Message-ID: <20131104162231.10177.84539.stgit@warthog.procyon.org.uk>
In-Reply-To: <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
References: <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a generic instantiation function for key types that use the preparse
hook.  This makes it easier to prereserve key quota before keyrings get locked
to retain the new key.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/asymmetric_type.c |   25 +------------------------
 include/linux/key-type.h                 |    2 ++
 security/keys/key.c                      |   30 ++++++++++++++++++++++++++++++
 3 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index b77eb5304788..c1fe0fcee8e3 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -164,29 +164,6 @@ static void asymmetric_key_free_preparse(struct key_preparsed_payload *prep)
 }
 
 /*
- * Instantiate a asymmetric_key defined key.  The key was preparsed, so we just
- * have to transfer the data here.
- */
-static int asymmetric_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
-{
-	int ret;
-
-	pr_devel("==>%s()\n", __func__);
-
-	ret = key_payload_reserve(key, prep->quotalen);
-	if (ret == 0) {
-		key->type_data.p[0] = prep->type_data[0];
-		key->type_data.p[1] = prep->type_data[1];
-		key->payload.data = prep->payload;
-		prep->type_data[0] = NULL;
-		prep->type_data[1] = NULL;
-		prep->payload = NULL;
-	}
-	pr_devel("<==%s() = %d\n", __func__, ret);
-	return ret;
-}
-
-/*
  * dispose of the data dangling from the corpse of a asymmetric key
  */
 static void asymmetric_key_destroy(struct key *key)
@@ -205,7 +182,7 @@ struct key_type key_type_asymmetric = {
 	.name		= "asymmetric",
 	.preparse	= asymmetric_key_preparse,
 	.free_preparse	= asymmetric_key_free_preparse,
-	.instantiate	= asymmetric_key_instantiate,
+	.instantiate	= generic_key_instantiate,
 	.match		= asymmetric_key_match,
 	.destroy	= asymmetric_key_destroy,
 	.describe	= asymmetric_key_describe,
diff --git a/include/linux/key-type.h b/include/linux/key-type.h
index a74c3a84dfdd..88503dca2a57 100644
--- a/include/linux/key-type.h
+++ b/include/linux/key-type.h
@@ -159,5 +159,7 @@ static inline int key_negate_and_link(struct key *key,
 	return key_reject_and_link(key, timeout, ENOKEY, keyring, instkey);
 }
 
+extern int generic_key_instantiate(struct key *key, struct key_preparsed_payload *prep);
+
 #endif /* CONFIG_KEYS */
 #endif /* _LINUX_KEY_TYPE_H */
diff --git a/security/keys/key.c b/security/keys/key.c
index 55d110f0aced..4ea216652d52 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -1030,6 +1030,36 @@ void key_invalidate(struct key *key)
 EXPORT_SYMBOL(key_invalidate);
 
 /**
+ * generic_key_instantiate - Simple instantiation of a key from preparsed data
+ * @key: The key to be instantiated
+ * @prep: The preparsed data to load.
+ *
+ * Instantiate a key from preparsed data.  We assume we can just copy the data
+ * in directly and clear the old pointers.
+ *
+ * This can be pointed to directly by the key type instantiate op pointer.
+ */
+int generic_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
+{
+	int ret;
+
+	pr_devel("==>%s()\n", __func__);
+
+	ret = key_payload_reserve(key, prep->quotalen);
+	if (ret == 0) {
+		key->type_data.p[0] = prep->type_data[0];
+		key->type_data.p[1] = prep->type_data[1];
+		rcu_assign_keypointer(key, prep->payload);
+		prep->type_data[0] = NULL;
+		prep->type_data[1] = NULL;
+		prep->payload = NULL;
+	}
+	pr_devel("<==%s() = %d\n", __func__, ret);
+	return ret;
+}
+EXPORT_SYMBOL(generic_key_instantiate);
+
+/**
  * register_key_type - Register a type of key.
  * @ktype: The new key type.
  *

