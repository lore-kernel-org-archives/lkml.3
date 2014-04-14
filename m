Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbaDNVkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 17:40:47 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:63578 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480AbaDNVh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 17:37:26 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 08/12] cgroup: allow cgroup creation and suppress automatic css creation in the unified hierarchy
Date: Mon, 14 Apr 2014 17:37:06 -0400
Message-Id: <1397511430-2673-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1397511430-2673-1-git-send-email-tj@kernel.org>
References: <1397511430-2673-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that effective css handling has been added and iterators updated
accordingly, it's safe to allow cgroup creation in the default
hierarchy.  Unblock cgroup creation in the default hierarchy.

As the default hierarchy will implement explicit enabling and
disabling of controllers on each cgroup, suppress automatic css
enabling on cgroup creation.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3de3951..02c99a3 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1115,8 +1115,10 @@ static int rebind_subsystems(struct cgroup_root *dst_root,
 		src_root->subsys_mask &= ~(1 << ssid);
 		src_root->cgrp.child_subsys_mask &= ~(1 << ssid);
 
+		/* default hierarchy doesn't enable controllers by default */
 		dst_root->subsys_mask |= 1 << ssid;
-		dst_root->cgrp.child_subsys_mask |= 1 << ssid;
+		if (dst_root != &cgrp_dfl_root)
+			dst_root->cgrp.child_subsys_mask |= 1 << ssid;
 
 		if (ss->bind)
 			ss->bind(css);
@@ -3790,13 +3792,6 @@ static long cgroup_create(struct cgroup *parent, const char *name,
 	struct cgroup_subsys *ss;
 	struct kernfs_node *kn;
 
-	/*
-	 * XXX: The default hierarchy isn't fully implemented yet.  Block
-	 * !root cgroup creation on it for now.
-	 */
-	if (root == &cgrp_dfl_root)
-		return -EINVAL;
-
 	/* allocate the cgroup and its ID, 0 is reserved for the root */
 	cgrp = kzalloc(sizeof(*cgrp), GFP_KERNEL);
 	if (!cgrp)
@@ -3882,7 +3877,12 @@ static long cgroup_create(struct cgroup *parent, const char *name,
 		}
 	}
 
-	cgrp->child_subsys_mask = parent->child_subsys_mask;
+	/*
+	 * On the default hierarchy, a child doesn't automatically inherit
+	 * child_subsys_mask from the parent.  Each is configured manually.
+	 */
+	if (!cgroup_on_dfl(cgrp))
+		cgrp->child_subsys_mask = parent->child_subsys_mask;
 
 	kernfs_activate(kn);
 
-- 
1.9.0

