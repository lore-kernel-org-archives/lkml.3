Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab3EXDTq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 23:19:46 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:61671 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759888Ab3EXDTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 23:19:44 -0400
MIME-Version: 1.0
In-Reply-To: <1369310405-21112-1-git-send-email-libo.chen@huawei.com>
References: <1369310405-21112-1-git-send-email-libo.chen@huawei.com>
Date: Fri, 24 May 2013 08:49:43 +0530
Message-ID: <CAK9yfHx7ifnWjKCVc0Oju-28PdosF81OpVC5S5Vdj6hDSnfQfw@mail.gmail.com>
Subject: Re: [PATCH RFC v3 1/3] i2c: i2c-bfin-twi: convert to devm_* API
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Libo Chen <libo.chen@huawei.com>
Cc: wsa@the-dreams.de, guz.fnst@cn.fujitsu.com, sonic.zhang@analog.com,
        uclinux-dist-devel@blackfin.uclinux.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 May 2013 17:30, Libo Chen <libo.chen@huawei.com> wrote:
> peripheral_request_list has got free if any one faild, so no need to free again in err case.
> aovid this, convert them to devm_* API
>
> Signed-off-by: Libo Chen <libo.chen@huawei.com>

It is a good practice to include changelog while submitting revised
versions of the patch.

> ---
>  drivers/i2c/busses/i2c-bfin-twi.c |   38 +++++++++---------------------------
>  1 files changed, 10 insertions(+), 28 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
> index 05080c4..2b99c48 100644
> --- a/drivers/i2c/busses/i2c-bfin-twi.c
> +++ b/drivers/i2c/busses/i2c-bfin-twi.c
> @@ -621,35 +621,27 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
>         int rc;
>         unsigned int clkhilow;
>
> -       iface = kzalloc(sizeof(struct bfin_twi_iface), GFP_KERNEL);
> +       iface = devm_kzalloc(&pdev->dev, sizeof(struct bfin_twi_iface),
> +                       GFP_KERNEL);
>         if (!iface) {
>                 dev_err(&pdev->dev, "Cannot allocate memory\n");

This error message is not really required.

> -               rc = -ENOMEM;
> -               goto out_error_nomem;
> +               return -ENOMEM;
>         }
>
>         spin_lock_init(&(iface->lock));
>
>         /* Find and map our resources */
>         res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -       if (res == NULL) {
> -               dev_err(&pdev->dev, "Cannot get IORESOURCE_MEM\n");
> -               rc = -ENOENT;
> -               goto out_error_get_res;
> -       }
> -
> -       iface->regs_base = ioremap(res->start, resource_size(res));
> -       if (iface->regs_base == NULL) {
> +       iface->regs_base = devm_ioremap_resource(&pdev->dev, res);
> +       if (IS_ERR(iface->regs_base)) {
>                 dev_err(&pdev->dev, "Cannot map IO\n");

devm_ioremap_resource prints out the error messages. So the above line
is redundant.

> -               rc = -ENXIO;
> -               goto out_error_ioremap;
> +               return -ENXIO;

Why not return PTR_ERR(iface->regs_base)?

>         }
>
>         iface->irq = platform_get_irq(pdev, 0);
>         if (iface->irq < 0) {
>                 dev_err(&pdev->dev, "No IRQ specified\n");
> -               rc = -ENOENT;
> -               goto out_error_no_irq;
> +               return -ENOENT;
>         }
>
>         p_adap = &iface->adap;
> @@ -666,10 +658,10 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
>                                         "i2c-bfin-twi");
>         if (rc) {
>                 dev_err(&pdev->dev, "Can't setup pin mux!\n");
> -               goto out_error_pin_mux;
> +               return rc;
>         }
>
> -       rc = request_irq(iface->irq, bfin_twi_interrupt_entry,
> +       rc = devm_request_irq(&pdev->dev, iface->irq, bfin_twi_interrupt_entry,
>                 0, pdev->name, iface);
>         if (rc) {
>                 dev_err(&pdev->dev, "Can't get IRQ %d !\n", iface->irq);
> @@ -707,16 +699,9 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
>         return 0;
>
>  out_error_add_adapter:
> -       free_irq(iface->irq, iface);
>  out_error_req_irq:
> -out_error_no_irq:
>         peripheral_free_list((unsigned short *)pdev->dev.platform_data);
> -out_error_pin_mux:
> -       iounmap(iface->regs_base);
> -out_error_ioremap:
> -out_error_get_res:
> -       kfree(iface);
> -out_error_nomem:
> +

Empty line not required.

You could probably combine all the empty labels into one meaningful label above.

>         return rc;


-- 
With warm regards,
Sachin
