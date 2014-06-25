Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707AbaFYWah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:30:37 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:54885 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbaFYWaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:30:35 -0400
MIME-Version: 1.0
In-Reply-To: <1403716136-32694-8-git-send-email-johan@kernel.org>
References: <1403716136-32694-1-git-send-email-johan@kernel.org> <1403716136-32694-8-git-send-email-johan@kernel.org>
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 25 Jun 2014 15:30:13 -0700
Message-ID: <CAK5ve-K2DQq+KpAARMWw_RR=zmCpz92TikAivwMNWT5=n2iDBQ@mail.gmail.com>
Subject: Re: [PATCH 07/13] leds: netxbig: fix attribute-creation race
To: Johan Hovold <johan@kernel.org>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-input@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        Janne Kanniainen <janne.kanniainen@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 10:08 AM, Johan Hovold <johan@kernel.org> wrote:
> Use the attribute groups of the led-class to create the sata attribute
> during probe in order to avoid racing with userspace.
>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/leds/leds-netxbig.c | 26 ++++++++++++--------------
>  1 file changed, 12 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/leds/leds-netxbig.c b/drivers/leds/leds-netxbig.c
> index e97f443a6e07..8ab931b8fcd3 100644
> --- a/drivers/leds/leds-netxbig.c
> +++ b/drivers/leds/leds-netxbig.c
> @@ -293,10 +293,14 @@ static ssize_t netxbig_led_sata_show(struct device *dev,
>
>  static DEVICE_ATTR(sata, 0644, netxbig_led_sata_show, netxbig_led_sata_store);
>
> +static struct attribute *netxbig_led_attrs[] = {
> +       &dev_attr_sata.attr,
> +       NULL
> +};
> +ATTRIBUTE_GROUPS(netxbig_led);
> +
>  static void delete_netxbig_led(struct netxbig_led_data *led_dat)
>  {
> -       if (led_dat->mode_val[NETXBIG_LED_SATA] != NETXBIG_LED_INVALID_MODE)
> -               device_remove_file(led_dat->cdev.dev, &dev_attr_sata);
>         led_classdev_unregister(&led_dat->cdev);
>  }
>
> @@ -327,6 +331,12 @@ create_netxbig_led(struct platform_device *pdev,
>         led_dat->sata = 0;
>         led_dat->cdev.brightness = LED_OFF;
>         led_dat->cdev.flags |= LED_CORE_SUSPENDRESUME;
> +       /*
> +        * If available, expose the SATA activity blink capability through
> +        * a "sata" sysfs attribute.
> +        */
> +       if (led_dat->mode_val[NETXBIG_LED_SATA] != NETXBIG_LED_INVALID_MODE)
> +               led_dat->cdev.groups = netxbig_led_groups;
>         led_dat->mode_addr = template->mode_addr;
>         led_dat->mode_val = template->mode_val;
>         led_dat->bright_addr = template->bright_addr;
> @@ -335,18 +345,6 @@ create_netxbig_led(struct platform_device *pdev,
>         led_dat->num_timer = pdata->num_timer;
>
>         ret = led_classdev_register(&pdev->dev, &led_dat->cdev);

Let's just "return led_classdev_register(&pdev->dev, &led_dat->cdev);"
and remove "ret"

I will handle this trivial change.

-Bryan
> -       if (ret < 0)
> -               return ret;
> -
> -       /*
> -        * If available, expose the SATA activity blink capability through
> -        * a "sata" sysfs attribute.
> -        */
> -       if (led_dat->mode_val[NETXBIG_LED_SATA] != NETXBIG_LED_INVALID_MODE) {
> -               ret = device_create_file(led_dat->cdev.dev, &dev_attr_sata);
> -               if (ret)
> -                       led_classdev_unregister(&led_dat->cdev);
> -       }
>
>         return ret;
>  }
> --
> 1.8.5.5
>
