Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322AbaGQLZD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:25:03 -0400
Received: from mail-bn1blp0182.outbound.protection.outlook.com ([207.46.163.182]:8331
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932218AbaGQLY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:24:57 -0400
Date: Thu, 17 Jul 2014 19:19:15 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v3 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Message-ID: <20140717111912.GA16025@shlinux1.ap.freescale.net>
References: <1405499166-6726-1-git-send-email-antoine.tenart@free-electrons.com>
 <22032517.gk8PRUMaIU@wuerfel>
 <93903d5fdf85427bb8a418894540c122@BN1PR0301MB0772.namprd03.prod.outlook.com>
 <5456516.0fVZeXjF8k@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5456516.0fVZeXjF8k@wuerfel>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(24454002)(189002)(199002)(164054003)(79102001)(83072002)(76482001)(15975445006)(77982001)(21056001)(74502001)(107046002)(74662001)(97736001)(97756001)(4396001)(46102001)(15395725005)(44976005)(83506001)(19580395003)(81542001)(83322001)(31966008)(102836001)(92566001)(92726001)(86362001)(80022001)(575784001)(85852003)(64706001)(47776003)(20776003)(81342001)(33656002)(69596002)(68736004)(104016003)(15202345003)(46406003)(105606002)(23726002)(110136001)(81156004)(87936001)(106466001)(84676001)(76176999)(54356999)(99396002)(6806004)(50986999)(93886003)(50466002)(26826002)(95666004)(85306003)(6606295002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB567;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027578BB13
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 12:21:56PM +0200, Arnd Bergmann wrote:
> On Thursday 17 July 2014 01:20:54 Peter Chen wrote:
> > Thanks, arnd.
> > 
> > For chipidea generic glue layer case, if there are three devices who use this
> > driver, and all devices have 32-bit bus, some devices have less 32 address lines.
> > For example:
> > 
> > - the device_a doesn't need to use dma_mask
> > - the device_b needs dma_mask as 0xfffffffff
> > - the device_c needs dma_mask as 0xfffffff0, assume it has only 28 address lines
> 
> This makes no sense. You always need a dma mask, so the first case doesn't exist,
> and the second one is the default.
> 
> In the third case, I assume you mean 0x0fffffff, which is a 28-bit mask.
> 
> > My questions are:
> > - Can we not set dma_mask at driver, and only set dma-ranges at dts for device_b
> > and device_c as a solution to cover this different dma mask use case?
> 
> try to understand my earlier reply. What is the problem with device_b?
> Is that a limitation of the bus it is connected to, or the version of the
> chipidea hardware?
> 
> > - If we can't use this solution, would you suggest one?
> 
> It depends on what the requirement of the hardware is, as I explained
> now for three times.
> 

Thanks, Arnd.

Currently, we are designing a generic driver, we don't know what's the
hardware architecture, we are trying to find a solution how to set
dma mask for all possible devices which will use this driver, Antoine's
this patch is trying to cover this feature.

For example, 

Marvell Berlin doesn't need to set dma mask specific.
http://marc.info/?l=linux-arm-kernel&m=140205228507045&w=2
http://www.spinics.net/lists/linux-usb/msg110598.html

Xilinx zynq needs to set dma mask as 0xFFFFFFF0
http://marc.info/?l=linux-usb&m=140384129921706&w=2

FSL i.mx needs to set dma mask as DMA_BIT_MASK(32)
https://git.kernel.org/cgit/linux/kernel/git/gregkh/usb.git/tree/drivers/usb/chipidea/ci_hdrc_imx.c?h=usb-next

-- 

Best Regards,
Peter Chen
