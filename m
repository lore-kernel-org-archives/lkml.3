Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612AbaCLKLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 06:11:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48928 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaCLKLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 06:11:17 -0400
Date: Wed, 12 Mar 2014 03:10:32 -0700
From: tip-bot for Vincent Guittot <tipbot@zytor.com>
Message-ID: <tip-a2cd42601b474b957e1a5fe3692bcf7f9363bd51@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, vincent.guittot@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, vincent.guittot@linaro.org, tglx@linutronix.de
In-Reply-To: <1394555166-22894-1-git-send-email-vincent.guittot@linaro.org>
References: <1394555166-22894-1-git-send-email-vincent.guittot@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Remove double calculation in fix_small_imbalance()
Git-Commit-ID: a2cd42601b474b957e1a5fe3692bcf7f9363bd51
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a2cd42601b474b957e1a5fe3692bcf7f9363bd51
Gitweb:     http://git.kernel.org/tip/a2cd42601b474b957e1a5fe3692bcf7f9363bd51
Author:     Vincent Guittot <vincent.guittot@linaro.org>
AuthorDate: Tue, 11 Mar 2014 17:26:06 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 12 Mar 2014 10:49:00 +0100

sched: Remove double calculation in fix_small_imbalance()

The tmp value has been already calculated in:

  scaled_busy_load_per_task =
		(busiest->load_per_task * SCHED_POWER_SCALE) /
		busiest->group_power;

Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1394555166-22894-1-git-send-email-vincent.guittot@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f1eedae..b301918 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6061,12 +6061,10 @@ void fix_small_imbalance(struct lb_env *env, struct sd_lb_stats *sds)
 	pwr_now /= SCHED_POWER_SCALE;
 
 	/* Amount of load we'd subtract */
-	tmp = (busiest->load_per_task * SCHED_POWER_SCALE) /
-		busiest->group_power;
-	if (busiest->avg_load > tmp) {
+	if (busiest->avg_load > scaled_busy_load_per_task) {
 		pwr_move += busiest->group_power *
 			    min(busiest->load_per_task,
-				busiest->avg_load - tmp);
+				busiest->avg_load - scaled_busy_load_per_task);
 	}
 
 	/* Amount of load we'd add */
