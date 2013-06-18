Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab3FRH46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 03:56:58 -0400
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:35271 "EHLO
	na3sys009aog136.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752776Ab3FRH45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 03:56:57 -0400
From: Lei Wen <leiwen@marvell.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        <mingo@redhat.com>, <leiwen@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: fix underflow when doing fix_small_imbalance
Date: Tue, 18 Jun 2013 15:56:38 +0800
Message-ID: <1371542198-29879-1-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since sds->max_load, sds->this_load, scaled_busy_load_per_task are all
unsigned long type, so it make even sds->max_load less than
sds->this_load, the statement as below would still be true.

	(sds->max_load - sds->this_load + scaled_busy_load_per_task >=
                       (scaled_busy_load_per_task * imbn)

This would make load balance happen, even the busiest group's load is
less than local group's load...

Signed-off-by: Lei Wen <leiwen@marvell.com>
---
 kernel/sched/fair.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c61a614..8d11a69 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4693,6 +4693,7 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 	unsigned long tmp, pwr_now = 0, pwr_move = 0;
 	unsigned int imbn = 2;
 	unsigned long scaled_busy_load_per_task;
+	int balance;
 
 	if (sds->this_nr_running) {
 		sds->this_load_per_task /= sds->this_nr_running;
@@ -4708,8 +4709,9 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 					 * SCHED_POWER_SCALE;
 	scaled_busy_load_per_task /= sds->busiest->sgp->power;
 
-	if (sds->max_load - sds->this_load + scaled_busy_load_per_task >=
-			(scaled_busy_load_per_task * imbn)) {
+	balance = sds->max_load - sds->this_load
+			+ scaled_busy_load_per_task * (1 - imbn);
+	if (balance >=0) {
 		env->imbalance = sds->busiest_load_per_task;
 		return;
 	}
-- 
1.7.10.4

