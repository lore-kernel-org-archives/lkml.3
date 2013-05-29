Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965268Ab3E2IuX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 04:50:23 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:43630 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965117Ab3E2IuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 04:50:19 -0400
MIME-Version: 1.0
In-Reply-To: <1369771281-5527-1-git-send-email-n.a.balandin@gmail.com>
References: <1369771281-5527-1-git-send-email-n.a.balandin@gmail.com>
Date: Wed, 29 May 2013 11:50:16 +0300
Message-ID: <CAHp75Vek0AAiU0MHHHVckwPv-9KXhSDyWU6O=y3_48vYkORsrw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] drivers/misc: at25: convert to use devm_kzalloc
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Nikolay Balandin <n.a.balandin@gmail.com>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>, Jingoo Han <jg1.han@samsung.com>,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Nikolay Balandin <nbalandin@dev.rtsoft.ru>, linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 11:01 PM, Nikolay Balandin
<n.a.balandin@gmail.com> wrote:
> From: Nikolay Balandin <nbalandin@dev.rtsoft.ru>
>
> Use devm_kzalloc to make cleanup paths simpler
>
> Signed-off-by: Nikolay Balandin <nbalandin@dev.rtsoft.ru>

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> ---
>  drivers/misc/eeprom/at25.c |   25 ++++++++-----------------
>  1 file changed, 8 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
> index ad8fd8e..840b359 100644
> --- a/drivers/misc/eeprom/at25.c
> +++ b/drivers/misc/eeprom/at25.c
> @@ -371,11 +371,10 @@ static int at25_probe(struct spi_device *spi)
>                 if (np) {
>                         err = at25_np_to_chip(&spi->dev, np, &chip);
>                         if (err)
> -                               goto fail;
> +                               return err;
>                 } else {
>                         dev_err(&spi->dev, "Error: no chip description\n");
> -                       err = -ENODEV;
> -                       goto fail;
> +                       return -ENODEV;
>                 }
>         } else
>                 chip = *(struct spi_eeprom *)spi->dev.platform_data;
> @@ -389,8 +388,7 @@ static int at25_probe(struct spi_device *spi)
>                 addrlen = 3;
>         else {
>                 dev_dbg(&spi->dev, "unsupported address type\n");
> -               err = -EINVAL;
> -               goto fail;
> +               return -EINVAL;
>         }
>
>         /* Ping the chip ... the status register is pretty portable,
> @@ -400,14 +398,12 @@ static int at25_probe(struct spi_device *spi)
>         sr = spi_w8r8(spi, AT25_RDSR);
>         if (sr < 0 || sr & AT25_SR_nRDY) {
>                 dev_dbg(&spi->dev, "rdsr --> %d (%02x)\n", sr, sr);
> -               err = -ENXIO;
> -               goto fail;
> +               return -ENXIO;
>         }
>
> -       if (!(at25 = kzalloc(sizeof *at25, GFP_KERNEL))) {
> -               err = -ENOMEM;
> -               goto fail;
> -       }
> +       at25 = devm_kzalloc(&spi->dev, sizeof(struct at25_data), GFP_KERNEL);
> +       if (!at25)
> +               return -ENOMEM;
>
>         mutex_init(&at25->lock);
>         at25->chip = chip;
> @@ -439,7 +435,7 @@ static int at25_probe(struct spi_device *spi)
>
>         err = sysfs_create_bin_file(&spi->dev.kobj, &at25->bin);
>         if (err)
> -               goto fail;
> +               return err;
>
>         if (chip.setup)
>                 chip.setup(&at25->mem, chip.context);
> @@ -453,10 +449,6 @@ static int at25_probe(struct spi_device *spi)
>                 (chip.flags & EE_READONLY) ? " (readonly)" : "",
>                 at25->chip.page_size);
>         return 0;
> -fail:
> -       dev_dbg(&spi->dev, "probe err %d\n", err);
> -       kfree(at25);
> -       return err;
>  }
>
>  static int at25_remove(struct spi_device *spi)
> @@ -465,7 +457,6 @@ static int at25_remove(struct spi_device *spi)
>
>         at25 = spi_get_drvdata(spi);
>         sysfs_remove_bin_file(&spi->dev.kobj, &at25->bin);
> -       kfree(at25);
>         return 0;
>  }
>
> --
> 1.7.9.5
>



--
With Best Regards,
Andy Shevchenko
