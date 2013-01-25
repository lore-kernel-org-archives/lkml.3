Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab3AYHLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 02:11:05 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:52473 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135Ab3AYHLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 02:11:02 -0500
Message-ID: <51022FD1.4080800@huawei.com>
Date: Fri, 25 Jan 2013 15:10:09 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH] cgroup: add lock validation in check_for_release()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a long-standing bug that this function was called without any
lock. Add a check to prevent similar issue.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 776ff75..3d21adf 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5028,13 +5028,20 @@ int cgroup_is_descendant(const struct cgroup *cgrp, struct task_struct *task)
 
 static void check_for_release(struct cgroup *cgrp)
 {
-	/* All of these checks rely on RCU to keep the cgroup
-	 * structure alive */
+	/*
+	 * All of these checks rely on RCU or cgroup_mutex to keep the cgroup
+	 * structure alive
+	 */
+	rcu_lockdep_assert(rcu_read_lock_held() || cgroup_lock_is_held(),
+			   "check_for_release() called witout proper locking");
+
 	if (cgroup_is_releasable(cgrp) && !atomic_read(&cgrp->count)
 	    && list_empty(&cgrp->children) && !cgroup_has_css_refs(cgrp)) {
-		/* Control Group is currently removeable. If it's not
+		/*
+		 * Control Group is currently removable. If it's not
 		 * already queued for a userspace notification, queue
-		 * it now */
+		 * it now
+		 */
 		int need_schedule_work = 0;
 		raw_spin_lock(&release_list_lock);
 		if (!cgroup_is_removed(cgrp) &&
-- 
1.8.0.2
