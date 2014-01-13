Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaAMSO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 13:14:28 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:56014 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbaAMSO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 13:14:26 -0500
MIME-Version: 1.0
In-Reply-To: <1389045371-1631-2-git-send-email-markus.mayer@linaro.org>
References: <1389045371-1631-1-git-send-email-markus.mayer@linaro.org>
	<1389045371-1631-2-git-send-email-markus.mayer@linaro.org>
Date: Mon, 13 Jan 2014 10:14:24 -0800
Message-ID: <CAPdLdqnT8PBV8RFhZetqxy2u2Z1at7G2-fMDbuxFey-KWus7pw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] watchdog: bcm281xx: Debugfs support
From: Markus Mayer <markus.mayer@linaro.org>
To: Wim Van Sebroeck <wim@iguana.be>, Guenter Roeck <linux@roeck-us.net>,
        Christian Daudt <bcm@fixthebug.org>
Cc: Linaro Patches <patches@linaro.org>,
        Linux Watchdog List <linux-watchdog@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Markus Mayer <markus.mayer@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 January 2014 13:56, Markus Mayer <markus.mayer@linaro.org> wrote:
> This change introduces debugfs support for the BCM281xx watchdog driver.
>
> Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
> ---
>  drivers/watchdog/Kconfig        |   10 ++++
>  drivers/watchdog/bcm_kona_wdt.c |  108 +++++++++++++++++++++++++++++++++++++--
>  2 files changed, 114 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 10d188a..af8f7c7 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -1152,6 +1152,16 @@ config BCM_KONA_WDT
>           Say 'Y' or 'M' here to enable the driver. The module will be called
>           bcm_kona_wdt.
>
> +config BCM_KONA_WDT_DEBUG
> +       bool "DEBUGFS support for BCM Kona Watchdog"
> +       depends on BCM_KONA_WDT
> +       help
> +         If enabled, adds /sys/kernel/debug/bcm_kona_wdt/info which provides
> +         access to the driver's internal data structures as well as watchdog
> +         timer hardware registres.
> +
> +         If in doubt, say 'N'.
> +
>  config LANTIQ_WDT
>         tristate "Lantiq SoC watchdog"
>         depends on LANTIQ
> diff --git a/drivers/watchdog/bcm_kona_wdt.c b/drivers/watchdog/bcm_kona_wdt.c
> index 7e41a83..9c24809 100644
> --- a/drivers/watchdog/bcm_kona_wdt.c
> +++ b/drivers/watchdog/bcm_kona_wdt.c
> @@ -11,6 +11,7 @@
>   * GNU General Public License for more details.
>   */
>
> +#include <linux/debugfs.h>
>  #include <linux/delay.h>
>  #include <linux/err.h>
>  #include <linux/io.h>
> @@ -55,9 +56,13 @@ struct bcm_kona_wdt {
>          */
>         int resolution;
>         spinlock_t lock;
> +#ifdef CONFIG_BCM_KONA_WDT_DEBUG
> +       unsigned long busy_count;
> +       struct dentry *debugfs;
> +#endif
>  };
>
> -static int secure_register_read(void __iomem *addr)
> +static int secure_register_read(struct bcm_kona_wdt *wdt, uint32_t offset)
>  {
>         uint32_t val;
>         unsigned count = 0;
> @@ -70,10 +75,16 @@ static int secure_register_read(void __iomem *addr)
>         do {
>                 if (unlikely(count > 1))
>                         udelay(5);
> -               val = readl_relaxed(addr);
> +               val = readl_relaxed(wdt->base + offset);
>                 count++;
>         } while ((val & SECWDOG_WD_LOAD_FLAG) && count < SECWDOG_MAX_TRY);
>
> +#ifdef CONFIG_BCM_KONA_WDT_DEBUG
> +       /* Remember the maximum number iterations due to WD_LOAD_FLAG */
> +       if (count > wdt->busy_count)
> +               wdt->busy_count = count;
> +#endif
> +
>         /* This is the only place we return a negative value. */
>         if (val & SECWDOG_WD_LOAD_FLAG)
>                 return -ETIMEDOUT;
> @@ -84,6 +95,93 @@ static int secure_register_read(void __iomem *addr)
>         return val;
>  }
>
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
> +       ctl_val = secure_register_read(wdt, SECWDOG_CTRL_REG);
> +       cur_val = secure_register_read(wdt, SECWDOG_COUNT_REG);
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
> +                               cur, cur, wdt->busy_count);
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
> +static void bcm_kona_wdt_debug_init(struct platform_device *pdev)
> +{
> +       struct dentry *dir;
> +       struct bcm_kona_wdt *wdt = platform_get_drvdata(pdev);
> +
> +       if (!wdt)
> +               return;
> +
> +       wdt->debugfs = NULL;
> +
> +       dir = debugfs_create_dir(BCM_KONA_WDT_NAME, NULL);
> +       if (IS_ERR_OR_NULL(dir))
> +               return;
> +
> +       if (debugfs_create_file("info", S_IFREG | S_IRUGO, dir, wdt,
> +                               &bcm_kona_dbg_operations))
> +               wdt->debugfs = dir;
> +       else
> +               debugfs_remove_recursive(dir);
> +}
> +
> +static void bcm_kona_wdt_debug_exit(struct platform_device *pdev)
> +{
> +       struct bcm_kona_wdt *wdt = platform_get_drvdata(pdev);
> +
> +       if (wdt && wdt->debugfs) {
> +               debugfs_remove_recursive(wdt->debugfs);
> +               wdt->debugfs = NULL;
> +       }
> +}
> +
> +#else
> +
> +static void bcm_kona_wdt_debug_init(struct platform_device *pdev) {}
> +static void bcm_kona_wdt_debug_exit(struct platform_device *pdev) {}
> +
> +#endif /* CONFIG_BCM_KONA_WDT_DEBUG */
> +
>  static int bcm_kona_wdt_ctrl_reg_modify(struct bcm_kona_wdt *wdt,
>                                         unsigned mask, unsigned newval)
>  {
> @@ -93,7 +191,7 @@ static int bcm_kona_wdt_ctrl_reg_modify(struct bcm_kona_wdt *wdt,
>
>         spin_lock_irqsave(&wdt->lock, flags);
>
> -       val = secure_register_read(wdt->base + SECWDOG_CTRL_REG);
> +       val = secure_register_read(wdt, SECWDOG_CTRL_REG);
>         if (val < 0) {
>                 ret = val;
>         } else {
> @@ -140,7 +238,7 @@ static unsigned int bcm_kona_wdt_get_timeleft(struct watchdog_device *wdog)
>         unsigned long flags;
>
>         spin_lock_irqsave(&wdt->lock, flags);
> -       val = secure_register_read(wdt->base + SECWDOG_COUNT_REG);
> +       val = secure_register_read(wdt, SECWDOG_COUNT_REG);
>         spin_unlock_irqrestore(&wdt->lock, flags);
>
>         if (val < 0)
> @@ -229,6 +327,7 @@ static int bcm_kona_wdt_probe(struct platform_device *pdev)
>                 return ret;
>         }
>
> +       bcm_kona_wdt_debug_init(pdev);
>         dev_dbg(dev, "Broadcom Kona Watchdog Timer");
>
>         return 0;
> @@ -236,6 +335,7 @@ static int bcm_kona_wdt_probe(struct platform_device *pdev)
>
>  static int bcm_kona_wdt_remove(struct platform_device *pdev)
>  {
> +       bcm_kona_wdt_debug_exit(pdev);
>         bcm_kona_wdt_shutdown(pdev);
>         watchdog_unregister_device(&bcm_kona_wdt_wdd);
>         dev_dbg(&pdev->dev, "Watchdog driver disabled");
> --
> 1.7.9.5
>

Hi Wim,


I was wondering if this series be queued for 3.14?

Thanks,
-Markus

-- 
Markus Mayer
Broadcom Landing Team
