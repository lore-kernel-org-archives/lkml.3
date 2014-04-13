Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbaDMNsb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 09:48:31 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:26139 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754492AbaDMNsa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 09:48:30 -0400
Date: Sun, 13 Apr 2014 09:48:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched/cpupri: fix cpupri_find() for high priority tasks
Message-ID: <20140413094828.081e844e@gandalf.local.home>
In-Reply-To: <20140413094023.47c762fd@gandalf.local.home>
References: <1397015410.5212.13.camel@marge.simpson.net>
	<20140413094023.47c762fd@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, since task_pri is calculated from convert_prio() that check
should never be hit. But, I'm paranoid, and instead of dropping the
check, we can do the same as what cpupri_set() does. Which is to BUG.

-- Steve

>From aac271901d6ef5ad19c52f166bf130ad27515b5f Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Sun, 13 Apr 2014 09:34:53 -0400
Subject: [PATCH] sched: Use CPUPRI_NR_PRIORITIES instead of MAX_RT_PRIO in
 cpupri check

The check at the beginning of cpupri_find() makes sure that the task_pri
variable does not exceed the cp->pri_to_cpu array length. But that length
is CPUPRI_NR_PRIORITIES not MAX_RT_PRIO, where it will miss the last two
priorities in that array.

As task_pri is computed from convert_prio() which should never be bigger
than CPUPRI_NR_PRIORITIES, if the check should cause a panic if it is
hit.

Link: http://lkml.kernel.org/r/1397015410.5212.13.camel@marge.simpson.net

Cc: stable@vger.kernel.org
Reported-by: Mike Galbraith <umgwanakikbuti@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/sched/cpupri.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/sched/cpupri.c b/kernel/sched/cpupri.c
index 8b836b3..3031bac 100644
--- a/kernel/sched/cpupri.c
+++ b/kernel/sched/cpupri.c
@@ -70,8 +70,7 @@ int cpupri_find(struct cpupri *cp, struct task_struct *p,
 	int idx = 0;
 	int task_pri = convert_prio(p->prio);
 
-	if (task_pri >= MAX_RT_PRIO)
-		return 0;
+	BUG_ON(task_pri >= CPUPRI_NR_PRIORITIES);
 
 	for (idx = 0; idx < task_pri; idx++) {
 		struct cpupri_vec *vec  = &cp->pri_to_cpu[idx];
-- 
1.8.1.4

