Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbaLPK15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 05:27:57 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:45281 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaLPK1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 05:27:55 -0500
MIME-Version: 1.0
In-Reply-To: <1418267151-5650-1-git-send-email-Ken.Xue@amd.com>
References: <1418267151-5650-1-git-send-email-Ken.Xue@amd.com>
Date: Tue, 16 Dec 2014 12:27:54 +0200
Message-ID: <CAHp75VfoMs-A-6UQurcNsNOCcpgtGL9BjhEPK6j9CET+v=CgGg@mail.gmail.com>
Subject: Re: [PATCH 3/3] acpi:lpss:Refine lpss codes to fit acpi soc.
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Ken Xue <Ken.Xue@amd.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 5:05 AM, Ken Xue <Ken.Xue@amd.com> wrote:

Make a commit message not empty.

> Signed-off-by: Ken Xue <Ken.Xue@amd.com>
> ---
>  drivers/acpi/acpi_lpss.c | 566 ++++++++++++++++++-----------------------------
>  1 file changed, 221 insertions(+), 345 deletions(-)
>
> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> index 93d1606..554c932 100644
> --- a/drivers/acpi/acpi_lpss.c
> +++ b/drivers/acpi/acpi_lpss.c
> @@ -10,7 +10,6 @@
>   * published by the Free Software Foundation.
>   */
>
> -#include <linux/acpi.h>
>  #include <linux/clk.h>
>  #include <linux/clkdev.h>
>  #include <linux/clk-provider.h>
> @@ -21,10 +20,13 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/delay.h>
>
> +#include "acpi_soc.h"
>  #include "internal.h"
>
>  ACPI_MODULE_NAME("acpi_lpss");
>
> +static struct acpi_soc a_soc;
> +
>  #ifdef CONFIG_X86_INTEL_LPSS
>
>  #define LPSS_ADDR(desc) ((unsigned long)&desc)
> @@ -58,170 +60,71 @@ ACPI_MODULE_NAME("acpi_lpss");
>  #define LPSS_CLK                       BIT(0)
>  #define LPSS_CLK_GATE                  BIT(1)
>  #define LPSS_CLK_DIVIDER               BIT(2)
> -#define LPSS_LTR                       BIT(3)
> -#define LPSS_SAVE_CTX                  BIT(4)
> -
> -struct lpss_private_data;
> -
> -struct lpss_device_desc {
> -       unsigned int flags;
> -       unsigned int prv_offset;
> -       size_t prv_size_override;
> -       void (*setup)(struct lpss_private_data *pdata);
> -};
> -
> -static struct lpss_device_desc lpss_dma_desc = {
> -       .flags = LPSS_CLK,
> -};
> -
> -struct lpss_private_data {
> -       void __iomem *mmio_base;
> -       resource_size_t mmio_size;
> -       unsigned int fixed_clk_rate;
> -       struct clk *clk;
> -       const struct lpss_device_desc *dev_desc;
> -       u32 prv_reg_ctx[LPSS_PRV_REG_COUNT];
> -};
>
>  /* UART Component Parameter Register */
>  #define LPSS_UART_CPR                  0xF4
>  #define LPSS_UART_CPR_AFCE             BIT(4)
>
> -static void lpss_uart_setup(struct lpss_private_data *pdata)
> +static u32 __lpss_reg_read(struct acpi_soc_dev_private_data *pdata,
> +                       unsigned int reg)
>  {
> -       unsigned int offset;
> -       u32 val;
> -
> -       offset = pdata->dev_desc->prv_offset + LPSS_TX_INT;
> -       val = readl(pdata->mmio_base + offset);
> -       writel(val | LPSS_TX_INT_MASK, pdata->mmio_base + offset);
> -
> -       val = readl(pdata->mmio_base + LPSS_UART_CPR);
> -       if (!(val & LPSS_UART_CPR_AFCE)) {
> -               offset = pdata->dev_desc->prv_offset + LPSS_GENERAL;
> -               val = readl(pdata->mmio_base + offset);
> -               val |= LPSS_GENERAL_UART_RTS_OVRD;
> -               writel(val, pdata->mmio_base + offset);
> -       }
> +       return readl(pdata->mmio_base + pdata->dev_desc->prv_offset + reg);
>  }
>
> -static void byt_i2c_setup(struct lpss_private_data *pdata)
> +static void __lpss_reg_write(u32 val, struct acpi_soc_dev_private_data *pdata,
> +                            unsigned int reg)
>  {
> -       unsigned int offset;
> -       u32 val;
> -
> -       offset = pdata->dev_desc->prv_offset + LPSS_RESETS;
> -       val = readl(pdata->mmio_base + offset);
> -       val |= LPSS_RESETS_RESET_APB | LPSS_RESETS_RESET_FUNC;
> -       writel(val, pdata->mmio_base + offset);
> -
> -       if (readl(pdata->mmio_base + pdata->dev_desc->prv_offset))
> -               pdata->fixed_clk_rate = 133000000;
> +       writel(val, pdata->mmio_base + pdata->dev_desc->prv_offset + reg);
>  }
>
> -static struct lpss_device_desc lpt_dev_desc = {
> -       .flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_CLK_DIVIDER | LPSS_LTR,
> -       .prv_offset = 0x800,
> -};
> -
> -static struct lpss_device_desc lpt_i2c_dev_desc = {
> -       .flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_LTR,
> -       .prv_offset = 0x800,
> -};
> -
> -static struct lpss_device_desc lpt_uart_dev_desc = {
> -       .flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_CLK_DIVIDER | LPSS_LTR,
> -       .prv_offset = 0x800,
> -       .setup = lpss_uart_setup,
> -};
> -
> -static struct lpss_device_desc lpt_sdio_dev_desc = {
> -       .flags = LPSS_LTR,
> -       .prv_offset = 0x1000,
> -       .prv_size_override = 0x1018,
> -};
> -
> -static struct lpss_device_desc byt_pwm_dev_desc = {
> -       .flags = LPSS_SAVE_CTX,
> -};
> -
> -static struct lpss_device_desc byt_uart_dev_desc = {
> -       .flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_CLK_DIVIDER | LPSS_SAVE_CTX,
> -       .prv_offset = 0x800,
> -       .setup = lpss_uart_setup,
> -};
> -
> -static struct lpss_device_desc byt_spi_dev_desc = {
> -       .flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_CLK_DIVIDER | LPSS_SAVE_CTX,
> -       .prv_offset = 0x400,
> -};
> -
> -static struct lpss_device_desc byt_sdio_dev_desc = {
> -       .flags = LPSS_CLK,
> -};
> -
> -static struct lpss_device_desc byt_i2c_dev_desc = {
> -       .flags = LPSS_CLK | LPSS_SAVE_CTX,
> -       .prv_offset = 0x800,
> -       .setup = byt_i2c_setup,
> -};
> -
> -#else
> -
> -#define LPSS_ADDR(desc) (0UL)
> -
> -#endif /* CONFIG_X86_INTEL_LPSS */
> -
> -static const struct acpi_device_id acpi_lpss_device_ids[] = {
> -       /* Generic LPSS devices */
> -       { "INTL9C60", LPSS_ADDR(lpss_dma_desc) },
> -
> -       /* Lynxpoint LPSS devices */
> -       { "INT33C0", LPSS_ADDR(lpt_dev_desc) },
> -       { "INT33C1", LPSS_ADDR(lpt_dev_desc) },
> -       { "INT33C2", LPSS_ADDR(lpt_i2c_dev_desc) },
> -       { "INT33C3", LPSS_ADDR(lpt_i2c_dev_desc) },
> -       { "INT33C4", LPSS_ADDR(lpt_uart_dev_desc) },
> -       { "INT33C5", LPSS_ADDR(lpt_uart_dev_desc) },
> -       { "INT33C6", LPSS_ADDR(lpt_sdio_dev_desc) },
> -       { "INT33C7", },
> -
> -       /* BayTrail LPSS devices */
> -       { "80860F09", LPSS_ADDR(byt_pwm_dev_desc) },
> -       { "80860F0A", LPSS_ADDR(byt_uart_dev_desc) },
> -       { "80860F0E", LPSS_ADDR(byt_spi_dev_desc) },
> -       { "80860F14", LPSS_ADDR(byt_sdio_dev_desc) },
> -       { "80860F41", LPSS_ADDR(byt_i2c_dev_desc) },
> -       { "INT33B2", },
> -       { "INT33FC", },
> -
> -       /* Braswell LPSS devices */
> -       { "80862288", LPSS_ADDR(byt_pwm_dev_desc) },
> -       { "8086228A", LPSS_ADDR(byt_uart_dev_desc) },
> -       { "8086228E", LPSS_ADDR(byt_spi_dev_desc) },
> -       { "808622C1", LPSS_ADDR(byt_i2c_dev_desc) },
> -
> -       { "INT3430", LPSS_ADDR(lpt_dev_desc) },
> -       { "INT3431", LPSS_ADDR(lpt_dev_desc) },
> -       { "INT3432", LPSS_ADDR(lpt_i2c_dev_desc) },
> -       { "INT3433", LPSS_ADDR(lpt_i2c_dev_desc) },
> -       { "INT3434", LPSS_ADDR(lpt_uart_dev_desc) },
> -       { "INT3435", LPSS_ADDR(lpt_uart_dev_desc) },
> -       { "INT3436", LPSS_ADDR(lpt_sdio_dev_desc) },
> -       { "INT3437", },
> +static void acpi_lpss_set_ltr(struct device *dev, s32 val)
> +{
> +       struct acpi_soc_dev_private_data *pdata;
> +       u32 ltr_mode, ltr_val;
>
> -       /* Wildcat Point LPSS devices */
> -       { "INT3438", LPSS_ADDR(lpt_dev_desc) },
> +       pdata = acpi_driver_data(ACPI_COMPANION(dev));
> +       ltr_mode = __lpss_reg_read(pdata, LPSS_GENERAL);
> +       if (val < 0) {
> +               if (ltr_mode & LPSS_GENERAL_LTR_MODE_SW) {
> +                       ltr_mode &= ~LPSS_GENERAL_LTR_MODE_SW;
> +                       __lpss_reg_write(ltr_mode, pdata, LPSS_GENERAL);
> +               }
> +               return;
> +       }
> +       ltr_val = __lpss_reg_read(pdata, LPSS_SW_LTR) & ~LPSS_LTR_SNOOP_MASK;
> +       if (val >= LPSS_LTR_SNOOP_LAT_CUTOFF) {
> +               ltr_val |= LPSS_LTR_SNOOP_LAT_32US;
> +               val = LPSS_LTR_MAX_VAL;
> +       } else if (val > LPSS_LTR_MAX_VAL) {
> +               ltr_val |= LPSS_LTR_SNOOP_LAT_32US | LPSS_LTR_SNOOP_REQ;
> +               val >>= LPSS_LTR_SNOOP_LAT_SHIFT;
> +       } else {
> +               ltr_val |= LPSS_LTR_SNOOP_LAT_1US | LPSS_LTR_SNOOP_REQ;
> +       }
> +       ltr_val |= val;
> +       __lpss_reg_write(ltr_val, pdata, LPSS_SW_LTR);
> +       if (!(ltr_mode & LPSS_GENERAL_LTR_MODE_SW)) {
> +               ltr_mode |= LPSS_GENERAL_LTR_MODE_SW;
> +               __lpss_reg_write(ltr_mode, pdata, LPSS_GENERAL);
> +       }
> +}
>
> -       { }
> -};
> +static void acpi_lpss_bind(struct acpi_soc_dev_private_data *pdata,
> +                                                       struct device *dev)
> +{
> +       if (!pdata || !pdata->mmio_base || !(pdata->dev_desc->prv_offset))
> +               return;
>
> -#ifdef CONFIG_X86_INTEL_LPSS
> +       if (pdata->mmio_size >= pdata->dev_desc->prv_offset + LPSS_LTR_SIZE)
> +               dev->power.set_latency_tolerance = acpi_lpss_set_ltr;
> +       else
> +               dev_err(dev, "MMIO size insufficient to access LTR\n");
> +}
>
> -static int is_memory(struct acpi_resource *res, void *not_used)
> +static void acpi_lpss_unbind(struct acpi_soc_dev_private_data *pdata,
> +                       struct device *dev)
>  {
> -       struct resource r;
> -       return !acpi_dev_resource_memory(res, &r);
> +       dev->power.set_latency_tolerance = NULL;
>  }
>
>  /* LPSS main clock device. */
> @@ -233,9 +136,9 @@ static inline void lpt_register_clock_device(void)
>  }
>
>  static int register_device_clock(struct acpi_device *adev,
> -                                struct lpss_private_data *pdata)
> +                                struct acpi_soc_dev_private_data *pdata)
>  {
> -       const struct lpss_device_desc *dev_desc = pdata->dev_desc;
> +       struct acpi_soc_dev_desc *dev_desc = pdata->dev_desc;
>         const char *devname = dev_name(&adev->dev);
>         struct clk *clk = ERR_PTR(-ENODEV);
>         struct lpss_clk_data *clk_data;
> @@ -257,9 +160,9 @@ static int register_device_clock(struct acpi_device *adev,
>         parent = clk_data->name;
>         prv_base = pdata->mmio_base + dev_desc->prv_offset;
>
> -       if (pdata->fixed_clk_rate) {
> +       if (dev_desc->fixed_clk_rate) {
>                 clk = clk_register_fixed_rate(NULL, devname, parent, 0,
> -                                             pdata->fixed_clk_rate);
> +                                             dev_desc->fixed_clk_rate);
>                 goto out;
>         }
>
> @@ -297,103 +200,182 @@ out:
>         if (IS_ERR(clk))
>                 return PTR_ERR(clk);
>
> -       pdata->clk = clk;
> +       dev_desc->clk = clk;
>         clk_register_clkdev(clk, NULL, devname);
>         return 0;
>  }
>
> -static int acpi_lpss_create_device(struct acpi_device *adev,
> -                                  const struct acpi_device_id *id)
> +static int lpss_common_setup(struct acpi_soc_dev_private_data *pdata)
>  {
> -       struct lpss_device_desc *dev_desc;
> -       struct lpss_private_data *pdata;
> -       struct resource_list_entry *rentry;
> -       struct list_head resource_list;
> -       struct platform_device *pdev;
> -       int ret;
> -
> -       dev_desc = (struct lpss_device_desc *)id->driver_data;
> -       if (!dev_desc) {
> -               pdev = acpi_create_platform_device(adev);
> -               return IS_ERR_OR_NULL(pdev) ? PTR_ERR(pdev) : 1;
> -       }
> -       pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
> -       if (!pdata)
> -               return -ENOMEM;
> -
> -       INIT_LIST_HEAD(&resource_list);
> -       ret = acpi_dev_get_resources(adev, &resource_list, is_memory, NULL);
> -       if (ret < 0)
> -               goto err_out;
> -
> -       list_for_each_entry(rentry, &resource_list, node)
> -               if (resource_type(&rentry->res) == IORESOURCE_MEM) {
> -                       if (dev_desc->prv_size_override)
> -                               pdata->mmio_size = dev_desc->prv_size_override;
> -                       else
> -                               pdata->mmio_size = resource_size(&rentry->res);
> -                       pdata->mmio_base = ioremap(rentry->res.start,
> -                                                  pdata->mmio_size);
> -                       break;
> -               }
> -
> -       acpi_dev_free_resource_list(&resource_list);
> +       int ret = 0;
> +       struct acpi_soc_dev_desc *dev_desc;
>
> -       pdata->dev_desc = dev_desc;
> +       dev_desc = pdata->dev_desc;
>
> -       if (dev_desc->setup)
> -               dev_desc->setup(pdata);
> +       if (dev_desc->flags & LPSS_CLK)
> +               ret = register_device_clock(pdata->adev, pdata);
>
> -       if (dev_desc->flags & LPSS_CLK) {
> -               ret = register_device_clock(adev, pdata);
> -               if (ret) {
> -                       /* Skip the device, but continue the namespace scan. */
> -                       ret = 0;
> -                       goto err_out;
> -               }
> -       }
> +       return ret;
> +}
>
> -       /*
> -        * This works around a known issue in ACPI tables where LPSS devices
> -        * have _PS0 and _PS3 without _PSC (and no power resources), so
> -        * acpi_bus_init_power() will assume that the BIOS has put them into D0.
> -        */
> -       ret = acpi_device_fix_up_power(adev);
> -       if (ret) {
> -               /* Skip the device, but continue the namespace scan. */
> -               ret = 0;
> -               goto err_out;
> -       }
> +static int byt_i2c_setup(struct acpi_soc_dev_private_data *pdata)
> +{
> +       unsigned int offset;
> +       u32 val;
>
> -       adev->driver_data = pdata;
> -       pdev = acpi_create_platform_device(adev);
> -       if (!IS_ERR_OR_NULL(pdev)) {
> -               return 1;
> -       }
> +       offset = pdata->dev_desc->prv_offset + LPSS_RESETS;
> +       val = readl(pdata->mmio_base + offset);
> +       val |= LPSS_RESETS_RESET_APB | LPSS_RESETS_RESET_FUNC;
> +       writel(val, pdata->mmio_base + offset);
>
> -       ret = PTR_ERR(pdev);
> -       adev->driver_data = NULL;
> +       if (readl(pdata->mmio_base + pdata->dev_desc->prv_offset))
> +               pdata->dev_desc->fixed_clk_rate = 133000000;
>
> - err_out:
> -       kfree(pdata);
> -       return ret;
> +       return lpss_common_setup(pdata);
>  }
>
> -static u32 __lpss_reg_read(struct lpss_private_data *pdata, unsigned int reg)
> +static int lpss_uart_setup(struct acpi_soc_dev_private_data *pdata)
>  {
> -       return readl(pdata->mmio_base + pdata->dev_desc->prv_offset + reg);
> -}
> +       unsigned int offset;
> +       u32 val;
>
> -static void __lpss_reg_write(u32 val, struct lpss_private_data *pdata,
> -                            unsigned int reg)
> -{
> -       writel(val, pdata->mmio_base + pdata->dev_desc->prv_offset + reg);
> +       offset = pdata->dev_desc->prv_offset + LPSS_TX_INT;
> +       val = readl(pdata->mmio_base + offset);
> +       writel(val | LPSS_TX_INT_MASK, pdata->mmio_base + offset);
> +
> +       val = readl(pdata->mmio_base + LPSS_UART_CPR);
> +       if (!(val & LPSS_UART_CPR_AFCE)) {
> +               offset = pdata->dev_desc->prv_offset + LPSS_GENERAL;
> +               val = readl(pdata->mmio_base + offset);
> +               val |= LPSS_GENERAL_UART_RTS_OVRD;
> +               writel(val, pdata->mmio_base + offset);
> +       }
> +
> +       return lpss_common_setup(pdata);
>  }
>
> +static struct acpi_soc_dev_desc lpss_dma_desc = {
> +       .flags = LPSS_CLK,
> +       .setup = lpss_common_setup,
> +};
> +
> +static struct acpi_soc_dev_desc lpt_dev_desc = {
> +       .flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_CLK_DIVIDER | ACPI_SOC_SYSFS,
> +       .prv_offset = 0x800,
> +       .setup = lpss_common_setup,
> +       .bind = acpi_lpss_bind,
> +       .unbind = acpi_lpss_unbind,
> +};
> +
> +static struct acpi_soc_dev_desc lpt_i2c_dev_desc = {
> +       .flags = LPSS_CLK | LPSS_CLK_GATE | ACPI_SOC_SYSFS,
> +       .prv_offset = 0x800,
> +       .setup = lpss_common_setup,
> +       .bind = acpi_lpss_bind,
> +       .unbind = acpi_lpss_unbind,
> +};
> +
> +static struct acpi_soc_dev_desc lpt_uart_dev_desc = {
> +       .flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_CLK_DIVIDER | ACPI_SOC_SYSFS,
> +       .prv_offset = 0x800,
> +       .setup = lpss_uart_setup,
> +       .bind = acpi_lpss_bind,
> +       .unbind = acpi_lpss_unbind,
> +};
> +
> +static struct acpi_soc_dev_desc lpt_sdio_dev_desc = {
> +       .flags = ACPI_SOC_SYSFS,
> +       .prv_offset = 0x1000,
> +       .mem_size_override = 0x1018,
> +       .setup = lpss_common_setup,
> +       .bind = acpi_lpss_bind,
> +       .unbind = acpi_lpss_unbind,
> +};
> +
> +static struct acpi_soc_dev_desc byt_pwm_dev_desc = {
> +       .flags = ACPI_SOC_PM,
> +       .setup = lpss_common_setup,
> +};
> +
> +static struct acpi_soc_dev_desc byt_uart_dev_desc = {
> +       .flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_CLK_DIVIDER | ACPI_SOC_PM,
> +       .prv_offset = 0x800,
> +       .setup = lpss_uart_setup,
> +};
> +
> +static struct acpi_soc_dev_desc byt_spi_dev_desc = {
> +       .flags = LPSS_CLK | LPSS_CLK_GATE | LPSS_CLK_DIVIDER | ACPI_SOC_PM,
> +       .prv_offset = 0x400,
> +       .setup = lpss_common_setup,
> +};
> +
> +static struct acpi_soc_dev_desc byt_sdio_dev_desc = {
> +       .flags = LPSS_CLK,
> +       .setup = lpss_common_setup,
> +};
> +
> +static struct acpi_soc_dev_desc byt_i2c_dev_desc = {
> +       .flags = LPSS_CLK | ACPI_SOC_PM,
> +       .prv_offset = 0x800,
> +       .setup = byt_i2c_setup,
> +};
> +
> +#else
> +
> +#define LPSS_ADDR(desc) (0UL)
> +
> +#endif /* CONFIG_X86_INTEL_LPSS */
> +
> +static struct acpi_device_id acpi_lpss_device_ids[] = {
> +       /* Generic LPSS devices */
> +       { "INTL9C60", LPSS_ADDR(lpss_dma_desc) },
> +
> +       /* Lynxpoint LPSS devices */
> +       { "INT33C0", LPSS_ADDR(lpt_dev_desc) },
> +       { "INT33C1", LPSS_ADDR(lpt_dev_desc) },
> +       { "INT33C2", LPSS_ADDR(lpt_i2c_dev_desc) },
> +       { "INT33C3", LPSS_ADDR(lpt_i2c_dev_desc) },
> +       { "INT33C4", LPSS_ADDR(lpt_uart_dev_desc) },
> +       { "INT33C5", LPSS_ADDR(lpt_uart_dev_desc) },
> +       { "INT33C6", LPSS_ADDR(lpt_sdio_dev_desc) },
> +       { "INT33C7", },
> +
> +       /* BayTrail LPSS devices */
> +       { "80860F09", LPSS_ADDR(byt_pwm_dev_desc) },
> +       { "80860F0A", LPSS_ADDR(byt_uart_dev_desc) },
> +       { "80860F0E", LPSS_ADDR(byt_spi_dev_desc) },
> +       { "80860F14", LPSS_ADDR(byt_sdio_dev_desc) },
> +       { "80860F41", LPSS_ADDR(byt_i2c_dev_desc) },
> +       { "INT33B2", },
> +       { "INT33FC", },
> +
> +       /* Braswell LPSS devices */
> +       { "80862288", LPSS_ADDR(byt_pwm_dev_desc) },
> +       { "8086228A", LPSS_ADDR(byt_uart_dev_desc) },
> +       { "8086228E", LPSS_ADDR(byt_spi_dev_desc) },
> +       { "808622C1", LPSS_ADDR(byt_i2c_dev_desc) },
> +
> +       { "INT3430", LPSS_ADDR(lpt_dev_desc) },
> +       { "INT3431", LPSS_ADDR(lpt_dev_desc) },
> +       { "INT3432", LPSS_ADDR(lpt_i2c_dev_desc) },
> +       { "INT3433", LPSS_ADDR(lpt_i2c_dev_desc) },
> +       { "INT3434", LPSS_ADDR(lpt_uart_dev_desc) },
> +       { "INT3435", LPSS_ADDR(lpt_uart_dev_desc) },
> +       { "INT3436", LPSS_ADDR(lpt_sdio_dev_desc) },
> +       { "INT3437", },
> +
> +       /* Wildcat Point LPSS devices */
> +       { "INT3438", LPSS_ADDR(lpt_dev_desc) },
> +
> +       { }
> +};
> +
> +#ifdef CONFIG_X86_INTEL_LPSS
> +
>  static int lpss_reg_read(struct device *dev, unsigned int reg, u32 *val)
>  {
>         struct acpi_device *adev;
> -       struct lpss_private_data *pdata;
> +       struct acpi_soc_dev_private_data *pdata;
>         unsigned long flags;
>         int ret;
>
> @@ -464,37 +446,6 @@ static struct attribute_group lpss_attr_group = {
>         .name = "lpss_ltr",
>  };
>
> -static void acpi_lpss_set_ltr(struct device *dev, s32 val)
> -{
> -       struct lpss_private_data *pdata = acpi_driver_data(ACPI_COMPANION(dev));
> -       u32 ltr_mode, ltr_val;
> -
> -       ltr_mode = __lpss_reg_read(pdata, LPSS_GENERAL);
> -       if (val < 0) {
> -               if (ltr_mode & LPSS_GENERAL_LTR_MODE_SW) {
> -                       ltr_mode &= ~LPSS_GENERAL_LTR_MODE_SW;
> -                       __lpss_reg_write(ltr_mode, pdata, LPSS_GENERAL);
> -               }
> -               return;
> -       }
> -       ltr_val = __lpss_reg_read(pdata, LPSS_SW_LTR) & ~LPSS_LTR_SNOOP_MASK;
> -       if (val >= LPSS_LTR_SNOOP_LAT_CUTOFF) {
> -               ltr_val |= LPSS_LTR_SNOOP_LAT_32US;
> -               val = LPSS_LTR_MAX_VAL;
> -       } else if (val > LPSS_LTR_MAX_VAL) {
> -               ltr_val |= LPSS_LTR_SNOOP_LAT_32US | LPSS_LTR_SNOOP_REQ;
> -               val >>= LPSS_LTR_SNOOP_LAT_SHIFT;
> -       } else {
> -               ltr_val |= LPSS_LTR_SNOOP_LAT_1US | LPSS_LTR_SNOOP_REQ;
> -       }
> -       ltr_val |= val;
> -       __lpss_reg_write(ltr_val, pdata, LPSS_SW_LTR);
> -       if (!(ltr_mode & LPSS_GENERAL_LTR_MODE_SW)) {
> -               ltr_mode |= LPSS_GENERAL_LTR_MODE_SW;
> -               __lpss_reg_write(ltr_mode, pdata, LPSS_GENERAL);
> -       }
> -}
> -
>  #ifdef CONFIG_PM
>  /**
>   * acpi_lpss_save_ctx() - Save the private registers of LPSS device
> @@ -506,9 +457,10 @@ static void acpi_lpss_set_ltr(struct device *dev, s32 val)
>   */
>  static void acpi_lpss_save_ctx(struct device *dev)
>  {
> -       struct lpss_private_data *pdata = acpi_driver_data(ACPI_COMPANION(dev));
>         unsigned int i;
> +       struct acpi_soc_dev_private_data *pdata;
>
> +       pdata = acpi_driver_data(ACPI_COMPANION(dev));
>         for (i = 0; i < LPSS_PRV_REG_COUNT; i++) {
>                 unsigned long offset = i * sizeof(u32);
>
> @@ -526,8 +478,8 @@ static void acpi_lpss_save_ctx(struct device *dev)
>   */
>  static void acpi_lpss_restore_ctx(struct device *dev)
>  {
> -       struct lpss_private_data *pdata = acpi_driver_data(ACPI_COMPANION(dev));
>         unsigned int i;
> +       struct acpi_soc_dev_private_data *pdata;
>
>         /*
>          * The following delay is needed or the subsequent write operations may
> @@ -537,6 +489,7 @@ static void acpi_lpss_restore_ctx(struct device *dev)
>          */
>         msleep(10);
>
> +       pdata = acpi_driver_data(ACPI_COMPANION(dev));
>         for (i = 0; i < LPSS_PRV_REG_COUNT; i++) {
>                 unsigned long offset = i * sizeof(u32);
>
> @@ -615,99 +568,22 @@ static struct dev_pm_domain acpi_lpss_pm_domain = {
>         },
>  };
>
> -static int acpi_lpss_platform_notify(struct notifier_block *nb,
> -                                    unsigned long action, void *data)

Could it be just a part of this file? It seems for me that AMD doesn't
have anything specific which requires to have a dedicated power
domain. Am I wrong?

> -{
> -       struct platform_device *pdev = to_platform_device(data);
> -       struct lpss_private_data *pdata;
> -       struct acpi_device *adev;
> -       const struct acpi_device_id *id;
> -
> -       id = acpi_match_device(acpi_lpss_device_ids, &pdev->dev);
> -       if (!id || !id->driver_data)
> -               return 0;
> -
> -       if (acpi_bus_get_device(ACPI_HANDLE(&pdev->dev), &adev))
> -               return 0;
> -
> -       pdata = acpi_driver_data(adev);
> -       if (!pdata || !pdata->mmio_base)
> -               return 0;
> -
> -       if (pdata->mmio_size < pdata->dev_desc->prv_offset + LPSS_LTR_SIZE) {
> -               dev_err(&pdev->dev, "MMIO size insufficient to access LTR\n");
> -               return 0;
> -       }
> -
> -       switch (action) {
> -       case BUS_NOTIFY_BOUND_DRIVER:
> -               if (pdata->dev_desc->flags & LPSS_SAVE_CTX)
> -                       pdev->dev.pm_domain = &acpi_lpss_pm_domain;
> -               break;
> -       case BUS_NOTIFY_UNBOUND_DRIVER:
> -               if (pdata->dev_desc->flags & LPSS_SAVE_CTX)
> -                       pdev->dev.pm_domain = NULL;
> -               break;
> -       case BUS_NOTIFY_ADD_DEVICE:
> -               if (pdata->dev_desc->flags & LPSS_LTR)
> -                       return sysfs_create_group(&pdev->dev.kobj,
> -                                                 &lpss_attr_group);
> -       case BUS_NOTIFY_DEL_DEVICE:
> -               if (pdata->dev_desc->flags & LPSS_LTR)
> -                       sysfs_remove_group(&pdev->dev.kobj, &lpss_attr_group);
> -       default:
> -               break;
> -       }
> -
> -       return 0;
> -}
> -
> -static struct notifier_block acpi_lpss_nb = {
> -       .notifier_call = acpi_lpss_platform_notify,
> -};
> -
> -static void acpi_lpss_bind(struct device *dev)
> -{
> -       struct lpss_private_data *pdata = acpi_driver_data(ACPI_COMPANION(dev));
> -
> -       if (!pdata || !pdata->mmio_base || !(pdata->dev_desc->flags & LPSS_LTR))
> -               return;
> -
> -       if (pdata->mmio_size >= pdata->dev_desc->prv_offset + LPSS_LTR_SIZE)
> -               dev->power.set_latency_tolerance = acpi_lpss_set_ltr;
> -       else
> -               dev_err(dev, "MMIO size insufficient to access LTR\n");
> -}
> -
> -static void acpi_lpss_unbind(struct device *dev)
> -{
> -       dev->power.set_latency_tolerance = NULL;
> -}
> -
> -static struct acpi_scan_handler lpss_handler = {
> -       .ids = acpi_lpss_device_ids,
> -       .attach = acpi_lpss_create_device,
> -       .bind = acpi_lpss_bind,
> -       .unbind = acpi_lpss_unbind,
> -};
> -
>  void __init acpi_lpss_init(void)
>  {
>         if (!lpt_clk_init()) {
> -               bus_register_notifier(&platform_bus_type, &acpi_lpss_nb);
> -               acpi_scan_add_handler(&lpss_handler);
> +               a_soc.ids = acpi_lpss_device_ids;
> +               a_soc.attr_group = &lpss_attr_group;
> +               a_soc.pm_domain = &acpi_lpss_pm_domain;
> +               register_acpi_soc(&a_soc, true);
>         }
>  }
>
>  #else
>
> -static struct acpi_scan_handler lpss_handler = {
> -       .ids = acpi_lpss_device_ids,
> -};
> -
>  void __init acpi_lpss_init(void)
>  {
> -       acpi_scan_add_handler(&lpss_handler);
> +       a_soc.ids = acpi_lpss_device_ids;
> +       register_acpi_soc(&a_soc, true);
>  }
>
>  #endif /* CONFIG_X86_INTEL_LPSS */
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
With Best Regards,
Andy Shevchenko
