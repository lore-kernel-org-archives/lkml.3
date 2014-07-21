Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440AbaGUSlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 14:41:44 -0400
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:22319
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933237AbaGUSlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 14:41:42 -0400
X-WSS-ID: 0N92RXA-07-BZ4-02
X-M-MSG: 
Message-ID: <53CD5ED9.2040600@amd.com>
Date: Mon, 21 Jul 2014 21:41:29 +0300
From: Oded Gabbay <oded.gabbay@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Daniel Vetter <daniel@ffwll.ch>
CC: Jerome Glisse <j.glisse@gmail.com>,
        =?UTF-8?B?Q2hyaXN0aWFuIEvDtm5pZw==?= <deathsimple@vodafone.de>,
        David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Andrew Lewycky" <Andrew.Lewycky@amd.com>,
        =?UTF-8?B?TWljaGVsIETDpG56ZXI=?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Evgeny Pinchuk <Evgeny.Pinchuk@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH v2 00/25] AMDKFD kernel driver
References: <53C7D645.3070607@amd.com>	<20140720174652.GE3068@gmail.com>
	<53CD0961.4070505@amd.com>	<53CD17FD.3000908@vodafone.de>
	<20140721152511.GW15237@phenom.ffwll.local>	<20140721155851.GB4519@gmail.com>
	<20140721170546.GB15237@phenom.ffwll.local>	<53CD4DD2.10906@amd.com>
 <CAKMK7uFhvGtxj_d6X=4OBdVSm6cT1-Z-DiTE-FTWMnFjY2uqMQ@mail.gmail.com>
In-Reply-To: <CAKMK7uFhvGtxj_d6X=4OBdVSm6cT1-Z-DiTE-FTWMnFjY2uqMQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.224.155.153]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(51704005)(377454003)(199002)(24454002)(189002)(479174003)(52314003)(80022001)(86362001)(44976005)(93886003)(50986999)(83072002)(107046002)(21056001)(65816999)(84676001)(46102001)(102836001)(101416001)(20776003)(64126003)(79102001)(47776003)(85852003)(85306003)(76176999)(99396002)(31966008)(33656002)(68736004)(81542001)(95666004)(92726001)(81342001)(77982001)(76482001)(19580395003)(106466001)(87936001)(74502001)(105586002)(97736001)(74662001)(54356999)(64706001)(83322001)(87266999)(19580405001)(50466002)(110136001)(36756003)(65806001)(4396001)(23676002)(92566001)(65956001)(83506001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR02MB042;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0279B3DD0D
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/07/14 21:22, Daniel Vetter wrote:
> On Mon, Jul 21, 2014 at 7:28 PM, Oded Gabbay <oded.gabbay@amd.com> wrote:
>>> I'm not sure whether we can do the same trick with the hw scheduler. But
>>> then unpinning hw contexts will drain the pipeline anyway, so I guess we
>>> can just stop feeding the hw scheduler until it runs dry. And then unpin
>>> and evict.
>> So, I'm afraid but we can't do this for AMD Kaveri because:
> 
> Well as long as you can drain the hw scheduler queue (and you can do
> that, worst case you have to unmap all the doorbells and other stuff
> to intercept further submission from userspace) you can evict stuff.

I can't drain the hw scheduler queue, as I can't do mid-wave preemption.
Moreover, if I use the dequeue request register to preempt a queue
during a dispatch it may be that some waves (wave groups actually) of
the dispatch have not yet been created, and when I reactivate the mqd,
they should be created but are not. However, this works fine if you use
the HIQ. the CP ucode correctly saves and restores the state of an
outstanding dispatch. I don't think we have access to the state from
software at all, so it's not a bug, it is "as designed".

> And if we don't want compute to be a denial of service on the display
> side of the driver we need this ability. Now if you go through an
> ioctl instead of the doorbell (I agree with Jerome here, the doorbell
> should be supported by benchmarks on linux) this gets a bit easier,
> but it's not a requirement really.
> -Daniel
> 
On KV, we have the theoretical option of DOS on the display side as we
can't do a mid-wave preemption. On CZ, we won't have this problem.

	Oded
