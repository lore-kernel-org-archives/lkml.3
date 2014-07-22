Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbaGVPf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:35:28 -0400
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:46076
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753793AbaGVPf0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:35:26 -0400
X-WSS-ID: 0N94DYN-07-FIQ-02
X-M-MSG: 
Message-ID: <53CE84AA.9030703@amd.com>
Date: Tue, 22 Jul 2014 17:35:06 +0200
From: =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5p?= =?UTF-8?B?Zw==?= 
	<deathsimple@vodafone.de>
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
References: <20140709093124.11354.3774.stgit@patser>
	<20140709122953.11354.46381.stgit@patser>
	<CAPM=9tyD2ZbrcGDC3hfNb7qNdzsfnyD-ZwM7G-nOgxeu5YKuSg@mail.gmail.com>
	<53CE2421.5040906@amd.com>	<20140722114607.GL15237@phenom.ffwll.local>
	<20140722115737.GN15237@phenom.ffwll.local>	<53CE56ED.4040109@vodafone.de>
	<20140722132652.GO15237@phenom.ffwll.local>	<53CE6AFA.1060807@vodafone.de>
 <CAKMK7uG1d31zU_i__wc+Yq46A0x0tPeKnMBs+NHSmHS82uMsXQ@mail.gmail.com>
In-Reply-To: <CAKMK7uG1d31zU_i__wc+Yq46A0x0tPeKnMBs+NHSmHS82uMsXQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
X-Originating-IP: [10.224.155.194]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(377454003)(199002)(189002)(51704005)(47776003)(85182001)(74502001)(97736001)(68736004)(64126003)(92566001)(107046002)(33656002)(65806001)(31966008)(80022001)(81342001)(20776003)(105586002)(102836001)(64706001)(85852003)(65956001)(19580395003)(92726001)(561944003)(99396002)(93886003)(50466002)(81542001)(83322001)(4396001)(65816999)(36756003)(87266999)(85306003)(86362001)(76482001)(77982001)(76176999)(85202003)(80316001)(87936001)(106466001)(19580405001)(46102001)(54356999)(74662001)(83072002)(79102001)(95666004)(83506001)(44976005)(84676001)(23676002)(21056001)(101416001)(59896001)(50986999);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR02MB037;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02801ACE41
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.07.2014 17:17, schrieb Daniel Vetter:
> On Tue, Jul 22, 2014 at 3:45 PM, Christian König
> <deathsimple@vodafone.de> wrote:
>>> Would that be something you can agree to?
>>
>> No, the whole enable_signaling stuff should go away. No callback from the
>> driver into the fence code, only the other way around.
>>
>> fence->signaled as well as fence->wait should become mandatory and only
>> called from process context without holding any locks, neither atomic nor
>> any mutex/semaphore (rcu might be ok).
> So for the enable_signaling, that's optional already. It's only for
> drivers that don't want to keep interrupts enabled all the time. You
> can opt out of that easily.
>
> Wrt holding no locks at all while calling into any fence functions,
> that's just not going to work out. The point here is to make different
> drivers work together and we can rework all the ttm and i915 code to
> work locklessly in all cases where they need to wait for someone to
> complete rendering. Or at least I don't think that's feasible. So if
> you insist that no one might call into radeon code then we simply need
> to exclude radeon from participating in any shared fencing. But that's
> a bit pointless.
>
>>> Like I've said I think restricting the insanity other people are willing
>>> to live with just because you don't like it isn't right. But it is
>>> certainly right for you to insist on not being forced into any such
>>> design. I think the above would achieve this.
>>
>> I don't think so. If it's just me I would say that I'm just to cautious and
>> the idea is still save to apply to the whole kernel.
>>
>> But since Dave, Jerome and Ben seems to have similar concerns I think we
>> need to agree to a minimum and save interface for all drivers.
> Well I haven't yet seen a proposal that actually works.

How about this:

Drivers exporting fences need to provide a fence->signaled and a 
fence->wait function, everything else like fence->enable_signaling or 
calling fence_signaled() from the driver is optional.

Drivers wanting to use exported fences don't call fence->signaled or 
fence->wait in atomic or interrupt context, and not with holding any 
global locking primitives (like mmap_sem etc...). Holding locking 
primitives local to the driver is ok, as long as they don't conflict 
with anything possible used by their own fence implementation.

Christian.

>   From an intel
> pov I don't care that much since we don't care about desktop prime, so
> if radeon/nouveau don't want to do that, meh. Imo the design as-is is
> fairly sound, and as simple as it can get given the requirements. I
> haven't heard an  argument convincing me otherwise, so I guess we
> won't have prime support on linux that actually works, ever.
> -Daniel

