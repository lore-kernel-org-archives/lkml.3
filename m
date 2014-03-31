Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbaCaDdA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 23:33:00 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51436 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbaCaDc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 23:32:59 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5338E1E8.4030700@roeck-us.net>
Date: Sun, 30 Mar 2014 20:32:56 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Xiubo Li <Li.Xiubo@freescale.com>, wim@iguana.be, w.sang@pengutronix.de,
        linux-watchdog@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] watchdog: imx2_wdt: Add big-endian support
References: <1395800500-22655-1-git-send-email-Li.Xiubo@freescale.com> <1395800500-22655-3-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1395800500-22655-3-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2014 07:21 PM, Xiubo Li wrote:
> For the platforms that this IP driver now supports:
> SoC        CPU        Watchdog     Need 'big-endian'?
> ------------------------------------------------------
> Vybird     little     little       No
> LS1        little     big          Yes
> LS2        little     little       No
> IMX+       little     little       No
>
> So for the LS1 SoCs, we need to do the big endianness converting.
>
> And this will also support the following case, for example:
> SoC        CPU        Watchdog     Need 'big-endian'?
> ------------------------------------------------------
> PowerPC    big        big          Yes
>
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Cc: Guenter Roeck <linux@roeck-us.net>

Is this patch intended to solve the problem generically ?

http://www.spinics.net/lists/kernel/msg1714375.html

Guenter

> ---
>   drivers/watchdog/imx2_wdt.c | 40 +++++++++++++++++++++++++++++++---------
>   1 file changed, 31 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
> index 1795922..32f8874 100644
> --- a/drivers/watchdog/imx2_wdt.c
> +++ b/drivers/watchdog/imx2_wdt.c
> @@ -30,6 +30,7 @@
>   #include <linux/miscdevice.h>
>   #include <linux/module.h>
>   #include <linux/moduleparam.h>
> +#include <linux/of.h>
>   #include <linux/platform_device.h>
>   #include <linux/timer.h>
>   #include <linux/uaccess.h>
> @@ -64,9 +65,26 @@ static struct {
>   	void __iomem *base;
>   	unsigned timeout;
>   	unsigned long status;
> +	bool big_endian;
>   	struct timer_list timer;	/* Pings the watchdog when closed */
>   } imx2_wdt;
>
> +static inline u16 imx2_wdt_readw(void __iomem *addr)
> +{
> +	if (imx2_wdt.big_endian)
> +		return ioread16be(addr);
> +	else
> +		return ioread16(addr);
> +}
> +
> +static inline void imx2_wdt_writew(u16 val, void __iomem *addr)
> +{
> +	if (imx2_wdt.big_endian)
> +		iowrite16be(val, addr);
> +	else
> +		iowrite16(val, addr);
> +}
> +
>   static struct miscdevice imx2_wdt_miscdev;
>
>   static bool nowayout = WATCHDOG_NOWAYOUT;
> @@ -87,7 +105,7 @@ static const struct watchdog_info imx2_wdt_info = {
>
>   static inline void imx2_wdt_setup(void)
>   {
> -	u16 val = __raw_readw(imx2_wdt.base + IMX2_WDT_WCR);
> +	u16 val = imx2_wdt_readw(imx2_wdt.base + IMX2_WDT_WCR);
>
>   	/* Suspend timer in low power mode, write once-only */
>   	val |= IMX2_WDT_WCR_WDZST;
> @@ -100,17 +118,17 @@ static inline void imx2_wdt_setup(void)
>   	/* Set the watchdog's Time-Out value */
>   	val |= WDOG_SEC_TO_COUNT(imx2_wdt.timeout);
>
> -	__raw_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
> +	imx2_wdt_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
>
>   	/* enable the watchdog */
>   	val |= IMX2_WDT_WCR_WDE;
> -	__raw_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
> +	imx2_wdt_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
>   }
>
>   static inline void imx2_wdt_ping(void)
>   {
> -	__raw_writew(IMX2_WDT_SEQ1, imx2_wdt.base + IMX2_WDT_WSR);
> -	__raw_writew(IMX2_WDT_SEQ2, imx2_wdt.base + IMX2_WDT_WSR);
> +	imx2_wdt_writew(IMX2_WDT_SEQ1, imx2_wdt.base + IMX2_WDT_WSR);
> +	imx2_wdt_writew(IMX2_WDT_SEQ2, imx2_wdt.base + IMX2_WDT_WSR);
>   }
>
>   static void imx2_wdt_timer_ping(unsigned long arg)
> @@ -143,12 +161,12 @@ static void imx2_wdt_stop(void)
>
>   static void imx2_wdt_set_timeout(int new_timeout)
>   {
> -	u16 val = __raw_readw(imx2_wdt.base + IMX2_WDT_WCR);
> +	u16 val = imx2_wdt_readw(imx2_wdt.base + IMX2_WDT_WCR);
>
>   	/* set the new timeout value in the WSR */
>   	val &= ~IMX2_WDT_WCR_WT;
>   	val |= WDOG_SEC_TO_COUNT(new_timeout);
> -	__raw_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
> +	imx2_wdt_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
>   }
>
>   static int imx2_wdt_open(struct inode *inode, struct file *file)
> @@ -192,7 +210,7 @@ static long imx2_wdt_ioctl(struct file *file, unsigned int cmd,
>   		return put_user(0, p);
>
>   	case WDIOC_GETBOOTSTATUS:
> -		val = __raw_readw(imx2_wdt.base + IMX2_WDT_WRSR);
> +		val = imx2_wdt_readw(imx2_wdt.base + IMX2_WDT_WRSR);
>   		new_value = val & IMX2_WDT_WRSR_TOUT ? WDIOF_CARDRESET : 0;
>   		return put_user(new_value, p);
>
> @@ -257,8 +275,12 @@ static struct miscdevice imx2_wdt_miscdev = {
>
>   static int __init imx2_wdt_probe(struct platform_device *pdev)
>   {
> -	int ret;
> +	struct device_node *np = pdev->dev.of_node;
>   	struct resource *res;
> +	int ret;
> +
> +	if (np)
> +		imx2_wdt.big_endian = of_property_read_bool(np, "big-endian");
>
>   	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>   	imx2_wdt.base = devm_ioremap_resource(&pdev->dev, res);
>

