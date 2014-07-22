Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbaGVP7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:59:40 -0400
Received: from pegasos-out.vodafone.de ([80.84.1.38]:55994 "EHLO
	pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793AbaGVP7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:59:38 -0400
X-Spam-Flag: NO
X-Spam-Score: -0.045
Authentication-Results: rohrpostix2.prod.vfnet.de (amavisd-new); dkim=pass
	header.i=@vodafone.de
X-DKIM: OpenDKIM Filter v2.6.8 pegasos-out.vodafone.de D631572552C
X-DKIM: OpenDKIM Filter v2.0.2 smtp-04.vodafone.de 566F6E841E
Message-ID: <53CE8A57.2000803@vodafone.de>
Date: Tue, 22 Jul 2014 17:59:19 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5p?= =?UTF-8?B?Zw==?= 
	<christian.koenig@amd.com>
CC: Dave Airlie <airlied@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence implementation
 for fences
References: <20140709093124.11354.3774.stgit@patser>	<20140709122953.11354.46381.stgit@patser>	<CAPM=9tyD2ZbrcGDC3hfNb7qNdzsfnyD-ZwM7G-nOgxeu5YKuSg@mail.gmail.com>	<53CE2421.5040906@amd.com>	<20140722114607.GL15237@phenom.ffwll.local>	<20140722115737.GN15237@phenom.ffwll.local>	<53CE56ED.4040109@vodafone.de>	<20140722132652.GO15237@phenom.ffwll.local>	<53CE6AFA.1060807@vodafone.de>	<CAKMK7uG1d31zU_i__wc+Yq46A0x0tPeKnMBs+NHSmHS82uMsXQ@mail.gmail.com>	<53CE84AA.9030703@amd.com> <CAKMK7uFa8vMBV9_JenbFGnFXtV_r9dk=WjbMkkCDWcauhrDdJg@mail.gmail.com>
In-Reply-To: <CAKMK7uFa8vMBV9_JenbFGnFXtV_r9dk=WjbMkkCDWcauhrDdJg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.07.2014 17:42, schrieb Daniel Vetter:
> On Tue, Jul 22, 2014 at 5:35 PM, Christian König
> <christian.koenig@amd.com> wrote:
>> Drivers exporting fences need to provide a fence->signaled and a fence->wait
>> function, everything else like fence->enable_signaling or calling
>> fence_signaled() from the driver is optional.
>>
>> Drivers wanting to use exported fences don't call fence->signaled or
>> fence->wait in atomic or interrupt context, and not with holding any global
>> locking primitives (like mmap_sem etc...). Holding locking primitives local
>> to the driver is ok, as long as they don't conflict with anything possible
>> used by their own fence implementation.
> Well that's almost what we have right now with the exception that
> drivers are allowed (actually must for correctness when updating
> fences) the ww_mutexes for dma-bufs (or other buffer objects).

In this case sorry for so much noise. I really haven't looked in so much 
detail into anything but Maarten's Radeon patches.

But how does that then work right now? My impression was that it's 
mandatory for drivers to call fence_signaled()?

> Locking
> correctness is enforced with some extremely nasty lockdep annotations
> + additional debugging infrastructure enabled with
> CONFIG_DEBUG_WW_MUTEX_SLOWPATH. We really need to be able to hold
> dma-buf ww_mutexes while updating fences or waiting for them. And
> obviously for ->wait we need non-atomic context, not just
> non-interrupt.

Sounds mostly reasonable, but for holding the dma-buf ww_mutex, wouldn't 
be an RCU be more appropriate here? E.g. aren't we just interested that 
the current assigned fence at some point is signaled?

Something like grab ww_mutexes, grab a reference to the current fence 
object, release ww_mutex, wait for fence, release reference to the fence 
object.


> Agreed that any shared locks are out of the way (especially stuff like
> dev->struct_mutex or other non-strictly driver-private stuff, i915 is
> really bad here still).

Yeah that's also an point I've wanted to note on Maartens patch. Radeon 
grabs the read side of it's exclusive semaphore while waiting for fences 
(because it assumes that the fence it waits for is a Radeon fence).

Assuming that we need to wait in both directions with Prime (e.g. Intel 
driver needs to wait for Radeon to finish rendering and Radeon needs to 
wait for Intel to finish displaying), this might become a perfect 
example of locking inversion.

> So from the core fence framework I think we already have exactly this,
> and we only need to adjust the radeon implementation a bit to make it
> less risky and invasive to the radeon driver logic.

Agree. Well the biggest problem I see is that exclusive semaphore I need 
to take when anything calls into the driver. For the fence code I need 
to move that down into the fence->signaled handler, cause that now can 
be called from outside the driver.

Maarten solved this by telling the driver in the lockup handler (where 
we grab the write side of the exclusive lock) that all interrupts are 
already enabled, so that fence->signaled hopefully wouldn't mess with 
the hardware at all. While this probably works, it just leaves me with a 
feeling that we are doing something wrong here.

Christian.

> -Daniel

