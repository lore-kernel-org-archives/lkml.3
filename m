Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaBKPlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:41:12 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:42297 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaBKPlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:41:09 -0500
Date: Tue, 11 Feb 2014 10:41:05 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH cgroup/for-3.14-fixes] cgroup: protect modifications to
 cgroup_idr with cgroup_mutex
Message-ID: <20140211154105.GC24490@htj.dyndns.org>
References: <52F9D9DA.7040108@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F9D9DA.7040108@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is the slightly modified patch that I applied to
cgroup/for-3.14-fixes.

Thanks a lot!

-------- 8< --------
>From 0ab02ca8f887908152d1a96db5130fc661d36a1e Mon Sep 17 00:00:00 2001
From: Li Zefan <lizefan@huawei.com>
Date: Tue, 11 Feb 2014 16:05:46 +0800

Setup cgroupfs like this:
  # mount -t cgroup -o cpuacct xxx /cgroup
  # mkdir /cgroup/sub1
  # mkdir /cgroup/sub2

Then run these two commands:
  # for ((; ;)) { mkdir /cgroup/sub1/tmp && rmdir /mnt/sub1/tmp; } &
  # for ((; ;)) { mkdir /cgroup/sub2/tmp && rmdir /mnt/sub2/tmp; } &

After seconds you may see this warning:

------------[ cut here ]------------
WARNING: CPU: 1 PID: 25243 at lib/idr.c:527 sub_remove+0x87/0x1b0()
idr_remove called for id=6 which is not allocated.
...
Call Trace:
 [<ffffffff8156063c>] dump_stack+0x7a/0x96
 [<ffffffff810591ac>] warn_slowpath_common+0x8c/0xc0
 [<ffffffff81059296>] warn_slowpath_fmt+0x46/0x50
 [<ffffffff81300aa7>] sub_remove+0x87/0x1b0
 [<ffffffff810f3f02>] ? css_killed_work_fn+0x32/0x1b0
 [<ffffffff81300bf5>] idr_remove+0x25/0xd0
 [<ffffffff810f2bab>] cgroup_destroy_css_killed+0x5b/0xc0
 [<ffffffff810f4000>] css_killed_work_fn+0x130/0x1b0
 [<ffffffff8107cdbc>] process_one_work+0x26c/0x550
 [<ffffffff8107eefe>] worker_thread+0x12e/0x3b0
 [<ffffffff81085f96>] kthread+0xe6/0xf0
 [<ffffffff81570bac>] ret_from_fork+0x7c/0xb0
---[ end trace 2d1577ec10cf80d0 ]---

It's because allocating/removing cgroup ID is not properly synchronized.

The bug was introduced when we converted cgroup_ida to cgroup_idr.
While synchronization is already done inside ida_simple_{get,remove}(),
users are responsible for concurrent calls to idr_{alloc,remove}().

tj: Refreshed on top of b58c89986a77 ("cgroup: fix error return from
cgroup_create()").

Fixes: 4e96ee8e981b ("cgroup: convert cgroup_ida to cgroup_idr")
Cc: <stable@vger.kernel.org> #3.12+
Reported-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |  2 ++
 kernel/cgroup.c        | 34 ++++++++++++++++++----------------
 2 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 5c09759..9450f02 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -166,6 +166,8 @@ struct cgroup {
 	 *
 	 * The ID of the root cgroup is always 0, and a new cgroup
 	 * will be assigned with a smallest available ID.
+	 *
+	 * Allocating/Removing ID must be protected by cgroup_mutex.
 	 */
 	int id;
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3edf716..52719ce 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -886,7 +886,9 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		 * per-subsystem and moved to css->id so that lookups are
 		 * successful until the target css is released.
 		 */
+		mutex_lock(&cgroup_mutex);
 		idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
+		mutex_unlock(&cgroup_mutex);
 		cgrp->id = -1;
 
 		call_rcu(&cgrp->rcu_head, cgroup_free_rcu);
@@ -4168,16 +4170,6 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	rcu_assign_pointer(cgrp->name, name);
 
 	/*
-	 * Temporarily set the pointer to NULL, so idr_find() won't return
-	 * a half-baked cgroup.
-	 */
-	cgrp->id = idr_alloc(&root->cgroup_idr, NULL, 1, 0, GFP_KERNEL);
-	if (cgrp->id < 0) {
-		err = -ENOMEM;
-		goto err_free_name;
-	}
-
-	/*
 	 * Only live parents can have children.  Note that the liveliness
 	 * check isn't strictly necessary because cgroup_mkdir() and
 	 * cgroup_rmdir() are fully synchronized by i_mutex; however, do it
@@ -4186,7 +4178,17 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	 */
 	if (!cgroup_lock_live_group(parent)) {
 		err = -ENODEV;
-		goto err_free_id;
+		goto err_free_name;
+	}
+
+	/*
+	 * Temporarily set the pointer to NULL, so idr_find() won't return
+	 * a half-baked cgroup.
+	 */
+	cgrp->id = idr_alloc(&root->cgroup_idr, NULL, 1, 0, GFP_KERNEL);
+	if (cgrp->id < 0) {
+		err = -ENOMEM;
+		goto err_unlock;
 	}
 
 	/* Grab a reference on the superblock so the hierarchy doesn't
@@ -4218,7 +4220,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	 */
 	err = cgroup_create_file(dentry, S_IFDIR | mode, sb);
 	if (err < 0)
-		goto err_unlock;
+		goto err_free_id;
 	lockdep_assert_held(&dentry->d_inode->i_mutex);
 
 	cgrp->serial_nr = cgroup_serial_nr_next++;
@@ -4254,12 +4256,12 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 
 	return 0;
 
-err_unlock:
-	mutex_unlock(&cgroup_mutex);
-	/* Release the reference count that we took on the superblock */
-	deactivate_super(sb);
 err_free_id:
 	idr_remove(&root->cgroup_idr, cgrp->id);
+	/* Release the reference count that we took on the superblock */
+	deactivate_super(sb);
+err_unlock:
+	mutex_unlock(&cgroup_mutex);
 err_free_name:
 	kfree(rcu_dereference_raw(cgrp->name));
 err_free_cgrp:
-- 
1.8.5.3

