Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbaDWDhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 23:37:52 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:36392 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666AbaDWDhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 23:37:11 -0400
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Bohac <jbohac@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH 2/3] printk: Add printk_once_deferred
Date: Tue, 22 Apr 2014 20:36:57 -0700
Message-Id: <1398224218-4429-3-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398224218-4429-1-git-send-email-john.stultz@linaro.org>
References: <1398224218-4429-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two of the three prink_deferred uses are really printk_once style
uses, so add a printk_once_deferred macro to simplify those call
sites.

Cc: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/printk.h  | 11 +++++++++++
 kernel/sched/deadline.c |  7 +------
 kernel/sched/rt.c       |  8 +-------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 7847301..bd21234 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -266,9 +266,20 @@ extern asmlinkage void dump_stack(void) __cold;
 		printk(fmt, ##__VA_ARGS__);			\
 	}							\
 })
+#define printk_once_deferred(fmt, ...)				\
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
+#define printk_once_deferred(fmt, ...)				\
+	no_printk(fmt, ##__VA_ARGS__)
 #endif
 
 #define pr_emerg_once(fmt, ...)					\
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 657ed68..3ec96bd 100644
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
+		printk_once_deferred("sched: DL replenish lagged to much\n");
 		dl_se->deadline = rq_clock(rq) + pi_se->dl_deadline;
 		dl_se->runtime = pi_se->dl_runtime;
 	}
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index c19b3cc..722e9a3 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -851,14 +851,8 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
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
+			printk_once_deferred("sched: RT throttling activated\n");
 		} else {
 			/*
 			 * In case we did anyway, make it go away,
-- 
1.8.3.2

