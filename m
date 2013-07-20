Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab3GTLRH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 07:17:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43517 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688Ab3GTLRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 07:17:06 -0400
Date: Sat, 20 Jul 2013 13:16:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mutex: Fix mutex_can_spin_on_owner
Message-ID: <20130720111648.GQ27075@twins.programming.kicks-ass.net>
References: <20130719183101.GA20909@twins.programming.kicks-ass.net>
 <51E98EB4.3080307@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E98EB4.3080307@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 03:08:36PM -0400, Waiman Long wrote:
> On 07/19/2013 02:31 PM, Peter Zijlstra wrote:
> >mutex_can_spin_on_owner() is broken in that it would allow the compiler
> >to load lock->owner twice, seeing a pointer first time and a MULL
> >pointer the second time.
> >
> >Signed-off-by: Peter Zijlstra<peterz@infradead.org>
> >---
> >  kernel/mutex.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> >diff --git a/kernel/mutex.c b/kernel/mutex.c
> >index ff05f4b..7ff48c5 100644
> >--- a/kernel/mutex.c
> >+++ b/kernel/mutex.c
> >@@ -209,11 +209,13 @@ int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
> >   */
> >  static inline int mutex_can_spin_on_owner(struct mutex *lock)
> >  {
> >+	struct task_struct *owner;
> >  	int retval = 1;
> >
> >  	rcu_read_lock();
> >-	if (lock->owner)
> >-		retval = lock->owner->on_cpu;
> >+	owner = ACCESS_ONCE(lock->owner);
> >+	if (owner)
> >+		retval = owner->on_cpu;
> >  	rcu_read_unlock();
> >  	/*
> >  	 * if lock->owner is not set, the mutex owner may have just acquired
> 
> I am fine with this change. However, the compiler is smart enough to not do
> two memory accesses to the same memory location. So this will not change the
> generated code. Below is the relevant x86 code for that section of code:

Yes I know, but the compiler would be allowed to do so; not so after the
change.

Also, GCC can be surprisingly stupid at times, depending on the options
given, never rely/trust on anything you don't have to.


