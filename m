Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbbAPPRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 10:17:20 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:54951 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbbAPPRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 10:17:17 -0500
Message-ID: <54B92B71.2090509@gmail.com>
Date: Fri, 16 Jan 2015 16:17:05 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: mtk.manpages@gmail.com, "Carlos O'Donell" <carlos@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        Torvald Riegel <triegel@redhat.com>,
        Roland McGrath <roland@redhat.com>, Darren Hart <dvhart@infradead.org>,
        Anton Blanchard <anton@samba.org>, Petr Baudis <pasky@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        bill o gallmeister <bgallmeister@gmail.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Daniel Wagner <wagi@monom.org>,
        Rich Felker <dalias@libc.org>
Subject: Re: futex(2) man page update help request
References: <537346E5.4050407@gmail.com> <CF98E3EF.90564%dvhart@linux.intel.com> <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com> <5373D0CA.2050204@redhat.com> <alpine.DEB.2.02.1405150121230.6261@ionos.tec.linutronix.de> <CAKgNAkjQ5Dd_U9OojXdgeforpRevvPHNFAw99kBFPCwHgf7Ggg@mail.gmail.com> <alpine.DEB.2.02.1405151144390.6261@ionos.tec.linutronix.de> <54B7D87C.3090901@gmail.com> <alpine.DEB.2.11.1501152313330.5526@nanos>
In-Reply-To: <alpine.DEB.2.11.1501152313330.5526@nanos>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

On 01/15/2015 11:23 PM, Thomas Gleixner wrote:
> On Thu, 15 Jan 2015, Michael Kerrisk (man-pages) wrote:
>>> [EINVAL] uaddr equal uaddr2. Requeue to same futex.
>>
>> ??? I added this, but does this error not occur only for PI requeues?
> 
> It's equally wrong for normal futexes. And its actually the same code
> checking for this for all variants.

I don't understand "equally wrong" in your reply, I'm sorry. Do you
mean:

a) This error text should be there for both normal and PI requeues
OR
a) This error text should be there for neither normal nor PI requeues

>>> [EDEADLOCK] The futex is already locked by the caller or the kernel 
>>> detected a deadlock scenario in a nested lock chain
>>
>> Added.
> 
> It's actually EDEADLK

Yes, sorry -- I should have said that I already found and fixed 
that problem.

>>> [EOWNERDIED] The owner of the futex died and the kernel made the 
>>> caller the new owner. The kernel sets the FUTEX_OWNER_DIED bit in the
>>> futex userspace value. Caller is responsible for cleanup
>>
>> There is no such thing as an EOWNERDIED error. I had a look
>> through the kernel source for the FUTEX_OWNER_DIED cases and didn't 
>> see an obvious error associated with them. Can you clarify? (I think 
>> the point is that this condition, which is described in
>> Documentation/robust-futexes.txt, is not an error as such. However, I'm
>> not yet sure of how to describe it in the man page.)
>> I will add this point as a FIXME in the new draft man page.
> 
> Oops. My bad. That's not the what the kernel does. The kernel merily
> marks it in the futex itself with FUTEX_OWNER_DIED. User space needs
> to deal with that and the posix users return EOWNERDEAD (not
> EOWNERDIED], so it's not part of the futex call itself.
> 
> We had discussions about returning EOWNERDEAD in that case, but then
> glibc with its sophisticated error handling prevented that ....

Okay. I'll add a FIXME to the draft page, to see if we get some good 
text together to describe FUTEX_OWNER_DIED and how it is used.

>>> FUTEX_TRYLOCK_PI
>>>
>>> This operation tries to acquire the futex at uaddr. It deals with the
>>> situation where the TID value at uaddr is 0, but the FUTEX_HAS_WAITER
>>> bit is set. User space cannot handle this race free.
>>
>> Added.
>>
>>> The arguments uaddr2, val, timeout and val3 are ignored.
>>
>> ??? But the code reads:
>>
>>         case FUTEX_TRYLOCK_PI:
>>                 return futex_lock_pi(uaddr, flags, 0, timeout, 1);
>>  
>> which momentarily misleads one into thinking that 'timeout' is used.
>> And: it's not quite ignored, since in futex_lock_pi() a non-NULL
>> 'timeout' is unconditionally dereferenced (meaning you could get
>> an EFAULT error for a bad 'timeout' pointer).
>> I'm confused....
> 
> Indeed. That's just wrong.
>  
>> Maybe the above code should be
>>
>>         case FUTEX_TRYLOCK_PI:
>>                 return futex_lock_pi(uaddr, flags, 0, NULL, 1);
>> ?
> 
> Care to send a patch?

Will do.
  
[...]

>> ??? I don't believe this can happen. 'val3' is internally set to
>> FUTEX_BITSET_MATCH_ANY. Can you confirm?
> 
> Right. We dont support that bitset stuff in requeue_pi ATM.

Thanks for the confirmation.

Cheers,

Michael



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
