Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbaGWHmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 03:42:11 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:3538
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757256AbaGWHmI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 03:42:08 -0400
X-WSS-ID: 0N95MQ1-08-XH3-02
X-M-MSG: 
Message-ID: <53CF6746.7010905@amd.com>
Date: Wed, 23 Jul 2014 09:41:58 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
CC: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>,
        "Dave Airlie" <airlied@gmail.com>,
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
	<53CE2421.5040906@amd.com>	<20140722114607.GL15237@phenom.ffwll.local>
	<20140722115737.GN15237@phenom.ffwll.local>	<53CE56ED.4040109@vodafone.de>
	<20140722132652.GO15237@phenom.ffwll.local>	<53CE6AFA.1060807@vodafone.de>
	<CAKMK7uG1d31zU_i__wc+Yq46A0x0tPeKnMBs+NHSmHS82uMsXQ@mail.gmail.com>
	<53CE84AA.9030703@amd.com>
	<CAKMK7uFa8vMBV9_JenbFGnFXtV_r9dk=WjbMkkCDWcauhrDdJg@mail.gmail.com>
	<53CE8A57.2000803@vodafone.de>	<53CF58FB.8070609@canonical.com>
	<53CF5B9F.1050800@amd.com>	<53CF5EFE.6070307@canonical.com>
 <CAKMK7uHijSve_CsDE+pUk8+tjCAZjL7-nZCKeUkKuuufCPS4tQ@mail.gmail.com>
 <53CF6128.6010703@amd.com> <53CF64F9.7020701@canonical.com>
In-Reply-To: <53CF64F9.7020701@canonical.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Originating-IP: [10.224.155.198]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(377454003)(189002)(199002)(24454002)(51704005)(377424004)(107046002)(99396002)(101416001)(85202003)(20776003)(74662001)(106466001)(44976005)(81542001)(92726001)(80316001)(19580405001)(81342001)(95666004)(46102001)(23676002)(47776003)(86362001)(83322001)(59896001)(65806001)(79102001)(87936001)(4396001)(93886003)(97736001)(85852003)(65956001)(19580395003)(80022001)(50466002)(50986999)(77982001)(21056001)(64706001)(76482001)(84676001)(85306003)(85182001)(36756003)(64126003)(68736004)(105586002)(65816999)(33656002)(561944003)(87266999)(102836001)(83506001)(54356999)(76176999)(83072002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB039;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028166BF91
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.07.2014 09:32, schrieb Maarten Lankhorst:
> op 23-07-14 09:15, Christian König schreef:
>> Am 23.07.2014 09:09, schrieb Daniel Vetter:
>>> On Wed, Jul 23, 2014 at 9:06 AM, Maarten Lankhorst
>>> <maarten.lankhorst@canonical.com> wrote:
>>>>> Can we somehow avoid the need to call fence_signal() at all? The interrupts at least on radeon are way to unreliable for such a thing. Can enable_signalling fail? What's the reason for fence_signaled() in the first place?
>>>> It doesn't need to be completely reliable, or finish immediately.
>>>>
>>>> And any time wake_up_all(&rdev->fence_queue) is called all the fences that were enabled will be rechecked.
>>> I raised this already somewhere else, but should we have some common
>>> infrastructure in the core fence code to recheck fences periodically?
>>> radeon doesn't seem to be the only hw where this isn't reliable
>>> enough. Of course timer-based rechecking would only work if the driver
>>> provides the fence->signalled callback to recheck actual fence state.
>> Yeah, agree. The proposal won't work reliable at all with radeon.
>>
>> Interrupts are accumulated before sending them to the CPU, e.g. you can get one interrupt for multiple fences finished. If it's just the interrupt for the last fence submitted that gets lost you are completely screwed up because you won't get another interrupt.
>>
>> I had that problem multiple times while working on UVD support, resulting in the driver thinking that it can't submit more jobs because non of the interrupts for the already submitted fence cam through.
> Yeah but all the fences that have .enable_signaling will get signaled from a single interrupt, or when any waiter calls radeon_fence_process.

You still need to check if the fence is really signaled, cause 
radeon_fence_process might wakeup the wait queue because of something 
completely different.

Apart from that you once again rely on somebody else calling 
radeon_fence_process. This will probably work most of the times, but 
it's not 100% reliable.

>
>> Apart from that interrupts on Macs usually don't work at all, so we really need a solution where calling fence_signaled() is completely optional.
> I haven't had a problem with interrupts on my mbp after d1f9809ed1315c4cdc5760cf2f59626fd3276952, but it should be trivial to start a timer that periodically does wake_up_all, and gets its timeout reset in a call to radeon_fence_process. It could either be added as a work item, or as a normal timer (disabled during gpu lockup recovery to prevent checks from fiddling with things it shouldn't).

That will probably work, but just again sounds like we force the driver 
to fit the fence implementation instead of the other way around.

Why is that fence_signaled() call needed for in the first place?

Christian.

>
> ~Maarten
>

