Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbaF0JOi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 05:14:38 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:45269 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaF0JOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 05:14:37 -0400
Message-ID: <53AD35A8.7030908@huawei.com>
Date: Fri, 27 Jun 2014 17:13:12 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] cgroup: fix mount failure in a corner case
References: <53AD18D0.3090100@huawei.com> <53AD2852.2060304@huawei.com>
In-Reply-To: <53AD2852.2060304@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Made a mistake again.. :(


==============

From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 1/3] cgroup: fix mount failure in a corner case

  # cat test.sh
  #! /bin/bash

  mount -t cgroup -o cpu xxx /cgroup
  umount /cgroup

  mount -t cgroup -o cpu,cpuacct xxx /cgroup
  umount /cgroup
  # ./test.sh
  mount: xxx already mounted or /cgroup busy
  mount: according to mtab, xxx is already mounted on /cgroup

It's because the cgroupfs_root of the first mount was under destruction
asynchronously.

Fix this by delaying and then retrying mount for this case.

v2:
- use percpu_ref_tryget_live() rather that introducing
  percpu_ref_alive(). (Tejun)
- adjust comment.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1c65f24..b94449f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1648,10 +1648,12 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 			 int flags, const char *unused_dev_name,
 			 void *data)
 {
+	struct cgroup_subsys *ss;
 	struct cgroup_root *root;
 	struct cgroup_sb_opts opts;
 	struct dentry *dentry;
 	int ret;
+	int i, j = -1;
 	bool new_sb;
 
 	/*
@@ -1677,6 +1679,25 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		goto out_unlock;
 	}
 
+	/*
+	 * Destruction of cgroup root is asynchronous, so we may fail to
+	 * mount a cgroupfs if it immediately follows a umount. Let's wait
+	 * a little bit and retry.
+	 */
+	for_each_subsys(ss, i) {
+		if (!(opts.subsys_mask & (1 << i)) ||
+		    ss->root == &cgrp_dfl_root)
+			continue;
+
+		if (!percpu_ref_tryget_live(&ss->root->cgrp.self.refcnt)) {
+			mutex_unlock(&cgroup_mutex);
+			msleep(10);
+			ret = restart_syscall();
+			goto out_free;
+		}
+		j = i;
+	}
+
 	for_each_root(root) {
 		bool name_match = false;
 
@@ -1763,6 +1784,14 @@ out_free:
 	kfree(opts.release_agent);
 	kfree(opts.name);
 
+	for_each_subsys(ss, i) {
+		if (i > j)
+			break;
+		if (!(opts.subsys_mask & (1 << i)))
+			continue;
+		cgroup_put(&ss->root->cgrp);
+	}
+
 	if (ret)
 		return ERR_PTR(ret);
 
-- 
1.8.0.2

