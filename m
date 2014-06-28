Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbaF1BES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 21:04:18 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:59018 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424AbaF1BDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 21:03:22 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
        mhocko@suse.cz, vgoyal@redhat.com, axboe@kernel.dk,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/6] cgroup: implement cgroup_subsys->depends_on
Date: Fri, 27 Jun 2014 21:03:11 -0400
Message-Id: <1403917392-32555-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403917392-32555-1-git-send-email-tj@kernel.org>
References: <1403917392-32555-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the blkio subsystem attributes all of writeback IOs to the
root.  One of the issues is that there's no way to tell who originated
a writeback IO from block layer.  Those IOs are usually issued
asynchronously from a task which didn't have anything to do with
actually generating the dirty pages.  The memory subsystem, when
enabled, already keeps track of the ownership of each dirty page and
it's desirable for blkio to piggyback instead of adding its own
per-page tag.

blkio piggybacking on memory is an implementation detail which
preferably should be handled automatically without requiring explicit
userland action.  To achieve that, this patch implements
cgroup_subsys->depends_on which contains the mask of subsystems which
should be enabled together when the subsystem is enabled.

The previous patches already implemented the support for enabled but
invisible subsystems and cgroup_subsys->depends_on can be easily
implemented by updating cgroup_refresh_child_subsys_mask() so that it
calculates cgroup->child_subsys_mask considering
cgroup_subsys->depends_on of the explicitly enabled subsystems.

Documentation/cgroups/unified-hierarchy.txt is updated to explain that
subsystems may not become immediately available after being unused
from userland and that dependency could be a factor in it.  As
subsystems may already keep residual references, this doesn't
significantly change how subsystem rebinding can be used.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 Documentation/cgroups/unified-hierarchy.txt | 23 ++++++++++++--
 include/linux/cgroup.h                      |  9 ++++++
 kernel/cgroup.c                             | 49 ++++++++++++++++++++++++++++-
 3 files changed, 77 insertions(+), 4 deletions(-)

diff --git a/Documentation/cgroups/unified-hierarchy.txt b/Documentation/cgroups/unified-hierarchy.txt
index 324b182..a7a2205 100644
--- a/Documentation/cgroups/unified-hierarchy.txt
+++ b/Documentation/cgroups/unified-hierarchy.txt
@@ -97,9 +97,26 @@ change soon.
 All controllers which are not bound to other hierarchies are
 automatically bound to unified hierarchy and show up at the root of
 it.  Controllers which are enabled only in the root of unified
-hierarchy can be bound to other hierarchies at any time.  This allows
-mixing unified hierarchy with the traditional multiple hierarchies in
-a fully backward compatible way.
+hierarchy can be bound to other hierarchies.  This allows mixing
+unified hierarchy with the traditional multiple hierarchies in a fully
+backward compatible way.
+
+A controller can be moved across hierarchies only after the controller
+is no longer referenced in its current hierarchy.  Because per-cgroup
+controller states are destroyed asynchronously and controllers may
+have lingering references, a controller may not show up immediately on
+the unified hierarchy after the final umount of the previous
+hierarchy.  Similarly, a controller should be fully disabled to be
+moved out of the unified hierarchy and it may take some time for the
+disabled controller to become available for other hierarchies;
+furthermore, due to dependencies among controllers, other controllers
+may need to be disabled too.
+
+While useful for development and manual configurations, dynamically
+moving controllers between the unified and other hierarchies is
+strongly discouraged for production use.  It is recommended to decide
+the hierarchies and controller associations before starting using the
+controllers.
 
 
 2-2. cgroup.subtree_control
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index db99e3b..28853e7 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -693,6 +693,15 @@ struct cgroup_subsys {
 
 	/* base cftypes, automatically registered with subsys itself */
 	struct cftype *base_cftypes;
+
+	/*
+	 * A subsystem may depend on other subsystems.  When such subsystem
+	 * is enabled on a cgroup, the depended-upon subsystems are enabled
+	 * together if available.  Subsystems enabled due to dependency are
+	 * not visible to userland until explicitly enabled.  The following
+	 * specifies the mask of subsystems that this one depends on.
+	 */
+	unsigned int depends_on;
 };
 
 #define SUBSYS(_x) extern struct cgroup_subsys _x ## _cgrp_subsys;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3a6b77d..cd02e99 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1037,9 +1037,56 @@ static void cgroup_put(struct cgroup *cgrp)
 	css_put(&cgrp->self);
 }
 
+/**
+ * cgroup_refresh_child_subsys_mask - update child_subsys_mask
+ * @cgrp: the target cgroup
+ *
+ * On the default hierarchy, a subsystem may request other subsystems to be
+ * enabled together through its ->depends_on mask.  In such cases, more
+ * subsystems than specified in "cgroup.subtree_control" may be enabled.
+ *
+ * This function determines which subsystems need to be enabled given the
+ * current @cgrp->subtree_control and records it in
+ * @cgrp->child_subsys_mask.  The resulting mask is always a superset of
+ * @cgrp->subtree_control and follows the usual hierarchy rules.
+ */
 static void cgroup_refresh_child_subsys_mask(struct cgroup *cgrp)
 {
-	cgrp->child_subsys_mask = cgrp->subtree_control;
+	struct cgroup *parent = cgroup_parent(cgrp);
+	unsigned int cur_ss_mask = cgrp->subtree_control;
+	struct cgroup_subsys *ss;
+	int ssid;
+
+	lockdep_assert_held(&cgroup_mutex);
+
+	if (!cgroup_on_dfl(cgrp)) {
+		cgrp->child_subsys_mask = cur_ss_mask;
+		return;
+	}
+
+	while (true) {
+		unsigned int new_ss_mask = cur_ss_mask;
+
+		for_each_subsys(ss, ssid)
+			if (cur_ss_mask & (1 << ssid))
+				new_ss_mask |= ss->depends_on;
+
+		/*
+		 * Mask out subsystems which aren't available.  This can
+		 * happen only if some depended-upon subsystems were bound
+		 * to non-default hierarchies.
+		 */
+		if (parent)
+			new_ss_mask &= parent->child_subsys_mask;
+		else
+			new_ss_mask &= cgrp->root->subsys_mask;
+
+		if (new_ss_mask == cur_ss_mask)
+			break;
+		cur_ss_mask = new_ss_mask;
+	}
+
+	cgrp->child_subsys_mask = cur_ss_mask;
 }
 
 /**
-- 
1.9.3

