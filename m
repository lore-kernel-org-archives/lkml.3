Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbaFLGda (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 02:33:30 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:34542 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaFLGd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 02:33:29 -0400
Message-ID: <539949A1.90301@huawei.com>
Date: Thu, 12 Jun 2014 14:33:05 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 5/5] cgroup: fix a race between cgroup_mount() and cgroup_kill_sb()
References: <53994943.60703@huawei.com>
In-Reply-To: <53994943.60703@huawei.com>
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

To fix this, we increase the refcnt of the superblock instead of increasing
the percpu refcnt of cgroup root.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---

A better fix is welcome!

---
 kernel/cgroup.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index bd37e8d..94e1814 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1654,7 +1654,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	struct dentry *dentry;
 	int ret;
 	int i;
-	bool new_sb;
+	bool sb_pinned = false;
 
 	/*
 	 * The first time anyone tries to mount a cgroup, enable the list
@@ -1735,19 +1735,21 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		}
 
 		/*
-		 * A root's lifetime is governed by its root cgroup.
-		 * tryget_live failure indicate that the root is being
-		 * destroyed.  Wait for destruction to complete so that the
-		 * subsystems are free.  We can use wait_queue for the wait
-		 * but this path is super cold.  Let's just sleep for a bit
-		 * and retry.
+		 * This may fail for two reasons:
+		 * - A concurrent mount is in process. We wait for that mount
+		     to complete.
+		 * - The superblock is being destroyed. We wait for the
+		 *   desctruction to complete so that the subsystems are free.
+		 * We can use wait_queue for the wait but this path is super
+		 * cold.  Let's just sleep for a bit and retry.
 		 */
-		if (!percpu_ref_tryget_live(&root->cgrp.self.refcnt)) {
+		if (!kernfs_pin_sb(root->kf_root, NULL)) {
 			mutex_unlock(&cgroup_mutex);
 			msleep(10);
 			ret = restart_syscall();
 			goto out_free;
 		}
+		sb_pinned = true;
 
 		ret = 0;
 		goto out_unlock;
@@ -1784,8 +1786,10 @@ out_free:
 	if (ret)
 		return ERR_PTR(ret);
 
-	dentry = kernfs_mount(fs_type, flags, root->kf_root, &new_sb);
-	if (IS_ERR(dentry) || !new_sb)
+	dentry = kernfs_mount(fs_type, flags, root->kf_root, NULL);
+	if (sb_pinned)
+		kernfs_drop_sb(root->kf_root, NULL);
+	if (!sb_pinned && IS_ERR(dentry))
 		cgroup_put(&root->cgrp);
 	return dentry;
 }
-- 
1.8.0.2

