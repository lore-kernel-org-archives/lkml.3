Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaBYCyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 21:54:25 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:21547 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402AbaBYCyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 21:54:23 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dI1432Id799hzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h17326ah8275bh8275dh1de097h186068hz2dh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh1155h)
Date: Tue, 25 Feb 2014 09:59:24 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Neil Zhang <zhangwm@marvell.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] usb: gadget: mv_udc: clear corresponding interrupt
 when flush fifo
Message-ID: <20140225015923.GE7540@shlinux1.ap.freescale.net>
References: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
 <1393228996-14787-4-git-send-email-zhangwm@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1393228996-14787-4-git-send-email-zhangwm@marvell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 04:03:13PM +0800, Neil Zhang wrote:
> The interruts are useless when this endpoint is going to be flushed.
> Especially in the enumeration phase, let's take get device description
> for example.
> 1. Device doesn't ACK the status package from host in time due to irq is
> disabled by some module.
> 2. Host find no ACK in time, and send another request.

Why device does not send NAK at that time?
Besides, you can try to prime status at data stage, it can also
avoid the problem usb 2.0 8.5.3.3 "Error Handling on the Last Data
Transaction" described.

> 3. Device gets the chance to handle the interrupt, the sequence is as
> following.
> 	a. Flush pending requests in ep0.
> 	b. Queue a request in ep0 according to host's request and change
> 	   the ep0 state to DATA_STATE_XMIT.
> 	c. Handle the pending interrupt for the last status package. But
> 	   actually it will check the new added request instead of the status
> 	   package and because of wront ep0 state, device will request an

%s/wront/wrong

Peter

> 	   unexpected status package from host.
> 	d. The ep0 state is going mad.
> 
> The solution is that we need clear the pending corresponding interrupt
> as well as flush
> endpoint.
> 
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> ---
>  drivers/usb/gadget/mv_udc_core.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/usb/gadget/mv_udc_core.c b/drivers/usb/gadget/mv_udc_core.c
> index 657ac5c..d5a9bdf 100644
> --- a/drivers/usb/gadget/mv_udc_core.c
> +++ b/drivers/usb/gadget/mv_udc_core.c
> @@ -692,6 +692,8 @@ static void mv_ep_fifo_flush(struct usb_ep *_ep)
>  		}
>  		loops--;
>  	} while (readl(&udc->op_regs->epstatus) & bit_pos);
> +
> +	writel(bit_pos, &udc->op_regs->epcomplete);
>  }
>  
>  /* queues (submits) an I/O request to an endpoint */
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 

Best Regards,
Peter Chen

