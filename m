Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbaBGOlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 09:41:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55962 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaBGOlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 09:41:06 -0500
Date: Fri, 7 Feb 2014 06:40:51 -0800
From: tip-bot for Preeti U Murthy <tipbot@zytor.com>
Message-ID: <tip-da7e6f45c34d39186b72328bacc4dd86bff60e0a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        preeti@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <20140207080606.17187.78306.stgit@preeti.in.ibm.com>
References: <20140207080606.17187.78306.stgit@preeti.in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] time:
  Change the return type of clockevents_notify() to integer
Git-Commit-ID: da7e6f45c34d39186b72328bacc4dd86bff60e0a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 07 Feb 2014 06:40:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da7e6f45c34d39186b72328bacc4dd86bff60e0a
Gitweb:     http://git.kernel.org/tip/da7e6f45c34d39186b72328bacc4dd86bff60e0a
Author:     Preeti U Murthy <preeti@linux.vnet.ibm.com>
AuthorDate: Fri, 7 Feb 2014 13:36:06 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 7 Feb 2014 15:34:29 +0100

time: Change the return type of clockevents_notify() to integer

The broadcast framework can potentially be made use of by archs which do not have an
external clock device as well. Then, it is required that one of the CPUs need
to handle the broadcasting of wakeup IPIs to the CPUs in deep idle. As a
result its local timers should remain functional all the time. For such
a CPU, the BROADCAST_ENTER notification has to fail indicating that its clock
device cannot be shutdown. To make way for this support, change the return
type of tick_broadcast_oneshot_control() and hence clockevents_notify() to
indicate such scenarios.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: deepthi@linux.vnet.ibm.com
Cc: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com
Cc: paulus@samba.org
Cc: srivatsa.bhat@linux.vnet.ibm.com
Cc: svaidy@linux.vnet.ibm.com
Cc: peterz@infradead.org
Cc: benh@kernel.crashing.org
Cc: rafael.j.wysocki@intel.com
Cc: linuxppc-dev@lists.ozlabs.org
Link: http://lkml.kernel.org/r/20140207080606.17187.78306.stgit@preeti.in.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/clockchips.h   | 6 +++---
 kernel/time/clockevents.c    | 8 +++++---
 kernel/time/tick-broadcast.c | 6 ++++--
 kernel/time/tick-internal.h  | 6 +++---
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 493aa02..e0c5a6c 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -186,9 +186,9 @@ static inline int tick_check_broadcast_expired(void) { return 0; }
 #endif
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
-extern void clockevents_notify(unsigned long reason, void *arg);
+extern int clockevents_notify(unsigned long reason, void *arg);
 #else
-static inline void clockevents_notify(unsigned long reason, void *arg) {}
+static inline int clockevents_notify(unsigned long reason, void *arg) { return 0; }
 #endif
 
 #else /* CONFIG_GENERIC_CLOCKEVENTS_BUILD */
@@ -196,7 +196,7 @@ static inline void clockevents_notify(unsigned long reason, void *arg) {}
 static inline void clockevents_suspend(void) {}
 static inline void clockevents_resume(void) {}
 
-static inline void clockevents_notify(unsigned long reason, void *arg) {}
+static inline int clockevents_notify(unsigned long reason, void *arg) { return 0; }
 static inline int tick_check_broadcast_expired(void) { return 0; }
 
 #endif
diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index f85e5fd..ad362c2 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -542,12 +542,13 @@ void clockevents_resume(void)
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
 
@@ -560,7 +561,7 @@ void clockevents_notify(unsigned long reason, void *arg)
 
 	case CLOCK_EVT_NOTIFY_BROADCAST_ENTER:
 	case CLOCK_EVT_NOTIFY_BROADCAST_EXIT:
-		tick_broadcast_oneshot_control(reason);
+		ret = tick_broadcast_oneshot_control(reason);
 		break;
 
 	case CLOCK_EVT_NOTIFY_CPU_DYING:
@@ -603,6 +604,7 @@ void clockevents_notify(unsigned long reason, void *arg)
 		break;
 	}
 	raw_spin_unlock_irqrestore(&clockevents_lock, flags);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(clockevents_notify);
 
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 003e6c3..84c8fd9 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -646,14 +646,15 @@ again:
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
@@ -759,6 +760,7 @@ void tick_broadcast_oneshot_control(unsigned long reason)
 	}
 out:
 	raw_spin_unlock_irqrestore(&tick_broadcast_lock, flags);
+	return ret;
 }
 
 /*
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index 26f1c0b..0756c62 100644
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
+static inline int tick_broadcast_oneshot_control(unsigned long reason) { return 0; }
 static inline void tick_broadcast_switch_to_oneshot(void) { }
 static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
 static inline int tick_broadcast_oneshot_active(void) { return 0; }
@@ -87,7 +87,7 @@ static inline void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
 	BUG();
 }
-static inline void tick_broadcast_oneshot_control(unsigned long reason) { }
+static inline int tick_broadcast_oneshot_control(unsigned long reason) { return 0; }
 static inline void tick_shutdown_broadcast_oneshot(unsigned int *cpup) { }
 static inline int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 {
