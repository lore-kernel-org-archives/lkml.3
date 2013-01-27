Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab3A0HuZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 02:50:25 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:65427 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121Ab3A0HuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 02:50:24 -0500
Message-ID: <1359273021.5803.80.camel@marge.simpson.net>
Subject: [patch] sched: minimalist select_idle_sibling() bouncing cow
 syndrome fix
From: Mike Galbraith <bitbucket@online.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Sun, 27 Jan 2013 08:50:21 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:smQ3oWepW3RwHi9HtoyG4qyu9JXkcFb9EVAfZccRfeN
 UejlQ+J9BSW2yvPAIwSWwzWTGJ3DEpNgw02/mH0cU1UgSqh4zY
 6TCFwEc/40yYawx4PcjcXqUYfbpmfJINVNfGfYtsR2mIuxgmjq
 4N/fm9T+OlFBf1kKwuEFD1ObXX+a5qfXRwtAslQXD/i4C6DtZZ
 vAxRxeBGr4ee66CzWklXqvhxEHJ4TzGryOmA8UnycCHzwqEOj8
 BywfkvXH9HOc7V7SVX8EsRTvh2C0mMgG/xPpSofrBlciwHbHOr
 Uzt76cIK+cALdAQEKX8O3JVXGCLRcBON6i9gdvFcdWSA43SJPD
 cTaYKY35DCD6xCrVoBE0L7rkMftpIbD3THb0sQpk3RjmJEgHw5
 nyKHxYCfK8MIg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If the previous CPU is cache affine and idle, select it.

Signed-off-by: Mike Galbraith <bitbucket@online.de>
---
 kernel/sched/fair.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3270,25 +3270,18 @@ find_idlest_cpu(struct sched_group *grou
  */
 static int select_idle_sibling(struct task_struct *p, int target)
 {
-	int cpu = smp_processor_id();
-	int prev_cpu = task_cpu(p);
 	struct sched_domain *sd;
 	struct sched_group *sg;
-	int i;
+	int i = task_cpu(p);
 
-	/*
-	 * If the task is going to be woken-up on this cpu and if it is
-	 * already idle, then it is the right target.
-	 */
-	if (target == cpu && idle_cpu(cpu))
-		return cpu;
+	if (idle_cpu(target))
+		return target;
 
 	/*
-	 * If the task is going to be woken-up on the cpu where it previously
-	 * ran and if it is currently idle, then it the right target.
+	 * If the prevous cpu is cache affine and idle, don't be stupid.
 	 */
-	if (target == prev_cpu && idle_cpu(prev_cpu))
-		return prev_cpu;
+	if (i != target && cpus_share_cache(i, target) && idle_cpu(i))
+		return i;
 
 	/*
 	 * Otherwise, iterate the domains and find an elegible idle cpu.
@@ -3302,7 +3295,7 @@ static int select_idle_sibling(struct ta
 				goto next;
 
 			for_each_cpu(i, sched_group_cpus(sg)) {
-				if (!idle_cpu(i))
+				if (i == target || !idle_cpu(i))
 					goto next;
 			}
 


