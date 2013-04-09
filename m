Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936698Ab3DICXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 22:23:47 -0400
Received: from mail-qe0-f43.google.com ([209.85.128.43]:63648 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936592Ab3DICXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 22:23:44 -0400
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, acme@ghostprotocols.net,
        eranian@google.com, namhyung.kim@lge.com, lizefan@huawei.com,
        mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/3] cgroup: make sure parent won't be destroyed before its children
Date: Mon,  8 Apr 2013 19:23:31 -0700
Message-Id: <1365474213-13354-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365474213-13354-1-git-send-email-tj@kernel.org>
References: <1365474213-13354-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizefan@huawei.com>

Suppose we rmdir a cgroup and there're still css refs, this cgroup won't
be freed. Then we rmdir the parent cgroup, and the parent is freed
immediately due to css ref draining to 0. Now it would be a disaster if
the still-alive child cgroup tries to access its parent.

Make sure this won't happen.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ba3e24a..d7dfa64 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -876,6 +876,13 @@ static void cgroup_free_fn(struct work_struct *work)
 	mutex_unlock(&cgroup_mutex);
 
 	/*
+	 * We get a ref to the parent's dentry, and put the ref when
+	 * this cgroup is being freed, so it's guaranteed that the
+	 * parent won't be destroyed before its children.
+	 */
+	dput(cgrp->parent->dentry);
+
+	/*
 	 * Drop the active superblock reference that we took when we
 	 * created the cgroup
 	 */
@@ -4168,6 +4175,9 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	for_each_subsys(root, ss)
 		dget(dentry);
 
+	/* hold a ref to the parent's dentry */
+	dget(parent->dentry);
+
 	/* creation succeeded, notify subsystems */
 	for_each_subsys(root, ss) {
 		err = online_css(ss, cgrp);
-- 
1.8.1.4

