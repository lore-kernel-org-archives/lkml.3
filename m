Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab3LCOxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:53:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab3LCOxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:53:19 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH3/5] KEYS: Fix multiple key add into associative array
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org, jmorris@namei.org
Cc: Stephen Gallagher <sgallagh@redhat.com>, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 03 Dec 2013 14:53:13 +0000
Message-ID: <20131203145313.30689.17848.stgit@warthog.procyon.org.uk>
In-Reply-To: <20131203145250.30689.28039.stgit@warthog.procyon.org.uk>
References: <20131203145250.30689.28039.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If sufficient keys (or keyrings) are added into a keyring such that a node in
the associative array's tree overflows (each node has a capacity N, currently
16) and such that all N+1 keys have the same index key segment for that level
of the tree (the level'th nibble of the index key), then assoc_array_insert()
calls ops->diff_objects() to indicate at which bit position the two index keys
vary.

However, __key_link_begin() passes a NULL object to assoc_array_insert() with
the intention of supplying the correct pointer later before we commit the
change.  This means that keyring_diff_objects() is given a NULL pointer as one
of its arguments which it does not expect.  This results in an oops like the
attached.

With the previous patch to fix the keyring hash function, this can be forced
much more easily by creating a keyring and only adding keyrings to it.  Add any
other sort of key and a different insertion path is taken - all 16+1 objects
must want to cluster in the same node slot.

This can be tested by:

	r=`keyctl newring sandbox @s`
	for ((i=0; i<=16; i++)); do keyctl newring ring$i $r; done

This should work fine, but oopses when the 17th keyring is added.

Since ops->diff_objects() is always called with the first pointer pointing to
the object to be inserted (ie. the NULL pointer), we can fix the problem by
changing the to-be-inserted object pointer to point to the index key passed
into assoc_array_insert() instead.

Whilst we're at it, we also switch the arguments so that they are the same as
for ->compare_object().

BUG: unable to handle kernel NULL pointer dereference at 0000000000000088
IP: [<ffffffff81191ee4>] hash_key_type_and_desc+0x18/0xb0
...
RIP: 0010:[<ffffffff81191ee4>] hash_key_type_and_desc+0x18/0xb0
...
Call Trace:
 [<ffffffff81191f9d>] keyring_diff_objects+0x21/0xd2
 [<ffffffff811f09ef>] assoc_array_insert+0x3b6/0x908
 [<ffffffff811929a7>] __key_link_begin+0x78/0xe5
 [<ffffffff81191a2e>] key_create_or_update+0x17d/0x36a
 [<ffffffff81192e0a>] SyS_add_key+0x123/0x183
 [<ffffffff81400ddb>] tracesys+0xdd/0xe2

Signed-off-by: David Howells <dhowells@redhat.com>
Tested-by: Stephen Gallagher <sgallagh@redhat.com>
---

 Documentation/assoc_array.txt |    6 +++---
 include/linux/assoc_array.h   |    6 +++---
 lib/assoc_array.c             |    4 ++--
 security/keys/keyring.c       |    7 +++----
 4 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/Documentation/assoc_array.txt b/Documentation/assoc_array.txt
index f4faec0f66e4..2f2c6cdd73c0 100644
--- a/Documentation/assoc_array.txt
+++ b/Documentation/assoc_array.txt
@@ -164,10 +164,10 @@ This points to a number of methods, all of which need to be provided:
 
  (4) Diff the index keys of two objects.
 
-	int (*diff_objects)(const void *a, const void *b);
+	int (*diff_objects)(const void *object, const void *index_key);
 
-     Return the bit position at which the index keys of two objects differ or
-     -1 if they are the same.
+     Return the bit position at which the index key of the specified object
+     differs from the given index key or -1 if they are the same.
 
 
  (5) Free an object.
diff --git a/include/linux/assoc_array.h b/include/linux/assoc_array.h
index 9a193b84238a..a89df3be1686 100644
--- a/include/linux/assoc_array.h
+++ b/include/linux/assoc_array.h
@@ -41,10 +41,10 @@ struct assoc_array_ops {
 	/* Is this the object we're looking for? */
 	bool (*compare_object)(const void *object, const void *index_key);
 
-	/* How different are two objects, to a bit position in their keys? (or
-	 * -1 if they're the same)
+	/* How different is an object from an index key, to a bit position in
+	 * their keys? (or -1 if they're the same)
 	 */
-	int (*diff_objects)(const void *a, const void *b);
+	int (*diff_objects)(const void *object, const void *index_key);
 
 	/* Method to free an object. */
 	void (*free_object)(void *object);
diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index 17edeaf19180..1b6a44f1ec3e 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -759,8 +759,8 @@ all_leaves_cluster_together:
 	pr_devel("all leaves cluster together\n");
 	diff = INT_MAX;
 	for (i = 0; i < ASSOC_ARRAY_FAN_OUT; i++) {
-		int x = ops->diff_objects(assoc_array_ptr_to_leaf(edit->leaf),
-					  assoc_array_ptr_to_leaf(node->slots[i]));
+		int x = ops->diff_objects(assoc_array_ptr_to_leaf(node->slots[i]),
+					  index_key);
 		if (x < diff) {
 			BUG_ON(x < 0);
 			diff = x;
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 0adbc77a59b9..3dd8445cd489 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -279,12 +279,11 @@ static bool keyring_compare_object(const void *object, const void *data)
  * Compare the index keys of a pair of objects and determine the bit position
  * at which they differ - if they differ.
  */
-static int keyring_diff_objects(const void *_a, const void *_b)
+static int keyring_diff_objects(const void *object, const void *data)
 {
-	const struct key *key_a = keyring_ptr_to_key(_a);
-	const struct key *key_b = keyring_ptr_to_key(_b);
+	const struct key *key_a = keyring_ptr_to_key(object);
 	const struct keyring_index_key *a = &key_a->index_key;
-	const struct keyring_index_key *b = &key_b->index_key;
+	const struct keyring_index_key *b = data;
 	unsigned long seg_a, seg_b;
 	int level, i;
 

