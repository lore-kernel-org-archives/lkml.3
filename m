Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbaBFQDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:03:49 -0500
Received: from www.linutronix.de ([62.245.132.108]:35810 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412AbaBFQDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:03:47 -0500
Date: Thu, 6 Feb 2014 17:03:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
cc: rafael.j.wysocki@intel.com, linux-pm@vger.kernel.org, peterz@infradead.org,
        fweisbec@gmail.com, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org, paulus@samba.org,
        benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        mingo@kernel.org, deepthi@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, svaidy@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com
Subject: Re: [PATCH V3 2/3] tick/cpuidle: Initialize hrtimer mode of
 broadcast
In-Reply-To: <20140206055012.4595.55692.stgit@preeti>
Message-ID: <alpine.DEB.2.02.1402061655560.21991@ionos.tec.linutronix.de>
References: <20140206054158.4595.17827.stgit@preeti> <20140206055012.4595.55692.stgit@preeti>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-695086802-1391702627=:21991"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-695086802-1391702627=:21991
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 6 Feb 2014, Preeti U Murthy wrote:

Compiler warnings are not so important, right?

kernel/time/tick-broadcast.c: In function ‘tick_broadcast_oneshot_control’:
kernel/time/tick-broadcast.c:700:3: warning: ‘return’ with no value, in function returning non-void [-Wreturn-type]
kernel/time/tick-broadcast.c:711:3: warning: ‘return’ with no value, in function returning non-void [-Wreturn-type]

> +		/*
> +		 * If the current CPU owns the hrtimer broadcast
> +		 * mechanism, it cannot go deep idle.
> +		 */
> +		ret = broadcast_needs_cpu(bc, cpu);

So we leave the CPU in the broadcast mask, just to force another call
to the notify code right away to remove it again. Wouldn't it be more
clever to clear the flag right away? That would make the changes to
the cpuidle code simpler. Delta patch below.

Thanks,

	tglx
---

--- tip.orig/kernel/time/tick-broadcast.c
+++ tip/kernel/time/tick-broadcast.c
@@ -697,7 +697,7 @@ int tick_broadcast_oneshot_control(unsig
 	 * states
 	 */
 	if (tick_broadcast_device.mode == TICKDEV_MODE_PERIODIC)
-		return;
+		return 0;
 
 	/*
 	 * We are called with preemtion disabled from the depth of the
@@ -708,7 +708,7 @@ int tick_broadcast_oneshot_control(unsig
 	dev = td->evtdev;
 
 	if (!(dev->features & CLOCK_EVT_FEAT_C3STOP))
-		return;
+		return 0;
 
 	bc = tick_broadcast_device.evtdev;
 
@@ -731,9 +731,14 @@ int tick_broadcast_oneshot_control(unsig
 		}
 		/*
 		 * If the current CPU owns the hrtimer broadcast
-		 * mechanism, it cannot go deep idle.
+		 * mechanism, it cannot go deep idle and we remove the
+		 * CPU from the broadcast mask. We don't have to go
+		 * through the EXIT path as the local timer is not
+		 * shutdown.
 		 */
 		ret = broadcast_needs_cpu(bc, cpu);
+		if (ret)
+			cpumask_clear_cpu(cpu, tick_broadcast_oneshot_mask);
 	} else {
 		if (cpumask_test_and_clear_cpu(cpu, tick_broadcast_oneshot_mask)) {
 			clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
--8323329-695086802-1391702627=:21991--
