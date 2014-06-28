Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbaF1BEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 21:04:44 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:42904 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129AbaF1BDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 21:03:17 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
        mhocko@suse.cz, vgoyal@redhat.com, axboe@kernel.dk,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/6] cgroup: reorganize cgroup_subtree_control_write()
Date: Fri, 27 Jun 2014 21:03:07 -0400
Message-Id: <1403917392-32555-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403917392-32555-1-git-send-email-tj@kernel.org>
References: <1403917392-32555-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the following two reorganizations to
cgroup_subtree_control_write().  These are to prepare for future
changes and shouldn't cause any functional difference.

* Move availability above css offlining wait.

* Move cgrp->child_subsys_mask update above new css creation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7868fc3..a46d7e2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2613,6 +2613,14 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 				continue;
 			}
 
+			/* unavailable or not enabled on the parent? */
+			if (!(cgrp_dfl_root.subsys_mask & (1 << ssid)) ||
+			    (cgroup_parent(cgrp) &&
+			     !(cgroup_parent(cgrp)->child_subsys_mask & (1 << ssid)))) {
+				ret = -ENOENT;
+				goto out_unlock;
+			}
+
 			/*
 			 * Because css offlining is asynchronous, userland
 			 * might try to re-enable the same controller while
@@ -2635,14 +2643,6 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 
 				return restart_syscall();
 			}
-
-			/* unavailable or not enabled on the parent? */
-			if (!(cgrp_dfl_root.subsys_mask & (1 << ssid)) ||
-			    (cgroup_parent(cgrp) &&
-			     !(cgroup_parent(cgrp)->child_subsys_mask & (1 << ssid)))) {
-				ret = -ENOENT;
-				goto out_unlock;
-			}
 		} else if (disable & (1 << ssid)) {
 			if (!(cgrp->child_subsys_mask & (1 << ssid))) {
 				disable &= ~(1 << ssid);
@@ -2673,12 +2673,10 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 		goto out_unlock;
 	}
 
-	/*
-	 * Create csses for enables and update child_subsys_mask.  This
-	 * changes cgroup_e_css() results which in turn makes the
-	 * subsequent cgroup_update_dfl_csses() associate all tasks in the
-	 * subtree to the updated csses.
-	 */
+	cgrp->child_subsys_mask |= enable;
+	cgrp->child_subsys_mask &= ~disable;
+
+	/* create new csses */
 	for_each_subsys(ss, ssid) {
 		if (!(enable & (1 << ssid)))
 			continue;
@@ -2690,9 +2688,11 @@ static ssize_t cgroup_subtree_control_write(struct kernfs_open_file *of,
 		}
 	}
 
-	cgrp->child_subsys_mask |= enable;
-	cgrp->child_subsys_mask &= ~disable;
-
+	/*
+	 * At this point, cgroup_e_css() results reflect the new csses
+	 * making the following cgroup_update_dfl_csses() properly update
+	 * css associations of all tasks in the subtree.
+	 */
 	ret = cgroup_update_dfl_csses(cgrp);
 	if (ret)
 		goto err_undo_css;
-- 
1.9.3

