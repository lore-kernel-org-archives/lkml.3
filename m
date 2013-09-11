Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab3IKFhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:37:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11316 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab3IKE5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:17 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=_WzgRhmuAjcA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Yf8OGtSgGmEA:10 a=i0EeH86SAAAA:8 a=VwQbUJbxAAAA:8 a=c8mzyqaV5ZIASwUaoV8A:9 a=hPjdaMEvmhQA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042917.861283797@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>
Subject: [153/251] cgroup: fix umount vs cgroup_cfts_commit() race
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0153-cgroup-fix-umount-vs-cgroup_cfts_commit-race.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

[ Upstream commit 084457f284abf6789d90509ee11dae383842b23b ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/cgroup.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9cf9102..79e528f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2761,13 +2761,17 @@ static void cgroup_cfts_commit(struct cgroup_subsys *ss,
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
@@ -2790,6 +2794,9 @@ static void cgroup_cfts_commit(struct cgroup_subsys *ss,
 		dput(cgrp->dentry);
 	}
 
+	if (sb)
+		deactivate_super(sb);
+
 	mutex_unlock(&cgroup_cft_mutex);
 }
 
-- 
1.7.10.4


