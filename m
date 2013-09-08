Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758713Ab3IHP53 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 11:57:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18000 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757328Ab3IHP4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 11:56:49 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=-Sme77ZZ12QA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=QZX9-uWsNf4A:10 a=VwQbUJbxAAAA:8 a=SwzNn0HwW6X4NKEoqz0A:9 a=jeBq3FmKZ4MA:10 a=Zh68SRI7RUMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130908151445.790294738@goodmis.org>
User-Agent: quilt/0.60-1
Date: Sun, 08 Sep 2013 11:13:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>
Subject: [PATCH RT 01/19] sched/workqueue: Only wake up idle workers if not blocked on
 sleeping spin lock
References: <20130908151355.362583092@goodmis.org>
Content-Disposition: inline; filename=0001-sched-workqueue-Only-wake-up-idle-workers-if-not-blo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

In -rt, most spin_locks() turn into mutexes. One of these spin_lock
conversions is performed on the workqueue gcwq->lock. When the idle
worker is worken, the first thing it will do is grab that same lock and
it too will block, possibly jumping into the same code, but because
nr_running would already be decremented it prevents an infinite loop.

But this is still a waste of CPU cycles, and it doesn't follow the method
of mainline, as new workers should only be woken when a worker thread is
truly going to sleep, and not just blocked on a spin_lock().

Check the saved_state too before waking up new workers.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/sched/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5051ca6..781e6c4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3632,8 +3632,10 @@ need_resched:
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
-- 
1.7.10.4


