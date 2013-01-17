Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759253Ab3AQIET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 03:04:19 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:35656 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758644Ab3AQIES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 03:04:18 -0500
Message-ID: <50F7B040.2020906@huawei.com>
Date: Thu, 17 Jan 2013 16:03:12 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 1/6] cgroup: initialize cgrp->dentry before css_alloc()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this change, it's guaranteed that cgroup_path() won't see NULL
cgrp->dentry, and thus we can remove the NULL check in it.

(Well, it's not true, because dummptop.dentry is always NULL)

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a893985..23a0ce1 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1764,7 +1764,7 @@ int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 	rcu_lockdep_assert(rcu_read_lock_held() || cgroup_lock_is_held(),
 			   "cgroup_path() called without proper locking");
 
-	if (!dentry || cgrp == dummytop) {
+	if (cgrp == dummytop) {
 		/*
 		 * Inactive subsystems have no dentry for their root
 		 * cgroup
@@ -4150,6 +4150,9 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 
 	init_cgroup_housekeeping(cgrp);
 
+	dentry->d_fsdata = cgrp;
+	cgrp->dentry = dentry;
+
 	cgrp->parent = parent;
 	cgrp->root = parent->root;
 	cgrp->top_cgroup = parent->top_cgroup;
@@ -4187,8 +4190,6 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	lockdep_assert_held(&dentry->d_inode->i_mutex);
 
 	/* allocation complete, commit to creation */
-	dentry->d_fsdata = cgrp;
-	cgrp->dentry = dentry;
 	list_add_tail(&cgrp->allcg_node, &root->allcg_list);
 	list_add_tail_rcu(&cgrp->sibling, &cgrp->parent->children);
 	root->number_of_cgroups++;
-- 
1.8.0.2

