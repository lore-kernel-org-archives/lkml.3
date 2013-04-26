Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966Ab3DZCyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 22:54:25 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:58372 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758744Ab3DZCyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 22:54:23 -0400
Message-ID: <5179EC53.6080006@huawei.com>
Date: Fri, 26 Apr 2013 10:54:11 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH] cgroup: fix use-after-free when umounting cgroupfs
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Try:
  # mount -t cgroup xxx /cgroup
  # mkdir /cgroup/sub && rmdir /cgroup/sub && umount /cgroup

And you might see this:

ida_remove called for id=1 which is not allocated.

It's because cgroup_kill_sb() is called to destroy root->cgroup_ida
and free cgrp->root before ida_simple_removed() is called. What's
worse is we're accessing cgrp->root while it has been freed.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6780459..a45aa12 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -845,9 +845,12 @@ static void cgroup_free_fn(struct work_struct *work)
 	 */
 	dput(cgrp->parent->dentry);
 
+	ida_simple_remove(&cgrp->root->cgroup_ida, cgrp->id);
+	
 	/*
 	 * Drop the active superblock reference that we took when we
-	 * created the cgroup
+	 * created the cgroup. This will free cgrp->root, if we are
+	 * holding the last reference to @sb.
 	 */
 	deactivate_super(cgrp->root->sb);
 
@@ -859,7 +862,6 @@ static void cgroup_free_fn(struct work_struct *work)
 
 	simple_xattrs_free(&cgrp->xattrs);
 
-	ida_simple_remove(&cgrp->root->cgroup_ida, cgrp->id);
 	kfree(rcu_dereference_raw(cgrp->name));
 	kfree(cgrp);
 }
-- 
1.8.0.2
