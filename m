Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab3JHBGu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 21:06:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab3JHBGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 21:06:19 -0400
Message-Id: <20131008010552.713337492@amt.cnet>
User-Agent: quilt/0.60-1
Date: Mon, 07 Oct 2013 22:05:16 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: kvm@vger.kernel.org
Cc: dzickus@redhat.com, pbonzini@redhat.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [patch 1/3] hung_task: add method to reset detector
References: <20131008010515.516032211@amt.cnet>
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
 
Index: kvm/include/linux/hung_task.h
===================================================================
--- /dev/null
+++ kvm/include/linux/hung_task.h
@@ -0,0 +1,15 @@
+/*
+ *  linux/include/linux/hung_task.h
+ */
+#ifndef LINUX_HUNG_TASK_H
+#define LINUX_HUNG_TASK_H
+
+#ifdef CONFIG_DETECT_HUNG_TASK
+void reset_hung_task_detector(void);
+#else
+static inline void reset_hung_task_detector(void)
+{
+}
+#endif
+
+#endif


