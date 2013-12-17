Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab3LQVY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 16:24:29 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38230 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3LQVY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 16:24:27 -0500
MIME-Version: 1.0
In-Reply-To: <1385160964-18578-2-git-send-email-markus.mayer@linaro.org>
References: <1385160964-18578-1-git-send-email-markus.mayer@linaro.org>
	<1385160964-18578-2-git-send-email-markus.mayer@linaro.org>
Date: Tue, 17 Dec 2013 13:24:25 -0800
Message-ID: <CAPdLdq=uiwjfEiiHoKgqL9Q79qaJROfaE=Bi6Vm9m_2RqoZd=w@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] watchdog: bcm281xx: Watchdog Driver
From: Markus Mayer <markus.mayer@linaro.org>
To: Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        Christian Daudt <bcm@fixthebug.org>
Cc: Linaro Patches <patches@linaro.org>, Matt Porter <matt.porter@linaro.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Linux Watchdog List <linux-watchdog@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Markus Mayer <markus.mayer@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wim,

Would you be able to pull v5 of this patch series into
linux-watchdog-next? There haven't been any negative comments for
several weeks.

Thanks,
-Markus

On 22 November 2013 14:56, Markus Mayer <markus.mayer@linaro.org> wrote:
> This commit adds support for the watchdog timer used on the BCM281xx
> family of SoCs.
>
> Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/watchdog/Kconfig        |   22 +++
>  drivers/watchdog/Makefile       |    1 +
>  drivers/watchdog/bcm_kona_wdt.c |  365 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 388 insertions(+)
>  create mode 100644 drivers/watchdog/bcm_kona_wdt.c
>
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 5be6e91..24bc93a 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -1139,6 +1139,28 @@ config BCM2835_WDT
>           To compile this driver as a loadable module, choose M here.
>           The module will be called bcm2835_wdt.
>
> +config BCM_KONA_WDT
> +       tristate "BCM Kona Watchdog"
> +       depends on ARCH_BCM
> +       select WATCHDOG_CORE
> +       help
> +         Support for the watchdog timer on the following Broadcom BCM281xx
> +         family, which includes BCM11130, BCM11140, BCM11351, BCM28145 and
> +         BCM28155 variants.
> +
> +         Say 'Y' or 'M' here to enable the driver. The module will be called
> +         bcm_kona_wdt.
> +
> +config BCM_KONA_WDT_DEBUG
> +       bool "DEBUGFS support for BCM Kona Watchdog"
> +       depends on BCM_KONA_WDT
> +       help
> +         If enabled, adds /sys/kernel/debug/bcm-kona-wdt/info which provides
> +         access to the driver's internal data structures as well as watchdog
> +         timer hardware registres.
> +
> +         If in doubt, say 'N'.
> +
>  config LANTIQ_WDT
>         tristate "Lantiq SoC watchdog"
>         depends on LANTIQ
> diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> index 91bd95a..af22516 100644
> --- a/drivers/watchdog/Makefile
> +++ b/drivers/watchdog/Makefile
> @@ -57,6 +57,7 @@ obj-$(CONFIG_RETU_WATCHDOG) += retu_wdt.o
>  obj-$(CONFIG_BCM2835_WDT) += bcm2835_wdt.o
>  obj-$(CONFIG_MOXART_WDT) += moxart_wdt.o
>  obj-$(CONFIG_SIRFSOC_WATCHDOG) += sirfsoc_wdt.o
> +obj-$(CONFIG_BCM_KONA_WDT) += bcm_kona_wdt.o
>
>  # AVR32 Architecture
>  obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
> diff --git a/drivers/watchdog/bcm_kona_wdt.c b/drivers/watchdog/bcm_kona_wdt.c
> new file mode 100644
> index 0000000..9fe174b
> --- /dev/null
> +++ b/drivers/watchdog/bcm_kona_wdt.c
> @@ -0,0 +1,365 @@
> +/*
> + * Copyright (C) 2013 Broadcom Corporation
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
> + * kind, whether express or implied; without even the implied warranty
> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/debugfs.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/of_address.h>
> +#include <linux/platform_device.h>
> +#include <linux/watchdog.h>
> +
> +#define SECWDOG_CTRL_REG               0x00000000
> +#define SECWDOG_COUNT_REG              0x00000004
> +
> +#define SECWDOG_RESERVED_MASK          0x1dffffff
> +#define SECWDOG_WD_LOAD_FLAG           0x10000000
> +#define SECWDOG_EN_MASK                        0x08000000
> +#define SECWDOG_SRSTEN_MASK            0x04000000
> +#define SECWDOG_RES_MASK               0x00f00000
> +#define SECWDOG_COUNT_MASK             0x000fffff
> +
> +#define SECWDOG_MAX_COUNT              SECWDOG_COUNT_MASK
> +#define SECWDOG_CLKS_SHIFT             20
> +#define SECWDOG_MAX_RES                        15
> +#define SECWDOG_DEFAULT_RESOLUTION     4
> +#define SECWDOG_MAX_TRY                        1000
> +
> +#define SECS_TO_TICKS(x, w)            ((x) << (w)->resolution)
> +#define TICKS_TO_SECS(x, w)            ((x) >> (w)->resolution)
> +
> +#define BCM_KONA_WDT_NAME              "bcm_kona_wdt"
> +
> +struct bcm_kona_wdt {
> +       void __iomem *base;
> +       /*
> +        * One watchdog tick is 1/(2^resolution) seconds. Resolution can take
> +        * the values 0-15, meaning one tick can be 1s to 30.52us. Our default
> +        * resolution of 4 means one tick is 62.5ms.
> +        *
> +        * The watchdog counter is 20 bits. Depending on resolution, the maximum
> +        * counter value of 0xfffff expires after about 12 days (resolution 0)
> +        * down to only 32s (resolution 15). The default resolution of 4 gives
> +        * us a maximum of about 18 hours and 12 minutes before the watchdog
> +        * times out.
> +        */
> +       int resolution;
> +       spinlock_t lock;
> +#ifdef CONFIG_BCM_KONA_WDT_DEBUG
> +       struct dentry *debugfs;
> +#endif
> +};
> +
> +#ifdef CONFIG_BCM_KONA_WDT_DEBUG
> +static unsigned long busy_count;
> +#endif
> +
> +static int secure_register_read(void __iomem *addr)
> +{
> +       uint32_t val;
> +       unsigned count = 0;
> +
> +       /*
> +        * If the WD_LOAD_FLAG is set, the watchdog counter field is being
> +        * updated in hardware. Once the WD timer is updated in hardware, it
> +        * gets cleared.
> +        */
> +       do {
> +               if (unlikely(count > 1))
> +                       udelay(5);
> +               val = readl_relaxed(addr);
> +               count++;
> +       } while ((val & SECWDOG_WD_LOAD_FLAG) && count < SECWDOG_MAX_TRY);
> +
> +#ifdef CONFIG_BCM_KONA_WDT_DEBUG
> +       /* Remember the maximum number iterations due to WD_LOAD_FLAG */
> +       if (count > busy_count)
> +               busy_count = count;
> +#endif
> +
> +       /* This is the only place we return a negative value. */
> +       if (val & SECWDOG_WD_LOAD_FLAG)
> +               return -ETIMEDOUT;
> +
> +       /* We always mask out reserved bits. */
> +       val &= SECWDOG_RESERVED_MASK;
> +
> +       return val;
> +}
> +
> +#ifdef CONFIG_BCM_KONA_WDT_DEBUG
> +
> +static int bcm_kona_wdt_dbg_show(struct seq_file *s, void *data)
> +{
> +       int ctl_val, cur_val, ret;
> +       unsigned long flags;
> +       struct bcm_kona_wdt *wdt = s->private;
> +
> +       if (!wdt)
> +               return seq_puts(s, "No device pointer\n");
> +
> +       spin_lock_irqsave(&wdt->lock, flags);
> +       ctl_val = secure_register_read(wdt->base + SECWDOG_CTRL_REG);
> +       cur_val = secure_register_read(wdt->base + SECWDOG_COUNT_REG);
> +       spin_unlock_irqrestore(&wdt->lock, flags);
> +
> +       if (ctl_val < 0 || cur_val < 0) {
> +               ret = seq_puts(s, "Error accessing hardware\n");
> +       } else {
> +               int ctl, cur, ctl_sec, cur_sec, res;
> +
> +               ctl = ctl_val & SECWDOG_COUNT_MASK;
> +               res = (ctl_val & SECWDOG_RES_MASK) >> SECWDOG_CLKS_SHIFT;
> +               cur = cur_val & SECWDOG_COUNT_MASK;
> +               ctl_sec = TICKS_TO_SECS(ctl, wdt);
> +               cur_sec = TICKS_TO_SECS(cur, wdt);
> +               ret = seq_printf(s, "Resolution: %d / %d\n"
> +                               "Control: %d s / %d (%#x) ticks\n"
> +                               "Current: %d s / %d (%#x) ticks\n"
> +                               "Busy count: %lu\n", res,
> +                               wdt->resolution, ctl_sec, ctl, ctl, cur_sec,
> +                               cur, cur, busy_count);
> +       }
> +
> +       return ret;
> +}
> +
> +static int bcm_kona_dbg_open(struct inode *inode, struct file *file)
> +{
> +       return single_open(file, bcm_kona_wdt_dbg_show, inode->i_private);
> +}
> +
> +static const struct file_operations bcm_kona_dbg_operations = {
> +       .open           = bcm_kona_dbg_open,
> +       .read           = seq_read,
> +       .llseek         = seq_lseek,
> +       .release        = single_release,
> +};
> +
> +static struct dentry *bcm_kona_wdt_debugfs_init(struct bcm_kona_wdt *wdt,
> +       struct watchdog_device *wdd)
> +{
> +       struct dentry *dir;
> +
> +       dir = debugfs_create_dir(BCM_KONA_WDT_NAME, NULL);
> +       if (IS_ERR_OR_NULL(dir))
> +               return NULL;
> +
> +       if (debugfs_create_file("info", S_IFREG | S_IRUGO, dir, wdt,
> +                               &bcm_kona_dbg_operations))
> +               return dir;
> +
> +       /* Clean up */
> +       debugfs_remove_recursive(dir);
> +       return NULL;
> +}
> +
> +static void bcm_kona_debugfs_exit(struct dentry *dir)
> +{
> +       debugfs_remove_recursive(dir);
> +}
> +
> +#endif /* CONFIG_BCM_KONA_WDT_DEBUG */
> +
> +static int bcm_kona_wdt_ctrl_reg_modify(struct bcm_kona_wdt *wdt,
> +                                       unsigned mask, unsigned newval)
> +{
> +       int val;
> +       unsigned long flags;
> +       int ret = 0;
> +
> +       spin_lock_irqsave(&wdt->lock, flags);
> +
> +       val = secure_register_read(wdt->base + SECWDOG_CTRL_REG);
> +       if (val < 0) {
> +               ret = val;
> +       } else {
> +               val &= ~mask;
> +               val |= newval;
> +               writel_relaxed(val, wdt->base + SECWDOG_CTRL_REG);
> +       }
> +
> +       spin_unlock_irqrestore(&wdt->lock, flags);
> +
> +       return ret;
> +}
> +
> +static int bcm_kona_wdt_set_resolution_reg(struct bcm_kona_wdt *wdt)
> +{
> +       if (wdt->resolution > SECWDOG_MAX_RES)
> +               return -EINVAL;
> +
> +       return bcm_kona_wdt_ctrl_reg_modify(wdt, SECWDOG_RES_MASK,
> +                                       wdt->resolution << SECWDOG_CLKS_SHIFT);
> +}
> +
> +static int bcm_kona_wdt_set_timeout_reg(struct watchdog_device *wdog,
> +                                       unsigned watchdog_flags)
> +{
> +       struct bcm_kona_wdt *wdt = watchdog_get_drvdata(wdog);
> +
> +       return bcm_kona_wdt_ctrl_reg_modify(wdt, SECWDOG_COUNT_MASK,
> +                                       SECS_TO_TICKS(wdog->timeout, wdt) |
> +                                       watchdog_flags);
> +}
> +
> +static int bcm_kona_wdt_set_timeout(struct watchdog_device *wdog,
> +       unsigned int t)
> +{
> +       wdog->timeout = t;
> +       return 0;
> +}
> +
> +static unsigned int bcm_kona_wdt_get_timeleft(struct watchdog_device *wdog)
> +{
> +       struct bcm_kona_wdt *wdt = watchdog_get_drvdata(wdog);
> +       int val;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&wdt->lock, flags);
> +       val = secure_register_read(wdt->base + SECWDOG_COUNT_REG);
> +       spin_unlock_irqrestore(&wdt->lock, flags);
> +
> +       if (val < 0)
> +               return val;
> +
> +       return TICKS_TO_SECS(val & SECWDOG_COUNT_MASK, wdt);
> +}
> +
> +static int bcm_kona_wdt_start(struct watchdog_device *wdog)
> +{
> +       return bcm_kona_wdt_set_timeout_reg(wdog,
> +                                       SECWDOG_EN_MASK | SECWDOG_SRSTEN_MASK);
> +}
> +
> +static int bcm_kona_wdt_stop(struct watchdog_device *wdog)
> +{
> +       struct bcm_kona_wdt *wdt = watchdog_get_drvdata(wdog);
> +
> +       return bcm_kona_wdt_ctrl_reg_modify(wdt, SECWDOG_EN_MASK |
> +                                           SECWDOG_SRSTEN_MASK, 0);
> +}
> +
> +static struct watchdog_ops bcm_kona_wdt_ops = {
> +       .owner =        THIS_MODULE,
> +       .start =        bcm_kona_wdt_start,
> +       .stop =         bcm_kona_wdt_stop,
> +       .set_timeout =  bcm_kona_wdt_set_timeout,
> +       .get_timeleft = bcm_kona_wdt_get_timeleft,
> +};
> +
> +static struct watchdog_info bcm_kona_wdt_info = {
> +       .options =      WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE |
> +                       WDIOF_KEEPALIVEPING,
> +       .identity =     "Broadcom Kona Watchdog Timer",
> +};
> +
> +static struct watchdog_device bcm_kona_wdt_wdd = {
> +       .info =         &bcm_kona_wdt_info,
> +       .ops =          &bcm_kona_wdt_ops,
> +       .min_timeout =  1,
> +       .max_timeout =  SECWDOG_MAX_COUNT >> SECWDOG_DEFAULT_RESOLUTION,
> +       .timeout =      SECWDOG_MAX_COUNT >> SECWDOG_DEFAULT_RESOLUTION,
> +};
> +
> +static void bcm_kona_wdt_shutdown(struct platform_device *pdev)
> +{
> +       bcm_kona_wdt_stop(&bcm_kona_wdt_wdd);
> +}
> +
> +static int bcm_kona_wdt_probe(struct platform_device *pdev)
> +{
> +       struct device *dev = &pdev->dev;
> +       struct bcm_kona_wdt *wdt;
> +       struct resource *res;
> +       int ret;
> +
> +       wdt = devm_kzalloc(dev, sizeof(*wdt), GFP_KERNEL);
> +       if (!wdt)
> +               return -ENOMEM;
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       wdt->base = devm_ioremap_resource(dev, res);
> +       if (IS_ERR(wdt->base))
> +               return -ENODEV;
> +
> +       wdt->resolution = SECWDOG_DEFAULT_RESOLUTION;
> +       ret = bcm_kona_wdt_set_resolution_reg(wdt);
> +       if (ret) {
> +               dev_err(dev, "Failed to set resolution (error: %d)", ret);
> +               return ret;
> +       }
> +
> +       spin_lock_init(&wdt->lock);
> +       platform_set_drvdata(pdev, wdt);
> +       watchdog_set_drvdata(&bcm_kona_wdt_wdd, wdt);
> +
> +       ret = bcm_kona_wdt_set_timeout_reg(&bcm_kona_wdt_wdd, 0);
> +       if (ret) {
> +               dev_err(dev, "Failed set watchdog timeout");
> +               return ret;
> +       }
> +
> +       ret = watchdog_register_device(&bcm_kona_wdt_wdd);
> +       if (ret) {
> +               dev_err(dev, "Failed to register watchdog device");
> +               return ret;
> +       }
> +
> +#ifdef CONFIG_BCM_KONA_WDT_DEBUG
> +       wdt->debugfs = bcm_kona_wdt_debugfs_init(wdt, &bcm_kona_wdt_wdd);
> +#endif
> +       dev_dbg(dev, "Broadcom Kona Watchdog Timer");
> +
> +       return 0;
> +}
> +
> +static int bcm_kona_wdt_remove(struct platform_device *pdev)
> +{
> +#ifdef CONFIG_BCM_KONA_WDT_DEBUG
> +       struct bcm_kona_wdt *wdt = platform_get_drvdata(pdev);
> +
> +       if (wdt->debugfs)
> +               bcm_kona_debugfs_exit(wdt->debugfs);
> +#endif /* CONFIG_BCM_KONA_WDT_DEBUG */
> +       bcm_kona_wdt_shutdown(pdev);
> +       watchdog_unregister_device(&bcm_kona_wdt_wdd);
> +       dev_dbg(&pdev->dev, "Watchdog driver disabled");
> +
> +       return 0;
> +}
> +
> +static const struct of_device_id bcm_kona_wdt_of_match[] = {
> +       { .compatible = "brcm,kona-wdt", },
> +       {},
> +};
> +MODULE_DEVICE_TABLE(of, bcm_kona_wdt_of_match);
> +
> +static struct platform_driver bcm_kona_wdt_driver = {
> +       .driver = {
> +                       .name = BCM_KONA_WDT_NAME,
> +                       .owner = THIS_MODULE,
> +                       .of_match_table = bcm_kona_wdt_of_match,
> +                 },
> +       .probe = bcm_kona_wdt_probe,
> +       .remove = bcm_kona_wdt_remove,
> +       .shutdown = bcm_kona_wdt_shutdown,
> +};
> +
> +module_platform_driver(bcm_kona_wdt_driver);
> +
> +MODULE_ALIAS("platform:" BCM_KONA_WDT_NAME);
> +MODULE_AUTHOR("Markus Mayer <mmayer@broadcom.com>");
> +MODULE_DESCRIPTION("Broadcom Kona Watchdog Driver");
> +MODULE_LICENSE("GPL v2");
> --
> 1.7.9.5

-- 
Markus Mayer
Broadcom Landing Team
