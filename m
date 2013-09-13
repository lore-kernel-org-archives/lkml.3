Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab3IMJVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 05:21:18 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:42566 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752024Ab3IMJVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 05:21:15 -0400
Message-ID: <5232D904.5030500@vmware.com>
Date: Fri, 13 Sep 2013 11:21:08 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Peter Zijlstra <peterz@infradead.org>, Dave Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] completely bonkers use of set_need_resched + VM_FAULT_NOPAGE
References: <20130912150645.GZ31370@twins.programming.kicks-ass.net> <CAKMK7uFF2GkYapa2_DLv4WYAd0t+POaT+Vy9HG=HQhzMmtH9nA@mail.gmail.com> <5231E18D.7070306@canonical.com> <5231EF5A.7010901@vmware.com> <52323734.4070908@canonical.com> <5232B44C.9010408@vmware.com> <5232BBE1.5030509@canonical.com> <5232C2BB.9070303@vmware.com> <5232C3E8.2050501@canonical.com> <5232CB66.6000906@vmware.com> <5232D399.7090703@canonical.com>
In-Reply-To: <5232D399.7090703@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2013 10:58 AM, Maarten Lankhorst wrote:
> Op 13-09-13 10:23, Thomas Hellstrom schreef:
>> On 09/13/2013 09:51 AM, Maarten Lankhorst wrote:
>>> Op 13-09-13 09:46, Thomas Hellstrom schreef:
>>>> On 09/13/2013 09:16 AM, Maarten Lankhorst wrote:
>>>>> Op 13-09-13 08:44, Thomas Hellstrom schreef:
>>>>>> On 09/12/2013 11:50 PM, Maarten Lankhorst wrote:
>>>>>>> Op 12-09-13 18:44, Thomas Hellstrom schreef:
>>>>>>>> On 09/12/2013 05:45 PM, Maarten Lankhorst wrote:
>>>>>>>>> Op 12-09-13 17:36, Daniel Vetter schreef:
>>>>>>>>>> On Thu, Sep 12, 2013 at 5:06 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>>>>>>>>>>> So I'm poking around the preemption code and stumbled upon:
>>>>>>>>>>>
>>>>>>>>>>> drivers/gpu/drm/i915/i915_gem.c:                set_need_resched();
>>>>>>>>>>> drivers/gpu/drm/ttm/ttm_bo_vm.c:                        set_need_resched();
>>>>>>>>>>> drivers/gpu/drm/ttm/ttm_bo_vm.c:                        set_need_resched();
>>>>>>>>>>> drivers/gpu/drm/udl/udl_gem.c:          set_need_resched();
>>>>>>>>>>>
>>>>>>>>>>> All these sites basically do:
>>>>>>>>>>>
>>>>>>>>>>>        while (!trylock())
>>>>>>>>>>>              yield();
>>>>>>>>>>>
>>>>>>>>>>> which is a horrible and broken locking pattern.
>>>>>>>>>>>
>>>>>>>>>>> Firstly its deadlock prone, suppose the faulting process is a FIFOn+1
>>>>>>>>>>> task that preempted the lock holder at FIFOn.
>>>>>>>>>>>
>>>>>>>>>>> Secondly the implementation is worse than usual by abusing
>>>>>>>>>>> VM_FAULT_NOPAGE, which is supposed to install a PTE so that the fault
>>>>>>>>>>> doesn't retry, but you're using it as a get out of fault path. And
>>>>>>>>>>> you're using set_need_resched() which is not something a driver should
>>>>>>>>>>> _ever_ touch.
>>>>>>>>>>>
>>>>>>>>>>> Now I'm going to take away set_need_resched() -- and while you can
>>>>>>>>>>> 'reimplement' it using set_thread_flag() you're not going to do that
>>>>>>>>>>> because it will be broken due to changes to the preempt code.
>>>>>>>>>>>
>>>>>>>>>>> So please as to fix ASAP and don't allow anybody to trick you into
>>>>>>>>>>> merging silly things like that again ;-)
>>>>>>>>>> The set_need_resched in i915_gem.c:i915_gem_fault can actually be
>>>>>>>>>> removed. It was there to give the error handler a chance to sneak in
>>>>>>>>>> and reset the hw/sw tracking when the gpu is dead. That hack goes back
>>>>>>>>>> to the days when the locking around our error handler was somewhere
>>>>>>>>>> between nonexistent and totally broken, nowadays we keep things from
>>>>>>>>>> live-locking by a bit of magic in i915_mutex_lock_interruptible. I'll
>>>>>>>>>> whip up a patch to rip this out. I'll also check that our testsuite
>>>>>>>>>> properly exercises this path (needs a bit of work on a quick look for
>>>>>>>>>> better coverage).
>>>>>>>>>>
>>>>>>>>>> The one in ttm is just bonghits to shut up lockdep: ttm can recurse
>>>>>>>>>> into it's own pagefault handler and then deadlock, the trylock just
>>>>>>>>>> keeps lockdep quiet. We've had that bug arise in drm/i915 due to some
>>>>>>>>>> fun userspace did and now have testcases for them. The right solution
>>>>>>>>>> to fix this is to use copy_to|from_user_atomic in ttm everywhere it
>>>>>>>>>> holds locks and have slowpaths which drops locks, copies stuff into a
>>>>>>>>>> temp allocation and then continues. At least that's how we've fixed
>>>>>>>>>> all those inversions in i915-gem. I'm not volunteering to fix this ;-)
>>>>>>>>> Ah the case where a mmap'd address is passed to the execbuf ioctl? :P
>>>>>>>>>
>>>>>>>>> Fine I'll look into it a bit, hopefully before tuesday. Else it might take a bit longer since I'll be on my way to plumbers..
>>>>>>>> I think a possible fix would be if fault() were allowed to return an error and drop the mmap_sem() before returning.
>>>>>>>>
>>>>>>>> Otherwise we need to track down all copy_to_user / copy_from_user which happen with bo::reserve held.
>>>>>> Actually, from looking at the mm code, it seems OK to do the following:
>>>>>>
>>>>>> if (!bo_tryreserve()) {
>>>>>>        up_read mmap_sem(); // Release the mmap_sem to avoid deadlocks.
>>>>>>        bo_reserve();               // Wait for the BO to become available (interruptible)
>>>>>>        bo_unreserve();           // Where is bo_wait_unreserved() when we need it, Maarten :P
>>>>>>        return VM_FAULT_RETRY; // Go ahead and retry the VMA walk, after regrabbing
>>>>>> }
>>>>> Is this meant as a jab at me? You're doing locking wrong here! Again!
>>>> It's not meant as a jab at you.  I'm sorry if it came out that way. It was meant as a joke. I wasn't aware the topic was sensitive.
>>>>
>>>> Anyway, could you describe what is wrong, with the above solution, because it seems perfectly legal to me.
>>>> There is no substantial overhead, and there is no risc of deadlocks. Or do you mean it's bad because it confuses lockdep?
>>> Evil userspace can pass a bo as pointer to use for relocation lists, lockdep will warn when that locks up, but still..
>>> This is already a problem now, and your fixing will only cause lockdep to explicitly warn on it.
>> As previously mentioned, copy_from_user should return -EFAULT, since the VMAs are marked with VM_IO. It should not recurse into fault(), so evil user-space looses.
>>
>>> You can make a complicated user program to test this, or simply use this function for debugging:
>>> void ttm_might_fault(void) { struct reservation_object obj; reservation_object_init(&obj); ww_mutex_lock(&obj.lock, NULL); ww_mutex_unlock(&obj.lock); reservation_object_fini(&obj); }
>>>
>>> Put it near every instance of copy_to_user/copy_from_user and you'll find the bugs. :)
>> I'm still not convinced that there are any problems with this solution. Did you take what's said above into account?


8<---------------------------------------------------------------------------------------

>>
>> Now, could we try to approach this based on pros and cons? Let's say we would be able to choose locking order without doing anything ugly. I'd put it like this:
>>
>> mmap_sem->bo_reserve:
>> Good: Native locking order of VM subsystem. Good if we in the future will need to reserve in mmap().
>> Bad: pwrite, pread, copy_to user, copy_from_user usage needs a slowpath that releases all locking, which has to be done in multiple places in multiple drivers. Grabbing the mmap_sem and then waiting for multiple possibly sleeping bo_reserves in slow paths will stall VMA write operations for this MM.
> I think the good offsets the bad a million times here. Just because it's harder.
>
>> bo_reserve->mmap_sem:
>> Good: Natural locking order for all driver ioctls. Slowpath needs to be done in a single place, in common code.
>> Bad: Bad if we ever need to perform bo_reserve in mmap.
> Considering you're open coding a mutex_lock with the reserve/unreserve+trylock, I think this is a horrible approach. The possibility of a deadlock still exists too. :(

8<---------------------------------------------------------------------------

Maarten, the above section was intended to discuss the benefits of 
different locking orders, assuming, as stated, that there
was a legitimatate solution to either choice.
Wording like "it's better bacause it's harder", "your implementation is 
horrible", "half-assed" doesn't really add much.

I still think, from a code maintenance point of view that the 
bo:reserve->mmap_sem locking order is superior, since we don't have the 
same tools that the Intel guys have. But implementation doesn't seem 
feasible ATM, both because as Peter pointed out, the pattern is 
non-deterministic, and as Daniel correctly pointed out, the copy_xx_user 
paths use regular page-faults, which makes recursion possible.

So I guess we need to take the mmap_sem->bo:reserve route after all.

/Thomas





>> In my view we have a clear winner. Given the problems i915 had when converting their driver, and the bashing they had to withstand, we have an even clearer winner.
>>
>> And then we need to take into account that, (given that I understand things correctly) lockdep will complain because it thinks there is a recursion that will never happen.
>> That will make the bo_reserve->mmap_sem solution look bad, but is this really enough to justify giving it up?
>>
>> /Thomas
>>
