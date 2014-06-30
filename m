Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbaF3Phf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:37:35 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:36009
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751005AbaF3Phd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:37:33 -0400
X-IronPort-AV: E=Sophos;i="5.01,575,1400018400"; 
   d="scan'208";a="69603461"
Date: Mon, 30 Jun 2014 17:37:29 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Alan Stern <stern@rowland.harvard.edu>
cc: Himangi Saraogi <himangi774@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: host: ohci-tmio: Use managed interfaces for resource
 allocation
In-Reply-To: <Pine.LNX.4.44L0.1406301105530.1550-100000@iolanthe.rowland.org>
Message-ID: <alpine.DEB.2.10.1406301737020.3511@hadrien>
References: <Pine.LNX.4.44L0.1406301105530.1550-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Jun 2014, Alan Stern wrote:

> On Sun, 29 Jun 2014, Himangi Saraogi wrote:
>
> > This patch moves resources allocated using ioremap or
> > dma_declare_coherent_memory to the corresponding managed interface. The
> > function calls to free the allocated resources are removed in the probe
> > and remove functions as they are no longer required. Also, some labels
> > are done away with and a new label err added to make it less specific to
> > the context.
> >
> > Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> > Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> > ---
> >  drivers/usb/host/ohci-tmio.c | 36 ++++++++++++------------------------
> >  1 file changed, 12 insertions(+), 24 deletions(-)
> >
> > diff --git a/drivers/usb/host/ohci-tmio.c b/drivers/usb/host/ohci-tmio.c
> > index bb40958..1a6034f 100644
> > --- a/drivers/usb/host/ohci-tmio.c
> > +++ b/drivers/usb/host/ohci-tmio.c
> > @@ -203,10 +203,8 @@ static int ohci_hcd_tmio_drv_probe(struct platform_device *dev)
> >  		return -EINVAL;
> >
> >  	hcd = usb_create_hcd(&ohci_tmio_hc_driver, &dev->dev, dev_name(&dev->dev));
> > -	if (!hcd) {
> > -		ret = -ENOMEM;
> > -		goto err_usb_create_hcd;
> > -	}
> > +	if (!hcd)
> > +		return -ENOMEM;
> >
> >  	hcd->rsrc_start = regs->start;
> >  	hcd->rsrc_len = resource_size(regs);
> > @@ -215,30 +213,31 @@ static int ohci_hcd_tmio_drv_probe(struct platform_device *dev)
> >
> >  	spin_lock_init(&tmio->lock);
> >
> > -	tmio->ccr = ioremap(config->start, resource_size(config));
> > +	tmio->ccr = devm_ioremap(&dev->dev, config->start,
> > +				 resource_size(config));
>
> You should use devm_ioremap_resource() rather than devm_ioremap().

Even if there was no request_mem_region in the original code?

julia

>
> ...
>
> > @@ -259,16 +258,8 @@ err_add_hcd:
> >  	tmio_stop_hc(dev);
> >  	if (cell->disable)
> >  		cell->disable(dev);
> > -err_enable:
> > -	dma_release_declared_memory(&dev->dev);
> > -err_dma_declare:
> > -	iounmap(hcd->regs);
> > -err_ioremap_regs:
> > -	iounmap(tmio->ccr);
> > -err_ioremap_ccr:
> > -	usb_put_hcd(hcd);
> > -err_usb_create_hcd:
> > -
> > +err:
> > +	usb_put_hcr(hcd);
>
> There is no function named "usb_put_hcr()".  Did you try to compile
> this patch?
>
> Alan Stern
>
>
