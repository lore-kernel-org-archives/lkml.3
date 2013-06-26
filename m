Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab3FZLF1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 07:05:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:33615 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3FZLFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 07:05:25 -0400
Date: Wed, 26 Jun 2013 13:05:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Prarit Bhargava <prarit@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, athorlton@sgi.com,
        CAI Qian <caiqian@redhat.com>
Subject: Re: BUG: tick device NULL pointer during system initialization and
 shutdown
In-Reply-To: <51CA2CBF.70404@redhat.com>
Message-ID: <alpine.DEB.2.02.1306261303260.4013@ionos.tec.linutronix.de>
References: <51C0AB09.2090605@redhat.com> <alpine.DEB.2.02.1306241551020.4013@ionos.tec.linutronix.de> <51CA2CBF.70404@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jun 2013, Prarit Bhargava wrote:
> On 06/24/2013 09:57 AM, Thomas Gleixner wrote:
> > On Tue, 18 Jun 2013, Prarit Bhargava wrote:
> > 
> >> Similar panics reported during bringup here:
> >>
> >> http://lists.infradead.org/pipermail/linux-arm-kernel/2013-May/166205.html
> >> http://lkml.org/lkml/2013/5/8/342
> >>
> >> I've seen this a few times on 3.10 based kernels.
> >>
> >> [  175.842027] Disabling non-boot CPUs ...
> >> [  475.827017] BUG: unable to handle kernel NULL pointer dereference at
> >> 0000000000000048
> > 
> > That looks like a stale bit in tick_broadcast_force_mask.
> > 
> > Does the patch below fix it?
> >
> 
> Thomas,
> 
> Thanks for the patch.
> 
> The reproducibility appears to be quite low.  I'm seeing this roughly 1 time
> every six hours of continuous system reboots.  I'm testing right now with your
> patch.  I'll update the thread in a couple of days...

I have a proper version of that patch now along with an explanation of
the failure.

-------------------->

Subject: tick: Make oneshot broadcast robust vs. CPU offlining
From: Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 26 Jun 2013 12:17:32 +0200

In periodic mode we remove offline cpus from the broadcast propagation
mask. In oneshot mode we fail to do so. This was not a problem so far,
but the recent changes to the broadcast propagation introduced a
constellation which can result in a NULL pointer dereference.

What happens is:

CPU0			CPU1
			idle()
			  arch_idle()
			    tick_broadcast_oneshot_control(OFF);
			      set cpu1 in tick_broadcast_force_mask
			  if (cpu_offline())
			     arch_cpu_dead()

cpu_dead_cleanup(cpu1)
 cpu1 tickdevice pointer = NULL

broadcast interrupt
  dereference cpu1 tickdevice pointer -> OOPS

We dereference the pointer because cpu1 is still set in
tick_broadcast_force_mask and tick_do_broadcast() expects a valid
cpumask and therefor lacks any further checks.

Remove the cpu from the tick_broadcast_force_mask before we set the
tick device pointer to NULL. Also add a sanity check to the oneshot
broadcast function, so we can detect such issues w/o crashing the
machine.

Reported-by: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/tick-broadcast.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

Index: tip/kernel/time/tick-broadcast.c
===================================================================
--- tip.orig/kernel/time/tick-broadcast.c
+++ tip/kernel/time/tick-broadcast.c
@@ -522,6 +522,13 @@ again:
 	cpumask_clear(tick_broadcast_force_mask);
 
 	/*
+	 * Sanity check. Catch the case where we try to broadcast to
+	 * offline cpus.
+	 */
+	if (WARN_ON_ONCE(!cpumask_subset(tmpmask, cpu_online_mask)))
+		cpumask_and(tmpmask, tmpmask, cpu_online_mask);
+
+	/*
 	 * Wakeup the cpus which have an expired event.
 	 */
 	tick_do_broadcast(tmpmask);
@@ -761,10 +768,12 @@ void tick_shutdown_broadcast_oneshot(uns
 	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
 
 	/*
-	 * Clear the broadcast mask flag for the dead cpu, but do not
-	 * stop the broadcast device!
+	 * Clear the broadcast masks for the dead cpu, but do not stop
+	 * the broadcast device!
 	 */
 	cpumask_clear_cpu(cpu, tick_broadcast_oneshot_mask);
+	cpumask_clear_cpu(cpu, tick_broadcast_pending_mask);
+	cpumask_clear_cpu(cpu, tick_broadcast_force_mask);
 
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
 }
