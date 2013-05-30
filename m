Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968173Ab3E3K0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:26:20 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:57269 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968055Ab3E3K0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:26:12 -0400
MIME-Version: 1.0
In-Reply-To: <51A6B7D4.7040202@huawei.com>
References: <51A6B7D4.7040202@huawei.com>
Date: Thu, 30 May 2013 13:26:11 +0300
Message-ID: <CAHp75VdGZ_20FTQRkoNzVaXavke3T2HijKj6rzDA2UqicyAdDA@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/2] mtd: bcm47: convert kzalloc to avoid invalid access
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Libo Chen <clbchenlibo.chen@huawei.com>
Cc: dwmw2@infradead.org, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        artem.bityutskiy@linux.intel.com, Bill Pemberton <wfp5p@virginia.edu>,
        hauke@hauke-m.de, linux-mtd@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 5:22 AM, Libo Chen <clbchenlibo.chen@huawei.com> wrote:
> mtd is just member of bcm47xxsflash, so we should free bcm47xxsflash not its member.
> So I use devm_kazlloc instead of kazlloc to avoid it.

You may amend commit message, but technically you have my
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> diff --git a/drivers/mtd/devices/bcm47xxsflash.c b/drivers/mtd/devices/bcm47xxsflash.c
> index 18e7761..2630d5c 100644
> --- a/drivers/mtd/devices/bcm47xxsflash.c
> +++ b/drivers/mtd/devices/bcm47xxsflash.c
> @@ -54,11 +54,9 @@ static int bcm47xxsflash_bcma_probe(struct platform_device *pdev)
>         struct bcm47xxsflash *b47s;
>         int err;
>
> -       b47s = kzalloc(sizeof(*b47s), GFP_KERNEL);
> -       if (!b47s) {
> -               err = -ENOMEM;
> -               goto out;
> -       }
> +       b47s = devm_kzalloc(&pdev->dev, sizeof(*b47s), GFP_KERNEL);
> +       if (!b47s)
> +               return -ENOMEM;
>         sflash->priv = b47s;
>
>         b47s->bcma_cc = container_of(sflash, struct bcma_drv_cc, sflash);
> @@ -81,15 +79,10 @@ static int bcm47xxsflash_bcma_probe(struct platform_device *pdev)
>         err = mtd_device_parse_register(&b47s->mtd, probes, NULL, NULL, 0);
>         if (err) {
>                 pr_err("Failed to register MTD device: %d\n", err);
> -               goto err_dev_reg;
> +               return err;
>         }
>
>         return 0;
> -
> -err_dev_reg:
> -       kfree(&b47s->mtd);
> -out:
> -       return err;
>  }
>
>  static int bcm47xxsflash_bcma_remove(struct platform_device *pdev)
> @@ -98,7 +91,6 @@ static int bcm47xxsflash_bcma_remove(struct platform_device *pdev)
>         struct bcm47xxsflash *b47s = sflash->priv;
>
>         mtd_device_unregister(&b47s->mtd);
> -       kfree(b47s);
>
>         return 0;
>  }
> --
> 1.7.1
>
>



--
With Best Regards,
Andy Shevchenko
