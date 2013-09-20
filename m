Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab3ITNrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 09:47:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44266 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab3ITNrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 09:47:15 -0400
Date: Fri, 20 Sep 2013 06:46:39 -0700
From: tip-bot for Vladimir Davydov <tipbot@zytor.com>
Message-ID: <tip-b18855500fc40da050512d9df82d2f1471e59642@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, vdavydov@parallels.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, vdavydov@parallels.com
In-Reply-To: <8f596cc6bc0e5e655119dc892c9bfcad26e971f4.1379252740.git.vdavydov@parallels.com>
References: <8f596cc6bc0e5e655119dc892c9bfcad26e971f4.1379252740.git.vdavydov@parallels.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/balancing: Fix 'local->avg_load > sds->
 avg_load' case in calculate_imbalance()
Git-Commit-ID: b18855500fc40da050512d9df82d2f1471e59642
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 20 Sep 2013 06:46:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b18855500fc40da050512d9df82d2f1471e59642
Gitweb:     http://git.kernel.org/tip/b18855500fc40da050512d9df82d2f1471e59642
Author:     Vladimir Davydov <vdavydov@parallels.com>
AuthorDate: Sun, 15 Sep 2013 17:49:13 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 20 Sep 2013 11:59:36 +0200

sched/balancing: Fix 'local->avg_load > sds->avg_load' case in calculate_imbalance()

In busiest->group_imb case we can come to calculate_imbalance() with
local->avg_load >= busiest->avg_load >= sds->avg_load. This can result
in imbalance overflow, because it is calculated as follows

env->imbalance = min(
	max_pull * busiest->group_power,
	(sds->avg_load - local->avg_load) * local->group_power) / SCHED_POWER_SCALE;

As a result we can end up constantly bouncing tasks from one cpu to
another if there are pinned tasks.

Fix this by skipping the assignment and assuming imbalance=0 in case
local->avg_load > sds->avg_load.

[ The bug can be caught by running 2*N cpuhogs pinned to two logical cpus
  belonging to different cores on an HT-enabled machine with N logical
  cpus: just look at se.nr_migrations growth. ]

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/8f596cc6bc0e5e655119dc892c9bfcad26e971f4.1379252740.git.vdavydov@parallels.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 11cd136..0b99aae 100644
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
