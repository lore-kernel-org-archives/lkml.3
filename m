Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbaHEXKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 19:10:21 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52327 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753796AbaHEXKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 19:10:20 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: [Update][PATCH 1/5] PM / sleep: Mechanism for aborting system suspends unconditionally
Date: Wed, 06 Aug 2014 01:29 +0200
Message-ID: <1909932.TyJLycJLk5@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2110414.zVMoE3FRqa@vostro.rjw.lan>
References: <20140724212620.GO3935@laptop> <3321219.itH23ZEDt4@vostro.rjw.lan> <2110414.zVMoE3FRqa@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: PM / sleep: Mechanism for aborting system suspends unconditionally

It sometimes may be necessary to abort a system suspend in
progress or wake up the system from suspend-to-idle even if the
pm_wakeup_event()/pm_stay_awake() mechanism is not enabled.

For this purpose, introduce a new global variable abort_suspend and
make pm_wakeup_pending() check its value.  Also add routines for
manipulating that variable.

This is going to be used in subsequent changes.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

The empty stub pm_wakeup_clear() for CONFIG_PM_SLEEP unset was missing.

Rafael

---
 drivers/base/power/wakeup.c |   20 ++++++++++++++++++++
 include/linux/suspend.h     |    4 ++++
 kernel/power/process.c      |    1 +
 3 files changed, 25 insertions(+)

Index: linux-pm/include/linux/suspend.h
===================================================================
--- linux-pm.orig/include/linux/suspend.h
+++ linux-pm/include/linux/suspend.h
@@ -371,6 +371,8 @@ extern int unregister_pm_notifier(struct
 extern bool events_check_enabled;
 
 extern bool pm_wakeup_pending(void);
+extern void pm_system_wakeup(void);
+extern void pm_wakeup_clear(void);
 extern bool pm_get_wakeup_count(unsigned int *count, bool block);
 extern bool pm_save_wakeup_count(unsigned int count);
 extern void pm_wakep_autosleep_enabled(bool set);
@@ -418,6 +420,8 @@ static inline int unregister_pm_notifier
 #define pm_notifier(fn, pri)	do { (void)(fn); } while (0)
 
 static inline bool pm_wakeup_pending(void) { return false; }
+static inline void pm_system_wakeup(void) {}
+static inline void pm_wakeup_clear(void) {}
 
 static inline void lock_system_sleep(void) {}
 static inline void unlock_system_sleep(void) {}
Index: linux-pm/drivers/base/power/wakeup.c
===================================================================
--- linux-pm.orig/drivers/base/power/wakeup.c
+++ linux-pm/drivers/base/power/wakeup.c
@@ -691,6 +691,8 @@ void pm_print_active_wakeup_sources(void
 }
 EXPORT_SYMBOL_GPL(pm_print_active_wakeup_sources);
 
+static bool abort_suspend;
+
 /**
  * pm_wakeup_pending - Check if power transition in progress should be aborted.
  *
@@ -712,6 +714,7 @@ bool pm_wakeup_pending(void)
 		ret = (cnt != saved_count || inpr > 0);
 		events_check_enabled = !ret;
 	}
+	ret = ret || abort_suspend;
 	spin_unlock_irqrestore(&events_lock, flags);
 
 	if (ret) {
@@ -722,6 +725,23 @@ bool pm_wakeup_pending(void)
 	return ret;
 }
 
+void pm_system_wakeup(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&events_lock, flags);
+	abort_suspend = true;
+	spin_unlock_irqrestore(&events_lock, flags);
+	freeze_wake();
+}
+
+void pm_wakeup_clear(void)
+{
+	spin_lock_irq(&events_lock);
+	abort_suspend = false;
+	spin_unlock_irq(&events_lock);
+}
+
 /**
  * pm_get_wakeup_count - Read the number of registered wakeup events.
  * @count: Address to store the value at.
Index: linux-pm/kernel/power/process.c
===================================================================
--- linux-pm.orig/kernel/power/process.c
+++ linux-pm/kernel/power/process.c
@@ -129,6 +129,7 @@ int freeze_processes(void)
 	if (!pm_freezing)
 		atomic_inc(&system_freezing_cnt);
 
+	pm_wakeup_clear();
 	printk("Freezing user space processes ... ");
 	pm_freezing = true;
 	error = try_to_freeze_tasks(true);

