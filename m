Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab3ITNrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 09:47:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44270 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab3ITNrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 09:47:18 -0400
Date: Fri, 20 Sep 2013 06:46:49 -0700
From: tip-bot for Vladimir Davydov <tipbot@zytor.com>
Message-ID: <tip-3029ede39373c368f402a76896600d85a4f7121b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, vdavydov@parallels.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, vdavydov@parallels.com
In-Reply-To: <ef167822e5c5b2d96cf5b0e3e4f4bdff3f0414a2.1379252740.git.vdavydov@parallels.com>
References: <ef167822e5c5b2d96cf5b0e3e4f4bdff3f0414a2.1379252740.git.vdavydov@parallels.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/balancing: Fix 'local->avg_load > busiest-
 >avg_load' case in fix_small_imbalance()
Git-Commit-ID: 3029ede39373c368f402a76896600d85a4f7121b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 20 Sep 2013 06:46:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3029ede39373c368f402a76896600d85a4f7121b
Gitweb:     http://git.kernel.org/tip/3029ede39373c368f402a76896600d85a4f7121b
Author:     Vladimir Davydov <vdavydov@parallels.com>
AuthorDate: Sun, 15 Sep 2013 17:49:14 +0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 20 Sep 2013 11:59:38 +0200

sched/balancing: Fix 'local->avg_load > busiest->avg_load' case in fix_small_imbalance()

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

[ The bug can be caught by running 2*N cpuhogs pinned to two logical cpus
  belonging to different cores on an HT-enabled machine with N logical
  cpus: just look at se.nr_migrations growth. ]

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/ef167822e5c5b2d96cf5b0e3e4f4bdff3f0414a2.1379252740.git.vdavydov@parallels.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0b99aae..2aedacc 100644
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
