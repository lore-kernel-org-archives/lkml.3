Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966563AbaCUAYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:24:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966041AbaCUAJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:09:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Prarit Bhargava <prarit@redhat.com>, athorlton@sgi.com,
        CAI Qian <caiqian@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: [PATCH 3.10 79/85] tick: Make oneshot broadcast robust vs. CPU offlining
Date: Thu, 20 Mar 2014 17:10:22 -0700
Message-Id: <20140321000610.050155107@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit c9b5a266b103af873abb9ac03bc3d067702c8f4b upstream.

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
Cc: athorlton@sgi.com
Cc: CAI Qian <caiqian@redhat.com>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1306261303260.4013@ionos.tec.linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/tick-broadcast.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -594,6 +594,13 @@ again:
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
@@ -834,10 +841,12 @@ void tick_shutdown_broadcast_oneshot(uns
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


