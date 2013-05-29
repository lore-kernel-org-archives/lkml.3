Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965241Ab3E2Isv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 04:48:51 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:60788 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965080Ab3E2Iss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 04:48:48 -0400
MIME-Version: 1.0
In-Reply-To: <1369771220-5492-1-git-send-email-n.a.balandin@gmail.com>
References: <1369771220-5492-1-git-send-email-n.a.balandin@gmail.com>
Date: Wed, 29 May 2013 11:48:45 +0300
Message-ID: <CAHp75Vda5BB-K4mcUUDQFJSROznYsf=oAUZ7ody+TMqWUC5FSg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] drivers/misc: at24: convert to use devm_kzalloc
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

On Tue, May 28, 2013 at 11:00 PM, Nikolay Balandin
<n.a.balandin@gmail.com> wrote:
> From: Nikolay Balandin <nbalandin@dev.rtsoft.ru>
>
> Use devm_kzalloc to make cleanup paths simpler
>
> Signed-off-by: Nikolay Balandin <nbalandin@dev.rtsoft.ru>

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> ---
>  drivers/misc/eeprom/at24.c |   44 +++++++++++++++-----------------------------
>  1 file changed, 15 insertions(+), 29 deletions(-)
>
> diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
> index 2baeec5..5d4fd69 100644
> --- a/drivers/misc/eeprom/at24.c
> +++ b/drivers/misc/eeprom/at24.c
> @@ -492,10 +492,9 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
>         if (client->dev.platform_data) {
>                 chip = *(struct at24_platform_data *)client->dev.platform_data;
>         } else {
> -               if (!id->driver_data) {
> -                       err = -ENODEV;
> -                       goto err_out;
> -               }
> +               if (!id->driver_data)
> +                       return -ENODEV;
> +
>                 magic = id->driver_data;
>                 chip.byte_len = BIT(magic & AT24_BITMASK(AT24_SIZE_BYTELEN));
>                 magic >>= AT24_SIZE_BYTELEN;
> @@ -519,8 +518,7 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
>                         "byte_len looks suspicious (no power of 2)!\n");
>         if (!chip.page_size) {
>                 dev_err(&client->dev, "page_size must not be 0!\n");
> -               err = -EINVAL;
> -               goto err_out;
> +               return -EINVAL;
>         }
>         if (!is_power_of_2(chip.page_size))
>                 dev_warn(&client->dev,
> @@ -528,10 +526,9 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
>
>         /* Use I2C operations unless we're stuck with SMBus extensions. */
>         if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> -               if (chip.flags & AT24_FLAG_ADDR16) {
> -                       err = -EPFNOSUPPORT;
> -                       goto err_out;
> -               }
> +               if (chip.flags & AT24_FLAG_ADDR16)
> +                       return -EPFNOSUPPORT;
> +
>                 if (i2c_check_functionality(client->adapter,
>                                 I2C_FUNC_SMBUS_READ_I2C_BLOCK)) {
>                         use_smbus = I2C_SMBUS_I2C_BLOCK_DATA;
> @@ -542,8 +539,7 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
>                                 I2C_FUNC_SMBUS_READ_BYTE_DATA)) {
>                         use_smbus = I2C_SMBUS_BYTE_DATA;
>                 } else {
> -                       err = -EPFNOSUPPORT;
> -                       goto err_out;
> +                       return -EPFNOSUPPORT;
>                 }
>         }
>
> @@ -553,12 +549,10 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
>                 num_addresses = DIV_ROUND_UP(chip.byte_len,
>                         (chip.flags & AT24_FLAG_ADDR16) ? 65536 : 256);
>
> -       at24 = kzalloc(sizeof(struct at24_data) +
> +       at24 = devm_kzalloc(&client->dev, sizeof(struct at24_data) +
>                 num_addresses * sizeof(struct i2c_client *), GFP_KERNEL);
> -       if (!at24) {
> -               err = -ENOMEM;
> -               goto err_out;
> -       }
> +       if (!at24)
> +               return -ENOMEM;
>
>         mutex_init(&at24->lock);
>         at24->use_smbus = use_smbus;
> @@ -596,11 +590,10 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
>                         at24->write_max = write_max;
>
>                         /* buffer (data + address at the beginning) */
> -                       at24->writebuf = kmalloc(write_max + 2, GFP_KERNEL);
> -                       if (!at24->writebuf) {
> -                               err = -ENOMEM;
> -                               goto err_struct;
> -                       }
> +                       at24->writebuf = devm_kzalloc(&client->dev,
> +                               write_max + 2, GFP_KERNEL);
> +                       if (!at24->writebuf)
> +                               return -ENOMEM;
>                 } else {
>                         dev_warn(&client->dev,
>                                 "cannot write due to controller restrictions.");
> @@ -648,11 +641,6 @@ err_clients:
>                 if (at24->client[i])
>                         i2c_unregister_device(at24->client[i]);
>
> -       kfree(at24->writebuf);
> -err_struct:
> -       kfree(at24);
> -err_out:
> -       dev_dbg(&client->dev, "probe error %d\n", err);
>         return err;
>  }
>
> @@ -667,8 +655,6 @@ static int at24_remove(struct i2c_client *client)
>         for (i = 1; i < at24->num_addresses; i++)
>                 i2c_unregister_device(at24->client[i]);
>
> -       kfree(at24->writebuf);
> -       kfree(at24);
>         return 0;
>  }
>
> --
> 1.7.9.5
>



--
With Best Regards,
Andy Shevchenko
