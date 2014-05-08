Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaEHKms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:42:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33113 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbaEHKmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:42:46 -0400
Date: Thu, 8 May 2014 03:41:48 -0700
From: "tip-bot for Steven Rostedt (Red Hat)" <tipbot@zytor.com>
Message-ID: <tip-6227cb00cc120f9a43ce8313bb0475ddabcb7d01@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, tglx@linutronix.de,
        umgwanakikbuti@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, peterz@infradead.org, tglx@linutronix.de,
        umgwanakikbuti@gmail.com
In-Reply-To: <1397015410.5212.13.camel@marge.simpson.net>
References: <1397015410.5212.13.camel@marge.simpson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Use CPUPRI_NR_PRIORITIES instead of MAX_RT_PRIO in cpupri check
Git-Commit-ID: 6227cb00cc120f9a43ce8313bb0475ddabcb7d01
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6227cb00cc120f9a43ce8313bb0475ddabcb7d01
Gitweb:     http://git.kernel.org/tip/6227cb00cc120f9a43ce8313bb0475ddabcb7d01
Author:     Steven Rostedt (Red Hat) <rostedt@goodmis.org>
AuthorDate: Sun, 13 Apr 2014 09:34:53 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 11:51:33 +0200

sched: Use CPUPRI_NR_PRIORITIES instead of MAX_RT_PRIO in cpupri check

The check at the beginning of cpupri_find() makes sure that the task_pri
variable does not exceed the cp->pri_to_cpu array length. But that length
is CPUPRI_NR_PRIORITIES not MAX_RT_PRIO, where it will miss the last two
priorities in that array.

As task_pri is computed from convert_prio() which should never be bigger
than CPUPRI_NR_PRIORITIES, if the check should cause a panic if it is
hit.

Reported-by: Mike Galbraith <umgwanakikbuti@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1397015410.5212.13.camel@marge.simpson.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
