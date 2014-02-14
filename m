Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaBNIy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 03:54:58 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:53833 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbaBNIyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 03:54:55 -0500
Message-ID: <52FDD9C4.1070001@huawei.com>
Date: Fri, 14 Feb 2014 16:54:28 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 1/3] cgroup: fix locking in cgroupstats_build()
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

css_set_lock has been converted to css_set_rwsem, and rwsem can't
nested inside rcu_read_lock.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index af4ecc3..0e794ca 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2997,6 +2997,8 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
 	    kernfs_type(kn) != KERNFS_DIR)
 		return -EINVAL;
 
+	mutex_lock(&cgroup_mutex);
+
 	/*
 	 * We aren't being called from kernfs and there's no guarantee on
 	 * @kn->priv's validity.  For this and css_tryget_from_dir(),
@@ -3004,10 +3006,12 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
 	 */
 	rcu_read_lock();
 	cgrp = rcu_dereference(kn->priv);
-	if (!cgrp) {
+	if (!cgrp || cgroup_is_dead(cgrp)) {
 		rcu_read_unlock();
+		mutex_unlock(&cgroup_mutex);
 		return -ENOENT;
 	}
+	rcu_read_unlock();
 
 	css_task_iter_start(&cgrp->dummy_css, &it);
 	while ((tsk = css_task_iter_next(&it))) {
@@ -3032,7 +3036,7 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
 	}
 	css_task_iter_end(&it);
 
-	rcu_read_unlock();
+	mutex_unlock(&cgroup_mutex);
 	return 0;
 }
 
-- 
1.8.0.2
