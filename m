Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439AbaGWH1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:27:16 -0400
Received: from pegasos-out.vodafone.de ([80.84.1.38]:52332 "EHLO
	pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbaGWH1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:27:14 -0400
X-Spam-Flag: NO
X-Spam-Score: 0.2
Authentication-Results: rohrpostix2.prod.vfnet.de (amavisd-new); dkim=pass
	header.i=@vodafone.de
X-DKIM: OpenDKIM Filter v2.6.8 pegasos-out.vodafone.de B00776A1F8F
X-DKIM: OpenDKIM Filter v2.0.2 smtp-04.vodafone.de B2DD1E5AC2
Message-ID: <53CF63C2.7070407@vodafone.de>
Date: Wed, 23 Jul 2014 09:26:58 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        =?UTF-8?B?Q2hyaXM=?= =?UTF-8?B?dGlhbiBLw7ZuaWc=?= 
	<christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
CC: Dave Airlie <airlied@gmail.com>, Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence implementation
 for fences
References: <20140709093124.11354.3774.stgit@patser>	<20140709122953.11354.46381.stgit@patser>	<CAPM=9tyD2ZbrcGDC3hfNb7qNdzsfnyD-ZwM7G-nOgxeu5YKuSg@mail.gmail.com>	<53CE2421.5040906@amd.com>	<20140722114607.GL15237@phenom.ffwll.local>	<20140722115737.GN15237@phenom.ffwll.local>	<53CE56ED.4040109@vodafone.de>	<20140722132652.GO15237@phenom.ffwll.local>	<53CE6AFA.1060807@vodafone.de>	<CAKMK7uG1d31zU_i__wc+Yq46A0x0tPeKnMBs+NHSmHS82uMsXQ@mail.gmail.com>	<53CE84AA.9030703@amd.com> <CAKMK7uFa8vMBV9_JenbFGnFXtV_r9dk=WjbMkkCDWcauhrDdJg@mail.gmail.com> <53CE8A57.2000803@vodafone.de> <53CF58FB.8070609@canonical.com> <53CF5B9F.1050800@amd.com> <53CF5EFE.6070307@canonical.com>
In-Reply-To: <53CF5EFE.6070307@canonical.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.07.2014 09:06, schrieb Maarten Lankhorst:
> op 23-07-14 08:52, Christian König schreef:
>> Am 23.07.2014 08:40, schrieb Maarten Lankhorst:
>>> op 22-07-14 17:59, Christian König schreef:
>>>> Am 22.07.2014 17:42, schrieb Daniel Vetter:
>>>>> On Tue, Jul 22, 2014 at 5:35 PM, Christian König
>>>>> <christian.koenig@amd.com> wrote:
>>>>>> Drivers exporting fences need to provide a fence->signaled and a fence->wait
>>>>>> function, everything else like fence->enable_signaling or calling
>>>>>> fence_signaled() from the driver is optional.
>>>>>>
>>>>>> Drivers wanting to use exported fences don't call fence->signaled or
>>>>>> fence->wait in atomic or interrupt context, and not with holding any global
>>>>>> locking primitives (like mmap_sem etc...). Holding locking primitives local
>>>>>> to the driver is ok, as long as they don't conflict with anything possible
>>>>>> used by their own fence implementation.
>>>>> Well that's almost what we have right now with the exception that
>>>>> drivers are allowed (actually must for correctness when updating
>>>>> fences) the ww_mutexes for dma-bufs (or other buffer objects).
>>>> In this case sorry for so much noise. I really haven't looked in so much detail into anything but Maarten's Radeon patches.
>>>>
>>>> But how does that then work right now? My impression was that it's mandatory for drivers to call fence_signaled()?
>>> It's only mandatory to call fence_signal() if the .enable_signaling callback has been called, else you can get away with never calling signaling a fence at all before dropping the last refcount to it.
>>> This allows you to keep interrupts disabled when you don't need them.
>> Can we somehow avoid the need to call fence_signal() at all? The interrupts at least on radeon are way to unreliable for such a thing. Can enable_signalling fail? What's the reason for fence_signaled() in the first place?
> It doesn't need to be completely reliable, or finish immediately.
>
> And any time wake_up_all(&rdev->fence_queue) is called all the fences that were enabled will be rechecked.
>
>>>>> Agreed that any shared locks are out of the way (especially stuff like
>>>>> dev->struct_mutex or other non-strictly driver-private stuff, i915 is
>>>>> really bad here still).
>>>> Yeah that's also an point I've wanted to note on Maartens patch. Radeon grabs the read side of it's exclusive semaphore while waiting for fences (because it assumes that the fence it waits for is a Radeon fence).
>>>>
>>>> Assuming that we need to wait in both directions with Prime (e.g. Intel driver needs to wait for Radeon to finish rendering and Radeon needs to wait for Intel to finish displaying), this might become a perfect example of locking inversion.
>>> In the preliminary patches where I can sync radeon with other GPU's I've been very careful in all the places that call into fences, to make sure that radeon wouldn't try to handle lockups for a different (possibly also radeon) card.
>> That's actually not such a good idea.
>>
>> In case of a lockup we need to handle the lockup cause otherwise it could happen that radeon waits for the lockup to be resolved and the lockup handling needs to wait for a fence that's never signaled because of the lockup.
> The lockup handling calls radeon_fence_wait, not the generic fence_wait. It doesn't call the exported wait function that takes the exclusive_lock in read mode.
> And lockdep should have complained if I screwed that up. :-)

You screwed it up and lockdep didn't warn you about it :-P

It's not a locking problem I'm talking about here. Radeons lockup 
handling kicks in when anything calls into the driver from the outside, 
if you have a fence wait function that's called from the outside but 
doesn't handle lockups you essentially rely on somebody else calling 
another radeon function for the lockup to be resolved.

Christian.

>
> ~Maarten
>

