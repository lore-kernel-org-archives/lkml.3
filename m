Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaHRJeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:34:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42544 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbaHRJeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:34:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mateusz Guzik <mguzik@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 023/137] sched: Fix possible divide by zero in avg_atom() calculation
Date: Mon, 18 Aug 2014 10:31:24 +0100
Message-Id: <1408354398-10226-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/sched/debug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 631daf2612c1..8304ee67c56b 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -554,7 +554,7 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 
 		avg_atom = p->se.sum_exec_runtime;
 		if (nr_switches)
-			do_div(avg_atom, nr_switches);
+			avg_atom = div64_ul(avg_atom, nr_switches);
 		else
 			avg_atom = -1LL;
 
-- 
1.9.1

