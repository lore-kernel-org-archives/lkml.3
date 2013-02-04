Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab3BDT0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:26:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38244 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab3BDT0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:26:18 -0500
Date: Mon, 4 Feb 2013 11:25:53 -0800
From: tip-bot for Mike Galbraith <bitbucket@online.de>
Message-ID: <tip-e0a79f529d5ba2507486d498b25da40911d95cf6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, bitbucket@online.de, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, bitbucket@online.de, tglx@linutronix.de
In-Reply-To: <1359371965.5783.127.camel@marge.simpson.net>
References: <1359371965.5783.127.camel@marge.simpson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix select_idle_sibling()
  bouncing cow syndrome
Git-Commit-ID: e0a79f529d5ba2507486d498b25da40911d95cf6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 04 Feb 2013 11:25:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e0a79f529d5ba2507486d498b25da40911d95cf6
Gitweb:     http://git.kernel.org/tip/e0a79f529d5ba2507486d498b25da40911d95cf6
Author:     Mike Galbraith <bitbucket@online.de>
AuthorDate: Mon, 28 Jan 2013 12:19:25 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 4 Feb 2013 20:07:24 +0100

sched: Fix select_idle_sibling() bouncing cow syndrome

If the previous CPU is cache affine and idle, select it.

The current implementation simply traverses the sd_llc domain,
taking the first idle CPU encountered, which walks buddy pairs
hand in hand over the package, inflicting excruciating pain.

1 tbench pair (worst case) in a 10 core + SMT package:

  pre   15.22 MB/sec 1 procs
  post 252.01 MB/sec 1 procs

Signed-off-by: Mike Galbraith <bitbucket@online.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1359371965.5783.127.camel@marge.simpson.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8dbee9f..ed18c74 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3252,25 +3252,18 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
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
@@ -3284,7 +3277,7 @@ static int select_idle_sibling(struct task_struct *p, int target)
 				goto next;
 
 			for_each_cpu(i, sched_group_cpus(sg)) {
-				if (!idle_cpu(i))
+				if (i == target || !idle_cpu(i))
 					goto next;
 			}
 
