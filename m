Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964815AbaGOXcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:32:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45609 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934096AbaGOXOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.15 68/84] cgroup: fix mount failure in a corner case
Date: Tue, 15 Jul 2014 16:18:05 -0700
Message-Id: <20140715231715.225164244@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

commit 970317aa48c6ef66cd023c039c2650c897bad927 upstream.

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

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[lizf: Backported to 3.15:
 - s/percpu_ref_tryget_live/atomic_inc_not_zero/
 - Use goto instead of calling restart_syscall()
 - Add cgroup_tree_mutex]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1484,10 +1484,12 @@ static struct dentry *cgroup_mount(struc
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
@@ -1514,6 +1516,29 @@ retry:
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
+		if (!atomic_inc_not_zero(&ss->root->cgrp.refcnt)) {
+			mutex_unlock(&cgroup_mutex);
+			mutex_unlock(&cgroup_tree_mutex);
+			msleep(10);
+			mutex_lock(&cgroup_tree_mutex);
+			mutex_lock(&cgroup_mutex);
+			goto retry;
+		}
+		cgroup_put(&ss->root->cgrp);
+	}
+
 	for_each_root(root) {
 		bool name_match = false;
 


