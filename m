Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757167AbaIWV5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 17:57:37 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:59776 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757053AbaIWV5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 17:57:36 -0400
Date: Tue, 23 Sep 2014 14:57:31 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Pramod Gurav <pramod.gurav@smartplayin.com>
Subject: Re: [PATCH v2] pinctrl: qcom: use restart_notifier mechanism for
 ps_hold
Message-ID: <20140923215731.GC15481@roeck-us.net>
References: <1411505993-8414-1-git-send-email-joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411505993-8414-1-git-send-email-joshc@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 03:59:53PM -0500, Josh Cartwright wrote:
> By converting to the restart_notifier mechanism for restart, we allow
> for other mechanisms, like the watchdog, to be used for restart in the
> case where PS_HOLD has failed to reset the chip.
> 
> Since this mechanism may be one of several mechanisms registered, change
> the post-ps_hold write timeout to be a more reasonable 1 second instead
> of 10 seconds.
> 
> Choose priority 128, as according to documentation, this mechanism "is
> sufficient to restart the entire system".
> 
> Cc: Pramod Gurav <pramod.gurav@smartplayin.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Tested-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>

Looks good to me.

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
> 
> Changes since v1:
>   - Simplified conditional notifier block registration
>   - Reduced wait time to 1s, which I've found to be sufficient on an IFC6410
>     board.
> 
>  drivers/pinctrl/qcom/pinctrl-msm.c | 31 ++++++++++++++++++-------------
>  1 file changed, 18 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
> index d5ed127..d30dddd 100644
> --- a/drivers/pinctrl/qcom/pinctrl-msm.c
> +++ b/drivers/pinctrl/qcom/pinctrl-msm.c
> @@ -27,8 +27,7 @@
>  #include <linux/gpio.h>
>  #include <linux/interrupt.h>
>  #include <linux/spinlock.h>
> -
> -#include <asm/system_misc.h>
> +#include <linux/reboot.h>
>  
>  #include "../core.h"
>  #include "../pinconf.h"
> @@ -43,6 +42,7 @@
>   * @dev:            device handle.
>   * @pctrl:          pinctrl handle.
>   * @chip:           gpiochip handle.
> + * @restart_nb:     restart notifier block.
>   * @irq:            parent irq for the TLMM irq_chip.
>   * @lock:           Spinlock to protect register resources as well
>   *                  as msm_pinctrl data structures.
> @@ -56,6 +56,7 @@ struct msm_pinctrl {
>  	struct device *dev;
>  	struct pinctrl_dev *pctrl;
>  	struct gpio_chip chip;
> +	struct notifier_block restart_nb;
>  	int irq;
>  
>  	spinlock_t lock;
> @@ -852,13 +853,14 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
>  	return 0;
>  }
>  
> -#ifdef CONFIG_ARM
> -static void __iomem *msm_ps_hold;
> -
> -static void msm_reset(enum reboot_mode reboot_mode, const char *cmd)
> +static int msm_ps_hold_restart(struct notifier_block *nb, unsigned long action,
> +			       void *data)
>  {
> -	writel(0, msm_ps_hold);
> -	mdelay(10000);
> +	struct msm_pinctrl *pctrl = container_of(nb, struct msm_pinctrl, restart_nb);
> +
> +	writel(0, pctrl->regs + PS_HOLD_OFFSET);
> +	mdelay(1000);
> +	return NOTIFY_DONE;
>  }
>  
>  static void msm_pinctrl_setup_pm_reset(struct msm_pinctrl *pctrl)
> @@ -868,13 +870,14 @@ static void msm_pinctrl_setup_pm_reset(struct msm_pinctrl *pctrl)
>  
>  	for (; i <= pctrl->soc->nfunctions; i++)
>  		if (!strcmp(func[i].name, "ps_hold")) {
> -			msm_ps_hold = pctrl->regs + PS_HOLD_OFFSET;
> -			arm_pm_restart = msm_reset;
> +			pctrl->restart_nb.notifier_call = msm_ps_hold_restart;
> +			pctrl->restart_nb.priority = 128;
> +			if (register_restart_handler(&pctrl->restart_nb))
> +				dev_err(pctrl->dev,
> +					"failed to setup restart handler.\n");
> +			break;
>  		}
>  }
> -#else
> -static void msm_pinctrl_setup_pm_reset(const struct msm_pinctrl *pctrl) {}
> -#endif
>  
>  int msm_pinctrl_probe(struct platform_device *pdev,
>  		      const struct msm_pinctrl_soc_data *soc_data)
> @@ -943,6 +946,8 @@ int msm_pinctrl_remove(struct platform_device *pdev)
>  
>  	pinctrl_unregister(pctrl->pctrl);
>  
> +	unregister_restart_handler(&pctrl->restart_nb);
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL(msm_pinctrl_remove);
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
> 
