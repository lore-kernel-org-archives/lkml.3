Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab3K2Rtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 12:49:55 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50503 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3K2Rsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 12:48:39 -0500
Message-Id: <20131129174429.935406562@infradead.org>
User-Agent: quilt/0.60-1
Date: Fri, 29 Nov 2013 18:37:00 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@gmail.com>, hpa@zytor.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 3/7] x86: Avoid a runtime condition in native_sched_clock()
References: <20131129173657.252094369@infradead.org>
Content-Disposition: inline; filename=peterz-tsc-static_key.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a static_key to avoid a runtime condition in native_sched_clock().

XXX: I still think tsc_disabled should die a horrid death.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/kernel/tsc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -11,6 +11,7 @@
 #include <linux/clocksource.h>
 #include <linux/percpu.h>
 #include <linux/timex.h>
+#include <linux/static_key.h>
 
 #include <asm/hpet.h>
 #include <asm/timer.h>
@@ -37,6 +38,8 @@ static int __read_mostly tsc_unstable;
    erroneous rdtsc usage on !cpu_has_tsc processors */
 static int __read_mostly tsc_disabled = -1;
 
+static struct static_key __use_tsc = STATIC_KEY_INIT;
+
 int tsc_clocksource_reliable;
 /*
  * Scheduler clock - returns current time in nanosec units.
@@ -53,7 +56,7 @@ u64 native_sched_clock(void)
 	 *   very important for it to be as fast as the platform
 	 *   can achieve it. )
 	 */
-	if (unlikely(tsc_disabled)) {
+	if (static_key_false(&__use_tsc)) {
 		/* No locking but a rare wrong value is not a big deal: */
 		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
 	}
@@ -1002,7 +1005,9 @@ void __init tsc_init(void)
 		return;
 
 	/* now allow native_sched_clock() to use rdtsc */
+
 	tsc_disabled = 0;
+	static_key_slow_inc(&__use_tsc);
 
 	if (!no_sched_irq_time)
 		enable_sched_clock_irqtime();


