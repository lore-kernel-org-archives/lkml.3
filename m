Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab3BFMip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 07:38:45 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:55393 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3BFMio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 07:38:44 -0500
MIME-Version: 1.0
Date: Wed, 6 Feb 2013 20:38:43 +0800
Message-ID: <CAJd=RBBsMaXS5hA1OCX8Sp2y90Crktp6p4a7MSRZ3p6xq6RCmg@mail.gmail.com>
Subject: [PATCH 2/3] stop_machine: dequeue work before signal completion
From: Hillf Danton <dhillf@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As handled by the kernel thread, work is dequeued first for further actions.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/stop_machine.c	Wed Feb  6 19:57:12 2013
+++ b/kernel/stop_machine.c	Wed Feb  6 20:02:12 2013
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
 			cpu_stop_signal_done(work->done, false, 0);
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
