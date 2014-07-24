Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbaGXWPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 18:15:23 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:59839 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaGXWPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 18:15:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21457.33657.540940.996259@quad.stoffel.home>
Date: Thu, 24 Jul 2014 18:06:49 -0400
From: "John Stoffel" <john@stoffel.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-input\@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: Linux 3.16-rc6
In-Reply-To: <53D16EC4.1000801@hp.com>
References: <CA+55aFzJKxzw_as9iGgeM=MdQ6trUkQLDuoEr8nxj88sOqQnQA@mail.gmail.com>
	<20140723095327.GA23131@pd.tnic>
	<CA+55aFzPs4uF=eR7jCnpyBtgWNRkX-uDfXeo5u34VEvT8_yyzw@mail.gmail.com>
	<20140724064353.GW9918@twins.programming.kicks-ass.net>
	<20140724084126.GB19239@pd.tnic>
	<20140724122513.GM19239@pd.tnic>
	<20140724125814.GX6758@twins.programming.kicks-ass.net>
	<CA+55aFynW5xSRQvY6xO+mxmt6yh7mFkMjy-pgJXpXNy8qDMcPA@mail.gmail.com>
	<20140724183643.GM3935@laptop>
	<53D16EC4.1000801@hp.com>
X-Mailer: VM 8.2.0b under 23.4.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Waiman" == Waiman Long <waiman.long@hp.com> writes:

Waiman> On 07/24/2014 02:36 PM, Peter Zijlstra wrote:
>> On Thu, Jul 24, 2014 at 11:18:16AM -0700, Linus Torvalds wrote:
>>> On Thu, Jul 24, 2014 at 5:58 AM, Peter Zijlstra<peterz@infradead.org>  wrote:
>>>> So going by the nifty picture rostedt made:
>>>> 
>>>> [   61.454336]        CPU0                    CPU1
>>>> [   61.454336]        ----                    ----
>>>> [   61.454336]   lock(&(&p->alloc_lock)->rlock);
>>>> [   61.454336]                                local_irq_disable();
>>>> [   61.454336]                                lock(tasklist_lock);
>>>> [   61.454336]                                lock(&(&p->alloc_lock)->rlock);
>>>> [   61.454336]<Interrupt>
>>>> [   61.454336]     lock(tasklist_lock);
>>> So this *should* be fine. It always has been in the past, and it was
>>> certainly the *intention* that it should continue to work with
>>> qrwlock, even in the presense of pending writers on other cpu's.
>>> 
>>> The qrwlock rules are that a read-lock in an interrupt is still going
>>> to be unfair and succeed if there are other readers.
>> Ah, indeed. Should have checked :/
>> 
>>> So it sounds to me like the new lockdep rules in tip/master are too
>>> strict and are throwing a false positive.
>> Right. Waiman can you have a look?

Waiman> Yes, I think I may have a solution for that.

Waiman> Borislav, can you apply the following patch on top of the lockdep patch 
Waiman> to see if it can fix the problem?

Waiman> diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
Waiman> index d24e433..507a8ce 100644
Waiman> --- a/kernel/locking/lockdep.c
Waiman> +++ b/kernel/locking/lockdep.c
Waiman> @@ -3595,6 +3595,12 @@ void lock_acquire(struct lockdep_map *lock, 
Waiman> unsigned int
Waiman>          raw_local_irq_save(flags);
Waiman>          check_flags(flags);

Waiman> +       /*
Waiman> +        * An interrupt recursive read in interrupt context can be 
Waiman> considered
Waiman> +        * to be the same as a recursive read from checking perspective.
Waiman> +        */
Waiman> +       if ((read == 3) && in_interrupt())
Waiman> +               read = 2;
current-> lockdep_recursion = 1;
Waiman>          trace_lock_acquire(lock, subclass, trylock, read, check, 
Waiman> nest_lock, ip);
Waiman>          __lock_acquire(lock, subclass, trylock, read, check,

Instead of the magic numbers 1,2,3, could you use some nicely named
constants here instead?  

John
