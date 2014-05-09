Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbaEIVPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:15:04 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:38556 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757382AbaEIVNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:13:47 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/9] cgroup: remove cgroup_destory_css_killed()
Date: Fri,  9 May 2014 17:13:32 -0400
Message-Id: <1399670015-23463-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399670015-23463-1-git-send-email-tj@kernel.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_destroy_css_killed() is cgroup destruction stage which happens
after all csses are offlined.  After the recent updates, it no longer
does anything other than putting the base reference.  This patch
removes the function and makes cgroup_destroy_locked() put the base
ref at the end isntead.

This also makes cgroup->nr_css unnecessary.  Removed.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  3 ---
 kernel/cgroup.c        | 62 +++++---------------------------------------------
 2 files changed, 6 insertions(+), 59 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 164851e..160fcc6 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -158,9 +158,6 @@ struct cgroup {
 	 */
 	int id;
 
-	/* the number of attached css's */
-	int nr_css;
-
 	/*
 	 * If this cgroup contains any tasks, it contributes one to
 	 * populated_cnt.  All children with non-zero popuplated_cnt of
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 87ea2ce..bb67acb 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -178,7 +178,6 @@ static struct cftype cgroup_base_files[];
 static void cgroup_put(struct cgroup *cgrp);
 static int rebind_subsystems(struct cgroup_root *dst_root,
 			     unsigned int ss_mask);
-static void cgroup_destroy_css_killed(struct cgroup *cgrp);
 static int cgroup_destroy_locked(struct cgroup *cgrp);
 static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss);
 static void kill_css(struct cgroup_subsys_state *css);
@@ -4168,7 +4167,6 @@ static int online_css(struct cgroup_subsys_state *css)
 		ret = ss->css_online(css);
 	if (!ret) {
 		css->flags |= CSS_ONLINE;
-		css->cgroup->nr_css++;
 		rcu_assign_pointer(css->cgroup->subsys[ss->id], css);
 	}
 	return ret;
@@ -4188,7 +4186,6 @@ static void offline_css(struct cgroup_subsys_state *css)
 		ss->css_offline(css);
 
 	css->flags &= ~CSS_ONLINE;
-	css->cgroup->nr_css--;
 	RCU_INIT_POINTER(css->cgroup->subsys[ss->id], NULL);
 
 	wake_up_all(&css->cgroup->offline_waitq);
@@ -4373,39 +4370,18 @@ out_destroy:
 
 /*
  * This is called when the refcnt of a css is confirmed to be killed.
- * css_tryget_online() is now guaranteed to fail.
+ * css_tryget_online() is now guaranteed to fail.  Tell the subsystem to
+ * initate destruction and put the css ref from kill_css().
  */
 static void css_killed_work_fn(struct work_struct *work)
 {
 	struct cgroup_subsys_state *css =
 		container_of(work, struct cgroup_subsys_state, destroy_work);
-	struct cgroup *cgrp = css->cgroup;
 
 	mutex_lock(&cgroup_mutex);
-
-	/*
-	 * css_tryget_online() is guaranteed to fail now.  Tell subsystems
-	 * to initate destruction.
-	 */
 	offline_css(css);
-
-	/*
-	 * If @cgrp is marked dead, it's waiting for refs of all css's to
-	 * be disabled before proceeding to the second phase of cgroup
-	 * destruction.  If we are the last one, kick it off.
-	 */
-	if (!cgrp->nr_css && cgroup_is_dead(cgrp))
-		cgroup_destroy_css_killed(cgrp);
-
 	mutex_unlock(&cgroup_mutex);
 
-	/*
-	 * Put the css refs from kill_css().  Each css holds an extra
-	 * reference to the cgroup's dentry and cgroup removal proceeds
-	 * regardless of css refs.  On the last put of each css, whenever
-	 * that may be, the extra dentry ref is put so that dentry
-	 * destruction happens only after all css's are released.
-	 */
 	css_put(css);
 }
 
@@ -4517,11 +4493,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	 */
 	set_bit(CGRP_DEAD, &cgrp->flags);
 
-	/*
-	 * Initiate massacre of all css's.  cgroup_destroy_css_killed()
-	 * will be invoked to perform the rest of destruction once the
-	 * percpu refs of all css's are confirmed to be killed.
-	 */
+	/* initiate massacre of all css's */
 	for_each_css(css, ssid, cgrp)
 		kill_css(css);
 
@@ -4532,15 +4504,6 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	raw_spin_unlock(&release_list_lock);
 
 	/*
-	 * If @cgrp has css's attached, the second stage of cgroup
-	 * destruction is kicked off from css_killed_work_fn() after the
-	 * refs of all attached css's are killed.  If @cgrp doesn't have
-	 * any css, we kick it off here.
-	 */
-	if (!cgrp->nr_css)
-		cgroup_destroy_css_killed(cgrp);
-
-	/*
 	 * Remove @cgrp directory along with the base files.  @cgrp has an
 	 * extra ref on its kn.
 	 */
@@ -4549,25 +4512,12 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	set_bit(CGRP_RELEASABLE, &cgrp->parent->flags);
 	check_for_release(cgrp->parent);
 
+	/* put the base reference */
+	cgroup_put(cgrp);
+
 	return 0;
 };
 
-/**
- * cgroup_destroy_css_killed - the second step of cgroup destruction
- * @cgrp: the cgroup whose csses have just finished offlining
- *
- * This function is invoked from a work item for a cgroup which is being
- * destroyed after all css's are offlined and performs the rest of
- * destruction.  This is the second step of destruction described in the
- * comment above cgroup_destroy_locked().
- */
-static void cgroup_destroy_css_killed(struct cgroup *cgrp)
-{
-	lockdep_assert_held(&cgroup_mutex);
-
-	cgroup_put(cgrp);
-}
-
 static int cgroup_rmdir(struct kernfs_node *kn)
 {
 	struct cgroup *cgrp;
-- 
1.9.0

