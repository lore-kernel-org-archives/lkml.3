Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083AbaGQBVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 21:21:01 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:39792
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751758AbaGQBU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 21:20:58 -0400
From: Peter Chen <Peter.Chen@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: =?iso-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Thread-Topic: [PATCH v3 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Thread-Index: AQHPoM+g9rJqVrp5SkK+NRByw9cq15uiYcMAgAAJm4CAABBXAIAAGzwggAAF8QCAANLu4A==
Date: Thu, 17 Jul 2014 01:20:54 +0000
Message-ID: <93903d5fdf85427bb8a418894540c122@BN1PR0301MB0772.namprd03.prod.outlook.com>
References: <1405499166-6726-1-git-send-email-antoine.tenart@free-electrons.com>
 <5615007.cNNjmu3rBK@wuerfel>
 <cd73d8a384cc4040a0bbc6afc1f3063d@DM2PR0301MB0783.namprd03.prod.outlook.com>
 <22032517.gk8PRUMaIU@wuerfel>
In-Reply-To: <22032517.gk8PRUMaIU@wuerfel>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:
x-forefront-prvs: 027578BB13
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(199002)(51704005)(164054003)(189002)(20776003)(99286002)(83322001)(21056001)(64706001)(95666004)(83072002)(85852003)(99396002)(76576001)(101416001)(92566001)(107046002)(105586002)(80022001)(66066001)(87936001)(4396001)(2656002)(106116001)(106356001)(74316001)(110136001)(81542001)(33646002)(81342001)(76482001)(86362001)(77096002)(77982001)(85306003)(76176999)(46102001)(93886003)(31966008)(50986999)(74502001)(79102001)(74662001)(54356999)(108616002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0772;H:BN1PR0301MB0772.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;LANG:en;
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > >
> > > > Some people wanted the possibility to set the DMA mask as this
> > > > USB2 CI driver does not do specific Berlin operation and can be
> reused later.
> > > > I don't particularly need to call dma_coerce_mask_and_coherent()
> > > > in my case, as far as I know.
> > >
> > > Ok, just remove the call then and rely on the default mask.
> > >
> > > > They can maybe give the restrictions they might want to put on the
> > > > DMA mask.
> > >
> > > If the restriction is from the bus, it should get handled
> > > automatically by the device probe as long as the correct dma-ranges
> > > property is there (though we have a small bug there at the moment).
> > > If there is a variation of ci13xxx that can't do 32-bit DMA, that
> > > should use a different compatible string and pass a fixed mask into
> > > dma_set_mask_and_coherent() based on the device.
> > >
> >
> > Correct me if my below understanding is wrong please.
> >
> > For three chipidea users:
> > user_a: don't need dma mask
> > user_b: dma mask value is dma_mask_b
> > user_c: dma mask value is dma_mask_c
> >
> > We don't need to call dma_coerce_mask_and_coherent() at generic
> > chipidea glue driver, and set dma-ranges as dma_mask_b at user_b's
> > dts, and set dma-ranges as dma_mask_c at user_c's dts.
> 
> The dma-ranges property doesn't just encode a dma-mask for a device, but
> rather how the children of a bus see the memory address space of the
> parent.
> 
> For traditional reasons we default to assuming that a 32-bit dma_mask is
> correct, but there may be multiple reasons why this is not true:
> 
> - you have a device connected to a bus that is smaller than 32-bit wide
>   (and that would have a dma-ranges property describing that)
> - you have a device that has fewer than 32 address lines but is connected
>   to a 32-bit upstream bus (hence the dma-ranges describe all 32 bit,
>   but the driver must set a smaller mask)
> - you have a 64-bit capable device connected to a 32-bit bus: the driver
>   will ask for a 64-bit mask, but the dma_set_mask() call refuses this
>   because of the bus capabilities.
> - you have a 64-bit capable device on a 64-bit capable bus, and the
>   dma_set_mask call should succeed.
> 
> The mask is definitely never "user" specific, but is a combination of the
> device you have and the bus it is connected to.
> 

Thanks, arnd.

For chipidea generic glue layer case, if there are three devices who use this
driver, and all devices have 32-bit bus, some devices have less 32 address lines.
For example:

- the device_a doesn't need to use dma_mask
- the device_b needs dma_mask as 0xfffffffff
- the device_c needs dma_mask as 0xfffffff0, assume it has only 28 address lines

My questions are:
- Can we not set dma_mask at driver, and only set dma-ranges at dts for device_b
and device_c as a solution to cover this different dma mask use case?

- If we can't use this solution, would you suggest one?

- If we can use this solution, for device_b and device_c, how can we write dma-ranges?
I can't find any arm platforms use it, only some powerpc platform use it.
According to the definition from Power_ePAPR_APPROVED_v1.1.pdf, it is
dma-ranges = <child-bus-address, parent-bus-address, length>
but I find the powerpc has different way for using dma-ranges. 

Peter


