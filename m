Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbaGVPCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:02:42 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:23976
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753988AbaGVPCl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:02:41 -0400
X-WSS-ID: 0N94CGA-07-C6Y-02
X-M-MSG: 
Message-ID: <53CE7D06.2010109@amd.com>
Date: Tue, 22 Jul 2014 17:02:30 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
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
References: <20140709093124.11354.3774.stgit@patser>
 <20140709122953.11354.46381.stgit@patser>
 <CAPM=9tyD2ZbrcGDC3hfNb7qNdzsfnyD-ZwM7G-nOgxeu5YKuSg@mail.gmail.com>
 <53CE2421.5040906@amd.com> <20140722114607.GL15237@phenom.ffwll.local>
 <20140722115737.GN15237@phenom.ffwll.local> <53CE56ED.4040109@vodafone.de>
 <20140722132652.GO15237@phenom.ffwll.local> <53CE6AFA.1060807@vodafone.de>
 <53CE78C0.9030408@canonical.com>
In-Reply-To: <53CE78C0.9030408@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
X-Originating-IP: [10.224.155.194]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(24454002)(377424004)(51704005)(81542001)(68736004)(20776003)(87266999)(83506001)(76176999)(81342001)(76482001)(80022001)(99396002)(84676001)(64126003)(87936001)(79102001)(105586002)(4396001)(65806001)(65956001)(77982001)(44976005)(80316001)(50466002)(47776003)(95666004)(54356999)(85306003)(64706001)(50986999)(46102001)(23756003)(106466001)(102836001)(86362001)(65816999)(59896001)(19580395003)(93886003)(36756003)(74502001)(97736001)(83322001)(85852003)(74662001)(21056001)(31966008)(83072002)(92566001)(33656002)(19580405001)(101416001)(107046002)(107886001)(92726001)(1121002)(921003);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB045;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02801ACE41
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.07.2014 16:44, schrieb Maarten Lankhorst:
> op 22-07-14 15:45, Christian König schreef:
>> Am 22.07.2014 15:26, schrieb Daniel Vetter:
>>> On Tue, Jul 22, 2014 at 02:19:57PM +0200, Christian König wrote:
>>>> Am 22.07.2014 13:57, schrieb Daniel Vetter:
>>>>> On Tue, Jul 22, 2014 at 01:46:07PM +0200, Daniel Vetter wrote:
>>>>>> On Tue, Jul 22, 2014 at 10:43:13AM +0200, Christian König wrote:
>>>>>>> Am 22.07.2014 06:05, schrieb Dave Airlie:
>>>>>>>> On 9 July 2014 22:29, Maarten Lankhorst <maarten.lankhorst@canonical.com> wrote:
>>>>>>>>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>>>>>>>>> ---
>>>>>>>>>    drivers/gpu/drm/radeon/radeon.h        |   15 +-
>>>>>>>>>    drivers/gpu/drm/radeon/radeon_device.c |   60 ++++++++-
>>>>>>>>>    drivers/gpu/drm/radeon/radeon_fence.c  |  223 ++++++++++++++++++++++++++------
>>>>>>>>>    3 files changed, 248 insertions(+), 50 deletions(-)
>>>>>>>>>
>>>>>>>>   From what I can see this is still suffering from the problem that we
>>>>>>>> need to find a proper solution to,
>>>>>>>>
>>>>>>>> My summary of the issues after talking to Jerome and Ben and
>>>>>>>> re-reading things is:
>>>>>>>>
>>>>>>>> We really need to work out a better interface into the drivers to be
>>>>>>>> able to avoid random atomic entrypoints,
>>>>>>> Which is exactly what I criticized from the very first beginning. Good to
>>>>>>> know that I'm not the only one thinking that this isn't such a good idea.
>>>>>> I guess I've lost context a bit, but which atomic entry point are we
>>>>>> talking about? Afaics the only one that's mandatory is the is
>>>>>> fence->signaled callback to check whether a fence really has been
>>>>>> signalled. It's used internally by the fence code to avoid spurious
>>>>>> wakeups. Afaik that should be doable already on any hardware. If that's
>>>>>> not the case then we can always track the signalled state in software and
>>>>>> double-check in a worker thread before updating the sw state. And wrap
>>>>>> this all up into a special fence class if there's more than one driver
>>>>>> needing this.
>>>>> One thing I've forgotten: The i915 scheduler that's floating around runs
>>>>> its bottom half from irq context. So I really want to be able to check
>>>>> fence state from irq context and I also want to make it possible
>>>>> (possible! not mandatory) to register callbacks which are run from any
>>>>> context asap after the fence is signalled.
>>>> NAK, that's just the bad design I've talked about. Checking fence state
>>>> inside the same driver from interrupt context is OK, because it's the
>>>> drivers interrupt that we are talking about here.
>>>>
>>>> Checking fence status from another drivers interrupt context is what really
>>>> concerns me here, cause your driver doesn't have the slightest idea if the
>>>> called driver is really capable of checking the fence right now.
>>> I guess my mail hasn't been clear then. If you don't like it we could add
>>> a bit of glue to insulate the madness and bad design i915 might do from
>>> radeon. That imo doesn't invalidate the overall fence interfaces.
>>>
>>> So what about the following:
>>> - fence->enabling_signaling is restricted to be called from process
>>>     context. We don't use any different yet, so would boild down to adding a
>>>     WARN_ON(in_interrupt) or so to fence_enable_sw_signalling.
>>>
>>> - Make fence->signaled optional (already the case) and don't implement it
>>>     in readon (i.e. reduce this patch here). Only downside is that radeon
>>>     needs to correctly (i.e. without races or so) call fence_signal. And the
>>>     cross-driver synchronization might be a bit less efficient. Note that
>>>     you can call fence_signal from wherever you want to, so hopefully that
>>>     doesn't restrict your implementation.
>>>
>>> End result: No one calls into radeon from interrupt context, and this is
>>> guaranteed.
>>>
>>> Would that be something you can agree to?
>> No, the whole enable_signaling stuff should go away. No callback from the driver into the fence code, only the other way around.
>>
>> fence->signaled as well as fence->wait should become mandatory and only called from process context without holding any locks, neither atomic nor any mutex/semaphore (rcu might be ok).
> fence->wait is mandatory, and already requires sleeping.
>
> If .signaled is not implemented there is no guarantee the fence will be
> signaled sometime soon, this is also why enable_signaling exists, to
> allow the driver to flush. I get it that it doesn't apply to radeon and nouveau,
> but for other drivers that could be necessary, like vmwgfx.
>
> Ironically that is also a part of the ttm fence, except it was called flush there.

Then call it flush again and make it optional like in TTM.

> I would also like to note that ttm_bo_wait currently is also a function that currently uses is_signaled from atomic_context...

I know, but TTM is only called from inside a single driver, no inter 
driver needs here. We currently even call the internal fence 
implementation from interrupt context as well and at more than one 
occasion assume that TTM only uses radeon fences.

Christian.

> For the more complicated locking worries: Lockdep is your friend, use PROVE_LOCKING and find bugs before they trigger. ;-)
>
>>> Like I've said I think restricting the insanity other people are willing
>>> to live with just because you don't like it isn't right. But it is
>>> certainly right for you to insist on not being forced into any such
>>> design. I think the above would achieve this.
>> I don't think so. If it's just me I would say that I'm just to cautious and the idea is still save to apply to the whole kernel.
>>
>> But since Dave, Jerome and Ben seems to have similar concerns I think we need to agree to a minimum and save interface for all drivers.
>>
>> Christian.
>>

