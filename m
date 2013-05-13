Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab3EMC1Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 22:27:25 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:47592 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab3EMC1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 22:27:24 -0400
MIME-Version: 1.0
In-Reply-To: <1367803801-17111-4-git-send-email-chao.xie@marvell.com>
References: <1367803801-17111-1-git-send-email-chao.xie@marvell.com> <1367803801-17111-4-git-send-email-chao.xie@marvell.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 13 May 2013 10:27:03 +0800
Message-ID: <CAMPhdO9EFj1YZt3zCD6evrH+t77=hiFj46_LPSM7dGX0rku6Kw@mail.gmail.com>
Subject: Re: [PATCH V4 3/3] pwm: pxa: add device tree support
To: Chao Xie <chao.xie@marvell.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Chao Xie <xiechao.mail@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 9:30 AM, Chao Xie <chao.xie@marvell.com> wrote:
> Add the deice tree support for pwm-pxa.
>
> Signed-off-by: Chao Xie <chao.xie@marvell.com>
> ---
>  drivers/pwm/pwm-pxa.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 51 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/pwm/pwm-pxa.c b/drivers/pwm/pwm-pxa.c
> index aa4bea7..c8d59a2 100644
> --- a/drivers/pwm/pwm-pxa.c
> +++ b/drivers/pwm/pwm-pxa.c
> @@ -9,6 +9,8 @@
>   *
>   * 2008-02-13  initial version
>   *             eric miao <eric.miao@marvell.com>
> + * 2013-04-24   add device tree support
> + *             Chao Xie <chao.xie@marvell.com>
>   */
>
>  #include <linux/module.h>
> @@ -18,6 +20,8 @@
>  #include <linux/err.h>
>  #include <linux/clk.h>
>  #include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
>  #include <linux/pwm.h>
>
>  #include <asm/div64.h>
> @@ -124,6 +128,38 @@ static struct pwm_ops pxa_pwm_ops = {
>         .owner = THIS_MODULE,
>  };
>
> +static const struct of_device_id pxa_pwm_of_match[] = {
> +       {
> +               .compatible = "marvell,pxa25x-pwm",
> +       }, {
> +               .compatible = "marvell,pxa27x-pwm",
> +               .data = (void *)HAS_SECONDARY_PWM
> +       }, {
> +               .compatible = "marvell,pxa168-pwm",
> +       }, {
> +               .compatible = "marvell,pxa910-pwm",
> +       },
> +       {}
> +};
> +
> +MODULE_DEVICE_TABLE(of, pxa_pwm_of_match);
> +
> +static int pxa_pwm_parse_data_dt(struct platform_device *pdev,
> +                               struct pxa_pwm_chip *pwm)
> +{
> +       const struct of_device_id *of_id =
> +                       of_match_device(pxa_pwm_of_match, &pdev->dev);
> +       unsigned int npwm;
> +
> +       if (!of_id)
> +               return -ENODEV;
> +
> +       npwm = (unsigned int)of_id->data;
> +       pwm->chip.npwm = (npwm & HAS_SECONDARY_PWM) ? 2 : 1;
> +
> +       return 0;
> +}
> +
>  static int pwm_probe(struct platform_device *pdev)
>  {
>         const struct platform_device_id *id = platform_get_device_id(pdev);
> @@ -144,7 +180,6 @@ static int pwm_probe(struct platform_device *pdev)
>         pwm->chip.dev = &pdev->dev;
>         pwm->chip.ops = &pxa_pwm_ops;
>         pwm->chip.base = -1;
> -       pwm->chip.npwm = (id->driver_data & HAS_SECONDARY_PWM) ? 2 : 1;
>
>         r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>         if (r == NULL) {
> @@ -156,6 +191,20 @@ static int pwm_probe(struct platform_device *pdev)
>         if (IS_ERR(pwm->mmio_base))
>                 return PTR_ERR(pwm->mmio_base);
>
> +       if (!id) {
> +               if (IS_ENABLED(CONFIG_OF))
> +                       ret = pxa_pwm_parse_data_dt(pdev, pwm);
> +               else
> +                       ret = -ENODEV;
> +       } else {
> +               pwm->chip.npwm = (id->driver_data & HAS_SECONDARY_PWM) ? 2 : 1;
> +       }

^^ braces not necessarily here, and I'm not really sure if we should check
CONFIG_OF firstly, and leave the platform_device_id thing as a legacy
fall back, what do you think?

  if (IS_ENABLED(CONFIG_OF)) {
     ...
  } else {
    const struct platform_device_id *id = platform_get_device_id(...);
    ...
  }

> +
> +       if (ret) {
> +               dev_err(&pdev->dev, "failed to parse data from device id\n");
> +               return ret;
> +       }
> +
>         ret = pwmchip_add(&pwm->chip);
>         if (ret < 0) {
>                 dev_err(&pdev->dev, "pwmchip_add() failed: %d\n", ret);
> @@ -181,6 +230,7 @@ static struct platform_driver pwm_driver = {
>         .driver         = {
>                 .name   = "pxa25x-pwm",
>                 .owner  = THIS_MODULE,
> +               .of_match_table = pxa_pwm_of_match,
>         },
>         .probe          = pwm_probe,
>         .remove         = pwm_remove,
> --
> 1.7.4.1
>
