Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035AbaEIVd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:33:28 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:64808 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757973AbaEIVbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:31:51 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/14] cgroup: use CSS_ONLINE instead of CGRP_DEAD
Date: Fri,  9 May 2014 17:31:28 -0400
Message-Id: <1399671091-23867-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399671091-23867-1-git-send-email-tj@kernel.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use CSS_ONLINE on the self css to indicate whether a cgroup has been
killed instead of CGRP_DEAD.  This will allow re-using css online test
for cgroup liveliness test.  This doesn't introduce any functional
change.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h | 2 --
 kernel/cgroup.c        | 7 ++++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 58867ed..2cf2063 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -138,8 +138,6 @@ static inline void css_put(struct cgroup_subsys_state *css)
 
 /* bits in struct cgroup flags field */
 enum {
-	/* Control Group is dead */
-	CGRP_DEAD,
 	/*
 	 * Control Group has previously had a child cgroup or a task,
 	 * but no longer (only if CGRP_NOTIFY_ON_RELEASE is set)
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e0953f7..a0cfe36 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -278,7 +278,7 @@ static struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgrp,
 /* convenient tests for these bits */
 static inline bool cgroup_is_dead(const struct cgroup *cgrp)
 {
-	return test_bit(CGRP_DEAD, &cgrp->flags);
+	return !(cgrp->self.flags & CSS_ONLINE);
 }
 
 struct cgroup_subsys_state *of_css(struct kernfs_open_file *of)
@@ -1518,6 +1518,7 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	INIT_LIST_HEAD(&cgrp->pidlists);
 	mutex_init(&cgrp->pidlist_mutex);
 	cgrp->self.cgroup = cgrp;
+	cgrp->self.flags |= CSS_ONLINE;
 
 	for_each_subsys(ss, ssid)
 		INIT_LIST_HEAD(&cgrp->e_csets[ssid]);
@@ -4540,13 +4541,13 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	 * Mark @cgrp dead.  This prevents further task migration and child
 	 * creation by disabling cgroup_lock_live_group().
 	 */
-	set_bit(CGRP_DEAD, &cgrp->flags);
+	cgrp->self.flags &= ~CSS_ONLINE;
 
 	/* initiate massacre of all css's */
 	for_each_css(css, ssid, cgrp)
 		kill_css(css);
 
-	/* CGRP_DEAD is set, remove from ->release_list for the last time */
+	/* CSS_ONLINE is clear, remove from ->release_list for the last time */
 	raw_spin_lock(&release_list_lock);
 	if (!list_empty(&cgrp->release_list))
 		list_del_init(&cgrp->release_list);
-- 
1.9.0

