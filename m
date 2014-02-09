Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaBIN4e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:56:34 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:60876 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbaBINxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:53:06 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/16] cgroup: reimplement cgroup_transfer_tasks() without using css_scan_tasks()
Date: Sun,  9 Feb 2014 08:52:34 -0500
Message-Id: <1391953964-22088-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391953964-22088-1-git-send-email-tj@kernel.org>
References: <1391953964-22088-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reimplement cgroup_transfer_tasks() so that it repeatedly fetches the
first task in the cgroup and then tranfers it.  This achieves the same
result without using css_scan_tasks() which is scheduled to be
removed.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 96a3a85..a5f965c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2849,15 +2849,6 @@ int css_scan_tasks(struct cgroup_subsys_state *css,
 	return 0;
 }
 
-static void cgroup_transfer_one_task(struct task_struct *task, void *data)
-{
-	struct cgroup *new_cgroup = data;
-
-	mutex_lock(&cgroup_mutex);
-	cgroup_attach_task(new_cgroup, task, false);
-	mutex_unlock(&cgroup_mutex);
-}
-
 /**
  * cgroup_trasnsfer_tasks - move tasks from one cgroup to another
  * @to: cgroup to which the tasks will be moved
@@ -2865,8 +2856,26 @@ static void cgroup_transfer_one_task(struct task_struct *task, void *data)
  */
 int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from)
 {
-	return css_scan_tasks(&from->dummy_css, NULL, cgroup_transfer_one_task,
-			      to, NULL);
+	struct css_task_iter it;
+	struct task_struct *task;
+	int ret = 0;
+
+	do {
+		css_task_iter_start(&from->dummy_css, &it);
+		task = css_task_iter_next(&it);
+		if (task)
+			get_task_struct(task);
+		css_task_iter_end(&it);
+
+		if (task) {
+			mutex_lock(&cgroup_mutex);
+			ret = cgroup_attach_task(to, task, false);
+			mutex_unlock(&cgroup_mutex);
+			put_task_struct(task);
+		}
+	} while (task && !ret);
+
+	return ret;
 }
 
 /*
-- 
1.8.5.3

