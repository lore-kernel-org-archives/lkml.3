Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308Ab3IXHfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 03:35:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33571 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab3IXHfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 03:35:03 -0400
Message-ID: <5241409B.6010102@canonical.com>
Date: Tue, 24 Sep 2013 09:34:51 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Thomas Hellstrom <thellstrom@vmware.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ben Skeggs <bskeggs@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [RFC PATCH] drm/nouveau: fix nested locking in mmap handler
References: <20130912150645.GZ31370@twins.programming.kicks-ass.net> <CAKMK7uFF2GkYapa2_DLv4WYAd0t+POaT+Vy9HG=HQhzMmtH9nA@mail.gmail.com> <5231E18D.7070306@canonical.com> <5231EF5A.7010901@vmware.com> <52323734.4070908@canonical.com> <5232B44C.9010408@vmware.com> <5232BBE1.5030509@canonical.com> <5232C2BB.9070303@vmware.com> <20130913082933.GH31370@twins.programming.kicks-ass.net> <CAKMK7uHh_pKh1JpQ_nA7gvWMUsvQoTKAcBXpdcwpVGSddHE9mQ@mail.gmail.com> <20130913090000.GJ31370@twins.programming.kicks-ass.net> <52405F3E.4000609@canonical.com> <52413DA9.4050000@vmware.com>
In-Reply-To: <52413DA9.4050000@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 24-09-13 09:22, Thomas Hellstrom schreef:
> On 09/23/2013 05:33 PM, Maarten Lankhorst wrote:
>> Hey,
>>
>> Op 13-09-13 11:00, Peter Zijlstra schreef:
>>> On Fri, Sep 13, 2013 at 10:41:54AM +0200, Daniel Vetter wrote:
>>>> On Fri, Sep 13, 2013 at 10:29 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>>>> On Fri, Sep 13, 2013 at 09:46:03AM +0200, Thomas Hellstrom wrote:
>>>>>>>> if (!bo_tryreserve()) {
>>>>>>>>      up_read mmap_sem(); // Release the mmap_sem to avoid deadlocks.
>>>>>>>>      bo_reserve();               // Wait for the BO to become available (interruptible)
>>>>>>>>      bo_unreserve();           // Where is bo_wait_unreserved() when we need it, Maarten :P
>>>>>>>>      return VM_FAULT_RETRY; // Go ahead and retry the VMA walk, after regrabbing
>>>>>>>> }
>>>>>> Anyway, could you describe what is wrong, with the above solution, because
>>>>>> it seems perfectly legal to me.
>>>>> Luckily the rule of law doesn't have anything to do with this stuff --
>>>>> at least I sincerely hope so.
>>>>>
>>>>> The thing that's wrong with that pattern is that its still not
>>>>> deterministic - although its a lot better than the pure trylock. Because
>>>>> you have to release and re-acquire with the trylock another user might
>>>>> have gotten in again. Its utterly prone to starvation.
>>>>>
>>>>> The acquire+release does remove the dead/life-lock scenario from the
>>>>> FIFO case, since blocking on the acquire will allow the other task to
>>>>> run (or even get boosted on -rt).
>>>>>
>>>>> Aside from that there's nothing particularly wrong with it and lockdep
>>>>> should be happy afaict (but I haven't had my morning juice yet).
>>>> bo_reserve internally maps to a ww-mutex and task can already hold
>>>> ww-mutex (potentially even the same for especially nasty userspace).
>>> OK, yes I wasn't aware of that. Yes in that case you're quite right.
>>>
>> I added a RFC patch below.  I only tested with PROVE_LOCKING, and always forced the slowpath for debugging.
>>
>> This fixes nouveau and core ttm to always use blocking acquisition in fastpath.
>> Nouveau was a bit of a headache, but afaict it should work.
>>
>> In almost all cases relocs are not updated, so I kept intact the fastpath
>> of not copying relocs from userspace. The slowpath tries to copy it atomically,
>> and if that fails it will unreserve all bo's and copy everything.
>>
>> One thing to note is that the command submission ioctl may fail now with -EFAULT
>> if presumed cannot be updated, while the commands are submitted succesfully.
>
> I think the Nouveau guys need to comment further on this, but returning -EFAULT might break existing user-space, and that's not allowed, but IIRC the return value of "presumed" is only a hint, and if it's incorrect will only trigger future command stream patching.
>
> Otherwise reviewing mostly the TTM stuff. FWIW, from wat I can tell the vmwgfx driver doesn't need any fixups.
Well because we read the list of buffer objects the presumed offsets are at least read-mapped. Although I guess in the worst case the mapping might disappear before the syscall copies back the data.
So if -EFAULT happens here then userspace messed up in some way, either by forgetting to map the offsets read-write, which cannot happen with libdrm or free'ing the bo list before the syscall returns,
which would probably result in libdrm crashing shortly afterwards anyway.

So I don't know whether to swallow that -EFAULT or not, which is what I asked.

And for vmwgfx just run it through PROVE_LOCKING and make sure all the copy_to/from_user call sites are called at least once, and then you can be certain it doesn't need fixups. ;)
Lockdep ftw..

>>
>> I'm not sure what the right behavior was here, and this can only happen if you
>> touch the memory during the ioctl or use a read-only page. Both of them are not done
>> in the common case.
>>
>> Reviews welcome. :P
>>
>> 8<---
>>
>> diff --git a/drivers/gpu/drm/nouveau/nouveau_gem.c b/drivers/gpu/drm/nouveau/nouveau_gem.c
>> index e4d60e7..2964bb7 100644
>> --- a/drivers/gpu/drm/nouveau/nouveau_gem.c
>> +++ b/drivers/gpu/drm/nouveau/nouveau_gem.c
>> @@ -445,8 +445,6 @@ validate_list(struct nouveau_channel *chan, struct nouveau_cli *cli,
>>             uint64_t user_pbbo_ptr)
>>   {
>>       struct nouveau_drm *drm = chan->drm;
>> -    struct drm_nouveau_gem_pushbuf_bo __user *upbbo =
>> -                (void __force __user *)(uintptr_t)user_pbbo_ptr;
>>       struct nouveau_bo *nvbo;
>>       int ret, relocs = 0;
>>   @@ -475,7 +473,7 @@ validate_list(struct nouveau_channel *chan, struct nouveau_cli *cli,
>>               return ret;
>>           }
>>   -        if (nv_device(drm->device)->card_type < NV_50) {
>> +        if (nv_device(drm->device)->card_type < NV_50 && !relocs) {
>>               if (nvbo->bo.offset == b->presumed.offset &&
>>                   ((nvbo->bo.mem.mem_type == TTM_PL_VRAM &&
>>                     b->presumed.domain & NOUVEAU_GEM_DOMAIN_VRAM) ||
>> @@ -483,53 +481,86 @@ validate_list(struct nouveau_channel *chan, struct nouveau_cli *cli,
>>                     b->presumed.domain & NOUVEAU_GEM_DOMAIN_GART)))
>>                   continue;
>>   -            if (nvbo->bo.mem.mem_type == TTM_PL_TT)
>> -                b->presumed.domain = NOUVEAU_GEM_DOMAIN_GART;
>> -            else
>> -                b->presumed.domain = NOUVEAU_GEM_DOMAIN_VRAM;
>> -            b->presumed.offset = nvbo->bo.offset;
>> -            b->presumed.valid = 0;
>> -            relocs++;
>> -
>> -            if (DRM_COPY_TO_USER(&upbbo[nvbo->pbbo_index].presumed,
>> -                         &b->presumed, sizeof(b->presumed)))
>> -                return -EFAULT;
>> +            relocs = 1;
>>           }
>>       }
>>         return relocs;
>>   }
>>   +static inline void
>> +u_free(void *addr)
>> +{
>> +    if (!is_vmalloc_addr(addr))
>> +        kfree(addr);
>> +    else
>> +        vfree(addr);
>> +}
>
> Isn't there a DRM utilty for this?
Oops, seems you're right..

Those functions can be replaced with drm_malloc_ab and drm_free_large.
>> +
>> +static inline void *
>> +u_memcpya(uint64_t user, unsigned nmemb, unsigned size, unsigned inatomic)
>> +{
>> +    void *mem;
>> +    void __user *userptr = (void __force __user *)(uintptr_t)user;
>> +
>> +    size *= nmemb;
>> +
>> +    mem = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
>> +    if (!mem)
>> +        mem = vmalloc(size);
> And for the above as well?
Indeed..
>
>> ...
>>   out_prevalid:
>>       u_free(bo);
>>       u_free(push);
>> diff --git a/drivers/gpu/drm/ttm/ttm_bo_vm.c b/drivers/gpu/drm/ttm/ttm_bo_vm.c
>> index 1006c15..829e911 100644
>> --- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
>> +++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
>> @@ -64,12 +64,9 @@ static int ttm_bo_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>>        * for reserve, and if it fails, retry the fault after scheduling.
>>        */
>>   -    ret = ttm_bo_reserve(bo, true, true, false, 0);
>> -    if (unlikely(ret != 0)) {
>> -        if (ret == -EBUSY)
>> -            set_need_resched();
>> +    ret = ttm_bo_reserve(bo, true, false, false, 0);
>> +    if (unlikely(ret != 0))
>>           return VM_FAULT_NOPAGE;
>> -    }
>>   
>
> Actually, it's not the locking order bo:reserve -> mmap_sem that triggers the lockdep warning, right? but the fact that copy_from_user could recurse into the fault handler? Grabbing bo:reseves recursively? which should leave us free to choose locking order at this point.
Same thing.

When PROVE_LOCKING is enabled the might_fault calls in copy_to/from_user do a fake locking of mmap_sem, which means all locking errors, provided that the reservation lock is taken at least once with mmap_sem held (eg the ttm fault handler is called at least once, it can be done separately, it doesn't need to be done in the same syscall). So any bugs will be found. The only thing to worry about is that lockdep turns off after finding 1 error, so you have to make sure it doesn't bomb out before completing tests, which is sometimes a problem on early rc kernels. ;)

~Maarten
