Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750AbaEIVNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 17:13:45 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:38174 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757603AbaEIVNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 17:13:42 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/9] cgroup: separate out cgroup_has_live_children() from cgroup_destroy_locked()
Date: Fri,  9 May 2014 17:13:29 -0400
Message-Id: <1399670015-23463-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399670015-23463-1-git-send-email-tj@kernel.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're expecting another user.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b3708a8..d369f19 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3294,6 +3294,21 @@ css_next_descendant_post(struct cgroup_subsys_state *pos,
 	return css_parent(pos);
 }
 
+static bool cgroup_has_live_children(struct cgroup *cgrp)
+{
+	struct cgroup *child;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(child, &cgrp->children, sibling) {
+		if (!cgroup_is_dead(child)) {
+			rcu_read_unlock();
+			return true;
+		}
+	}
+	rcu_read_unlock();
+	return false;
+}
+
 /**
  * css_advance_task_iter - advance a task itererator to the next css_set
  * @it: the iterator to advance
@@ -4464,7 +4479,6 @@ static void kill_css(struct cgroup_subsys_state *css)
 static int cgroup_destroy_locked(struct cgroup *cgrp)
 	__releases(&cgroup_mutex) __acquires(&cgroup_mutex)
 {
-	struct cgroup *child;
 	struct cgroup_subsys_state *css;
 	bool empty;
 	int ssid;
@@ -4486,15 +4500,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	 * emptiness as dead children linger on it while being destroyed;
 	 * otherwise, "rmdir parent/child parent" may fail with -EBUSY.
 	 */
-	empty = true;
-	rcu_read_lock();
-	list_for_each_entry_rcu(child, &cgrp->children, sibling) {
-		empty = cgroup_is_dead(child);
-		if (!empty)
-			break;
-	}
-	rcu_read_unlock();
-	if (!empty)
+	if (cgroup_has_live_children(cgrp))
 		return -EBUSY;
 
 	/*
-- 
1.9.0

