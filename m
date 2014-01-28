Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbaA1PcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 10:32:22 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:35918 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755314AbaA1PcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 10:32:19 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH 2/4] cgroup: fix error return from cgroup_create()
Date: Tue, 28 Jan 2014 10:32:03 -0500
Message-Id: <1390923125-4369-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390923125-4369-1-git-send-email-tj@kernel.org>
References: <1390923125-4369-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_create() was returning 0 after allocation failures.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: stable@vger.kernel.org
---
 kernel/cgroup.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 364aeb22..2e9f12a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4158,7 +4158,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	struct cgroup *cgrp;
 	struct cgroup_name *name;
 	struct cgroupfs_root *root = parent->root;
-	int ssid, err = 0;
+	int ssid, err;
 	struct cgroup_subsys *ss;
 	struct super_block *sb = root->sb;
 
@@ -4168,8 +4168,10 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 		return -ENOMEM;
 
 	name = cgroup_alloc_name(dentry);
-	if (!name)
+	if (!name) {
+		err = -ENOMEM;
 		goto err_free_cgrp;
+	}
 	rcu_assign_pointer(cgrp->name, name);
 
 	/*
@@ -4177,8 +4179,10 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	 * a half-baked cgroup.
 	 */
 	cgrp->id = idr_alloc(&root->cgroup_idr, NULL, 1, 0, GFP_KERNEL);
-	if (cgrp->id < 0)
+	if (cgrp->id < 0) {
+		err = -ENOMEM;
 		goto err_free_name;
+	}
 
 	/*
 	 * Only live parents can have children.  Note that the liveliness
-- 
1.8.5.3

