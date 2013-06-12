Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab3FLVEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 17:04:36 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:46637 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758111Ab3FLVDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 17:03:50 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        koverstreet@google.com, linux-kernel@vger.kernel.org,
        cl@linux-foundation.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/11] cgroup: reorder the operations in cgroup_destroy_locked()
Date: Wed, 12 Jun 2013 14:03:14 -0700
Message-Id: <1371070996-20613-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1371070996-20613-1-git-send-email-tj@kernel.org>
References: <1371070996-20613-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch reorders the operations in cgroup_destroy_locked() such
that the userland visible parts happen before css offlining and
removal from the ->sibling list.  This will be used to make css use
percpu refcnt.

While at it, split out CGRP_DEAD related comment from the refcnt
deactivation one and correct / clarify how different guarantees are
met.

While this patch changes the specific order of operations, it
shouldn't cause any noticeable behavior difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 61 +++++++++++++++++++++++++++++++++------------------------
 1 file changed, 35 insertions(+), 26 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index aefda90..a43bc9d 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4382,13 +4382,8 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 
 	/*
 	 * Block new css_tryget() by deactivating refcnt and mark @cgrp
-	 * removed.  This makes future css_tryget() and child creation
-	 * attempts fail thus maintaining the removal conditions verified
-	 * above.
-	 *
-	 * Note that CGRP_DEAD assertion is depended upon by
-	 * cgroup_next_sibling() to resume iteration after dropping RCU
-	 * read lock.  See cgroup_next_sibling() for details.
+	 * removed.  This makes future css_tryget() attempts fail which we
+	 * guarantee to ->css_offline() callbacks.
 	 */
 	for_each_subsys(cgrp->root, ss) {
 		struct cgroup_subsys_state *css = cgrp->subsys[ss->subsys_id];
@@ -4396,8 +4391,41 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 		WARN_ON(atomic_read(&css->refcnt) < 0);
 		atomic_add(CSS_DEACT_BIAS, &css->refcnt);
 	}
+
+	/*
+	 * Mark @cgrp dead.  This prevents further task migration and child
+	 * creation by disabling cgroup_lock_live_group().  Note that
+	 * CGRP_DEAD assertion is depended upon by cgroup_next_sibling() to
+	 * resume iteration after dropping RCU read lock.  See
+	 * cgroup_next_sibling() for details.
+	 */
 	set_bit(CGRP_DEAD, &cgrp->flags);
 
+	/* CGRP_DEAD is set, remove from ->release_list for the last time */
+	raw_spin_lock(&release_list_lock);
+	if (!list_empty(&cgrp->release_list))
+		list_del_init(&cgrp->release_list);
+	raw_spin_unlock(&release_list_lock);
+
+	/*
+	 * Remove @cgrp directory.  The removal puts the base ref but we
+	 * aren't quite done with @cgrp yet, so hold onto it.
+	 */
+	dget(d);
+	cgroup_d_remove_dir(d);
+
+	/*
+	 * Unregister events and notify userspace.
+	 * Notify userspace about cgroup removing only after rmdir of cgroup
+	 * directory to avoid race between userspace and kernelspace.
+	 */
+	spin_lock(&cgrp->event_list_lock);
+	list_for_each_entry_safe(event, tmp, &cgrp->event_list, list) {
+		list_del_init(&event->list);
+		schedule_work(&event->remove);
+	}
+	spin_unlock(&cgrp->event_list_lock);
+
 	/* tell subsystems to initate destruction */
 	for_each_subsys(cgrp->root, ss)
 		offline_css(ss, cgrp);
@@ -4412,34 +4440,15 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	for_each_subsys(cgrp->root, ss)
 		css_put(cgrp->subsys[ss->subsys_id]);
 
-	raw_spin_lock(&release_list_lock);
-	if (!list_empty(&cgrp->release_list))
-		list_del_init(&cgrp->release_list);
-	raw_spin_unlock(&release_list_lock);
-
 	/* delete this cgroup from parent->children */
 	list_del_rcu(&cgrp->sibling);
 	list_del_init(&cgrp->allcg_node);
 
-	dget(d);
-	cgroup_d_remove_dir(d);
 	dput(d);
 
 	set_bit(CGRP_RELEASABLE, &parent->flags);
 	check_for_release(parent);
 
-	/*
-	 * Unregister events and notify userspace.
-	 * Notify userspace about cgroup removing only after rmdir of cgroup
-	 * directory to avoid race between userspace and kernelspace.
-	 */
-	spin_lock(&cgrp->event_list_lock);
-	list_for_each_entry_safe(event, tmp, &cgrp->event_list, list) {
-		list_del_init(&event->list);
-		schedule_work(&event->remove);
-	}
-	spin_unlock(&cgrp->event_list_lock);
-
 	return 0;
 }
 
-- 
1.8.2.1

