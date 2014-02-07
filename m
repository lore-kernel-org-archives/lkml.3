Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaBGOlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 09:41:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55972 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaBGOlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 09:41:18 -0500
Date: Fri, 7 Feb 2014 06:41:03 -0800
From: tip-bot for Preeti U Murthy <tipbot@zytor.com>
Message-ID: <tip-ba8f20c2eb4158a443e9d6a909aee5010efa0c69@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        preeti@linux.vnet.ibm.com, rafael.j.wysocki@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, tglx@linutronix.de,
        rafael.j.wysocki@intel.com
In-Reply-To: <20140207080652.17187.66344.stgit@preeti.in.ibm.com>
References: <20140207080652.17187.66344.stgit@preeti.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] cpuidle: Handle clockevents_notify(
 BROADCAST_ENTER) failure
Git-Commit-ID: ba8f20c2eb4158a443e9d6a909aee5010efa0c69
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 07 Feb 2014 06:41:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba8f20c2eb4158a443e9d6a909aee5010efa0c69
Gitweb:     http://git.kernel.org/tip/ba8f20c2eb4158a443e9d6a909aee5010efa0c69
Author:     Preeti U Murthy <preeti@linux.vnet.ibm.com>
AuthorDate: Fri, 7 Feb 2014 13:36:52 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 7 Feb 2014 15:34:29 +0100

cpuidle: Handle clockevents_notify(BROADCAST_ENTER) failure

Some archs set the CPUIDLE_FLAG_TIMER_STOP flag for idle states in which the
local timers stop. The cpuidle_idle_call() currently handles such idle states
by calling into the broadcast framework so as to wakeup CPUs at their next
wakeup event. With the hrtimer mode of broadcast, the BROADCAST_ENTER call
into the broadcast frameowork can fail for archs that do not have an external
clock device to handle wakeups and the CPU in question has thus to be made
the stand by CPU. This patch handles such cases by failing the call into
cpuidle so that the arch can take some default action. The arch will certainly
not enter a similar idle state because a failed cpuidle call will also implicitly
indicate that the broadcast framework has not registered this CPU to be woken up.
Hence we are safe if we fail the cpuidle call.

In the process move the functions that trace idle statistics just before and
after the entry and exit into idle states respectively. In other
scenarios where the call to cpuidle fails, we end up not tracing idle
entry and exit since a decision on an idle state could not be taken. Similarly
when the call to broadcast framework fails, we skip tracing idle statistics
because we are in no further position to take a decision on an alternative
idle state to enter into.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: deepthi@linux.vnet.ibm.com
Cc: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com
Cc: paulus@samba.org
Cc: srivatsa.bhat@linux.vnet.ibm.com
Cc: svaidy@linux.vnet.ibm.com
Cc: peterz@infradead.org
Cc: benh@kernel.crashing.org
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: linuxppc-dev@lists.ozlabs.org
Link: http://lkml.kernel.org/r/20140207080652.17187.66344.stgit@preeti.in.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/cpuidle/cpuidle.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index a55e68f..09d05ab 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -140,12 +140,14 @@ int cpuidle_idle_call(void)
 		return 0;
 	}
 
-	trace_cpu_idle_rcuidle(next_state, dev->cpu);
-
 	broadcast = !!(drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP);
 
-	if (broadcast)
-		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu);
+	if (broadcast &&
+	    clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_ENTER, &dev->cpu))
+		return -EBUSY;
+
+
+	trace_cpu_idle_rcuidle(next_state, dev->cpu);
 
 	if (cpuidle_state_is_coupled(dev, drv, next_state))
 		entered_state = cpuidle_enter_state_coupled(dev, drv,
@@ -153,11 +155,11 @@ int cpuidle_idle_call(void)
 	else
 		entered_state = cpuidle_enter_state(dev, drv, next_state);
 
+	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
+
 	if (broadcast)
 		clockevents_notify(CLOCK_EVT_NOTIFY_BROADCAST_EXIT, &dev->cpu);
 
-	trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
-
 	/* give the governor an opportunity to reflect on the outcome */
 	if (cpuidle_curr_governor->reflect)
 		cpuidle_curr_governor->reflect(dev, entered_state);
