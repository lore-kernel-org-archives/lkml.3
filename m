Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758414AbaIOUqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:46:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757366AbaIOUpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 16:45:39 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 07/10] KEYS: Implement binary asymmetric key ID handling
 [ver #2]
From: David Howells <dhowells@redhat.com>
To: vgoyal@redhat.com
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Mon, 15 Sep 2014 21:45:33 +0100
Message-ID: <20140915204533.27499.32101.stgit@warthog.procyon.org.uk>
In-Reply-To: <20140915204456.27499.40234.stgit@warthog.procyon.org.uk>
References: <20140915204456.27499.40234.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the first step in using binary key IDs for asymmetric keys rather
than hex string keys.

The previously added match data preparsing will be able to convert hex
criterion strings into binary which can then be compared more rapidly.

Further, we actually want more then one ID string per public key.  The problem
is that X.509 certs refer to other X.509 certs by matching Issuer + AuthKeyId
to Subject + SubjKeyId, but PKCS#7 messages match against X.509 Issuer +
SerialNumber.

This patch just provides facilities for a later patch to make use of.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 crypto/asymmetric_keys/asymmetric_keys.h |    4 +
 crypto/asymmetric_keys/asymmetric_type.c |   89 ++++++++++++++++++++++++++++++
 include/keys/asymmetric-type.h           |   38 +++++++++++++
 3 files changed, 131 insertions(+)

diff --git a/crypto/asymmetric_keys/asymmetric_keys.h b/crypto/asymmetric_keys/asymmetric_keys.h
index a63c551c6557..917be6b985e7 100644
--- a/crypto/asymmetric_keys/asymmetric_keys.h
+++ b/crypto/asymmetric_keys/asymmetric_keys.h
@@ -10,6 +10,10 @@
  */
 
 int asymmetric_keyid_match(const char *kid, const char *id);
+extern bool asymmetric_match_key_ids(const struct asymmetric_key_ids *kids,
+				     const struct asymmetric_key_id *match_id);
+
+extern struct asymmetric_key_id *asymmetric_key_hex_to_key_id(const char *id);
 
 static inline const char *asymmetric_key_id(const struct key *key)
 {
diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index 7755f918e8d9..92bfc438dd1d 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -15,6 +15,7 @@
 #include <linux/seq_file.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/ctype.h>
 #include "asymmetric_keys.h"
 
 MODULE_LICENSE("GPL");
@@ -22,6 +23,94 @@ MODULE_LICENSE("GPL");
 static LIST_HEAD(asymmetric_key_parsers);
 static DECLARE_RWSEM(asymmetric_key_parsers_sem);
 
+/**
+ * asymmetric_key_generate_id: Construct an asymmetric key ID
+ * @val_1: First binary blob
+ * @len_1: Length of first binary blob
+ * @val_2: Second binary blob
+ * @len_2: Length of second binary blob
+ *
+ * Construct an asymmetric key ID from a pair of binary blobs.
+ */
+struct asymmetric_key_id *asymmetric_key_generate_id(const void *val_1,
+						     size_t len_1,
+						     const void *val_2,
+						     size_t len_2)
+{
+	struct asymmetric_key_id *kid;
+
+	kid = kmalloc(sizeof(struct asymmetric_key_id) + len_1 + len_2,
+		      GFP_KERNEL);
+	if (!kid)
+		return ERR_PTR(-ENOMEM);
+	kid->len = len_1 + len_2;
+	memcpy(kid->data, val_1, len_1);
+	memcpy(kid->data + len_1, val_2, len_2);
+	return kid;
+}
+EXPORT_SYMBOL_GPL(asymmetric_key_generate_id);
+
+/**
+ * asymmetric_key_id_same - Return true if two asymmetric keys IDs are the same.
+ * @kid_1, @kid_2: The key IDs to compare
+ */
+bool asymmetric_key_id_same(const struct asymmetric_key_id *kid1,
+			    const struct asymmetric_key_id *kid2)
+{
+	if (!kid1 || !kid2)
+		return false;
+	if (kid1->len != kid2->len)
+		return false;
+	return memcmp(kid1->data, kid2->data, kid1->len) == 0;
+}
+EXPORT_SYMBOL_GPL(asymmetric_key_id_same);
+
+/**
+ * asymmetric_match_key_ids - Search asymmetric key IDs
+ * @kids: The list of key IDs to check
+ * @match_id: The key ID we're looking for
+ */
+bool asymmetric_match_key_ids(const struct asymmetric_key_ids *kids,
+			      const struct asymmetric_key_id *match_id)
+{
+	if (!kids || !match_id)
+		return false;
+	if (asymmetric_key_id_same(kids->id[0], match_id))
+		return true;
+	if (asymmetric_key_id_same(kids->id[1], match_id))
+		return true;
+	return false;
+}
+EXPORT_SYMBOL_GPL(asymmetric_match_key_ids);
+
+/**
+ * asymmetric_key_hex_to_key_id - Convert a hex string into a key ID.
+ * @id: The ID as a hex string.
+ */
+struct asymmetric_key_id *asymmetric_key_hex_to_key_id(const char *id)
+{
+	struct asymmetric_key_id *match_id;
+	const char *p;
+	ptrdiff_t hexlen;
+
+	if (!*id)
+		return ERR_PTR(-EINVAL);
+	for (p = id; *p; p++)
+		if (!isxdigit(*p))
+			return ERR_PTR(-EINVAL);
+	hexlen = p - id;
+	if (hexlen & 1)
+		return ERR_PTR(-EINVAL);
+
+	match_id = kmalloc(sizeof(struct asymmetric_key_id) + hexlen / 2,
+			   GFP_KERNEL);
+	if (!match_id)
+		return ERR_PTR(-ENOMEM);
+	match_id->len = hexlen / 2;
+	(void)hex2bin(match_id->data, id, hexlen / 2);
+	return match_id;
+}
+
 /*
  * Match asymmetric key id with partial match
  * @id:		key id to match in a form "id:<id>"
diff --git a/include/keys/asymmetric-type.h b/include/keys/asymmetric-type.h
index 7dd473496180..044ab0d3aa45 100644
--- a/include/keys/asymmetric-type.h
+++ b/include/keys/asymmetric-type.h
@@ -19,6 +19,44 @@
 extern struct key_type key_type_asymmetric;
 
 /*
+ * Identifiers for an asymmetric key ID.  We have three ways of looking up a
+ * key derived from an X.509 certificate:
+ *
+ * (1) Serial Number & Issuer.  Non-optional.  This is the only valid way to
+ *     map a PKCS#7 signature to an X.509 certificate.
+ *
+ * (2) Issuer & Subject Unique IDs.  Optional.  These were the original way to
+ *     match X.509 certificates, but have fallen into disuse in favour of (3).
+ *
+ * (3) Auth & Subject Key Identifiers.  Optional.  SKIDs are only provided on
+ *     CA keys that are intended to sign other keys, so don't appear in end
+ *     user certificates unless forced.
+ *
+ * We could also support an PGP key identifier, which is just a SHA1 sum of the
+ * public key and certain parameters, but since we don't support PGP keys at
+ * the moment, we shall ignore those.
+ *
+ * What we actually do is provide a place where binary identifiers can be
+ * stashed and then compare against them when checking for an id match.
+ */
+struct asymmetric_key_id {
+	unsigned short	len;
+	unsigned char	data[];
+};
+
+struct asymmetric_key_ids {
+	void		*id[2];
+};
+
+extern bool asymmetric_key_id_same(const struct asymmetric_key_id *kid1,
+				   const struct asymmetric_key_id *kid2);
+
+extern struct asymmetric_key_id *asymmetric_key_generate_id(const void *val_1,
+							    size_t len_1,
+							    const void *val_2,
+							    size_t len_2);
+
+/*
  * The payload is at the discretion of the subtype.
  */
 

