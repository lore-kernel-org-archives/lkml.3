Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbaHUFp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 01:45:56 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:28105 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750791AbaHUFpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 01:45:55 -0400
X-IronPort-AV: E=Sophos;i="5.04,370,1406563200"; 
   d="scan'208";a="34880054"
From: chai wen <chaiw.fnst@cn.fujitsu.com>
CC: <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        chai wen <chaiw.fnst@cn.fujitsu.com>, Don Zickus <dzickus@redhat.com>
Subject: [PATCH] softlockup: make detector be aware of task switch of processes hogging cpu
Date: Thu, 21 Aug 2014 13:42:22 +0800
Message-ID: <1408599742-21674-1-git-send-email-chaiw.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20140821023051.GO49576@redhat.com>
References: <20140821023051.GO49576@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.161]
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
index 0037db6..2e55620 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -42,6 +42,7 @@ static DEFINE_PER_CPU(bool, softlockup_touch_sync);
 static DEFINE_PER_CPU(bool, soft_watchdog_warn);
 static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
 static DEFINE_PER_CPU(unsigned long, soft_lockup_hrtimer_cnt);
+static DEFINE_PER_CPU(struct task_struct *, softlockup_task_ptr_saved);
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 static DEFINE_PER_CPU(bool, hard_watchdog_warn);
 static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
@@ -328,8 +329,20 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
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
@@ -345,6 +358,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 		pr_emerg("BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
 			smp_processor_id(), duration,
 			current->comm, task_pid_nr(current));
+		__this_cpu_write(softlockup_task_ptr_saved, current);
 		print_modules();
 		print_irqtrace_events(current);
 		if (regs)
-- 
1.7.1

