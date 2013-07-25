Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab3GYSU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 14:20:56 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:56692 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756883Ab3GYSUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 14:20:54 -0400
Subject: Re: [PATCH] usb: dwc3: core: modify IO memory resource after
 deferred probe completes
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <51F15E85.1050808@cogentembedded.com>
References: <1374769590-14491-1-git-send-email-iivanov@mm-sol.com>
	 <51F15E85.1050808@cogentembedded.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Jul 2013 21:20:51 +0300
Message-ID: <1374776451.24810.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 21:21 +0400, Sergei Shtylyov wrote:
> On 07/25/2013 08:26 PM, Ivan T. Ivanov wrote:
> 
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> > When deferred probe happens driver will try to ioremap multiple times
> > and will fail. Memory resource.start variable is a global variable,
> > modifications in this field will be accumulated on every probe.
> > Fix this by moving the above operations after driver hold all
> > required PHY's.
> 

Forgot to mention, generated on top of Felipe's 'testing' branch.

> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > ---
> >   drivers/usb/dwc3/core.c |   31 ++++++++++++++++---------------
> >   1 file changed, 16 insertions(+), 15 deletions(-)
> 
> > diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> > index 607bef8..50c833f 100644
> > --- a/drivers/usb/dwc3/core.c
> > +++ b/drivers/usb/dwc3/core.c
> [...]
> > @@ -452,6 +437,22 @@ static int dwc3_probe(struct platform_device *pdev)
> >   		return -EPROBE_DEFER;
> >   	}
> >
> > +	dwc->xhci_resources[0].start = res->start;
> > +	dwc->xhci_resources[0].end = dwc->xhci_resources[0].start +
> > +					DWC3_XHCI_REGS_END;
> > +	dwc->xhci_resources[0].flags = res->flags;
> > +	dwc->xhci_resources[0].name = res->name;
> > +
> > +	res->start += DWC3_GLOBALS_REGS_START;
> > +
> > +	 /*
> > +	  * Request memory region but exclude xHCI regs,
> > +	  * since it will be requested by the xhci-plat driver.
> > +	  */
> 
>      Please remove an extra space after a tab on each comment line.
> It seems like a good time to do it, while you're moving this code.
> 

Ok. 

Regards,
Ivan

> > +	regs = devm_ioremap_resource(dev, res);
> > +	if (IS_ERR(regs))
> > +		return PTR_ERR(regs);
> > +
> 
> WBR, Sergei
> 


