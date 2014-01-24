Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbaAXHBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 02:01:47 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:58563 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaAXHBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 02:01:45 -0500
Subject: [PATCH V2 1/2] time: Change the return type of clockevents_notify()
 to integer
To: daniel.lezcano@linaro.org, peterz@infradead.org, fweisbec@gmail.com,
        galak@kernel.crashing.org, paul.gortmaker@windriver.com,
        paulus@samba.org, mingo@kernel.org, mikey@neuling.org,
        shangw@linux.vnet.ibm.com, rafael.j.wysocki@intel.com, agraf@suse.de,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, michael@ellerman.id.au,
        john.stultz@linaro.org, anton@samba.org, tglx@linutronix.de,
        chenhui.zhao@freescale.com, deepthi@linux.vnet.ibm.com,
        r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Fri, 24 Jan 2014 12:27:39 +0530
Message-ID: <20140124065739.17564.97259.stgit@preeti.in.ibm.com>
In-Reply-To: <20140124065501.17564.39363.stgit@preeti.in.ibm.com>
References: <20140124065501.17564.39363.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012407-8236-0000-0000-000006607D24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The broadcast framework can potentially be made use of by archs which do not have an
external clock device as well. Then, it is required that one of the CPUs need
to handle the broadcasting of wakeup IPIs to the CPUs in deep idle. As a
result its local timers should remain functional all the time. For such
a CPU, the BROADCAST_ENTER notification has to fail indicating that its clock
device cannot be shutdown. To make way for this support, change the return
type of tick_broadcast_oneshot_control() and hence clockevents_notify() to
indicate such scenarios.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 include/linux/clockchips.h   |    6 +++---
 kernel/time/clockevents.c    |    8 +++++---
 kernel/time/tick-broadcast.c |    6 ++++--
 kernel/time/tick-internal.h  |    6 +++---
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 493aa02..ac81b56 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -186,9 +186,9 @@ static inline int tick_check_broadcast_expired(void) { return 0; }
 #endif
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
-extern void clockevents_notify(unsigned long reason, void *arg);
+extern int clockevents_notify(unsigned long reason, void *arg);
 #else
-static inline void clockevents_notify(unsigned long reason, void *arg) {}
+static inline int clockevents_notify(unsigned long reason, void *arg) {}
 #endif
 
 #else /* CONFIG_GENERIC_CLOCKEVENTS_BUILD */
@@ -196,7 +196,7 @@ static inline void clockevents_notify(unsigned long reason, void *arg) {}
 static inline void clockevents_suspend(void) {}
 static inline void clockevents_resume(void) {}
 
-static inline void clockevents_notify(unsigned long reason, void *arg) {}
+static inline int clockevents_notify(unsigned long reason, void *arg) {}
 static inline int tick_check_broadcast_expired(void) { return 0; }
 
 #endif
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index 086ad60..79b8685 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -524,12 +524,13 @@ void clockevents_resume(void)
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 /**
  * clockevents_notify - notification about relevant events
+ * Returns 0 on success, any other value on error
  */
-void clockevents_notify(unsigned long reason, void *arg)
+int clockevents_notify(unsigned long reason, void *arg)
 {
 	struct clock_event_device *dev, *tmp;
 	unsigned long flags;
-	int cpu;
+	int cpu, ret = 0;
 
 	raw_spin_lock_irqsave(&clockevents_lock, flags);
 
@@ -542,7 +543,7 @@ void clockevents_notify(unsigned long reason, void *arg)
 
 	case CLOCK_EVT_NOTIFY_BROADCAST_ENTER:
 	case CLOCK_EVT_NOTIFY_BROADCAST_EXIT:
-		tick_broadcast_oneshot_control(reason);
+		ret = tick_broadcast_oneshot_control(reason);
 		break;
 
 	case CLOCK_EVT_NOTIFY_CPU_DYING:
@@ -585,6 +586,7 @@ void clockevents_notify(unsigned long reason, void *arg)
 		break;
 	}
 	raw_spin_unlock_irqrestore(&clockevents_lock, flags);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(clockevents_notify);
 
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 9532690..be00692 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -633,14 +633,15 @@ again:
 /*
  * Powerstate information: The system enters/leaves a state, where
  * affected devices might stop
+ * Returns 0 on success, -EBUSY if the cpu is used to broadcast wakeups.
  */
-void tick_broadcast_oneshot_control(unsigned long reason)
+int tick_broadcast_oneshot_control(unsigned long reason)
 {
 	struct clock_event_device *bc, *dev;
 	struct tick_device *td;
 	unsigned long flags;
 	ktime_t now;
-	int cpu;
+	int cpu, ret = 0;
 
 	/*
 	 * Periodic mode does not care about the enter/exit of power
@@ -746,6 +747,7 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 	}
 out:
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
+	return ret;
 }
 
 /*
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 18e71f7..164465c 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -46,7 +46,7 @@ extern int tick_switch_to_oneshot(void (*handler)(struct clock_event_device *));
 extern void tick_resume_oneshot(void);
 # ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 extern void tick_broadcast_setup_oneshot(struct clock_event_device *bc);
-extern void tick_broadcast_oneshot_control(unsigned long reason);
+extern int tick_broadcast_oneshot_control(unsigned long reason);
 extern void tick_broadcast_switch_to_oneshot(void);
 extern void tick_shutdown_broadcast_oneshot(unsigned int *cpup);
 extern int tick_resume_broadcast_oneshot(struct clock_event_device *bc);
@@ -58,7 +58,7 @@ static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
 	BUG();
 }
-static inline void tick_broadcast_oneshot_control(unsigned long reason) { }
+static inline int tick_broadcast_oneshot_control(unsigned long reason) { }
 static inline void tick_broadcast_switch_to_oneshot(void) { }
 static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
 static inline int tick_broadcast_oneshot_active(void) { return 0; }
@@ -87,7 +87,7 @@ static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
 	BUG();
 }
-static inline void tick_broadcast_oneshot_control(unsigned long reason) { }
+static inline int tick_broadcast_oneshot_control(unsigned long reason) { }
 static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
 static inline int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 {

