Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581AbaHDHje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 03:39:34 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:35343 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751204AbaHDHj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 03:39:26 -0400
X-IronPort-AV: E=Sophos;i="5.04,260,1406563200"; 
   d="scan'208";a="34137951"
From: chai wen <chaiw.fnst@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: <dzickus@redhat.com>, <mingo@redhat.com>,
        chai wen <chaiw.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] softlockup: make detector be aware of task switch of processes hogging cpu
Date: Mon, 4 Aug 2014 15:36:19 +0800
Message-ID: <1407137779-19129-2-git-send-email-chaiw.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1407137779-19129-1-git-send-email-chaiw.fnst@cn.fujitsu.com>
References: <1407137779-19129-1-git-send-email-chaiw.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.161]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For now, soft lockup detector warns once for each case of process softlockup.
But the thread 'watchdog/n' may can not always get cpu at the time slot between
the task switch of two processes hogging that cpu.
This case is a false negative of "warn only once for a process", as there may be
a different process that is going to hog the cpu. Is is better for detector to
be aware of it. 

Signed-off-by: chai wen <chaiw.fnst@cn.fujitsu.com>
---
 kernel/watchdog.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 4c2e11c..908050c 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -42,6 +42,7 @@ static DEFINE_PER_CPU(bool, softlockup_touch_sync);
 static DEFINE_PER_CPU(bool, soft_watchdog_warn);
 static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts);
 static DEFINE_PER_CPU(unsigned long, soft_lockup_hrtimer_cnt);
+static DEFINE_PER_CPU(pid_t, softlockup_warn_pid_saved);
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 static DEFINE_PER_CPU(bool, hard_watchdog_warn);
 static DEFINE_PER_CPU(bool, watchdog_nmi_touch);
@@ -317,6 +318,8 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 	 */
 	duration = is_softlockup(touch_ts);
 	if (unlikely(duration)) {
+		pid_t pid = task_pid_nr(current);
+
 		/*
 		 * If a virtual machine is stopped by the host it can look to
 		 * the watchdog like a soft lockup, check to see if the host
@@ -326,8 +329,18 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 			return HRTIMER_RESTART;
 
 		/* only warn once */
-		if (__this_cpu_read(soft_watchdog_warn) == true)
+		if (__this_cpu_read(soft_watchdog_warn) == true) {
+			/*
+			 * soft lockup detector should be aware of that there
+			 * may be a task-swicth of two different processes
+			 * hogging the cpu continously
+			 */
+			if (__this_cpu_read(softlockup_warn_pid_saved) != pid) {
+				__this_cpu_write(soft_watchdog_warn, false);
+				__touch_watchdog();
+			}
 			return HRTIMER_RESTART;
+		}
 
 		if (softlockup_all_cpu_backtrace) {
 			/* Prevent multiple soft-lockup reports if one cpu is already
@@ -342,7 +355,8 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 
 		printk(KERN_EMERG "BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
 			smp_processor_id(), duration,
-			current->comm, task_pid_nr(current));
+			current->comm, pid);
+		__this_cpu_write(softlockup_warn_pid_saved, pid);
 		print_modules();
 		print_irqtrace_events(current);
 		if (regs)
-- 
1.7.1

