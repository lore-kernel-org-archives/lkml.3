Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab3FRKl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 06:41:26 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:53739 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab3FRKlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 06:41:23 -0400
Message-ID: <51C03913.5020008@huawei.com>
Date: Tue, 18 Jun 2013 18:40:19 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 1/3] cgroup: fix umount vs cgroup_cfs_commit() race
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_cfs_commit() uses dget() to keep cgroup alive after cgroup_mutex
is dropped, but dget() won't prevent cgroupfs from being umounted. When
the race happens, vfs will see some dentries with non-zero refcnt while
umount is in process.

Keep running this:
  mount -t cgroup -o blkio xxx /cgroup
  umount /cgroup

And this:
  modprobe cfq-iosched
  rmmod cfs-iosched

After a while, the BUG() in shrink_dcache_for_umount_subtree() may
be triggered:

  BUG: Dentry xxx{i=0,n=blkio.yyy} still in use (1) [umount of cgroup cgroup]

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 25f1054..482252a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2788,13 +2788,17 @@ static void cgroup_cfts_commit(struct cgroup_subsys *ss,
 {
 	LIST_HEAD(pending);
 	struct cgroup *cgrp, *n;
+	struct super_block *sb = ss->root->sb;
 
 	/* %NULL @cfts indicates abort and don't bother if @ss isn't attached */
-	if (cfts && ss->root != &rootnode) {
+	if (cfts && ss->root != &rootnode &&
+	    atomic_inc_not_zero(sb->s_active)) {
 		list_for_each_entry(cgrp, &ss->root->allcg_list, allcg_node) {
 			dget(cgrp->dentry);
 			list_add_tail(&cgrp->cft_q_node, &pending);
 		}
+	} else {
+		sb = NULL;
 	}
 
 	mutex_unlock(&cgroup_mutex);
@@ -2817,6 +2821,9 @@ static void cgroup_cfts_commit(struct cgroup_subsys *ss,
 		dput(cgrp->dentry);
 	}
 
+	if (sb)
+		deactivate_super(sb);
+
 	mutex_unlock(&cgroup_cft_mutex);
 }
 
-- 
1.8.0.2
