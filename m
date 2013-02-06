Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab3BFMgH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 07:36:07 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:36569 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3BFMgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 07:36:04 -0500
MIME-Version: 1.0
Date: Wed, 6 Feb 2013 20:36:01 +0800
Message-ID: <CAJd=RBD=yMa1-iAm_i71U+KKRNYmXDTb6yZzW5aVAGHQ+zD8Sw@mail.gmail.com>
Subject: [PATCH 1/3] stop_machine: check work->done while handling enqueued works
From: Hillf Danton <dhillf@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To advoid invalid reference, updating work result is moved to
cpu_stop_signal_done().

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/stop_machine.c	Wed Feb  6 19:50:56 2013
+++ b/kernel/stop_machine.c	Wed Feb  6 19:54:34 2013
@@ -51,9 +51,11 @@ static void cpu_stop_init_done(struct cp
 }

 /* signal completion unless @done is NULL */
-static void cpu_stop_signal_done(struct cpu_stop_done *done, bool executed)
+static void cpu_stop_signal_done(struct cpu_stop_done *done, bool
executed, int ret)
 {
 	if (done) {
+		if (ret)
+			done->ret = ret;
 		if (executed)
 			done->executed = true;
 		if (atomic_dec_and_test(&done->nr_todo))
@@ -73,7 +75,7 @@ static void cpu_stop_queue_work(struct c
 		list_add_tail(&work->list, &stopper->works);
 		wake_up_process(stopper->thread);
 	} else
-		cpu_stop_signal_done(work->done, false);
+		cpu_stop_signal_done(work->done, false, 0);

 	spin_unlock_irqrestore(&stopper->lock, flags);
 }
@@ -279,8 +281,6 @@ repeat:
 		preempt_disable();

 		ret = fn(arg);
-		if (ret)
-			done->ret = ret;

 		/* restore preemption and check it's still balanced */
 		preempt_enable();
@@ -289,7 +289,7 @@ repeat:
 			  kallsyms_lookup((unsigned long)fn, NULL, NULL, NULL,
 					  ksym_buf), arg);

-		cpu_stop_signal_done(done, true);
+		cpu_stop_signal_done(done, true, ret);
 	} else
 		schedule();

@@ -343,7 +343,7 @@ static int __cpuinit cpu_stop_cpu_callba
 		/* drain remaining works */
 		spin_lock_irq(&stopper->lock);
 		list_for_each_entry(work, &stopper->works, list)
-			cpu_stop_signal_done(work->done, false);
+			cpu_stop_signal_done(work->done, false, 0);
 		stopper->enabled = false;
 		spin_unlock_irq(&stopper->lock);
 		/* release the stopper */
--
