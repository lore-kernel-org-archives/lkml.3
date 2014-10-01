Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaJAMZM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 08:25:12 -0400
Received: from mail-bl2on0136.outbound.protection.outlook.com ([65.55.169.136]:51680
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751053AbaJAMZJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 08:25:09 -0400
From: Peter Chen <Peter.Chen@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>
Subject: RE: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Thread-Topic: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Thread-Index: AQHP1xkurfkrdRvKVEqm7ahNs/szPpwZXj8AgAAfLwCAALGngP//i84AgAEaS8CAACO5gIAAPgSg
Date: Wed, 1 Oct 2014 12:25:06 +0000
Message-ID: <ba59ee980d0b48a6b9027741f4420612@BN1PR0301MB0772.namprd03.prod.outlook.com>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com>
 <10249326.XCThPmSrfL@wuerfel>
 <abb0c775ec2549e3abb0a2218b4eef98@BN1PR0301MB0772.namprd03.prod.outlook.com>
 <1845601.0ISfgfFO3Y@wuerfel>
In-Reply-To: <1845601.0ISfgfFO3Y@wuerfel>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.158.211]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0772;
x-forefront-prvs: 0351D213B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(164054003)(24454002)(199003)(189002)(45984002)(92566001)(80022003)(64706001)(33646002)(10300001)(99396003)(120916001)(107046002)(86362001)(46102003)(66066001)(108616004)(20776003)(99286002)(110136001)(105586002)(31966008)(95666004)(76482002)(50986999)(76176999)(106356001)(106116001)(76576001)(87936001)(85306004)(21056001)(101416001)(54356999)(77096002)(4396001)(85852003)(74316001)(93886004)(2656002)(97736003)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0772;H:BN1PR0301MB0772.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> On Wednesday 01 October 2014 06:35:58 Peter Chen wrote:
> > > Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for
> > > ci13xxx
> > >
> > > On Tuesday 30 September 2014 20:39:34 Peter Chen wrote:
> > > > Thanks, Arnd. I had not thought setting dma mask is so
> > > > complicated, yes, it should check the return value, two things to confirm:
> > > >
> > > > - dma_coerce_mask_and_coherent or dma_set_mask_and_coherent,
> the
> > > only
> > > > difference of these two API is the first one do "dev->dma_mask =
> > > >&dev- coherent_dma_mask;"
> > > > The reason you suggest choosing dma_set_mask_and_coherent is you
> > > >do  not want assign dev->dma_mask?
> > >
> > > No, that is just the current definition on ARM32 with
> > > CONFIG_ARCH_MULTIPLATFORM, and that is going to change soon to be
> DT
> > > aware.
> > > dma_set_mask_and_coherent() is supposed to check whether the
> > > platform can support the respective mask and return an error if it cannot.
> > >
> > > > - The second parameter for dma_set_mask_and_coherent is
> > > > DMA_BIT_MASK(32), is it ok?
> > > >
> > > > I just a little confused of what's the operation is "hardcoding the dma
> mask"?
> > >
> > > dma_coerce_mask_and_coherent() will hardcode the dma mask and
> > > override whatever the platform says is necessary.
> > >
> >
> > So, we should use dma_set_mask_and_coherent() in most of cases in
> > device driver, and use dma_coerce_mask_and_coherent() only  when the
> device's dma_mask is wrong?
> >
> >
> 
> dma_coerce_mask_and_coherent() should really not be used at all. Russell
> introduced it to convert drivers that were incorrectly setting the dma_mask
> pointer themselves to something slightly more palatable.
> 
> The initial dma_mask is supposed to be set by the platform for each DMA
> capable device, according to the address width of its upstream bus.
> For DT based probing, we now set it to 32-bit mask but should really set it to
> something smaller if the bus is more limited than that.
> 
> For devices created by platform code (board files), the platform should call
> platform_device_register_full() and specify the dma mask in the
> platform_device_info. Older platforms sometimes define a static platform
> device structure that has the dma mask set. This works as well but is
> discouraged for other reasons.
> 
> Drivers that require a dma mask that is either smaller than 32-bit (because of
> device specific quirks) or that know that the device is capable of larger DMA
> space and want to use that need to call dma_set_mask or
> dma_set_mask_and_coherent and check the return value.
> 
> Ideally all device drivers that want to do DMA should call set_dma_mask or
> set_dma_mask_and_coherent, even if the device has exactly a 32-bit
> connection to the upstream bus.
> 
> One more complication: if the device is not a DMA master itself but uses a dma
> engine, you should not use set_dma_mask_and_coherent() but instead use
> dma_get_mask() on the dmaengine device to query its mask, and also use that
> same pointer to pass into dma_alloc_coherent and dma_map_*.
> 
 
Thank you very much, Arnd. It makes things clear.

Peter
