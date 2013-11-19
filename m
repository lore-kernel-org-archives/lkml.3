Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751680Ab3KSFMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 00:12:50 -0500
Received: from mail.active-venture.com ([67.228.131.205]:54560 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab3KSFMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 00:12:48 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <528AF349.9070902@roeck-us.net>
Date: Mon, 18 Nov 2013 21:12:41 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Wim Van Sebroeck <wim@iguana.be>, Sekhar Nori <nsekhar@ti.com>,
        linux-watchdog@vger.kernel.org, devicetree@vger.kernel.org
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Strashko Grygorii <grygorii.strashko@ti.com>
Subject: Re: [PATCH 1/6] watchdog: davinci: change driver to use WDT core
References: <1384795139-19466-1-git-send-email-ivan.khoronzhuk@ti.com> <1384795139-19466-2-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1384795139-19466-2-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 09:18 AM, Ivan Khoronzhuk wrote:
> To reduce code duplicate and increase code readability use WDT core
> code to handle WDT interface.
>
> Remove io_lock as the WDT core uses mutex to lock each wdt device.
> Remove wdt_state as the WDT core track state with its own variable.
>
> The watchdog_init_timeout() can read timeout value from timeout-sec
> property if the passed value is out of bounds. The heartbeat is
> initialized in next way. If heartbeat is not set thought module
> parameter, try to read it's value from WDT node timeout-sec property.
> If node has no one, use default value.
>
> The heartbeat is hold in wdd->timeout by WDT core, so use it in
> order to set timeout period.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> ---
>   drivers/watchdog/Kconfig       |    2 +
>   drivers/watchdog/davinci_wdt.c |  152 ++++++++++------------------------------
>   2 files changed, 39 insertions(+), 115 deletions(-)
>
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index d1d53f3..d7db13d 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -271,6 +271,8 @@ config IOP_WATCHDOG
>   config DAVINCI_WATCHDOG
>   	tristate "DaVinci watchdog"
>   	depends on ARCH_DAVINCI
> +	select WATCHDOG_CORE
> +	select WATCHDOG_NOWAYOUT

Is this mandatory, ie is it correct that the watchdog can not be stopped once started ?

Assuming it is,

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

>   	help
>   	  Say Y here if to include support for the watchdog timer
>   	  in the DaVinci DM644x/DM646x processors.
> diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
> index bead774..cb9e8c5 100644
> --- a/drivers/watchdog/davinci_wdt.c
> +++ b/drivers/watchdog/davinci_wdt.c
> @@ -3,7 +3,7 @@
>    *
>    * Watchdog driver for DaVinci DM644x/DM646x processors
>    *
> - * Copyright (C) 2006 Texas Instruments.
> + * Copyright (C) 2006-2013 Texas Instruments.
>    *
>    * 2007 (c) MontaVista Software, Inc. This file is licensed under
>    * the terms of the GNU General Public License version 2. This program
> @@ -15,18 +15,12 @@
>   #include <linux/moduleparam.h>
>   #include <linux/types.h>
>   #include <linux/kernel.h>
> -#include <linux/fs.h>
> -#include <linux/miscdevice.h>
>   #include <linux/watchdog.h>
>   #include <linux/init.h>
> -#include <linux/bitops.h>
>   #include <linux/platform_device.h>
> -#include <linux/spinlock.h>
> -#include <linux/uaccess.h>
>   #include <linux/io.h>
>   #include <linux/device.h>
>   #include <linux/clk.h>
> -#include <linux/slab.h>
>   #include <linux/err.h>
>
>   #define MODULE_NAME "DAVINCI-WDT: "
> @@ -61,31 +55,12 @@
>   #define WDKEY_SEQ0		(0xa5c6 << 16)
>   #define WDKEY_SEQ1		(0xda7e << 16)
>
> -static int heartbeat = DEFAULT_HEARTBEAT;
> -
> -static DEFINE_SPINLOCK(io_lock);
> -static unsigned long wdt_status;
> -#define WDT_IN_USE        0
> -#define WDT_OK_TO_CLOSE   1
> -#define WDT_REGION_INITED 2
> -#define WDT_DEVICE_INITED 3
> -
> +static int heartbeat;
>   static void __iomem	*wdt_base;
>   struct clk		*wdt_clk;
> +static struct watchdog_device	wdt_wdd;
>
> -static void wdt_service(void)
> -{
> -	spin_lock(&io_lock);
> -
> -	/* put watchdog in service state */
> -	iowrite32(WDKEY_SEQ0, wdt_base + WDTCR);
> -	/* put watchdog in active state */
> -	iowrite32(WDKEY_SEQ1, wdt_base + WDTCR);
> -
> -	spin_unlock(&io_lock);
> -}
> -
> -static void wdt_enable(void)
> +static int davinci_wdt_start(struct watchdog_device *wdd)
>   {
>   	u32 tgcr;
>   	u32 timer_margin;
> @@ -93,8 +68,6 @@ static void wdt_enable(void)
>
>   	wdt_freq = clk_get_rate(wdt_clk);
>
> -	spin_lock(&io_lock);
> -
>   	/* disable, internal clock source */
>   	iowrite32(0, wdt_base + TCR);
>   	/* reset timer, set mode to 64-bit watchdog, and unreset */
> @@ -105,9 +78,9 @@ static void wdt_enable(void)
>   	iowrite32(0, wdt_base + TIM12);
>   	iowrite32(0, wdt_base + TIM34);
>   	/* set timeout period */
> -	timer_margin = (((u64)heartbeat * wdt_freq) & 0xffffffff);
> +	timer_margin = (((u64)wdd->timeout * wdt_freq) & 0xffffffff);
>   	iowrite32(timer_margin, wdt_base + PRD12);
> -	timer_margin = (((u64)heartbeat * wdt_freq) >> 32);
> +	timer_margin = (((u64)wdd->timeout * wdt_freq) >> 32);
>   	iowrite32(timer_margin, wdt_base + PRD34);
>   	/* enable run continuously */
>   	iowrite32(ENAMODE12_PERIODIC, wdt_base + TCR);
> @@ -119,84 +92,28 @@ static void wdt_enable(void)
>   	iowrite32(WDKEY_SEQ0 | WDEN, wdt_base + WDTCR);
>   	/* put watchdog in active state */
>   	iowrite32(WDKEY_SEQ1 | WDEN, wdt_base + WDTCR);
> -
> -	spin_unlock(&io_lock);
> -}
> -
> -static int davinci_wdt_open(struct inode *inode, struct file *file)
> -{
> -	if (test_and_set_bit(WDT_IN_USE, &wdt_status))
> -		return -EBUSY;
> -
> -	wdt_enable();
> -
> -	return nonseekable_open(inode, file);
> +	return 0;
>   }
>
> -static ssize_t
> -davinci_wdt_write(struct file *file, const char *data, size_t len,
> -		  loff_t *ppos)
> +static int davinci_wdt_ping(struct watchdog_device *wdd)
>   {
> -	if (len)
> -		wdt_service();
> -
> -	return len;
> +	/* put watchdog in service state */
> +	iowrite32(WDKEY_SEQ0, wdt_base + WDTCR);
> +	/* put watchdog in active state */
> +	iowrite32(WDKEY_SEQ1, wdt_base + WDTCR);
> +	return 0;
>   }
>
> -static const struct watchdog_info ident = {
> +static const struct watchdog_info davinci_wdt_info = {
>   	.options = WDIOF_KEEPALIVEPING,
>   	.identity = "DaVinci Watchdog",
>   };
>
> -static long davinci_wdt_ioctl(struct file *file,
> -					unsigned int cmd, unsigned long arg)
> -{
> -	int ret = -ENOTTY;
> -
> -	switch (cmd) {
> -	case WDIOC_GETSUPPORT:
> -		ret = copy_to_user((struct watchdog_info *)arg, &ident,
> -				   sizeof(ident)) ? -EFAULT : 0;
> -		break;
> -
> -	case WDIOC_GETSTATUS:
> -	case WDIOC_GETBOOTSTATUS:
> -		ret = put_user(0, (int *)arg);
> -		break;
> -
> -	case WDIOC_KEEPALIVE:
> -		wdt_service();
> -		ret = 0;
> -		break;
> -
> -	case WDIOC_GETTIMEOUT:
> -		ret = put_user(heartbeat, (int *)arg);
> -		break;
> -	}
> -	return ret;
> -}
> -
> -static int davinci_wdt_release(struct inode *inode, struct file *file)
> -{
> -	wdt_service();
> -	clear_bit(WDT_IN_USE, &wdt_status);
> -
> -	return 0;
> -}
> -
> -static const struct file_operations davinci_wdt_fops = {
> -	.owner = THIS_MODULE,
> -	.llseek = no_llseek,
> -	.write = davinci_wdt_write,
> -	.unlocked_ioctl = davinci_wdt_ioctl,
> -	.open = davinci_wdt_open,
> -	.release = davinci_wdt_release,
> -};
> -
> -static struct miscdevice davinci_wdt_miscdev = {
> -	.minor = WATCHDOG_MINOR,
> -	.name = "watchdog",
> -	.fops = &davinci_wdt_fops,
> +static const struct watchdog_ops davinci_wdt_ops = {
> +	.owner		= THIS_MODULE,
> +	.start		= davinci_wdt_start,
> +	.stop		= davinci_wdt_ping,
> +	.ping		= davinci_wdt_ping,
>   };
>
>   static int davinci_wdt_probe(struct platform_device *pdev)
> @@ -204,6 +121,7 @@ static int davinci_wdt_probe(struct platform_device *pdev)
>   	int ret = 0;
>   	struct device *dev = &pdev->dev;
>   	struct resource  *wdt_mem;
> +	struct watchdog_device *wdd;
>
>   	wdt_clk = devm_clk_get(dev, NULL);
>   	if (WARN_ON(IS_ERR(wdt_clk)))
> @@ -211,29 +129,34 @@ static int davinci_wdt_probe(struct platform_device *pdev)
>
>   	clk_prepare_enable(wdt_clk);
>
> -	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
> -		heartbeat = DEFAULT_HEARTBEAT;
> +	wdd			= &wdt_wdd;
> +	wdd->info		= &davinci_wdt_info;
> +	wdd->ops		= &davinci_wdt_ops;
> +	wdd->min_timeout 	= 1;
> +	wdd->max_timeout 	= MAX_HEARTBEAT;
> +	wdd->timeout		= DEFAULT_HEARTBEAT;
> +
> +	watchdog_init_timeout(wdd, heartbeat, dev);
> +
> +	dev_info(dev, "heartbeat %d sec\n", wdd->timeout);
>
> -	dev_info(dev, "heartbeat %d sec\n", heartbeat);
> +	watchdog_set_nowayout(wdd, WATCHDOG_NOWAYOUT);
>
>   	wdt_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>   	wdt_base = devm_ioremap_resource(dev, wdt_mem);
>   	if (IS_ERR(wdt_base))
>   		return PTR_ERR(wdt_base);
>
> -	ret = misc_register(&davinci_wdt_miscdev);
> -	if (ret < 0) {
> -		dev_err(dev, "cannot register misc device\n");
> -	} else {
> -		set_bit(WDT_DEVICE_INITED, &wdt_status);
> -	}
> +	ret = watchdog_register_device(wdd);
> +	if (ret < 0)
> +		dev_err(dev, "cannot register watchdog device\n");
>
>   	return ret;
>   }
>
>   static int davinci_wdt_remove(struct platform_device *pdev)
>   {
> -	misc_deregister(&davinci_wdt_miscdev);
> +	watchdog_unregister_device(&wdt_wdd);
>   	clk_disable_unprepare(wdt_clk);
>
>   	return 0;
> @@ -247,7 +170,7 @@ MODULE_DEVICE_TABLE(of, davinci_wdt_of_match);
>
>   static struct platform_driver platform_wdt_driver = {
>   	.driver = {
> -		.name = "watchdog",
> +		.name = "davinci-wdt",
>   		.owner	= THIS_MODULE,
>   		.of_match_table = davinci_wdt_of_match,
>   	},
> @@ -267,5 +190,4 @@ MODULE_PARM_DESC(heartbeat,
>   		 __MODULE_STRING(DEFAULT_HEARTBEAT));
>
>   MODULE_LICENSE("GPL");
> -MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
> -MODULE_ALIAS("platform:watchdog");
> +MODULE_ALIAS("platform:davinci-wdt");
>

