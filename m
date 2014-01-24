Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaAXRnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 12:43:32 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44228 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaAXRna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 12:43:30 -0500
Message-ID: <52E2A643.6050209@cogentembedded.com>
Date: Fri, 24 Jan 2014 21:43:31 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>, linux-usb@vger.kernel.org
CC: balbi@ti.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] usb: musb: musb_host: Enable ISOCH IN handling for
 AM335x host
References: <1390572895-26428-1-git-send-email-george.cherian@ti.com> <1390572895-26428-2-git-send-email-george.cherian@ti.com>
In-Reply-To: <1390572895-26428-2-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 24-01-2014 18:14, George Cherian wrote:

> Enable the isochrounous IN handling for AM335x HOST.
> Reprogram CPPI to receive consecutive ISOCH frames in the same URB.

    Sigh, I knew CPPI ISO path was broken for years but didn't have time to 
fix it. :-(

> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>   drivers/usb/musb/musb_host.c | 29 ++++++++++++++++++++++++++---
>   1 file changed, 26 insertions(+), 3 deletions(-)

> diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
> index ed45572..5b6482c 100644
> --- a/drivers/usb/musb/musb_host.c
> +++ b/drivers/usb/musb/musb_host.c
> @@ -1689,9 +1689,11 @@ void musb_host_rx(struct musb *musb, u8 epnum)
>   			| MUSB_RXCSR_H_AUTOREQ
>   			| MUSB_RXCSR_AUTOCLEAR
>   			| MUSB_RXCSR_RXPKTRDY);
> +

    Not needed.

>   		musb_writew(hw_ep->regs, MUSB_RXCSR, val);
>
> -#if defined(CONFIG_USB_INVENTRA_DMA) || defined(CONFIG_USB_UX500_DMA)
> +#if defined(CONFIG_USB_INVENTRA_DMA) || defined(CONFIG_USB_UX500_DMA) || \
> +	defined(CONFIG_USB_TI_CPPI41_DMA)

    The DaVinci CPPI 3.0 should probably also be included here...

>   		if (usb_pipeisoc(pipe)) {
>   			struct usb_iso_packet_descriptor *d;
>
> @@ -1706,8 +1708,28 @@ void musb_host_rx(struct musb *musb, u8 epnum)
>
>   			if (++qh->iso_idx >= urb->number_of_packets)
>   				done = true;
> -			else
> +			else {

    If you're making the *else* arm use {}, you should make all the other arms 
of *if* statement also have them -- see Documentation/CodingStyle.

WBR, Sergei

