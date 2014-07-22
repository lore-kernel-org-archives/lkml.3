Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbaGVIn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 04:43:26 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:11567
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751861AbaGVInW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 04:43:22 -0400
X-WSS-ID: 0N93UW4-07-12K-02
X-M-MSG: 
Message-ID: <53CE2421.5040906@amd.com>
Date: Tue, 22 Jul 2014 10:43:13 +0200
From: =?ISO-8859-1?Q?Christian_K=F6nig?= <christian.koenig@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: Dave Airlie <airlied@linux.ie>, Thomas Hellstrom <thellstrom@vmware.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>
Subject: Re: [PATCH 09/17] drm/radeon: use common fence implementation for
 fences
References: <20140709093124.11354.3774.stgit@patser>
	<20140709122953.11354.46381.stgit@patser>
 <CAPM=9tyD2ZbrcGDC3hfNb7qNdzsfnyD-ZwM7G-nOgxeu5YKuSg@mail.gmail.com>
In-Reply-To: <CAPM=9tyD2ZbrcGDC3hfNb7qNdzsfnyD-ZwM7G-nOgxeu5YKuSg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.224.155.198]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(24454002)(51704005)(199002)(189002)(51444003)(20776003)(47776003)(102836001)(85306003)(64706001)(81342001)(81542001)(83072002)(85852003)(50466002)(77982001)(65816999)(36756003)(54356999)(76176999)(87266999)(50986999)(86362001)(46102001)(65956001)(65806001)(80022001)(95666004)(64126003)(101416001)(23756003)(97736001)(105586002)(107046002)(31966008)(106466001)(87936001)(76482001)(33656002)(83506001)(4396001)(44976005)(84676001)(74502001)(74662001)(68736004)(92726001)(19580395003)(80316001)(92566001)(19580405001)(83322001)(79102001)(21056001)(99396002);DIR:OUT;SFP:;SCL:1;SRVR:CO1PR02MB046;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02801ACE41
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Christian.Koenig@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.07.2014 06:05, schrieb Dave Airlie:
> On 9 July 2014 22:29, Maarten Lankhorst <maarten.lankhorst@canonical.com> wrote:
>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>> ---
>>   drivers/gpu/drm/radeon/radeon.h        |   15 +-
>>   drivers/gpu/drm/radeon/radeon_device.c |   60 ++++++++-
>>   drivers/gpu/drm/radeon/radeon_fence.c  |  223 ++++++++++++++++++++++++++------
>>   3 files changed, 248 insertions(+), 50 deletions(-)
>>
>  From what I can see this is still suffering from the problem that we
> need to find a proper solution to,
>
> My summary of the issues after talking to Jerome and Ben and
> re-reading things is:
>
> We really need to work out a better interface into the drivers to be
> able to avoid random atomic entrypoints,

Which is exactly what I criticized from the very first beginning. Good 
to know that I'm not the only one thinking that this isn't such a good idea.

> I'm sure you have some ideas and I think you really need to
> investigate them to move this thing forward,
> even it if means some issues with android sync pts.

Actually I think that TTMs fence interface already gave quite a good 
hint how it might look like. I can only guess that this won't fit with 
the Android stuff, otherwise I can't see a good reason why we didn't 
stick with that.

> but none of the two major drivers seem to want the interface as-is so
> something needs to give
>
> My major question is why we need an atomic callback here at all, what
> scenario does it cover?

Agree totally. As far as I can see all current uses of the interface are 
of the kind of waiting for a fence to signal.

No need for any callback from one driver into another, especially not in 
atomic context. If a driver needs such a functionality it should just 
start up a kernel thread and do it's waiting there.

This obviously shouldn't be an obstacle for pure hardware 
implementations where one driver signals a semaphore another driver is 
waiting for, or a high signal on an interrupt line directly wired 
between two chips. And I think this is a completely different topic and 
not necessarily part of the common fence interface we should currently 
focus on.

Christian.

> Surely we can use a workqueue based callback to ask a driver to check
> its signalling, is it really
> that urgent?
>
> Dave.
