Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946241Ab3BHKlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 05:41:07 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:47770 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946128Ab3BHKlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 05:41:04 -0500
Message-ID: <5114D58A.1030903@openwrt.org>
Date: Fri, 08 Feb 2013 11:38:02 +0100
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: manjunath.goudar@linaro.org
CC: linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, stern@rowland.harvard.edu, arnd@linaro.org,
        gregkh@linuxfoundation.org, Greg KH <greg@kroah.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] USB: EHCI: make ehci-orion a separate driver
References: <yes> <1360258447-27247-1-git-send-email-yes> <5113e5f0.c84e420a.08c3.ffffbe9a@mx.google.com>
In-Reply-To: <5113e5f0.c84e420a.08c3.ffffbe9a@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Manjunath,

On 02/07/2013 06:34 PM, manjunath.goudar@linaro.org wrote:
> From: Manjunath Goudar <manjunath.goudar@linaro.org>
>
> Separate the Marvell Orion host controller driver from ehci-hcd host code
> into its own driver module.
>
[snip]

The changes you introduce in ehci-hcd.c would certainly deserve their 
own preliminary patch in this serie and not be squashed into this one imho.

> --- a/drivers/usb/host/ehci-hcd.c
> +++ b/drivers/usb/host/ehci-hcd.c
> @@ -155,7 +155,7 @@ static inline unsigned ehci_read_frame_index(struct ehci_hcd *ehci)
>    * before driver shutdown. But it also seems to be caused by bugs in cardbus
>    * bridge shutdown:  shutting down the bridge before the devices using it.
>    */
> -static int handshake (struct ehci_hcd *ehci, void __iomem *ptr,
> +int handshake(struct ehci_hcd *ehci, void __iomem *ptr,
>   		      u32 mask, u32 done, int usec)
>   {
>   	u32	result;
> @@ -172,9 +172,9 @@ static int handshake (struct ehci_hcd *ehci, void __iomem *ptr,
>   	} while (usec > 0);
>   	return -ETIMEDOUT;
>   }
> -
> +EXPORT_SYMBOL_GPL(handshake);

This sounds way too generic as a name to be exported as is, so please 
namespace this with ehci_hcd_ at least.

>   /* check TDI/ARC silicon is in host mode */
> -static int tdi_in_host_mode (struct ehci_hcd *ehci)
> +static int tdi_in_host_mode(struct ehci_hcd *ehci)

Looks unrelated to the goals of your patches.

>   {
>   	u32		tmp;
>
> @@ -186,7 +186,7 @@ static int tdi_in_host_mode (struct ehci_hcd *ehci)
>    * Force HC to halt state from unknown (EHCI spec section 2.3).
>    * Must be called with interrupts enabled and the lock not held.
>    */
> -static int ehci_halt (struct ehci_hcd *ehci)
> +int ehci_halt(struct ehci_hcd *ehci)
>   {
>   	u32	temp;
>
> @@ -215,9 +215,9 @@ static int ehci_halt (struct ehci_hcd *ehci)
>   	return handshake(ehci, &ehci->regs->status,
>   			  STS_HALT, STS_HALT, 16 * 125);
>   }
> -
> +EXPORT_SYMBOL_GPL(ehci_halt);

I would rename this to ehci_hcd_halt to express the fact that it takes 
an ehci_hcd structure pointer as parameter, can be addressed later.

>   /* put TDI/ARC silicon into EHCI mode */
> -static void tdi_reset (struct ehci_hcd *ehci)
> +void tdi_reset(struct ehci_hcd *ehci)
>   {
>   	u32		tmp;
>
> @@ -231,12 +231,12 @@ static void tdi_reset (struct ehci_hcd *ehci)
>   		tmp |= USBMODE_BE;
>   	ehci_writel(ehci, tmp, &ehci->regs->usbmode);
>   }
> -
> +EXPORT_SYMBOL_GPL(tdi_reset);

Same here, way too generic to be exported as is as a symbol name.
--
Florian
