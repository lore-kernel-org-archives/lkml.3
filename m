Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab3K2RE5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 12:04:57 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51921 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757069Ab3K2REy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 12:04:54 -0500
Message-ID: <5298C932.60709@ti.com>
Date: Fri, 29 Nov 2013 12:04:50 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Chao Xu <caesarxuchao@gmail.com>
CC: <linux-omap@vger.kernel.org>, Kevin Hilman <khilman@linaro.org>,
        <linus.walleij@linaro.org>, <linux-gpio@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <tony@atomide.com>, <balbi@ti.com>,
        Nishanth Menon <nm@ti.com>, Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH V2] gpio: omap: refresh patch "be more aggressive with
 pm_runtime" against v3.12-rc5
References: <1385506004-14943-1-git-send-email-caesarxuchao@gmail.com>
In-Reply-To: <1385506004-14943-1-git-send-email-caesarxuchao@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Kevin's Linaro id, + Nishant,

On Tuesday 26 November 2013 05:46 PM, Chao Xu wrote:
> From: Felipe Balbi <balbi@ti.com>
> 
> try to keep gpio block suspended as much as possible.
> 
> Tested with pandaboard and a sysfs exported gpio.
> 
> Signed-off-by: Felipe Balbi <balbi at ti.com>
> 
> [caesarxuchao@gmail.com : Refreshed against v3.12-rc5, and added revision check to enable aggressive pm_runtime on OMAP4-only. Because am33xx_gpio_sysc.idlemodes seems to be wrongly marked as SIDLE_SMART_WKUP, which might cause missed interrupts with this patch. Tested on Pandaboard rev A2.]
> 
Please format the text and limit it to 80 char rule.

> Signed-off-by: Chao Xu <caesarxuchao@gmail.com>
> ---
> According to Mr. Felipe Balbi, the original patch was not accepted because interrupts would be missed when GPIO was used as IRQ source. But in my tests with pandaboard, interrupts were not missed. This is because _idle_sysc() sets the idlemode of gpio module to smart-idle-wakeup, and according to OMAP4430 TRM, under this idlemode, the gpio can generate an asynchronous wakeup request to the PRCM. And after GPIO is awake, the wake-up request is reflected into the interrupt status registers. 
> 
> A change made on the original patch is only applying the aggressive runtime pm scheme on OMAP4, because I don’t have HW to test OMAP3 or am33xx devices. According to the respective TRMs, their GPIO modules also can generate wake-up request if the idlemode is set to smart-idle or smart-idle-wakeup. So the patch should work for them, too. But I suspect a potential SW bug may cause missed interrupts: the am33xx_gpio_sysc.idlemodes is marked as capable of SIDLE_SMART_WKUP in omap_hwmod_33xx.c. But according to AM335x TRM, _only_ gpio0 is capable of this mode. This may make GPIO stuck in force-idle mode and unable to generate wakeup request. And thus interrupt will be missed. Again, I don’t have the HW to verify whether this is a bug or not :(
> 
In general I am not against this idea but patch has many assumptions which
are not entirely correct.

- SMART_WAKEUP will take care of waking IP etc not always true to power
domain getting into idle.

- If we want to go on this path then I would like to see we address
omap2_gpio_[prepare/resumne]_for_idle()

- GPIO though sound simple is one of the most notorious IP block
on PM front so this needs lot of testing. This patch not seems be
tested at all so I would have much liked it to be in RFC/RFT
state.

>  drivers/gpio/gpio-omap.c                |  103 ++++++++++++++++++++++++++-----
>  include/linux/platform_data/gpio-omap.h |    1 +
>  2 files changed, 87 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/gpio/gpio-omap.c b/drivers/gpio/gpio-omap.c
> index 89675f8..90661f2 100644
> --- a/drivers/gpio/gpio-omap.c
> +++ b/drivers/gpio/gpio-omap.c
> @@ -76,6 +76,7 @@ struct gpio_bank {
>  	int context_loss_count;
>  	int power_mode;
>  	bool workaround_enabled;
> +	bool is_aggressive_pm;
>  
>  	void (*set_dataout)(struct gpio_bank *bank, int gpio, int enable);
>  	int (*get_context_loss_count)(struct device *dev);
> @@ -473,8 +474,15 @@ static void _disable_gpio_module(struct gpio_bank *bank, unsigned offset)
>  static int gpio_is_input(struct gpio_bank *bank, int mask)
>  {
>  	void __iomem *reg = bank->base + bank->regs->direction;
> +	u32 val;
>  
> -	return __raw_readl(reg) & mask;
> +	if (bank->is_aggressive_pm)
> +		pm_runtime_get_sync(bank->dev);
> +	val = __raw_readl(reg) & mask;
> +	if (bank->is_aggressive_pm)
> +		pm_runtime_put(bank->dev);
> +
Move above in some wrapper instead of sprinkling the
'is_aggressive_pm' check everywhere.
  
> @@ -1585,18 +1651,21 @@ static const struct omap_gpio_platform_data omap2_pdata = {
>  	.regs = &omap2_gpio_regs,
>  	.bank_width = 32,
>  	.dbck_flag = false,
> +	.is_aggressive_pm = false,
>  };
>  
>  static const struct omap_gpio_platform_data omap3_pdata = {
>  	.regs = &omap2_gpio_regs,
>  	.bank_width = 32,
>  	.dbck_flag = true,
> +	.is_aggressive_pm = false,
>  };
>  
>  static const struct omap_gpio_platform_data omap4_pdata = {
>  	.regs = &omap4_gpio_regs,
>  	.bank_width = 32,
>  	.dbck_flag = true,
> +	.is_aggressive_pm = true,
>  };
>  
Well OMAP IP shouldn't have different behavior on OMAP3 and
OMAP4 at least so something you can enable for OMAP4, you
should be able to do it for OMAP3 as well.

Kevin might have some more concerns to add.

Regards,
Santosh

