Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbaGVQkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:40:04 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:42975
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755995AbaGVQj7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:39:59 -0400
X-WSS-ID: 0N94GYG-08-8OM-02
X-M-MSG: 
Message-ID: <53CE93D4.3010204@amd.com>
Date: Tue, 22 Jul 2014 18:39:48 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5p?= =?UTF-8?B?Zw==?= 
	<deathsimple@vodafone.de>
CC: Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "Deucher, Alexander" <alexander.deucher@amd.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [Nouveau] [PATCH 09/17] drm/radeon: use common fence implementation
 for fences
References: <20140709093124.11354.3774.stgit@patser>
	<20140709122953.11354.46381.stgit@patser>
	<CAPM=9tyD2ZbrcGDC3hfNb7qNdzsfnyD-ZwM7G-nOgxeu5YKuSg@mail.gmail.com>
	<53CE2421.5040906@amd.com>	<20140722114607.GL15237@phenom.ffwll.local>
	<20140722115737.GN15237@phenom.ffwll.local>	<53CE56ED.4040109@vodafone.de>
	<20140722132652.GO15237@phenom.ffwll.local>	<53CE6AFA.1060807@vodafone.de>
	<CAKMK7uG1d31zU_i__wc+Yq46A0x0tPeKnMBs+NHSmHS82uMsXQ@mail.gmail.com>
	<53CE84AA.9030703@amd.com>
	<CAKMK7uFa8vMBV9_JenbFGnFXtV_r9dk=WjbMkkCDWcauhrDdJg@mail.gmail.com>
	<53CE8A57.2000803@vodafone.de>
 <CAKMK7uFugmw_pP1nyA1ws5tMB6iCe1CqBHeWHoYzQ0wXE301EA@mail.gmail.com>
In-Reply-To: <CAKMK7uFugmw_pP1nyA1ws5tMB6iCe1CqBHeWHoYzQ0wXE301EA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Originating-IP: [10.224.155.194]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(377454003)(51704005)(199002)(189002)(76482001)(106466001)(19580395003)(87936001)(80316001)(74662001)(65816999)(92726001)(77982001)(81542001)(95666004)(74502001)(81342001)(36756003)(23676002)(92566001)(85182001)(65806001)(4396001)(65956001)(59896001)(83506001)(50466002)(87266999)(19580405001)(97736001)(83322001)(21056001)(105586002)(64706001)(54356999)(107046002)(83072002)(84676001)(46102001)(86362001)(80022001)(93886003)(44976005)(85852003)(31966008)(47776003)(33656002)(20776003)(99396002)(85306003)(50986999)(101416001)(68736004)(85202003)(102836001)(79102001)(64126003)(76176999);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB042;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02801ACE41
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe I've mixed things up a bit in my description. There is
> fence_signal which the implementor/exporter of a fence must call when
> the fence is completed. If the exporter has an ->enable_signaling
> callback it can delay that call to fence_signal for as long as it
> wishes as long as enable_signaling isn't called yet. But that's just
> the optimization to not required irqs to be turned on all the time.
>
> The other function is fence_is_signaled, which is used by code that is
> interested in the fence state, together with fence_wait if it wants to
> block and not just wants to know the momentary fence state. All the
> other functions (the stuff that adds callbacks and the various _locked
> and other versions) are just for fancy special cases.
Well that's rather bad, cause IRQs aren't reliable enough on Radeon HW 
for such a thing. Especially on Prime systems and Macs.

That's why we have this fancy HZ/2 timeout on all fence wait operations 
to manually check if the fence is signaled or not.

To guarantee that a fence is signaled after enable_signaling is called 
we would need to fire up a kernel thread which periodically calls 
fence->signaled.

Christian.

Am 22.07.2014 18:21, schrieb Daniel Vetter:
> On Tue, Jul 22, 2014 at 5:59 PM, Christian König
> <deathsimple@vodafone.de> wrote:
>> Am 22.07.2014 17:42, schrieb Daniel Vetter:
>>
>>> On Tue, Jul 22, 2014 at 5:35 PM, Christian König
>>> <christian.koenig@amd.com> wrote:
>>>> Drivers exporting fences need to provide a fence->signaled and a
>>>> fence->wait
>>>> function, everything else like fence->enable_signaling or calling
>>>> fence_signaled() from the driver is optional.
>>>>
>>>> Drivers wanting to use exported fences don't call fence->signaled or
>>>> fence->wait in atomic or interrupt context, and not with holding any
>>>> global
>>>> locking primitives (like mmap_sem etc...). Holding locking primitives
>>>> local
>>>> to the driver is ok, as long as they don't conflict with anything
>>>> possible
>>>> used by their own fence implementation.
>>> Well that's almost what we have right now with the exception that
>>> drivers are allowed (actually must for correctness when updating
>>> fences) the ww_mutexes for dma-bufs (or other buffer objects).
>>
>> In this case sorry for so much noise. I really haven't looked in so much
>> detail into anything but Maarten's Radeon patches.
>>
>> But how does that then work right now? My impression was that it's mandatory
>> for drivers to call fence_signaled()?
> Maybe I've mixed things up a bit in my description. There is
> fence_signal which the implementor/exporter of a fence must call when
> the fence is completed. If the exporter has an ->enable_signaling
> callback it can delay that call to fence_signal for as long as it
> wishes as long as enable_signaling isn't called yet. But that's just
> the optimization to not required irqs to be turned on all the time.
>
> The other function is fence_is_signaled, which is used by code that is
> interested in the fence state, together with fence_wait if it wants to
> block and not just wants to know the momentary fence state. All the
> other functions (the stuff that adds callbacks and the various _locked
> and other versions) are just for fancy special cases.
>
>>> Locking
>>> correctness is enforced with some extremely nasty lockdep annotations
>>> + additional debugging infrastructure enabled with
>>> CONFIG_DEBUG_WW_MUTEX_SLOWPATH. We really need to be able to hold
>>> dma-buf ww_mutexes while updating fences or waiting for them. And
>>> obviously for ->wait we need non-atomic context, not just
>>> non-interrupt.
>>
>> Sounds mostly reasonable, but for holding the dma-buf ww_mutex, wouldn't be
>> an RCU be more appropriate here? E.g. aren't we just interested that the
>> current assigned fence at some point is signaled?
> Yeah, as an optimization you can get the set of currently attached
> fences to a dma-buf with just rcu. But if you update the set of fences
> attached to a dma-buf (e.g. radeon blits the newly rendered frame to a
> dma-buf exported by i915 for scanout on i915) then you need a write
> lock on that buffer. Which is what the ww_mutex is for, to make sure
> that you don't deadlock with i915 doing concurrent ops on the same
> underlying buffer.
>
>> Something like grab ww_mutexes, grab a reference to the current fence
>> object, release ww_mutex, wait for fence, release reference to the fence
>> object.
> Yeah, if the only thing you want to do is wait for fences, then the
> rcu-protected fence ref grabbing + lockless waiting is all you need.
> But e.g. in an execbuf you also need to update fences and maybe deep
> down in the reservation code you notice that you need to evict some
> stuff and so need to wait on some other guy to finish, and it's too
> complicated to drop and reacquire all the locks. Or you simply need to
> do a blocking wait on other gpus (because there's no direct hw sync
> mechanism) and again dropping locks would needlessly complicate the
> code. So I think we should allow this just to avoid too hairy/brittle
> (and almost definitely little tested code) in drivers.
>
> Afaik this is also the same way ttm currently handles things wrt
> buffer reservation and eviction.
>
>>> Agreed that any shared locks are out of the way (especially stuff like
>>> dev->struct_mutex or other non-strictly driver-private stuff, i915 is
>>> really bad here still).
>>
>> Yeah that's also an point I've wanted to note on Maartens patch. Radeon
>> grabs the read side of it's exclusive semaphore while waiting for fences
>> (because it assumes that the fence it waits for is a Radeon fence).
>>
>> Assuming that we need to wait in both directions with Prime (e.g. Intel
>> driver needs to wait for Radeon to finish rendering and Radeon needs to wait
>> for Intel to finish displaying), this might become a perfect example of
>> locking inversion.
> fence updates are atomic on a dma-buf, protected by ww_mutex. The neat
> trick of ww_mutex is that they enforce a global ordering, so in your
> scenario either i915 or radeon would be first and you can't deadlock.
> There is no way to interleave anything even if you have lots of
> buffers shared between i915/radeon. Wrt deadlocking it's exactly the
> same guarantees as the magic ttm provides for just one driver with
> concurrent command submission since it's the same idea.
>
>>> So from the core fence framework I think we already have exactly this,
>>> and we only need to adjust the radeon implementation a bit to make it
>>> less risky and invasive to the radeon driver logic.
>>
>> Agree. Well the biggest problem I see is that exclusive semaphore I need to
>> take when anything calls into the driver. For the fence code I need to move
>> that down into the fence->signaled handler, cause that now can be called
>> from outside the driver.
>>
>> Maarten solved this by telling the driver in the lockup handler (where we
>> grab the write side of the exclusive lock) that all interrupts are already
>> enabled, so that fence->signaled hopefully wouldn't mess with the hardware
>> at all. While this probably works, it just leaves me with a feeling that we
>> are doing something wrong here.
> I'm not versed on the details in readon, but on i915 we can attach a
> memory location and cookie value to each fence and just do a memory
> fetch to figure out whether the fence has passed or not. So no locking
> needed at all. Of course the fence itself needs to lock a reference
> onto that memory location, which is a neat piece of integration work
> that we still need to tackle in some cases - there's conflicting patch
> series all over this ;-)
>
> But like I've said fence->signaled is optional so you don't need this
> necessarily, as long as radeon eventually calls fence_signaled once
> the fence has completed.
> -Daniel

