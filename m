Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbaF3OSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:18:39 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:51877 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaF3OSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:18:37 -0400
Date: Mon, 30 Jun 2014 10:18:33 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] cgroup: fix mount failure in a corner case
Message-ID: <20140630141833.GA14807@htj.dyndns.org>
References: <53B0DE66.5080100@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B0DE66.5080100@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied with minor updates.

Thanks.
------- 8< -------
>From 970317aa48c6ef66cd023c039c2650c897bad927 Mon Sep 17 00:00:00 2001
From: Li Zefan <lizefan@huawei.com>
Date: Mon, 30 Jun 2014 11:49:58 +0800
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

v3:
- put the refcnt immediately after getting it. (Tejun)

v2:
- use percpu_ref_tryget_live() rather that introducing
  percpu_ref_alive(). (Tejun)
- adjust comment.

tj: Updated the comment a bit.

Cc: <stable@vger.kernel.org> # 3.15
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index d9a8be9..6406866 100644
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
@@ -1677,6 +1679,27 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		goto out_unlock;
 	}
 
+	/*
+	 * Destruction of cgroup root is asynchronous, so subsystems may
+	 * still be dying after the previous unmount.  Let's drain the
+	 * dying subsystems.  We just need to ensure that the ones
+	 * unmounted previously finish dying and don't care about new ones
+	 * starting.  Testing ref liveliness is good enough.
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
+		cgroup_put(&ss->root->cgrp);
+	}
+
 	for_each_root(root) {
 		bool name_match = false;
 
-- 
1.9.3

