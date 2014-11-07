Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaKGK3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 05:29:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:34417 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaKGK3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 05:29:05 -0500
Date: Fri, 7 Nov 2014 11:28:55 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Subbaraman Narayanamurthy <subbaram@codeaurora.org>, daniel@numascale.com,
        yuyang.du@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH]: kthread: Fix memory ordering in __kthread_parkme
Message-ID: <20141107102855.GA29390@twins.programming.kicks-ass.net>
References: <20141106150150.GT10501@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.11.1411071037440.3789@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1411071037440.3789@nanos>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 10:39:48AM +0100, Thomas Gleixner wrote:
> > 2) the usage of __set_current_state(TASK_PARKED) in __kthread_parkme()
> >    is wrong AFAICT, one should always use set_current_state() for
> >    setting !TASK_RUNNING state. The comment with set_current_state()
> >    explains why.
> > 
> >    This would've allowed the test_bit(KTHREAD_SHOULD_PARK) load to have
> >    been satisfied before the store of TASK_PARKED.
> 
> My bad. Can you send a proper patch addressing that issue please? That
> should be tagged stable as well I guess.

Sure thing, something like so then?

---
Subject: kthread: Fix memory ordering in __kthread_parkme

One should always use set_current_state() to set !TASK_RUNNING states.

	set_current_state(TASK_*);		cond = true;
	/* mb */				/* wmb */
	if (!cond)				wake_up_state(, TASK_*);
		schedule();

By not having the mb we allow for the cond load to be satisfied before
the state store, this can result in:

	if (!cond)
						cond = true;
						wake_up_state(, TASK_*);
	__set_current_state(TASK_*);
		schedule();

Which would block 'forever', since the cond is still false and the
wakeup would not have seen the !TASK_RUNNING state.

Cc: stable@vger.kernel.org
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
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
