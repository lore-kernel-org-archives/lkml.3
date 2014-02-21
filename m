Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757AbaBUM5I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:57:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47279 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621AbaBUMvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Gleixner <tglx@linutronix.de>, Olaf Hering <olaf@aepfle.de>,
        Dave Jones <davej@redhat.com>, "Justin M. Forbes" <jforbes@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 108/121] tick: Clear broadcast pending bit when switching to oneshot
Date: Fri, 21 Feb 2014 12:48:52 +0000
Message-Id: <1392986945-9693-109-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit dd5fd9b91a77b4c9c28b7ef9c181b1a875820d0a upstream.

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

Stanislaw came up independently with the same patch by enforcing the
C1E workaround and debugging the fallout. I picked mine, because mine
has a changelog :)

Reported-by: poma <pomidorabelisima@gmail.com>
Debugged-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Olaf Hering <olaf@aepfle.de>
Cc: Dave Jones <davej@redhat.com>
Cc: Justin M. Forbes <jforbes@redhat.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1402111434180.21991@ionos.tec.linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/time/tick-broadcast.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 218bcb5..8a95408b 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -755,6 +755,7 @@ out:
 static void tick_broadcast_clear_oneshot(int cpu)
 {
 	cpumask_clear_cpu(cpu, tick_broadcast_oneshot_mask);
+	cpumask_clear_cpu(cpu, tick_broadcast_pending_mask);
 }
 
 static void tick_broadcast_init_next_event(struct cpumask *mask,
-- 
1.9.0

