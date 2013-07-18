Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983Ab3GRNk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 09:40:29 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:47471 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab3GRNk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 09:40:27 -0400
Message-ID: <51E7F03A.4090305@hp.com>
Date: Thu, 18 Jul 2013 09:40:10 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH RFC 1/2] qrwlock: A queue read/write lock implementation
References: <1373679249-27123-1-git-send-email-Waiman.Long@hp.com> <1373679249-27123-2-git-send-email-Waiman.Long@hp.com> <alpine.DEB.2.02.1307151657540.11918@ionos.tec.linutronix.de> <51E49FA3.4030202@hp.com> <20130718074204.GA22623@gmail.com>
In-Reply-To: <20130718074204.GA22623@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2013 03:42 AM, Ingo Molnar wrote:
> * Waiman Long<waiman.long@hp.com>  wrote:
>
>>>> + *    stealing the lock if come at the right moment, the granting of the
>>>> + *    lock is mostly in FIFO order.
>>>> + * 2. It is faster in high contention situation.
>>> Again, why is it faster?
>> The current rwlock implementation suffers from a thundering herd
>> problem. When many readers are waiting for the lock hold by a writer,
>> they will all jump in more or less at the same time when the writer
>> releases the lock. That is not the case with qrwlock. It has been shown
>> in many cases that avoiding this thundering herd problem can lead to
>> better performance.
> Btw., it's possible to further optimize this "writer releases the lock to
> multiple readers spinning" thundering herd scenario in the classic
> read_lock() case, without changing the queueing model.
>
> Right now read_lock() fast path is a single atomic instruction. When a
> writer releases the lock then it makes it available to all readers and
> each reader will execute a LOCK DEC instruction which will succeed.
>
> This is the relevant code in arch/x86/lib/rwlock.S [edited for
> readability]:
>
> __read_lock_failed():
>
> 0:      LOCK_PREFIX
>          READ_LOCK_SIZE(inc) (%__lock_ptr)
>
> 1:      rep; nop
>          READ_LOCK_SIZE(cmp) $1, (%__lock_ptr)
>          js      1b
>
>          LOCK_PREFIX READ_LOCK_SIZE(dec) (%__lock_ptr)
>          js      0b
>
>          ret
>
> This is where we could optimize: instead of signalling to each reader that
> it's fine to decrease the count and letting dozens of readers do that on
> the same cache-line, which ping-pongs around the numa cross-connect
> touching every other CPU as they execute the LOCK DEC instruction, we
> could let the _writer_ modify the count on unlock in essence, to the exact
> value that readers expect.
>
> Since read_lock() can never abort this should be relatively
> straightforward: the INC above could be left out, and the writer side
> needs to detect that there are no other writers waiting and can set the
> count to 'reader locked' value - which the readers will detect without
> modifying the cache line:
>
> __read_lock_failed():
>
> 0:      rep; nop
>          READ_LOCK_SIZE(cmp) $1, (%__lock_ptr)
>          js      0b
>
>          ret
>
> (Unless I'm missing something that is.)
>
> That way the current write_unlock() followed by a 'thundering herd' of
> __read_lock_failed() atomic accesses is transformed into an efficient
> read-only broadcast of information with only a single update to the
> cacheline: the writer-updated cacheline propagates in parallel to every
> CPU and is cached there.
>
> On typical hardware this will be broadcast to all CPUs as part of regular
> MESI invalidation bus traffic.
>
> reader unlock will still have to modify the cacheline, so rwlocks will
> still have a fundamental scalability limit even in the read-only usecase.

I think that will work. The only drawback that I can see is the fairness 
argument. The current read/write lock implementation is unfair to the 
writer. That change will make it even more unfair to the writer and 
there is no easy way to detect a waiting writer unless we change the 
structure to add such a field. As a result, a steady stream of readers 
will have a higher chance of blocking out a writer indefinitely.

Regards,
Longman
