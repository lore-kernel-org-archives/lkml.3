Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaJBSfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:35:04 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:58413 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbaJBSfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:35:01 -0400
Date: Thu, 2 Oct 2014 11:34:55 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Feng Kan <fkan@apm.com>
Cc: dbaryshkov@gmail.com, linux-kernel@vger.kernel.org, patches@apm.com,
        linux-pm@vger.kernel.org, ser@kernel.org
Subject: Re: [PATCH 1/1] power: reset: corrections for simple syscon reboot
 driver
Message-ID: <20141002183455.GA19250@roeck-us.net>
References: <1412274255-1315-1-git-send-email-fkan@apm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412274255-1315-1-git-send-email-fkan@apm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 11:24:15AM -0700, Feng Kan wrote:
> This patch is to fix some bugs in reboot driver. Which includes auto selection
> of the MFD_SYSCON for the driver, use of container to locate restart handler,
> correction of the count down failure timer and ordering of the header file.
> 
> Signed-off-by: Feng Kan <fkan@apm.com>
> ---
>  drivers/power/reset/Kconfig         |  3 ++-
>  drivers/power/reset/syscon-reboot.c | 25 ++++++++++---------------
>  2 files changed, 12 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
> index addb26a..3b451e1 100644
> --- a/drivers/power/reset/Kconfig
> +++ b/drivers/power/reset/Kconfig
> @@ -120,6 +120,7 @@ config POWER_RESET_KEYSTONE
>  
>  config POWER_RESET_SYSCON
>  	bool "Generic SYSCON regmap reset driver"
> -	depends on POWER_RESET && MFD_SYSCON && OF
> +	depends on POWER_RESET && OF
> +	select MFD_SYSCON
>  	help
>  	  Reboot support for generic SYSCON mapped register reset.
> diff --git a/drivers/power/reset/syscon-reboot.c b/drivers/power/reset/syscon-reboot.c
> index 948e0ee..90dfdbf 100644
> --- a/drivers/power/reset/syscon-reboot.c
> +++ b/drivers/power/reset/syscon-reboot.c
> @@ -14,14 +14,15 @@
>   * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>   * GNU General Public License for more details.
>   */
> +#include <linux/delay.h>
>  #include <linux/io.h>
> -#include <linux/of_device.h>
> -#include <linux/of_address.h>
> -#include <linux/platform_device.h>
>  #include <linux/notifier.h>
>  #include <linux/mfd/syscon.h>
> -#include <linux/regmap.h>
> +#include <linux/of_address.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
>  #include <linux/reboot.h>
> +#include <linux/regmap.h>
>  
>  struct syscon_reboot_context {
>  	struct regmap *map;
> @@ -30,21 +31,17 @@ struct syscon_reboot_context {
>  	struct notifier_block restart_handler;
>  };
>  
> -static struct syscon_reboot_context *syscon_reboot_ctx;
> -
>  static int syscon_restart_handle(struct notifier_block *this,
>  					unsigned long mode, void *cmd)
>  {
> -	struct syscon_reboot_context *ctx = syscon_reboot_ctx;
> -	unsigned long timeout;
> +	struct syscon_reboot_context *ctx =
> +			container_of(this, struct syscon_reboot_context,
> +					restart_handler);
>  
>  	/* Issue the reboot */
> -	if (ctx->map)
> -		regmap_write(ctx->map, ctx->offset, ctx->mask);
> +	regmap_write(ctx->map, ctx->offset, ctx->mask);
>  
> -	timeout = jiffies + HZ;
> -	while (time_before(jiffies, timeout))
> -		cpu_relax();
> +	mdelay(1000);
>  
>  	pr_emerg("Unable to restart system\n");
>  	return NOTIFY_DONE;
> @@ -76,8 +73,6 @@ static int syscon_reboot_probe(struct platform_device *pdev)
>  	if (err)
>  		dev_err(dev, "can't register restart notifier (err=%d)\n", err);
>  
> -	syscon_reboot_ctx = ctx;
> -
>  	return 0;

Since the driver doesn't really do anything if the restart notifier registration
call fails, you might as well return err here.

Nitpick, really, especially since the function in reality never returns an error.

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Thanks,
Guenter
