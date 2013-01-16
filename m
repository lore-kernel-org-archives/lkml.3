Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab3APCxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 21:53:05 -0500
Received: from mail-da0-f47.google.com ([209.85.210.47]:51175 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113Ab3APCxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 21:53:02 -0500
Date: Tue, 15 Jan 2013 18:52:51 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] module, async: async_synchronize_full() on module init iff
 async is used
Message-ID: <20130116025251.GM2668@htj.dyndns.org>
References: <CACVXFVNvBeHG2TgfNY-wRQYtqsd6v-3AAiQVPAECuRnJ--ON-g@mail.gmail.com>
 <CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com>
 <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com>
 <CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com>
 <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
 <20130115183204.GE2668@htj.dyndns.org>
 <CA+55aFzZ1NJz34r99N7+mU4CN5Ju4QpHrDoWv5Kbd5-Z4QzgaA@mail.gmail.com>
 <20130115235043.GJ2668@htj.dyndns.org>
 <CA+55aFzm4k2CyQ_mZVHyeasjw4ybqfO2SpJrZZNZeUsSW8PB=g@mail.gmail.com>
 <CA+55aFxLJ=Yfms9SkPJLjQ-ZASPNZC0JUBsb3OwonJvTCcBzxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxLJ=Yfms9SkPJLjQ-ZASPNZC0JUBsb3OwonJvTCcBzxA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the default iosched is built as module, the kernel may deadlock
while trying to load the iosched module on device probe if the probing
was running off async.  This is because async_synchronize_full() at
the end of module init ends up waiting for the async job which
initiated the module loading.

 async A				modprobe

 1. finds a device
 2. registers the block device
 3. request_module(default iosched)
					4. modprobe in userland
					5. load and init module
					6. async_synchronize_full()

Async A waits for modprobe to finish in request_module() and modprobe
waits for async A to finish in async_synchronize_full().

Because there's no easy to track dependency once control goes out to
userland, implementing properly nested flushing is difficult.  For
now, make module init perform async_synchronize_full() iff module init
has queued async jobs as suggested by Linus.

This avoids the described deadlock because iosched module doesn't use
async and thus wouldn't invoke async_synchronize_full().  This is
hacky and incomplete.  It will deadlock if async module loading nests;
however, this works around the known problem case and seems to be the
best of bad options.

For more details, please refer to the following thread.

  http://thread.gmane.org/gmane.linux.kernel/1420814

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Alex Riesen <raa.lkml@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
It makes me feel dirty but makes the problem go away and I can't think
of anything better, so here is the implementation of "used async"
workaround.

Thanks.

 include/linux/sched.h |    1 +
 kernel/async.c        |    3 +++
 kernel/module.c       |   27 +++++++++++++++++++++++++--
 3 files changed, 29 insertions(+), 2 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1810,6 +1810,7 @@ extern void thread_group_cputime_adjuste
 #define PF_MEMALLOC	0x00000800	/* Allocating memory */
 #define PF_NPROC_EXCEEDED 0x00001000	/* set_user noticed that RLIMIT_NPROC was exceeded */
 #define PF_USED_MATH	0x00002000	/* if unset the fpu must be initialized before use */
+#define PF_USED_ASYNC	0x00004000	/* used async_schedule*(), used by module init */
 #define PF_NOFREEZE	0x00008000	/* this thread should not be frozen */
 #define PF_FROZEN	0x00010000	/* frozen for system suspend */
 #define PF_FSTRANS	0x00020000	/* inside a filesystem transaction */
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -196,6 +196,9 @@ static async_cookie_t __async_schedule(a
 	atomic_inc(&entry_count);
 	spin_unlock_irqrestore(&async_lock, flags);
 
+	/* mark that this task has queued an async job, used by module init */
+	current->flags |= PF_USED_ASYNC;
+
 	/* schedule for execution */
 	queue_work(system_unbound_wq, &entry->work);
 
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3013,6 +3013,12 @@ static int do_init_module(struct module
 {
 	int ret = 0;
 
+	/*
+	 * We want to find out whether @mod uses async during init.  Clear
+	 * PF_USED_ASYNC.  async_schedule*() will set it.
+	 */
+	current->flags &= ~PF_USED_ASYNC;
+
 	blocking_notifier_call_chain(&module_notify_list,
 			MODULE_STATE_COMING, mod);
 
@@ -3058,8 +3064,25 @@ static int do_init_module(struct module
 	blocking_notifier_call_chain(&module_notify_list,
 				     MODULE_STATE_LIVE, mod);
 
-	/* We need to finish all async code before the module init sequence is done */
-	async_synchronize_full();
+	/*
+	 * We need to finish all async code before the module init sequence
+	 * is done.  This has potential to deadlock.  For example, a newly
+	 * detected block device can trigger request_module() of the
+	 * default iosched from async probing task.  Once userland helper
+	 * reaches here, async_synchronize_full() will wait on the async
+	 * task waiting on request_module() and deadlock.
+	 *
+	 * This deadlock is avoided by perfomring async_synchronize_full()
+	 * iff module init queued any async jobs.  This isn't a full
+	 * solution as it will deadlock the same if module loading from
+	 * async jobs nests more than once; however, due to the various
+	 * constraints, this hack seems to be the best option for now.
+	 * Please refer to the following thread for details.
+	 *
+	 * http://thread.gmane.org/gmane.linux.kernel/1420814
+	 */
+	if (current->flags & PF_USED_ASYNC)
+		async_synchronize_full();
 
 	mutex_lock(&module_mutex);
 	/* Drop initial reference. */
