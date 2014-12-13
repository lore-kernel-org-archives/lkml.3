Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaLMPoz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 10:44:55 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:55318 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbaLMPoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 10:44:54 -0500
Message-ID: <548C5ED9.4090203@roeck-us.net>
Date: Sat, 13 Dec 2014 07:44:25 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Matthias Brugger <matthias.bgg@gmail.com>, wim@iguana.be,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        grant.likely@linaro.org
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, heiko@sntech.de,
        yingjoe.chen@gmail.com, ibanezchen@gmail.com, greta.zhang@mediatek.com,
        eddie.huang@mediatek.com
Subject: Re: [PATCH v2 1/2] watchdog: Add driver for Mediatek watchdog
References: <1418395859-32209-1-git-send-email-matthias.bgg@gmail.com> <1418395859-32209-2-git-send-email-matthias.bgg@gmail.com>
In-Reply-To: <1418395859-32209-2-git-send-email-matthias.bgg@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated_sender: linux@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020203.548C5EF5.02D4,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 7
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

On 12/12/2014 06:50 AM, Matthias Brugger wrote:
> This patch adds a driver for the Mediatek SoC integrated
> watchdog. This driver supports watchdog and software reset
> for mt65xx and mt81xx SoCs.
>
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> ---
>   drivers/watchdog/Kconfig   |  10 ++
>   drivers/watchdog/Makefile  |   1 +
>   drivers/watchdog/mtk_wdt.c | 257 +++++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 268 insertions(+)
>   create mode 100644 drivers/watchdog/mtk_wdt.c
>
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index d0107d4..fcbca1b 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -505,6 +505,16 @@ config MESON_WATCHDOG
>   	  To compile this driver as a module, choose M here: the
>   	  module will be called meson_wdt.
>
> +config MEDIATEK_WATCHDOG
> +	tristate "Mediatek SoCs watchdog support"
> +	depends on ARCH_MEDIATEK
> +	select WATCHDOG_CORE
> +	help
> +	  Say Y here to include support for the watchdog timer
> +	  in Mediatek SoCs.
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called mtk_wdt.
> +
>   # AVR32 Architecture
>
>   config AT32AP700X_WDT
> diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> index c569ec8..0d4821f 100644
> --- a/drivers/watchdog/Makefile
> +++ b/drivers/watchdog/Makefile
> @@ -63,6 +63,7 @@ obj-$(CONFIG_QCOM_WDT) += qcom-wdt.o
>   obj-$(CONFIG_BCM_KONA_WDT) += bcm_kona_wdt.o
>   obj-$(CONFIG_TEGRA_WATCHDOG) += tegra_wdt.o
>   obj-$(CONFIG_MESON_WATCHDOG) += meson_wdt.o
> +obj-$(CONFIG_MEDIATEK_WATCHDOG) += mtk_wdt.o
>
>   # AVR32 Architecture
>   obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
> diff --git a/drivers/watchdog/mtk_wdt.c b/drivers/watchdog/mtk_wdt.c
> new file mode 100644
> index 0000000..5f75442
> --- /dev/null
> +++ b/drivers/watchdog/mtk_wdt.c
> @@ -0,0 +1,257 @@
> +/*
> + * Mediatek Watchdog Driver
> + *
> + * Copyright (C) 2014 Matthias Brugger
> + *
> + * Matthias Brugger <matthias.bgg@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * Based on mtk_wdt.c
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/of.h>
> +#include <linux/platform_device.h>
> +#include <linux/types.h>
> +#include <linux/watchdog.h>
> +#include <linux/notifier.h>
> +#include <linux/reboot.h>
> +#include <linux/delay.h>
> +
> +#define WDT_MAX_TIMEOUT		31
> +#define WDT_MIN_TIMEOUT		1
> +#define WDT_LENGTH_TIMEOUT(n)	((n) << 5)
> +
> +#define WDT_LENGTH		0x04
> +#define WDT_LENGTH_KEY		0x8
> +
> +#define WDT_RST			0x08
> +#define WDT_RST_RELOAD		0x1971
> +
> +#define WDT_MODE		0x00
> +#define WDT_MODE_EN		(1 << 0)
> +#define WDT_MODE_EXT_POL_LOW	(0 << 1)
> +#define WDT_MODE_EXT_POL_HIGH	(1 << 1)
> +#define WDT_MODE_EXRST_EN	(1 << 2)
> +#define WDT_MODE_IRQ_EN		(1 << 3)
> +#define WDT_MODE_AUTO_START	(1 << 4)
> +#define WDT_MODE_DUAL_EN	(1 << 6)
> +#define WDT_MODE_KEY		0x22000000
> +
> +#define WDT_SWRST		0x14
> +#define WDT_SWRST_KEY		0x1209
> +
> +#define DRV_NAME		"mtk-wdt"
> +#define DRV_VERSION		"1.0"
> +
> +static bool nowayout = WATCHDOG_NOWAYOUT;
> +static unsigned int timeout = WDT_MAX_TIMEOUT;
> +
> +struct mtk_wdt_dev {
> +	struct watchdog_device wdt_dev;
> +	void __iomem *wdt_base;
> +	struct notifier_block restart_handler;
> +};
> +
> +static int mtk_reset_handler(struct notifier_block *this, unsigned long mode,
> +				void *cmd)
> +{
> +	struct mtk_wdt_dev *mtk_wdt = container_of(this,
> +						       struct mtk_wdt_dev,
> +						       restart_handler);
> +	void __iomem *wdt_base = mtk_wdt->wdt_base;
> +	u32 reg;
> +
> +	/* Reset system */
> +	writel(WDT_SWRST_KEY, wdt_base + WDT_SWRST);
> +
> +	while (1) {
> +		mdelay(5);
> +		writel(WDT_SWRST_KEY, wdt_base + WDT_SWRST);
> +	}
> +	return NOTIFY_DONE;
> +
Unnecessary empty line. See checkpatch --strict.

> +}
> +
> +static int mtk_wdt_ping(struct watchdog_device *wdt_dev)
> +{
> +	struct mtk_wdt_dev *mtk_wdt = watchdog_get_drvdata(wdt_dev);
> +	void __iomem *wdt_base = mtk_wdt->wdt_base;
> +
> +	iowrite32(WDT_RST_RELOAD, wdt_base + WDT_RST);
> +
> +	return 0;
> +}
> +
> +static int mtk_wdt_set_timeout(struct watchdog_device *wdt_dev,
> +		unsigned int timeout)

Continuation line alignment is off. See checkpatch --strict.

> +{
> +	struct mtk_wdt_dev *mtk_wdt = watchdog_get_drvdata(wdt_dev);
> +	void __iomem *wdt_base = mtk_wdt->wdt_base;
> +	u32 reg;
> +
> +	mtk_wdt->wdt_dev.timeout = timeout;
> +
> +	/* One bit is the value of 512 ticks

Please use standard multi-line comment style.

> +	 * The clock has 32 KHz
> +	 */
> +	reg = WDT_LENGTH_TIMEOUT(timeout << 6) | WDT_LENGTH_KEY;
> +	iowrite32(reg, wdt_base + WDT_LENGTH);
> +
> +	mtk_wdt_ping(wdt_dev);
> +
> +	return 0;
> +}
> +
> +static int mtk_wdt_stop(struct watchdog_device *wdt_dev)
> +{
> +	struct mtk_wdt_dev *mtk_wdt = watchdog_get_drvdata(wdt_dev);
> +	void __iomem *wdt_base = mtk_wdt->wdt_base;
> +	u32 reg;
> +
> +	reg = readl(wdt_base + WDT_MODE);
> +	reg &= ~(WDT_MODE_EN);
> +	iowrite32(reg, wdt_base + WDT_MODE);
> +
> +	return 0;
> +}
> +
> +static int mtk_wdt_start(struct watchdog_device *wdt_dev)
> +{
> +	u32 reg;
> +	struct mtk_wdt_dev *mtk_wdt = watchdog_get_drvdata(wdt_dev);
> +	void __iomem *wdt_base = mtk_wdt->wdt_base;
> +	u32 ret;
> +
> +	ret = mtk_wdt_set_timeout(&mtk_wdt->wdt_dev,
> +			mtk_wdt->wdt_dev.timeout);
> +	if (ret < 0)
> +		return ret;
> +
> +	reg = ioread32(wdt_base + WDT_MODE);
> +	reg &= ~(WDT_MODE_IRQ_EN | WDT_MODE_DUAL_EN);
> +	reg |= (WDT_MODE_EN | WDT_MODE_KEY);
> +	iowrite32(reg, wdt_base + WDT_MODE);
> +
> +	return 0;
> +}
> +
> +static const struct watchdog_info mtk_wdt_info = {
> +	.identity	= DRV_NAME,
> +	.options	= WDIOF_SETTIMEOUT |
> +			  WDIOF_KEEPALIVEPING |
> +			  WDIOF_MAGICCLOSE,
> +};
> +
> +static const struct watchdog_ops mtk_wdt_ops = {
> +	.owner		= THIS_MODULE,
> +	.start		= mtk_wdt_start,
> +	.stop		= mtk_wdt_stop,
> +	.ping		= mtk_wdt_ping,
> +	.set_timeout	= mtk_wdt_set_timeout,
> +};
> +
> +static int mtk_wdt_probe(struct platform_device *pdev)
> +{
> +	struct mtk_wdt_dev *mtk_wdt;
> +	struct resource *res;
> +	int err;
> +
> +	mtk_wdt = devm_kzalloc(&pdev->dev, sizeof(*mtk_wdt), GFP_KERNEL);
> +	if (!mtk_wdt)
> +		return -EINVAL;

-ENOMEM

> +
> +	platform_set_drvdata(pdev, mtk_wdt);
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	mtk_wdt->wdt_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(mtk_wdt->wdt_base))
> +		return PTR_ERR(mtk_wdt->wdt_base);
> +
> +	mtk_wdt->wdt_dev.info = &mtk_wdt_info;
> +	mtk_wdt->wdt_dev.ops = &mtk_wdt_ops;
> +	mtk_wdt->wdt_dev.timeout = WDT_MAX_TIMEOUT;
> +	mtk_wdt->wdt_dev.max_timeout = WDT_MAX_TIMEOUT;
> +	mtk_wdt->wdt_dev.min_timeout = WDT_MIN_TIMEOUT;
> +	mtk_wdt->wdt_dev.parent = &pdev->dev;
> +
> +	watchdog_init_timeout(&mtk_wdt->wdt_dev, timeout, &pdev->dev);
> +	watchdog_set_nowayout(&mtk_wdt->wdt_dev, nowayout);
> +
> +	watchdog_set_drvdata(&mtk_wdt->wdt_dev, mtk_wdt);
> +
> +	mtk_wdt_stop(&mtk_wdt->wdt_dev);
> +
> +	err = watchdog_register_device(&mtk_wdt->wdt_dev);
> +	if (unlikely(err))
> +		return err;
> +
> +	mtk_wdt->restart_handler.notifier_call = mtk_reset_handler;
> +	mtk_wdt->restart_handler.priority = 128;
> +	err = register_restart_handler(&mtk_wdt->restart_handler);
> +	if (err)
> +		dev_err(&pdev->dev,

dev_warn

> +			"cannot register restart handler (err=%d)\n", err);
> +
> +	dev_info(&pdev->dev, "Watchdog enabled (timeout=%d sec, nowayout=%d)",
> +			mtk_wdt->wdt_dev.timeout, nowayout);
> +
> +	return 0;
> +}
> +
> +static int mtk_wdt_remove(struct platform_device *pdev)
> +{
> +	struct mtk_wdt_dev *mtk_wdt = platform_get_drvdata(pdev);
> +
> +	unregister_restart_handler(&mtk_wdt->restart_handler);
> +
> +	watchdog_unregister_device(&mtk_wdt->wdt_dev);
> +	watchdog_set_drvdata(&mtk_wdt->wdt_dev, NULL);

Unnecessary. mtk_wdt is about to be freed.

> +
> +	return 0;
> +}
> +
> +static const struct of_device_id mtk_wdt_dt_ids[] = {
> +	{ .compatible = "mediatek,mt6589-wdt" },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, mtk_wdt_dt_ids);
> +
> +static struct platform_driver mtk_wdt_driver = {
> +	.probe		= mtk_wdt_probe,
> +	.remove		= mtk_wdt_remove,
> +	.driver		= {
> +		.owner		= THIS_MODULE,
> +		.name		= DRV_NAME,
> +		.of_match_table	= mtk_wdt_dt_ids,
> +	},
> +};
> +
> +module_platform_driver(mtk_wdt_driver);
> +
> +module_param(timeout, uint, 0);
> +MODULE_PARM_DESC(timeout, "Watchdog heartbeat in seconds");
> +
> +module_param(nowayout, bool, 0);
> +MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
> +			__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Matthias Brugger <matthias.bgg@gmail.com>");
> +MODULE_DESCRIPTION("Mediatek WatchDog Timer Driver");
> +MODULE_VERSION(DRV_VERSION);
>

