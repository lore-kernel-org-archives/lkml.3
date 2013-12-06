Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783Ab3LFUPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:15:30 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:42694 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab3LFUP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:15:26 -0500
Date: Fri, 6 Dec 2013 15:15:23 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: [PATCH cgroup/for-3.13-fixes] cgroup: fix cgroup_create() error
 handling path
Message-ID: <20131206201523.GG13373@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch was posted back in Aug, got reviewed and acked.
Unfortunately, I somehow forgot to apply it and Vladimir reported the
same problem.  Refreshed the patch, updated commit message and
committed to libata/for-3.13-fixes.  The original posting is

 http://permalink.gmane.org/gmane.linux.kernel.containers/26804

Thanks.

------ 8< ------
>From 266ccd505e8acb98717819cef9d91d66c7b237cc Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 6 Dec 2013 15:07:32 -0500

ae7f164a09 ("cgroup: move cgroup->subsys[] assignment to
online_css()") moved cgroup->subsys[] assignements later in
cgroup_create() but didn't update error handling path accordingly
leading to the following oops and leaking later css's after an
online_css() failure.  The oops is from cgroup destruction path being
invoked on the partially constructed cgroup which is not ready to
handle empty slots in cgrp->subsys[] array.

  BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
  IP: [<ffffffff810eeaa8>] cgroup_destroy_locked+0x118/0x2f0
  PGD a780a067 PUD aadbe067 PMD 0
  Oops: 0000 [#1] SMP
  Modules linked in:
  CPU: 6 PID: 7360 Comm: mkdir Not tainted 3.13.0-rc2+ #69
  Hardware name:
  task: ffff8800b9dbec00 ti: ffff8800a781a000 task.ti: ffff8800a781a000
  RIP: 0010:[<ffffffff810eeaa8>]  [<ffffffff810eeaa8>] cgroup_destroy_locked+0x118/0x2f0
  RSP: 0018:ffff8800a781bd98  EFLAGS: 00010282
  RAX: ffff880586903878 RBX: ffff880586903800 RCX: ffff880586903820
  RDX: ffff880586903860 RSI: ffff8800a781bdb0 RDI: ffff880586903820
  RBP: ffff8800a781bde8 R08: ffff88060e0b8048 R09: ffffffff811d7bc1
  R10: 000000000000008c R11: 0000000000000001 R12: ffff8800a72286c0
  R13: 0000000000000000 R14: ffffffff81cf7a40 R15: 0000000000000001
  FS:  00007f60ecda57a0(0000) GS:ffff8806272c0000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000008 CR3: 00000000a7a03000 CR4: 00000000000007e0
  Stack:
   ffff880586903860 ffff880586903910 ffff8800a72286c0 ffff880586903820
   ffffffff81cf7a40 ffff880586903800 ffff88060e0b8018 ffffffff81cf7a40
   ffff8800b9dbec00 ffff8800b9dbf098 ffff8800a781bec8 ffffffff810ef5bf
  Call Trace:
   [<ffffffff810ef5bf>] cgroup_mkdir+0x55f/0x5f0
   [<ffffffff811c90ae>] vfs_mkdir+0xee/0x140
   [<ffffffff811cb07e>] SyS_mkdirat+0x6e/0xf0
   [<ffffffff811c6a19>] SyS_mkdir+0x19/0x20
   [<ffffffff8169e569>] system_call_fastpath+0x16/0x1b

This patch moves reference bumping inside online_css() loop, clears
css_ar[] as css's are brought online successfully, and updates
err_destroy path so that either a css is fully online and destroyed by
cgroup_destroy_locked() or the error path frees it.  This creates a
duplicate css free logic in the error path but it will be cleaned up
soon.

v2: Li pointed out that cgroup_destroy_locked() would do NULL-deref if
    invoked with a cgroup which doesn't have all css's populated.
    Update cgroup_destroy_locked() so that it skips NULL css's.

Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: Li Zefan <lizefan@huawei.com>
Reported-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: stable@vger.kernel.org # v3.12+
---
 kernel/cgroup.c | 31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 8b729c2..bcb1755 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4426,14 +4426,6 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	list_add_tail_rcu(&cgrp->sibling, &cgrp->parent->children);
 	root->number_of_cgroups++;
 
-	/* each css holds a ref to the cgroup's dentry and the parent css */
-	for_each_root_subsys(root, ss) {
-		struct cgroup_subsys_state *css = css_ar[ss->subsys_id];
-
-		dget(dentry);
-		css_get(css->parent);
-	}
-
 	/* hold a ref to the parent's dentry */
 	dget(parent->dentry);
 
@@ -4445,6 +4437,13 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 		if (err)
 			goto err_destroy;
 
+		/* each css holds a ref to the cgroup's dentry and parent css */
+		dget(dentry);
+		css_get(css->parent);
+
+		/* mark it consumed for error path */
+		css_ar[ss->subsys_id] = NULL;
+
 		if (ss->broken_hierarchy && !ss->warned_broken_hierarchy &&
 		    parent->parent) {
 			pr_warning("cgroup: %s (%d) created nested cgroup for controller \"%s\" which has incomplete hierarchy support. Nested cgroups may change behavior in the future.\n",
@@ -4491,6 +4490,14 @@ err_free_cgrp:
 	return err;
 
 err_destroy:
+	for_each_root_subsys(root, ss) {
+		struct cgroup_subsys_state *css = css_ar[ss->subsys_id];
+
+		if (css) {
+			percpu_ref_cancel_init(&css->refcnt);
+			ss->css_free(css);
+		}
+	}
 	cgroup_destroy_locked(cgrp);
 	mutex_unlock(&cgroup_mutex);
 	mutex_unlock(&dentry->d_inode->i_mutex);
@@ -4652,8 +4659,12 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	 * will be invoked to perform the rest of destruction once the
 	 * percpu refs of all css's are confirmed to be killed.
 	 */
-	for_each_root_subsys(cgrp->root, ss)
-		kill_css(cgroup_css(cgrp, ss));
+	for_each_root_subsys(cgrp->root, ss) {
+		struct cgroup_subsys_state *css = cgroup_css(cgrp, ss);
+
+		if (css)
+			kill_css(css);
+	}
 
 	/*
 	 * Mark @cgrp dead.  This prevents further task migration and child
-- 
1.8.4.2

