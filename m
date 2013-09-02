Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab3IBHln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 03:41:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52423 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab3IBHll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 03:41:41 -0400
Date: Mon, 2 Sep 2013 00:41:07 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-lppceyv6kb3a19g8spmrn20b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        preeti@linux.vnet.ibm.com, pjt@google.com, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, peterz@infradead.org, pjt@google.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Optimize find_busiest_queue()
Git-Commit-ID: 6906a40839198f33dbb56d20e644c01e00663952
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 02 Sep 2013 00:41:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6906a40839198f33dbb56d20e644c01e00663952
Gitweb:     http://git.kernel.org/tip/6906a40839198f33dbb56d20e644c01e00663952
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 19 Aug 2013 15:20:21 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 2 Sep 2013 08:27:37 +0200

sched/fair: Optimize find_busiest_queue()

Use for_each_cpu_and() and thereby avoid computing the capacity for
CPUs we know we're not interested in.

Reviewed-by: Paul Turner <pjt@google.com>
Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-lppceyv6kb3a19g8spmrn20b@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ccf20e7..bedd30b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4946,7 +4946,7 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 	unsigned long busiest_load = 0, busiest_power = 1;
 	int i;
 
-	for_each_cpu(i, sched_group_cpus(group)) {
+	for_each_cpu_and(i, sched_group_cpus(group), env->cpus) {
 		unsigned long power = power_of(i);
 		unsigned long capacity = DIV_ROUND_CLOSEST(power,
 							   SCHED_POWER_SCALE);
@@ -4955,9 +4955,6 @@ static struct rq *find_busiest_queue(struct lb_env *env,
 		if (!capacity)
 			capacity = fix_small_capacity(env->sd, group);
 
-		if (!cpumask_test_cpu(i, env->cpus))
-			continue;
-
 		rq = cpu_rq(i);
 		wl = weighted_cpuload(i);
 
