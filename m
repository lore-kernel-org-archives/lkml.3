Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab3KJTmO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 14:42:14 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:54234 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3KJTmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 14:42:05 -0500
From: Michal Nazarewicz <mpn@google.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCH] sched: fair: avoid integer overflow
Date: Sun, 10 Nov 2013 20:42:01 +0100
Message-Id: <1384112521-25177-1-git-send-email-mpn@google.com>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

sa->runnable_avg_sum is of type u32 but after shifting it by NICE_0_SHIFT
bits it is promoted to u64.  This of course makes no sense, since the
result will never be more then 32-bit long.  Casting sa->runnable_avg_sum
to u64 before it is shifted, fixes this problem.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index df77c60..50f1e170 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2153,7 +2153,7 @@ static inline void __update_tg_runnable_avg(struct sched_avg *sa,
 	long contrib;
 
 	/* The fraction of a cpu used by this cfs_rq */
-	contrib = div_u64(sa->runnable_avg_sum << NICE_0_SHIFT,
+	contrib = div_u64((u64)sa->runnable_avg_sum << NICE_0_SHIFT,
 			  sa->runnable_avg_period + 1);
 	contrib -= cfs_rq->tg_runnable_contrib;
 
-- 
1.8.3.2

