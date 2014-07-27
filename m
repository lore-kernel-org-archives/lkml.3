Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbaG0QpE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 12:45:04 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:45665 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbaG0QpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 12:45:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140727162918.GN11241@linux.vnet.ibm.com>
References: <1406264818-2296-1-git-send-email-bobby.prani@gmail.com>
 <20140725144458.GY11241@linux.vnet.ibm.com> <CAJhHMCAvcKZ+gnW4GYf5-WNYFHsoAiBFU4vUcR5ifJedVvFtzQ@mail.gmail.com>
 <20140725224759.GG11241@linux.vnet.ibm.com> <CAJhHMCA_Z-1DP1Fo8_KJ2F8R4LYsMrbC2Yp_NqCSu0cCR8EQDw@mail.gmail.com>
 <20140727162918.GN11241@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Sun, 27 Jul 2014 12:44:30 -0400
Message-ID: <CAJhHMCB7C-Sah5wh1vSQFj7cpRHbGZbV==aPH0xP_aQYJ1MR+A@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] rcu: Use rcu_gp_kthread_wake() to wake up kthreads
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2014 at 12:29 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Sun, Jul 27, 2014 at 11:55:38AM -0400, Pranith Kumar wrote:
>> Hi Paul,
>>
>> On Fri, Jul 25, 2014 at 6:47 PM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com> wrote:
>> > On Fri, Jul 25, 2014 at 04:19:43PM -0400, Pranith Kumar wrote:
>> >>
>> >> I checked all the locations where gp_flags is being updated and the
>> >> root node lock is held in all the cases.
>> >> So I guess we can remove the comment too.
>> >
>> > And the accesses that matter (for some definition of "that matter") are
>> > also similarly protected?
>> >
>> > An example of an access that doesn't matter is one that is followed up
>> > by an access under the appropriate lock.
>>
>> I am really new to having to think about the need for memory barriers,
>> so please correct me if I am wrong.
>>
>> So the idea here is that two consecutive accesses to ->gp_flags should
>> not be re-ordered. If an access to ->gp_flags is followed by an access
>> within a lock, the second access cannot be re-ordered with the first
>> one and hence it will be safe, right?
>
> No, in that case they actually can be re-ordered.
>
> If two accesses are made while holding a given lock, then they cannot
> be reordered, but only from the viewpoint of another access made while
> holding that same lock.
>
> This gets really involved really fast.  You therefore need to read
> Documentation/memory-barriers.txt.

OK, I think I will do that now and for the next few days :)

>
>> The appropriate lock for ->gp_flags is rcu_node->lock.
>
> Specifically, the root rcu_node structure's ->lock.
>
>>                                                        I see
>> consecutive accesses to ->gp_flags without this lock only in
>> force_quiescent_state()(we take fqslock there), but these accesses
>> looks safe as they are in independent iterations of a loop. These
>> cannot be rearranged by the compiler.
>
> Almost...  They are ordered because the accesses are to the exact same
> variable -and- because they are protected by ACCESS_ONCE().  If there
> was no ACCESS_ONCE(), both the CPU and the compiler could rearrange the
> accesses.  (On many, but not all, architectures, the unlock-lock
> pairs would act as full barriers.)

I was under the impression that ACCESS_ONCE() only defeated the
compiler re-orderings. I did not know that it could defeat the CPU
reordering too. I will look for the details in the documentation.


>
>> So all the accesses are safe from re-ordering and hence there is no
>> need of a memory barrier for accessing ->gp_flags in
>> rcu_gp_kthread_wake().
>
> Your answer does in fact appear to be correct, but the reasoning leading
> to it is not completely sound.  Which is not bad, given that you appear
> not to have read the documentation.  Therefore, once again, please read
> Documentation/memory-barriers.txt.

When the answer is yes/no, I think I luckily landed on the correct
side of 50% fence :)

--
Pranith.

>
>                                                         Thanx, Paul
>
>> > Anyway, if it is all locked properly, then yes, we should get rid of
>> > the comment -- or replace it with a comment saying that barriers are
>> > not needed due to locking.
>> >
>> >                                                         Thanx, Paul
>> >
>> >> >> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>> >> >> ---
>> >> >>  kernel/rcu/tree.c | 6 ++++--
>> >> >>  1 file changed, 4 insertions(+), 2 deletions(-)
>> >> >>
>> >> >> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
>> >> >> index 72e0b1f..d0e0d6e 100644
>> >> >> --- a/kernel/rcu/tree.c
>> >> >> +++ b/kernel/rcu/tree.c
>> >> >> @@ -1938,7 +1938,8 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp, unsigned long flags)
>> >> >>  {
>> >> >>       WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
>> >> >>       raw_spin_unlock_irqrestore(&rcu_get_root(rsp)->lock, flags);
>> >> >> -     wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
>> >> >> +     /* Memory barrier implied by wake_up() path. */
>> >> >> +     rcu_gp_kthread_wake(rsp);
>> >> >>  }
>> >> >>
>> >> >>  /*
>> >> >> @@ -2516,7 +2517,8 @@ static void force_quiescent_state(struct rcu_state *rsp)
>> >> >>       ACCESS_ONCE(rsp->gp_flags) =
>> >> >>               ACCESS_ONCE(rsp->gp_flags) | RCU_GP_FLAG_FQS;
>> >> >>       raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
>> >> >> -     wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
>> >> >> +     /* Memory barrier implied by wake_up() path. */
>> >> >> +     rcu_gp_kthread_wake(rsp);
>> >> >>  }
>> >> >>
>> >> >>  /*
>> >> >> --
>> >> >> 2.0.1
>> >> >>
>> >> >
>> >>
>> >>
>> >>
>> >> --
>> >> Pranith
>> >>
>> >
>>
>>
>>
>> --
>> Pranith
>>
>



-- 
Pranith
