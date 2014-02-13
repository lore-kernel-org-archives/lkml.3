Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaBMU5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 15:57:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44026 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaBMU5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 15:57:53 -0500
Date: Thu, 13 Feb 2014 12:57:32 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-dd5fd9b91a77b4c9c28b7ef9c181b1a875820d0a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        olaf@aepfle.de, davej@redhat.com, jwboyer@redhat.com,
        tglx@linutronix.de, pomidorabelisima@gmail.com, sgruszka@redhat.com,
        jforbes@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        olaf@aepfle.de, davej@redhat.com, jwboyer@redhat.com,
        tglx@linutronix.de, pomidorabelisima@gmail.com, jforbes@redhat.com,
        sgruszka@redhat.com
In-Reply-To: <alpine.DEB.2.02.1402111434180.21991@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1402111434180.21991@ionos.tec.linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] tick:
  Clear broadcast pending bit when switching to oneshot
Git-Commit-ID: dd5fd9b91a77b4c9c28b7ef9c181b1a875820d0a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 12:57:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd5fd9b91a77b4c9c28b7ef9c181b1a875820d0a
Gitweb:     http://git.kernel.org/tip/dd5fd9b91a77b4c9c28b7ef9c181b1a875820d0a
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 11 Feb 2014 14:35:40 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 13 Feb 2014 21:55:54 +0100

tick: Clear broadcast pending bit when switching to oneshot

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
Cc: stable@vger.kernel.org # 3.10+
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-broadcast.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 43780ab..98977a5 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -756,6 +756,7 @@ out:
 static void tick_broadcast_clear_oneshot(int cpu)
 {
 	cpumask_clear_cpu(cpu, tick_broadcast_oneshot_mask);
+	cpumask_clear_cpu(cpu, tick_broadcast_pending_mask);
 }
 
 static void tick_broadcast_init_next_event(struct cpumask *mask,
