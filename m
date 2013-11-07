Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab3KGW4X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 17:56:23 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:43872 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab3KGW4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 17:56:15 -0500
MIME-Version: 1.0
In-Reply-To: <20131101133345.03db24ec@notabene.brown>
References: <20131101133345.03db24ec@notabene.brown>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 7 Nov 2013 14:55:54 -0800
Message-ID: <CAK5ve-JO3-f53SpfJb5P4kK+z3rATsS8cXAjnDr5RmCAZEPKjA@mail.gmail.com>
Subject: Re: [PATCH 1/2] LEDS: tca6507 - fix bugs in parsing of device-tree configuration.
To: NeilBrown <neilb@suse.de>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 7:33 PM, NeilBrown <neilb@suse.de> wrote:
>
>
> 1/ The led_info array must be allocated to allow the full number
>   of LEDs even if not all are present.  The array maybe be sparsely
>   filled but it is indexed by device address so we must at least
>   allocate as many slots as the highest address used.  It is easiest
>   just to allocate all 7.
>
> 2/ range check the 'reg' value properly.
>
> 3/ led.flags must be initialised to zero, else all leds could
>    be treated as GPIOs (depending on what happens to be on the stack).
>
> Signed-off-by: NeilBrown <neilb@suse.de>
>

Thanks, queued into devel branch of my tree for 3.14 kernel.

-Bryan

> diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
> index 8cc304f36728..f5063f447463 100644
> --- a/drivers/leds/leds-tca6507.c
> +++ b/drivers/leds/leds-tca6507.c
> @@ -682,7 +682,7 @@ tca6507_led_dt_init(struct i2c_client *client)
>                 return ERR_PTR(-ENODEV);
>
>         tca_leds = devm_kzalloc(&client->dev,
> -                       sizeof(struct led_info) * count, GFP_KERNEL);
> +                       sizeof(struct led_info) * NUM_LEDS, GFP_KERNEL);
>         if (!tca_leds)
>                 return ERR_PTR(-ENOMEM);
>
> @@ -695,9 +695,9 @@ tca6507_led_dt_init(struct i2c_client *client)
>                         of_get_property(child, "label", NULL) ? : child->name;
>                 led.default_trigger =
>                         of_get_property(child, "linux,default-trigger", NULL);
> -
> +               led.flags = 0;
>                 ret = of_property_read_u32(child, "reg", &reg);
> -               if (ret != 0)
> +               if (ret != 0 || reg < 0 || reg >= NUM_LEDS)
>                         continue;
>
>                 tca_leds[reg] = led;
> @@ -708,7 +708,7 @@ tca6507_led_dt_init(struct i2c_client *client)
>                 return ERR_PTR(-ENOMEM);
>
>         pdata->leds.leds = tca_leds;
> -       pdata->leds.num_leds = count;
> +       pdata->leds.num_leds = NUM_LEDS;
>
>         return pdata;
>  }
