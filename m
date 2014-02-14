Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbaBNI57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 03:57:59 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:56800 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbaBNI55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 03:57:57 -0500
Message-ID: <52FDDA77.6070606@huawei.com>
Date: Fri, 14 Feb 2014 16:57:27 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernfs: fix kernfs_node_from_dentry()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently kernfs_node_from_dentry() returns NULL for root dentry,
because root_dentry->d_op == NULL.

Due to this bug cgroupstats_build() returns -EINVAL for root cgroup.

  # mount -t cgroup -o cpuacct /cgroup
  # Documentation/accounting/getdelays -C /cgroup
  fatal reply error,  errno -22

With this fix:

  # Documentation/accounting/getdelays -C /cgroup
  sleeping 305, blocked 0, running 1, stopped 0, uninterruptible 1

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 fs/kernfs/dir.c             | 2 +-
 fs/kernfs/kernfs-internal.h | 1 +
 fs/kernfs/mount.c           | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 939684e..300f57b 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -501,7 +501,7 @@ const struct dentry_operations kernfs_dops = {
  */
 struct kernfs_node *kernfs_node_from_dentry(struct dentry *dentry)
 {
-	if (dentry->d_op == &kernfs_dops)
+	if (dentry->d_sb->s_op == &kernfs_sops)
 		return dentry->d_fsdata;
 	return NULL;
 }
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index a91d7a1..8be13b2 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -65,6 +65,7 @@ struct kernfs_super_info {
 };
 #define kernfs_info(SB) ((struct kernfs_super_info *)(SB->s_fs_info))
 
+extern const struct super_operations kernfs_sops;
 extern struct kmem_cache *kernfs_node_cache;
 
 /*
diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index e5b28b0..405279b 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -39,7 +39,7 @@ static int kernfs_sop_show_options(struct seq_file *sf, struct dentry *dentry)
 	return 0;
 }
 
-static const struct super_operations kernfs_sops = {
+const struct super_operations kernfs_sops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= generic_delete_inode,
 	.evict_inode	= kernfs_evict_inode,
-- 
1.8.0.2

