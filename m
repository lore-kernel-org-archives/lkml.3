Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab3AWVzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 16:55:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab3AWVzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 16:55:45 -0500
Message-ID: <51005C4D.1090105@redhat.com>
Date: Wed, 23 Jan 2013 16:55:25 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Ingo Molnar <mingo@redhat.com>, "Paul E. McKenney" <paulmck@us.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/6] kernel: faster queue spinlock implementation
References: <1358896415-28569-1-git-send-email-walken@google.com> <1358896415-28569-5-git-send-email-walken@google.com>
In-Reply-To: <1358896415-28569-5-git-send-email-walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 06:13 PM, Michel Lespinasse wrote:

> Because of these limitations, the MCS queue spinlock implementation does
> not always compare favorably to ticket spinlocks under moderate contention.
>
> This alternative queue spinlock implementation has some nice properties:
>
> - One single atomic operation (xchg) during acquire
> - One single memory store for unlock. No busy looping either.
>    Actually, the unlock is so short that we can just inline it.
> - Same basic API as with the MCS spinlock

There is one thing I do not understand about these locks.

> +static inline void
> +q_spin_unlock(struct q_spinlock *lock, struct q_spinlock_node *node)
> +{
> +	q_spin_unlock_mb();	/* guarantee release store semantics */
> +	ACCESS_ONCE(node->token->wait) = false;
> +	preempt_enable();
> +}

Here you set wait to false, in the CPU-local (on the current CPU)
queue lock token. Afterwards, the same CPU could try to lock another
lock, using the same token...

> +DEFINE_PER_CPU(struct q_spinlock_token *, q_spinlock_token[2]);
> +
> +static inline struct q_spinlock_token *
> +____q_spin_lock(struct q_spinlock *lock,
> +		struct q_spinlock_token **percpu_token)
>   {
> +	/*
> +	 * Careful about reentrancy here - if we are interrupted and the code
> +	 * running in that interrupt tries to get another queue spinlock,
> +	 * it must not use the same percpu_token that we're using here.
> +	 */
> +
> +	struct q_spinlock_token *token, *prev;
> +
> +	token = __this_cpu_read(*percpu_token);
> +	token->wait = true;
> +	prev = xchg(&lock->token, token);
> +	__this_cpu_write(*percpu_token, prev);
> +	while (ACCESS_ONCE(prev->wait))
>   		cpu_relax();
>   	q_spin_lock_mb();	/* guarantee acquire load semantics */
> +	return token;
>   }

Here a CPU trying to take the lock will spin on the previous
CPU's token.

However, the previous CPU can immediately re-use its token.

It looks like it might be possible for the CPU trying to
acquire the lock to miss prev->wait being set to false, and
continue spinning.

If this lock type is widely used, could that lead to a deadlock?

Is there something in your code that guarantees the scenario
I described cannot happen, and I just missed it?
