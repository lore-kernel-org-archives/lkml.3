Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934652AbaGXUie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 16:38:34 -0400
Received: from g2t2353.austin.hp.com ([15.217.128.52]:42724 "EHLO
	g2t2353.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176AbaGXUid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 16:38:33 -0400
Message-ID: <53D16EC4.1000801@hp.com>
Date: Thu, 24 Jul 2014 16:38:28 -0400
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
References: <CA+55aFzJKxzw_as9iGgeM=MdQ6trUkQLDuoEr8nxj88sOqQnQA@mail.gmail.com> <20140723095327.GA23131@pd.tnic> <CA+55aFzPs4uF=eR7jCnpyBtgWNRkX-uDfXeo5u34VEvT8_yyzw@mail.gmail.com> <20140724064353.GW9918@twins.programming.kicks-ass.net> <20140724084126.GB19239@pd.tnic> <20140724122513.GM19239@pd.tnic> <20140724125814.GX6758@twins.programming.kicks-ass.net> <CA+55aFynW5xSRQvY6xO+mxmt6yh7mFkMjy-pgJXpXNy8qDMcPA@mail.gmail.com> <20140724183643.GM3935@laptop>
In-Reply-To: <20140724183643.GM3935@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2014 02:36 PM, Peter Zijlstra wrote:
> On Thu, Jul 24, 2014 at 11:18:16AM -0700, Linus Torvalds wrote:
>> On Thu, Jul 24, 2014 at 5:58 AM, Peter Zijlstra<peterz@infradead.org>  wrote:
>>> So going by the nifty picture rostedt made:
>>>
>>> [   61.454336]        CPU0                    CPU1
>>> [   61.454336]        ----                    ----
>>> [   61.454336]   lock(&(&p->alloc_lock)->rlock);
>>> [   61.454336]                                local_irq_disable();
>>> [   61.454336]                                lock(tasklist_lock);
>>> [   61.454336]                                lock(&(&p->alloc_lock)->rlock);
>>> [   61.454336]<Interrupt>
>>> [   61.454336]     lock(tasklist_lock);
>> So this *should* be fine. It always has been in the past, and it was
>> certainly the *intention* that it should continue to work with
>> qrwlock, even in the presense of pending writers on other cpu's.
>>
>> The qrwlock rules are that a read-lock in an interrupt is still going
>> to be unfair and succeed if there are other readers.
> Ah, indeed. Should have checked :/
>
>> So it sounds to me like the new lockdep rules in tip/master are too
>> strict and are throwing a false positive.
> Right. Waiman can you have a look?

Yes, I think I may have a solution for that.

Borislav, can you apply the following patch on top of the lockdep patch 
to see if it can fix the problem?

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index d24e433..507a8ce 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3595,6 +3595,12 @@ void lock_acquire(struct lockdep_map *lock, 
unsigned int
         raw_local_irq_save(flags);
         check_flags(flags);

+       /*
+        * An interrupt recursive read in interrupt context can be 
considered
+        * to be the same as a recursive read from checking perspective.
+        */
+       if ((read == 3) && in_interrupt())
+               read = 2;
         current->lockdep_recursion = 1;
         trace_lock_acquire(lock, subclass, trylock, read, check, 
nest_lock, ip);
         __lock_acquire(lock, subclass, trylock, read, check,

