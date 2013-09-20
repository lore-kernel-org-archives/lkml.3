Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab3ITNrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 09:47:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44295 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab3ITNrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 09:47:43 -0400
Date: Fri, 20 Sep 2013 06:47:09 -0700
From: tip-bot for Vladimir Davydov <tipbot@zytor.com>
Message-ID: <tip-7aff2e3a56b724b79fa2d5abd10d8231ef8fb0c5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, vdavydov@parallels.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, vdavydov@parallels.com
In-Reply-To: <281f59b6e596c718dd565ad267fc38f5b8e5c995.1379265590.git.vdavydov@parallels.com>
References: <281f59b6e596c718dd565ad267fc38f5b8e5c995.1379265590.git.vdavydov@parallels.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/balancing:
  Prevent the reselection of a previous env.dst_cpu if some tasks are pinned
Git-Commit-ID: 7aff2e3a56b724b79fa2d5abd10d8231ef8fb0c5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 20 Sep 2013 06:47:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7aff2e3a56b724b79fa2d5abd10d8231ef8fb0c5
Gitweb:     http://git.kernel.org/tip/7aff2e3a56b724b79fa2d5abd10d8231ef8fb0c5
Author:     Vladimir Davydov <vdavydov@parallels.com>
AuthorDate: Sun, 15 Sep 2013 21:30:13 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 20 Sep 2013 12:02:20 +0200

sched/balancing: Prevent the reselection of a previous env.dst_cpu if some tasks are pinned

Currently new_dst_cpu is prevented from being reselected actually, not
dst_cpu. This can result in attempting to pull tasks to this_cpu twice.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/281f59b6e596c718dd565ad267fc38f5b8e5c995.1379265590.git.vdavydov@parallels.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 71c6ef5..0784ab6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5261,15 +5261,15 @@ more_balance:
 		 */
 		if ((env.flags & LBF_DST_PINNED) && env.imbalance > 0) {
 
+			/* Prevent to re-select dst_cpu via env's cpus */
+			cpumask_clear_cpu(env.dst_cpu, env.cpus);
+
 			env.dst_rq	 = cpu_rq(env.new_dst_cpu);
 			env.dst_cpu	 = env.new_dst_cpu;
 			env.flags	&= ~LBF_DST_PINNED;
 			env.loop	 = 0;
 			env.loop_break	 = sched_nr_migrate_break;
 
-			/* Prevent to re-select dst_cpu via env's cpus */
-			cpumask_clear_cpu(env.dst_cpu, env.cpus);
-
 			/*
 			 * Go back to "more_balance" rather than "redo" since we
 			 * need to continue with same src_cpu.
