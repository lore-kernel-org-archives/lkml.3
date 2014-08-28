Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934203AbaH1Eww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 00:52:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932421AbaH1Ewv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 00:52:51 -0400
From: Don Zickus <dzickus@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        chai wen <chaiw.fnst@cn.fujitsu.com>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH] softlockup: Make detector be aware of task switch of processes hogging cpu
Date: Thu, 28 Aug 2014 00:52:24 -0400
Message-Id: <1409201544-82371-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chai wen <chaiw.fnst@cn.fujitsu.com>

For now, soft lockup detector warns once for each case of process softlockup.
But the thread 'watchdog/n' may not always get the cpu at the time slot between
the task switch of two processes hogging that cpu to reset soft_watchdog_warn.

An example would be two processes hogging the cpu.  Process A causes the
softlockup warning and is killed manually by a user.  Process B immediately
becomes the new process hogging the cpu preventing the softlockup code from
resetting the soft_watchdog_warn variable.

This case is a false negative of "warn only once for a process", as there may
be a different process that is going to hog the cpu.  Resolve this by
saving/checking the task pointer of the hogging process and use that to reset
soft_watchdog_warn too.

Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index c3319bd..499f65f 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -47,6 +47,7 @@ static DEFINE_PER_CPU(bool, softlockup_touch_sync);
 static DEFINE_PER_CPU(bool, soft_watchdog_warn);
 static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
 static DEFINE_PER_CPU(unsigned long, soft_lockup_hrtimer_cnt);
+static DEFINE_PER_CPU(struct task_struct *, softlockup_task_ptr_saved);
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 static DEFINE_PER_CPU(bool, hard_watchdog_warn);
 static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
@@ -331,8 +332,20 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 			return HRTIMER_RESTART;
 
 		/* only warn once */
-		if (__this_cpu_read(soft_watchdog_warn) == true)
+		if (__this_cpu_read(soft_watchdog_warn) == true) {
+			/*
+			 * Handle the case where multiple processes are
+			 * causing softlockups but the duration is small
+			 * enough, the softlockup detector can not reset
+			 * itself in time.  Use task pointers to detect this.
+			 */
+			if (__this_cpu_read(softlockup_task_ptr_saved) !=
+			    current) {
+				__this_cpu_write(soft_watchdog_warn, false);
+				__touch_watchdog();
+			}
 			return HRTIMER_RESTART;
+		}
 
 		if (softlockup_all_cpu_backtrace) {
 			/* Prevent multiple soft-lockup reports if one cpu is already
@@ -348,6 +361,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 		printk(KERN_EMERG "BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
 			smp_processor_id(), duration,
 			current->comm, task_pid_nr(current));
+		__this_cpu_write(softlockup_task_ptr_saved, current);
 		print_modules();
 		print_irqtrace_events(current);
 		if (regs)
-- 
1.7.1

