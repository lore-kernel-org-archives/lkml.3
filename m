Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752584Ab3AWX6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 18:58:08 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46019 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab3AWX55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 18:57:57 -0500
MIME-Version: 1.0
In-Reply-To: <51005C4D.1090105@redhat.com>
References: <1358896415-28569-1-git-send-email-walken@google.com>
	<1358896415-28569-5-git-send-email-walken@google.com>
	<51005C4D.1090105@redhat.com>
Date: Wed, 23 Jan 2013 15:52:30 -0800
Message-ID: <CANN689GdaoiQ6EDTgTfPmXTQPb6_4pWnXZm4pEs=f6pqjL2KKA@mail.gmail.com>
Subject: Re: [RFC PATCH 4/6] kernel: faster queue spinlock implementation
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>, "Paul E. McKenney" <paulmck@us.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 1:55 PM, Rik van Riel <riel@redhat.com> wrote:
> There is one thing I do not understand about these locks.

Ah, I need to explain it better then :)

> On 01/22/2013 06:13 PM, Michel Lespinasse wrote:
>> +static inline void
>> +q_spin_unlock(struct q_spinlock *lock, struct q_spinlock_node *node)
>> +{
>> +       q_spin_unlock_mb();     /* guarantee release store semantics */
>> +       ACCESS_ONCE(node->token->wait) = false;
>> +       preempt_enable();
>> +}
>
> Here you set wait to false, in the CPU-local (on the current CPU)
> queue lock token. Afterwards, the same CPU could try to lock another
> lock, using the same token...

No, it won't use the same token. Besically, setting token->wait =
false does two things:
- it indicates to the next waiter (if any) that it doesn't need to spin anymore;
- it releases ownership of the token so that the next thread to
acquire the spinlock (or that may be already spinning on it) can reuse
the token.

>> +DEFINE_PER_CPU(struct q_spinlock_token *, q_spinlock_token[2]);
>> +
>> +static inline struct q_spinlock_token *
>> +____q_spin_lock(struct q_spinlock *lock,
>> +               struct q_spinlock_token **percpu_token)
>>   {
>> +       /*
>> +        * Careful about reentrancy here - if we are interrupted and the
>> code
>> +        * running in that interrupt tries to get another queue spinlock,
>> +        * it must not use the same percpu_token that we're using here.
>> +        */
>> +
>> +       struct q_spinlock_token *token, *prev;
>> +
>> +       token = __this_cpu_read(*percpu_token);
>> +       token->wait = true;
>> +       prev = xchg(&lock->token, token);
>> +       __this_cpu_write(*percpu_token, prev);
>> +       while (ACCESS_ONCE(prev->wait))
>>                 cpu_relax();
>>         q_spin_lock_mb();       /* guarantee acquire load semantics */
>> +       return token;
>>   }
>
> Here a CPU trying to take the lock will spin on the previous
> CPU's token.
>
> However, the previous CPU can immediately re-use its token.

No, they'll use a different token every time.
I think what confused you is that in __q_spin_lock_process(),
percpu_token always points to q_spinlock_token[0]. But that in turns
points to a new token every time (actually points to the token that
was reclaimed on the last spinlock acquisition), so that consecutive
spinlock acquisitions on the same CPU won't keep reusing the same
token.

>> +       token = __this_cpu_read(*percpu_token);

This get the token that was reclaimed during the last spinlock
acquisition. We know the token is available to us, because the
previous spinlock acquisition waited for token->wait to become false,
and this condition got satisfied only when the previous spinlock
holder released ownership of the token.

>> +       __this_cpu_write(*percpu_token, prev);

This stores the token we're waiting on in our per-cpu stash so we can
reuse it on the next spinlock acquisition. It doesn't belong to us
yet, but it will as soon as we're done spinning.

We also have the __q_spin_lock_process() vs __q_spin_lock_bh()
distinction to ensure interrupts won't cause us to reuse per-cpu
tokens before we're done spinning on them.

Hope this helps,

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
