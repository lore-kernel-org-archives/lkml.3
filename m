Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbaHDKj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 06:39:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:33298 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbaHDKjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 06:39:54 -0400
Message-Id: <20140804103537.356311360@infradead.org>
User-Agent: quilt/0.60-1
Date: Mon, 04 Aug 2014 12:30:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, oleg@redhat.com, torvalds@linux-foundation.org
Cc: tglx@linutronix.de, ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        John McCutchan <john@johnmccutchan.com>, Robert Love <rlove@rlove.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 1/7] wait: Provide infrastructure to deal with nested blocking
References: <20140804103025.478913141@infradead.org>
Content-Disposition: inline; filename=peterz-wait-nested.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a few places that call blocking primitives from wait loops,
provide infrastructure to support this without the typical
task_struct::state collision.

We record the wakeup in wait_queue_t::flags which leaves
task_struct::state free to be used by others.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/wait.h |    7 ++++++-
 kernel/sched/wait.c  |   29 +++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 1 deletion(-)

--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -13,9 +13,12 @@ typedef struct __wait_queue wait_queue_t
 typedef int (*wait_queue_func_t)(wait_queue_t *wait, unsigned mode, int flags, void *key);
 int default_wake_function(wait_queue_t *wait, unsigned mode, int flags, void *key);
 
+/* __wait_queue::flags */
+#define WQ_FLAG_EXCLUSIVE	0x01
+#define WQ_FLAG_WOKEN		0x02
+
 struct __wait_queue {
 	unsigned int		flags;
-#define WQ_FLAG_EXCLUSIVE	0x01
 	void			*private;
 	wait_queue_func_t	func;
 	struct list_head	task_list;
@@ -825,6 +828,8 @@ void prepare_to_wait_exclusive(wait_queu
 long prepare_to_wait_event(wait_queue_head_t *q, wait_queue_t *wait, int state);
 void finish_wait(wait_queue_head_t *q, wait_queue_t *wait);
 void abort_exclusive_wait(wait_queue_head_t *q, wait_queue_t *wait, unsigned int mode, void *key);
+long wait_woken(wait_queue_t *wait, unsigned mode, long timeout);
+int woken_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
 int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
 int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
 
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -297,6 +297,35 @@ int autoremove_wake_function(wait_queue_
 }
 EXPORT_SYMBOL(autoremove_wake_function);
 
+long wait_woken(wait_queue_t *wait, unsigned mode, long timeout)
+{
+	set_current_state(mode);
+	if (!(wait->flags & WQ_FLAG_WOKEN))
+		timeout = schedule_timeout(timeout);
+	else
+		wait->flags &= ~WQ_FLAG_WOKEN;
+	__set_current_state(TASK_RUNNING);
+
+	return timeout;
+}
+EXPORT_SYMBOL(wait_woken);
+
+int woken_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key)
+{
+	/*
+	 * Although this function is called under waitqueue lock, LOCK
+	 * doesn't imply write barrier and the users expect write
+	 * barrier semantics on wakeup functions.  The following
+	 * smp_wmb() is equivalent to smp_wmb() in try_to_wake_up()
+	 * and is paired with set_mb() in wait_woken().
+	 */
+	smp_wmb();
+	wait->flags |= WQ_FLAG_WOKEN;
+
+	return default_wake_function(wait, mode, sync, key);
+}
+EXPORT_SYMBOL(woken_wake_function);
+
 int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *arg)
 {
 	struct wait_bit_key *key = arg;


