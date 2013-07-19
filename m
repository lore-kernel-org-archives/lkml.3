Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761177Ab3GSTIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 15:08:40 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:8834 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab3GSTIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 15:08:39 -0400
Message-ID: <51E98EB4.3080307@hp.com>
Date: Fri, 19 Jul 2013 15:08:36 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Davidlohr Bueso <davidlohr.bueso@hp.com>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mutex: Fix mutex_can_spin_on_owner
References: <20130719183101.GA20909@twins.programming.kicks-ass.net>
In-Reply-To: <20130719183101.GA20909@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 02:31 PM, Peter Zijlstra wrote:
> mutex_can_spin_on_owner() is broken in that it would allow the compiler
> to load lock->owner twice, seeing a pointer first time and a MULL
> pointer the second time.
>
> Signed-off-by: Peter Zijlstra<peterz@infradead.org>
> ---
>   kernel/mutex.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/mutex.c b/kernel/mutex.c
> index ff05f4b..7ff48c5 100644
> --- a/kernel/mutex.c
> +++ b/kernel/mutex.c
> @@ -209,11 +209,13 @@ int mutex_spin_on_owner(struct mutex *lock, struct task_struct *owner)
>    */
>   static inline int mutex_can_spin_on_owner(struct mutex *lock)
>   {
> +	struct task_struct *owner;
>   	int retval = 1;
>
>   	rcu_read_lock();
> -	if (lock->owner)
> -		retval = lock->owner->on_cpu;
> +	owner = ACCESS_ONCE(lock->owner);
> +	if (owner)
> +		retval = owner->on_cpu;
>   	rcu_read_unlock();
>   	/*
>   	 * if lock->owner is not set, the mutex owner may have just acquired

I am fine with this change. However, the compiler is smart enough to not 
do two memory accesses to the same memory location. So this will not 
change the generated code. Below is the relevant x86 code for that 
section of code:

    0x00000000000005d2 <+34>:    mov    0x18(%rdi),%rdx
    0x00000000000005d6 <+38>:    mov    $0x1,%eax
    0x00000000000005db <+43>:    test   %rdx,%rdx
    0x00000000000005de <+46>:    je     0x5e3 <__mutex_lock_slowpath+51>
    0x00000000000005e0 <+48>:    mov    0x28(%rdx),%eax
    0x00000000000005e3 <+51>:    test   %eax,%eax
    0x00000000000005e5 <+53>:    je     0x6d3 <__mutex_lock_slowpath+291>

Only one memory access is done.

Ack-by: Waiman Long <Waiman.Long@hp.com>
