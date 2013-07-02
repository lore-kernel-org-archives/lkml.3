Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab3GBMbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 08:31:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42280 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab3GBMbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 08:31:50 -0400
Date: Tue, 2 Jul 2013 05:31:23 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-c9b5a266b103af873abb9ac03bc3d067702c8f4b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        caiqian@redhat.com, tglx@linutronix.de, prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        caiqian@redhat.com, tglx@linutronix.de, prarit@redhat.com
In-Reply-To: <alpine.DEB.2.02.1306261303260.4013@ionos.tec.linutronix.de>
References: <alpine.DEB.2.02.1306261303260.4013@ionos.tec.linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] tick:
  Make oneshot broadcast robust vs. CPU offlining
Git-Commit-ID: c9b5a266b103af873abb9ac03bc3d067702c8f4b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Jul 2013 05:31:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c9b5a266b103af873abb9ac03bc3d067702c8f4b
Gitweb:     http://git.kernel.org/tip/c9b5a266b103af873abb9ac03bc3d067702c8f4b
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 26 Jun 2013 12:17:32 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 2 Jul 2013 14:26:44 +0200

tick: Make oneshot broadcast robust vs. CPU offlining

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
---
 kernel/time/tick-broadcast.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index d067c01..4790037 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -533,6 +533,13 @@ again:
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
@@ -773,10 +780,12 @@ void tick_shutdown_broadcast_oneshot(unsigned int *cpup)
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
