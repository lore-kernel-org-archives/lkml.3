Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab3LLTRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 14:17:20 -0500
Received: from relay.parallels.com ([195.214.232.42]:36784 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab3LLTRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 14:17:18 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: <cgroups@vger.kernel.org>, <devel@openvz.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH cgroup/for-3.14] cgroup: fix fail path in cgroup_load_subsys()
Date: Thu, 12 Dec 2013 23:17:08 +0400
Message-ID: <1386875828-5075-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.25.135]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calling cgroup_unload_subsys() from cgroup_load_subsys() after
online_css() failure will result in a NULL ptr dereference on attempt to
offline_css(), because online_css() only assigns css to cgroup on
success. Let's fix that by skipping calls to offline_css() and
css_free() in cgroup_unload_subsys() if there is no css, and freeing css
in cgroup_load_subsys() on online_css() failure.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 402f7aa..7030f04 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4652,8 +4652,10 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
 	write_unlock(&css_set_lock);
 
 	ret = online_css(css);
-	if (ret)
+	if (ret) {
+		ss->css_free(css);
 		goto err_unload;
+	}
 
 	/* success! */
 	mutex_unlock(&cgroup_root_mutex);
@@ -4680,6 +4682,7 @@ EXPORT_SYMBOL_GPL(cgroup_load_subsys);
 void cgroup_unload_subsys(struct cgroup_subsys *ss)
 {
 	struct cgrp_cset_link *link;
+	struct cgroup_subsys_state *css;
 
 	BUG_ON(ss->module == NULL);
 
@@ -4693,7 +4696,9 @@ void cgroup_unload_subsys(struct cgroup_subsys *ss)
 	mutex_lock(&cgroup_mutex);
 	mutex_lock(&cgroup_root_mutex);
 
-	offline_css(cgroup_css(cgroup_dummy_top, ss));
+	css = cgroup_css(cgroup_dummy_top, ss);
+	if (css)
+		offline_css(css);
 
 	/* deassign the subsys_id */
 	cgroup_subsys[ss->subsys_id] = NULL;
@@ -4720,7 +4725,8 @@ void cgroup_unload_subsys(struct cgroup_subsys *ss)
 	 * need to free before marking as null because ss->css_free needs
 	 * the cgrp->subsys pointer to find their state.
 	 */
-	ss->css_free(cgroup_css(cgroup_dummy_top, ss));
+	if (css)
+		ss->css_free(css);
 	RCU_INIT_POINTER(cgroup_dummy_top->subsys[ss->subsys_id], NULL);
 
 	mutex_unlock(&cgroup_root_mutex);
-- 
1.7.1

