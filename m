Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909Ab3EWOMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:12:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60562 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758530Ab3EWOLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:11:30 -0400
Date: Thu, 23 May 2013 10:11:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roger Quadros <rogerq@ti.com>
cc: gregkh@linuxfoundation.org, <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 1/1] USB: ehci-omap: Reset dma_mask pointer on probe
In-Reply-To: <1369304387-29610-2-git-send-email-rogerq@ti.com>
Message-ID: <Pine.LNX.4.44L0.1305231009230.1459-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 May 2013, Roger Quadros wrote:

> Device tree probed devices don't get dma_mask set. Previously
> we were setting the dma_mask pointer only if it was NULL.
> However, the address of 'omap_ehci_dma_mask' would change
> each time the module is unloaded and loaded back thus causing
> the devices dma_mask pointer to be invalid on the next load.
> 
> This will cause page faults if any driver tries to access the
> old dma_mask pointer.
> 
> Unconditionally re-setting the dma_mask pointer fixes this problem.

> diff --git a/drivers/usb/host/ehci-omap.c b/drivers/usb/host/ehci-omap.c
> index 3d1491b..b33e306 100644
> --- a/drivers/usb/host/ehci-omap.c
> +++ b/drivers/usb/host/ehci-omap.c
> @@ -146,8 +146,7 @@ static int ehci_hcd_omap_probe(struct platform_device *pdev)
>  	 * Since shared usb code relies on it, set it here for now.
>  	 * Once we have dma capability bindings this can go away.
>  	 */
> -	if (!pdev->dev.dma_mask)
> -		pdev->dev.dma_mask = &omap_ehci_dma_mask;
> +	pdev->dev.dma_mask = &omap_ehci_dma_mask;

Is this the solution that people have agreed on?  There has been a lot 
of discussion on this topic.  In particular, there has been talk about 
fixing it in the DT core.

This particular approach doesn't seem very robust.  What if 
pdev->dev.dma_mask is already set to a different value for some good 
reason?

Alan Stern

