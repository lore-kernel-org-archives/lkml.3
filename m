Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaBHQip (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 11:38:45 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:39528 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbaBHQik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 11:38:40 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/8] cgroup: make cgroup hold onto its kernfs_node
Date: Sat,  8 Feb 2014 11:38:26 -0500
Message-Id: <1391877509-10855-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391877509-10855-1-git-send-email-tj@kernel.org>
References: <1391877509-10855-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup currently releases its kernfs_node when it gets removed.  While
not buggy, this makes cgroup->kn access rules complicated than
necessary and leads to things like get/put protection around
kernfs_remove() in cgroup_destroy_locked().  In addition, we want to
use kernfs_name/path() and friends but also want to be able to
determine a cgroup's name between removal and release.

This patch makes cgroup hold onto its kernfs_node until freed so that
cgroup->kn is always accessible.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6da820d..da8aef0 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -957,6 +957,8 @@ static void cgroup_free_fn(struct work_struct *work)
 
 	cgroup_pidlist_destroy_all(cgrp);
 
+	kernfs_put(cgrp->kn);
+
 	kfree(rcu_dereference_raw(cgrp->name));
 	kfree(cgrp);
 }
@@ -3784,6 +3786,12 @@ static long cgroup_create(struct cgroup *parent, const char *name_str,
 	}
 	cgrp->kn = kn;
 
+	/*
+	 * This extra ref will be put in cgroup_free_fn() and guarantees
+	 * that @cgrp->kn is always accessible.
+	 */
+	kernfs_get(kn);
+
 	cgrp->serial_nr = cgroup_serial_nr_next++;
 
 	/* allocation complete, commit to creation */
@@ -3964,7 +3972,6 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 {
 	struct cgroup *child;
 	struct cgroup_subsys_state *css;
-	struct kernfs_node *kn;
 	bool empty;
 	int ssid;
 
@@ -4042,13 +4049,8 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	 * clearing of cgrp->kn->priv backpointer, which should happen
 	 * after all files under it have been removed.
 	 */
-	kn = cgrp->kn;
-	kernfs_get(kn);
-
-	kernfs_remove(cgrp->kn);
-
+	kernfs_remove(cgrp->kn);	/* @cgrp has an extra ref on its kn */
 	RCU_INIT_POINTER(*(void __rcu __force **)&cgrp->kn->priv, NULL);
-	kernfs_put(kn);
 
 	mutex_lock(&cgroup_mutex);
 
-- 
1.8.5.3

