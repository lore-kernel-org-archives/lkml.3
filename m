Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663AbaGVPSu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:18:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42151 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbaGVPSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:18:48 -0400
Message-ID: <53CE80CF.2060709@canonical.com>
Date: Tue, 22 Jul 2014 17:18:39 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>,
        =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>,
        Dave Airlie <airlied@gmail.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence implementation
 for fences
References: <20140709093124.11354.3774.stgit@patser> <20140709122953.11354.46381.stgit@patser> <CAPM=9tyD2ZbrcGDC3hfNb7qNdzsfnyD-ZwM7G-nOgxeu5YKuSg@mail.gmail.com> <53CE2421.5040906@amd.com> <20140722114607.GL15237@phenom.ffwll.local> <20140722115737.GN15237@phenom.ffwll.local> <53CE56ED.4040109@vodafone.de> <20140722132652.GO15237@phenom.ffwll.local> <53CE6AFA.1060807@vodafone.de> <53CE78C0.9030408@canonical.com> <53CE7D06.2010109@amd.com>
In-Reply-To: <53CE7D06.2010109@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

op 22-07-14 17:02, Christian König schreef:
> Am 22.07.2014 16:44, schrieb Maarten Lankhorst:
>> op 22-07-14 15:45, Christian König schreef:
>>> Am 22.07.2014 15:26, schrieb Daniel Vetter:
>>>> On Tue, Jul 22, 2014 at 02:19:57PM +0200, Christian König wrote:
>>>>> Am 22.07.2014 13:57, schrieb Daniel Vetter:
>>>>>> On Tue, Jul 22, 2014 at 01:46:07PM +0200, Daniel Vetter wrote:
>>>>>>> On Tue, Jul 22, 2014 at 10:43:13AM +0200, Christian König wrote:
>>>>>>>> Am 22.07.2014 06:05, schrieb Dave Airlie:
>>>>>>>>> On 9 July 2014 22:29, Maarten Lankhorst <maarten.lankhorst@canonical.com> wrote:
>>>>>>>>>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>>>>>>>>>> ---
>>>>>>>>>>    drivers/gpu/drm/radeon/radeon.h        |   15 +-
>>>>>>>>>>    drivers/gpu/drm/radeon/radeon_device.c |   60 ++++++++-
>>>>>>>>>>    drivers/gpu/drm/radeon/radeon_fence.c  |  223 ++++++++++++++++++++++++++------
>>>>>>>>>>    3 files changed, 248 insertions(+), 50 deletions(-)
>>>>>>>>>>
>>>>>>>>>   From what I can see this is still suffering from the problem that we
>>>>>>>>> need to find a proper solution to,
>>>>>>>>>
>>>>>>>>> My summary of the issues after talking to Jerome and Ben and
>>>>>>>>> re-reading things is:
>>>>>>>>>
>>>>>>>>> We really need to work out a better interface into the drivers to be
>>>>>>>>> able to avoid random atomic entrypoints,
>>>>>>>> Which is exactly what I criticized from the very first beginning. Good to
>>>>>>>> know that I'm not the only one thinking that this isn't such a good idea.
>>>>>>> I guess I've lost context a bit, but which atomic entry point are we
>>>>>>> talking about? Afaics the only one that's mandatory is the is
>>>>>>> fence->signaled callback to check whether a fence really has been
>>>>>>> signalled. It's used internally by the fence code to avoid spurious
>>>>>>> wakeups. Afaik that should be doable already on any hardware. If that's
>>>>>>> not the case then we can always track the signalled state in software and
>>>>>>> double-check in a worker thread before updating the sw state. And wrap
>>>>>>> this all up into a special fence class if there's more than one driver
>>>>>>> needing this.
>>>>>> One thing I've forgotten: The i915 scheduler that's floating around runs
>>>>>> its bottom half from irq context. So I really want to be able to check
>>>>>> fence state from irq context and I also want to make it possible
>>>>>> (possible! not mandatory) to register callbacks which are run from any
>>>>>> context asap after the fence is signalled.
>>>>> NAK, that's just the bad design I've talked about. Checking fence state
>>>>> inside the same driver from interrupt context is OK, because it's the
>>>>> drivers interrupt that we are talking about here.
>>>>>
>>>>> Checking fence status from another drivers interrupt context is what really
>>>>> concerns me here, cause your driver doesn't have the slightest idea if the
>>>>> called driver is really capable of checking the fence right now.
>>>> I guess my mail hasn't been clear then. If you don't like it we could add
>>>> a bit of glue to insulate the madness and bad design i915 might do from
>>>> radeon. That imo doesn't invalidate the overall fence interfaces.
>>>>
>>>> So what about the following:
>>>> - fence->enabling_signaling is restricted to be called from process
>>>>     context. We don't use any different yet, so would boild down to adding a
>>>>     WARN_ON(in_interrupt) or so to fence_enable_sw_signalling.
>>>>
>>>> - Make fence->signaled optional (already the case) and don't implement it
>>>>     in readon (i.e. reduce this patch here). Only downside is that radeon
>>>>     needs to correctly (i.e. without races or so) call fence_signal. And the
>>>>     cross-driver synchronization might be a bit less efficient. Note that
>>>>     you can call fence_signal from wherever you want to, so hopefully that
>>>>     doesn't restrict your implementation.
>>>>
>>>> End result: No one calls into radeon from interrupt context, and this is
>>>> guaranteed.
>>>>
>>>> Would that be something you can agree to?
>>> No, the whole enable_signaling stuff should go away. No callback from the driver into the fence code, only the other way around.
>>>
>>> fence->signaled as well as fence->wait should become mandatory and only called from process context without holding any locks, neither atomic nor any mutex/semaphore (rcu might be ok).
>> fence->wait is mandatory, and already requires sleeping.
>>
>> If .signaled is not implemented there is no guarantee the fence will be
>> signaled sometime soon, this is also why enable_signaling exists, to
>> allow the driver to flush. I get it that it doesn't apply to radeon and nouveau,
>> but for other drivers that could be necessary, like vmwgfx.
>>
>> Ironically that is also a part of the ttm fence, except it was called flush there.
>
> Then call it flush again and make it optional like in TTM.
You've posted a lot of concerns, but I haven't seen you come up with any scenario that could create a lockup and lockdep wouldn't warn about.

>> I would also like to note that ttm_bo_wait currently is also a function that currently uses is_signaled from atomic_context...
>
> I know, but TTM is only called from inside a single driver, no inter driver needs here. We currently even call the internal fence implementation from interrupt context as well and at more than one occasion assume that TTM only uses radeon fences.
This is no longer true when you start synchronizing with other drivers. The TTM core will see the intel fences and treat them no differently. That's the entire reason for this conversion. It's also needed to remove the need to pin dma-buf when exporting.

~Maarten.

