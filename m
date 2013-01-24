Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab3AXGbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 01:31:15 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:61581 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab3AXGbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 01:31:08 -0500
Message-ID: <5100D4FE.9080205@huawei.com>
Date: Thu, 24 Jan 2013 14:30:22 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH v2 1/6] cgroup: initialize cgrp->dentry before css_alloc()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this change, we're guaranteed that cgroup_path() won't see NULL
cgrp->dentry, and thus we can remove the NULL check in it.

(Well, it's not true, because dummptop.dentry is always NULL)

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ad3359f..b9a76e2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1767,7 +1767,7 @@ int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 	rcu_lockdep_assert(rcu_read_lock_held() || cgroup_lock_is_held(),
 			   "cgroup_path() called without proper locking");
 
-	if (!dentry || cgrp == dummytop) {
+	if (cgrp == dummytop) {
 		/*
 		 * Inactive subsystems have no dentry for their root
 		 * cgroup
@@ -4153,6 +4153,9 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 
 	init_cgroup_housekeeping(cgrp);
 
+	dentry->d_fsdata = cgrp;
+	cgrp->dentry = dentry;
+
 	cgrp->parent = parent;
 	cgrp->root = parent->root;
 	cgrp->top_cgroup = parent->top_cgroup;
@@ -4190,8 +4193,6 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	lockdep_assert_held(&dentry->d_inode->i_mutex);
 
 	/* allocation complete, commit to creation */
-	dentry->d_fsdata = cgrp;
-	cgrp->dentry = dentry;
 	list_add_tail(&cgrp->allcg_node, &root->allcg_list);
 	list_add_tail_rcu(&cgrp->sibling, &cgrp->parent->children);
 	root->number_of_cgroups++;
-- 
1.8.0.2
