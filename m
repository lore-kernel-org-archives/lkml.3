Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458AbaH2B20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 21:28:26 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:13971 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752325AbaH2B2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 21:28:23 -0400
Date: Thu, 28 Aug 2014 18:28:21 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andy Gross <agross@codeaurora.org>
Subject: Re: [PATCH 4/4] pinctrl: qcom: Add support for reset for apq8064
Message-ID: <20140829012819.GE12494@sonymobile.com>
References: <1409282570-27299-1-git-send-email-pramod.gurav@smartplayin.com>
 <1409282570-27299-5-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409282570-27299-5-git-send-email-pramod.gurav@smartplayin.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 28 Aug 20:22 PDT 2014, Pramod Gurav wrote:

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
>  drivers/pinctrl/qcom/pinctrl-apq8064.c |    7 +++++-
>  drivers/pinctrl/qcom/pinctrl-msm.c     |   38 ++++++++++++++++++++++++++++++++
>  2 files changed, 44 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pinctrl/qcom/pinctrl-apq8064.c b/drivers/pinctrl/qcom/pinctrl-apq8064.c
> index feb6f15..ef1263c 100644
> --- a/drivers/pinctrl/qcom/pinctrl-apq8064.c
> +++ b/drivers/pinctrl/qcom/pinctrl-apq8064.c
> @@ -324,6 +324,7 @@ enum apq8064_functions {
>  	APQ_MUX_tsif1,
>  	APQ_MUX_tsif2,
>  	APQ_MUX_usb2_hsic,
> +	APQ_MUX_ps_hold,
>  	APQ_MUX_NA,
>  };
>  
> @@ -351,6 +352,9 @@ static const char * const gpio_groups[] = {
>  	"gpio78", "gpio79", "gpio80", "gpio81", "gpio82", "gpio83", "gpio84",
>  	"gpio85", "gpio86", "gpio87", "gpio88", "gpio89"
>  };
> +static const char * const ps_hold_groups[] = {
> +	"gpio78"
> +};
>  static const char * const gsbi1_groups[] = {
>  	"gpio18", "gpio19", "gpio20", "gpio21"
>  };
> @@ -477,6 +481,7 @@ static const struct msm_function apq8064_functions[] = {
>  	FUNCTION(tsif1),
>  	FUNCTION(tsif2),
>  	FUNCTION(usb2_hsic),
> +	FUNCTION(ps_hold),
>  };
>  
>  static const struct msm_pingroup apq8064_groups[] = {
> @@ -558,7 +563,7 @@ static const struct msm_pingroup apq8064_groups[] = {
>  	PINGROUP(75, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
>  	PINGROUP(76, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
>  	PINGROUP(77, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> -	PINGROUP(78, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> +	PINGROUP(78, ps_hold, NA, NA, NA, NA, NA, NA, NA, NA, NA),
>  	PINGROUP(79, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
>  	PINGROUP(80, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
>  	PINGROUP(81, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA),
> diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
> index 2738108..be43e7a 100644
> --- a/drivers/pinctrl/qcom/pinctrl-msm.c
> +++ b/drivers/pinctrl/qcom/pinctrl-msm.c
> @@ -12,6 +12,7 @@
>   * GNU General Public License for more details.
>   */
>  
> +#include <linux/delay.h>
>  #include <linux/err.h>
>  #include <linux/io.h>
>  #include <linux/module.h>
> @@ -27,12 +28,17 @@
>  #include <linux/interrupt.h>
>  #include <linux/spinlock.h>
>  
> +#include <asm/system_misc.h>
> +
>  #include "../core.h"
>  #include "../pinconf.h"
>  #include "pinctrl-msm.h"
>  #include "../pinctrl-utils.h"
>  
>  #define MAX_NR_GPIO 300
> +#define PS_HOLD_OFFSET 0x820
> +
> +static void __iomem *msm_ps_hold;
>  
>  /**
>   * struct msm_pinctrl - state for a pinctrl-msm device
> @@ -848,10 +854,31 @@ static int msm_gpio_init(struct msm_pinctrl *pctrl)
>  	return 0;
>  }
>  
> +static void qcom_reset(enum reboot_mode reboot_mode, const char *cmd)

This doesn't follow the naming used in this.

> +{
> +	writel(0, msm_ps_hold);
> +	mdelay(10000);

Why 10 seconds? What happens after that?

> +}
> +
> +const struct msm_function
> +*find_pshold_function(const struct msm_function *functions,
> +					unsigned nfunctions, const char *name)

This should be static. But that would cause a compile warning on non-ARM
platforms, see below.

> +{
> +	int i = 0;
> +	const struct msm_function *func;
> +
> +	for (func = functions; i <= nfunctions; func++, i++)

Why do you have 'func' and why do you iterate over that and i?

for (i = 0; i < nfunctions; i++)
	if (strcmp(functions[i]->name, name) == 0)
		return true; (or &functions[i] if you really need it)

But as you only uses this once I would prefer if you just merge in the setting
of msm_ps_hold and arm_pm_restart here as well, see below.

> +		if (!strcmp(func->name, name))
> +			return func;
> +
> +	return NULL;
> +}
> +
>  int msm_pinctrl_probe(struct platform_device *pdev,
>  		      const struct msm_pinctrl_soc_data *soc_data)
>  {
>  	struct msm_pinctrl *pctrl;
> +	const struct msm_function *func;
>  	struct resource *res;
>  	int ret;
>  
> @@ -871,6 +898,17 @@ int msm_pinctrl_probe(struct platform_device *pdev,
>  	if (IS_ERR(pctrl->regs))
>  		return PTR_ERR(pctrl->regs);
>  
> +#ifdef CONFIG_ARM
> +	func = find_pshold_function(soc_data->functions,
> +					soc_data->nfunctions, "ps_hold");
> +	if (func) {
> +		dev_dbg(&pdev->dev, "Found Function %s\n", func->name);

Guess what, it will print "ps_hold" here. I would prefer if you just skip this
line, as this will always be true on 8960 and 8064.

> +		msm_ps_hold = pctrl->regs + PS_HOLD_OFFSET;
> +		arm_pm_restart = qcom_reset;
> +	}
> +#else
> +#error "not supported on this arch"

There is no reason for you to break compilation of this driver on non-ARM
platforms. This #else/#error should be removed.

I would prefer if you did not #ifdef at all within the function, but rather
merge this piece of logic with the search above into a static function that's
surrounded by a check for CONFIG_ARM - providing a no-op for non-arm boards.

I.e

#ifdef CONFIG_ARM
static void qcom_reset(enum reboot_mode reboot_mode, const char *cmd)
{
	...
}

static void msm_pinctrl_setup_pm_reset(pctrl)
{
	...
}
#else
static void msm_pinctrl_setup_pm_reset(pctrl) {}
#endif

> +#endif

Regards,
Bjorn
