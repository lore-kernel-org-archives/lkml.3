Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259AbaDQFx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 01:53:57 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:37334 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaDQFx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 01:53:56 -0400
Message-ID: <534F6C44.2060800@huawei.com>
Date: Thu, 17 Apr 2014 13:53:08 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH] cgroup: fix the retry path of cgroup_mount()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we hit the retry path, we'll call parse_cgroupfs_options() again,
but the string we pass to it has been modified by the previous call
to this function.

This bug can be observed by:

  # mount -t cgroup -o name=foo,cpuset xxx /mnt && umount /mnt && \
    mount -t cgroup -o name=foo,cpuset xxx /mnt
  mount: wrong fs type, bad option, bad superblock on xxx,
         missing codepage or helper program, or other error
  ...

The second mount passed "name=foo,cpuset" to the parser, and then it
hit the retry path and call the parser again, but this time the string
passed to the parser is "name=foo".

To fix this, we avoid calling parse_cgroupfs_options() again in this
case.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 08c4439..9d6be07 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1580,7 +1580,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	 */
 	if (!use_task_css_set_links)
 		cgroup_enable_task_cg_lists();
-retry:
+
 	mutex_lock(&cgroup_tree_mutex);
 	mutex_lock(&cgroup_mutex);
 
@@ -1588,7 +1588,7 @@ retry:
 	ret = parse_cgroupfs_options(data, &opts);
 	if (ret)
 		goto out_unlock;
-
+retry:
 	/* look for a matching existing root */
 	if (!opts.subsys_mask && !opts.none && !opts.name) {
 		cgrp_dfl_root_visible = true;
@@ -1647,9 +1647,9 @@ retry:
 		if (!atomic_inc_not_zero(&root->cgrp.refcnt)) {
 			mutex_unlock(&cgroup_mutex);
 			mutex_unlock(&cgroup_tree_mutex);
-			kfree(opts.release_agent);
-			kfree(opts.name);
 			msleep(10);
+			mutex_lock(&cgroup_tree_mutex);
+			mutex_lock(&cgroup_mutex);
 			goto retry;
 		}
 
-- 
1.8.0.2

