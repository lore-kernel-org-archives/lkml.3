Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbaHHUnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:43:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40205 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726AbaHHUl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:41:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mateusz Guzik <mguzik@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 144/259] sched: Fix possible divide by zero in avg_atom() calculation
Date: Fri,  8 Aug 2014 13:39:27 -0700
Message-Id: <1407530482-4483-145-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Guzik <mguzik@redhat.com>

commit b0ab99e7736af88b8ac1b7ae50ea287fffa2badc upstream.

proc_sched_show_task() does:

  if (nr_switches)
	do_div(avg_atom, nr_switches);

nr_switches is unsigned long and do_div truncates it to 32 bits, which
means it can test non-zero on e.g. x86-64 and be truncated to zero for
division.

Fix the problem by using div64_ul() instead.

As a side effect calculations of avg_atom for big nr_switches are now correct.

Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1402750809-31991-1-git-send-email-mguzik@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/sched/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 5c34d18..0c60913 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -608,7 +608,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 
 		avg_atom = p->se.sum_exec_runtime;
 		if (nr_switches)
-			do_div(avg_atom, nr_switches);
+			avg_atom = div64_ul(avg_atom, nr_switches);
 		else
 			avg_atom = -1LL;
 
-- 
1.9.1

