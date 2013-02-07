Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab3BGX6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 18:58:24 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:57201 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab3BGX6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 18:58:22 -0500
MIME-Version: 1.0
In-Reply-To: <1360277809.28557.60.camel@edumazet-glaptop>
References: <1358896415-28569-1-git-send-email-walken@google.com>
	<1358896415-28569-2-git-send-email-walken@google.com>
	<20130207223434.GG2545@linux.vnet.ibm.com>
	<1360277809.28557.60.camel@edumazet-glaptop>
Date: Thu, 7 Feb 2013 15:58:20 -0800
Message-ID: <CANN689G0N0ynSMVcH9CbOFgL_mLSswOBx5yBzPBag0AO9fk8+A@mail.gmail.com>
Subject: Re: [RFC PATCH 1/6] kernel: implement queue spinlock API
From: Michel Lespinasse <walken@google.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 2:56 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Thu, 2013-02-07 at 14:34 -0800, Paul E. McKenney wrote:
>> On Tue, Jan 22, 2013 at 03:13:30PM -0800, Michel Lespinasse wrote:
>> > Introduce queue spinlocks, to be used in situations where it is desired
>> > to have good throughput even under the occasional high-contention situation.
>> >
>> > This initial implementation is based on the classic MCS spinlock,
>> > because I think this represents the nicest API we can hope for in a
>> > fast queue spinlock algorithm. The MCS spinlock has known limitations
>> > in that it performs very well under high contention, but is not as
>> > good as the ticket spinlock under low contention. I will address these
>> > limitations in a later patch, which will propose an alternative,
>> > higher performance implementation using (mostly) the same API.
>> >
>> > Sample use case acquiring mystruct->lock:
>> >
>> >   struct q_spinlock_node node;
>> >
>> >   q_spin_lock(&mystruct->lock, &node);
>> >   ...
>> >   q_spin_unlock(&mystruct->lock, &node);
>>
>> It is possible to keep the normal API for MCS locks by having the lock
>> holder remember the parameter in the lock word itself.  While spinning,
>> the node is on the stack, is not needed once the lock is acquired.
>> The pointer to the next node in the queue -is- needed, but this can be
>> stored in the lock word.
>>
>> I believe that John Stultz worked on something like this some years back,
>> so added him to CC.
>>
>
> Hmm...
>
> This could easily break if the spin_lock() is embedded in a function,
> and the unlock done in another one.
>
> (storage for the node would disappear at function epilogue )

No, I think that's doable. The trick would be that once a thread
acquires the lock, the only remaining use of the node is to receive
the 'next' pointer if/when another thread starts contending for the
lock. So if the lock state would need to distinguish between a lock
that is currently locked but not contended (the next value would then
be NULL), and a lock that is currently locked and contended (the
lock->next value is the node that goes after the current lock owner)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
