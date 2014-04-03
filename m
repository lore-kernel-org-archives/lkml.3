Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbaDCQgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:36:13 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:39700 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbaDCQgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:36:09 -0400
Date: Thu, 3 Apr 2014 09:36:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: wim@iguana.be, shawn.guo@linaro.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv4 2/2] watchdog: imx2_wdt: convert to use regmap API.
Message-ID: <20140403163604.GA11832@roeck-us.net>
References: <1396487059-15298-1-git-send-email-Li.Xiubo@freescale.com>
 <1396487059-15298-3-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396487059-15298-3-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 09:04:19AM +0800, Xiubo Li wrote:
> This watchdog driver will be working on IMX2+, Vybrid, LS1, LS2+
> platforms, and will be in different endianness mode in those SoCs:
> 
> SoCs         CPU endian mode      WDT endian mode
> ------------------------------------------------
> IMX2+            LE                    LE
> Vybird           LE                    LE
> LS1              LE                    BE
> LS2              LE                    LE
> 
> Other possible SoCs:
> SoCs         CPU endian mode      WDT endian mode
> ------------------------------------------------
> Soc1             BE                    BE
> Soc2             BE                    LE
> 
> And also the watchdog's registers will be 32-bits for some versions,
> and though it is 16-bits in IMX2+, Vybird and LS+.
> 
> Using the regmap APIs, could be more easy to support different
> endianness and also more easy to support 32-bits version...
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> ---
>  drivers/watchdog/imx2_wdt.c | 50 +++++++++++++++++++++++++++++----------------
>  1 file changed, 32 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
> index 1795922..76fa724 100644
> --- a/drivers/watchdog/imx2_wdt.c
> +++ b/drivers/watchdog/imx2_wdt.c
> @@ -31,6 +31,7 @@
>  #include <linux/module.h>
>  #include <linux/moduleparam.h>
>  #include <linux/platform_device.h>
> +#include <linux/regmap.h>
>  #include <linux/timer.h>
>  #include <linux/uaccess.h>
>  #include <linux/watchdog.h>
> @@ -61,7 +62,7 @@
>  
>  static struct {
>  	struct clk *clk;
> -	void __iomem *base;
> +	struct regmap *regmap;
>  	unsigned timeout;
>  	unsigned long status;
>  	struct timer_list timer;	/* Pings the watchdog when closed */
> @@ -87,7 +88,9 @@ static const struct watchdog_info imx2_wdt_info = {
>  
>  static inline void imx2_wdt_setup(void)
>  {
> -	u16 val = __raw_readw(imx2_wdt.base + IMX2_WDT_WCR);
> +	u32 val;
> +
> +	regmap_read(imx2_wdt.regmap, IMX2_WDT_WCR, &val);
>  
>  	/* Suspend timer in low power mode, write once-only */
>  	val |= IMX2_WDT_WCR_WDZST;
> @@ -100,17 +103,17 @@ static inline void imx2_wdt_setup(void)
>  	/* Set the watchdog's Time-Out value */
>  	val |= WDOG_SEC_TO_COUNT(imx2_wdt.timeout);
>  
> -	__raw_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
> +	regmap_write(imx2_wdt.regmap, IMX2_WDT_WCR, val);
>  
>  	/* enable the watchdog */
>  	val |= IMX2_WDT_WCR_WDE;
> -	__raw_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
> +	regmap_write(imx2_wdt.regmap, IMX2_WDT_WCR, val);
>  }
>  
>  static inline void imx2_wdt_ping(void)
>  {
> -	__raw_writew(IMX2_WDT_SEQ1, imx2_wdt.base + IMX2_WDT_WSR);
> -	__raw_writew(IMX2_WDT_SEQ2, imx2_wdt.base + IMX2_WDT_WSR);
> +	regmap_write(imx2_wdt.regmap, IMX2_WDT_WSR, IMX2_WDT_SEQ1);
> +	regmap_write(imx2_wdt.regmap, IMX2_WDT_WSR, IMX2_WDT_SEQ2);
>  }
>  
>  static void imx2_wdt_timer_ping(unsigned long arg)
> @@ -143,12 +146,8 @@ static void imx2_wdt_stop(void)
>  
>  static void imx2_wdt_set_timeout(int new_timeout)
>  {
> -	u16 val = __raw_readw(imx2_wdt.base + IMX2_WDT_WCR);
> -
> -	/* set the new timeout value in the WSR */
> -	val &= ~IMX2_WDT_WCR_WT;
> -	val |= WDOG_SEC_TO_COUNT(new_timeout);
> -	__raw_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
> +	regmap_update_bits(imx2_wdt.regmap, IMX2_WDT_WCR, IMX2_WDT_WCR_WT,
> +			   WDOG_SEC_TO_COUNT(new_timeout));
>  }
>  
>  static int imx2_wdt_open(struct inode *inode, struct file *file)
> @@ -181,7 +180,7 @@ static long imx2_wdt_ioctl(struct file *file, unsigned int cmd,
>  	void __user *argp = (void __user *)arg;
>  	int __user *p = argp;
>  	int new_value;
> -	u16 val;
> +	u32 val;
>  
>  	switch (cmd) {
>  	case WDIOC_GETSUPPORT:
> @@ -192,7 +191,7 @@ static long imx2_wdt_ioctl(struct file *file, unsigned int cmd,
>  		return put_user(0, p);
>  
>  	case WDIOC_GETBOOTSTATUS:
> -		val = __raw_readw(imx2_wdt.base + IMX2_WDT_WRSR);
> +		regmap_read(imx2_wdt.regmap, IMX2_WDT_WRSR, &val);
>  		new_value = val & IMX2_WDT_WRSR_TOUT ? WDIOF_CARDRESET : 0;
>  		return put_user(new_value, p);
>  
> @@ -255,15 +254,30 @@ static struct miscdevice imx2_wdt_miscdev = {
>  	.fops = &imx2_wdt_fops,
>  };
>  
> +static struct regmap_config imx2_wdt_regmap_config = {
> +	.reg_bits = 16,
> +	.reg_stride = 2,
> +	.val_bits = 16,
> +	.max_register = 0x8,
> +};
> +
>  static int __init imx2_wdt_probe(struct platform_device *pdev)
>  {
> -	int ret;
>  	struct resource *res;
> +	void __iomem *base;
> +	int ret;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	imx2_wdt.base = devm_ioremap_resource(&pdev->dev, res);
> -	if (IS_ERR(imx2_wdt.base))
> -		return PTR_ERR(imx2_wdt.base);
> +	base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(base))
> +		return PTR_ERR(base);
> +
> +	imx2_wdt.regmap = devm_regmap_init_mmio_clk(&pdev->dev, NULL, base,
> +						    &imx2_wdt_regmap_config);

This patch causes the following buiild failure:

Building arm:imx_v4_v5_defconfig ... failed
--------------
Error log:
drivers/built-in.o: In function `imx2_wdt_probe':
clk-composite.c:(.init.text+0x82c4): undefined reference to
`devm_regmap_init_mmio_clk'
make: *** [vmlinux] Error 1
--------------

This is on top of

b33ce44 Merge branch 'for-3.15/drivers' of git://git.kernel.dk/linux-block

Does it have build dependencies on code which is (or was) not yet available
in mainline ?

Thanks,
Guenter
