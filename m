Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537AbaCTPXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:23:14 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:46834 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146AbaCTPXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:23:10 -0400
Date: Thu, 20 Mar 2014 11:23:06 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH cgroup/for-3.15] cgroup: break kernfs active_ref protection
 in cgroup directory operations
Message-ID: <20140320152306.GA8791@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e1b2dc176f2d5be7952c47a4e4e8f3b06a90db1c Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 20 Mar 2014 11:10:15 -0400

cgroup_tree_mutex should nest above the kernfs active_ref protection;
however, cgroup_create() and cgroup_rename() were grabbing
cgroup_tree_mutex while under kernfs active_ref protection.  This has
actualy possibility to lead to deadlocks in case these operations race
against cgroup_rmdir() which invokes kernfs_remove() on directory
kernfs_node while holding cgroup_tree_mutex.

Neither cgroup_create() or cgroup_rename() requires active_ref
protection.  The former already has enough synchronization through
cgroup_lock_live_group() and the latter doesn't care, so this can be
fixed by updating both functions to break all active_ref protections
before grabbing cgroup_tree_mutex.

While this patch fixes the immediate issue, it probably needs further
work in the long term - kernfs directories should enable lockdep
annotations and maybe the better way to handle this is marking
directory nodes as not needing active_ref protection rather than
breaking it in each operation.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Hey,

Another last minute fix that I just committed.  I'm thinking maybe the
right thing to do for cgroup directories is implementing a flag
similar KERNFS_NO_ACTIVE_REF, which achieves similar thing but doesn't
require each operation to break protection explicitly.  Anyways, this
should be enough for now.

Thanks!

 kernel/cgroup.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 98a8045..58c67b3 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2324,6 +2324,14 @@ static int cgroup_rename(struct kernfs_node *kn, struct kernfs_node *new_parent,
 	if (cgroup_sane_behavior(cgrp))
 		return -EPERM;
 
+	/*
+	 * We're gonna grab cgroup_tree_mutex which nests outside kernfs
+	 * active_ref.  kernfs_rename() doesn't require active_ref
+	 * protection.  Break them before grabbing cgroup_tree_mutex.
+	 */
+	kernfs_break_active_protection(new_parent);
+	kernfs_break_active_protection(kn);
+
 	mutex_lock(&cgroup_tree_mutex);
 	mutex_lock(&cgroup_mutex);
 
@@ -2331,6 +2339,9 @@ static int cgroup_rename(struct kernfs_node *kn, struct kernfs_node *new_parent,
 
 	mutex_unlock(&cgroup_mutex);
 	mutex_unlock(&cgroup_tree_mutex);
+
+	kernfs_unbreak_active_protection(kn);
+	kernfs_unbreak_active_protection(new_parent);
 	return ret;
 }
 
@@ -3778,8 +3789,22 @@ static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,
 			umode_t mode)
 {
 	struct cgroup *parent = parent_kn->priv;
+	int ret;
 
-	return cgroup_create(parent, name, mode);
+	/*
+	 * cgroup_create() grabs cgroup_tree_mutex which nests outside
+	 * kernfs active_ref and cgroup_create() already synchronizes
+	 * properly against removal through cgroup_lock_live_group().
+	 * Break it before calling cgroup_create().
+	 */
+	cgroup_get(parent);
+	kernfs_break_active_protection(parent_kn);
+
+	ret = cgroup_create(parent, name, mode);
+
+	kernfs_unbreak_active_protection(parent_kn);
+	cgroup_put(parent);
+	return ret;
 }
 
 /*
-- 
1.8.5.3

