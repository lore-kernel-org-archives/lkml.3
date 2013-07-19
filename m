Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760882Ab3GSSgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 14:36:33 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:10415 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab3GSSgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 14:36:32 -0400
Message-ID: <1374258989.9305.6.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] mutex: Fix mutex_can_spin_on_owner
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <Waiman.Long@hp.com>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Fri, 19 Jul 2013 11:36:29 -0700
In-Reply-To: <20130719183101.GA20909@twins.programming.kicks-ass.net>
References: <20130719183101.GA20909@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-19 at 20:31 +0200, Peter Zijlstra wrote:
> mutex_can_spin_on_owner() is broken in that it would allow the compiler
> to load lock->owner twice, seeing a pointer first time and a MULL
> pointer the second time.
> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Yep, I remember this from the rwsem optimistic spinning thread.

Acked-by: Davidlohr Bueso <davidlohr.bueso@hp.com>

> ---
>  kernel/mutex.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/mutex.c b/kernel/mutex.c
> index ff05f4b..7ff48c5 100644
> --- a/kernel/mutex.c
> +++ b/kernel/mutex.c
> @@ -209,11 +209,13 @@ int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
>   */
>  static inline int mutex_can_spin_on_owner(struct mutex *lock)
>  {
> +	struct task_struct *owner;
>  	int retval = 1;
>  
>  	rcu_read_lock();
> -	if (lock->owner)
> -		retval = lock->owner->on_cpu;
> +	owner = ACCESS_ONCE(lock->owner);
> +	if (owner)
> +		retval = owner->on_cpu;
>  	rcu_read_unlock();
>  	/*
>  	 * if lock->owner is not set, the mutex owner may have just acquired


