Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaIZAXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 20:23:53 -0400
Received: from mail-bn1on0138.outbound.protection.outlook.com ([157.56.110.138]:11168
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752312AbaIZAXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 20:23:52 -0400
Date: Fri, 26 Sep 2014 08:23:40 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>,
        <alexandre.belloni@free-electrons.com>, <p.zabel@pengutronix.de>,
        <jszhang@marvell.com>, <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
Message-ID: <20140926002339.GB3026@peterchendt>
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com>
 <1411468088-5702-8-git-send-email-antoine.tenart@free-electrons.com>
 <20140925011647.GB3716@peterchendt> <3696520.MDUrkdjfGZ@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3696520.MDUrkdjfGZ@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(51704005)(189002)(24454002)(50466002)(74662003)(46102003)(74502003)(80022003)(77982003)(76482002)(81542003)(81342003)(93886004)(85306004)(110136001)(87936001)(33716001)(79102003)(31966008)(97736003)(107046002)(33656002)(57986006)(86362001)(85852003)(99396003)(92566001)(6806004)(21056001)(102836001)(83072002)(44976005)(20776003)(47776003)(90102001)(46406003)(120916001)(23726002)(10300001)(68736004)(69596002)(83322001)(95666004)(84676001)(83506001)(104016003)(106466001)(92726001)(97756001)(81156004)(64706001)(76176999)(50986999)(54356999)(4396001)(105606002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0637;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0637;
X-Forefront-PRVS: 03468CBA43
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 09:11:35AM +0200, Arnd Bergmann wrote:
> On Thursday 25 September 2014 09:16:48 Peter Chen wrote:
> > > +     }
> > > +
> > > +     if (dev->of_node) {
> > > +             ret = ci_hdrc_usb2_dt_probe(dev, ci_pdata);
> > > +             if (ret)
> > > +                     goto clk_err;
> > > +     } else {
> > > +             ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> > > +             if (ret)
> > > +                     goto clk_err;
> > > +     }
> > 
> > Hi Antoine, the above code may not be needed, since get phy and set dma
> > mask are common operation, we can do it at core code, the only thing you
> > need to do is something like: dev->dma_mask = DMA_BIT_MASK(32).
> > 
> 
> Certainly not, doing that would be broken for a number of reasons:
> 
> - dev->dma_mask is a pointer, a driver should not reassign that
> - the device may have been set up for a bus that requires a smaller mask
>   that is already set, changing the mask would cause data corruption
> - setting just the dma mask but not coherent mask is wrong
> - setting the dma mask can fail, e.g. if the mask is smaller than the
>   smallest memory zone, so you have to check the return value.
> 

In current chipidea structure, the parent (glue layer) driver will not be
used for dma, udc/host driver uses dma mask from child (core layer), at core
layer we will do:


	pdev->dev.dma_mask = dev->dma_mask; /* this device is parent */
	dma_set_coherent_mask(&pdev->dev, dev->coherent_dma_mask);

Would you suggestion us a suitable way? Or it is ok we use just Antoine's way that
call dma_coerce_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32)) at parent
driver no matter dt or non-dt? Thanks.

-- 
Best Regards,
Peter Chen
