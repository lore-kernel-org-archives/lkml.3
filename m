Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122Ab3HSQtN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 12:49:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10755 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab3HSQtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 12:49:10 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=FhRC9Vwtdx4A:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=mmEQHNNGUxcA:10 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=YYkoI8h6Vtb6UQliDYgA:9 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 19 Aug 2013 12:49:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Clark Williams <clark.williams@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH RT 2/3] swait: Add memory barrier before checking list
 empty
Message-ID: <20130819124908.2e45b9a1@gandalf.local.home>
In-Reply-To: <20130819115155.41f909fe@gandalf.local.home>
References: <20130819153530.409041534@goodmis.org>
	<20130819153618.983248997@goodmis.org>
	<20130819115155.41f909fe@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Aug 2013 11:51:55 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 19 Aug 2013 11:35:32 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: Steven Rostedt <rostedt@goodmis.org>
> > 
> > There's a race condition with swait wakeups and adding to the list. The
> > __swait_wake() does a check for swait_head_has_waiters(), and if it is
> > empty it will exit without doing any wake ups. The problem is that the
> > check does not include any memory barriers before it makes a decision
> > to wake up or not.
> > 
> > 	CPU0				CPU1
> > 	----				----
> > 
> >   condition = 1
> > 
> >   load h->list (is empty)
> > 				    raw_spin_lock(hlist->lock)
> > 				    hlist_add();
> > 				    __set_current_state();
> > 				    raw_spin_unlock(hlist->lock)
> >   swait_wake()
> >    swait_head_has_waiters()
> >    (sees h->list as empty and returns)
> > 
> 
> BTW, the race still exists if you move the raw_spin_unlock(hlist->lock)
> above to here. That is:
> 
>    swait_wake()
>     swait_head_has_waiters()
>      (sees h->list as empty and returns)
> 
> 				    raw_spin_unlock(hlist->lock)
> 
> 
> Maybe this will help to understand it more.

As with all memory barrier issues, it can be confusing. To try to
describe this even better, the bug happens because the load of h->list
can happen before the store of condition by the waker.

The wake up code requires that the condition is written out first, and
then the check to see if waiters exist happens (which is the check if
h->list is empty or not).

To prevent missing a wake up, the waiter will add itself to the wait
queue (h->list), then check the condition. If the condition is already
set, it puts back its state, and continues without calling schedule. If
the condition is not set, its safe to call schedule because if the task
that is to wake it up will do so after setting the condition. But
that's assuming that it knows to wake it up (because its on the list).

If the condition is stored after the check of whether or not there are
waiters, then we can not guarantee we will wake up the task waiting for
the condition to arise. What happens instead, the waker checks the list,
sees nothing on it, and returns (the condition is still in the process
of being stored by the CPU, but hasn't yet made it to memory). The
waiter then sets itself on the list to be woken, and checks the
condition. But since the condition hasn't been written out yet, it goes
to sleep. But this time, nobody is there to wake it up.

By adding the memory barrier before checking the list to see if anyone
is waiting for the condition, we force the condition out to memory and
so it will be seen by the waiter before it goes to sleep, or after it
added itself to the waiter list. In any case, the memory barrier will
either have the waiter see the condition is set, or the waker will see
the waiter is on the list. Either case, the waiter will be woken up.

Now, patch 3/3 handles the case where the waiter may read the condition
before it sets itself on the list. This too is bad, because it can read
the condition before the waker sets it, but then the waker can read the
list before the waiter adds itself to the list. This is also a missed
wakeup.

But luckily, this case on x86 isn't a issue because the
raw_spin_unlock() will prevent that from happening, because on x86,
raw_spin_unlock() is a full memory barrier. But it may not be on other
architectures. If other architectures only flush out what has been
written, it does not guarantee that something could have been read
early, that would let the condition leak before the h->list is stored.
That's why I kept patch 3/3 different than this patch. This patch is a
bug on all SMP architectures, where as 3/3 is only a bug on specific
architectures.

-- Steve


> 
> > 				    check_condition (sees condition = 0)
> > 
> >    store condition = 1
> > 
> > 				    schedule()
> > 
> > Now the task on CPU1 has just missed its wakeup. By adding a memory
> > barrier before the list empty check, we fix the problem of miss seeing
> > the list not empty as well as pushing out the condition for the other
> > task to see.
> > 
> > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

