Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab3IMFd0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 01:33:26 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:44104 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668Ab3IMFdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 01:33:24 -0400
Message-ID: <5232A39B.5040205@vmware.com>
Date: Fri, 13 Sep 2013 07:33:15 +0200
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
References: <20130912150645.GZ31370@twins.programming.kicks-ass.net> <CAKMK7uFF2GkYapa2_DLv4WYAd0t+POaT+Vy9HG=HQhzMmtH9nA@mail.gmail.com> <5231E18D.7070306@canonical.com> <5231EF5A.7010901@vmware.com> <52323734.4070908@canonical.com>
In-Reply-To: <52323734.4070908@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 11:50 PM, Maarten Lankhorst wrote:
> Op 12-09-13 18:44, Thomas Hellstrom schreef:
>> On 09/12/2013 05:45 PM, Maarten Lankhorst wrote:
>>> Op 12-09-13 17:36, Daniel Vetter schreef:
>>>> On Thu, Sep 12, 2013 at 5:06 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>>>>> So I'm poking around the preemption code and stumbled upon:
>>>>>
>>>>> drivers/gpu/drm/i915/i915_gem.c:                set_need_resched();
>>>>> drivers/gpu/drm/ttm/ttm_bo_vm.c:                        set_need_resched();
>>>>> drivers/gpu/drm/ttm/ttm_bo_vm.c:                        set_need_resched();
>>>>> drivers/gpu/drm/udl/udl_gem.c:          set_need_resched();
>>>>>
>>>>> All these sites basically do:
>>>>>
>>>>>     while (!trylock())
>>>>>           yield();
>>>>>
>>>>> which is a horrible and broken locking pattern.
>>>>>
>>>>> Firstly its deadlock prone, suppose the faulting process is a FIFOn+1
>>>>> task that preempted the lock holder at FIFOn.
>>>>>
>>>>> Secondly the implementation is worse than usual by abusing
>>>>> VM_FAULT_NOPAGE, which is supposed to install a PTE so that the fault
>>>>> doesn't retry, but you're using it as a get out of fault path. And
>>>>> you're using set_need_resched() which is not something a driver should
>>>>> _ever_ touch.
>>>>>
>>>>> Now I'm going to take away set_need_resched() -- and while you can
>>>>> 'reimplement' it using set_thread_flag() you're not going to do that
>>>>> because it will be broken due to changes to the preempt code.
>>>>>
>>>>> So please as to fix ASAP and don't allow anybody to trick you into
>>>>> merging silly things like that again ;-)
>>>> The set_need_resched in i915_gem.c:i915_gem_fault can actually be
>>>> removed. It was there to give the error handler a chance to sneak in
>>>> and reset the hw/sw tracking when the gpu is dead. That hack goes back
>>>> to the days when the locking around our error handler was somewhere
>>>> between nonexistent and totally broken, nowadays we keep things from
>>>> live-locking by a bit of magic in i915_mutex_lock_interruptible. I'll
>>>> whip up a patch to rip this out. I'll also check that our testsuite
>>>> properly exercises this path (needs a bit of work on a quick look for
>>>> better coverage).
>>>>
>>>> The one in ttm is just bonghits to shut up lockdep: ttm can recurse
>>>> into it's own pagefault handler and then deadlock, the trylock just
>>>> keeps lockdep quiet. We've had that bug arise in drm/i915 due to some
>>>> fun userspace did and now have testcases for them. The right solution
>>>> to fix this is to use copy_to|from_user_atomic in ttm everywhere it
>>>> holds locks and have slowpaths which drops locks, copies stuff into a
>>>> temp allocation and then continues. At least that's how we've fixed
>>>> all those inversions in i915-gem. I'm not volunteering to fix this ;-)
>>> Ah the case where a mmap'd address is passed to the execbuf ioctl? :P
>>>
>>> Fine I'll look into it a bit, hopefully before tuesday. Else it might take a bit longer since I'll be on my way to plumbers..
>> I think a possible fix would be if fault() were allowed to return an error and drop the mmap_sem() before returning.
>>
>> Otherwise we need to track down all copy_to_user / copy_from_user which happen with bo::reserve held.
> CONFIG_PROVE_LOCKING=y
>
> and hard grab that reserve lock within the fault handler, done.. lockdep will spit it out for you :p
>
> ~Maarten

Given that all copy_to_user / copy_from_user paths are actually hit 
during testing, right?

/Thomas
