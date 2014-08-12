Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaHLOzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:55:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37016 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbaHLOxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:53:44 -0400
Date: Tue, 12 Aug 2014 07:52:39 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-9a5d9ba6a3631d55c358fe1bdbaa162a97471a05@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        vincent.guittot@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        vincent.guittot@linaro.org, tglx@linutronix.de
In-Reply-To: <20140729152705.GX12054@laptop.lan>
References: <20140729152705.GX12054@laptop.lan>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Allow calculate_imbalance()
  to move idle cpus
Git-Commit-ID: 9a5d9ba6a3631d55c358fe1bdbaa162a97471a05
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

Commit-ID:  9a5d9ba6a3631d55c358fe1bdbaa162a97471a05
Gitweb:     http://git.kernel.org/tip/9a5d9ba6a3631d55c358fe1bdbaa162a97471a05
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 29 Jul 2014 17:15:11 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 12 Aug 2014 12:48:20 +0200

sched/fair: Allow calculate_imbalance() to move idle cpus

Allow calculate_imbalance() to 'create' idle cpus in the busiest group
if there are idle cpus in the local group.

Suggested-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140729152705.GX12054@laptop.lan
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 9437725..df1ed17 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6273,12 +6273,11 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 		return fix_small_imbalance(env, sds);
 	}
 
-	if (busiest->group_type == group_overloaded) {
-		/*
-		 * Don't want to pull so many tasks that a group would go idle.
-		 * Except of course for the group_imb case, since then we might
-		 * have to drop below capacity to reach cpu-load equilibrium.
-		 */
+	/*
+	 * If there aren't any idle cpus, avoid creating some.
+	 */
+	if (busiest->group_type == group_overloaded &&
+	    local->group_type   == group_overloaded) {
 		load_above_capacity =
 			(busiest->sum_nr_running - busiest->group_capacity_factor);
 
