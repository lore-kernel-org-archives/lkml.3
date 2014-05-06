Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592AbaEFMon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:44:43 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:36114 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757558AbaEFMoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:44:38 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
        axboe@kernel.dk, hannes@cmpxchg.org, mhocko@suse.cz,
        arozansk@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/5] cgroup: remove cgroup->control_kn
Date: Tue,  6 May 2014 08:44:26 -0400
Message-Id: <1399380266-3324-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399380266-3324-1-git-send-email-tj@kernel.org>
References: <1399380266-3324-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that cgroup_subtree_control_write() has access to the associated
kernfs_open_file and thus the kernfs_node, there's no need to cache it
in cgroup->control_kn on creation.  Remove cgroup->control_kn and use
@of->kn directly.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 1 -
 kernel/cgroup.c        | 8 +++-----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index f8cfadb..037fa80 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -179,7 +179,6 @@ struct cgroup {
 
 	struct cgroup *parent;		/* my parent */
 	struct kernfs_node *kn;		/* cgroup kernfs entry */
-	struct kernfs_node *control_kn;	/* kn for "cgroup.subtree_control" */
 	struct kernfs_node *populated_kn; /* kn for "cgroup.subtree_populated" */
 
 	/*
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 06ad484..eeb4b62 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2578,7 +2578,7 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 	 * active_ref protection.
 	 */
 	cgroup_get(cgrp);
-	kernfs_break_active_protection(cgrp->control_kn);
+	kernfs_break_active_protection(of->kn);
 
 	mutex_lock(&cgroup_tree_mutex);
 
@@ -2695,7 +2695,7 @@ out_unlock:
 out_unlock_tree:
 	mutex_unlock(&cgroup_tree_mutex);
 out_unbreak:
-	kernfs_unbreak_active_protection(cgrp->control_kn);
+	kernfs_unbreak_active_protection(of->kn);
 	cgroup_put(cgrp);
 	return ret ?: nbytes;
 
@@ -2885,9 +2885,7 @@ static int cgroup_add_file(struct cgroup *cgrp, struct cftype *cft)
 		return ret;
 	}
 
-	if (cft->seq_show == cgroup_subtree_control_show)
-		cgrp->control_kn = kn;
-	else if (cft->seq_show == cgroup_populated_show)
+	if (cft->seq_show == cgroup_populated_show)
 		cgrp->populated_kn = kn;
 	return 0;
 }
-- 
1.9.0

