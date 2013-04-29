Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933066Ab3D2VqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:46:06 -0400
Received: from mail-ye0-f202.google.com ([209.85.213.202]:54645 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759518Ab3D2Vpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:45:55 -0400
From: Colin Cross <ccross@android.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, Colin Cross <ccross@android.com>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: [PATCH 02/10] freezer: skip waking up tasks with PF_FREEZER_SKIP set
Date: Mon, 29 Apr 2013 14:45:38 -0700
Message-Id: <1367271946-7239-3-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367271946-7239-1-git-send-email-ccross@android.com>
References: <1367271946-7239-1-git-send-email-ccross@android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a task has called freezer_do_not_count(), don't bother waking it
up.  If it happens to wake up later it will call freezer_count() and
immediately enter the refrigerator.

Signed-off-by: Colin Cross <ccross@android.com>
---
 kernel/cgroup_freezer.c | 5 ++++-
 kernel/power/process.c  | 4 ++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 75dda1e..406dd71 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -331,8 +331,11 @@ static void freeze_cgroup(struct freezer *freezer)
 	struct task_struct *task;
 
 	cgroup_iter_start(cgroup, &it);
-	while ((task = cgroup_iter_next(cgroup, &it)))
+	while ((task = cgroup_iter_next(cgroup, &it))) {
+		if (freezer_should_skip(task))
+			continue;
 		freeze_task(task);
+	}
 	cgroup_iter_end(cgroup, &it);
 }
 
diff --git a/kernel/power/process.c b/kernel/power/process.c
index eb7e6c1..0680be2 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -46,10 +46,10 @@ static int try_to_freeze_tasks(bool user_only)
 		todo = 0;
 		read_lock(&tasklist_lock);
 		do_each_thread(g, p) {
-			if (p == current || !freeze_task(p))
+			if (p == current || freezer_should_skip(p))
 				continue;
 
-			if (!freezer_should_skip(p))
+			if (freeze_task(p))
 				todo++;
 		} while_each_thread(g, p);
 		read_unlock(&tasklist_lock);
-- 
1.8.2.1

