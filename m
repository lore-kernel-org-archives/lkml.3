Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab3EYOvs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 10:51:48 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:37575 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598Ab3EYOvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 10:51:45 -0400
MIME-Version: 1.0
In-Reply-To: <1369492914-32288-1-git-send-email-n.a.balandin@gmail.com>
References: <1369492914-32288-1-git-send-email-n.a.balandin@gmail.com>
Date: Sat, 25 May 2013 10:51:43 -0400
Message-ID: <CAHdPZaMg5PeL-ny2jM5_UBC0cnS9uMTsC5knC6OwiqV=3Mh0mw@mail.gmail.com>
Subject: Re: [PATCH 1/1] rtc: rtc-ds1307: use devm_*() functions
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Nikolay Balandin <n.a.balandin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nikolay Balandin <nbalandin@dev.rtsoft.ru>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 25, 2013 at 10:41 AM, Nikolay Balandin
<n.a.balandin@gmail.com> wrote:
> From: Nikolay Balandin <nbalandin@dev.rtsoft.ru>
>
> Use devm_*() functions to make cleanup paths simpler.
>
> Signed-off-by: Nikolay Balandin <nbalandin@dev.rtsoft.ru>
> ---
>  drivers/rtc/rtc-ds1307.c |   57 +++++++++++++++++-----------------------------
>  1 file changed, 21 insertions(+), 36 deletions(-)
>
> diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
> index b53992a..9852f55 100644
> --- a/drivers/rtc/rtc-ds1307.c
> +++ b/drivers/rtc/rtc-ds1307.c
> @@ -683,7 +683,9 @@ static int ds1307_probe(struct i2c_client *client,
>             && !i2c_check_functionality(adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
>                 return -EIO;
>
> -       ds1307 = kzalloc(sizeof(struct ds1307), GFP_KERNEL);
> +       ds1307 = devm_kzalloc(&client->dev, sizeof(struct ds1307),
> +                                               GFP_KERNEL);
> +
>         if (!ds1307)
>                 return -ENOMEM;
>
> @@ -714,8 +716,7 @@ static int ds1307_probe(struct i2c_client *client,
>                                 DS1337_REG_CONTROL, 2, buf);
>                 if (tmp != 2) {
>                         dev_dbg(&client->dev, "read error %d\n", tmp);
> -                       err = -EIO;
> -                       goto exit_free;
> +                       return -EIO;
>                 }
>
>                 /* oscillator off?  turn it on, so clock can tick. */
> @@ -753,8 +754,7 @@ static int ds1307_probe(struct i2c_client *client,
>                                 RX8025_REG_CTRL1 << 4 | 0x08, 2, buf);
>                 if (tmp != 2) {
>                         dev_dbg(&client->dev, "read error %d\n", tmp);
> -                       err = -EIO;
> -                       goto exit_free;
> +                       return -EIO;
>                 }
>
>                 /* oscillator off?  turn it on, so clock can tick. */
> @@ -797,8 +797,7 @@ static int ds1307_probe(struct i2c_client *client,
>                                         RX8025_REG_CTRL1 << 4 | 0x08, 2, buf);
>                         if (tmp != 2) {
>                                 dev_dbg(&client->dev, "read error %d\n", tmp);
> -                               err = -EIO;
> -                               goto exit_free;
> +                               return -EIO;
>                         }
>
>                         /* correct hour */
> @@ -825,8 +824,7 @@ read_rtc:
>         tmp = ds1307->read_block_data(ds1307->client, ds1307->offset, 8, buf);
>         if (tmp != 8) {
>                 dev_dbg(&client->dev, "read error %d\n", tmp);
> -               err = -EIO;
> -               goto exit_free;
> +               return -EIO;
>         }
>
>         /*
> @@ -867,8 +865,7 @@ read_rtc:
>                 tmp = i2c_smbus_read_byte_data(client, DS1340_REG_FLAG);
>                 if (tmp < 0) {
>                         dev_dbg(&client->dev, "read error %d\n", tmp);
> -                       err = -EIO;
> -                       goto exit_free;
> +                       return -EIO;
>                 }
>
>                 /* oscillator fault?  clear flag, and warn */
> @@ -927,13 +924,13 @@ read_rtc:
>                                 bin2bcd(tmp));
>         }
>
> -       ds1307->rtc = rtc_device_register(client->name, &client->dev,
> +       ds1307->rtc = devm_rtc_device_register(&client->dev, client->name,
>                                 &ds13xx_rtc_ops, THIS_MODULE);
>         if (IS_ERR(ds1307->rtc)) {
>                 err = PTR_ERR(ds1307->rtc);
>                 dev_err(&client->dev,
>                         "unable to register the class device\n");
> -               goto exit_free;
> +               return err;
>         }
>
>         if (want_irq) {
> @@ -942,7 +939,7 @@ read_rtc:
>                 if (err) {
>                         dev_err(&client->dev,
>                                 "unable to request IRQ!\n");
> -                       goto exit_irq;
> +                       return err;
>                 }
>
>                 device_set_wakeup_capable(&client->dev, 1);
> @@ -951,12 +948,12 @@ read_rtc:
>         }
>
>         if (chip->nvram_size) {
> -               ds1307->nvram = kzalloc(sizeof(struct bin_attribute),
> -                                                       GFP_KERNEL);
> -               if (!ds1307->nvram) {
> -                       err = -ENOMEM;
> -                       goto exit_nvram;
> -               }
> +               ds1307->nvram = devm_kzalloc(&client->dev,
> +                       sizeof(struct bin_attribute), GFP_KERNEL);
> +
> +               if (!ds1307->nvram)
> +                       return -ENOMEM;
> +
>                 ds1307->nvram->attr.name = "nvram";
>                 ds1307->nvram->attr.mode = S_IRUGO | S_IWUSR;
>                 sysfs_bin_attr_init(ds1307->nvram);
> @@ -965,22 +962,14 @@ read_rtc:
>                 ds1307->nvram->size = chip->nvram_size;
>                 ds1307->nvram_offset = chip->nvram_offset;
>                 err = sysfs_create_bin_file(&client->dev.kobj, ds1307->nvram);
> -               if (err) {
> -                       kfree(ds1307->nvram);
> -                       goto exit_nvram;
> -               }
> +               if (err)
> +                       return err;
> +
>                 set_bit(HAS_NVRAM, &ds1307->flags);
>                 dev_info(&client->dev, "%zu bytes nvram\n", ds1307->nvram->size);
>         }
>
>         return 0;
> -
> -exit_nvram:
> -exit_irq:
> -       rtc_device_unregister(ds1307->rtc);

Please dont remove this unregister, there's no devm_* for the rtc subsystem.


> -exit_free:
> -       kfree(ds1307);
> -       return err;
>  }
>
>  static int ds1307_remove(struct i2c_client *client)
> @@ -992,13 +981,9 @@ static int ds1307_remove(struct i2c_client *client)
>                 cancel_work_sync(&ds1307->work);
>         }
>
> -       if (test_and_clear_bit(HAS_NVRAM, &ds1307->flags)) {
> +       if (test_and_clear_bit(HAS_NVRAM, &ds1307->flags))
>                 sysfs_remove_bin_file(&client->dev.kobj, ds1307->nvram);
> -               kfree(ds1307->nvram);
> -       }
>
> -       rtc_device_unregister(ds1307->rtc);

Here too.


> -       kfree(ds1307);
>         return 0;
>  }
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
