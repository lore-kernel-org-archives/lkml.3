Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab3ENQ3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:29:10 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:58835 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3ENQ3H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:29:07 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1368448964-2118-1-git-send-email-mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
References: <1368448964-2118-1-git-send-email-mika.westerberg@linux.intel.com>
Message-ID: <20130514162903.10068.97616@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH] ACPI / LPSS: add support for Intel BayTrail
Date: Tue, 14 May 2013 09:29:03 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mika Westerberg (2013-05-13 05:42:44)
> Intel BayTrail has almost the same Low Power Subsystem than Lynxpoint with
> few differences. Peripherals are clocked with different speeds (typically
> lower) and the clock is not always gated. To support this we add
> possibility to share a common fixed rate clock and make clock gating
> optional.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Acked-by: Mike Turquette <mturquette@linaro.org>

> ---
>  drivers/acpi/acpi_lpss.c  |   88 +++++++++++++++++++++++++++++++++++++++++----
>  drivers/clk/x86/clk-lpt.c |    4 +--
>  2 files changed, 82 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
> index 652fd5c..f6d7605 100644
> --- a/drivers/acpi/acpi_lpss.c
> +++ b/drivers/acpi/acpi_lpss.c
> @@ -33,11 +33,19 @@ ACPI_MODULE_NAME("acpi_lpss");
>  #define LPSS_SW_LTR                    0x10
>  #define LPSS_AUTO_LTR                  0x14
>  
> +struct lpss_shared_clock {
> +       const char *name;
> +       unsigned long rate;
> +       struct clk *clk;
> +};
> +
>  struct lpss_device_desc {
>         bool clk_required;
>         const char *clkdev_name;
>         bool ltr_required;
>         unsigned int prv_offset;
> +       bool clk_gate;
> +       struct lpss_shared_clock *shared_clock;
>  };
>  
>  static struct lpss_device_desc lpss_dma_desc = {
> @@ -56,6 +64,7 @@ static struct lpss_device_desc lpt_dev_desc = {
>         .clk_required = true,
>         .prv_offset = 0x800,
>         .ltr_required = true,
> +       .clk_gate = true,
>  };
>  
>  static struct lpss_device_desc lpt_sdio_dev_desc = {
> @@ -63,6 +72,45 @@ static struct lpss_device_desc lpt_sdio_dev_desc = {
>         .ltr_required = true,
>  };
>  
> +static struct lpss_shared_clock uart_clock = {
> +       .name = "uart_clk",
> +       .rate = 44236800,
> +};
> +
> +static struct lpss_device_desc byt_uart_dev_desc = {
> +       .clk_required = true,
> +       .prv_offset = 0x800,
> +       .clk_gate = true,
> +       .shared_clock = &uart_clock,
> +};
> +
> +static struct lpss_shared_clock spi_clock = {
> +       .name = "spi_clk",
> +       .rate = 50000000,
> +};
> +
> +static struct lpss_device_desc byt_spi_dev_desc = {
> +       .clk_required = true,
> +       .prv_offset = 0x400,
> +       .clk_gate = true,
> +       .shared_clock = &spi_clock,
> +};
> +
> +static struct lpss_device_desc byt_sdio_dev_desc = {
> +       .clk_required = true,
> +};
> +
> +static struct lpss_shared_clock i2c_clock = {
> +       .name = "i2c_clk",
> +       .rate = 100000000,
> +};
> +
> +static struct lpss_device_desc byt_i2c_dev_desc = {
> +       .clk_required = true,
> +       .prv_offset = 0x800,
> +       .shared_clock = &i2c_clock,
> +};
> +
>  static const struct acpi_device_id acpi_lpss_device_ids[] = {
>         /* Generic LPSS devices */
>         { "INTL9C60", (unsigned long)&lpss_dma_desc },
> @@ -77,6 +125,13 @@ static const struct acpi_device_id acpi_lpss_device_ids[] = {
>         { "INT33C6", (unsigned long)&lpt_sdio_dev_desc },
>         { "INT33C7", },
>  
> +       /* BayTrail LPSS devices */
> +       { "80860F0A", (unsigned long)&byt_uart_dev_desc },
> +       { "80860F0E", (unsigned long)&byt_spi_dev_desc },
> +       { "80860F14", (unsigned long)&byt_sdio_dev_desc },
> +       { "80860F41", (unsigned long)&byt_i2c_dev_desc },
> +       { "INT33B2", },
> +
>         { }
>  };
>  
> @@ -98,7 +153,10 @@ static int register_device_clock(struct acpi_device *adev,
>                                  struct lpss_private_data *pdata)
>  {
>         const struct lpss_device_desc *dev_desc = pdata->dev_desc;
> +       struct lpss_shared_clock *shared_clock = dev_desc->shared_clock;
> +       struct clk *clk = ERR_PTR(-ENODEV);
>         struct lpss_clk_data *clk_data;
> +       const char *parent;
>  
>         if (!lpss_clk_dev)
>                 lpt_register_clock_device();
> @@ -117,14 +175,30 @@ static int register_device_clock(struct acpi_device *adev,
>             || pdata->mmio_size < dev_desc->prv_offset + LPSS_CLK_SIZE)
>                 return -ENODATA;
>  
> -       pdata->clk = clk_register_gate(NULL, dev_name(&adev->dev),
> -                                      clk_data->name, 0,
> -                                      pdata->mmio_base + dev_desc->prv_offset,
> -                                      0, 0, NULL);
> -       if (IS_ERR(pdata->clk))
> -               return PTR_ERR(pdata->clk);
> +       parent = clk_data->name;
> +
> +       if (shared_clock) {
> +               clk = shared_clock->clk;
> +               if (!clk) {
> +                       clk = clk_register_fixed_rate(NULL, shared_clock->name,
> +                                                     "lpss_clk", 0,
> +                                                     shared_clock->rate);
> +                       shared_clock->clk = clk;
> +               }
> +               parent = shared_clock->name;
> +       }
> +
> +       if (dev_desc->clk_gate) {
> +               clk = clk_register_gate(NULL, dev_name(&adev->dev), parent, 0,
> +                                       pdata->mmio_base + dev_desc->prv_offset,
> +                                       0, 0, NULL);
> +               pdata->clk = clk;
> +       }
> +
> +       if (IS_ERR(clk))
> +               return PTR_ERR(clk);
>  
> -       clk_register_clkdev(pdata->clk, NULL, dev_name(&adev->dev));
> +       clk_register_clkdev(clk, NULL, dev_name(&adev->dev));
>         return 0;
>  }
>  
> diff --git a/drivers/clk/x86/clk-lpt.c b/drivers/clk/x86/clk-lpt.c
> index 4f45eee..812f83f 100644
> --- a/drivers/clk/x86/clk-lpt.c
> +++ b/drivers/clk/x86/clk-lpt.c
> @@ -1,5 +1,5 @@
>  /*
> - * Intel Lynxpoint LPSS clocks.
> + * Intel Low Power Subsystem clocks.
>   *
>   * Copyright (C) 2013, Intel Corporation
>   * Authors: Mika Westerberg <mika.westerberg@linux.intel.com>
> @@ -18,8 +18,6 @@
>  #include <linux/platform_data/clk-lpss.h>
>  #include <linux/platform_device.h>
>  
> -#define PRV_CLOCK_PARAMS 0x800
> -
>  static int lpt_clk_probe(struct platform_device *pdev)
>  {
>         struct lpss_clk_data *drvdata;
> -- 
> 1.7.10.4
