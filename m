Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaHLOxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:53:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37018 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbaHLOxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:53:46 -0400
Date: Tue, 12 Aug 2014 07:52:10 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-743cb1ff191f00fee653212bdbcee1e56086d6ce@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        vincent.guittot@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, riel@redhat.com,
        vincent.guittot@linaro.org, tglx@linutronix.de
In-Reply-To: <20140729152631.GW12054@laptop.lan>
References: <20140729152631.GW12054@laptop.lan>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Make calculate_imbalance()
  independent
Git-Commit-ID: 743cb1ff191f00fee653212bdbcee1e56086d6ce
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

Commit-ID:  743cb1ff191f00fee653212bdbcee1e56086d6ce
Gitweb:     http://git.kernel.org/tip/743cb1ff191f00fee653212bdbcee1e56086d6ce
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 29 Jul 2014 17:00:21 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 12 Aug 2014 12:48:18 +0200

sched/fair: Make calculate_imbalance() independent

Rik noticed that calculate_imbalance() relies on
update_sd_pick_busiest() to guarantee that busiest->sum_nr_running >
busiest->group_capacity_factor.

Break this implicit assumption (with the intent of not providing it
anymore) by having calculat_imbalance() verify it and not rely on
others.

Reported-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Link: http://lkml.kernel.org/r/20140729152631.GW12054@laptop.lan
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bfa3c86..e9477e6 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6248,7 +6248,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
 		return fix_small_imbalance(env, sds);
 	}
 
-	if (!busiest->group_imb) {
+	if (busiest->sum_nr_running > busiest->group_capacity_factor) {
 		/*
 		 * Don't want to pull so many tasks that a group would go idle.
 		 * Except of course for the group_imb case, since then we might
