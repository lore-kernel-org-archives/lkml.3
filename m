Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaBKOZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 09:25:00 -0500
Received: from www.linutronix.de ([62.245.132.108]:42129 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbaBKOY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 09:24:58 -0500
Date: Tue, 11 Feb 2014 15:25:05 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: poma <pomidorabelisima@gmail.com>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org,
        Olaf Hering <olaf@aepfle.de>, Dave Jones <davej@redhat.com>,
        "Justin M. Forbes" <jforbes@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: WARNING: CPU: 1 PID: 0 at kernel/time/tick-broadcast.c:668
 tick_broadcast_oneshot_control+0x17d/0x190()
In-Reply-To: <alpine.DEB.2.02.1402101056260.21991@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.02.1402111434180.21991@ionos.tec.linutronix.de>
References: <52F84A9B.5020008@gmail.com> <alpine.DEB.2.02.1402101056260.21991@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb 2014, Thomas Gleixner wrote:
> On Mon, 10 Feb 2014, poma wrote:
> 
> > [   83.558551]  [<ffffffff81025b17>] amd_e400_idle+0x87/0x130
> 
> So this seems to happen only on AMD machines which use that e400 idle
> mode. I have no idea at the moment whats wrong there. I'll find one of
> those machines and try to reproduce.

Found it. Patch below.

Thanks,

	tglx
----
Subject: tick: Clear broadcast pending bit when switching to oneshot
From: Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 11 Feb 2014 14:35:40 +0100

AMD systems which use the C1E workaround in the amd_e400_idle routine
trigger the WARN_ON_ONCE in the broadcast code when onlining a CPU.

The reason is that the idle routine of those AMD systems switches the
cpu into forced broadcast mode early on before the newly brought up
CPU can switch over to high resolution / NOHZ mode. The timer related
CPU1 bringup looks like this:

  clockevent_register_device(local_apic);
  tick_setup(local_apic);
  ...
  idle()
	tick_broadcast_on_off(FORCE);
	tick_broadcast_oneshot_control(ENTER)
	  cpumask_set(cpu, broadcast_oneshot_mask);
	halt();

Now the broadcast interrupt on CPU0 sets CPU1 in the
broadcast_pending_mask and wakes CPU1. So CPU1 continues:

	local_apic_timer_interrupt()
	   tick_handle_periodic();
	   softirq()
	     tick_init_highres();
	       cpumask_clr(cpu, broadcast_oneshot_mask);
	
	tick_broadcast_oneshot_control(ENTER)
	   WARN_ON(cpumask_test(cpu, broadcast_pending_mask);

So while we remove CPU1 from the broadcast_oneshot_mask when we switch
over to highres mode, we do not clear the pending bit, which then
triggers the warning when we go back to idle.

The reason why this is only visible on C1E affected AMD systems is
that the other machines enter the deep sleep states via
acpi_idle/intel_idle and exit the broadcast mode before executing the
remote triggered local_apic_timer_interrupt. So the pending bit is
already cleared when the switch over to highres mode is clearing the
oneshot mask.

The solution is simple: Clear the pending bit together with the mask
bit when we switch over to highres mode.

Reported-by: poma <pomidorabelisima@gmail.com>
Cc: stable@vger.kernel.org # 3.10+
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-broadcast.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/kernel/time/tick-broadcast.c
===================================================================
--- linux-2.6.orig/kernel/time/tick-broadcast.c
+++ linux-2.6/kernel/time/tick-broadcast.c
@@ -756,6 +756,7 @@ out:
 static void tick_broadcast_clear_oneshot(int cpu)
 {
 	cpumask_clear_cpu(cpu, tick_broadcast_oneshot_mask);
+	cpumask_clear_cpu(cpu, tick_broadcast_pending_mask);
 }
 
 static void tick_broadcast_init_next_event(struct cpumask *mask,


