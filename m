Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416Ab3JOQfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 12:35:00 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33776 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758902Ab3JOQe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 12:34:57 -0400
Message-ID: <525D6E86.1040208@ti.com>
Date: Tue, 15 Oct 2013 22:04:14 +0530
From: Balaji T K <balajitk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Andreas Fenkart <afenkart@gmail.com>
CC: Chris Ball <cjb@laptop.org>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        <zonque@gmail.com>, <devicetree-discuss@lists.ozlabs.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mmc@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v3 3/4] mmc: omap_hsmmc: Remux pins to support SDIO interrupt
 on AM335x
References: <1380971830-21492-1-git-send-email-afenkart@gmail.com> <1380971830-21492-4-git-send-email-afenkart@gmail.com>
In-Reply-To: <1380971830-21492-4-git-send-email-afenkart@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Andreas for the patch,

On Saturday 05 October 2013 04:47 PM, Andreas Fenkart wrote:
> The am335x can't detect pending cirq in PM runtime suspend.
> This patch reconfigures dat1 as a GPIO before going to suspend.
> SDIO interrupts are detected with the GPIO, while in runtime
> suspend, standard detection of the module block otherwise.
>
> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
>
> @@ -2293,23 +2440,66 @@ static int omap_hsmmc_resume(struct device *dev)
>   static int omap_hsmmc_runtime_suspend(struct device *dev)
>   {
>   	struct omap_hsmmc_host *host;
> +	unsigned long flags;
> +	int ret = 0;
>
>   	host = platform_get_drvdata(to_platform_device(dev));
>   	omap_hsmmc_context_save(host);
>   	dev_dbg(dev, "disabled\n");
>
> -	return 0;
> +	if (host->flags & HSMMC_SWAKEUP_QUIRK) {
> +		spin_lock_irqsave(&host->irq_lock, flags);
> +		OMAP_HSMMC_WRITE(host->base, ISE, 0);
> +		OMAP_HSMMC_WRITE(host->base, IE, 0);
> +		OMAP_HSMMC_WRITE(host->base, STAT, STAT_CLEAR);
> +		spin_unlock_irqrestore(&host->irq_lock, flags);
> +
> +		ret = pinctrl_select_state(host->pinctrl, host->idle);
> +		if (ret < 0)
> +			dev_warn(mmc_dev(host->mmc), "Unable to select idle pinmux\n");
> +
> +		enable_irq(mmc_slot(host).sdio_irq);
> +	}
> +
> +	spin_lock_irqsave(&host->irq_lock, flags);
> +	/* infinite loop, if irq not cleared in omap_hsmmc_enable_sdio_irq */
> +	host->flags |= HSMMC_RUNTIME_SUSPENDED;

Can you provide more details about the infinite loop and how it will get recovered.

> +	spin_unlock_irqrestore(&host->irq_lock, flags);
> +
> +	return ret;
>   }
>
>   static int omap_hsmmc_runtime_resume(struct device *dev)
>   {
>   	struct omap_hsmmc_host *host;
> +	unsigned long flags;
> +	int ret = 0;
>
>   	host = platform_get_drvdata(to_platform_device(dev));
>   	omap_hsmmc_context_restore(host);
>   	dev_dbg(dev, "enabled\n");
>
> -	return 0;
> +	spin_lock_irqsave(&host->irq_lock, flags);
> +	/* infinite loop, if irq not cleared in omap_hsmmc_enable_sdio_irq */
> +	host->flags &= ~HSMMC_RUNTIME_SUSPENDED;
> +	spin_unlock_irqrestore(&host->irq_lock, flags);
> +
> +	if (host->flags & HSMMC_SWAKEUP_QUIRK) {
> +		disable_irq(mmc_slot(host).sdio_irq);
> +
> +		ret = pinctrl_select_state(host->pinctrl, host->active);
> +		if (ret < 0)
> +			dev_warn(mmc_dev(host->mmc), "Unable to select active pinmux\n");
> +
> +		spin_lock_irqsave(&host->irq_lock, flags);
> +		if (host->flags & HSMMC_SDIO_IRQ_ENABLED) {
> +			OMAP_HSMMC_WRITE(host->base, STAT, STAT_CLEAR);
> +			OMAP_HSMMC_WRITE(host->base, ISE, CIRQ_EN);
> +			OMAP_HSMMC_WRITE(host->base, IE, CIRQ_EN);
> +		}
> +		spin_unlock_irqrestore(&host->irq_lock, flags);
> +	}
> +	return ret;
>   }
>
>   static struct dev_pm_ops omap_hsmmc_dev_pm_ops = {
> diff --git a/include/linux/platform_data/mmc-omap.h b/include/linux/platform_data/mmc-omap.h
> index 2bf1b30..fd5fff5 100644
> --- a/include/linux/platform_data/mmc-omap.h
> +++ b/include/linux/platform_data/mmc-omap.h
> @@ -115,6 +115,7 @@ struct omap_mmc_platform_data {
>
>   		int switch_pin;			/* gpio (card detect) */
>   		int gpio_wp;			/* gpio (write protect) */
> +		int gpio_cirq;			/* gpio (card irq) */
>
>   		int (*set_bus_mode)(struct device *dev, int slot, int bus_mode);
>   		int (*set_power)(struct device *dev, int slot,
> @@ -145,6 +146,9 @@ struct omap_mmc_platform_data {
>   		int card_detect_irq;
>   		int (*card_detect)(struct device *dev, int slot);
>
> +		/* SDIO IRQs */
> +		int sdio_irq;
> +
>   		unsigned int ban_openended:1;
>
>   	} slots[OMAP_MMC_MAX_SLOTS];
>

