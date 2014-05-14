Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbaENR7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 13:59:19 -0400
Received: from smtprelay0231.hostedemail.com ([216.40.44.231]:46773 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751925AbaENR7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 13:59:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:4384:5007:6119:6120:7652:7901:8957:10004:10400:10482:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13019:13972:19901:19997,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: drop15_336e01ddae84f
X-Filterd-Recvd-Size: 3668
Message-ID: <1400090352.30384.19.camel@joe-AO725>
Subject: Re: [PATCH 2/2 v2] usb: gadget: net2280: Add support for PLX USB338X
From: Joe Perches <joe@perches.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 14 May 2014 10:59:12 -0700
In-Reply-To: <1400089197-18427-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1400089197-18427-1-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-14 at 19:39 +0200, Ricardo Ribalda Delgado wrote:
> This patch adds support for the PLX USB3380 and USB3382.
> 
> This driver is based on the driver from the manufacturer.
> 
> Since USB338X is register compatible with NET2280, I thought that it
> would be better to include this hardware into net2280 driver.
> 
> Manufacturer's driver only supported the USB33X, did not follow the
> Kernel Style and contain some trivial errors. This patch has tried to
> address this issues.
> 
> This patch has only been tested on USB338x hardware, but the merge has
> been done trying to not affect the behaviour of NET2280.

trivial notes:

> diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
[]
> @@ -148,6 +155,10 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
>  	struct net2280_ep	*ep;
>  	u32			max, tmp;
>  	unsigned long		flags;
> +	static const u32 ep_bit[9] = { 0, 17, 2, 19, 4, 1, 18, 3, 20 };
[]
> @@ -361,6 +407,56 @@ static void ep_reset (struct net2280_regs __iomem *regs, struct net2280_ep *ep)
[]
> +static void ep_reset_338x(struct net2280_regs __iomem *regs,
> +					struct net2280_ep *ep)
> +{
> +	u32 tmp, dmastat;
> +	static const u32 ep_bit[9] = { 0, 17, 2, 19, 4, 1, 18, 3, 20 };

To avoid duplication, perhaps ep_bit should be
declared static const to the module instead of 
declared in multiple functions.

> @@ -874,8 +991,23 @@ net2280_queue (struct usb_ep *_ep, struct usb_request *_req, gfp_t gfp_flags)
>  
>  	/* kickstart this i/o queue? */
>  	if (list_empty (&ep->queue) && !ep->stopped) {
> +		/* DMA request while EP halted */
> +		if (ep->dma
> +		    && (readl(&ep->regs->ep_rsp) & (1 << CLEAR_ENDPOINT_HALT))
> +			&& (dev->pdev->vendor == 0x10b5)) {

Generally logical continuations are at the end-of-line like
		if (ep->dma &&
		    (readl(&ep->regs->ep_rsp) & (1 << CLEAR_ENDPOINT_HALT)) &&
		    (dev->pdev->vendor == 0x10b5)) {

[]

> @@ -1820,7 +2149,122 @@ static void usb_reinit (struct net2280 *dev)
[]
> +		if (dev->enhanced_mode) {
> +			ep->cfg = &dev->epregs[ne[i]];
> +			ep->regs =
> +			    (struct net2280_ep_regs __iomem
> +			     *)(((unsigned char *)&dev->epregs[ne[i]]) +
> +				ep_reg_addr[i]);

I find this pretty difficult to read.
Temporaries might help.

Or maybe cast ep->cfg like
			ep->regs = (struct net2280_ep_regs __iomem *)
				   ((unsigned char *)ep->cfg + ep_reg_addr[i]);
[]

> +	/* AA_AB Errata. Issue 4. Workaround for SuperSpeed USB
> +	   Hot Reset Exit Handshake may Fail in Specific Case using
> +	   Default Register Settings. Workaround for Enumeration test.
> +	 */

linux-kernel multi-line comment style is generally:

	/*
	 * comments...
	 */



