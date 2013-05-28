Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab3E1UKm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 16:10:42 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:42767 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546Ab3E1UKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 16:10:41 -0400
MIME-Version: 1.0
In-Reply-To: <1369767800-31895-1-git-send-email-n.a.balandin@gmail.com>
References: <1369767800-31895-1-git-send-email-n.a.balandin@gmail.com>
Date: Tue, 28 May 2013 23:10:39 +0300
Message-ID: <CAHp75VdYxMovRMVQmspn14d+W2fZfSf-6CxODqqRBq1xvbU3yg@mail.gmail.com>
Subject: Re: [PATCH 1/1] drivers/misc: at2x: use devm_kzalloc() to make
 cleanup paths simpler
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

Thanks for updated version.
Please, find few comments below.

On Tue, May 28, 2013 at 10:03 PM, Nikolay Balandin
<n.a.balandin@gmail.com> wrote:
> From: Nikolay Balandin <nbalandin@dev.rtsoft.ru>

Next time you may use --subject-prefix to specify the version of the
patch. This one in particular is "PATCH v2".

I'm pretty sure Greg or any maintainer will ask you to split your
patch to two: one per driver.

> Use devm_kzalloc() instead of kzalloc. Get rid of the "goto" statements
> and useless dev_dbg() calls when driver probe fails.

I think in the subject line is better to write something like
"at24: convert to use devm_kzalloc".
For at25 accordingly.

> --- a/drivers/misc/eeprom/at24.c
> +++ b/drivers/misc/eeprom/at24.c

struct i2c_device_id *id)
>                 } else if (i2c_check_functionality(client->adapter,
>                                 I2C_FUNC_SMBUS_READ_BYTE_DATA)) {
>                         use_smbus = I2C_SMBUS_BYTE_DATA;
> -               } else {
> -                       err = -EPFNOSUPPORT;
> -                       goto err_out;
> -               }
> +               } else
> +                       return -EPFNOSUPPORT;

It's good to keep the style here untouched, because it follows CodingStyle.
thus
} else {
 return ...
}

> @@ -596,11 +589,11 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
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
> +

Redundant empty line

> +                       if (!at24->writebuf)
> +                               return -ENOMEM;
>                 } else {
>                         dev_warn(&client->dev,
>                                 "cannot write due to controller restrictions.");
> @@ -647,12 +640,6 @@ err_clients:
>         for (i = 1; i < num_addresses; i++)
>                 if (at24->client[i])
>                         i2c_unregister_device(at24->client[i]);
> -

No need to remove this empty line.

> @@ -666,9 +653,6 @@ static int at24_remove(struct i2c_client *client)
>
>         for (i = 1; i < at24->num_addresses; i++)
>                 i2c_unregister_device(at24->client[i]);
> -

Ditto.

--
With Best Regards,
Andy Shevchenko
