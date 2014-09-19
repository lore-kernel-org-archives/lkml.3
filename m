Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbaISCyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 22:54:47 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:54223 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbaISCyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 22:54:46 -0400
Message-ID: <541B9ADA.2070107@roeck-us.net>
Date: Thu, 18 Sep 2014 19:54:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Pramod Gurav <pramod.gurav@smartplayin.com>
Subject: Re: [PATCH] pinctrl: qcom: use restart_notifier mechanism for ps_hold
References: <1411079579-10172-1-git-send-email-joshc@codeaurora.org>
In-Reply-To: <1411079579-10172-1-git-send-email-joshc@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.541B9AF6.0010,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: 
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 4
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2014 03:32 PM, Josh Cartwright wrote:
> By converting to the restart_notifier mechanism for restart, we allow
> for other mechanisms, like the watchdog, to be used for restart in the
> case where PS_HOLD has failed to reset the chip.
>
> Choose priority 128, as according to documentation, this mechanism "is
> sufficient to restart the entire system".
>
> Cc: Pramod Gurav <pramod.gurav@smartplayin.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
>   drivers/pinctrl/qcom/pinctrl-msm.c | 38 ++++++++++++++++++++++++++------------
>   1 file changed, 26 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
> index d5ed127..9fced3b 100644
> --- a/drivers/pinctrl/qcom/pinctrl-msm.c
> +++ b/drivers/pinctrl/qcom/pinctrl-msm.c
> @@ -27,8 +27,7 @@
>   #include <linux/gpio.h>
>   #include <linux/interrupt.h>
>   #include <linux/spinlock.h>
> -
> -#include <asm/system_misc.h>
> +#include <linux/reboot.h>
>
>   #include "../core.h"
>   #include "../pinconf.h"
> @@ -43,6 +42,7 @@
>    * @dev:            device handle.
>    * @pctrl:          pinctrl handle.
>    * @chip:           gpiochip handle.
> + * @restart_nb:     restart notifier block.
>    * @irq:            parent irq for the TLMM irq_chip.
>    * @lock:           Spinlock to protect register resources as well
>    *                  as msm_pinctrl data structures.
> @@ -56,6 +56,7 @@ struct msm_pinctrl {
>   	struct device *dev;
>   	struct pinctrl_dev *pctrl;
>   	struct gpio_chip chip;
> +	struct notifier_block restart_nb;
>   	int irq;
>
>   	spinlock_t lock;
> @@ -852,13 +853,14 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
>   	return 0;
>   }
>
> -#ifdef CONFIG_ARM

Unrelated to this patch, but is this going to be executed (and potentially used)
on any non-arm architectures ?

Reason for asking that the restart handler mechanism is currently only
implemented on arm and arm64. If it is going to be used with other
architectures, we'll have to add the necessary call into the architecture
restart code.

> -static void __iomem *msm_ps_hold;
> -
> -static void msm_reset(enum reboot_mode reboot_mode, const char *cmd)
> +static int msm_ps_hold_restart(struct notifier_block *nb, unsigned long action,
> +			       void *data)
>   {
> -	writel(0, msm_ps_hold);
> +	struct msm_pinctrl *pctrl = container_of(nb, struct msm_pinctrl, restart_nb);
> +
> +	writel(0, pctrl->regs + PS_HOLD_OFFSET);
>   	mdelay(10000);

Sure you still want to wait for 10 seconds here ?
Would it make sense to choose a more reasonable timeout ?

Thanks,
Guenter

> +	return NOTIFY_DONE;
>   }
>
>   static void msm_pinctrl_setup_pm_reset(struct msm_pinctrl *pctrl)
> @@ -868,13 +870,16 @@ static void msm_pinctrl_setup_pm_reset(struct msm_pinctrl *pctrl)
>
>   	for (; i <= pctrl->soc->nfunctions; i++)
>   		if (!strcmp(func[i].name, "ps_hold")) {
> -			msm_ps_hold = pctrl->regs + PS_HOLD_OFFSET;
> -			arm_pm_restart = msm_reset;
> +			pctrl->restart_nb.notifier_call = msm_ps_hold_restart;
> +			pctrl->restart_nb.priority = 128;
> +			if (register_restart_handler(&pctrl->restart_nb)) {
> +				dev_err(pctrl->dev,
> +					"failed to setup restart handler.\n");
> +				pctrl->restart_nb.notifier_call = NULL;
> +			}
> +			break;
>   		}
>   }
> -#else
> -static void msm_pinctrl_setup_pm_reset(const struct msm_pinctrl *pctrl) {}
> -#endif
>
>   int msm_pinctrl_probe(struct platform_device *pdev,
>   		      const struct msm_pinctrl_soc_data *soc_data)
> @@ -943,6 +948,15 @@ int msm_pinctrl_remove(struct platform_device *pdev)
>
>   	pinctrl_unregister(pctrl->pctrl);
>
> +	if (pctrl->restart_nb.notifier_call) {
> +		ret = unregister_restart_handler(&pctrl->restart_nb);
> +		if (ret) {
> +			dev_err(&pdev->dev,
> +				"unable to unregister restart handler\n");
> +			return ret;
> +		}
> +	}
> +
>   	return 0;
>   }
>   EXPORT_SYMBOL(msm_pinctrl_remove);
>

