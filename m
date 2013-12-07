Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab3LGH6S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 02:58:18 -0500
Received: from relay.parallels.com ([195.214.232.42]:46411 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab3LGH6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 02:58:16 -0500
From: Vladimir Davydov <vdavydov@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: <cgroups@vger.kernel.org>, <devel@openvz.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH] cgroup: fix fail path in cgroup_load_subsys()
Date: Sat, 7 Dec 2013 11:58:05 +0400
Message-ID: <1386403085-24866-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.25.78]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should not call cgroup_unload_subsys() if online_css() fails, because
online_css() does not assign css to cgroup on failure, while
offline_css() called from cgroup_unload_subsys() expects it is assigned.
So let's call everything we need to rollback inline without involving
cgroup_unload_subsys().

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 8b729c2..3cd7247 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4861,10 +4861,8 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
 	 */
 	css = ss->css_alloc(cgroup_css(cgroup_dummy_top, ss));
 	if (IS_ERR(css)) {
-		/* failure case - need to deassign the cgroup_subsys[] slot. */
-		cgroup_subsys[ss->subsys_id] = NULL;
-		mutex_unlock(&cgroup_mutex);
-		return PTR_ERR(css);
+		ret = PTR_ERR(css);
+		goto out_err;
 	}
 
 	list_add(&ss->sibling, &cgroup_dummy_root.subsys_list);
@@ -4873,6 +4871,10 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
 	/* our new subsystem will be attached to the dummy hierarchy. */
 	init_css(css, ss, cgroup_dummy_top);
 
+	ret = online_css(css);
+	if (ret)
+		goto free_css;
+
 	/*
 	 * Now we need to entangle the css into the existing css_sets. unlike
 	 * in cgroup_init_subsys, there are now multiple css_sets, so each one
@@ -4896,18 +4898,17 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
 	}
 	write_unlock(&css_set_lock);
 
-	ret = online_css(css);
-	if (ret)
-		goto err_unload;
-
 	/* success! */
 	mutex_unlock(&cgroup_mutex);
 	return 0;
 
-err_unload:
+free_css:
+	list_del(&ss->sibling);
+	ss->css_free(css);
+out_err:
+	/* failure case - need to deassign the cgroup_subsys[] slot. */
+	cgroup_subsys[ss->subsys_id] = NULL;
 	mutex_unlock(&cgroup_mutex);
-	/* @ss can't be mounted here as try_module_get() would fail */
-	cgroup_unload_subsys(ss);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(cgroup_load_subsys);
-- 
1.7.10.4

