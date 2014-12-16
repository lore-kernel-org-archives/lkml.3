Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaLPP67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 10:58:59 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:59254 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaLPP65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 10:58:57 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [PATCH] sched/fair: Fix the dealing with decay_count in __synchronize_entity_decay()
Date: Tue, 16 Dec 2014 23:58:29 +0800
Message-Id: <1418745509-2609-1-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index df2cdf7..ea517cd 100644
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
-- 
1.9.1

