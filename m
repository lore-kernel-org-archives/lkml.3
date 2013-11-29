Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab3K2Kq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 05:46:29 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:52980 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab3K2KqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 05:46:25 -0500
Subject: [PATCH V4 6/9] cpuidle/ppc: Add basic infrastructure to enable the
 broadcast framework on ppc
To: fweisbec@gmail.com, paul.gortmaker@windriver.com, paulus@samba.org,
        shangw@linux.vnet.ibm.com, rjw@sisk.pl, galak@kernel.crashing.org,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, michael@ellerman.id.au,
        john.stultz@linaro.org, tglx@linutronix.de, chenhui.zhao@freescale.com,
        deepthi@linux.vnet.ibm.com, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Fri, 29 Nov 2013 16:13:03 +0530
Message-ID: <20131129104303.651.40279.stgit@preeti.in.ibm.com>
In-Reply-To: <20131129104010.651.23117.stgit@preeti.in.ibm.com>
References: <20131129104010.651.23117.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112910-0320-0000-0000-000001DA6226
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ppc there are certain deep CPU idle states in which the local timers stop. One such
idle state on Power8 is "Fast-Sleep". However we do not have an external timer
to wake up these CPUs. Hence we prevent one of the CPUs from entering
Fast-Sleep so that it can wakeup the remaining CPUs in this state.

However we would still rely on the broadcast framework[1] in the kernel to keep
track of the CPUs in deep idle and the time at which to wake them up. To enable
this framework, we need to register a clock device that does not stop in deep idle
states. Without such a device, the broadcast framework does not take any
action when CPUs enter and exit deep idle states since it believes that there
is no clock device to wakeup the CPUs in deep idle states.

A local timer does not satisfy this condition and hence we introduce a
pseudo clock device, called the broadcast_clockevent and get this registered
in the broadcast framework. This is done to trick the broadcast framework
into believing that we have an external timer to wakeup the CPUs. But this
device is not programmable; it just enables us to make use of the broadcast framework.

[1]http://lwn.net/Articles/574591/

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 arch/powerpc/Kconfig            |    2 +
 arch/powerpc/include/asm/time.h |    1 +
 arch/powerpc/kernel/time.c      |   58 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index b44b52c..cafa788 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -129,6 +129,8 @@ config PPC
 	select GENERIC_CMOS_UPDATE
 	select GENERIC_TIME_VSYSCALL_OLD
 	select GENERIC_CLOCKEVENTS
+	select GENERIC_CLOCKEVENTS_BROADCAST
+	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select GENERIC_STRNCPY_FROM_USER
 	select GENERIC_STRNLEN_USER
 	select HAVE_MOD_ARCH_SPECIFIC
diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index 1d428e6..4057425 100644
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
index 42cb603..d2e582b 100644
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
@@ -97,6 +98,10 @@ static struct clocksource clocksource_timebase = {
 
 static int decrementer_set_next_event(unsigned long evt,
 				      struct clock_event_device *dev);
+static int broadcast_set_next_event(unsigned long evt,
+				      struct clock_event_device *dev);
+static void broadcast_set_mode(enum clock_event_mode mode,
+				 struct clock_event_device *dev);
 static void decrementer_set_mode(enum clock_event_mode mode,
 				 struct clock_event_device *dev);
 
@@ -106,12 +111,23 @@ struct clock_event_device decrementer_clockevent = {
 	.irq            = 0,
 	.set_next_event = decrementer_set_next_event,
 	.set_mode       = decrementer_set_mode,
-	.features       = CLOCK_EVT_FEAT_ONESHOT,
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
 
@@ -811,6 +827,19 @@ static int decrementer_set_next_event(unsigned long evt,
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
@@ -840,6 +869,19 @@ static void register_decrementer_clockevent(int cpu)
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
@@ -854,6 +896,19 @@ static void __init init_decrementer_clockevent(void)
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
@@ -930,6 +985,7 @@ void __init time_init(void)
 	clocksource_init();
 
 	init_decrementer_clockevent();
+	init_broadcast_clockevent();
 }
 
 

