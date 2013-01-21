Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab3AUK1M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:27:12 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:56097 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab3AUK1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:27:10 -0500
Date: Mon, 21 Jan 2013 02:27:08 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 12/33] Input: Convert to devm_ioremap_resource()
Message-ID: <20130121102708.GB13784@core.coreip.homeip.net>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-13-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358762966-20791-13-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 11:09:05AM +0100, Thierry Reding wrote:
> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
> 
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

> Cc: linux-input@vger.kernel.org
> ---
>  drivers/input/keyboard/spear-keyboard.c | 8 +++-----
>  drivers/input/serio/arc_ps2.c           | 7 ++++---
>  2 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/input/keyboard/spear-keyboard.c b/drivers/input/keyboard/spear-keyboard.c
> index 695d237..cb1e8f6 100644
> --- a/drivers/input/keyboard/spear-keyboard.c
> +++ b/drivers/input/keyboard/spear-keyboard.c
> @@ -228,11 +228,9 @@ static int spear_kbd_probe(struct platform_device *pdev)
>  		kbd->suspended_rate = pdata->suspended_rate;
>  	}
>  
> -	kbd->io_base = devm_request_and_ioremap(&pdev->dev, res);
> -	if (!kbd->io_base) {
> -		dev_err(&pdev->dev, "request-ioremap failed for kbd_region\n");
> -		return -ENOMEM;
> -	}
> +	kbd->io_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(kbd->io_base))
> +		return PTR_ERR(kbd->io_base);
>  
>  	kbd->clk = devm_clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(kbd->clk))
> diff --git a/drivers/input/serio/arc_ps2.c b/drivers/input/serio/arc_ps2.c
> index b571eb3..c52e3e5 100644
> --- a/drivers/input/serio/arc_ps2.c
> +++ b/drivers/input/serio/arc_ps2.c
> @@ -8,6 +8,7 @@
>   * Driver is originally developed by Pavel Sokolov <psokolov@synopsys.com>
>   */
>  
> +#include <linux/err.h>
>  #include <linux/module.h>
>  #include <linux/interrupt.h>
>  #include <linux/input.h>
> @@ -206,9 +207,9 @@ static int arc_ps2_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
>  
> -	arc_ps2->addr = devm_request_and_ioremap(&pdev->dev, res);
> -	if (!arc_ps2->addr)
> -		return -EBUSY;
> +	arc_ps2->addr = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(arc_ps2->addr))
> +		return PTR_ERR(arc_ps2->addr);
>  
>  	dev_info(&pdev->dev, "irq = %d, address = 0x%p, ports = %i\n",
>  		 irq, arc_ps2->addr, ARC_PS2_PORTS);
> -- 
> 1.8.1.1
> 

-- 
Dmitry
