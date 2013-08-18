Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab3HRI0D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 04:26:03 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:51244 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753240Ab3HRIZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 04:25:55 -0400
From: Lei Wen <leiwen@marvell.com>
To: Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, <mingo@redhat.com>, <leiwen@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/8] sched: change load balance number to h_nr_running of run queue
Date: Sun, 18 Aug 2013 16:25:15 +0800
Message-ID: <1376814322-7320-2-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376814322-7320-1-git-send-email-leiwen@marvell.com>
References: <1376814322-7320-1-git-send-email-leiwen@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since rq->nr_running would include both migration and rt task, it is not
reasonable to seek to move nr_running number of task in the load_balance
function, since it only apply to cfs type.

Change it to cfs's h_nr_running, which could well present the task
number in current cfs queue.

Signed-off-by: Lei Wen <leiwen@marvell.com>
---
 kernel/sched/fair.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f918635..d6153c8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5096,17 +5096,19 @@ redo:
 	schedstat_add(sd, lb_imbalance[idle], env.imbalance);
 
 	ld_moved = 0;
-	if (busiest->nr_running > 1) {
+	/* load balance only apply to CFS task, we use h_nr_running here */
+	if (busiest->cfs.h_nr_running > 1) {
 		/*
 		 * Attempt to move tasks. If find_busiest_group has found
-		 * an imbalance but busiest->nr_running <= 1, the group is
+		 * an imbalance but busiest->cfs.h_nr_running <= 1, the group is
 		 * still unbalanced. ld_moved simply stays zero, so it is
 		 * correctly treated as an imbalance.
 		 */
 		env.flags |= LBF_ALL_PINNED;
 		env.src_cpu   = busiest->cpu;
 		env.src_rq    = busiest;
-		env.loop_max  = min(sysctl_sched_nr_migrate, busiest->nr_running);
+		env.loop_max  = min(sysctl_sched_nr_migrate,
+				    busiest->cfs.h_nr_running);
 
 		update_h_load(env.src_cpu);
 more_balance:
-- 
1.7.5.4

