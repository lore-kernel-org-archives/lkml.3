Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934035AbaKMTZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:25:24 -0500
Received: from mail-yh0-f53.google.com ([209.85.213.53]:40655 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933762AbaKMTZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:25:21 -0500
From: Pranith Kumar <bobby.prani@gmail.com>
To: David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Stephen Hemminger <shemming@brocade.com>,
        Andreea-Cristina Bernat <bernat.ada@gmail.com>,
        linux-kernel@vger.kernel.org (open list),
        keyrings@linux-nfs.org (open list:KEYS/KEYRINGS:),
        linux-security-module@vger.kernel.org (open list:SECURITY SUBSYSTEM)
Cc: paulmck@linux.vnet.ibm.com
Subject: [PATCH 06/16] assoc_array: Replace smp_read_barrier_depends() with lockless_dereference()
Date: Thu, 13 Nov 2014 14:24:12 -0500
Message-Id: <1415906662-4576-7-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
References: <1415906662-4576-1-git-send-email-bobby.prani@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently lockless_dereference() was added which can be used in place of
hard-coding smp_read_barrier_depends(). The following PATCH makes the change.

I replaced the inline functions dereferencing pointer 'x' to use
lockless_dereference() because of which we do not need to litter the code with
smp_read_barrier_depends().

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 include/linux/assoc_array_priv.h | 11 +++++++----
 lib/assoc_array.c                |  7 -------
 security/keys/keyring.c          |  6 ------
 3 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/include/linux/assoc_array_priv.h b/include/linux/assoc_array_priv.h
index 711275e..96449c3 100644
--- a/include/linux/assoc_array_priv.h
+++ b/include/linux/assoc_array_priv.h
@@ -118,7 +118,8 @@ struct assoc_array_edit {
 
 static inline bool assoc_array_ptr_is_meta(const struct assoc_array_ptr *x)
 {
-	return (unsigned long)x & ASSOC_ARRAY_PTR_TYPE_MASK;
+	return (unsigned long)lockless_dereference(x) &
+						ASSOC_ARRAY_PTR_TYPE_MASK;
 }
 static inline bool assoc_array_ptr_is_leaf(const struct assoc_array_ptr *x)
 {
@@ -126,7 +127,8 @@ static inline bool assoc_array_ptr_is_leaf(const struct assoc_array_ptr *x)
 }
 static inline bool assoc_array_ptr_is_shortcut(const struct assoc_array_ptr *x)
 {
-	return (unsigned long)x & ASSOC_ARRAY_PTR_SUBTYPE_MASK;
+	return (unsigned long)lockless_dereference(x) &
+						ASSOC_ARRAY_PTR_SUBTYPE_MASK;
 }
 static inline bool assoc_array_ptr_is_node(const struct assoc_array_ptr *x)
 {
@@ -135,13 +137,14 @@ static inline bool assoc_array_ptr_is_node(const struct assoc_array_ptr *x)
 
 static inline void *assoc_array_ptr_to_leaf(const struct assoc_array_ptr *x)
 {
-	return (void *)((unsigned long)x & ~ASSOC_ARRAY_PTR_TYPE_MASK);
+	return (void *)((unsigned long)lockless_dereference(x) &
+						~ASSOC_ARRAY_PTR_TYPE_MASK);
 }
 
 static inline
 unsigned long __assoc_array_ptr_to_meta(const struct assoc_array_ptr *x)
 {
-	return (unsigned long)x &
+	return (unsigned long)lockless_dereference(x) &
 		~(ASSOC_ARRAY_PTR_SUBTYPE_MASK | ASSOC_ARRAY_PTR_TYPE_MASK);
 }
 static inline
diff --git a/lib/assoc_array.c b/lib/assoc_array.c
index 2404d03..5b62033 100644
--- a/lib/assoc_array.c
+++ b/lib/assoc_array.c
@@ -37,12 +37,10 @@ begin_node:
 	if (assoc_array_ptr_is_shortcut(cursor)) {
 		/* Descend through a shortcut */
 		shortcut = assoc_array_ptr_to_shortcut(cursor);
-		smp_read_barrier_depends();
 		cursor = ACCESS_ONCE(shortcut->next_node);
 	}
 
 	node = assoc_array_ptr_to_node(cursor);
-	smp_read_barrier_depends();
 	slot = 0;
 
 	/* We perform two passes of each node.
@@ -85,7 +83,6 @@ begin_node:
 
 continue_node:
 	node = assoc_array_ptr_to_node(cursor);
-	smp_read_barrier_depends();
 
 	for (; slot < ASSOC_ARRAY_FAN_OUT; slot++) {
 		ptr = ACCESS_ONCE(node->slots[slot]);
@@ -104,7 +101,6 @@ finished_node:
 
 	if (assoc_array_ptr_is_shortcut(parent)) {
 		shortcut = assoc_array_ptr_to_shortcut(parent);
-		smp_read_barrier_depends();
 		cursor = parent;
 		parent = ACCESS_ONCE(shortcut->back_pointer);
 		slot = shortcut->parent_slot;
@@ -215,7 +211,6 @@ jumped:
 
 consider_node:
 	node = assoc_array_ptr_to_node(cursor);
-	smp_read_barrier_depends();
 
 	slot = segments >> (level & ASSOC_ARRAY_KEY_CHUNK_MASK);
 	slot &= ASSOC_ARRAY_FAN_MASK;
@@ -253,7 +248,6 @@ consider_node:
 	cursor = ptr;
 follow_shortcut:
 	shortcut = assoc_array_ptr_to_shortcut(cursor);
-	smp_read_barrier_depends();
 	pr_devel("shortcut to %d\n", shortcut->skip_to_level);
 	sc_level = level + ASSOC_ARRAY_LEVEL_STEP;
 	BUG_ON(sc_level > shortcut->skip_to_level);
@@ -343,7 +337,6 @@ void *assoc_array_find(const struct assoc_array *array,
 			 * actually going to dereference it.
 			 */
 			leaf = assoc_array_ptr_to_leaf(ptr);
-			smp_read_barrier_depends();
 			if (ops->compare_object(leaf, index_key))
 				return (void *)leaf;
 		}
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 8177010..48d3464 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -683,7 +683,6 @@ descend_to_keyring:
 		 * doesn't contain any keyring pointers.
 		 */
 		shortcut = assoc_array_ptr_to_shortcut(ptr);
-		smp_read_barrier_depends();
 		if ((shortcut->index_key[0] & ASSOC_ARRAY_FAN_MASK) != 0)
 			goto not_this_keyring;
 
@@ -693,7 +692,6 @@ descend_to_keyring:
 	}
 
 	node = assoc_array_ptr_to_node(ptr);
-	smp_read_barrier_depends();
 
 	ptr = node->slots[0];
 	if (!assoc_array_ptr_is_meta(ptr))
@@ -706,7 +704,6 @@ descend_to_node:
 	kdebug("descend");
 	if (assoc_array_ptr_is_shortcut(ptr)) {
 		shortcut = assoc_array_ptr_to_shortcut(ptr);
-		smp_read_barrier_depends();
 		ptr = ACCESS_ONCE(shortcut->next_node);
 		BUG_ON(!assoc_array_ptr_is_node(ptr));
 	}
@@ -714,7 +711,6 @@ descend_to_node:
 
 begin_node:
 	kdebug("begin_node");
-	smp_read_barrier_depends();
 	slot = 0;
 ascend_to_node:
 	/* Go through the slots in a node */
@@ -762,14 +758,12 @@ ascend_to_node:
 
 	if (ptr && assoc_array_ptr_is_shortcut(ptr)) {
 		shortcut = assoc_array_ptr_to_shortcut(ptr);
-		smp_read_barrier_depends();
 		ptr = ACCESS_ONCE(shortcut->back_pointer);
 		slot = shortcut->parent_slot;
 	}
 	if (!ptr)
 		goto not_this_keyring;
 	node = assoc_array_ptr_to_node(ptr);
-	smp_read_barrier_depends();
 	slot++;
 
 	/* If we've ascended to the root (zero backpointer), we must have just
-- 
1.9.1

