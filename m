Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925Ab3HNL6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 07:58:52 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:38340 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759737Ab3HNL6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 07:58:49 -0400
Subject: [RFC V2 PATCH 3/6] cpuidle/ppc: Add timer offload framework to
 support deep idle states
To: fweisbec@gmail.com, paul.gortmaker@windriver.com, paulus@samba.org,
        shangw@linux.vnet.ibm.com, galak@kernel.crashing.org,
        deepthi@linux.vnet.ibm.com, benh@kernel.crashing.org,
        paulmck@linux.vnet.ibm.com, arnd@arndb.de, linux-pm@vger.kernel.org,
        rostedt@goodmis.org, rjw@sisk.pl, john.stultz@linaro.org,
        tglx@linutronix.de, chenhui.zhao@freescale.com, michael@ellerman.id.au,
        r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Wed, 14 Aug 2013 17:26:13 +0530
Message-ID: <20130814115613.5193.43161.stgit@preeti.in.ibm.com>
In-Reply-To: <20130814115311.5193.32212.stgit@preeti.in.ibm.com>
References: <20130814115311.5193.32212.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081411-7014-0000-0000-00000376F84E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ppc, in deep idle states, the local clock event device of CPUs gets
switched off. On PowerPC, the local clock event device is called the
decrementer. Make use of the broadcast framework to issue interrupts to
cpus in deep idle states on their timer events, except that on ppc, we
do not have an external device such as HPET, but we use the decrementer
of one of the CPUs itself as the broadcast device.

Instantiate two different clock event devices, one representing the
decrementer and another representing the broadcast device for each cpu.
The cpu which registers its broadcast device will be responsible for
performing the function of issuing timer interrupts to CPUs in deep idle
states, and is referred to as the broadcast cpu/bc_cpu in the changelogs of this
patchset for convenience. Such a CPU is not allowed to enter deep idle
states, where the decrementer is switched off.

For now, only the boot cpu's broadcast device gets registered as a clock event
device along with the decrementer. Hence this is the broadcast cpu.

On the broadcast cpu, on each timer interrupt, apart from the regular local
timer event handler the broadcast handler is also called. We avoid the overhead
of programming the decrementer specifically for a broadcast event. The reason is for
performance and scalability reasons. Say cpuX goes to deep idle state. It
has to ask the broadcast CPU to reprogram its(broadcast CPU's) decrementer for
the next local timer event of cpuX. cpuX can do so only by sending an IPI to the
broadcast CPU. With many more cpus going to deep idle, this model of sending
IPIs each time will result in performance bottleneck and may not scale well.

Apart from this there is no change in the way broadcast is handled today. On
a broadcast ipi the event handler for a timer interrupt is called on the cpu
in deep idle state to handle the local events.

The current design and implementation of the timer offload framework supports
the ONESHOT tick mode but not the PERIODIC mode.

Signed-off-by: Preeti U. Murthy <preeti@linux.vnet.ibm.com>
---

 arch/powerpc/include/asm/time.h        |    3 +
 arch/powerpc/kernel/smp.c              |    4 +-
 arch/powerpc/kernel/time.c             |   81 ++++++++++++++++++++++++++++++++
 arch/powerpc/platforms/powernv/Kconfig |    1 
 4 files changed, 86 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/time.h b/arch/powerpc/include/asm/time.h
index c1f2676..936be0d 100644
--- a/arch/powerpc/include/asm/time.h
+++ b/arch/powerpc/include/asm/time.h
@@ -24,14 +24,17 @@ extern unsigned long tb_ticks_per_jiffy;
 extern unsigned long tb_ticks_per_usec;
 extern unsigned long tb_ticks_per_sec;
 extern struct clock_event_device decrementer_clockevent;
+extern struct clock_event_device broadcast_clockevent;
 
 struct rtc_time;
 extern void to_tm(int tim, struct rtc_time * tm);
 extern void GregorianDay(struct rtc_time *tm);
+extern void decrementer_timer_interrupt(void);
 
 extern void generic_calibrate_decr(void);
 
 extern void set_dec_cpu6(unsigned int val);
+extern int bc_cpu;
 
 /* Some sane defaults: 125 MHz timebase, 1GHz processor */
 extern unsigned long ppc_proc_freq;
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 6a68ca4..d3b7014 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -114,7 +114,7 @@ int smp_generic_kick_cpu(int nr)
 
 static irqreturn_t timer_action(int irq, void *data)
 {
-	timer_interrupt();
+	decrementer_timer_interrupt();
 	return IRQ_HANDLED;
 }
 
@@ -223,7 +223,7 @@ irqreturn_t smp_ipi_demux(void)
 
 #ifdef __BIG_ENDIAN
 		if (all & (1 << (24 - 8 * PPC_MSG_TIMER)))
-			timer_interrupt();
+			decrementer_timer_interrupt();
 		if (all & (1 << (24 - 8 * PPC_MSG_RESCHEDULE)))
 			scheduler_ipi();
 		if (all & (1 << (24 - 8 * PPC_MSG_CALL_FUNC_SINGLE)))
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 65ab9e9..7e858e1 100644
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
@@ -97,8 +98,11 @@ static struct clocksource clocksource_timebase = {
 
 static int decrementer_set_next_event(unsigned long evt,
 				      struct clock_event_device *dev);
+static int broadcast_set_next_event(unsigned long evt,
+				      struct clock_event_device *dev);
 static void decrementer_set_mode(enum clock_event_mode mode,
 				 struct clock_event_device *dev);
+static void decrementer_timer_broadcast(const struct cpumask *mask);
 
 struct clock_event_device decrementer_clockevent = {
 	.name           = "decrementer",
@@ -106,13 +110,26 @@ struct clock_event_device decrementer_clockevent = {
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
+	.set_mode       = decrementer_set_mode,
+	.features       = CLOCK_EVT_FEAT_ONESHOT,
+};
+EXPORT_SYMBOL(broadcast_clockevent);
+
 DEFINE_PER_CPU(u64, decrementers_next_tb);
 static DEFINE_PER_CPU(struct clock_event_device, decrementers);
+static DEFINE_PER_CPU(struct clock_event_device, bc_timer);
 
+int bc_cpu;
 #define XSEC_PER_SEC (1024*1024)
 
 #ifdef CONFIG_PPC64
@@ -487,6 +504,8 @@ void timer_interrupt(struct pt_regs * regs)
 	struct pt_regs *old_regs;
 	u64 *next_tb = &__get_cpu_var(decrementers_next_tb);
 	struct clock_event_device *evt = &__get_cpu_var(decrementers);
+	struct clock_event_device *bc_evt = &__get_cpu_var(bc_timer);
+	int cpu = smp_processor_id();
 	u64 now;
 
 	/* Ensure a positive value is written to the decrementer, or else
@@ -532,6 +551,10 @@ void timer_interrupt(struct pt_regs * regs)
 		*next_tb = ~(u64)0;
 		if (evt->event_handler)
 			evt->event_handler(evt);
+		if (cpu == bc_cpu && bc_evt->event_handler) {
+			bc_evt->event_handler(bc_evt);
+		}
+
 	} else {
 		now = *next_tb - now;
 		if (now <= DECREMENTER_MAX)
@@ -806,6 +829,20 @@ static int decrementer_set_next_event(unsigned long evt,
 	return 0;
 }
 
+/*
+ * We cannot program the decrementer of a remote CPU. Hence CPUs going into
+ * deep idle states need to send IPIs to the broadcast CPU to program its
+ * decrementer for their next local event so as to receive a broadcast IPI
+ * for the same. In order to avoid the overhead of multiple CPUs from sending
+ * IPIs, this function is a nop. Instead the broadcast CPU will handle the
+ * wakeup of CPUs in deep idle states in each of its local timer interrupts.
+ */
+static int broadcast_set_next_event(unsigned long evt,
+					struct clock_event_device *dev)
+{
+	return 0;
+}
+
 static void decrementer_set_mode(enum clock_event_mode mode,
 				 struct clock_event_device *dev)
 {
@@ -813,6 +850,20 @@ static void decrementer_set_mode(enum clock_event_mode mode,
 		decrementer_set_next_event(DECREMENTER_MAX, dev);
 }
 
+void decrementer_timer_interrupt(void)
+{
+	struct clock_event_device *evt;
+	evt = &per_cpu(decrementers, smp_processor_id());
+
+	if (evt->event_handler)
+		evt->event_handler(evt);
+}
+
+static void decrementer_timer_broadcast(const struct cpumask *mask)
+{
+	arch_send_tick_broadcast(mask);
+}
+
 static void register_decrementer_clockevent(int cpu)
 {
 	struct clock_event_device *dec = &per_cpu(decrementers, cpu);
@@ -826,6 +877,20 @@ static void register_decrementer_clockevent(int cpu)
 	clockevents_register_device(dec);
 }
 
+static void register_broadcast_clockevent(int cpu)
+{
+	struct clock_event_device *bc_evt = &per_cpu(bc_timer, cpu);
+
+	*bc_evt = broadcast_clockevent;
+	bc_evt->cpumask = cpumask_of(cpu);
+
+	printk_once(KERN_DEBUG "clockevent: %s mult[%x] shift[%d] cpu[%d]\n",
+		    bc_evt->name, bc_evt->mult, bc_evt->shift, cpu);
+
+	clockevents_register_device(bc_evt);
+	bc_cpu = cpu;
+}
+
 static void __init init_decrementer_clockevent(void)
 {
 	int cpu = smp_processor_id();
@@ -840,6 +905,19 @@ static void __init init_decrementer_clockevent(void)
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
@@ -916,6 +994,7 @@ void __init time_init(void)
 	clocksource_init();
 
 	init_decrementer_clockevent();
+	init_broadcast_clockevent();
 }
 
 
diff --git a/arch/powerpc/platforms/powernv/Kconfig b/arch/powerpc/platforms/powernv/Kconfig
index ace2d22..e1a96eb 100644
--- a/arch/powerpc/platforms/powernv/Kconfig
+++ b/arch/powerpc/platforms/powernv/Kconfig
@@ -6,6 +6,7 @@ config PPC_POWERNV
 	select PPC_ICP_NATIVE
 	select PPC_P7_NAP
 	select PPC_PCI_CHOICE if EMBEDDED
+	select GENERIC_CLOCKEVENTS_BROADCAST
 	select EPAPR_BOOT
 	default y
 

