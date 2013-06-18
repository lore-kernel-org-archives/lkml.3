Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab3FRDaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 23:30:07 -0400
Received: from na3sys009aog122.obsmtp.com ([74.125.149.147]:45665 "EHLO
	na3sys009aog122.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752576Ab3FRDaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 23:30:05 -0400
From: Lei Wen <leiwen@marvell.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        <mingo@redhat.com>, <leiwen@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 1/3] sched: reduce calculation effort in fix_small_imbalance
Date: Tue, 18 Jun 2013 11:18:04 +0800
Message-ID: <1371525486-11270-2-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1371525486-11270-1-git-send-email-leiwen@marvell.com>
References: <1371525486-11270-1-git-send-email-leiwen@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually all below item could be repalced by scaled_busy_load_per_task
	(sds->busiest_load_per_task * SCHED_POWER_SCALE)
		/sds->busiest->sgp->power;

Signed-off-by: Lei Wen <leiwen@marvell.com>
---
 kernel/sched/fair.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c61a614..28052fa 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4727,20 +4727,17 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 	pwr_now /= SCHED_POWER_SCALE;
 
 	/* Amount of load we'd subtract */
-	tmp = (sds->busiest_load_per_task * SCHED_POWER_SCALE) /
-		sds->busiest->sgp->power;
-	if (sds->max_load > tmp)
+	if (sds->max_load > scaled_busy_load_per_task) {
 		pwr_move += sds->busiest->sgp->power *
-			min(sds->busiest_load_per_task, sds->max_load - tmp);
-
-	/* Amount of load we'd add */
-	if (sds->max_load * sds->busiest->sgp->power <
-		sds->busiest_load_per_task * SCHED_POWER_SCALE)
-		tmp = (sds->max_load * sds->busiest->sgp->power) /
-			sds->this->sgp->power;
-	else
+			min(sds->busiest_load_per_task,
+				sds->max_load - scaled_busy_load_per_task);
 		tmp = (sds->busiest_load_per_task * SCHED_POWER_SCALE) /
 			sds->this->sgp->power;
+	} else
+		tmp = (sds->max_load * sds->busiest->sgp->power) /
+			sds->this->sgp->power;
+
+	/* Amount of load we'd add */
 	pwr_move += sds->this->sgp->power *
 			min(sds->this_load_per_task, sds->this_load + tmp);
 	pwr_move /= SCHED_POWER_SCALE;
-- 
1.7.10.4

