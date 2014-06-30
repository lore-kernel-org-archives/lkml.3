Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbaF3DvO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 23:51:14 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:19980 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292AbaF3DvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 23:51:12 -0400
Message-ID: <53B0DEA3.80807@huawei.com>
Date: Mon, 30 Jun 2014 11:50:59 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v3 3/3] cgroup: fix a race between cgroup_mount() and cgroup_kill_sb()
References: <53B0DE66.5080100@huawei.com>
In-Reply-To: <53B0DE66.5080100@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've converted cgroup to kernfs so cgroup won't be intertwined with
vfs objects and locking, but there are dark areas.

Run two instances of this script concurrently:

    for ((; ;))
    {
    	mount -t cgroup -o cpuacct xxx /cgroup
    	umount /cgroup
    }

After a while, I saw two mount processes were stuck at retrying, because
they were waiting for a subsystem to become free, but the root associated
with this subsystem never got freed.

This can happen, if thread A is in the process of killing superblock but
hasn't called percpu_ref_kill(), and at this time thread B is mounting
the same cgroup root and finds the root in the root list and performs
percpu_ref_try_get().

To fix this, we try to increase both the refcnt of the superblock and the
percpu refcnt of cgroup root.

v2:
- we should try to get both the superblock refcnt and cgroup_root refcnt,
  because cgroup_root may have no superblock assosiated with it.
- adjust/add comments.

Cc: <stable@vger.kernel.org> # 3.15
Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d3662ac..11e40cf 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1655,6 +1655,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	int ret;
 	int i;
 	bool new_sb;
+	struct super_block *sb = NULL;
 
 	/*
 	 * The first time anyone tries to mount a cgroup, enable the list
@@ -1739,14 +1740,18 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 
 		/*
 		 * A root's lifetime is governed by its root cgroup.
-		 * tryget_live failure indicate that the root is being
-		 * destroyed.  Wait for destruction to complete so that the
-		 * subsystems are free.  We can use wait_queue for the wait
-		 * but this path is super cold.  Let's just sleep for a bit
-		 * and retry.
+		 * pin_sb and tryget_live failure indicate that the root is
+		 * being destroyed.  Wait for destruction to complete so that
+		 * the subsystems are free.  We can use wait_queue for the
+		 * wait but this path is super cold.  Let's just sleep for
+		 * a bit and retry.
 		 */
-		if (!percpu_ref_tryget_live(&root->cgrp.self.refcnt)) {
+		sb = kernfs_pin_sb(root->kf_root, NULL);
+		if (IS_ERR(sb) ||
+		    !percpu_ref_tryget_live(&root->cgrp.self.refcnt)) {
 			mutex_unlock(&cgroup_mutex);
+			if (!IS_ERR_OR_NULL(sb))
+				deactivate_super(sb);
 			msleep(10);
 			ret = restart_syscall();
 			goto out_free;
@@ -1790,6 +1795,17 @@ out_free:
 	dentry = kernfs_mount(fs_type, flags, root->kf_root, &new_sb);
 	if (IS_ERR(dentry) || !new_sb)
 		cgroup_put(&root->cgrp);
+
+	if (sb) {
+		/*
+		 * On success kernfs_mount() returns with sb->s_umount held,
+		 * but kernfs_mount() also increases the superblock's refcnt,
+		 * so calling deactivate_super() to drop the refcnt we got when
+		 * looking up cgroup root won't acquire sb->s_umount again.
+		 */
+		WARN_ON(new_sb);
+		deactivate_super(sb);
+	}
 	return dentry;
 }
 
-- 
1.8.0.2

