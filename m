Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3FIQHy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 12:07:54 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:40477 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182Ab3FIQHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 12:07:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-SNBaS_T=FV3ov6-AtBPExMOOGP7dQ3RHG_FupUCcn0A@mail.gmail.com>
References: <CAPgLHd-SNBaS_T=FV3ov6-AtBPExMOOGP7dQ3RHG_FupUCcn0A@mail.gmail.com>
Date: Sun, 9 Jun 2013 19:07:52 +0300
Message-ID: <CAHp75VdQS+tDVxE1sTGoxkFLivgK5E5QEDh-5=eZAq3xcZNxMw@mail.gmail.com>
Subject: Re: [PATCH] memstick: fix error return code in r592_probe()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: maximlevitsky@gmail.com, yongjun_wei@trendmicro.com.cn,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's better to combine with moving it to pcim_* and devm_* and get
minus-diff instead of plus.

On Fri, Jun 7, 2013 at 5:15 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/memstick/host/r592.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/memstick/host/r592.c b/drivers/memstick/host/r592.c
> index 1b6e913..aa1dd24 100644
> --- a/drivers/memstick/host/r592.c
> +++ b/drivers/memstick/host/r592.c
> @@ -761,8 +761,10 @@ static int r592_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>                 goto error3;
>
>         dev->mmio = pci_ioremap_bar(pdev, 0);
> -       if (!dev->mmio)
> +       if (!dev->mmio) {
> +               error = -ENOMEM;
>                 goto error4;
> +       }
>
>         dev->irq = pdev->irq;
>         spin_lock_init(&dev->irq_lock);
> @@ -789,12 +791,13 @@ static int r592_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>                 &dev->dummy_dma_page_physical_address);
>         r592_stop_dma(dev , 0);
>
> -       if (request_irq(dev->irq, &r592_irq, IRQF_SHARED,
> -                         DRV_NAME, dev))
> +       error = request_irq(dev->irq, &r592_irq, IRQF_SHARED, DRV_NAME, dev);
> +       if (error)
>                 goto error6;
>
>         r592_update_card_detect(dev);
> -       if (memstick_add_host(host))
> +       error = memstick_add_host(host);
> +       if (error)
>                 goto error7;
>
>         message("driver successfully loaded");
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
With Best Regards,
Andy Shevchenko
