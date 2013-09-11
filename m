Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3IKCyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:54:46 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:51373 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884Ab3IKCyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:54:45 -0400
Subject: [PATCH V3 4/6] cpuidle/ppc: Add basic infrastructure to support the
 broadcast framework on ppc
To: benh@kernel.crashing.org, paul.gortmaker@windriver.com, paulus@samba.org,
        shangw@linux.vnet.ibm.com, rjw@sisk.pl, galak@kernel.crashing.org,
        fweisbec@gmail.com, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, michael@ellerman.id.au,
        john.stultz@linaro.org, tglx@linutronix.de, chenhui.zhao@freescale.com,
        deepthi@linux.vnet.ibm.com, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Wed, 11 Sep 2013 08:21:53 +0530
Message-ID: <20130911025153.27726.23239.stgit@preeti.in.ibm.com>
In-Reply-To: <20130911024906.27726.4735.stgit@preeti.in.ibm.com>
References: <20130911024906.27726.4735.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091102-0928-0000-0000-000001973B8D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The broadcast framework in the kernel expects an external clock device which will
continue functioning in deep idle states also. This ability is specified by
the "non-existence" of the feature C3STOP . This is the device that it relies
upon to wakup cpus in deep idle states whose local timers/clock devices get
switched off in deep idle states.

On ppc we do not have such an external device. Therefore we introduce a
pseudo clock device, which has the features of this external clock device
called the broadcast_clockevent. Having such a device qualifies the cpus to
enter and exit deep idle states from the point of view of the broadcast
framework, because there is an external device to wake them up.
	Specifically the broadcast framework uses this device's event
handler and next_event members in its functioning. On ppc we use this
device as the gateway into the broadcast framework and *not* as a
timer. An explicit timer infrastructure will be developed in the following
patches to keep track of when to wake up cpus in deep idle.

Since this device is a pseudo device, it can be safely assumed to work for
all cpus. Therefore its cpumask is set to cpu_possible_mask. Also due to the
same reason, the set_next_event() routine associated with this device is a
nop.

The broadcast framework relies on a broadcast functionality being made
available in the .broadcast member of the local clock devices on all cpus.
This function is called upon by the broadcast framework on one of the nominated
cpus, to send ipis to all the cpus in deep idle at their expired timer events.
This patch also initializes the .broadcast member of the decrementer whose
job is to send the broadcast ipis.

When cpus inform the broadcast framework that they are entering deep idle,
their local timers are put in shutdown mode. On ppc, this means setting the
decrementer_next_tb and programming the decrementer to DECREMENTER_MAX.
On being woken up by the broadcast ipi, these cpus call __timer_interrupt(),
which runs the local timers only if decrementer_next_tb has expired.
  Therefore on being woken up from the broadcast ipi, set the decrementers_next_tb
to now before calling __timer_interrupt().

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 arch/powerpc/Kconfig            |    1 +
 arch/powerpc/include/asm/time.h |    1 +
 arch/powerpc/kernel/time.c      |   69 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index dbd9d3c..550fc04 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -130,6 +130,7 @@ config PPC
 	select GENERIC_CMOS_UPDATE
 	select GENERIC_TIME_VSYSCALL_OLD
 	select GENERIC_CLOCKEVENTS
+	select GENERIC_CLOCKEVENTS_BROADCAST
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select HAVE_MOD_ARCH_SPECIFIC
diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index 4e35282..264dc96 100644
--- a/arch/powerpc/include/asm/time.h
+++ b/arch/powerpc/include/asm/time.h
@@ -24,6 +24,7 @@ extern unsigned long tb_ticks_per_jiffy;
 extern unsigned long tb_ticks_per_usec;
 extern unsigned long tb_ticks_per_sec;
 extern struct clock_event_device decrementer_clockevent;
+extern struct clock_event_device broadcast_clockevent;
 
 struct rtc_time;
 extern void to_tm(int tim, struct rtc_time * tm);
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index eb48291..bda78bb 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -42,6 +42,7 @@
 #include <linux/timex.h>
 #include <linux/kernel_stat.h>
 #include <linux/time.h>
+#include <linux/timer.h>
 #include <linux/init.h>
 #include <linux/profile.h>
 #include <linux/cpu.h>
@@ -97,8 +98,13 @@ static struct clocksource clocksource_timebase = {
 
 static int decrementer_set_next_event(unsigned long evt,
 				      struct clock_event_device *dev);
+static int broadcast_set_next_event(unsigned long evt,
+				      struct clock_event_device *dev);
+static void broadcast_set_mode(enum clock_event_mode mode,
+				 struct clock_event_device *dev);
 static void decrementer_set_mode(enum clock_event_mode mode,
 				 struct clock_event_device *dev);
+static void decrementer_timer_broadcast(const struct cpumask *mask);
 
 struct clock_event_device decrementer_clockevent = {
 	.name           = "decrementer",
@@ -106,12 +112,24 @@ struct clock_event_device decrementer_clockevent = {
 	.irq            = 0,
 	.set_next_event = decrementer_set_next_event,
 	.set_mode       = decrementer_set_mode,
-	.features       = CLOCK_EVT_FEAT_ONESHOT,
+	.broadcast	= decrementer_timer_broadcast,
+	.features       = CLOCK_EVT_FEAT_C3STOP | CLOCK_EVT_FEAT_ONESHOT,
 };
 EXPORT_SYMBOL(decrementer_clockevent);
 
+struct clock_event_device broadcast_clockevent = {
+	.name           = "broadcast",
+	.rating         = 200,
+	.irq            = 0,
+	.set_next_event = broadcast_set_next_event,
+	.set_mode       = broadcast_set_mode,
+	.features       = CLOCK_EVT_FEAT_ONESHOT,
+};
+EXPORT_SYMBOL(broadcast_clockevent);
+
 DEFINE_PER_CPU(u64, decrementers_next_tb);
 static DEFINE_PER_CPU(struct clock_event_device, decrementers);
+static struct clock_event_device bc_timer;
 
 #define XSEC_PER_SEC (1024*1024)
 
@@ -811,6 +829,19 @@ static int decrementer_set_next_event(unsigned long evt,
 	return 0;
 }
 
+static int broadcast_set_next_event(unsigned long evt,
+					struct clock_event_device *dev)
+{
+	return 0;
+}
+
+static void broadcast_set_mode(enum clock_event_mode mode,
+				 struct clock_event_device *dev)
+{
+	if (mode != CLOCK_EVT_MODE_ONESHOT)
+		broadcast_set_next_event(DECREMENTER_MAX, dev);
+}
+
 static void decrementer_set_mode(enum clock_event_mode mode,
 				 struct clock_event_device *dev)
 {
@@ -820,6 +851,15 @@ static void decrementer_set_mode(enum clock_event_mode mode,
 
 void decrementer_timer_interrupt(void)
 {
+	u64 *next_tb = &__get_cpu_var(decrementers_next_tb);
+
+	*next_tb = get_tb_or_rtc();
+	__timer_interrupt();
+}
+
+static void decrementer_timer_broadcast(const struct cpumask *mask)
+{
+	arch_send_tick_broadcast(mask);
 }
 
 static void register_decrementer_clockevent(int cpu)
@@ -835,6 +875,19 @@ static void register_decrementer_clockevent(int cpu)
 	clockevents_register_device(dec);
 }
 
+static void register_broadcast_clockevent(int cpu)
+{
+	struct clock_event_device *bc_evt = &bc_timer;
+
+	*bc_evt = broadcast_clockevent;
+	bc_evt->cpumask = cpu_possible_mask;
+
+	printk_once(KERN_DEBUG "clockevent: %s mult[%x] shift[%d] cpu[%d]\n",
+		    bc_evt->name, bc_evt->mult, bc_evt->shift, cpu);
+
+	clockevents_register_device(bc_evt);
+}
+
 static void __init init_decrementer_clockevent(void)
 {
 	int cpu = smp_processor_id();
@@ -849,6 +902,19 @@ static void __init init_decrementer_clockevent(void)
 	register_decrementer_clockevent(cpu);
 }
 
+static void __init init_broadcast_clockevent(void)
+{
+	int cpu = smp_processor_id();
+
+	clockevents_calc_mult_shift(&broadcast_clockevent, ppc_tb_freq, 4);
+
+	broadcast_clockevent.max_delta_ns =
+		clockevent_delta2ns(DECREMENTER_MAX, &broadcast_clockevent);
+	broadcast_clockevent.min_delta_ns =
+		clockevent_delta2ns(2, &broadcast_clockevent);
+	register_broadcast_clockevent(cpu);
+}
+
 void secondary_cpu_time_init(void)
 {
 	/* Start the decrementer on CPUs that have manual control
@@ -925,6 +991,7 @@ void __init time_init(void)
 	clocksource_init();
 
 	init_decrementer_clockevent();
+	init_broadcast_clockevent();
 }
 
 

