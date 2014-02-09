Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaBINxU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:53:20 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:41534 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432AbaBINxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:53:16 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/16] cpuset: don't use cgroup_taskset_cur_css()
Date: Sun,  9 Feb 2014 08:52:41 -0500
Message-Id: <1391953964-22088-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391953964-22088-1-git-send-email-tj@kernel.org>
References: <1391953964-22088-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cgroup_taskset_cur_css() will be removed during the planned
resturcturing of migration path.  The only use of
cgroup_taskset_cur_css() is finding out the old cgroup_subsys_state of
the leader in cpuset_attach().  This usage can easily be removed by
remembering the old value from cpuset_can_attach().

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index bf20e4a..d8bec21 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1379,6 +1379,8 @@ static int fmeter_getrate(struct fmeter *fmp)
 	return val;
 }
 
+static struct cpuset *cpuset_attach_old_cs;
+
 /* Called by cgroups to determine if a cpuset is usable; cpuset_mutex held */
 static int cpuset_can_attach(struct cgroup_subsys_state *css,
 			     struct cgroup_taskset *tset)
@@ -1387,6 +1389,9 @@ static int cpuset_can_attach(struct cgroup_subsys_state *css,
 	struct task_struct *task;
 	int ret;
 
+	/* used later by cpuset_attach() */
+	cpuset_attach_old_cs = task_cs(cgroup_taskset_first(tset));
+
 	mutex_lock(&cpuset_mutex);
 
 	/*
@@ -1450,10 +1455,8 @@ static void cpuset_attach(struct cgroup_subsys_state *css,
 	struct mm_struct *mm;
 	struct task_struct *task;
 	struct task_struct *leader = cgroup_taskset_first(tset);
-	struct cgroup_subsys_state *oldcss = cgroup_taskset_cur_css(tset,
-							cpuset_cgrp_id);
 	struct cpuset *cs = css_cs(css);
-	struct cpuset *oldcs = css_cs(oldcss);
+	struct cpuset *oldcs = cpuset_attach_old_cs;
 	struct cpuset *cpus_cs = effective_cpumask_cpuset(cs);
 	struct cpuset *mems_cs = effective_nodemask_cpuset(cs);
 
-- 
1.8.5.3

