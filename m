Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbaAJOBb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 09:01:31 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:62904 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbaAJN5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:57:48 -0500
From: Tejun Heo <tj@kernel.org>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, stern@rowland.harvard.edu,
        JBottomley@parallels.com, bhelgaas@google.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/14] kernfs: make kernfs_get_active() block if the node is deactivated but not removed
Date: Fri, 10 Jan 2014 08:57:25 -0500
Message-Id: <1389362251-8128-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389362251-8128-1-git-send-email-tj@kernel.org>
References: <1389362251-8128-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, kernfs_get_active() fails if the target node is
deactivated.  This is fine as a node always gets removed after
deactivation; however, we're gonna add reactivation so the assumption
won't hold.  It'd be incorrect for kernfs_get_active() to fail for a
node which was deactivated only temporarily.

This patch makes kernfs_get_active() block if the node is deactivated
but not removed.  If the node gets reactivated (not yet implemented),
it will be retried and succeed.  If the node gets removed, it will be
woken up and fail.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 770d687..37dd640 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -149,12 +149,25 @@ struct kernfs_node *kernfs_get_active(struct kernfs_node *kn)
 	if (unlikely(!kn))
 		return NULL;
 
-	if (!atomic_inc_unless_negative(&kn->active))
-		return NULL;
-
 	if (kernfs_lockdep(kn))
 		rwsem_acquire_read(&kn->dep_map, 0, 1, _RET_IP_);
-	return kn;
+
+	/*
+	 * Try to obtain an active ref.  If @kn is deactivated, we block
+	 * till either it's reactivated or killed.
+	 */
+	do {
+		if (atomic_inc_unless_negative(&kn->active))
+			return kn;
+
+		wait_event(kernfs_root(kn)->deactivate_waitq,
+			   atomic_read(&kn->active) >= 0 ||
+			   RB_EMPTY_NODE(&kn->rb));
+	} while (!RB_EMPTY_NODE(&kn->rb));
+
+	if (kernfs_lockdep(kn))
+		rwsem_release(&kn->dep_map, 1, _RET_IP_);
+	return NULL;
 }
 
 /**
@@ -786,6 +799,7 @@ static void __kernfs_deactivate(struct kernfs_node *kn)
 
 static void __kernfs_remove(struct kernfs_node *kn)
 {
+	struct kernfs_root *root = kernfs_root(kn);
 	struct kernfs_node *pos;
 
 	lockdep_assert_held(&kernfs_mutex);
@@ -837,6 +851,9 @@ static void __kernfs_remove(struct kernfs_node *kn)
 
 		kernfs_put(pos);
 	} while (pos != kn);
+
+	/* some nodes killed, kick get_active waiters */
+	wake_up_all(&root->deactivate_waitq);
 }
 
 /**
-- 
1.8.4.2

