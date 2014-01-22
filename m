Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaAVRPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 12:15:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34867 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaAVRPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 12:15:33 -0500
Date: Wed, 22 Jan 2014 18:14:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] sched: Use a static_key for sched_clock_stable
Message-ID: <20140122171454.GR31570@twins.programming.kicks-ass.net>
References: <20131212140835.729222186@infradead.org>
 <20131212141655.362219382@infradead.org>
 <52DEF495.2020304@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DEF495.2020304@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 05:28:37PM -0500, Sasha Levin wrote:
> 	[    0.000000] Initmem setup node 30 [mem 0x12ee000000-0x138dffffff]
> 	[    0.000000]   NODE_DATA [mem 0xcfa42000-0xcfa72fff]
> 	[    0.000000]     NODE_DATA(30) on node 1
> 	[    0.000000] Initmem setup node 31 [mem 0x138e000000-0x142fffffff]
> 	[    0.000000]   NODE_DATA [mem 0xcfa11000-0xcfa41fff]
> 	[    0.000000]     NODE_DATA(31) on node 1
> 	[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> 	[    0.000000] kvm-clock: cpu 0, msr 0:cf991001, boot clock
> 	[133538.294040] Zone ranges:
> 	[133538.294338]   DMA      [mem 0x00001000-0x00ffffff]
> 	[133538.294804]   DMA32    [mem 0x01000000-0xffffffff]
> 	[133538.295223]   Normal   [mem 0x100000000-0x142fffffff]
> 	[133538.295670] Movable zone start for each node

OK, took me a while to fiddle with KVM and all the various muck around
that to reproduce. But I can confirm the below does fix the issue for
me.

I'm hoping to not have to re-introcude the kevents_up() check, but I
need to figure out what hardware triggered that and test again.

---
Subject: sched/clock: Fixup early sched_clock initialization
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 22 Jan 2014 12:59:18 +0100

The code would assume sched_clock_stable() and switch to !stable
later, this switch brings a discontinuity in time.

The discontinuity on switching from stable to unstable was always
present, but previously we would set stable/unstable before
initializing TSC and usually stick to the one we start out with.

So the static_key bits brought an extra switch where there previously
wasn't one.

Things are further complicated by the fact that we cannot use
static_key as early as we usually call set_sched_clock_stable().

Fix things by tracking the stable state in a regular variable and only
set the static_key to the right state on sched_clock_init(), which is
ran right after late_time_init->tsc_init().

Before this we would not be using the TSC anyway.

Fixes: 35af99e646c7 ("sched/clock, x86: Use a static_key for sched_clock_stable")
Cc: jacob.jun.pan@linux.intel.com
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com
Cc: paulmck@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: lenb@kernel.org
Cc: rjw@rjwysocki.net
Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: rui.zhang@intel.com
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Reported-by: dyoung@redhat.com
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140122115918.GG3694@twins.programming.kicks-ass.net
---
 kernel/sched/clock.c |   53 +++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 12 deletions(-)

--- a/kernel/sched/clock.c
+++ b/kernel/sched/clock.c
@@ -77,35 +77,50 @@ __read_mostly int sched_clock_running;
 
 #ifdef CONFIG_HAVE_UNSTABLE_SCHED_CLOCK
 static struct static_key __sched_clock_stable = STATIC_KEY_INIT;
+static int __sched_clock_stable_early;
 
 int sched_clock_stable(void)
 {
-	if (static_key_false(&__sched_clock_stable))
-		return false;
-	return true;
+	return static_key_false(&__sched_clock_stable);
 }
 
-void set_sched_clock_stable(void)
+static void __set_sched_clock_stable(void)
 {
 	if (!sched_clock_stable())
-		static_key_slow_dec(&__sched_clock_stable);
+		static_key_slow_inc(&__sched_clock_stable);
+}
+
+void set_sched_clock_stable(void)
+{
+	__sched_clock_stable_early = 1;
+
+	smp_mb(); /* matches sched_clock_init() */
+
+	if (!sched_clock_running)
+		return;
+
+	__set_sched_clock_stable();
 }
 
 static void __clear_sched_clock_stable(struct work_struct *work)
 {
 	/* XXX worry about clock continuity */
 	if (sched_clock_stable())
-		static_key_slow_inc(&__sched_clock_stable);
+		static_key_slow_dec(&__sched_clock_stable);
 }
 
 static DECLARE_WORK(sched_clock_work, __clear_sched_clock_stable);
 
 void clear_sched_clock_stable(void)
 {
-	if (keventd_up())
-		schedule_work(&sched_clock_work);
-	else
-		__clear_sched_clock_stable(&sched_clock_work);
+	__sched_clock_stable_early = 0;
+
+	smp_mb(); /* matches sched_clock_init() */
+
+	if (!sched_clock_running)
+		return;
+
+	schedule_work(&sched_clock_work);
 }
 
 struct sched_clock_data {
@@ -140,6 +155,20 @@ void sched_clock_init(void)
 	}
 
 	sched_clock_running = 1;
+
+	/*
+	 * Ensure that it is impossible to not do a static_key update.
+	 *
+	 * Either {set,clear}_sched_clock_stable() must see sched_clock_running
+	 * and do the update, or we must see their __sched_clock_stable_early
+	 * and do the update, or both.
+	 */
+	smp_mb(); /* matches {set,clear}_sched_clock_stable() */
+
+	if (__sched_clock_stable_early)
+		__set_sched_clock_stable();
+	else
+		__clear_sched_clock_stable(NULL);
 }
 
 /*
@@ -340,7 +369,7 @@ EXPORT_SYMBOL_GPL(sched_clock_idle_wakeu
  */
 u64 cpu_clock(int cpu)
 {
-	if (static_key_false(&__sched_clock_stable))
+	if (!sched_clock_stable())
 		return sched_clock_cpu(cpu);
 
 	return sched_clock();
@@ -355,7 +384,7 @@ u64 cpu_clock(int cpu)
  */
 u64 local_clock(void)
 {
-	if (static_key_false(&__sched_clock_stable))
+	if (!sched_clock_stable())
 		return sched_clock_cpu(raw_smp_processor_id());
 
 	return sched_clock();
