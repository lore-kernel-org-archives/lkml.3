Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967329AbaFQVxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:53:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55046 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966184AbaFQVxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:53:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 144/212] sched: Use CPUPRI_NR_PRIORITIES instead of MAX_RT_PRIO in cpupri check
Date: Tue, 17 Jun 2014 14:43:58 -0700
Message-Id: <1403041506-13646-145-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

commit 6227cb00cc120f9a43ce8313bb0475ddabcb7d01 upstream.

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
Link: http://lkml.kernel.org/r/1397015410.5212.13.camel@marge.simpson.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
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
1.9.1

