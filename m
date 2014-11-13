Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934610AbaKMV6x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:58:53 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:55358 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934261AbaKMV6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:58:51 -0500
Date: Thu, 13 Nov 2014 16:58:48 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH cgroup/for-3.19 2/3] cgroup: restructure child_subsys_mask
 handling in cgroup_subtree_control_write()
Message-ID: <20141113215848.GB2598@htj.dyndns.org>
References: <20141113215813.GA2598@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113215813.GA2598@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make cgroup_subtree_control_write() first calculate new
subtree_control (new_sc), child_subsys_mask (new_ss) and
css_enable/disable masks before applying them to the cgroup.  Also,
store the original subtree_control (old_sc) and child_subsys_mask
(old_ss) and use them to restore the orignal state after failure.

This patch shouldn't cause any behavior changes.  This prepares for a
fix for a bug in the async css offline wait logic.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2653,7 +2653,7 @@ static ssize_t cgroup_subtree_control_wr
 					    loff_t off)
 {
 	unsigned int enable = 0, disable = 0;
-	unsigned int css_enable, css_disable, old_ctrl, new_ctrl;
+	unsigned int css_enable, css_disable, old_sc, new_sc, old_ss, new_ss;
 	struct cgroup *cgrp, *child;
 	struct cgroup_subsys *ss;
 	char *tok;
@@ -2770,18 +2770,19 @@ static ssize_t cgroup_subtree_control_wr
 	 * subsystems than specified may need to be enabled or disabled
 	 * depending on subsystem dependencies.
 	 */
-	cgrp->subtree_control |= enable;
-	cgrp->subtree_control &= ~disable;
+	old_sc = cgrp->subtree_control;
+	old_ss = cgrp->child_subsys_mask;
+	new_sc = (old_sc | enable) & ~disable;
+	new_ss = cgroup_calc_child_subsys_mask(cgrp, new_sc);
 
-	old_ctrl = cgrp->child_subsys_mask;
-	cgroup_refresh_child_subsys_mask(cgrp);
-	new_ctrl = cgrp->child_subsys_mask;
-
-	css_enable = ~old_ctrl & new_ctrl;
-	css_disable = old_ctrl & ~new_ctrl;
+	css_enable = ~old_ss & new_ss;
+	css_disable = old_ss & ~new_ss;
 	enable |= css_enable;
 	disable |= css_disable;
 
+	cgrp->subtree_control = new_sc;
+	cgrp->child_subsys_mask = new_ss;
+
 	/*
 	 * Create new csses or make the existing ones visible.  A css is
 	 * created invisible if it's being implicitly enabled through
@@ -2844,9 +2845,8 @@ out_unlock:
 	return ret ?: nbytes;
 
 err_undo_css:
-	cgrp->subtree_control &= ~enable;
-	cgrp->subtree_control |= disable;
-	cgroup_refresh_child_subsys_mask(cgrp);
+	cgrp->subtree_control = old_sc;
+	cgrp->child_subsys_mask = old_ss;
 
 	for_each_subsys(ss, ssid) {
 		if (!(enable & (1 << ssid)))
