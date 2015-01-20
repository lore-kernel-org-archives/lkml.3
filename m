Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbbATKgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:36:49 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:33705 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbbATKgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:36:45 -0500
Subject: [PATCH V3] tick/broadcast: Make movement of broadcast hrtimer
 robust against hotplug
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
To: tglx@linutronix.de
Cc: aik@ozlabs.ru, shreyas@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        michael@ellerman.id.au, anton@samba.org, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Date: Tue, 20 Jan 2015 16:06:30 +0530
Message-ID: <20150120103559.8430.50933.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012010-0005-0000-0000-0000082AE049
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today if the cpu handling broadcasting of wakeups goes offline, the job of
broadcasting is handed over to another cpu in the CPU_DEAD phase. The CPU_DEAD
notifiers are run only after the offline cpu sets its state as CPU_DEAD.
Meanwhile, the kthread doing the offline is scheduled out while waiting for
this transition by queuing a timer. This is fatal because if the cpu on which
this kthread was running has no other work queued on it, it can re-enter deep
idle state, since it sees that a broadcast cpu still exists. However the broadcast
wakeup will never come since the cpu which was handling it is offline, and the cpu
on which the kthread doing the hotplug operation was running never wakes up to see
this because its in deep idle state.

Fix this by setting the broadcast timer to a max value so as to force the cpus
entering deep idle states henceforth to freshly nominate the broadcast cpu. More
importantly this has to be done in the CPU_DYING phase so that it is visible to
all cpus right after exiting stop_machine, which is when they can re-enter idle.
This ensures that handover of the broadcast duty falls in place on offline of the
broadcast cpu, without having to do it explicitly.

It fixes the bug reported here:
http://linuxppc.10917.n7.nabble.com/offlining-cpus-breakage-td88619.html

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
Changes from previous versions:
1. Modification to the changelog
2. Clarified the comments

 kernel/time/clockevents.c    |    2 +-
 kernel/time/tick-broadcast.c |    7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 5544990..f3907c9 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -568,6 +568,7 @@ int clockevents_notify(unsigned long reason, void *arg)
 
 	case CLOCK_EVT_NOTIFY_CPU_DYING:
 		tick_handover_do_timer(arg);
+		tick_shutdown_broadcast_oneshot(arg);
 		break;
 
 	case CLOCK_EVT_NOTIFY_SUSPEND:
@@ -580,7 +581,6 @@ int clockevents_notify(unsigned long reason, void *arg)
 		break;
 
 	case CLOCK_EVT_NOTIFY_CPU_DEAD:
-		tick_shutdown_broadcast_oneshot(arg);
 		tick_shutdown_broadcast(arg);
 		tick_shutdown(arg);
 		/*
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 066f0ec..f983983 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -675,8 +675,11 @@ static void broadcast_move_bc(int deadcpu)
 
 	if (!bc || !broadcast_needs_cpu(bc, deadcpu))
 		return;
-	/* This moves the broadcast assignment to this cpu */
-	clockevents_program_event(bc, bc->next_event, 1);
+	/* Since a cpu with the earliest wakeup is nominated as the 
+	 * standby cpu, the next cpu to invoke BROADCAST_ENTER
+	 * will now automatically take up the duty of broadcasting.
+	 */
+	bc->next_event.tv64 = KTIME_MAX;
 }
 
 /*

