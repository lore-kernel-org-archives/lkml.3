Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbaFWSny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:43:54 -0400
Received: from smtprelay.synopsys.com ([198.182.60.111]:52224 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbaFWSnw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:43:52 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Robert Baldyga <r.baldyga@samsung.com>, "balbi@ti.com" <balbi@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "andrzej.p@samsung.com" <andrzej.p@samsung.com>
Subject: RE: [PATCH 10/11] usb: dwc2/gadget: assign TX FIFO dynamically
Thread-Topic: [PATCH 10/11] usb: dwc2/gadget: assign TX FIFO dynamically
Thread-Index: AQHPjrhd7CUJJ6fO0kiXe1dIRicwl5t/B/Tw
Date: Mon, 23 Jun 2014 18:43:50 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844B9CD9@US01WEMBX2.internal.synopsys.com>
References: <1403509890-14103-1-git-send-email-r.baldyga@samsung.com>
 <1403509890-14103-11-git-send-email-r.baldyga@samsung.com>
In-Reply-To: <1403509890-14103-11-git-send-email-r.baldyga@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Robert Baldyga [mailto:r.baldyga@samsung.com]
> Sent: Monday, June 23, 2014 12:51 AM
> 
> Because we have not enough memory to have each TX FIFO of size at least 3072
> bytes (the maximum single packet size), we create four FIFOs of lenght 1024,
> and four of length 3072 bytes, and assing them to endpoints dynamically
> according to maxpacket size value of given endpoint.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> ---
>  drivers/usb/dwc2/core.h   |  1 +
>  drivers/usb/dwc2/gadget.c | 48 +++++++++++++++++++++++++++++++++--------------
>  2 files changed, 35 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
> index 067390e..23f7e86 100644
> --- a/drivers/usb/dwc2/core.h
> +++ b/drivers/usb/dwc2/core.h
> @@ -197,6 +197,7 @@ struct s3c_hsotg {
>  	int			fifo_mem;
>  	unsigned int            dedicated_fifos:1;
>  	unsigned char           num_of_eps;
> +	u32			fifo_map;
> 
>  	struct dentry           *debug_root;
>  	struct dentry           *debug_file;
> diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
> index 3435711..2a7c014 100644
> --- a/drivers/usb/dwc2/gadget.c
> +++ b/drivers/usb/dwc2/gadget.c
> @@ -184,14 +184,26 @@ static void s3c_hsotg_init_fifo(struct s3c_hsotg *hsotg)
> 
>  	/* start at the end of the GNPTXFSIZ, rounded up */
>  	addr = 2048 + 1024;
> -	size = 768;
> 
>  	/*
>  	 * currently we allocate TX FIFOs for all possible endpoints,
>  	 * and assume that they are all the same size.
>  	 */

I think this comment is no longer correct after this patch, right? In
that case, it should be deleted, or better yet replaced with the text
from the commit message.

-- 
Paul

> -	for (ep = 1; ep <= 15; ep++) {
> +	/* 256*4=1024 bytes FIFO length */
> +	size = 256;
> +	for (ep = 1; ep <= 4; ep++) {
> +		val = addr;
> +		val |= size << FIFOSIZE_DEPTH_SHIFT;
> +		WARN_ONCE(addr + size > hsotg->fifo_mem,
> +			  "insufficient fifo memory");
> +		addr += size;
> +
> +		writel(val, hsotg->regs + DPTXFSIZN(ep));
> +	}
> +	/* 768*4=3072 bytes FIFO length */
> +	size = 768;
> +	for (ep = 5; ep <= 8; ep++) {
>  		val = addr;
>  		val |= size << FIFOSIZE_DEPTH_SHIFT;
>  		WARN_ONCE(addr + size > hsotg->fifo_mem,
> @@ -2440,6 +2452,7 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
>  	u32 epctrl;
>  	u32 mps;
>  	int dir_in;
> +	int i, val, size;
>  	int ret = 0;
> 
>  	dev_dbg(hsotg->dev,
> @@ -2512,17 +2525,8 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
>  		break;
> 
>  	case USB_ENDPOINT_XFER_INT:
> -		if (dir_in) {
> -			/*
> -			 * Allocate our TxFNum by simply using the index
> -			 * of the endpoint for the moment. We could do
> -			 * something better if the host indicates how
> -			 * many FIFOs we are expecting to use.
> -			 */
> -
> +		if (dir_in)
>  			hs_ep->periodic = 1;
> -			epctrl |= DXEPCTL_TXFNUM(index);
> -		}
> 
>  		epctrl |= DXEPCTL_EPTYPE_INTERRUPT;
>  		break;
> @@ -2536,8 +2540,24 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
>  	 * if the hardware has dedicated fifos, we must give each IN EP
>  	 * a unique tx-fifo even if it is non-periodic.
>  	 */
> -	if (dir_in && hsotg->dedicated_fifos)
> -		epctrl |= DXEPCTL_TXFNUM(index);
> +	if (dir_in && hsotg->dedicated_fifos) {
> +		size = hs_ep->ep.maxpacket*hs_ep->mc;
> +		for (i = 1; i < 8; ++i) {
> +			if (hsotg->fifo_map & (1<<i))
> +				continue;
> +			val = readl(hsotg->regs + DPTXFSIZN(i));
> +			val = (val >> FIFOSIZE_DEPTH_SHIFT)*4;
> +			if (val < size)
> +				continue;
> +			hsotg->fifo_map |= 1<<i;
> +			break;
> +		}
> +
> +		if (i == 8)
> +			return -ENOMEM;
> +
> +		epctrl |= DXEPCTL_TXFNUM(i);
> +	}
> 
>  	/* for non control endpoints, set PID to D0 */
>  	if (index)
> --
> 1.9.1

