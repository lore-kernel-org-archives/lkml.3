Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbbASK1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 05:27:09 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33956 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbbASK1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 05:27:07 -0500
Subject: [PATCH] tick/broadcast: Make movement of broadcast hrtimer robust
 against hotplug
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
To: tglx@linutronix.de
Cc: aik@ozlabs.ru, shreyas@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        michael@ellerman.id.au, anton@samba.org, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Date: Mon, 19 Jan 2015 15:56:48 +0530
Message-ID: <20150119102647.23035.13380.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011910-0037-0000-0000-00000063C225
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today if a cpu handling broadcasting of wakeups goes offline, it hands over
the job of broadcasting to another cpu in the CPU_DEAD phase. The CPU_DEAD
notifiers are run only after the offline cpu sets its state as CPU_DEAD.
Meanwhile, the kthread doing the offline is scheduled out while waiting for
this transition by queuing a timer. This is fatal because if the cpu on which
this kthread was running has no other work queued on it, it can re-enter deep
idle state, since it sees that a broadcast cpu still exists. However the broadcast
wakeup will never come since the cpu which was handling it is offline, and this cpu
never wakes up to see this because its in deep idle state.

Fix this by setting the broadcast timer to a max value so as to force the cpus
entering deep idle states henceforth to freshly nominate the broadcast cpu. More
importantly this has to be done in the CPU_DYING phase so that it is visible to
all cpus right after exiting stop_machine, which is when they can re-enter idle.
This ensures that handover of the broadcast duty falls in place on offline, without
having to do it explicitly.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 kernel/time/clockevents.c    |    2 +-
 kernel/time/tick-broadcast.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

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
index 066f0ec..e9c1d9b 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -675,8 +675,8 @@ static void broadcast_move_bc(int deadcpu)
 
 	if (!bc || !broadcast_needs_cpu(bc, deadcpu))
 		return;
-	/* This moves the broadcast assignment to this cpu */
-	clockevents_program_event(bc, bc->next_event, 1);
+	/* This allows fresh nomination of broadcast cpu */
+	bc->next_event.tv64 = KTIME_MAX;
 }
 
 /*

