Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbaAJN5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 08:57:54 -0500
Received: from mail-qe0-f53.google.com ([209.85.128.53]:46149 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbaAJN5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:57:41 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/14] kernfs: remove KERNFS_ACTIVE_REF and add kernfs_lockdep()
Date: Fri, 10 Jan 2014 08:57:20 -0500
Message-Id: <1389362251-8128-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389362251-8128-1-git-send-email-tj@kernel.org>
References: <1389362251-8128-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There currently are two mechanisms gating active ref lockdep
annotations - KERNFS_LOCKDEP flag and KERNFS_ACTIVE_REF type mask.
The former disables lockdep annotations in kernfs_get/put_active()
while the latter disables all of kernfs_deactivate().

While KERNFS_ACTIVE_REF also behaves as an optimization to skip the
deactivation step for non-file nodes, the benefit is marginal and it
needlessly diverges code paths.  Let's drop KERNFS_ACTIVE_REF and use
KERNFS_LOCKDEP in kernfs_deactivate() too.

While at it, add a test helper kernfs_lockdep() to test KERNFS_LOCKDEP
flag so that it's more convenient and the related code can be compiled
out when not enabled.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c        | 31 ++++++++++++++++++++-----------
 include/linux/kernfs.h |  1 -
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index ed62de6..1c9130a 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -22,6 +22,15 @@ DEFINE_MUTEX(kernfs_mutex);
 
 #define rb_to_kn(X) rb_entry((X), struct kernfs_node, rb)
 
+static bool kernfs_lockdep(struct kernfs_node *kn)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	return kn->flags & KERNFS_LOCKDEP;
+#else
+	return false;
+#endif
+}
+
 /**
  *	kernfs_name_hash
  *	@name: Null terminated string to hash
@@ -138,7 +147,7 @@ struct kernfs_node *kernfs_get_active(struct kernfs_node *kn)
 	if (!atomic_inc_unless_negative(&kn->active))
 		return NULL;
 
-	if (kn->flags & KERNFS_LOCKDEP)
+	if (kernfs_lockdep(kn))
 		rwsem_acquire_read(&kn->dep_map, 0, 1, _RET_IP_);
 	return kn;
 }
@@ -158,7 +167,7 @@ void kernfs_put_active(struct kernfs_node *kn)
 	if (unlikely(!kn))
 		return;
 
-	if (kn->flags & KERNFS_LOCKDEP)
+	if (kernfs_lockdep(kn))
 		rwsem_release(&kn->dep_map, 1, _RET_IP_);
 	v = atomic_dec_return(&kn->active);
 	if (likely(v != KN_DEACTIVATED_BIAS))
@@ -179,21 +188,21 @@ static void kernfs_deactivate(struct kernfs_node *kn)
 
 	BUG_ON(!(kn->flags & KERNFS_REMOVED));
 
-	if (!(kernfs_type(kn) & KERNFS_ACTIVE_REF))
-		return;
-
-	rwsem_acquire(&kn->dep_map, 0, 0, _RET_IP_);
-
 	atomic_add(KN_DEACTIVATED_BIAS, &kn->active);
 
-	if (atomic_read(&kn->active) != KN_DEACTIVATED_BIAS)
-		lock_contended(&kn->dep_map, _RET_IP_);
+	if (kernfs_lockdep(kn)) {
+		rwsem_acquire(&kn->dep_map, 0, 0, _RET_IP_);
+		if (atomic_read(&kn->active) != KN_DEACTIVATED_BIAS)
+			lock_contended(&kn->dep_map, _RET_IP_);
+	}
 
 	wait_event(root->deactivate_waitq,
 		   atomic_read(&kn->active) == KN_DEACTIVATED_BIAS);
 
-	lock_acquired(&kn->dep_map, _RET_IP_);
-	rwsem_release(&kn->dep_map, 1, _RET_IP_);
+	if (kernfs_lockdep(kn)) {
+		lock_acquired(&kn->dep_map, _RET_IP_);
+		rwsem_release(&kn->dep_map, 1, _RET_IP_);
+	}
 }
 
 /**
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 232f1a6..42ad32f 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -34,7 +34,6 @@ enum kernfs_node_type {
 };
 
 #define KERNFS_TYPE_MASK	0x000f
-#define KERNFS_ACTIVE_REF	KERNFS_FILE
 #define KERNFS_FLAG_MASK	~KERNFS_TYPE_MASK
 
 enum kernfs_node_flag {
-- 
1.8.4.2

