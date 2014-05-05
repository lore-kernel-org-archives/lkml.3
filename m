Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbaEEUse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:48:34 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:56919 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248AbaEEUsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:48:05 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Bohac <jbohac@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3/4] printk: Add printk_deferred_once
Date: Mon,  5 May 2014 13:47:43 -0700
Message-Id: <1399322864-22861-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399322864-22861-1-git-send-email-john.stultz@linaro.org>
References: <1399322864-22861-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two of the three prink_deferred uses are really printk_once style
uses, so add a printk_deferred_once macro to simplify those call
sites.

Cc: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/printk.h  | 11 +++++++++++
 kernel/sched/deadline.c |  7 +------
 kernel/sched/rt.c       |  8 +-------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 7847301..f086d6c 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -266,9 +266,20 @@ extern asmlinkage void dump_stack(void) __cold;
 		printk(fmt, ##__VA_ARGS__);			\
 	}							\
 })
+#define printk_deferred_once(fmt, ...)				\
+({								\
+	static bool __print_once __read_mostly;			\
+								\
+	if (!__print_once) {					\
+		__print_once = true;				\
+		printk_deferred(fmt, ##__VA_ARGS__);		\
+	}							\
+})
 #else
 #define printk_once(fmt, ...)					\
 	no_printk(fmt, ##__VA_ARGS__)
+#define printk_deferred_once(fmt, ...)				\
+	no_printk(fmt, ##__VA_ARGS__)
 #endif
 
 #define pr_emerg_once(fmt, ...)					\
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 657ed68..80837e9 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -348,12 +348,7 @@ static void replenish_dl_entity(struct sched_dl_entity *dl_se,
 	 * entity.
 	 */
 	if (dl_time_before(dl_se->deadline, rq_clock(rq))) {
-		static bool lag_once = false;
-
-		if (!lag_once) {
-			lag_once = true;
-			printk_deferred("sched: DL replenish lagged to much\n");
-		}
+		printk_deferred_once("sched: DL replenish lagged to much\n");
 		dl_se->deadline = rq_clock(rq) + pi_se->dl_deadline;
 		dl_se->runtime = pi_se->dl_runtime;
 	}
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index e7dc728..ea4d500 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -890,14 +890,8 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
 		 * but accrue some time due to boosting.
 		 */
 		if (likely(rt_b->rt_runtime)) {
-			static bool once = false;
-
 			rt_rq->rt_throttled = 1;
-
-			if (!once) {
-				once = true;
-				printk_deferred("sched: RT throttling activated\n");
-			}
+			printk_deferred_once("sched: RT throttling activated\n");
 		} else {
 			/*
 			 * In case we did anyway, make it go away,
-- 
1.9.1

