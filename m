Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632Ab3FRSQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 14:16:25 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:37761 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253Ab3FRSQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 14:16:23 -0400
Date: Tue, 18 Jun 2013 11:16:18 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 1/2][UPDATED] cgroup: make serial_nr_cursor available
 throughout cgroup.c
Message-ID: <20130618181618.GA1596@htj.dyndns.org>
References: <51C03AF2.7050702@huawei.com>
 <51C03C41.2040704@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51C03C41.2040704@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 794611a1dfcb055d7d41ce133378dd8197d73e38 Mon Sep 17 00:00:00 2001
From: Li Zefan <lizefan@huawei.com>
Date: Tue, 18 Jun 2013 18:53:53 +0800

The next patch will use it to determine if a cgroup is newly created
while we're iterating the cgroup hierarchy.

tj: Rephrased the comment on top of cgroup_serial_nr_cursor.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied to cgroup/for-3.11 with minor update.

Thanks.

 kernel/cgroup.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1d4f471..e6571ca 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -198,6 +198,15 @@ static DEFINE_IDR(cgroup_hierarchy_idr);
 
 static struct cgroup_name root_cgroup_name = { .name = "/" };
 
+/*
+ * Assign a monotonically increasing serial number to cgroups.  It
+ * guarantees cgroups with bigger numbers are newer than those with smaller
+ * numbers.  Also, as cgroups are always appended to the parent's
+ * ->children list, it guarantees that sibling cgroups are always sorted in
+ * the ascending serial number order on the list.
+ */
+static atomic64_t cgroup_serial_nr_cursor = ATOMIC64_INIT(0);
+
 /* This flag indicates whether tasks in the fork and exit paths should
  * check for fork/exit handlers to call. This avoids us having to do
  * extra work in the fork/exit path if none of the subsystems need to
@@ -4222,7 +4231,6 @@ static void offline_css(struct cgroup_subsys *ss, struct cgroup *cgrp)
 static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 			     umode_t mode)
 {
-	static atomic64_t serial_nr_cursor = ATOMIC64_INIT(0);
 	struct cgroup *cgrp;
 	struct cgroup_name *name;
 	struct cgroupfs_root *root = parent->root;
@@ -4309,13 +4317,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 		goto err_free_all;
 	lockdep_assert_held(&dentry->d_inode->i_mutex);
 
-	/*
-	 * Assign a monotonically increasing serial number.  With the list
-	 * appending below, it guarantees that sibling cgroups are always
-	 * sorted in the ascending serial number order on the parent's
-	 * ->children.
-	 */
-	cgrp->serial_nr = atomic64_inc_return(&serial_nr_cursor);
+	cgrp->serial_nr = atomic64_inc_return(&cgroup_serial_nr_cursor);
 
 	/* allocation complete, commit to creation */
 	list_add_tail(&cgrp->allcg_node, &root->allcg_list);
-- 
1.8.2.1

