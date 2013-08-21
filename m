Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab3HUMqE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 08:46:04 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:58306 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3HUMqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 08:46:03 -0400
Date: Wed, 21 Aug 2013 08:45:58 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cpuset: fix a regression in validating config change
Message-ID: <20130821124558.GA19286@mtj.dyndns.org>
References: <52142464.1060603@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52142464.1060603@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

I dropped the make_*_empty variables and just put the conditionals
directly inside the outer if.  Please scream if I messed it up.
Applied to cgroup/for-3.11-fixes.

Thanks.

------- 8< --------
>From 1c09b195d37fa459844036f429a0f378e70c3db6 Mon Sep 17 00:00:00 2001
From: Li Zefan <lizefan@huawei.com>
Date: Wed, 21 Aug 2013 10:22:28 +0800
Subject: [PATCH] cpuset: fix a regression in validating config change

It's not allowed to clear masks of a cpuset if there're tasks in it,
but it's broken:

  # mkdir /cgroup/sub
  # echo 0 > /cgroup/sub/cpuset.cpus
  # echo 0 > /cgroup/sub/cpuset.mems
  # echo $$ > /cgroup/sub/tasks
  # echo > /cgroup/sub/cpuset.cpus
  (should fail)

This bug was introduced by commit 88fa523bff295f1d60244a54833480b02f775152
("cpuset: allow to move tasks to empty cpusets").

tj: Dropped temp bool variables and nestes the conditionals directly.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cpuset.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 010a008..ea1966d 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -475,13 +475,17 @@ static int validate_change(const struct cpuset *cur, const struct cpuset *trial)
 
 	/*
 	 * Cpusets with tasks - existing or newly being attached - can't
-	 * have empty cpus_allowed or mems_allowed.
+	 * be changed to have empty cpus_allowed or mems_allowed.
 	 */
 	ret = -ENOSPC;
-	if ((cgroup_task_count(cur->css.cgroup) || cur->attach_in_progress) &&
-	    (cpumask_empty(trial->cpus_allowed) &&
-	     nodes_empty(trial->mems_allowed)))
-		goto out;
+	if ((cgroup_task_count(cur->css.cgroup) || cur->attach_in_progress)) {
+		if (!cpumask_empty(cur->cpus_allowed) &&
+		    cpumask_empty(trial->cpus_allowed))
+			goto out;
+		if (!nodes_empty(cur->mems_allowed) &&
+		    nodes_empty(trial->mems_allowed))
+			goto out;
+	}
 
 	ret = 0;
 out:
-- 
1.8.3.1

