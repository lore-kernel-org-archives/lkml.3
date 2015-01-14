Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbbANOCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:02:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36852 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbbANOCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:02:17 -0500
Date: Wed, 14 Jan 2015 06:01:30 -0800
From: tip-bot for Xunlei Pang <tipbot@zytor.com>
Message-ID: <tip-638476007d13534b2ed4134bf0279ef44071140b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, bsegall@google.com,
        pang.xunlei@linaro.org, peterz@infradead.org,
        torvalds@linux-foundation.org, mingo@kernel.org, hpa@zytor.com
Reply-To: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        bsegall@google.com, pang.xunlei@linaro.org, hpa@zytor.com,
        mingo@kernel.org
In-Reply-To: <1418745509-2609-1-git-send-email-pang.xunlei@linaro.org>
References: <1418745509-2609-1-git-send-email-pang.xunlei@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair:
  Fix the dealing with decay_count in __synchronize_entity_decay()
Git-Commit-ID: 638476007d13534b2ed4134bf0279ef44071140b
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

Commit-ID:  638476007d13534b2ed4134bf0279ef44071140b
Gitweb:     http://git.kernel.org/tip/638476007d13534b2ed4134bf0279ef44071140b
Author:     Xunlei Pang <pang.xunlei@linaro.org>
AuthorDate: Tue, 16 Dec 2014 23:58:29 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 14 Jan 2015 13:34:13 +0100

sched/fair: Fix the dealing with decay_count in __synchronize_entity_decay()

In __synchronize_entity_decay(), if "decays" happens to be zero,
se->avg.decay_count will not be zeroed, holding the positive value
assigned when dequeued last time.

This is problematic in the following case:
If this runnable task is CFS-balanced to other CPUs soon afterwards,
migrate_task_rq_fair() will treat it as a blocked task due to its
non-zero decay_count, thereby adding its load to cfs_rq->removed_load
wrongly.

Thus, we must zero se->avg.decay_count in this case as well.

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ben Segall <bsegall@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1418745509-2609-1-git-send-email-pang.xunlei@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 40667cb..97000a9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2574,11 +2574,11 @@ static inline u64 __synchronize_entity_decay(struct sched_entity *se)
 	u64 decays = atomic64_read(&cfs_rq->decay_counter);
 
 	decays -= se->avg.decay_count;
+	se->avg.decay_count = 0;
 	if (!decays)
 		return 0;
 
 	se->avg.load_avg_contrib = decay_load(se->avg.load_avg_contrib, decays);
-	se->avg.decay_count = 0;
 
 	return decays;
 }
