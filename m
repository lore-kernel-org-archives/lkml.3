Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab3LEDMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 22:12:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab3LEDMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 22:12:21 -0500
Date: Wed, 4 Dec 2013 22:12:18 -0500
From: Don Zickus <dzickus@redhat.com>
To: Ben Zhang <benzh@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v2] watchdog: Add a sysctl to disable soft lockup detector
Message-ID: <20131205031218.GO35219@redhat.com>
References: <20131204212916.GJ35219@redhat.com>
 <1386208556-23873-1-git-send-email-benzh@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386208556-23873-1-git-send-email-benzh@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 04, 2013 at 05:55:56PM -0800, Ben Zhang wrote:
> Currently, the soft lockup detector and hard lockup detector
> can be enabled or disabled together via the flag variable
> watchdog_user_enabled. There isn't a way to disable only the
> soft lockup detector while keeping the hard lockup detector
> running.
> 
> The hard lockup detector sometimes does not work on a x86
> machine with multiple cpus when softlockup_panic is set to 0.
> For example:
> 1. Hard lockup occurs on cpu0 ("cli" followed by a infinite loop).
> 2. Soft lockup occurs on cpu1 shortly after because cpu1 tries to
> send a function to cpu0 via smp_call_function_single().
> 3. watchdog_timer_fn() detects the soft lockup on cpu1 and
> dumps the stack. dump_stack() eventually calls touch_nmi_watchdog()
> which sets watchdog_nmi_touch=true for all cpus and sets
> watchdog_touch_ts=0 for cpu1.
> 4. NMI fires on cpu0. watchdog_overflow_callback() sees
> watchdog_nmi_touch=true, so it does not do anything except setting
> watchdog_nmi_touch=false.
> 5. watchdog_timer_fn() is called again on cpu1, it sees
> watchdog_touch_ts=0, so reloads it with the current tick. Thus,
> is_softlockup() returns false, and soft_watchdog_warn is set to false.
> 6. Before NMI can fire on cpu0 again with watchdog_nmi_touch=false,
> watchdog_timer_fn() reports the soft lockup on cpu1 again
> and we go back to #3.

Yup.  This is because touch_nmi_watchdog touches _all_ the cpus instead of
its own.  I tried to fix this 3 years ago, but Andrew wanted me to fix
something else in the panic code first as a trade for his ack in changing
the semantics of touch_nmi_watchdog. ;-p

I doubt this patch still applies but the concept is pretty simple, touch
only the local cpu not all of them.  Should be pretty easy to port.

Not entirely sure if this would be accepted by folks, but I think it would
address your fundamental problem.

Cheers,
Don 

-------------------8<------------------------
From: Don Zickus <dzickus@redhat.com>
Date: Thu, 4 Nov 2010 20:53:03 -0400
Subject: [PATCH v3] watchdog:  touch_nmi_watchdog should only touch local cpu not every one

I ran into a scenario where while one cpu was stuck and should have panic'd
because of the NMI watchdog, it didn't.  The reason was another cpu was spewing
stack dumps on to the console.  Upon investigation, I noticed that when writing
to the console and also when dumping the stack, the watchdog is touched.

This causes all the cpus to reset their NMI watchdog flags and the 'stuck' cpu
just spins forever.

This change causes the semantics of touch_nmi_watchdog to be changed slightly.
Previously, I accidentally changed the semantics and we noticed there was a
codepath in which touch_nmi_watchdog could be touched from a preemtible area.
That caused a BUG() to happen when CONFIG_DEBUG_PREEMPT was enabled.  I believe
it was the acpi code.

My attempt here re-introduces the change to have the touch_nmi_watchdog() code
only touch the local cpu instead of all of the cpus.  But instead of using
__get_cpu_var(), I use the __raw_get_cpu_var() version.

This avoids the preemption problem.  However my reasoning wasn't because I was
trying to be lazy.  Instead I rationalized it as, well if preemption is enabled
then interrupts should be enabled to and the NMI watchdog will have no reason
to trigger.  So it won't matter if the wrong cpu is touched because the percpu
interrupt counters the NMI watchdog uses should still be incrementing.

V3: Really remove touch_all_nmi_watchdogs()
V2: Remove touch_all_nmi_watchdogs()

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index dc8e168..09fddd7 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -141,14 +141,15 @@ void touch_all_softlockup_watchdogs(void)
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 void touch_nmi_watchdog(void)
 {
-	if (watchdog_enabled) {
-		unsigned cpu;
+	/*
+	 * Using __raw here because some code paths have
+	 * preemption enabled.  If preemption is enabled
+	 * then interrupts should be enabled too, in which
+	 * case we shouldn't have to worry about the watchdog
+	 * going off.
+	 */
+	__raw_get_cpu_var(watchdog_nmi_touch) = true;
 
-		for_each_present_cpu(cpu) {
-			if (per_cpu(watchdog_nmi_touch, cpu) != true)
-				per_cpu(watchdog_nmi_touch, cpu) = true;
-		}
-	}
 	touch_softlockup_watchdog();
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
-- 
1.7.2.3

