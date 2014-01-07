Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbaAGC0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 21:26:54 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:50662 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636AbaAGC0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 21:26:32 -0500
MIME-Version: 1.0
In-Reply-To: <1388122847-3276-1-git-send-email-rongjun.ying@csr.com>
References: <1388122847-3276-1-git-send-email-rongjun.ying@csr.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 7 Jan 2014 10:26:12 +0800
Message-ID: <CAGsJ_4zYRL2aM4vMxY6RT41ow3M1AjFDpcAcf2itarRjeF2CWA@mail.gmail.com>
Subject: Re: [PATCH v2] extcon: gpio: Add power resume support
To: rjying <rjying@gmail.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Barry Song <Barry.Song@csr.com>,
        DL-SHA-WorkGroupLinux <Workgroup.linux@csr.com>,
        Rongjun Ying <rongjun.ying@csr.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/27 rjying <rjying@gmail.com>:
> From: Rongjun Ying <rongjun.ying@csr.com>
>
> When system on the suspend state, Some SoC can't get gpio interrupt.
> After system resume, need send extcon uevent to userspace.
>
> Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>

Reviewed-by: Barry Song <Baohua.Song@csr.com>

for CSR SiRFSoC, we need similar patch in extcon to make the lost
plug/unplug event during sleeping to be resent.

> ---
>  -v2: Add lost_sleep_irq flags.
>
>  drivers/extcon/extcon-gpio.c       |   20 ++++++++++++++++++++
>  include/linux/extcon/extcon-gpio.h |    1 +
>  2 files changed, 21 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
> index 7e0dff5..fde52c1 100644
> --- a/drivers/extcon/extcon-gpio.c
> +++ b/drivers/extcon/extcon-gpio.c
> @@ -40,6 +40,7 @@ struct gpio_extcon_data {
>         int irq;
>         struct delayed_work work;
>         unsigned long debounce_jiffies;
> +       bool lost_sleep_irq;
>  };
>
>  static void gpio_extcon_work(struct work_struct *work)
> @@ -103,6 +104,7 @@ static int gpio_extcon_probe(struct platform_device *pdev)
>         extcon_data->gpio_active_low = pdata->gpio_active_low;
>         extcon_data->state_on = pdata->state_on;
>         extcon_data->state_off = pdata->state_off;
> +       extcon_data->lost_sleep_irq = pdata->lost_sleep_irq;
>         if (pdata->state_on && pdata->state_off)
>                 extcon_data->edev.print_state = extcon_gpio_print_state;
>         if (pdata->debounce) {
> @@ -159,12 +161,30 @@ static int gpio_extcon_remove(struct platform_device *pdev)
>         return 0;
>  }
>
> +#ifdef CONFIG_PM_SLEEP
> +static int gpio_extcon_resume(struct device *dev)
> +{
> +       struct gpio_extcon_data *extcon_data;
> +
> +       extcon_data = dev_get_drvdata(dev);
> +       if (extcon_data->lost_sleep_irq)
> +               queue_delayed_work(system_power_efficient_wq,
> +                       &extcon_data->work, extcon_data->debounce_jiffies);
> +       return 0;
> +}
> +#endif
> +
> +static const struct dev_pm_ops gpio_extcon_pm_ops = {
> +       SET_SYSTEM_SLEEP_PM_OPS(NULL, gpio_extcon_resume)
> +};
> +
>  static struct platform_driver gpio_extcon_driver = {
>         .probe          = gpio_extcon_probe,
>         .remove         = gpio_extcon_remove,
>         .driver         = {
>                 .name   = "extcon-gpio",
>                 .owner  = THIS_MODULE,
> +               .pm = &gpio_extcon_pm_ops,
>         },
>  };
>
> diff --git a/include/linux/extcon/extcon-gpio.h b/include/linux/extcon/extcon-gpio.h
> index 4195810..c7f0c3e 100644
> --- a/include/linux/extcon/extcon-gpio.h
> +++ b/include/linux/extcon/extcon-gpio.h
> @@ -51,6 +51,7 @@ struct gpio_extcon_platform_data {
>         /* if NULL, "0" or "1" will be printed */
>         const char *state_on;
>         const char *state_off;
> +       bool lost_sleep_irq;
>  };
>
>  #endif /* __EXTCON_GPIO_H__ */
> --
> 1.7.5.4

-barry
