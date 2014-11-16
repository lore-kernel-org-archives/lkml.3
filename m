Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbaKPMdE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:33:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35528 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbaKPMdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:33:02 -0500
Date: Sun, 16 Nov 2014 04:32:32 -0800
From: tip-bot for Wanpeng Li <tipbot@zytor.com>
Message-ID: <tip-cb0b9f2445cdf9893352e4548582a2892af7137c@git.kernel.org>
Cc: vincent.guittot@linaro.org, riel@redhat.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, wanpeng.li@linux.intel.com,
        tglx@linutronix.de, mingo@kernel.org, peterz@infradead.org,
        hpa@zytor.com, ktkhai@parallels.com
Reply-To: vincent.guittot@linaro.org, torvalds@linux-foundation.org,
        riel@redhat.com, linux-kernel@vger.kernel.org,
        wanpeng.li@linux.intel.com, peterz@infradead.org, hpa@zytor.com,
        ktkhai@parallels.com, tglx@linutronix.de, mingo@kernel.org
In-Reply-To: <1415144690-25196-1-git-send-email-wanpeng.li@linux.intel.com>
References: <1415144690-25196-1-git-send-email-wanpeng.li@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair:
  Fix stale overloaded status in the busiest group finding logic
Git-Commit-ID: cb0b9f2445cdf9893352e4548582a2892af7137c
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

Commit-ID:  cb0b9f2445cdf9893352e4548582a2892af7137c
Gitweb:     http://git.kernel.org/tip/cb0b9f2445cdf9893352e4548582a2892af7137c
Author:     Wanpeng Li <wanpeng.li@linux.intel.com>
AuthorDate: Wed, 5 Nov 2014 07:44:50 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 10:58:56 +0100

sched/fair: Fix stale overloaded status in the busiest group finding logic

Commit caeb178c60f4 ("sched/fair: Make update_sd_pick_busiest() return
'true' on a busier sd") changes groups to be ranked in the order of
overloaded > imbalance > other, and busiest group is picked according
to this order.

sgs->group_capacity_factor is used to check if the group is overloaded.

When the child domain prefers tasks to go to siblings first, the
sgs->group_capacity_factor will be set lower than one in order to
move all the excess tasks away.

However, group overloaded status is not updated when
sgs->group_capacity_factor is set to lower than one, which leads to us
missing to find the busiest group.

This patch fixes it by updating group overloaded status when sg capacity
factor is set to one, in order to find the busiest group accurately.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Kirill Tkhai <ktkhai@parallels.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1415144690-25196-1-git-send-email-wanpeng.li@linux.intel.com
[ Fixed the changelog. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8bca292..df2cdf7 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6352,8 +6352,10 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 		 * with a large weight task outweighs the tasks on the system).
 		 */
 		if (prefer_sibling && sds->local &&
-		    sds->local_stat.group_has_free_capacity)
+		    sds->local_stat.group_has_free_capacity) {
 			sgs->group_capacity_factor = min(sgs->group_capacity_factor, 1U);
+			sgs->group_type = group_classify(sg, sgs);
+		}
 
 		if (update_sd_pick_busiest(env, sds, sg, sgs)) {
 			sds->busiest = sg;
