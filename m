Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab3KLWSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 17:18:11 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:40230 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626Ab3KLWSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 17:18:00 -0500
MIME-Version: 1.0
In-Reply-To: <20131111173434.GA25532@roeck-us.net>
References: <1383943488-6537-1-git-send-email-markus.mayer@linaro.org>
	<1383943488-6537-2-git-send-email-markus.mayer@linaro.org>
	<20131111173434.GA25532@roeck-us.net>
Date: Tue, 12 Nov 2013 14:17:58 -0800
Message-ID: <CAPdLdqn5bvxnURdcy0JATBWmyJsbL=EJ65repSVxchw7srWpfQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] watchdog: bcm281xx: Watchdog Driver
From: Markus Mayer <markus.mayer@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wim Van Sebroeck <wim@iguana.be>, Christian Daudt <bcm@fixthebug.org>,
        Linaro Patches <patches@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        Linux Watchdog List <linux-watchdog@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 November 2013 09:34, Guenter Roeck <linux@roeck-us.net> wrote:
> On Fri, Nov 08, 2013 at 12:44:47PM -0800, Markus Mayer wrote:
>> This commit adds support for the watchdog timer used on the BCM281xx
>> family of SoCs.
>>
>> Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
>> Reviewed-by: Matt Porter <matt.porter@linaro.org>
>
> Overall I am a bit concerned about the heavy use of -EAGAIN, which is a first
> for watchdog drivers. The condition seems to be around secure_register_read.
> If that is stuck for some reason, it may cause endless retries. Not sure if
> that is a good idea. -ETIMEDOUT might be a betetr idea.
>
>> ---
>>  drivers/watchdog/Kconfig        |   21 +++
>>  drivers/watchdog/Makefile       |    1 +
>>  drivers/watchdog/bcm_kona_wdt.c |  399 +++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 421 insertions(+)
>>  create mode 100644 drivers/watchdog/bcm_kona_wdt.c
>>
>> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
>> index d1d53f3..59013f6 100644
>> --- a/drivers/watchdog/Kconfig
>> +++ b/drivers/watchdog/Kconfig
>> @@ -1121,6 +1121,27 @@ config BCM2835_WDT
>>         To compile this driver as a loadable module, choose M here.
>>         The module will be called bcm2835_wdt.
>>
>> +config BCM_KONA_WDT
>> +     tristate "BCM Kona Watchdog"
>> +     depends on ARCH_BCM
>> +     select WATCHDOG_CORE
>> +     help
>> +       Support for the watchdog timer on the following Broadcom BCM281xx
>> +       family, which includes BCM11130, BCM11140, BCM11351, BCM28145 and
>> +       BCM28155 variants.
>> +
>> +       Say 'Y' or 'M' here to enable the driver.
>> +
> It is customary to state the module name if drivers are built as module.
>
>> +config BCM_KONA_WDT_DEBUG
>> +     bool "DEBUGFS support for BCM Kona Watchdog"
>> +     depends on BCM_KONA_WDT
>> +     help
>> +       If enabled, adds /sys/kernel/debug/bcm-kona-wdt/info which provides
>> +       access to the driver's internal data structures as well as watchdog
>> +       timer hardware registres.
>> +
>> +       If in doubt, say 'N'.
>> +
>>  config LANTIQ_WDT
>>       tristate "Lantiq SoC watchdog"
>>       depends on LANTIQ
>> diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
>> index 6c5bb27..7c860ca 100644
>> --- a/drivers/watchdog/Makefile
>> +++ b/drivers/watchdog/Makefile
>> @@ -55,6 +55,7 @@ obj-$(CONFIG_IMX2_WDT) += imx2_wdt.o
>>  obj-$(CONFIG_UX500_WATCHDOG) += ux500_wdt.o
>>  obj-$(CONFIG_RETU_WATCHDOG) += retu_wdt.o
>>  obj-$(CONFIG_BCM2835_WDT) += bcm2835_wdt.o
>> +obj-$(CONFIG_BCM_KONA_WDT) += bcm_kona_wdt.o
>>
>>  # AVR32 Architecture
>>  obj-$(CONFIG_AT32AP700X_WDT) += at32ap700x_wdt.o
>> diff --git a/drivers/watchdog/bcm_kona_wdt.c b/drivers/watchdog/bcm_kona_wdt.c
>> new file mode 100644
>> index 0000000..c47ac77
>> --- /dev/null
>> +++ b/drivers/watchdog/bcm_kona_wdt.c
>> @@ -0,0 +1,399 @@
>> +/*
>> + * Copyright (C) 2013 Broadcom Corporation
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License as
>> + * published by the Free Software Foundation version 2.
>> + *
>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
>> + * kind, whether express or implied; without even the implied warranty
>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/debugfs.h>
>> +#include <linux/err.h>
>> +#include <linux/io.h>
>> +#include <linux/miscdevice.h>
>> +#include <linux/module.h>
>> +#include <linux/of_address.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/watchdog.h>
>> +
>> +#define SECWDOG_CTRL_REG             0x00000000
>> +#define SECWDOG_COUNT_REG            0x00000004
>> +
>> +#define SECWDOG_RESERVED_MASK                0x1dffffff
>> +#define SECWDOG_WD_LOAD_FLAG_MASK    0x10000000
>> +#define SECWDOG_EN_MASK                      0x08000000
>> +#define SECWDOG_SRSTEN_MASK          0x04000000
>> +#define SECWDOG_RES_MASK             0x00f00000
>> +#define SECWDOG_COUNT_MASK           0x000fffff
>> +
>> +#define SECWDOG_MAX_COUNT            SECWDOG_COUNT_MASK
>> +#define SECWDOG_CLKS_SHIFT           20
>> +#define SECWDOG_MAX_RES                      15
>> +#define SECWDOG_DEFAULT_RESOLUTION   4
>> +#define SECWDOG_MAX_TRY                      10000
>> +
>> +#define SECS_TO_TICKS(x, w)          ((x) << (w)->resolution)
>> +#define TICKS_TO_SECS(x, w)          ((x) >> (w)->resolution)
>> +
>> +#define BCM_KONA_WDT_NAME            "bcm-kona-wdt"
>> +
>> +struct bcm_kona_wdt {
>> +     void __iomem *base;
>> +     int resolution;
>> +     spinlock_t lock;
>> +#ifdef CONFIG_BCM_KONA_WDT_DEBUG
>> +     struct dentry *debugfs;
>> +#endif
>> +};
>> +
>> +static uint32_t secure_register_read(void __iomem *addr, int *timeout)
>> +{
> From the context, it appears that timeout is really a boolean and does not
> reflect a count (as one might think). I would suggest to make it a boolean.
>
>> +     uint32_t val;
>> +     unsigned count = 0;
>> +
>> +     do {
>> +             val = readl_relaxed(addr);
>> +             count++;
>> +     } while ((val & SECWDOG_WD_LOAD_FLAG_MASK) != 0 &&
>
> The "!= 0" is really unnecessary here.
>
> Also, wonder if there should be a specific delay in the loop. Looping without
> delay means this will time out faster on faster machines, which may cause
> unnecessary failures at some point.
>
> Overall I am a bit concerned that this is always called with interrupts
> disabled. Looping up to 10,000 times with interrupts disabled is a lot.
> Is this really necessary, or would a mutex be good enough ?
>
>> +             count < SECWDOG_MAX_TRY);
>> +     if (timeout)
>> +             *timeout = ((val & SECWDOG_WD_LOAD_FLAG_MASK) != 0);
>> +
>> +     /* We always mask out reserved bits before returning the value. */
>> +     val &= SECWDOG_RESERVED_MASK;
>> +
>
> You might consider defining the function as int32_t or as int, and return a
> negative error value (-EBUSY or -ETIMEDOUT). That would simplyfy the code a bit.
>
>> +     return val;
>> +}
>> +
>> +
> Single empty line is sufficient.
>
>> +#ifdef CONFIG_BCM_KONA_WDT_DEBUG
>> +
>> +static int bcm_kona_wdt_dbg_show(struct seq_file *s, void *data)
>> +{
>> +     uint32_t ctl_val, cur_val;
>> +     int ret, ctl_timeout, cur_timeout;
>> +     unsigned long flags;
>> +     struct bcm_kona_wdt *wdt = s->private;
>> +
>> +     if (!wdt)
>> +             return seq_printf(s, "No device pointer\n");
>> +
>> +     spin_lock_irqsave(&wdt->lock, flags);
>> +     ctl_val = secure_register_read(wdt->base + SECWDOG_CTRL_REG,
>> +                             &ctl_timeout);
>> +     cur_val = secure_register_read(wdt->base + SECWDOG_COUNT_REG,
>> +                             &cur_timeout);
>> +     spin_unlock_irqrestore(&wdt->lock, flags);
>> +
>> +     if (ctl_timeout || cur_timeout) {
>> +             ret = seq_printf(s, "Error accessing hardware\n");
>> +     } else {
>> +             int ctl, cur, ctl_sec, cur_sec, res;
>> +
>> +             ctl = ctl_val & SECWDOG_COUNT_MASK;
>> +             res = (ctl_val & SECWDOG_RES_MASK) >> SECWDOG_CLKS_SHIFT;
>> +             cur = cur_val & SECWDOG_COUNT_MASK;
>> +             ctl_sec = TICKS_TO_SECS(ctl, wdt);
>> +             cur_sec = TICKS_TO_SECS(cur, wdt);
>> +             ret = seq_printf(s, "Resolution: %d / %d\n"
>> +                             "Control: %d s / %d (%#x) ticks\n"
>> +                             "Current: %d s / %d (%#x) ticks\n", res,
>> +                             wdt->resolution, ctl_sec, ctl, ctl, cur_sec,
>> +                             cur, cur);
>> +     }
>> +
>> +     return ret;
>> +}
>> +
>> +static int bcm_kona_dbg_open(struct inode *inode, struct file *file)
>> +{
>> +     return single_open(file, bcm_kona_wdt_dbg_show, inode->i_private);
>> +}
>> +
>> +static const struct file_operations bcm_kona_dbg_operations = {
>> +     .open           = bcm_kona_dbg_open,
>> +     .read           = seq_read,
>> +     .llseek         = seq_lseek,
>> +     .release        = single_release,
>> +};
>> +
>> +static struct dentry *bcm_kona_wdt_debugfs_init(struct bcm_kona_wdt *wdt,
>> +     struct watchdog_device *wdd)
>> +{
>> +     struct dentry *dir;
>> +
>> +     dir = debugfs_create_dir(BCM_KONA_WDT_NAME, NULL);
>> +     if (!dir)
>> +             return NULL;
>
> debugfs_create_dir() returns an ERR_PTR in error cases.
> That probably won't matter if DEBUG_FS is not defined, but I don't think
> debugfs_create_file will like it if there is a genuine error.
>
>> +
>> +     if (!debugfs_create_file("info", S_IFREG | S_IRUGO, dir, wdt,
>> +                             &bcm_kona_dbg_operations))
>> +             goto out_err;
>> +
>> +     return dir;
>> +
>> +out_err:
>> +     debugfs_remove_recursive(dir);
>> +     return NULL;
>> +}
>> +
>> +static void bcm_kona_debugfs_exit(struct dentry *debugfs)
>> +{
>> +     debugfs_remove_recursive(debugfs);
>> +}
>> +
>> +#endif /* CONFIG_BCM_KONA_WDT_DEBUG */
>> +
>> +
>
> Single empty line should be sufficient.
>
>> +static int bcm_kona_wdt_set_resolution_reg(struct bcm_kona_wdt *wdt)
>> +{
>> +     uint32_t val;
>> +     int timeout;
>> +     unsigned long flags;
>> +     int ret = 0;
>> +
>> +     if (wdt->resolution > SECWDOG_MAX_RES)
>> +             return -EINVAL;
>> +
> This can never happen; see below.

Right now it can't, so I can remove it for now. However, I am
considering a proposal for making the resolution available to be set
by userland. So this error case could happen then. That will be a
separate RFC / patch series, though.

>> +     spin_lock_irqsave(&wdt->lock, flags);
>> +
>> +     val = secure_register_read(wdt->base + SECWDOG_CTRL_REG, &timeout);
>> +     if (!timeout) {
>> +             val &= ~SECWDOG_RES_MASK;
>> +             val |= wdt->resolution << SECWDOG_CLKS_SHIFT;
>> +             writel_relaxed(val, wdt->base + SECWDOG_CTRL_REG);
>> +     } else {
>> +             ret = -EAGAIN;
>> +     }
>> +
>> +     spin_unlock_irqrestore(&wdt->lock, flags);
>> +
>> +     return ret;
>> +}
>> +
>> +static int bcm_kona_wdt_set_timeout_reg(struct watchdog_device *wdog)
>> +{
>> +     struct bcm_kona_wdt *wdt = watchdog_get_drvdata(wdog);
>> +     uint32_t val;
>> +     int timeout;
>> +     unsigned long flags;
>> +     int ret = 0;
>> +
>> +     spin_lock_irqsave(&wdt->lock, flags);
>> +
>> +     val = secure_register_read(wdt->base + SECWDOG_CTRL_REG, &timeout);
>> +     if (!timeout) {
>> +             val &= ~SECWDOG_COUNT_MASK;
>> +             val |= SECS_TO_TICKS(wdog->timeout, wdt);
>> +             writel_relaxed(val, wdt->base + SECWDOG_CTRL_REG);
>> +     } else {
>> +             ret = -EAGAIN;
>> +     }
>> +
>> +     spin_unlock_irqrestore(&wdt->lock, flags);
>> +
>> +     return ret;
>> +}
>> +
>> +static int bcm_kona_wdt_set_timeout(struct watchdog_device *wdog,
>> +     unsigned int t)
>> +{
>> +     wdog->timeout = t;
>> +     return 0;
>> +}
>> +
>> +static unsigned int bcm_kona_wdt_get_timeleft(struct watchdog_device *wdog)
>> +{
>> +     struct bcm_kona_wdt *wdt = watchdog_get_drvdata(wdog);
>> +     uint32_t val;
>> +     int timeout;
>> +     unsigned long flags;
>> +
>> +     spin_lock_irqsave(&wdt->lock, flags);
>> +     val = secure_register_read(wdt->base + SECWDOG_COUNT_REG, &timeout);
>> +     spin_unlock_irqrestore(&wdt->lock, flags);
>> +
>> +     if (timeout)
>> +             return -EAGAIN;
>> +
>> +     return TICKS_TO_SECS(val & SECWDOG_COUNT_MASK, wdt);
>> +}
>> +
>> +static int bcm_kona_wdt_start(struct watchdog_device *wdog)
>> +{
>> +     struct bcm_kona_wdt *wdt = watchdog_get_drvdata(wdog);
>> +     uint32_t val;
>> +     int timeout;
>> +     unsigned long flags;
>> +     int ret = 0;
>> +
>> +     spin_lock_irqsave(&wdt->lock, flags);
>> +
>> +     val = secure_register_read(wdt->base + SECWDOG_CTRL_REG, &timeout);
>> +     if (!timeout) {
>> +             val &= ~SECWDOG_COUNT_MASK;
>> +             val |= SECWDOG_EN_MASK | SECWDOG_SRSTEN_MASK |
>> +                     SECS_TO_TICKS(wdog->timeout, wdt);
>> +             writel_relaxed(val, wdt->base + SECWDOG_CTRL_REG);
>> +     } else {
>> +             ret = -EAGAIN;
>> +     }
>> +
>> +     spin_unlock_irqrestore(&wdt->lock, flags);
>> +
>> +     if (!timeout)
>> +             dev_info(wdog->dev, "Watchdog timer started");
>> +
> Since you don't have a ping function, and unless I am missing something, this
> message would be displayed for each watchdog ping. That is really not a good
> idea.

You are right. I added this when I did experiment with a separate ping
function. There wasn't much benefit to having it, so I took it back
out.

>> +     return ret;
>> +}
>> +
>> +static int bcm_kona_wdt_stop(struct watchdog_device *wdog)
>> +{
>> +     struct bcm_kona_wdt *wdt = watchdog_get_drvdata(wdog);
>> +     uint32_t val;
>> +     int timeout, timeleft;
>> +     unsigned long flags;
>> +     int ret = 0;
>> +
>> +     timeleft = bcm_kona_wdt_get_timeleft(wdog);
>> +     if (timeleft < 0)
>> +             return ret;
>> +
> Does this really make sense ? There is only an error if reading the
> watchdog counter register was unsuccessful. In this case, you just return
> w/o actually stopping the watchdog, but you claim success. That seems odd.

No. It doesn't make sense. It's also left-over from my experiments
with a separate ping function.

>> +     spin_lock_irqsave(&wdt->lock, flags);
>> +
>> +     val = secure_register_read(wdt->base + SECWDOG_CTRL_REG, &timeout);
>> +     if (!timeout) {
>> +             val &= ~(SECWDOG_EN_MASK | SECWDOG_SRSTEN_MASK |
>> +                     SECWDOG_COUNT_MASK);
>> +             val |= SECS_TO_TICKS(timeleft, wdt);
>> +             writel_relaxed(val, wdt->base + SECWDOG_CTRL_REG);
>> +     } else {
>> +             ret = -EAGAIN;
>> +     }
>> +
>> +     spin_unlock_irqrestore(&wdt->lock, flags);
>> +
>> +     if (!timeout)
>> +             dev_info(wdog->dev, "Watchdog timer stopped");
>> +
> All that noise.

Would it be acceptable to turn these calls into dev_dbg() calls, here
and elsewhere?

>> +     return ret;
>> +}
>> +
>> +static struct watchdog_ops bcm_kona_wdt_ops = {
>> +     .owner =        THIS_MODULE,
>> +     .start =        bcm_kona_wdt_start,
>> +     .stop =         bcm_kona_wdt_stop,
>> +     .set_timeout =  bcm_kona_wdt_set_timeout,
>> +     .get_timeleft = bcm_kona_wdt_get_timeleft,
>> +};
>> +
>> +static struct watchdog_info bcm_kona_wdt_info = {
>> +     .options =      WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE |
>> +                     WDIOF_KEEPALIVEPING,
>> +     .identity =     "Broadcom Kona Watchdog Timer",
>> +};
>> +
>> +static struct watchdog_device bcm_kona_wdt_wdd = {
>> +     .info =         &bcm_kona_wdt_info,
>> +     .ops =          &bcm_kona_wdt_ops,
>> +     .min_timeout =  1,
>> +     .max_timeout =  SECWDOG_MAX_COUNT >> SECWDOG_DEFAULT_RESOLUTION,
>> +     .timeout =      SECWDOG_MAX_COUNT >> SECWDOG_DEFAULT_RESOLUTION,
>> +};
>> +
>> +static void bcm_kona_wdt_shutdown(struct platform_device *pdev)
>> +{
>> +     bcm_kona_wdt_stop(&bcm_kona_wdt_wdd);
>> +}
>> +
>> +static int bcm_kona_wdt_probe(struct platform_device *pdev)
>> +{
>> +     struct device *dev = &pdev->dev;
>> +     struct bcm_kona_wdt *wdt;
>> +     struct resource *res;
>> +     int ret;
>> +
>> +     wdt = devm_kzalloc(dev, sizeof(*wdt), GFP_KERNEL);
>> +     if (!wdt) {
>> +             dev_err(dev, "Failed to allocate memory for watchdog device");
>> +             return -ENOMEM;
>> +     }
>> +
>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +     wdt->base = devm_ioremap_resource(dev, res);
>> +     if (IS_ERR(wdt->base))
>> +             return -ENODEV;
>> +
>> +     wdt->resolution = SECWDOG_DEFAULT_RESOLUTION;
>> +     ret = bcm_kona_wdt_set_resolution_reg(wdt);
>> +     if (ret) {
>> +             dev_err(dev, "Failed to set resolution (error: %d)", ret);
>
> ret can be -EAGAIN or -EINVAL. -EINVAL suggests a bad internale error (hopefully
> SECWDOG_DEFAULT_RESOLUTION is defined to be smaller than SECWDOG_MAX_RES),
> and if it is -EAGAIN there should be no error message.
>
> Actually, bcm_kona_wdt_set_resolution_reg is only called from here, meaning the
> error check in the function is really unnecessary.

This again goes back to making resolution available to userland. Then
bcm_kona_wdt_set_resolution_reg() would be called from elsewhere. Why
is it bad to print an error message on timeout? Would this still apply
if I switch the code to -ETIMEDOUT?

>> +             return ret;
>> +     }
>> +
>> +     spin_lock_init(&wdt->lock);
>> +     platform_set_drvdata(pdev, wdt);
>> +     watchdog_set_drvdata(&bcm_kona_wdt_wdd, wdt);
>> +
>> +     ret = bcm_kona_wdt_set_timeout_reg(&bcm_kona_wdt_wdd);
>> +     if (ret) {
>> +             dev_err(dev, "Failed set watchdog timeout");
>
> The only error case is -EAGAIN. I don't think there should be an error mesasge
> in this case (though I am not sure what the reaction should be).

I am thinking that probe() needs to return an error if setting the
timeout fails, as it can't really rely on the watchdog timer or let
the system use it. Shouldn't that be accompanied by an error message
letting the user know what happened?

>> +             return ret;
>> +     }
>> +
>> +     ret = watchdog_register_device(&bcm_kona_wdt_wdd);
>> +     if (ret) {
>> +             dev_err(dev, "Failed to register watchdog device");
>> +             return ret;
>> +     }
>> +
>> +#ifdef CONFIG_BCM_KONA_WDT_DEBUG
>> +     wdt->debugfs = bcm_kona_wdt_debugfs_init(wdt, &bcm_kona_wdt_wdd);
>> +#endif
>> +     dev_info(dev, "Broadcom Kona Watchdog Timer");
>> +
> Such messages are in general considered nuisance nowadays. I would suggest to
> remove it (or ask Greg KH for advice).
>
>> +     return 0;
>> +}
>> +
>> +static int bcm_kona_wdt_remove(struct platform_device *pdev)
>> +{
>> +#ifdef CONFIG_BCM_KONA_WDT_DEBUG
>> +     struct bcm_kona_wdt *wdt = platform_get_drvdata(pdev);
>> +
>> +     if (wdt->debugfs)
>> +             bcm_kona_debugfs_exit(wdt->debugfs);
>> +#endif /* CONFIG_BCM_KONA_WDT_DEBUG */
>> +     bcm_kona_wdt_shutdown(pdev);
>> +     watchdog_unregister_device(&bcm_kona_wdt_wdd);
>> +     dev_info(&pdev->dev, "Watchdog driver disabled");
>> +
> Even more nuisance.
>
>> +     return 0;
>> +}
>> +
>> +static const struct of_device_id bcm_kona_wdt_of_match[] = {
>> +     { .compatible = "brcm,kona-wdt", },
>> +     {},
>> +};
>> +MODULE_DEVICE_TABLE(of, bcm_kona_wdt_of_match);
>> +
>> +static struct platform_driver bcm_kona_wdt_driver = {
>> +     .driver = {
>> +                     .name = BCM_KONA_WDT_NAME,
>> +                     .owner = THIS_MODULE,
>> +                     .of_match_table = bcm_kona_wdt_of_match,
>> +                },
>> +     .probe = bcm_kona_wdt_probe,
>> +     .remove = bcm_kona_wdt_remove,
>> +     .shutdown = bcm_kona_wdt_shutdown,
>> +};
>> +
>> +module_platform_driver(bcm_kona_wdt_driver);
>> +
>> +MODULE_AUTHOR("Markus Mayer <mmayer@broadcom.com>");
>> +MODULE_DESCRIPTION("Broadcom Kona Watchdog Driver");
>> +MODULE_LICENSE("GPL v2");
>> +MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
>
> This alias is being removed.
>
>> --
>> 1.7.9.5

Thanks,
-Markus

-- 
Markus Mayer
Broadcom Landing Team
