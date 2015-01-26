Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbbAZN7C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:59:02 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59612 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753887AbbAZN67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:58:59 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v3]PM/Sleep: Timer quiesce in freeze state
Date: Mon, 26 Jan 2015 15:21:42 +0100
Message-ID: <7916564.nnH80uMtkt@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.DEB.2.11.1501260946390.5526@nanos>
References: <54866625.8010406@linux.intel.com> <54C5FE6A.9010300@linux.intel.com> <alpine.DEB.2.11.1501260946390.5526@nanos>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 26, 2015 10:40:24 AM Thomas Gleixner wrote:
> On Mon, 26 Jan 2015, Li, Aubrey wrote:
> > On 2015/1/22 18:15, Thomas Gleixner wrote:
> > > Can we please stop adding more crap to that notifier thing? I rather
> > > see that go away than being expanded.
> > 
> > Are you referring to FREEZE_PREPARE or remove all of FREEZE staff at all?
> > 
> > What's the disadvantage of adding more notifier?
> 
> clockevents_notify() is not a notifier. Its a multiplex call and I
> want to get rid of it and replace it with explicit functions.

OK, so perhaps we need to move _SUSPEND/_RESUME out of there to start with?

As far as I can say, clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL) and
clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL) are each only called from
one place and moreover, since they are in syscore_ops, we don't need any
locking around them.

So what about the patch below?


---
 include/linux/clockchips.h |    2 --
 kernel/time/clockevents.c  |    9 ---------
 kernel/time/timekeeping.c  |    6 ++++--
 3 files changed, 4 insertions(+), 13 deletions(-)

Index: linux-pm/include/linux/clockchips.h
===================================================================
--- linux-pm.orig/include/linux/clockchips.h
+++ linux-pm/include/linux/clockchips.h
@@ -16,8 +16,6 @@ enum clock_event_nofitiers {
 	CLOCK_EVT_NOTIFY_BROADCAST_FORCE,
 	CLOCK_EVT_NOTIFY_BROADCAST_ENTER,
 	CLOCK_EVT_NOTIFY_BROADCAST_EXIT,
-	CLOCK_EVT_NOTIFY_SUSPEND,
-	CLOCK_EVT_NOTIFY_RESUME,
 	CLOCK_EVT_NOTIFY_CPU_DYING,
 	CLOCK_EVT_NOTIFY_CPU_DEAD,
 };
Index: linux-pm/kernel/time/clockevents.c
===================================================================
--- linux-pm.orig/kernel/time/clockevents.c
+++ linux-pm/kernel/time/clockevents.c
@@ -570,15 +570,6 @@ int clockevents_notify(unsigned long rea
 		tick_handover_do_timer(arg);
 		break;
 
-	case CLOCK_EVT_NOTIFY_SUSPEND:
-		tick_suspend();
-		tick_suspend_broadcast();
-		break;
-
-	case CLOCK_EVT_NOTIFY_RESUME:
-		tick_resume();
-		break;
-
 	case CLOCK_EVT_NOTIFY_CPU_DEAD:
 		tick_shutdown_broadcast_oneshot(arg);
 		tick_shutdown_broadcast(arg);
Index: linux-pm/kernel/time/timekeeping.c
===================================================================
--- linux-pm.orig/kernel/time/timekeeping.c
+++ linux-pm/kernel/time/timekeeping.c
@@ -1245,7 +1245,7 @@ static void timekeeping_resume(void)
 
 	touch_softlockup_watchdog();
 
-	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
+	tick_resume();
 
 	/* Resume hrtimers */
 	hrtimers_resume();
@@ -1299,7 +1299,9 @@ static int timekeeping_suspend(void)
 	write_seqcount_end(&tk_core.seq);
 	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
 
-	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
+	tick_suspend();
+	tick_suspend_broadcast();
+
 	clocksource_suspend();
 	clockevents_suspend();
 

