Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbaAMP6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:58:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32810 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbaAMP6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:58:44 -0500
Date: Mon, 13 Jan 2014 07:58:14 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-hrz87bo37qke25bty6pnfy4b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/clock, x86:
  Avoid a runtime condition in native_sched_clock()
Git-Commit-ID: 10b033d434c25a6c9e0f4f4dc2418af1b8236c63
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 13 Jan 2014 07:58:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  10b033d434c25a6c9e0f4f4dc2418af1b8236c63
Gitweb:     http://git.kernel.org/tip/10b033d434c25a6c9e0f4f4dc2418af1b8236c63
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 28 Nov 2013 19:01:40 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 13 Jan 2014 15:13:17 +0100

sched/clock, x86: Avoid a runtime condition in native_sched_clock()

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
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-hrz87bo37qke25bty6pnfy4b@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/tsc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 53c1235..6377fb2 100644
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
@@ -282,7 +285,7 @@ u64 native_sched_clock(void)
 	 *   very important for it to be as fast as the platform
 	 *   can achieve it. )
 	 */
-	if (unlikely(tsc_disabled)) {
+	if (!static_key_false(&__use_tsc)) {
 		/* No locking but a rare wrong value is not a big deal: */
 		return (jiffies_64 - INITIAL_JIFFIES) * (1000000000 / HZ);
 	}
@@ -1193,7 +1196,9 @@ void __init tsc_init(void)
 		return;
 
 	/* now allow native_sched_clock() to use rdtsc */
+
 	tsc_disabled = 0;
+	static_key_slow_inc(&__use_tsc);
 
 	if (!no_sched_irq_time)
 		enable_sched_clock_irqtime();
