Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734Ab3IKE6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab3IKE44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:56 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=X7RI7SzHyIoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=9keDbNrbGkoA:10 a=yPCof4ZbAAAA:8 a=VnNF1IyMAAAA:8 a=VmTogLBsE3_rpke-7agA:9 a=7DSvI1NPTFQA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042928.371646481@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [217/251] xen/smp: initialize IPI vectors before marking CPU online
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0217-xen-smp-initialize-IPI-vectors-before-marking-CPU-on.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Chuck Anderson <chuck.anderson@oracle.com>

[ Upstream commit fc78d343fa74514f6fd117b5ef4cd27e4ac30236 ]

An older PVHVM guest (v3.0 based) crashed during vCPU hot-plug with:

	kernel BUG at drivers/xen/events.c:1328!

RCU has detected that a CPU has not entered a quiescent state within the
grace period.  It needs to send the CPU a reschedule IPI if it is not
offline.  rcu_implicit_offline_qs() does this check:

	/*
	 * If the CPU is offline, it is in a quiescent state.  We can
	 * trust its state not to change because interrupts are disabled.
	 */
	if (cpu_is_offline(rdp->cpu)) {
		rdp->offline_fqs++;
		return 1;
	}

	Else the CPU is online.  Send it a reschedule IPI.

The CPU is in the middle of being hot-plugged and has been marked online
(!cpu_is_offline()).  See start_secondary():

	set_cpu_online(smp_processor_id(), true);
	...
	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;

start_secondary() then waits for the CPU bringing up the hot-plugged CPU to
mark it as active:

	/*
	 * Wait until the cpu which brought this one up marked it
	 * online before enabling interrupts. If we don't do that then
	 * we can end up waking up the softirq thread before this cpu
	 * reached the active state, which makes the scheduler unhappy
	 * and schedule the softirq thread on the wrong cpu. This is
	 * only observable with forced threaded interrupts, but in
	 * theory it could also happen w/o them. It's just way harder
	 * to achieve.
	 */
	while (!cpumask_test_cpu(smp_processor_id(), cpu_active_mask))
		cpu_relax();

	/* enable local interrupts */
	local_irq_enable();

The CPU being hot-plugged will be marked active after it has been fully
initialized by the CPU managing the hot-plug.  In the Xen PVHVM case
xen_smp_intr_init() is called to set up the hot-plugged vCPU's
XEN_RESCHEDULE_VECTOR.

The hot-plugging CPU is marked online, not marked active and does not have
its IPI vectors set up.  rcu_implicit_offline_qs() sees the hot-plugging
cpu is !cpu_is_offline() and tries to send it a reschedule IPI:
This will lead to:

	kernel BUG at drivers/xen/events.c:1328!

	xen_send_IPI_one()
	xen_smp_send_reschedule()
	rcu_implicit_offline_qs()
	rcu_implicit_dynticks_qs()
	force_qs_rnp()
	force_quiescent_state()
	__rcu_process_callbacks()
	rcu_process_callbacks()
	__do_softirq()
	call_softirq()
	do_softirq()
	irq_exit()
	xen_evtchn_do_upcall()

because xen_send_IPI_one() will attempt to use an uninitialized IRQ for
the XEN_RESCHEDULE_VECTOR.

There is at least one other place that has caused the same crash:

	xen_smp_send_reschedule()
	wake_up_idle_cpu()
	add_timer_on()
	clocksource_watchdog()
	call_timer_fn()
	run_timer_softirq()
	__do_softirq()
	call_softirq()
	do_softirq()
	irq_exit()
	xen_evtchn_do_upcall()
	xen_hvm_callback_vector()

clocksource_watchdog() uses cpu_online_mask to pick the next CPU to handle
a watchdog timer:

	/*
	 * Cycle through CPUs to check if the CPUs stay synchronized
	 * to each other.
	 */
	next_cpu = cpumask_next(raw_smp_processor_id(), cpu_online_mask);
	if (next_cpu >= nr_cpu_ids)
		next_cpu = cpumask_first(cpu_online_mask);
	watchdog_timer.expires += WATCHDOG_INTERVAL;
	add_timer_on(&watchdog_timer, next_cpu);

This resulted in an attempt to send an IPI to a hot-plugging CPU that
had not initialized its reschedule vector. One option would be to make
the RCU code check to not check for CPU offline but for CPU active.
As becoming active is done after a CPU is online (in older kernels).

But Srivatsa pointed out that "the cpu_active vs cpu_online ordering has been
completely reworked - in the online path, cpu_active is set *before* cpu_online,
and also, in the cpu offline path, the cpu_active bit is reset in the CPU_DYING
notification instead of CPU_DOWN_PREPARE." Drilling in this the bring-up
path: "[brought up CPU].. send out a CPU_STARTING notification, and in response
to that, the scheduler sets the CPU in the cpu_active_mask. Again, this mask
is better left to the scheduler alone, since it has the intelligence to use it
judiciously."

The conclusion was that:
"
1. At the IPI sender side:

   It is incorrect to send an IPI to an offline CPU (cpu not present in
   the cpu_online_mask). There are numerous places where we check this
   and warn/complain.

2. At the IPI receiver side:

   It is incorrect to let the world know of our presence (by setting
   ourselves in global bitmasks) until our initialization steps are complete
   to such an extent that we can handle the consequences (such as
   receiving interrupts without crashing the sender etc.)
" (from Srivatsa)

As the native code enables the interrupts at some point we need to be
able to service them. In other words a CPU must have valid IPI vectors
if it has been marked online.

It doesn't need to handle the IPI (interrupts may be disabled) but needs
to have valid IPI vectors because another CPU may find it in cpu_online_mask
and attempt to send it an IPI.

This patch will change the order of the Xen vCPU bring-up functions so that
Xen vectors have been set up before start_secondary() is called.
It also will not continue to bring up a Xen vCPU if xen_smp_intr_init() fails
to initialize it.

Orabug 13823853
Signed-off-by Chuck Anderson <chuck.anderson@oracle.com>
Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/xen/smp.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 76bce6e..72701ac 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -663,8 +663,15 @@ static void __init xen_hvm_smp_prepare_cpus(unsigned int max_cpus)
 static int __cpuinit xen_hvm_cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int rc;
-	rc = native_cpu_up(cpu, tidle);
-	WARN_ON (xen_smp_intr_init(cpu));
+	/*
+	 * xen_smp_intr_init() needs to run before native_cpu_up()
+	 * so that IPI vectors are set up on the booting CPU before
+	 * it is marked online in native_cpu_up().
+	*/
+	rc = xen_smp_intr_init(cpu);
+	WARN_ON(rc);
+	if (!rc)
+		rc =  native_cpu_up(cpu, tidle);
 	return rc;
 }
 
-- 
1.7.10.4


