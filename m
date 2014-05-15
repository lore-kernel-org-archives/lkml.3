Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbaEOSkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:40:32 -0400
Received: from smtprelay0028.hostedemail.com ([216.40.44.28]:40890 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752681AbaEOSkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:40:31 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1544:1593:1594:1605:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3622:3865:3866:3867:3868:3870:3871:3874:4250:4321:4384:4605:5007:6119:6120:7652:7901:8957:10004:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: toy35_2140c0d994e19
X-Filterd-Recvd-Size: 5640
Message-ID: <1400179227.5058.14.camel@joe-AO725>
Subject: Re: [PATCH 2/2 v4] usb: gadget: net2280: Add support for PLX USB338X
From: Joe Perches <joe@perches.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, auttamchandani@logicube.com
Date: Thu, 15 May 2014 11:40:27 -0700
In-Reply-To: <1400156926-11100-2-git-send-email-ricardo.ribalda@gmail.com>
References: <1400156926-11100-1-git-send-email-ricardo.ribalda@gmail.com>
	 <1400156926-11100-2-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-15 at 14:28 +0200, Ricardo Ribalda Delgado wrote:
> This patch adds support for the PLX USB3380 and USB3382.

A few more trivial notes, all can be addressed
as follow-on patches or perhaps even ignored
altogether.

> diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c

[]

> @@ -90,11 +97,12 @@ static const char *const ep_name [] = {
>   */
>  static bool use_dma = 1;
>  static bool use_dma_chaining = 0;
> +static bool use_msi = 1;

Nicer to use true/false instead of 1/0
 
[]

> @@ -161,11 +172,20 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
>  	if ((desc->bEndpointAddress & 0x0f) == EP_DONTUSE)
>  		return -EDOM;
>  
> +	if (dev->pdev->vendor == 0x10b5) {

There are several tests of vendor that
could use #define constants instead of
magic numbers

Also, perhaps these parts will be used
by other vendors and might have to be
expanded.

>  	/* sanity check ep-e/ep-f since their fifos are small */
>  	max = usb_endpoint_maxp (desc) & 0x1fff;
> -	if (ep->num > 4 && max > 64)
> +	if (ep->num > 4 && max > 64 && (dev->pdev->vendor == 0x17cc))
>  		return -ERANGE;

Maybe too specific to one vendor ID?
 
> +

Superfluous blank line

> @@ -176,7 +196,8 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
>  	ep->out_overflow = 0;
>  
>  	/* set speed-dependent max packet; may kick in high bandwidth */
> -	set_idx_reg (dev->regs, REG_EP_MAXPKT (dev, ep->num), max);
> +	set_idx_reg(dev->regs, (dev->enhanced_mode) ? ep_enhanced[ep->num]
> +					: REG_EP_MAXPKT(dev, ep->num), max);

Maybe a static inline/macro helper function for this?

	dev->enhanced_mode ? ep_enhanced[ep->num] : REG_EP_MAXPKT(dev, ep->num)
 
> @@ -226,11 +267,13 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
[]
>  	/* enable irqs */
>  	if (!ep->dma) {				/* pio, per-packet */
> -		tmp = (1 << ep->num) | readl (&dev->regs->pciirqenb0);
> +		tmp = (dev->pdev->vendor == 0x17cc)?(1 << ep->num)
> +						   : (1 << ep_bit[ep->num]);

And another static inline/macro helper for this?

> @@ -251,8 +294,10 @@ net2280_enable (struct usb_ep *_ep, const struct usb_endpoint_descriptor *desc)
>  			tmp = (1 << SHORT_PACKET_TRANSFERRED_INTERRUPT_ENABLE);
>  			writel (tmp, &ep->regs->ep_irqenb);
>  
> -			tmp = (1 << ep->num) | readl (&dev->regs->pciirqenb0);
> -			writel (tmp, &dev->regs->pciirqenb0);
> +			tmp = (dev->pdev->vendor == 0x17cc)?(1 << ep->num)
> +						: (1 << ep_bit[ep->num]);

This one is used twice and should use at
least the same formatting.

[]

> @@ -361,6 +407,55 @@ static void ep_reset (struct net2280_regs __iomem *regs, struct net2280_ep *ep)
[]
> +	writel((1 << SHORT_PACKET_OUT_DONE_INTERRUPT) |
> +	       (1 << SHORT_PACKET_TRANSFERRED_INTERRUPT) |
> +	       (1 << FIFO_OVERFLOW) |
> +	       (1 << DATA_PACKET_RECEIVED_INTERRUPT) |
> +	       (1 << DATA_PACKET_TRANSMITTED_INTERRUPT) |
> +	       (1 << DATA_OUT_PING_TOKEN_INTERRUPT) |
> +	       (1 << DATA_IN_TOKEN_INTERRUPT), &ep->regs->ep_stat);
> +}

Perhaps these should use the BIT macro

	writel((BIT(SHORT_PACKET_OUT_DONE_INTERRUPT) |
		BIT(SHORT_PACKET_TRANSFERRED_INTERRUPT) |
		BIT(FIFO_OVERFLOW) |
etc...
> 
@@ -374,13 +469,17 @@ static int net2280_disable (struct usb_ep *_ep)
>  
>  	spin_lock_irqsave (&ep->dev->lock, flags);
>  	nuke (ep);
> -	ep_reset (ep->dev->regs, ep);
> +
> +	if (ep->dev->pdev->vendor == 0x10b5)

Another vendor ID that could be a #define

> @@ -874,8 +990,23 @@ net2280_queue (struct usb_ep *_ep, struct usb_request *_req, gfp_t gfp_flags)
>  
>  	/* kickstart this i/o queue? */
>  	if (list_empty (&ep->queue) && !ep->stopped) {
> +		/* DMA request while EP halted */
> +		if (ep->dma &&
> +		    (readl(&ep->regs->ep_rsp) & (1 << CLEAR_ENDPOINT_HALT)) &&
> +			(dev->pdev->vendor == 0x10b5)) {

here too

> +static void defect7374_workaround(struct net2280 *dev, struct usb_ctrlrequest r)
[]
> +	if (ack_wait_timeout >= DEFECT_7374_NUMBEROF_MAX_WAIT_LOOPS) {
> +		ERROR(dev, "FAIL: Defect 7374 workaround waited but failed");
> +		ERROR(dev, "to detect SS host's data phase ACK.");
> +		ERROR(dev, "PL_EP_STATUS_1(23:16):.Expected from 0x11 to 0x16");
> +		ERROR(dev, "got 0x%2.2x.\n", state >> STATE);

I'd use just 2 output lines/ERROR calls here.

> +	} else {
> +		WARNING(dev, "INFO: Defect 7374 workaround waited about\n");
> +		WARNING(dev, "%duSec for Control Read Data Phase ACK\n",
> +			DEFECT_7374_PROCESSOR_WAIT_TIME * ack_wait_timeout);

and just 1 here


