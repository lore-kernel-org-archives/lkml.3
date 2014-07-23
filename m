Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637AbaGWGw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 02:52:28 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:12680
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753477AbaGWGw0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 02:52:26 -0400
X-WSS-ID: 0N95KF7-08-VFO-02
X-M-MSG: 
Message-ID: <53CF5B9F.1050800@amd.com>
Date: Wed, 23 Jul 2014 08:52:15 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        =?UTF-8?B?Q2hyaXM=?= =?UTF-8?B?dGlhbiBLw7ZuaWc=?= 
	<deathsimple@vodafone.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
CC: Dave Airlie <airlied@gmail.com>, Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
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
 <53CE8A57.2000803@vodafone.de> <53CF58FB.8070609@canonical.com>
In-Reply-To: <53CF58FB.8070609@canonical.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Originating-IP: [10.224.155.198]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(199002)(189002)(377454003)(377424004)(51704005)(24454002)(36756003)(65816999)(86362001)(87266999)(83322001)(4396001)(76176999)(77982001)(106466001)(87936001)(85306003)(76482001)(93886003)(50466002)(80316001)(99396002)(84676001)(81542001)(44976005)(21056001)(46102001)(19580405001)(101416001)(23676002)(59896001)(50986999)(74662001)(83506001)(85202003)(54356999)(79102001)(83072002)(95666004)(97736001)(107046002)(33656002)(68736004)(64126003)(47776003)(85182001)(65806001)(92726001)(19580395003)(20776003)(81342001)(85852003)(80022001)(65956001)(105586002)(102836001)(64706001);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB037;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028166BF91
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.07.2014 08:40, schrieb Maarten Lankhorst:
> op 22-07-14 17:59, Christian König schreef:
>> Am 22.07.2014 17:42, schrieb Daniel Vetter:
>>> On Tue, Jul 22, 2014 at 5:35 PM, Christian König
>>> <christian.koenig@amd.com> wrote:
>>>> Drivers exporting fences need to provide a fence->signaled and a fence->wait
>>>> function, everything else like fence->enable_signaling or calling
>>>> fence_signaled() from the driver is optional.
>>>>
>>>> Drivers wanting to use exported fences don't call fence->signaled or
>>>> fence->wait in atomic or interrupt context, and not with holding any global
>>>> locking primitives (like mmap_sem etc...). Holding locking primitives local
>>>> to the driver is ok, as long as they don't conflict with anything possible
>>>> used by their own fence implementation.
>>> Well that's almost what we have right now with the exception that
>>> drivers are allowed (actually must for correctness when updating
>>> fences) the ww_mutexes for dma-bufs (or other buffer objects).
>> In this case sorry for so much noise. I really haven't looked in so much detail into anything but Maarten's Radeon patches.
>>
>> But how does that then work right now? My impression was that it's mandatory for drivers to call fence_signaled()?
> It's only mandatory to call fence_signal() if the .enable_signaling callback has been called, else you can get away with never calling signaling a fence at all before dropping the last refcount to it.
> This allows you to keep interrupts disabled when you don't need them.

Can we somehow avoid the need to call fence_signal() at all? The 
interrupts at least on radeon are way to unreliable for such a thing. 
Can enable_signalling fail? What's the reason for fence_signaled() in 
the first place?

>>> Agreed that any shared locks are out of the way (especially stuff like
>>> dev->struct_mutex or other non-strictly driver-private stuff, i915 is
>>> really bad here still).
>> Yeah that's also an point I've wanted to note on Maartens patch. Radeon grabs the read side of it's exclusive semaphore while waiting for fences (because it assumes that the fence it waits for is a Radeon fence).
>>
>> Assuming that we need to wait in both directions with Prime (e.g. Intel driver needs to wait for Radeon to finish rendering and Radeon needs to wait for Intel to finish displaying), this might become a perfect example of locking inversion.
> In the preliminary patches where I can sync radeon with other GPU's I've been very careful in all the places that call into fences, to make sure that radeon wouldn't try to handle lockups for a different (possibly also radeon) card.

That's actually not such a good idea.

In case of a lockup we need to handle the lockup cause otherwise it 
could happen that radeon waits for the lockup to be resolved and the 
lockup handling needs to wait for a fence that's never signaled because 
of the lockup.

Christian.

>
> This is also why fence_is_signaled should never block, and why it trylocks the exclusive_lock. :-) I think lockdep would complain if I grabbed exclusive_lock while blocking in is_signaled.
>
>>> So from the core fence framework I think we already have exactly this,
>>> and we only need to adjust the radeon implementation a bit to make it
>>> less risky and invasive to the radeon driver logic.
>> Agree. Well the biggest problem I see is that exclusive semaphore I need to take when anything calls into the driver. For the fence code I need to move that down into the fence->signaled handler, cause that now can be called from outside the driver.
>>
>> Maarten solved this by telling the driver in the lockup handler (where we grab the write side of the exclusive lock) that all interrupts are already enabled, so that fence->signaled hopefully wouldn't mess with the hardware at all. While this probably works, it just leaves me with a feeling that we are doing something wrong here.
> There is unfortunately no global mechanism to say 'this card is locked up, please don't call into any of my fences', and I don't associate fences with devices, and radeon doesn't keep a global list of fences.
> If all of that existed, it would complicate the interface and its callers a lot, while I like to keep things simple.
> So I did the best I could, and simply prevented the fence calls from fiddling with the hardware. Fortunately gpu lockup is not a common operation. :-)
>
> ~Maarten
>
>

