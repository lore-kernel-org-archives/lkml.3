Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934613AbaH0Njj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:39:39 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53501 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933757AbaH0Njh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:39:37 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 2/2] pinctrl: qcom: Add support for reset for apq8064
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1409077867-9446-2-git-send-email-pramod.gurav@smartplayin.com>
Date: Wed, 27 Aug 2014 08:39:32 -0500
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andy Gross <agross@codeaurora.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <53BA5DC2-68CB-4B61-A090-E8415EEBCF44@codeaurora.org>
References: <1409077867-9446-1-git-send-email-pramod.gurav@smartplayin.com> <1409077867-9446-2-git-send-email-pramod.gurav@smartplayin.com>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 26, 2014, at 1:31 PM, Pramod Gurav <pramod.gurav@smartplayin.com> wrote:

> This patch adds support for reset functions to reboot the boards
> with soc apq8064.
> 
> CC: Linus Walleij <linus.walleij@linaro.org>
> CC: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> CC: Stephen Boyd <sboyd@codeaurora.org>
> CC: Andy Gross <agross@codeaurora.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
> drivers/pinctrl/qcom/pinctrl-apq8064.c |    7 +++++-
> drivers/pinctrl/qcom/pinctrl-msm.c     |   36 ++++++++++++++++++++++++++++++++
> 2 files changed, 42 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pinctrl/qcom/pinctrl-apq8064.c b/drivers/pinctrl/qcom/pinctrl-apq8064.c
> index feb6f15..ef1263c 100644
> --- a/drivers/pinctrl/qcom/pinctrl-apq8064.c
> +++ b/drivers/pinctrl/qcom/pinctrl-apq8064.c
> @@ -324,6 +324,7 @@ enum apq8064_functions {
> 	APQ_MUX_tsif1,
> 	APQ_MUX_tsif2,
> 	APQ_MUX_usb2_hsic,
> +	APQ_MUX_ps_hold,
> 	APQ_MUX_NA,
> };
> 
> @@ -351,6 +352,9 @@ static const char * const gpio_groups[] = {
> 	"gpio78", "gpio79", "gpio80", "gpio81", "gpio82", "gpio83", "gpio84",
> 	"gpio85", "gpio86", "gpio87", "gpio88", "gpio89"
> };
> +static const char * const ps_hold_groups[] = {
> +	"gpio78"
> +};
> static const char * const gsbi1_groups[] = {
> 	"gpio18", "gpio19", "gpio20", "gpio21"
> };
> @@ -477,6 +481,7 @@ static const struct msm_function apq8064_functions[] = {
> 	FUNCTION(tsif1),
> 	FUNCTION(tsif2),
> 	FUNCTION(usb2_hsic),
> +	FUNCTION(ps_hold),
> };
> 
> static const struct msm_pingroup apq8064_groups[] = {
> @@ -558,7 +563,7 @@ static const struct msm_pingroup apq8064_groups[] = {
> 	PINGROUP(75, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> 	PINGROUP(76, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> 	PINGROUP(77, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> -	PINGROUP(78, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(78, ps_hold, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> 	PINGROUP(79, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> 	PINGROUP(80, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> 	PINGROUP(81, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
> index 2738108..f4e4f8f 100644
> --- a/drivers/pinctrl/qcom/pinctrl-msm.c
> +++ b/drivers/pinctrl/qcom/pinctrl-msm.c
> @@ -12,6 +12,7 @@
>  * GNU General Public License for more details.
>  */
> 
> +#include <linux/delay.h>
> #include <linux/err.h>
> #include <linux/io.h>
> #include <linux/module.h>
> @@ -27,12 +28,17 @@
> #include <linux/interrupt.h>
> #include <linux/spinlock.h>
> 
> +#include <asm/system_misc.h>
> +
> #include "../core.h"
> #include "../pinconf.h"
> #include "pinctrl-msm.h"
> #include "../pinctrl-utils.h"
> 
> #define MAX_NR_GPIO 300
> +#define PS_HOLD_OFFSET 0x820
> +
> +static void __iomem *msm_ps_hold;
> 
> /**
>  * struct msm_pinctrl - state for a pinctrl-msm device
> @@ -848,10 +854,31 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
> 	return 0;
> }
> 
> +static void qcom_reset(enum reboot_mode reboot_mode, const char *cmd)
> +{
> +	writel(0, msm_ps_hold);
> +	mdelay(10000);
> +}
> +
> +const struct msm_function
> +*find_pshold_function(const struct msm_function *functions,
> +					unsigned nfunctions, const char *name)
> +{
> +	int i = 0;
> +	const struct msm_function *func;
> +
> +	for (func = functions; i <= nfunctions; func++, i++)
> +		if (!strcmp(func->name, name))
> +			return func;
> +
> +	return NULL;
> +}
> +
> int msm_pinctrl_probe(struct platform_device *pdev,
> 		      const struct msm_pinctrl_soc_data *soc_data)
> {
> 	struct msm_pinctrl *pctrl;
> +	const struct msm_function *func;
> 	struct resource *res;
> 	int ret;
> 
> @@ -871,6 +898,15 @@ int msm_pinctrl_probe(struct platform_device *pdev,
> 	if (IS_ERR(pctrl->regs))
> 		return PTR_ERR(pctrl->regs);
> 
> +#ifdef CONFIG_ARM
> +	func = find_pshold_function(soc_data->functions,
> +					soc_data->nfunctions, "ps_hold");
> +	if (func) {
> +		dev_dbg(&pdev->dev, "Found Function %s\n", func->name);
> +		msm_ps_hold = pctrl->regs + PS_HOLD_OFFSET;
> +		arm_pm_restart = qcom_reset;
> +	}

If we keep this we probably should add something like:

#else
#error “not supported on this arch"

> +#endif
> 	pctrl->irq = platform_get_irq(pdev, 0);
> 	if (pctrl->irq < 0) {
> 		dev_err(&pdev->dev, "No interrupt defined for msmgpio\n");
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

