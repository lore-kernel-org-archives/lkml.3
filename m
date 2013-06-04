Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3FDNAv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 09:00:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62442 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab3FDNAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 09:00:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>, viresh.kumar@linaro.org,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v1 3/4] dma: dw: split driver to library part and platform code
Date: Tue, 04 Jun 2013 15:00:43 +0200
Message-ID: <4155522.4XZWB6Jmjq@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1370349382-20914-4-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1370349382-20914-1-git-send-email-andriy.shevchenko@linux.intel.com> <1370349382-20914-4-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:/A/ntcNDh/tGBYvXUoIyqyFgXIVPBbs7aIXgDcu4RVL
 sg2WBPYoC8gwJIgw0BW7HQQydK+NJ+w0ow2QjS3WaJbcQ1kasR
 M2vyZAwgv94PtWqEPyD9fpH/D7qDbVskablMGvZ55FWEbbL+oF
 H7vlfiUhwxP2yCcn/DGZ1RIbx065LGI4N8DRdoB1rQpLxb4ZhH
 kZ5GMFLWu5GTBvhQJiU9otySfoxqN1KUTG0N++UEnTmlDzOjfi
 mCevUihoA+NdTkjK2s8q626yGFDe9Rt9DWHURKU6NKIXjuis0T
 HR6Bm9RzCGB9TP+afv66EZHVwXNO65Kwu1XGHb84koq1YAuCv1
 IPA6RAEqfhwS6neZuqf8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 June 2013 15:36:21 Andy Shevchenko wrote:
> To simplify the driver development let's split driver to library and platform
> code parts. It helps us to add PCI driver in future.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/Makefile                      |   2 +-
>  drivers/dma/dw/Kconfig                    |   8 +-
>  drivers/dma/dw/Makefile                   |   6 +-
>  drivers/dma/dw/{dw_dmac.c => core.c}      | 309 ++++--------------------------
>  drivers/dma/dw/internal.h                 |  74 +++++++
>  drivers/dma/dw/platform.c                 | 308 +++++++++++++++++++++++++++++
>  drivers/dma/dw/{dw_dmac_regs.h => regs.h} |   1 +

Looks good to me, just one issue I found:

> +#ifdef CONFIG_PM_SLEEP
> +
> +int dw_dma_suspend_noirq(struct dw_dma_chip *chip);
> +int dw_dma_resume_noirq(struct dw_dma_chip *chip);
> +
> +#else /* !CONFIG_PM_SLEEP */
> +
> +#define dw_dma_suspend_noirq	NULL
> +#define dw_dma_resume_noirq	NULL
> +
> +#endif /* !CONFIG_PM_SLEEP */

This won't work ...

> +static int dw_suspend_noirq(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct dw_dma_chip *chip = platform_get_drvdata(pdev);
> +
> +	return dw_dma_suspend_noirq(chip);
> +}
> +
> +static int dw_resume_noirq(struct device *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct dw_dma_chip *chip = platform_get_drvdata(pdev);
> +
> +	return dw_dma_resume_noirq(chip);
> +}

when you try to call NULL as a function.

Please try to get it to build with CONFIG_PM_SLEEP disabled.

	Arnd
