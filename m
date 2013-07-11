Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab3GKOuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:50:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42904 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649Ab3GKOZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:25:44 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 19/98] cgroup: fix umount vs cgroup_cfts_commit() race
Date: Thu, 11 Jul 2013 15:23:49 +0100
Message-Id: <1373552708-15235-20-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
References: <1373552708-15235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

commit 084457f284abf6789d90509ee11dae383842b23b upstream.

cgroup_cfts_commit() uses dget() to keep cgroup alive after cgroup_mutex
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
Signed-off-by: Tejun Heo <tj@kernel.org>
[ luis: backported to 3.5:
  - fixed build error: added '&' to atomic_inc_not_zero parameter;
    this was fixed upstream by commit e8c82d20a9f729cf4b9f73043f7fd4e0872bebfd ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/cgroup.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 07ba52a..3b3fa5b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2771,13 +2771,17 @@ static void cgroup_cfts_commit(struct cgroup_subsys *ss,
 {
 	LIST_HEAD(pending);
 	struct cgroup *cgrp, *n;
+	struct super_block *sb = ss->root->sb;
 
 	/* %NULL @cfts indicates abort and don't bother if @ss isn't attached */
-	if (cfts && ss->root != &rootnode) {
+	if (cfts && ss->root != &rootnode &&
+	    atomic_inc_not_zero(&sb->s_active)) {
 		list_for_each_entry(cgrp, &ss->root->allcg_list, allcg_node) {
 			dget(cgrp->dentry);
 			list_add_tail(&cgrp->cft_q_node, &pending);
 		}
+	} else {
+		sb = NULL;
 	}
 
 	mutex_unlock(&cgroup_mutex);
@@ -2800,6 +2804,9 @@ static void cgroup_cfts_commit(struct cgroup_subsys *ss,
 		dput(cgrp->dentry);
 	}
 
+	if (sb)
+		deactivate_super(sb);
+
 	mutex_unlock(&cgroup_cft_mutex);
 }
 
-- 
1.8.1.2

