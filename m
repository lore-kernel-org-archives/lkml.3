Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaG0X7O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 19:59:14 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:46091 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaG0X7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 19:59:12 -0400
MIME-Version: 1.0
In-Reply-To: <456359712.21364.1406504982621.JavaMail.zimbra@efficios.com>
References: <1406504249-15176-1-git-send-email-bobby.prani@gmail.com> <456359712.21364.1406504982621.JavaMail.zimbra@efficios.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Sun, 27 Jul 2014 19:58:40 -0400
Message-ID: <CAJhHMCDL4RdCi9PGvQQTwxC+n8WXq7k8OfsO8vK8fo5HDeLd0A@mail.gmail.com>
Subject: Re: [PATCH 1/1] rcu: Use rcu_gp_kthread_wake() to wake up grace
 period kthreads
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2014 at 7:49 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> ----- Original Message -----
>> From: "Pranith Kumar" <bobby.prani@gmail.com>
>> To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "Josh Triplett" <josh@joshtriplett.org>, "Steven Rostedt"
>> <rostedt@goodmis.org>, "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Lai Jiangshan" <laijs@cn.fujitsu.com>,
>> "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
>> Sent: Sunday, July 27, 2014 7:37:29 PM
>> Subject: [PATCH 1/1] rcu: Use rcu_gp_kthread_wake() to wake up grace period kthreads
>>
>> The rcu_gp_kthread_wake() function checks for three conditions before waking
>> up
>> grace period kthreads:
>>
>> *  Is the thread we are trying to wake up the current thread?
>> *  Are the gp_flags zero? (all threads wait on non-zero gp_flags condition)
>> *  Is there no thread created for this flavour, hence nothing to wake up?
>>
>> If any one of these condition is true, we do not call wake_up().
>>
>> It was found that there are quite a few avoidable wake ups both during idle
>> time and under stress induced by rcutorture.
>>
>> Idle:
>>
>> Total:66000, unnecessary:66000, case1:61827, case2:66000, case3:0
>> Total:68000, unnecessary:68000, case1:63696, case2:68000, case3:0
>>
>> rcutorture:
>>
>> Total:254000, unnecessary:254000, case1:199913, case2:254000, case3:0
>> Total:256000, unnecessary:256000, case1:201784, case2:256000, case3:0
>>
>> Here case{1-3} are the cases listed above. We can avoid these wake ups by
>> using
>> rcu_gp_kthread_wake() to conditionally wake up the grace period kthreads.
>>
>> Hence this commit tries to avoid calling wake_up() whenever we can by using
>> rcu_gp_kthread_wake() function.
>>
>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>> ---
>>  kernel/rcu/tree.c | 10 ++++++++--
>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
>> index b63517c..36911ee 100644
>> --- a/kernel/rcu/tree.c
>> +++ b/kernel/rcu/tree.c
>> @@ -1938,7 +1938,10 @@ static void rcu_report_qs_rsp(struct rcu_state *rsp,
>> unsigned long flags)
>>  {
>>       WARN_ON_ONCE(!rcu_gp_in_progress(rsp));
>>       raw_spin_unlock_irqrestore(&rcu_get_root(rsp)->lock, flags);
>> -     wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
>> +     /* ->gp_flags is properly protected by locks, so a memory barrier
>> +      * is not necessary here
>
> Two point:
>
> 1- The format of this comment is odd, and should be:
>
> /*
>  * Text...
>  */

OK, I will update it according to this format.

>
> 2- Since when can a memory barrier be replaced by a lock ? More explanation
>    appears to be needed on what this barrier matches exactly.

On re-reading I realize that this comment is very vague and introduces
more doubts than it clears.

The context here is that in rcu_gp_kthread_wake() we are accessing
->gp_flags to determine whether we need to wake up the gp kthreads. We
don't need a barrier here since we are accessing it using
ACCESS_ONCE() and all other accesses are properly protected by using
ACCESS_ONCE() and taking the root rcu_node lock.

So how about this:

/*
 * ->gp_flags is being accessed using ACCESS_ONCE() because of
 * which a memory barrier is not required here.
 */

>
>> +      */
>> +     rcu_gp_kthread_wake(rsp);
>>  }
>>
>>  /*
>> @@ -2516,7 +2519,10 @@ static void force_quiescent_state(struct rcu_state
>> *rsp)
>>       ACCESS_ONCE(rsp->gp_flags) =
>>               ACCESS_ONCE(rsp->gp_flags) | RCU_GP_FLAG_FQS;
>>       raw_spin_unlock_irqrestore(&rnp_old->lock, flags);
>> -     wake_up(&rsp->gp_wq);  /* Memory barrier implied by wake_up() path. */
>> +     /* ->gp_flags is properly protected by locks, so a memory barrier
>> +      * is not necessary here
>> +      */
>> +     rcu_gp_kthread_wake(rsp);
>>  }
>>
>>  /*
>> --
>> 1.9.1
>>
>>
>
> --
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com



-- 
Pranith
