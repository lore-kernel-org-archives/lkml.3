Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933838AbaGRNAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:00:13 -0400
Received: from smtp.citrix.com ([66.165.176.89]:57542 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831AbaGRNAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:00:07 -0400
X-IronPort-AV: E=Sophos;i="5.01,685,1400025600"; 
   d="scan'208";a="153661156"
From: Jonathan Davies <jonathan.davies@citrix.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
CC: Jonathan Davies <jonathan.davies@citrix.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC] sched/core: Make idle_cpu return 0 if doing softirq work
Date: Fri, 18 Jul 2014 13:59:06 +0100
Message-ID: <1405688346-7349-1-git-send-email-jonathan.davies@citrix.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of idle_cpu only considers tasks that might be in the
CPU's runqueue. If there's nothing in the specified CPU's runqueue, it will
return 1. But if the CPU is doing work in the softirq context, it is wrong for
idle_cpu to return 1. This patch makes it return 0.

I observed this to be a problem with a device driver kicking a kthread by
executing wake_up from softirq context. The Completely Fair Scheduler's
select_task_rq_fair was looking for an "idle sibling" of the CPU executing it by
calling select_idle_sibling, passing the executing CPU as the 'target'
parameter. The first thing that select_idle_sibling does is to check whether the
'target' CPU is idle, using idle_cpu, and to return that CPU if so. Despite the
executing CPU being busy in softirq context, idle_cpu was returning 1, meaning
that the scheduler would consistently try to run the kthread on the same CPU as
the kick came from. Given that the softirq work was on-going, this led to a
multi-millisecond delay before the scheduler eventually realised it should
migrate the kthread to a different CPU.

A solution to this problem would be to make idle_cpu return 0 when the CPU is
running in softirq context. I haven't got a patch for that because I couldn't
find an easy way of querying whether an arbitrary CPU is doing this. (Perhaps I
should look at the per-CPU softirq_work_list[]...?)

Instead, the following patch is a partial solution, only handling the case when
the currently-executing CPU is in softirq context. This was sufficient to solve
the problem I observed.

Signed-off-by: Jonathan Davies <jonathan.davies@citrix.com>
---
 kernel/sched/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 7bc599d..4ee58c4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3169,6 +3169,10 @@ int idle_cpu(int cpu)
 		return 0;
 #endif
 
+	/* When the current CPU is in softirq context, count it as non-idle */
+	if (cpu == smp_processor_id() && in_softirq())
+		return 0;
+
 	return 1;
 }
 
-- 
1.9.1

