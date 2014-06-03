Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaFCEF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 00:05:26 -0400
Received: from [119.145.14.64] ([119.145.14.64]:45296 "EHLO
	szxga01-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaFCEFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 00:05:25 -0400
Message-ID: <538D4956.5050205@huawei.com>
Date: Tue, 3 Jun 2014 12:04:38 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 1/3] cgroup: don't destroy the default root
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default root is allocated and initialized at boot, so we
shouldn't destroy the default root when it's umounted, otherwise
it will lead to disaster.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a5f75ac..f73fe48 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1027,12 +1027,14 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
 static void cgroup_get(struct cgroup *cgrp)
 {
 	WARN_ON_ONCE(cgroup_is_dead(cgrp));
-	css_get(&cgrp->self);
+	if (!(cgrp->self.flags & CSS_NO_REF))
+		css_get(&cgrp->self);
 }
 
 static void cgroup_put(struct cgroup *cgrp)
 {
-	css_put(&cgrp->self);
+	if (!(cgrp->self.flags & CSS_NO_REF))
+		css_put(&cgrp->self);
 }
 
 /**
@@ -1781,10 +1783,12 @@ static void cgroup_kill_sb(struct super_block *sb)
 	 * This prevents new mounts by disabling percpu_ref_tryget_live().
 	 * cgroup_mount() may wait for @root's release.
 	 */
-	if (css_has_online_children(&root->cgrp.self))
+	if (css_has_online_children(&root->cgrp.self)) {
 		cgroup_put(&root->cgrp);
-	else
-		percpu_ref_kill(&root->cgrp.self.refcnt);
+	} else {
+		if (root != &cgrp_dfl_root)
+			percpu_ref_kill(&root->cgrp.self.refcnt);
+	}
 
 	kernfs_kill_sb(sb);
 }
-- 
1.8.0.2

