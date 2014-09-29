Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbaI2Nxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:53:48 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48448 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbaI2Nxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:53:47 -0400
Message-ID: <5429644A.80108@ti.com>
Date: Mon, 29 Sep 2014 16:53:14 +0300
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>, Sebastian Reichel <sre@kernel.org>
CC: <linux-pm@vger.kernel.org>, Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH 08/10] power/reset: keystone: Register with kernel restart
 handler
References: <1411779438-23127-1-git-send-email-linux@roeck-us.net> <1411779438-23127-9-git-send-email-linux@roeck-us.net>
In-Reply-To: <1411779438-23127-9-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2014 03:57 AM, Guenter Roeck wrote:
> Register with kernel restart handler instead of setting arm_pm_restart directly.
>
> Move notifier registration to the end of the probe function to avoid having to
> implement error handling.
>
> Cc: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>   drivers/power/reset/keystone-reset.c | 18 ++++++++++++++----
>   1 file changed, 14 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/power/reset/keystone-reset.c b/drivers/power/reset/keystone-reset.c
> index 408a18f..9d46586 100644
> --- a/drivers/power/reset/keystone-reset.c
> +++ b/drivers/power/reset/keystone-reset.c
> @@ -12,9 +12,9 @@
>   
>   #include <linux/io.h>
>   #include <linux/module.h>
> +#include <linux/notifier.h>
>   #include <linux/reboot.h>
>   #include <linux/regmap.h>
> -#include <asm/system_misc.h>
>   #include <linux/mfd/syscon.h>
>   #include <linux/of_platform.h>
>   
> @@ -52,7 +52,8 @@ static inline int rsctrl_enable_rspll_write(void)
>   				  RSCTRL_KEY_MASK, RSCTRL_KEY);
>   }
>   
> -static void rsctrl_restart(enum reboot_mode mode, const char *cmd)
> +static int rsctrl_restart_handler(struct notifier_block *this,
> +				  unsigned long mode, void *cmd)
>   {
>   	/* enable write access to RSTCTRL */
>   	rsctrl_enable_rspll_write();
> @@ -60,8 +61,15 @@ static void rsctrl_restart(enum reboot_mode mode, const char *cmd)
>   	/* reset the SOC */
>   	regmap_update_bits(pllctrl_regs, rspll_offset + RSCTRL_RG,
>   			   RSCTRL_RESET_MASK, 0);
> +
> +	return NOTIFY_DONE;
>   }
>   
> +static struct notifier_block rsctrl_restart_nb = {
> +	.notifier_call = rsctrl_restart_handler,
> +	.priority = 128,
> +};
> +
>   static struct of_device_id rsctrl_of_match[] = {
>   	{.compatible = "ti,keystone-reset", },
>   	{},
> @@ -114,8 +122,6 @@ static int rsctrl_probe(struct platform_device *pdev)
>   	if (ret)
>   		return ret;
>   
> -	arm_pm_restart = rsctrl_restart;
> -
>   	/* disable a reset isolation for all module clocks */
>   	ret = regmap_write(pllctrl_regs, rspll_offset + RSISO_RG, 0);
>   	if (ret)
> @@ -147,6 +153,10 @@ static int rsctrl_probe(struct platform_device *pdev)
>   			return ret;
>   	}
>   
> +	ret = register_restart_handler(&rsctrl_restart_nb);
> +	if (ret)
> +		dev_err(dev, "cannot register restart handler (err=%d)\n", ret);

What about return ret? Even the register_restart_handler() always 
returns 0 currently.

> +
>   	return 0;
>   }
>   

Santosh,
I've tested it. That's fine.


-- 
Regards,
Ivan Khoronzhuk

