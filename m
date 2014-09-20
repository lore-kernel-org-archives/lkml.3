Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751621AbaITGtQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 02:49:16 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:10635 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaITGtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 02:49:15 -0400
Message-ID: <541D2366.2020107@huawei.com>
Date: Sat, 20 Sep 2014 14:49:10 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cgroup: remove redundant variable in cgroup_mount()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both pinned_sb and new_sb indicate if a new superblock is needed,
so we can just remove new_sb.

Note now we must check if kernfs_tryget_sb() returns NULL, because
when it returns NULL, kernfs_mount() may still re-use an existing
superblock, which is just allocated by another concurent mount.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---

Hi Tejun,

I think you wanted to see the @new_sb argument removed from kernfs_mount(),
but it's also used in debugfs and we can't use kernfs_tryget_sb() to
replace the new_sb check.

---
 kernel/cgroup.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 33f15b3..15a2387 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1694,7 +1694,6 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	struct dentry *dentry;
 	int ret;
 	int i;
-	bool new_sb;
 
 	/*
 	 * The first time anyone tries to mount a cgroup, enable the list
@@ -1785,7 +1784,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		 * path is super cold.  Let's just sleep a bit and retry.
 		 */
 		pinned_sb = kernfs_pin_sb(root->kf_root, NULL);
-		if (IS_ERR(pinned_sb) ||
+		if (IS_ERR_OR_NULL(pinned_sb) ||
 		    !percpu_ref_tryget_live(&root->cgrp.self.refcnt)) {
 			mutex_unlock(&cgroup_mutex);
 			if (!IS_ERR_OR_NULL(pinned_sb))
@@ -1831,18 +1830,16 @@ out_free:
 		return ERR_PTR(ret);
 
 	dentry = kernfs_mount(fs_type, flags, root->kf_root,
-				CGROUP_SUPER_MAGIC, &new_sb);
-	if (IS_ERR(dentry) || !new_sb)
+				CGROUP_SUPER_MAGIC, NULL);
+	if (IS_ERR(dentry) || pinned_sb)
 		cgroup_put(&root->cgrp);
 
 	/*
 	 * If @pinned_sb, we're reusing an existing root and holding an
 	 * extra ref on its sb.  Mount is complete.  Put the extra ref.
 	 */
-	if (pinned_sb) {
-		WARN_ON(new_sb);
+	if (pinned_sb)
 		deactivate_super(pinned_sb);
-	}
 
 	return dentry;
 }
-- 
1.8.0.2

