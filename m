Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab3LLOVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 09:21:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36004 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab3LLOVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 09:21:12 -0500
Message-Id: <20131212141655.485306919@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 12 Dec 2013 15:08:50 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 15/15] x86: Avoid a runtime condition in native_sched_clock()
References: <20131212140835.729222186@infradead.org>
Content-Disposition: inline; filename=peterz-tsc-static_key.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a static_key to avoid touching tsc_disabled and a runtime
condition in native_sched_clock() -- less cachelines touched is always
better.

                        MAINLINE   PRE       POST

    sched_clock_stable: 1          1         1
    (cold) sched_clock: 329841     215295    213039
    (cold) local_clock: 301773     220773    216084
    (warm) sched_clock: 38375      25659     25231
    (warm) local_clock: 100371     27242     27601
    (warm) rdtsc:       27340      24208     24203
    sched_clock_stable: 0          0         0
    (cold) sched_clock: 382634     237019    240055
    (cold) local_clock: 396890     294819    299942
    (warm) sched_clock: 38194      25609     25276
    (warm) local_clock: 143452     71232     73232
    (warm) rdtsc:       27345      24243     24244

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
@@ -243,7 +246,7 @@ u64 native_sched_clock(void)
 	 *   very important for it to be as fast as the platform
 	 *   can achieve it. )
 	 */
-	if (unlikely(tsc_disabled)) {
+	if (!static_key_false(&__use_tsc)) {
 		/* No locking but a rare wrong value is not a big deal: */
 		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
 	}
@@ -1152,7 +1155,9 @@ void __init tsc_init(void)
 		return;
 
 	/* now allow native_sched_clock() to use rdtsc */
+
 	tsc_disabled = 0;
+	static_key_slow_inc(&__use_tsc);
 
 	if (!no_sched_irq_time)
 		enable_sched_clock_irqtime();


