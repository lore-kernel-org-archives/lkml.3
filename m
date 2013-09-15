Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab3IORa3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 13:30:29 -0400
Received: from relay.parallels.com ([195.214.232.42]:56018 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab3IORa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 13:30:27 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
CC: Paul Turner <pjt@google.com>, <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>
Subject: [PATCH 1/2] sched: load_balance: Prevent reselect prev dst_cpu if some pinned
Date: Sun, 15 Sep 2013 21:30:13 +0400
Message-ID: <281f59b6e596c718dd565ad267fc38f5b8e5c995.1379265590.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.21.58]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently new_dst_cpu is prevented from being reselected actually, not
dst_cpu. This can result in attempting to pull tasks to this_cpu twice.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 kernel/sched/fair.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9b3fe1c..cd59640 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5269,15 +5269,15 @@ more_balance:
 		 */
 		if ((env.flags & LBF_SOME_PINNED) && env.imbalance > 0) {
 
+			/* Prevent to re-select dst_cpu via env's cpus */
+			cpumask_clear_cpu(env.dst_cpu, env.cpus);
+
 			env.dst_rq	 = cpu_rq(env.new_dst_cpu);
 			env.dst_cpu	 = env.new_dst_cpu;
 			env.flags	&= ~LBF_SOME_PINNED;
 			env.loop	 = 0;
 			env.loop_break	 = sched_nr_migrate_break;
 
-			/* Prevent to re-select dst_cpu via env's cpus */
-			cpumask_clear_cpu(env.dst_cpu, env.cpus);
-
 			/*
 			 * Go back to "more_balance" rather than "redo" since we
 			 * need to continue with same src_cpu.
-- 
1.7.10.4

