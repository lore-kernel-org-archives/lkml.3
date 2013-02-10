Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751233Ab3BJF0M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 00:26:12 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:36920 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab3BJF0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 00:26:11 -0500
MIME-Version: 1.0
Date: Sun, 10 Feb 2013 13:26:11 +0800
Message-ID: <CAJd=RBAJdTewGVs2CFoto6ybnxUOJKHSF57nZQT25uF7B-b+fg@mail.gmail.com>
Subject: [PATCH 2/2] stop_machine: dequeue work before signal completion
From: Hillf Danton <dhillf@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a CPU is finally put down in either CPU_UP_CANCELLED or
CPU_POST_DEAD, cpu_stop_cpu_callback() signals immediate completion on
all cpu_stop_works still queued on the dead CPU; unfortunately, this
code is buggy in that it doesn't remove the canceled work items off
the stopper->works leaving it corrupted, which will trigger BUG_ON()
during CPU_UP_PREPARE if the CPU is brought back online.

This bug isn't easily triggered because CPU_DOWN has to race against
cpu_stop calls and most, if not all, cpu stop users pin target CPUs.

Fix it by popping each work item off stopper->works.

Thanks Tejun for sharing commit message, again.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: stable@vger.kernel.org
---

--- a/kernel/stop_machine.c	Sun Feb 10 13:00:00 2013
+++ b/kernel/stop_machine.c	Sun Feb 10 13:02:18 2013
@@ -334,23 +334,24 @@ static int __cpuinit cpu_stop_cpu_callba
 #ifdef CONFIG_HOTPLUG_CPU
 	case CPU_UP_CANCELED:
 	case CPU_POST_DEAD:
-	{
-		struct cpu_stop_work *work;
-
 		sched_set_stop_task(cpu, NULL);
 		/* kill the stopper */
 		kthread_stop(stopper->thread);
 		/* drain remaining works */
 		spin_lock_irq(&stopper->lock);
-		list_for_each_entry(work, &stopper->works, list)
+		while (!list_empty(&stopper->works)) {
+			struct cpu_stop_work *work;
+			work = list_first_entry(&stopper->works,
+					struct cpu_stop_work, list);
+			list_del_init(&work->list);
 			cpu_stop_signal_done(work->done, false);
+		}
 		stopper->enabled = false;
 		spin_unlock_irq(&stopper->lock);
 		/* release the stopper */
 		put_task_struct(stopper->thread);
 		stopper->thread = NULL;
 		break;
-	}
 #endif
 	}

--
