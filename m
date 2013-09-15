Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab3IONtZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 09:49:25 -0400
Received: from relay.parallels.com ([195.214.232.42]:35167 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052Ab3IONtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 09:49:24 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
CC: Paul Turner <pjt@google.com>, <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>
Subject: [PATCH 1/2] sched: calculate_imbalance: Fix local->avg_load > sds->avg_load case
Date: Sun, 15 Sep 2013 17:49:13 +0400
Message-ID: <8f596cc6bc0e5e655119dc892c9bfcad26e971f4.1379252740.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.21.58]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In busiest->group_imb case we can come to calculate_imbalance() with
local->avg_load >= busiest->avg_load >= sds->avg_load. This can result
in imbalance overflow, because it is calculated as follows

env->imbalance = min(
	max_pull * busiest->group_power,
	(sds->avg_load - local->avg_load) * local->group_power
) / SCHED_POWER_SCALE;

As a result we can end up constantly bouncing tasks from one cpu to
another if there are pinned tasks.

Fix this by skipping the assignment and assuming imbalance=0 in case
local->avg_load > sds->avg_load.
--
The bug can be caught by running 2*N cpuhogs pinned to two logical cpus
belonging to different cores on an HT-enabled machine with N logical
cpus: just look at se.nr_migrations growth.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 kernel/sched/fair.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9b3fe1c..507a8a9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4896,7 +4896,8 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 	 * max load less than avg load(as we skip the groups at or below
 	 * its cpu_power, while calculating max_load..)
 	 */
-	if (busiest->avg_load < sds->avg_load) {
+	if (busiest->avg_load <= sds->avg_load ||
+	    local->avg_load >= sds->avg_load) {
 		env->imbalance = 0;
 		return fix_small_imbalance(env, sds);
 	}
-- 
1.7.10.4

