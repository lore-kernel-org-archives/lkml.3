Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab3A2NLJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 08:11:09 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:42275 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab3A2NLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 08:11:07 -0500
MIME-Version: 1.0
In-Reply-To: <1358762966-20791-8-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
	<1358762966-20791-8-git-send-email-thierry.reding@avionic-design.de>
Date: Tue, 29 Jan 2013 15:11:05 +0200
Message-ID: <CAHp75VdeBrMg-ccxwY-45H_-_KatdwL7FnjB8SXWWgF1C+9Y1Q@mail.gmail.com>
Subject: Re: [PATCH 07/33] dma: Convert to devm_ioremap_resource()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Vinod Koul <vinod.koul@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 12:09 PM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
>
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
>
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Vinod Koul <vinod.koul@intel.com>
> ---
>  drivers/dma/dw_dmac.c         |  7 ++++---
>  drivers/dma/imx-dma.c         |  7 ++++---
>  drivers/dma/mmp_pdma.c        |  7 ++++---
>  drivers/dma/mmp_tdma.c        |  7 ++++---
>  drivers/dma/tegra20-apb-dma.c | 10 ++++------
>  5 files changed, 20 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 3e8ba02..b33d1f6 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -14,6 +14,7 @@
>  #include <linux/delay.h>
>  #include <linux/dmaengine.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/err.h>
>  #include <linux/init.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
> @@ -1489,9 +1490,9 @@ static int dw_probe(struct platform_device *pdev)
>         if (irq < 0)
>                 return irq;
>
> -       regs = devm_request_and_ioremap(&pdev->dev, io);
> -       if (!regs)
> -               return -EBUSY;
> +       regs = devm_ioremap_resource(&pdev->dev, io);
> +       if (IS_ERR(regs))
> +               return PTR_ERR(regs);

Do you concern that change makes sparse crazy?

drivers/dma/dw_dmac.c:1690:20: warning: incorrect type in argument 1
(different address spaces)
drivers/dma/dw_dmac.c:1690:20:    expected void const *ptr
drivers/dma/dw_dmac.c:1690:20:    got void [noderef] <asn:2>*[assigned] regs
drivers/dma/dw_dmac.c:1691:32: warning: incorrect type in argument 1
(different address spaces)
drivers/dma/dw_dmac.c:1691:32:    expected void const *ptr
drivers/dma/dw_dmac.c:1691:32:    got void [noderef] <asn:2>*[assigned] regs


-- 
With Best Regards,
Andy Shevchenko
