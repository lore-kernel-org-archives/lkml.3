Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab3GZCG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 22:06:59 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:47313 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049Ab3GZCG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 22:06:58 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb: dwc3: core: modify IO memory resource after
 deferred probe completes
Thread-Topic: [PATCH] usb: dwc3: core: modify IO memory resource after
 deferred probe completes
Thread-Index: AQHOiVPvkmnt8PfOUEep6UDMuSIK7Jl1y1AggACJGwD//92QsA==
Date: Fri, 26 Jul 2013 02:06:55 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030458DE12C9@US01WEMBX2.internal.synopsys.com>
References: <1374769590-14491-1-git-send-email-iivanov@mm-sol.com>
 <A2CA0424C0A6F04399FB9E1CD98E030458DE112E@US01WEMBX2.internal.synopsys.com>
 <20130725205224.GA12209@radagast>
In-Reply-To: <20130725205224.GA12209@radagast>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Thursday, July 25, 2013 1:52 PM
> 
> On Thu, Jul 25, 2013 at 07:46:58PM +0000, Paul Zimmerman wrote:
> > > diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> > > index 607bef8..50c833f 100644
> > > --- a/drivers/usb/dwc3/core.c
> > > +++ b/drivers/usb/dwc3/core.c
> > > @@ -384,21 +384,6 @@ static int dwc3_probe(struct platform_device *pdev)
> > >  		dev_err(dev, "missing memory resource\n");
> > >  		return -ENODEV;
> > >  	}
> > > -	dwc->xhci_resources[0].start = res->start;
> > > -	dwc->xhci_resources[0].end = dwc->xhci_resources[0].start +
> > > -					DWC3_XHCI_REGS_END;
> > > -	dwc->xhci_resources[0].flags = res->flags;
> > > -	dwc->xhci_resources[0].name = res->name;
> > > -
> > > -	res->start += DWC3_GLOBALS_REGS_START;
> > > -
> > > -	 /*
> > > -	  * Request memory region but exclude xHCI regs,
> > > -	  * since it will be requested by the xhci-plat driver.
> > > -	  */
> > > -	regs = devm_ioremap_resource(dev, res);
> > > -	if (IS_ERR(regs))
> > > -		return PTR_ERR(regs);
> > >
> > >  	if (node) {
> > >  		dwc->maximum_speed = of_usb_get_maximum_speed(node);
> > > @@ -452,6 +437,22 @@ static int dwc3_probe(struct platform_device *pdev)
> > >  		return -EPROBE_DEFER;
> > >  	}
> > >
> > > +	dwc->xhci_resources[0].start = res->start;
> > > +	dwc->xhci_resources[0].end = dwc->xhci_resources[0].start +
> > > +					DWC3_XHCI_REGS_END;
> > > +	dwc->xhci_resources[0].flags = res->flags;
> > > +	dwc->xhci_resources[0].name = res->name;
> > > +
> > > +	res->start += DWC3_GLOBALS_REGS_START;
> >
> > Ick. The driver is modifying the struct resource passed to it by the
> 
> heh...
> 
> > platform code? That seems like a layering violation, and is fragile as
> > hell. In addition to this bug, what would happen if the struct resource
> > was declared 'const'?
> 
> nothing would happen if it was declared const since platform_add_device
> makes a copy of what was declared, and that's always non-const.

OK.

> Also, this is not *modifying* what was passed, just skipping the xHCI
> address space so we don't request_mem_region() an area we won't really
> handle and prevent xhci-hcd.ko from probing.

Hmm? platform_get_resource() returns a pointer to an entry in the
platform_device's resource[] array. And "res->start +=" modifies the
entry pointed at. If it didn't, the bug fixed by this patch wouldn't
have happened.

Are you sure this code will work OK if you build the driver as a module,
modprobe it, rmmod it, and then modprobe it again? Seems like it won't,
unless the dev->resource[] array gets reinitialized in between somehow.

All this assumes I'm reading the code correctly, of course. If I'm not,
then never mind :)

-- 
Paul

