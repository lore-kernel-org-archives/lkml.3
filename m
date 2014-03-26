Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033AbaCZEAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 00:00:51 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:56322 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaCZEAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 00:00:49 -0400
Subject: [PATCH] tick,
 broadcast: Prevent false alarm when force mask contains offline cpus
To: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: linux-pm@vger.kernel.org, peterz@infradead.org, rjw@rjwysocki.net,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        davem@davemloft.net
Date: Wed, 26 Mar 2014 09:26:48 +0530
Message-ID: <20140326035648.21736.85740.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032604-1344-0000-0000-000000814D7A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Its possible that the tick_broadcast_force_mask contains cpus which are not
in cpu_online_mask when a broadcast tick occurs. This could happen under the
following circumstance assuming CPU1 is among the CPUs waiting for broadcast.

CPU0					CPU1

Run CPU_DOWN_PREPARE notifiers

Start stop_machine			Gets woken up by IPI to run
					stop_machine, sets itself in
					tick_broadcast_force_mask if the
					time of broadcast interrupt is around
					the same time as this IPI.

					Start stop_machine
					  set_cpu_online(cpu1, false)
End stop_machine			End stop_machine

Broadcast interrupt
  Finds that cpu1 in
  tick_broadcast_force_mask is offline
  and triggers the WARN_ON in
  tick_handle_oneshot_broadcast()

Clears all broadcast masks
in CPU_DEAD stage.

This WARN_ON was added to capture scenarios where the broadcast mask, be it
oneshot/pending/force_mask contain offline cpus whose tick devices have been
removed. But here is a case where we trigger the warn on in a valid scenario.

One could argue that the scenario is invalid and ought to be warned against
because ideally the broadcast masks need to be cleared of the cpus about to
go offine before clearing them in the online_mask so that we dont hit these
scenarios.

This would mean clearing the masks in CPU_DOWN_PREPARE stage. But
it is quite possible that this stage itself will fail and cpu hotplug will
not go through. We would then end up in a situation where the cpu has not gone
offline, and continues to wait for the broadcast interrupt like before.
  However it is cleared in the broadcast masks and this interrupt will never
be delivered. Hence clearing of masks is best kept off until we are sure that
the cpu is dead, i.e. in the CPU_DEAD stage.

Hence simply ensure that the tick_broadcast_force_mask is a subset of the
online cpus to take care of rare occurences such as above. Moreover this is
not a harmful scenario where the cpu is in the mask but its tick device was
shutdown. The WARN_ON will then continue to capture cases where we could
possibly cause a kernel crash.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 kernel/time/tick-broadcast.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 63c7b2d..30b8731 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -606,7 +606,12 @@ again:
 	 */
 	cpumask_clear_cpu(smp_processor_id(), tick_broadcast_pending_mask);
 
-	/* Take care of enforced broadcast requests */
+	/* Take care of enforced broadcast requests. We could have offline
+	 * cpus in the tick_broadcast_force_mask. Thats ok, we got the interrupt
+	 * before we could clear the mask.
+	 */
+	cpumask_and(tick_broadcast_force_mask,
+			tick_broadcast_force_mask, cpu_online_mask);
 	cpumask_or(tmpmask, tmpmask, tick_broadcast_force_mask);
 	cpumask_clear(tick_broadcast_force_mask);
 

