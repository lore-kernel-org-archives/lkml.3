Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab3IYHx4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 03:53:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40120 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab3IYHxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 03:53:55 -0400
Date: Wed, 25 Sep 2013 09:53:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <bitbucket@online.de>, Paul Turner <pjt@google.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] sched: Avoid select_idle_sibling() for
 wake_affine(.sync=true)
Message-ID: <20130925075341.GB3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: sched: Avoid select_idle_sibling() for wake_affine(.sync=true)
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed Sep 25 08:28:39 CEST 2013

When a task is the only running task and does a sync wakeup; avoid
going through select_idle_sibling() as it doesn't know the current CPU
is going to be idle shortly.

Without this two sync wakers will ping-pong between CPUs for no
reason.

Suggested-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/sched/fair.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3461,6 +3461,16 @@ select_task_rq_fair(struct task_struct *
 		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
 			prev_cpu = cpu;
 
+		/*
+		 * Don't bother with select_idle_sibling() in the case of a sync wakeup
+		 * where we know the only running task will soon go away. Going
+		 * through select_idle_sibling will only lead to pointless ping-pong.
+		 */
+		if (sync && prev_cpu == cpu && cpu_rq(cpu)->nr_running == 1) {
+			new_cpu = cpu;
+			goto unlock;
+		}
+
 		new_cpu = select_idle_sibling(p, prev_cpu);
 		goto unlock;
 	}
