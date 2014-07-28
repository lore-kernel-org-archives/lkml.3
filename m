Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751050AbaG1QhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:37:22 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:54129 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbaG1QhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:37:21 -0400
Message-ID: <53D67C3A.1060401@hp.com>
Date: Mon, 28 Jul 2014 12:37:14 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: Linux 3.16-rc6
References: <CA+55aFzJKxzw_as9iGgeM=MdQ6trUkQLDuoEr8nxj88sOqQnQA@mail.gmail.com> <20140723095327.GA23131@pd.tnic> <CA+55aFzPs4uF=eR7jCnpyBtgWNRkX-uDfXeo5u34VEvT8_yyzw@mail.gmail.com> <20140724064353.GW9918@twins.programming.kicks-ass.net> <20140724084126.GB19239@pd.tnic> <20140724122513.GM19239@pd.tnic> <20140724125814.GX6758@twins.programming.kicks-ass.net> <CA+55aFynW5xSRQvY6xO+mxmt6yh7mFkMjy-pgJXpXNy8qDMcPA@mail.gmail.com> <20140724183643.GM3935@laptop> <53D16EC4.1000801@hp.com> <20140725161002.GE6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140725161002.GE6758@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2014 12:10 PM, Peter Zijlstra wrote:
> On Thu, Jul 24, 2014 at 04:38:28PM -0400, Waiman Long wrote:
>> Yes, I think I may have a solution for that.
>>
>> Borislav, can you apply the following patch on top of the lockdep patch to
>> see if it can fix the problem?
>>
>> diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
>> index d24e433..507a8ce 100644
>> --- a/kernel/locking/lockdep.c
>> +++ b/kernel/locking/lockdep.c
>> @@ -3595,6 +3595,12 @@ void lock_acquire(struct lockdep_map *lock, unsigned int
>>          raw_local_irq_save(flags);
>>          check_flags(flags);
>>
>> +       /*
>> +        * An interrupt recursive read in interrupt context can be considered
>> +        * to be the same as a recursive read from checking perspective.
>> +        */
>> +       if ((read == 3)&&  in_interrupt())
>> +               read = 2;
>>          current->lockdep_recursion = 1;
>>          trace_lock_acquire(lock, subclass, trylock, read, check, nest_lock, ip);
>>          __lock_acquire(lock, subclass, trylock, read, check,
> Just had another look at the initial patch and it cannot be right, even
> with the above.
>
> The problem is you cannot use in_interrupt() in check_deadlock().
> Check_deadlock() must be context invariant, it should only test the
> chain state and not rely on where or when its called.
>
>

I am planning to take out the check in check_deadlock and only have the 
test in lock_acquire which change a 3 to 2 when in interrupt context. 
Now my question is whether to do it as a new patch on top of the 
existing one in tip or a total replacement. I also intend to use 
symbolic names for the read states for better readability as suggested 
by John.

-Longman
