Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038Ab3BNIgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 03:36:46 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55666 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353Ab3BNIgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 03:36:45 -0500
MIME-Version: 1.0
In-Reply-To: <20130214072643.GA4690@elgon.mountain>
References: <20130214072643.GA4690@elgon.mountain>
Date: Thu, 14 Feb 2013 14:06:43 +0530
Message-ID: <CAK7N6vpKNahP1xjHq6wx0vkN5Ayi6OrD4j8304Zwcu0Oc7WB=g@mail.gmail.com>
Subject: Re: [patch] generic-adc-battery: forever loop in gab_remove()
From: anish singh <anish198519851985@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 12:56 PM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> There is a forever loop calling iio_channel_release() because the
> "chan < " part of the "chan < ARRAY_SIZE()" is missing.  This is in both
> the error handling on probe and also in the remove function.
>
> The other thing is that it's possible for some of the elements of the
> adc_bat->channel[chan] array to be an ERR_PTR().  I've changed them to
> be NULL instead.  We're still not allowed to pass NULLs to
> iio_channel_release() so I've added a check.
>
> Finally, I removed an unused "chan = ARRAY_SIZE(gab_chan_name);"
> statement as a small cleanup.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

>
> diff --git a/drivers/power/generic-adc-battery.c b/drivers/power/generic-adc-battery.c
> index 42733c4..8cb5d7f 100644
> --- a/drivers/power/generic-adc-battery.c
> +++ b/drivers/power/generic-adc-battery.c
> @@ -263,9 +263,6 @@ static int gab_probe(struct platform_device *pdev)
>         psy->external_power_changed = gab_ext_power_changed;
>         adc_bat->pdata = pdata;
>
> -       /* calculate the total number of channels */
> -       chan = ARRAY_SIZE(gab_chan_name);
> -
>         /*
>          * copying the static properties and allocating extra memory for holding
>          * the extra configurable properties received from platform data.
> @@ -291,6 +288,7 @@ static int gab_probe(struct platform_device *pdev)
>                                                          gab_chan_name[chan]);
>                 if (IS_ERR(adc_bat->channel[chan])) {
>                         ret = PTR_ERR(adc_bat->channel[chan]);
> +                       adc_bat->channel[chan] = NULL;
>                 } else {
>                         /* copying properties for supported channels only */
>                         memcpy(properties + sizeof(*(psy->properties)) * index,
> @@ -344,8 +342,10 @@ err_gpio:
>  gpio_req_fail:
>         power_supply_unregister(psy);
>  err_reg_fail:
> -       for (chan = 0; ARRAY_SIZE(gab_chan_name); chan++)
> -               iio_channel_release(adc_bat->channel[chan]);
> +       for (chan = 0; chan < ARRAY_SIZE(gab_chan_name); chan++) {
> +               if (adc_bat->channel[chan])
> +                       iio_channel_release(adc_bat->channel[chan]);
> +       }
>  second_mem_fail:
>         kfree(psy->properties);
>  first_mem_fail:
> @@ -365,8 +365,10 @@ static int gab_remove(struct platform_device *pdev)
>                 gpio_free(pdata->gpio_charge_finished);
>         }
>
> -       for (chan = 0; ARRAY_SIZE(gab_chan_name); chan++)
> -               iio_channel_release(adc_bat->channel[chan]);
> +       for (chan = 0; chan < ARRAY_SIZE(gab_chan_name); chan++) {
> +               if (adc_bat->channel[chan])
> +                       iio_channel_release(adc_bat->channel[chan]);
> +       }
>
>         kfree(adc_bat->psy.properties);
>         cancel_delayed_work(&adc_bat->bat_work);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
