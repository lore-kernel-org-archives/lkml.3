Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaBOEDN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 23:03:13 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:60478 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbaBOEDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 23:03:11 -0500
Message-ID: <52FEE6F8.8030404@huawei.com>
Date: Sat, 15 Feb 2014 12:03:04 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH v2] cgroup: fix top cgroup refcnt leak
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we mount the same cgroupfs in serveral mount points, and then
umount all of them, kill_sb() will be called only once.

Therefore it's wrong to increment top_cgroup's refcnt when we find
an existing cgroup_root.

Try:
        # mount -t cgroup -o cpuacct xxx /cgroup
        # mount -t cgroup -o cpuacct xxx /cgroup2
        # cat /proc/cgroups | grep cpuacct
        cpuacct 2       1       1
        # umount /cgroup
        # umount /cgroup2
        # cat /proc/cgroups | grep cpuacct
        cpuacct 2       1       1

You'll see cgroupfs will never be freed.

v2: change to take the refcnt and drop it after kernfs_mount().

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 37d94a2..eaffc08 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1477,6 +1477,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	struct cgroup_sb_opts opts;
 	struct dentry *dentry;
 	int ret;
+	bool new_root = false;
 
 	/*
 	 * The first time anyone tries to mount a cgroup, enable the list
@@ -1536,6 +1537,10 @@ retry:
 		 * destruction to complete so that the subsystems are free.
 		 * We can use wait_queue for the wait but this path is
 		 * super cold.  Let's just sleep for a bit and retry.
+		 *
+		 * Take a reference so root won't be freed after we drop
+		 * cgroup mutexes, and drop it after we've done the real
+		 * mount through kernfs.
 		 */
 		if (!atomic_inc_not_zero(&root->top_cgroup.refcnt)) {
 			mutex_unlock(&cgroup_mutex);
@@ -1551,6 +1556,7 @@ retry:
 	}
 
 	/* no such thing, create a new one */
+	new_root = true;
 	root = cgroup_root_from_opts(&opts);
 	if (IS_ERR(root)) {
 		ret = PTR_ERR(root);
@@ -1572,7 +1578,7 @@ out_unlock:
 		return ERR_PTR(ret);
 
 	dentry = kernfs_mount(fs_type, flags, root->kf_root);
-	if (IS_ERR(dentry))
+	if (IS_ERR(dentry) || !new_root)
 		cgroup_put(&root->top_cgroup);
 	return dentry;
 }
-- 
1.8.0.2

