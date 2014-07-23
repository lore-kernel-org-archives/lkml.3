Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbaGWMf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:35:57 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:46402 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213AbaGWMfz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:35:55 -0400
MIME-Version: 1.0
In-Reply-To: <53CF5B9F.1050800@amd.com>
References: <20140709093124.11354.3774.stgit@patser>
	<20140709122953.11354.46381.stgit@patser>
	<CAPM=9tyD2ZbrcGDC3hfNb7qNdzsfnyD-ZwM7G-nOgxeu5YKuSg@mail.gmail.com>
	<53CE2421.5040906@amd.com>
	<20140722114607.GL15237@phenom.ffwll.local>
	<20140722115737.GN15237@phenom.ffwll.local>
	<53CE56ED.4040109@vodafone.de>
	<20140722132652.GO15237@phenom.ffwll.local>
	<53CE6AFA.1060807@vodafone.de>
	<CAKMK7uG1d31zU_i__wc+Yq46A0x0tPeKnMBs+NHSmHS82uMsXQ@mail.gmail.com>
	<53CE84AA.9030703@amd.com>
	<CAKMK7uFa8vMBV9_JenbFGnFXtV_r9dk=WjbMkkCDWcauhrDdJg@mail.gmail.com>
	<53CE8A57.2000803@vodafone.de>
	<53CF58FB.8070609@canonical.com>
	<53CF5B9F.1050800@amd.com>
Date: Wed, 23 Jul 2014 08:35:54 -0400
Message-ID: <CAF6AEGtDB0cX1dtRGr3j7m2gBEv-+KqVOy49U4jgCuu=cRdJmQ@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence
 implementation for fences
From: Rob Clark <robdclark@gmail.com>
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <deathsimple@vodafone.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 2:52 AM, Christian König
<christian.koenig@amd.com> wrote:
> Am 23.07.2014 08:40, schrieb Maarten Lankhorst:
>
>> op 22-07-14 17:59, Christian König schreef:
>>>
>>> Am 22.07.2014 17:42, schrieb Daniel Vetter:
>>>>
>>>> On Tue, Jul 22, 2014 at 5:35 PM, Christian König
>>>> <christian.koenig@amd.com> wrote:
>>>>>
>>>>> Drivers exporting fences need to provide a fence->signaled and a
>>>>> fence->wait
>>>>> function, everything else like fence->enable_signaling or calling
>>>>> fence_signaled() from the driver is optional.
>>>>>
>>>>> Drivers wanting to use exported fences don't call fence->signaled or
>>>>> fence->wait in atomic or interrupt context, and not with holding any
>>>>> global
>>>>> locking primitives (like mmap_sem etc...). Holding locking primitives
>>>>> local
>>>>> to the driver is ok, as long as they don't conflict with anything
>>>>> possible
>>>>> used by their own fence implementation.
>>>>
>>>> Well that's almost what we have right now with the exception that
>>>> drivers are allowed (actually must for correctness when updating
>>>> fences) the ww_mutexes for dma-bufs (or other buffer objects).
>>>
>>> In this case sorry for so much noise. I really haven't looked in so much
>>> detail into anything but Maarten's Radeon patches.
>>>
>>> But how does that then work right now? My impression was that it's
>>> mandatory for drivers to call fence_signaled()?
>>
>> It's only mandatory to call fence_signal() if the .enable_signaling
>> callback has been called, else you can get away with never calling signaling
>> a fence at all before dropping the last refcount to it.
>> This allows you to keep interrupts disabled when you don't need them.
>
>
> Can we somehow avoid the need to call fence_signal() at all? The interrupts
> at least on radeon are way to unreliable for such a thing. Can
> enable_signalling fail? What's the reason for fence_signaled() in the first
> place?
>

the device you are sharing with may not be able to do hw<->hw
signalling.. think about buffer sharing w/ camera, for example.

You probably want your ->enable_signalling() to enable whatever
workaround periodic-polling you need to do to catch missed irq's (and
then call fence->signal() once you detect the fence has passed.

fwiw, I haven't had a chance to read this whole thread yet, but I
expect that a lot of the SoC devices, especially ones with separate
kms-only display and gpu drivers, will want callback from gpu's irq to
bang a few display controller registers.  I agree in general callbacks
from atomic ctx is probably something you want to avoid, but in this
particular case I think it is worth the extra complexity.  Nothing is
stopping a driver from using a callback that just chucks something on
a workqueue, whereas the inverse is not possible.

BR,
-R

>
>>>> Agreed that any shared locks are out of the way (especially stuff like
>>>> dev->struct_mutex or other non-strictly driver-private stuff, i915 is
>>>> really bad here still).
>>>
>>> Yeah that's also an point I've wanted to note on Maartens patch. Radeon
>>> grabs the read side of it's exclusive semaphore while waiting for fences
>>> (because it assumes that the fence it waits for is a Radeon fence).
>>>
>>> Assuming that we need to wait in both directions with Prime (e.g. Intel
>>> driver needs to wait for Radeon to finish rendering and Radeon needs to wait
>>> for Intel to finish displaying), this might become a perfect example of
>>> locking inversion.
>>
>> In the preliminary patches where I can sync radeon with other GPU's I've
>> been very careful in all the places that call into fences, to make sure that
>> radeon wouldn't try to handle lockups for a different (possibly also radeon)
>> card.
>
>
> That's actually not such a good idea.
>
> In case of a lockup we need to handle the lockup cause otherwise it could
> happen that radeon waits for the lockup to be resolved and the lockup
> handling needs to wait for a fence that's never signaled because of the
> lockup.
>
> Christian.
>
>
>>
>> This is also why fence_is_signaled should never block, and why it trylocks
>> the exclusive_lock. :-) I think lockdep would complain if I grabbed
>> exclusive_lock while blocking in is_signaled.
>>
>>>> So from the core fence framework I think we already have exactly this,
>>>> and we only need to adjust the radeon implementation a bit to make it
>>>> less risky and invasive to the radeon driver logic.
>>>
>>> Agree. Well the biggest problem I see is that exclusive semaphore I need
>>> to take when anything calls into the driver. For the fence code I need to
>>> move that down into the fence->signaled handler, cause that now can be
>>> called from outside the driver.
>>>
>>> Maarten solved this by telling the driver in the lockup handler (where we
>>> grab the write side of the exclusive lock) that all interrupts are already
>>> enabled, so that fence->signaled hopefully wouldn't mess with the hardware
>>> at all. While this probably works, it just leaves me with a feeling that we
>>> are doing something wrong here.
>>
>> There is unfortunately no global mechanism to say 'this card is locked up,
>> please don't call into any of my fences', and I don't associate fences with
>> devices, and radeon doesn't keep a global list of fences.
>> If all of that existed, it would complicate the interface and its callers
>> a lot, while I like to keep things simple.
>> So I did the best I could, and simply prevented the fence calls from
>> fiddling with the hardware. Fortunately gpu lockup is not a common
>> operation. :-)
>>
>> ~Maarten
>>
>>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
