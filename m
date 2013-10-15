Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751049Ab3JOEkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 00:40:19 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54236 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab3JOEkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 00:40:18 -0400
Message-ID: <525CC725.7060508@ti.com>
Date: Tue, 15 Oct 2013 10:10:05 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>, <kishon@ti.com>,
        <ldewangan@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] extcon: palmas: Handle ID interrupt properly using USB_ID_INT_SRC
References: <1381430919-4635-1-git-send-email-george.cherian@ti.com>
In-Reply-To: <1381430919-4635-1-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laxman/Chanwoo/Kishon,

Any comments on this!!
Regards
-George
On 10/11/2013 12:18 AM, George Cherian wrote:
> Always cross check with the ID state and the source of interrupt.
> Also add a case in which ID Source is ID_GND but LATCH state is set
> wrongly. This uses the previous Link stat to determine the new state.
>
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>   drivers/extcon/extcon-palmas.c | 15 ++++++++++++---
>   1 file changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
> index 6e83e9a..2aea4bc 100644
> --- a/drivers/extcon/extcon-palmas.c
> +++ b/drivers/extcon/extcon-palmas.c
> @@ -78,20 +78,24 @@ static irqreturn_t palmas_vbus_irq_handler(int irq, void *_palmas_usb)
>   
>   static irqreturn_t palmas_id_irq_handler(int irq, void *_palmas_usb)
>   {
> -	unsigned int set;
> +	unsigned int set, id_src;
>   	struct palmas_usb *palmas_usb = _palmas_usb;
>   
>   	palmas_read(palmas_usb->palmas, PALMAS_USB_OTG_BASE,
>   		PALMAS_USB_ID_INT_LATCH_SET, &set);
> +	palmas_read(palmas_usb->palmas, PALMAS_USB_OTG_BASE,
> +		PALMAS_USB_ID_INT_SRC, &id_src);
>   
> -	if (set & PALMAS_USB_ID_INT_SRC_ID_GND) {
> +	if ((set & PALMAS_USB_ID_INT_SRC_ID_GND) &&
> +				(id_src & PALMAS_USB_ID_INT_SRC_ID_GND)) {
>   		palmas_write(palmas_usb->palmas, PALMAS_USB_OTG_BASE,
>   			PALMAS_USB_ID_INT_LATCH_CLR,
>   			PALMAS_USB_ID_INT_EN_HI_CLR_ID_GND);
>   		palmas_usb->linkstat = PALMAS_USB_STATE_ID;
>   		extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", true);
>   		dev_info(palmas_usb->dev, "USB-HOST cable is attached\n");
> -	} else if (set & PALMAS_USB_ID_INT_SRC_ID_FLOAT) {
> +	} else if ((set & PALMAS_USB_ID_INT_SRC_ID_FLOAT) &&
> +				(id_src & PALMAS_USB_ID_INT_SRC_ID_FLOAT)) {
>   		palmas_write(palmas_usb->palmas, PALMAS_USB_OTG_BASE,
>   			PALMAS_USB_ID_INT_LATCH_CLR,
>   			PALMAS_USB_ID_INT_EN_HI_CLR_ID_FLOAT);
> @@ -103,6 +107,11 @@ static irqreturn_t palmas_id_irq_handler(int irq, void *_palmas_usb)
>   		palmas_usb->linkstat = PALMAS_USB_STATE_DISCONNECT;
>   		extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", false);
>   		dev_info(palmas_usb->dev, "USB-HOST cable is detached\n");
> +	} else if ((palmas_usb->linkstat == PALMAS_USB_STATE_DISCONNECT) &&
> +				(id_src & PALMAS_USB_ID_INT_SRC_ID_GND)) {
> +		palmas_usb->linkstat = PALMAS_USB_STATE_ID;
> +		extcon_set_cable_state(&palmas_usb->edev, "USB-HOST", true);
> +		dev_info(palmas_usb->dev, " USB-HOST cable is attached\n");
>   	}
>   
>   	return IRQ_HANDLED;


-- 
-George

