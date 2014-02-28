Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaB1Ofo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 09:35:44 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:22230 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbaB1Ofn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 09:35:43 -0500
Message-ID: <53109EBE.4020900@atmel.com>
Date: Fri, 28 Feb 2014 15:35:42 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Felipe Balbi <balbi@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>
Subject: Re: [PATCH] usb: gadget: atmel_usba: fix crash when no endpoint are
 specified
References: <1393515733-15764-1-git-send-email-alexandre.belloni@free-electrons.com>
In-Reply-To: <1393515733-15764-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/02/2014 16:42, Alexandre Belloni :
> If no endpoints are present in the device tree, the kernel will cras hwith the

s/cras hwith/crash with/

> following error:
> 
> Unable to handle kernel paging request at virtual address 00101008
> [...]
> [<c0222ff4>] (composite_dev_prepare) from [<c022326c>] (composite_bind+0x5c/0x190)
> [<c022326c>] (composite_bind) from [<c021ff8c>] (udc_bind_to_driver+0x48/0xf0)
> [<c021ff8c>] (udc_bind_to_driver) from [<c02208e0>] (usb_gadget_probe_driver+0x7c/0xa0)
> [<c02208e0>] (usb_gadget_probe_driver) from [<c0008970>] (do_one_initcall+0x94/0x140)
> [<c0008970>] (do_one_initcall) from [<c04b4b50>] (kernel_init_freeable+0xec/0x1b4)
> [<c04b4b50>] (kernel_init_freeable) from [<c0376cc4>] (kernel_init+0x8/0xe4)
> [<c0376cc4>] (kernel_init) from [<c0009590>] (ret_from_fork+0x14/0x24)
> Code: e5950014 e1a04001 e5902008 e3a010d0 (e5922008)
> ---[ end trace 35c74bdd89b373d0 ]---
> Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> 
> This checks for that case and returns an error, not allowing the driver to be
> loaded with no endpoints.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  drivers/usb/gadget/atmel_usba_udc.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
> index 52771d4c44bc..e3e0c8ff242e 100644
> --- a/drivers/usb/gadget/atmel_usba_udc.c
> +++ b/drivers/usb/gadget/atmel_usba_udc.c
> @@ -1914,6 +1914,12 @@ static struct usba_ep * atmel_udc_of_init(struct platform_device *pdev,
>  		i++;
>  	}
>  
> +	if (i == 0) {
> +		dev_err(&pdev->dev, "of_probe: no endpoint specified\n");
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +

It is better for debugging when creating a DT for a new SoC. So, okay.

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

>  	return eps;
>  err:
>  	return ERR_PTR(ret);
> 


-- 
Nicolas Ferre
