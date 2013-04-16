Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935341Ab3DPBUe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 21:20:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934897Ab3DPBUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 21:20:33 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] NOHZ, check to see if tick device is initialized in IRQ handling path
Date: Mon, 15 Apr 2013 21:20:25 -0400
Message-Id: <1366075225-21115-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think the linux.git "system hang" isn't really a hang.  For some reason the
panic text wasn't displayed on the console.  I've seen this behaviour a few
times now ... maybe there's a bug in the panic output path?

I also haven't determined why I'm seeing a thermal interrupt during a CPU
hotplug test.  It could be a problem with the hardware I'm testing on, but
the bottom line is that it is possible to take an interrupt before the
tick's evtdev is set.

I can also see via some simple printk debug that it certainly looks like
the thermal interrupt code is enabled prior to the tick:

echo 1 > /sys/.../cpu/cpu20/online

[  347.402647] thermal_throttle_cpu_callback: cpu 20 add dev  <<< my debug
[  347.408992] Booting Node 0 Processor 20 APIC 0x1
[  347.429219] cpu_notify: called with CPU_STARTING <<< my debug
[  347.431261] cpu_notify: called with CPU_ONLINE <<< my debug
[  347.429219] tick_check_new_device: new cpu 20 evtdev start  <<< my debug
[  347.462542] microcode: CPU20 sig=0x306e2, pf=0x1, revision=0x209
[  347.469276] platform microcode: firmware: requesting intel-ucode/06-3e-02

Here's a patch...

----8<----

When adding a CPU there is a small window in which interrupts are enabled and
the clock tick device has not been initialized.  If an interrupt occurs in
this window, irq_exit() will be called which calls tick_nohz_irq_exit() which
in turn calls __tick_nohz_idle_enter().

__tick_nohz_idle() enter assumes that the tick has been initialized.  In the
above case, however, it has not and this leads to what appears to be a system
hang on latest linux.git or a the following panic on RHEL6:

Pid: 0, comm: swapper Not tainted 2.6.32-358.el6.x86_64 #1
RIP: 0010:[<ffffffff810a89e5>]  [<ffffffff810a89e5>] tick_nohz_stop_sched_tick+0x2a5/0x3e0
RSP: 0018:ffff88089c503f38  EFLAGS: 00010046
RAX: ffffffff81c07520 RBX: ffff88089c5116a0 RCX: 000002f04bb18cd8
RDX: 0000000000000000 RSI: 000000000000a1b5 RDI: 000002f04bb0eb23
RBP: ffff88089c503f88 R08: ffff88089c50e060 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000017
R13: 000002f04bb17dd5 R14: 0000000000000000 R15: 0000000000000092
FS:  0000000000000000(0000) GS:ffff88089c500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 0000000000000078 CR3: 0000000001a85000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 0, threadinfo ffff8810745c0000, task ffff8808740f2080)
Stack:
 00000000000116a0 0000000000000087 ffff88089c503f78 0000000000000046
<d> ffff88089c503f98 0000000000000000 0000000000000000 0000000000000000
<d> 0000000000000000 0000000000000000 ffff88089c503f98 ffffffff81076d86
Call Trace:
 <IRQ>
 [<ffffffff81076d86>] irq_exit+0x76/0x90
 [<ffffffff81028dd6>] smp_thermal_interrupt+0x26/0x40
 [<ffffffff8100bcf3>] thermal_interrupt+0x13/0x20
 <EOI>
 [<ffffffff81506997>] ? start_secondary+0x127/0x2ef
 [<ffffffff81506990>] ? start_secondary+0x120/0x2ef

The code currently assumes that the tick device is initialized when
irq_enter() and irq_exit() are called.  This is not correct and a check must
be performed prior to entering the tick code through these code paths to
ensure that the tick device is initialized and running.

I've only seen this occur on one system.  I've tested with and without the
patch and as far as I can tell this patch resolves the problem on
linux.git top of tree.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-sched.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index a19a399..5027187 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -567,6 +567,12 @@ EXPORT_SYMBOL_GPL(tick_nohz_idle_enter);
 void tick_nohz_irq_exit(void)
 {
 	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+	struct clock_event_device *dev =
+				     __get_cpu_var(tick_cpu_device).evtdev;
+
+	/* Has the tick been initialized yet? */
+	if (unlikely(!dev || dev->mode == CLOCK_EVT_MODE_UNUSED))
+		return;
 
 	if (!ts->inidle)
 		return;
@@ -809,6 +815,12 @@ static inline void tick_check_nohz(int cpu) { }
  */
 void tick_check_idle(int cpu)
 {
+	struct clock_event_device *dev = per_cpu(tick_cpu_device, cpu).evtdev;
+
+	/* Has the tick been initialized yet? */
+	if (unlikely(!dev || dev->mode == CLOCK_EVT_MODE_UNUSED))
+		return;
+
 	tick_check_oneshot_broadcast(cpu);
 	tick_check_nohz(cpu);
 }
-- 
1.7.9.3

