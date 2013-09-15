Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab3IONt0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 09:49:26 -0400
Received: from relay.parallels.com ([195.214.232.42]:35166 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757053Ab3IONtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 09:49:24 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
CC: Paul Turner <pjt@google.com>, <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>
Subject: [PATCH 2/2] sched: fix_small_imbalance: Fix local->avg_load > busiest->avg_load case
Date: Sun, 15 Sep 2013 17:49:14 +0400
Message-ID: <ef167822e5c5b2d96cf5b0e3e4f4bdff3f0414a2.1379252740.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <8f596cc6bc0e5e655119dc892c9bfcad26e971f4.1379252740.git.vdavydov@parallels.com>
References: <8f596cc6bc0e5e655119dc892c9bfcad26e971f4.1379252740.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.21.58]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In busiest->group_imb case we can come to fix_small_imbalance() with
local->avg_load > busiest->avg_load. This can result in wrong imbalance
fix-up, because there is the following check there where all the
members are unsigned:

if (busiest->avg_load - local->avg_load + scaled_busy_load_per_task >=
    (scaled_busy_load_per_task * imbn)) {
	env->imbalance = busiest->load_per_task;
	return;
}

As a result we can end up constantly bouncing tasks from one cpu to
another if there are pinned tasks.

Fix it by substituting the subtraction with an equivalent addition in
the check.
--
The bug can be caught by running 2*N cpuhogs pinned to two logical cpus
belonging to different cores on an HT-enabled machine with N logical
cpus: just look at se.nr_migrations growth.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 kernel/sched/fair.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 507a8a9..bdaf1fc 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4823,8 +4823,8 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 		(busiest->load_per_task * SCHED_POWER_SCALE) /
 		busiest->group_power;
 
-	if (busiest->avg_load - local->avg_load + scaled_busy_load_per_task >=
-	    (scaled_busy_load_per_task * imbn)) {
+	if (busiest->avg_load + scaled_busy_load_per_task >=
+	    local->avg_load + (scaled_busy_load_per_task * imbn)) {
 		env->imbalance = busiest->load_per_task;
 		return;
 	}
-- 
1.7.10.4

