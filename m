Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab3CRTMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 15:12:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25146 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3CRTMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 15:12:50 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=-mocLKwlevAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=QZX9-uWsNf4A:10 a=SwzNn0HwW6X4NKEoqz0A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363633969.28194.3.camel@gandalf.local.home>
Subject: [PATCH RT] sched/workqueue: Only wake up idle workers if not
 blocked on sleeping spin lock
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Date: Mon, 18 Mar 2013 15:12:49 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In -rt, most spin_locks() turn into mutexes. One of these spin_lock
conversions is performed on the workqueue gcwq->lock. When the idle
worker is worken, the first thing it will do is grab that same lock and
it too will block, possibly jumping into the same code, but because
nr_running would already be decremented it prevents an infinite loop.

But this is still a waste of CPU cycles, and it doesn't follow the method
of mainline, as new workers should only be woken when a worker thread is
truly going to sleep, and not just blocked on a spin_lock().

Check the saved_state too before waking up new workers.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index ff34113..b25bfec 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3630,8 +3630,10 @@ need_resched:
 			 * If a worker went to sleep, notify and ask workqueue
 			 * whether it wants to wake up a task to maintain
 			 * concurrency.
+			 * Only call wake up if prev isn't blocked on a sleeping
+			 * spin lock.
 			 */
-			if (prev->flags & PF_WQ_WORKER) {
+			if (prev->flags & PF_WQ_WORKER && !prev->saved_state) {
 				struct task_struct *to_wakeup;
 
 				to_wakeup = wq_worker_sleeping(prev, cpu);


