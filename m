Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719AbaIWScG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 14:32:06 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:52600 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbaIWScD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 14:32:03 -0400
Date: Tue, 23 Sep 2014 11:31:59 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/2] watchdog: dw_wdt: add restart handler support
Message-ID: <20140923183159.GB24930@roeck-us.net>
References: <1411458132-5410-1-git-send-email-jszhang@marvell.com>
 <1411458132-5410-3-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411458132-5410-3-git-send-email-jszhang@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 03:42:12PM +0800, Jisheng Zhang wrote:
> The kernel core now provides an API to trigger a system restart.
> Register with it to support restarting the system via. watchdog.
> 
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> ---
>  drivers/watchdog/dw_wdt.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
> index 449c885..9e577a6 100644
> --- a/drivers/watchdog/dw_wdt.c
> +++ b/drivers/watchdog/dw_wdt.c
> @@ -21,6 +21,7 @@
>  
>  #include <linux/bitops.h>
>  #include <linux/clk.h>
> +#include <linux/delay.h>
>  #include <linux/device.h>
>  #include <linux/err.h>
>  #include <linux/fs.h>
> @@ -29,9 +30,11 @@
>  #include <linux/miscdevice.h>
>  #include <linux/module.h>
>  #include <linux/moduleparam.h>
> +#include <linux/notifier.h>
>  #include <linux/of.h>
>  #include <linux/pm.h>
>  #include <linux/platform_device.h>
> +#include <linux/reboot.h>
>  #include <linux/spinlock.h>
>  #include <linux/timer.h>
>  #include <linux/uaccess.h>
> @@ -63,6 +66,7 @@ static struct {
>  	unsigned long		next_heartbeat;
>  	struct timer_list	timer;
>  	int			expect_close;
> +	struct notifier_block	restart_handler;
>  } dw_wdt;
>  
>  static inline int dw_wdt_is_enabled(void)
> @@ -121,6 +125,26 @@ static void dw_wdt_keepalive(void)
>  	       WDOG_COUNTER_RESTART_REG_OFFSET);
>  }
>  
> +static int dw_wdt_restart_handle(struct notifier_block *this,
> +				unsigned long mode, void *cmd)
> +{
> +	u32 val;
> +
> +	writel(0, dw_wdt.regs + WDOG_TIMEOUT_RANGE_REG_OFFSET);
> +	val = readl(dw_wdt.regs + WDOG_CONTROL_REG_OFFSET);
> +	if (val & WDOG_CONTROL_REG_WDT_EN_MASK)
> +		writel(WDOG_COUNTER_RESTART_KICK_VALUE, dw_wdt.regs +
> +			WDOG_COUNTER_RESTART_REG_OFFSET);
> +	else
> +		writel(WDOG_CONTROL_REG_WDT_EN_MASK,
> +		       dw_wdt.regs + WDOG_CONTROL_REG_OFFSET);
> +
> +	/* wait for reset to assert... */
> +	mdelay(500);
> +
> +	return NOTIFY_DONE;
> +}
> +
>  static void dw_wdt_ping(unsigned long data)
>  {
>  	if (time_before(jiffies, dw_wdt.next_heartbeat) ||
> @@ -316,6 +340,12 @@ static int dw_wdt_drv_probe(struct platform_device *pdev)
>  	if (ret)
>  		goto out_disable_clk;
>  
> +	dw_wdt.restart_handler.notifier_call = dw_wdt_restart_handle;
> +	dw_wdt.restart_handler.priority = 128;
> +	ret = register_restart_handler(&dw_wdt.restart_handler);
> +	if (ret)
> +		pr_warn("cannot register restart handler\n");

Please use dev_warn(&pdev->dev, ...).

Thanks,
Guenter

> +
>  	dw_wdt_set_next_heartbeat();
>  	setup_timer(&dw_wdt.timer, dw_wdt_ping, 0);
>  	mod_timer(&dw_wdt.timer, jiffies + WDT_TIMEOUT);
> @@ -330,6 +360,8 @@ out_disable_clk:
>  
>  static int dw_wdt_drv_remove(struct platform_device *pdev)
>  {
> +	unregister_restart_handler(&dw_wdt.restart_handler);
> +
>  	misc_deregister(&dw_wdt_miscdev);
>  
>  	clk_disable_unprepare(dw_wdt.clk);
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
