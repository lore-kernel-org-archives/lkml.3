Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162080Ab3DEQhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:37:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48441 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161970Ab3DEQhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:37:06 -0400
Message-ID: <1365179800.2609.135.camel@laptop>
Subject: [PATCH] sched: Fix 32bit race in sched_clock_remote()
From: Peter Zijlstra <peterz@infradead.org>
To: tglx <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
        mingo@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Fri, 05 Apr 2013 18:36:40 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas spotted a nasty 32bit race in sched_clock_remote() after way too
many hours of debugging weirdness.

What happens is that sched_clock_remote() does regular machine word
reads of sched_clock_data::clock; this appears safe since we use
cmpxchg64() to update the variable and any half-read value would
trigger a retry.

Except we don't validate the new value 'val' in the same way! Thus we
can propagate non-atomic read errors into the clock value.

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Debugged-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched/clock.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/clock.c b/kernel/sched/clock.c
index c685e31..7042ef7 100644
--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -170,6 +170,21 @@ static u64 sched_clock_local(struct sched_clock_data *scd)
 	return clock;
 }
 
+#ifndef CONFIG_64BIT
+/*
+ * 32bit machines can't atomically read a u64 except using cmpxchg64()
+ */
+static inline u64 scd_read_clock(struct sched_clock_data *scd)
+{
+	return cmpxchg64(&scd->clock, 0, 0);
+}
+#else
+static inline u64 scd_read_clock(struct sched_clock_data *scd)
+{
+	return scd->clock;
+}
+#endif
+
 static u64 sched_clock_remote(struct sched_clock_data *scd)
 {
 	struct sched_clock_data *my_scd = this_scd();
@@ -178,8 +193,8 @@ static u64 sched_clock_remote(struct sched_clock_data *scd)
 
 	sched_clock_local(my_scd);
 again:
-	this_clock = my_scd->clock;
-	remote_clock = scd->clock;
+	this_clock = scd_clock_read(my_scd);
+	remote_clock = scd_clock_read(scd);
 
 	/*
 	 * Use the opportunity that we have both locks


