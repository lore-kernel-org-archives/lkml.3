Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab3JLAoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 20:44:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509Ab3JLAnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 20:43:49 -0400
Message-Id: <20131012004217.058840904@amt.cnet>
User-Agent: quilt/0.60-1
Date: Fri, 11 Oct 2013 21:39:26 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: kvm@vger.kernel.org
Cc: dzickus@redhat.com, pbonzini@redhat.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 2/2] hung_task: add method to reset detector
References: <20131012003924.092908362@amt.cnet>
Content-Disposition: inline; filename=01-hung-task-watchdog-reset
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In certain occasions it is possible for a hung task detector
positive to be false: continuation from a paused VM, for example.

Add a method to reset detection, similar as is done
with other kernel watchdogs.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Index: kvm/kernel/hung_task.c
===================================================================
--- kvm.orig/kernel/hung_task.c
+++ kvm/kernel/hung_task.c
@@ -203,6 +203,14 @@ int proc_dohung_task_timeout_secs(struct
 	return ret;
 }
 
+static atomic_t reset_hung_task = ATOMIC_INIT(0);
+
+void reset_hung_task_detector(void)
+{
+	atomic_set(&reset_hung_task, 1);
+}
+EXPORT_SYMBOL_GPL(reset_hung_task_detector);
+
 /*
  * kthread which checks for tasks stuck in D state
  */
@@ -216,6 +224,9 @@ static int watchdog(void *dummy)
 		while (schedule_timeout_interruptible(timeout_jiffies(timeout)))
 			timeout = sysctl_hung_task_timeout_secs;
 
+		if (atomic_xchg(&reset_hung_task, 0))
+			continue;
+
 		check_hung_uninterruptible_tasks(timeout);
 	}
 
Index: kvm/include/linux/sched.h
===================================================================
--- kvm.orig/include/linux/sched.h
+++ kvm/include/linux/sched.h
@@ -285,6 +285,14 @@ static inline void lockup_detector_init(
 }
 #endif
 
+#ifdef CONFIG_DETECT_HUNG_TASK
+void reset_hung_task_detector(void);
+#else
+static inline void reset_hung_task_detector(void)
+{
+}
+#endif
+
 /* Attach to any functions which should be ignored in wchan output. */
 #define __sched		__attribute__((__section__(".sched.text")))
 
Index: kvm/arch/x86/kernel/pvclock.c
===================================================================
--- kvm.orig/arch/x86/kernel/pvclock.c
+++ kvm/arch/x86/kernel/pvclock.c
@@ -48,6 +48,7 @@ void pvclock_touch_watchdogs(void)
 	touch_softlockup_watchdog_sync();
 	clocksource_touch_watchdog();
 	rcu_cpu_stall_reset();
+	reset_hung_task_detector();
 }
 
 static atomic64_t last_value = ATOMIC64_INIT(0);


