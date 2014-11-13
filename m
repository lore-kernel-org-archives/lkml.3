Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934557AbaKMV6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:58:19 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:61798 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934261AbaKMV6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:58:17 -0500
Date: Thu, 13 Nov 2014 16:58:13 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH cgroup/for-3.19 1/3] cgroup: separate out
 cgroup_calc_child_subsys_mask() from cgroup_refresh_child_subsys_mask()
Message-ID: <20141113215813.GA2598@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_refresh_child_subsys_mask() calculates and updates the
effective @cgrp->child_subsys_maks according to the current
@cgrp->subtree_control.  Separate out the calculation part into
cgroup_calc_child_subsys_mask().  This will be used to fix a bug in
the async css offline wait logic.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c |   36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1019,31 +1019,30 @@ static void cgroup_put(struct cgroup *cg
 }
 
 /**
- * cgroup_refresh_child_subsys_mask - update child_subsys_mask
+ * cgroup_calc_child_subsys_mask - calculate child_subsys_mask
  * @cgrp: the target cgroup
+ * @subtree_control: the new subtree_control mask to consider
  *
  * On the default hierarchy, a subsystem may request other subsystems to be
  * enabled together through its ->depends_on mask.  In such cases, more
  * subsystems than specified in "cgroup.subtree_control" may be enabled.
  *
- * This function determines which subsystems need to be enabled given the
- * current @cgrp->subtree_control and records it in
- * @cgrp->child_subsys_mask.  The resulting mask is always a superset of
- * @cgrp->subtree_control and follows the usual hierarchy rules.
+ * This function calculates which subsystems need to be enabled if
+ * @subtree_control is to be applied to @cgrp.  The returned mask is always
+ * a superset of @subtree_control and follows the usual hierarchy rules.
  */
-static void cgroup_refresh_child_subsys_mask(struct cgroup *cgrp)
+static unsigned int cgroup_calc_child_subsys_mask(struct cgroup *cgrp,
+						  unsigned int subtree_control)
 {
 	struct cgroup *parent = cgroup_parent(cgrp);
-	unsigned int cur_ss_mask = cgrp->subtree_control;
+	unsigned int cur_ss_mask = subtree_control;
 	struct cgroup_subsys *ss;
 	int ssid;
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	if (!cgroup_on_dfl(cgrp)) {
-		cgrp->child_subsys_mask = cur_ss_mask;
-		return;
-	}
+	if (!cgroup_on_dfl(cgrp))
+		return cur_ss_mask;
 
 	while (true) {
 		unsigned int new_ss_mask = cur_ss_mask;
@@ -1067,7 +1066,20 @@ static void cgroup_refresh_child_subsys_
 		cur_ss_mask = new_ss_mask;
 	}
 
-	cgrp->child_subsys_mask = cur_ss_mask;
+	return cur_ss_mask;
+}
+
+/**
+ * cgroup_refresh_child_subsys_mask - update child_subsys_mask
+ * @cgrp: the target cgroup
+ *
+ * Update @cgrp->child_subsys_mask according to the current
+ * @cgrp->subtree_control using cgroup_calc_child_subsys_mask().
+ */
+static void cgroup_refresh_child_subsys_mask(struct cgroup *cgrp)
+{
+	cgrp->child_subsys_mask =
+		cgroup_calc_child_subsys_mask(cgrp, cgrp->subtree_control);
 }
 
 /**
