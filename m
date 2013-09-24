Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab3IXKeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 06:34:06 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:53894 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753231Ab3IXKeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 06:34:04 -0400
Message-ID: <52416A96.6040802@vmware.com>
Date: Tue, 24 Sep 2013 12:33:58 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: Peter Zijlstra <peterz@infradead.org>, Dave Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ben Skeggs <bskeggs@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [RFC PATCH] drm/nouveau: fix nested locking in mmap handler
References: <5232B44C.9010408@vmware.com> <5232BBE1.5030509@canonical.com> <5232C2BB.9070303@vmware.com> <20130913082933.GH31370@twins.programming.kicks-ass.net> <CAKMK7uHh_pKh1JpQ_nA7gvWMUsvQoTKAcBXpdcwpVGSddHE9mQ@mail.gmail.com> <20130913090000.GJ31370@twins.programming.kicks-ass.net> <52405F3E.4000609@canonical.com> <52413DA9.4050000@vmware.com> <5241409B.6010102@canonical.com> <52415569.6020602@vmware.com> <20130924093620.GA14003@phenom.ffwll.local> <52416556.7030208@canonical.com>
In-Reply-To: <52416556.7030208@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 12:11 PM, Maarten Lankhorst wrote:
> Op 24-09-13 11:36, Daniel Vetter schreef:
>> On Tue, Sep 24, 2013 at 11:03:37AM +0200, Thomas Hellstrom wrote:
>>> On 09/24/2013 09:34 AM, Maarten Lankhorst wrote:
>>>> Op 24-09-13 09:22, Thomas Hellstrom schreef:
>>>>> On 09/23/2013 05:33 PM, Maarten Lankhorst wrote:
>>>>>> Hey,
>>>>>>
>>>>>> Op 13-09-13 11:00, Peter Zijlstra schreef:
>>>>>>> On Fri, Sep 13, 2013 at 10:41:54AM +0200, Daniel Vetter wrote:
>>>>>>>> On Fri, Sep 13, 2013 at 10:29 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>>>>>>>> On Fri, Sep 13, 2013 at 09:46:03AM +0200, Thomas Hellstrom wrote:
>>>>>>>>>>>> if (!bo_tryreserve()) {
>>>>>>>>>>>>       up_read mmap_sem(); // Release the mmap_sem to avoid deadlocks.
>>>>>>>>>>>>       bo_reserve();               // Wait for the BO to become available (interruptible)
>>>>>>>>>>>>       bo_unreserve();           // Where is bo_wait_unreserved() when we need it, Maarten :P
>>>>>>>>>>>>       return VM_FAULT_RETRY; // Go ahead and retry the VMA walk, after regrabbing
>>>>>>>>>>>> }
>>>>>>>>>> Anyway, could you describe what is wrong, with the above solution, because
>>>>>>>>>> it seems perfectly legal to me.
>>>>>>>>> Luckily the rule of law doesn't have anything to do with this stuff --
>>>>>>>>> at least I sincerely hope so.
>>>>>>>>>
>>>>>>>>> The thing that's wrong with that pattern is that its still not
>>>>>>>>> deterministic - although its a lot better than the pure trylock. Because
>>>>>>>>> you have to release and re-acquire with the trylock another user might
>>>>>>>>> have gotten in again. Its utterly prone to starvation.
>>>>>>>>>
>>>>>>>>> The acquire+release does remove the dead/life-lock scenario from the
>>>>>>>>> FIFO case, since blocking on the acquire will allow the other task to
>>>>>>>>> run (or even get boosted on -rt).
>>>>>>>>>
>>>>>>>>> Aside from that there's nothing particularly wrong with it and lockdep
>>>>>>>>> should be happy afaict (but I haven't had my morning juice yet).
>>>>>>>> bo_reserve internally maps to a ww-mutex and task can already hold
>>>>>>>> ww-mutex (potentially even the same for especially nasty userspace).
>>>>>>> OK, yes I wasn't aware of that. Yes in that case you're quite right.
>>>>>>>
>>>>>> I added a RFC patch below.  I only tested with PROVE_LOCKING, and always forced the slowpath for debugging.
>>>>>>
>>>>>> This fixes nouveau and core ttm to always use blocking acquisition in fastpath.
>>>>>> Nouveau was a bit of a headache, but afaict it should work.
>>>>>>
>>>>>> In almost all cases relocs are not updated, so I kept intact the fastpath
>>>>>> of not copying relocs from userspace. The slowpath tries to copy it atomically,
>>>>>> and if that fails it will unreserve all bo's and copy everything.
>>>>>>
>>>>>> One thing to note is that the command submission ioctl may fail now with -EFAULT
>>>>>> if presumed cannot be updated, while the commands are submitted succesfully.
>>>>> I think the Nouveau guys need to comment further on this, but returning -EFAULT might break existing user-space, and that's not allowed, but IIRC the return value of "presumed" is only a hint, and if it's incorrect will only trigger future command stream patching.
>>>>>
>>>>> Otherwise reviewing mostly the TTM stuff. FWIW, from wat I can tell the vmwgfx driver doesn't need any fixups.
>>>> Well because we read the list of buffer objects the presumed offsets are at least read-mapped. Although I guess in the worst case the mapping might disappear before the syscall copies back the data.
>>>> So if -EFAULT happens here then userspace messed up in some way, either by forgetting to map the offsets read-write, which cannot happen with libdrm or free'ing the bo list before the syscall returns,
>>>> which would probably result in libdrm crashing shortly afterwards anyway.
>>> Hmm, is the list of buffer objects (and the "presumed" members)
>>> really in DRM memory? Because if it resides or may reside in
>>> anonymous system memory, it may well be paged out between reading
>>> and writing, in which case the -EFAULT return is incorrect.
>>>
>>> In fact failures of pushbuf / execbuf *after* commands are
>>> successfully submitted are generally very hard to recover from.
>>> That's why the kernel should do whatever it takes to recover from
>>> such failures, and user-space should do whatever it takes to recover
>>> from copy-to-user failures of needed info from the kernel, and it
>>> really depends on the user-space usage pattern of "presumed". IIRC
>>> the original reason for copying it back to user-space was, that if a
>>> relocation offsets were patched up by the kernel, and then the
>>> process was sent a signal causing it to retry execbuf, then
>>> "presumed" had to be updated, otherwise it would be inconsistent
>>> with what's currently in the command stream, which is very bad. If
>>> "presumed" is, however, only used by user-space to guess an offset,
>>> the correct action would be to swallow the -EFAULT.
>> In i915 we've had tons of fun with a regression in 3.7 where exactly this
>> blows up: Some of our userspace (UXA ddx specifically) retains
>> relocations-trees partially accross an execbuf. Which means if the kernel
>> updates the relocations it _must_ update the presumed offset for
>> otherwise things will go haywire on the next execbuf. So we can't return
>> -EFAULT if the userspace memory needs to be just refaulted but still need
>> to guarante a "correct" presumed offset.
>>
>> Since we didn't come up with a way to make sure this will work in all
>> cases when we get an -EFAULT when writing back presumed offsets we have a
>> rather tricky piece of fallback logic.
>> - Any -EFAULT error in the fastpath will drop us into the relocation
>>    slowpath. The slowpath completly processes relocs anew, so any updates
>>    done by the fastpath are irrelevant.
>>
>> - The first thing the slowpath does is set the presumed offset in the
>>    userspace reloc lists to an invalid address (we pick -1) to make sure
>>    that any subsequent execbuf with the same partial reloc tree will again
>>    go through the relocation update code.
>>
>> - Then we do the usual slowpath, i.e. copy relocs from userspace, re-grab
>>    locks and then process them. The copy-back of the presumed offset
>>    happens with an copy_to_user_inatomic, and we ignore any errors.
>>
>> Of course we try really hard to make sure that we never hit the reloc
>> slowpath ;-) But nowadays this is all fully tested with some nasty
>> testcases (and a small kernel option to disable prefaulting).
>>
> It seems userspace only updates offset and domain in nouveau. If it fails to update
> it would result in the same affect as when the buffer gets moved around by TTM.
> But hey maybe I'll have some fun, I'll lie to userspace, hardcode userspace offset
> to 0x40000000, always force domain to be different and see what breaks.
>
> My guess is absolutely nothing, except it might expose some bugs where we forgot annotation..
I think that would certainly break if your return an -ERESTARTSYS after 
applying relocations but
before submitting the command stream to hardware....

/Thomas

>
> ~Maarten
