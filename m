Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbaFLGcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 02:32:24 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:32970 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbaFLGcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 02:32:22 -0400
Message-ID: <5399496D.6060003@huawei.com>
Date: Thu, 12 Jun 2014 14:32:13 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 3/5] cgroup: fix mount failure in a corner case
References: <53994943.60703@huawei.com>
In-Reply-To: <53994943.60703@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Fix this by delaying and then retrying mount in this case.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1c65f24..bd37e8d 100644
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
+	int i;
 	bool new_sb;
 
 	/*
@@ -1677,6 +1679,22 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		goto out_unlock;
 	}
 
+	/*
+	 * If some subsystems have been bound to existing cgroup hierarchies,
+	 * but those hierachies are being destroyed, let's wait a little bit
+	 * and retry.
+	 */
+	for_each_subsys(ss, i) {
+		if (!(opts.subsys_mask & (1 << i)))
+			continue;
+		if (!percpu_ref_alive(&ss->root->cgrp.self.refcnt)) {
+			mutex_unlock(&cgroup_mutex);
+			msleep(10);
+			ret = restart_syscall();
+			goto out_free;
+		}
+	}
+
 	for_each_root(root) {
 		bool name_match = false;
 
-- 
1.8.0.2

