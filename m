Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbaCMTyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 15:54:47 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:59566 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbaCMTuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 15:50:19 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/11] cgroup: relocate setting of CGRP_DEAD
Date: Thu, 13 Mar 2014 15:50:04 -0400
Message-Id: <1394740213-17626-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394740213-17626-1-git-send-email-tj@kernel.org>
References: <1394740213-17626-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In cgroup_destroy_locked(), move setting of CGRP_DEAD above
invocations of kill_css().  This doesn't make any visible behavior
difference now but will be used to inhibit manipulating controller
enable states of a dying cgroup on the unified hierarchy.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ca19735..7bf1459 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3868,6 +3868,15 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 		return -EBUSY;
 
 	/*
+	 * Mark @cgrp dead.  This prevents further task migration and child
+	 * creation by disabling cgroup_lock_live_group().  Note that
+	 * CGRP_DEAD assertion is depended upon by css_next_child() to
+	 * resume iteration after dropping RCU read lock.  See
+	 * css_next_child() for details.
+	 */
+	set_bit(CGRP_DEAD, &cgrp->flags);
+
+	/*
 	 * Initiate massacre of all css's.  cgroup_destroy_css_killed()
 	 * will be invoked to perform the rest of destruction once the
 	 * percpu refs of all css's are confirmed to be killed.  This
@@ -3878,15 +3887,6 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 		kill_css(css);
 	mutex_lock(&cgroup_mutex);
 
-	/*
-	 * Mark @cgrp dead.  This prevents further task migration and child
-	 * creation by disabling cgroup_lock_live_group().  Note that
-	 * CGRP_DEAD assertion is depended upon by css_next_child() to
-	 * resume iteration after dropping RCU read lock.  See
-	 * css_next_child() for details.
-	 */
-	set_bit(CGRP_DEAD, &cgrp->flags);
-
 	/* CGRP_DEAD is set, remove from ->release_list for the last time */
 	raw_spin_lock(&release_list_lock);
 	if (!list_empty(&cgrp->release_list))
-- 
1.8.5.3

