Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417Ab3IORa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 13:30:28 -0400
Received: from relay.parallels.com ([195.214.232.42]:56016 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab3IORa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 13:30:27 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
CC: Paul Turner <pjt@google.com>, <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>
Subject: [PATCH 2/2] sched: load_balance: Reset env when going to redo due to all pinned
Date: Sun, 15 Sep 2013 21:30:14 +0400
Message-ID: <c34e2ebbe55403d5db111fa3ecdf6ca52b73a337.1379265590.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <281f59b6e596c718dd565ad267fc38f5b8e5c995.1379265590.git.vdavydov@parallels.com>
References: <281f59b6e596c718dd565ad267fc38f5b8e5c995.1379265590.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.21.58]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Firstly, reset env.dst_cpu/dst_rq to this_cpu/this_rq, because it could
have changed in 'some pinned' case. Otherwise, should_we_balance() can
stop balancing beforehand.

Secondly, reset env.flags, because it can have LBF_SOME_PINNED set.

Thirdly, reset env.dst_grpmask cpus in env.cpus to allow handling 'some
pinned' case when pulling tasks from a new busiest cpu.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 kernel/sched/fair.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cd59640..d840e51 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5289,8 +5289,16 @@ more_balance:
 		if (unlikely(env.flags & LBF_ALL_PINNED)) {
 			cpumask_clear_cpu(cpu_of(busiest), cpus);
 			if (!cpumask_empty(cpus)) {
-				env.loop = 0;
-				env.loop_break = sched_nr_migrate_break;
+				env.dst_cpu	= this_cpu;
+				env.dst_rq	= this_rq;
+				env.flags	= 0;
+				env.loop	= 0;
+				env.loop_break	= sched_nr_migrate_break;
+
+				/* Reset cpus cleared in LBF_SOME_PINNED case */
+				if (env.dst_grpmask)
+					cpumask_or(cpus, cpus, env.dst_grpmask);
+
 				goto redo;
 			}
 			goto out_balanced;
-- 
1.7.10.4

