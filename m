Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaKFPB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:01:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:54955 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaKFPBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:01:55 -0500
Date: Thu, 6 Nov 2014 16:01:50 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Subbaraman Narayanamurthy <subbaram@codeaurora.org>, daniel@numascale.com,
        yuyang.du@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: hotplug thread issues
Message-ID: <20141106150150.GT10501@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

So there have been some reports on hitting:

  BUG_ON(td->cpu != smp_processor_id());

in smpboot_thread_fn.

Now I've been staring at this for a wee bit today and I've found two
issues, but I'm not sure either are enough to explain the observed.

1) smpboot_register_percpu_thread() seems to lack serialization against
   hotplug. It has a for_each_online() loop, but no get_online_cpus() --
   unlike smpboot_unregister_percpu_thread, which does.

   Typical usage like spawn_ksoftirqd() should be fine, they're early
   init calls and those run before we bring up the other CPUs. Therefore
   this does not explain the observation that its ksoftirqd/n triggering
   the BUG.

   However, the usage in proc_dowatchdog() is susceptible to this race
   and its entirely possible to go wrong there.


2) the usage of __set_current_state(TASK_PARKED) in __kthread_parkme()
   is wrong AFAICT, one should always use set_current_state() for
   setting !TASK_RUNNING state. The comment with set_current_state()
   explains why.

   This would've allowed the test_bit(KTHREAD_SHOULD_PARK) load to have
   been satisfied before the store of TASK_PARKED.


In any case, I'm not sure either of these are enough, I'll go stare at
it a bit more I suppose.

---
 kernel/kthread.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 10e489c448fe..9787244d43ec 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -156,12 +156,12 @@ void *probe_kthread_data(struct task_struct *task)
 
 static void __kthread_parkme(struct kthread *self)
 {
-	__set_current_state(TASK_PARKED);
+	set_current_state(TASK_PARKED);
 	while (test_bit(KTHREAD_SHOULD_PARK, &self->flags)) {
 		if (!test_and_set_bit(KTHREAD_IS_PARKED, &self->flags))
 			complete(&self->parked);
 		schedule();
-		__set_current_state(TASK_PARKED);
+		set_current_state(TASK_PARKED);
 	}
 	clear_bit(KTHREAD_IS_PARKED, &self->flags);
 	__set_current_state(TASK_RUNNING);



