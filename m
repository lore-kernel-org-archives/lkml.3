Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbaEFLuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:50:55 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:32855 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841AbaEFLuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:50:50 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/4] cgroup: use restart_syscall() for retries after offline waits in cgroup_subtree_control_write()
Date: Tue,  6 May 2014 07:50:43 -0400
Message-Id: <1399377044-29873-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399377044-29873-1-git-send-email-tj@kernel.org>
References: <1399377044-29873-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After waiting for a child to finish offline,
cgroup_subtree_control_write() jumps up to retry from after the input
parsing and active protection breaking.  This retry makes the
scheduled locking update more difficult.  Let's simplify it by
returning with restart_syscall() for retries.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9066fe9..3ced79a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2535,7 +2535,7 @@ out_finish:
 static int cgroup_subtree_control_write(struct cgroup_subsys_state *dummy_css,
 					struct cftype *cft, char *buffer)
 {
-	unsigned int enable_req = 0, disable_req = 0, enable, disable;
+	unsigned int enable = 0, disable = 0;
 	struct cgroup *cgrp = dummy_css->cgroup, *child;
 	struct cgroup_subsys *ss;
 	char *tok, *p;
@@ -2552,11 +2552,11 @@ static int cgroup_subtree_control_write(struct cgroup_subsys_state *dummy_css,
 				continue;
 
 			if (*tok == '+') {
-				enable_req |= 1 << ssid;
-				disable_req &= ~(1 << ssid);
+				enable |= 1 << ssid;
+				disable &= ~(1 << ssid);
 			} else if (*tok == '-') {
-				disable_req |= 1 << ssid;
-				enable_req &= ~(1 << ssid);
+				disable |= 1 << ssid;
+				enable &= ~(1 << ssid);
 			} else {
 				return -EINVAL;
 			}
@@ -2574,9 +2574,6 @@ static int cgroup_subtree_control_write(struct cgroup_subsys_state *dummy_css,
 	 */
 	cgroup_get(cgrp);
 	kernfs_break_active_protection(cgrp->control_kn);
-retry:
-	enable = enable_req;
-	disable = disable_req;
 
 	mutex_lock(&cgroup_tree_mutex);
 
@@ -2606,7 +2603,9 @@ retry:
 				schedule();
 				finish_wait(&child->offline_waitq, &wait);
 				cgroup_put(child);
-				goto retry;
+
+				ret = restart_syscall();
+				goto out_unbreak;
 			}
 
 			/* unavailable or not enabled on the parent? */
@@ -2690,6 +2689,7 @@ out_unlock:
 	mutex_unlock(&cgroup_mutex);
 out_unlock_tree:
 	mutex_unlock(&cgroup_tree_mutex);
+out_unbreak:
 	kernfs_unbreak_active_protection(cgrp->control_kn);
 	cgroup_put(cgrp);
 	return ret;
-- 
1.9.0

