Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750963AbaEBEnP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 00:43:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbaEBEnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 00:43:14 -0400
Date: Fri, 2 May 2014 00:42:37 -0400
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: morten.rasmussen@arm.com, mingo@kernel.org, peterz@infradead.org,
        george.mccollister@gmail.com, ktkhai@parallels.com,
        umgwanakikbuti@gmail.com
Subject: [PATCH RFC/TEST] sched: make sync affine wakeups work
Message-ID: <20140502004237.79dd3de6@annuminas.surriel.com>
Organization: Red Hat, Inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently sync wakeups from the wake_affine code cannot work as
designed, because the task doing the sync wakeup from the target
cpu will block its wakee from selecting that cpu.

This is despite the fact that whether or not the wakeup is sync
determines whether or not we want to do an affine wakeup...

This patch allows sync wakeups to pick the waker's cpu.

Whether or not this is the right thing to do remains to be seen,
but it does allow us to verify whether or not the wake_affine
strategy of always doing affine wakeups and only disabling them
in a specific circumstance is sound, or needs rethinking...

Not-yet-signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/sched/fair.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7570dd9..7f8fe16 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4358,13 +4358,13 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 /*
  * Try and locate an idle CPU in the sched_domain.
  */
-static int select_idle_sibling(struct task_struct *p, int target)
+static int select_idle_sibling(struct task_struct *p, int target, int sync)
 {
 	struct sched_domain *sd;
 	struct sched_group *sg;
 	int i = task_cpu(p);
 
-	if (idle_cpu(target))
+	if (idle_cpu(target) || (sync && cpu_rq(target)->nr_running == 1))
 		return target;
 
 	/*
@@ -4453,7 +4453,7 @@ select_task_rq_fair(struct task_struct *p, int prev_cpu, int sd_flag, int wake_f
 		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
 			prev_cpu = cpu;
 
-		new_cpu = select_idle_sibling(p, prev_cpu);
+		new_cpu = select_idle_sibling(p, prev_cpu, sync);
 		goto unlock;
 	}
 
.
