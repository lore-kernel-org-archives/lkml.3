Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab3FRG0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 02:26:43 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:34466 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751444Ab3FRG0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 02:26:41 -0400
From: Lei Wen <leiwen@marvell.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        <mingo@redhat.com>, <leiwen@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: fix load_above_capacity underflow
Date: Tue, 18 Jun 2013 14:26:23 +0800
Message-ID: <1371536783-27012-1-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apparently we don't want to see sds->busiest_nr_running is small than
sds->busiest_group_capacity, while our load_above_capacity is
an "unsigned long" type.

Signed-off-by: Lei Wen <leiwen@marvell.com>
---
 kernel/sched/fair.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c61a614..fd90b17 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4780,12 +4780,17 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 		/*
 		 * Don't want to pull so many tasks that a group would go idle.
 		 */
-		load_above_capacity = (sds->busiest_nr_running -
-						sds->busiest_group_capacity);
+		if (sds->busiest_has_capacity)
+			load_above_capacity = 0;
+		else {
+			load_above_capacity = (sds->busiest_nr_running -
+					sds->busiest_group_capacity);
 
-		load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
+			load_above_capacity *=
+				(SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
 
-		load_above_capacity /= sds->busiest->sgp->power;
+			load_above_capacity /= sds->busiest->sgp->power;
+		}
 	}
 
 	/*
-- 
1.7.10.4

