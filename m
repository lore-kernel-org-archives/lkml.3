Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaGBWF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 18:05:59 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:56037 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbaGBWF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 18:05:57 -0400
MIME-Version: 1.0
In-Reply-To: <1404337044-15142-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1404337044-15142-1-git-send-email-benjamin.tissoires@redhat.com>
Date: Wed, 2 Jul 2014 15:05:55 -0700
Message-ID: <CAF8JNhLVS7JMczwcvxURqTBb5SOfR7YNqWTrtvqy7dnJfsc6Hg@mail.gmail.com>
Subject: Re: [PATCH] Input - wacom: split out the pad device for the wireless receiver
From: Ping Cheng <pinglinux@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jason Gerecke <killertofu@gmail.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 2, 2014 at 2:37 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> The Wireless Receiver should also behave in the same way than regular
> USB devices.
>
> To simplify the unregistering of the different devices,
> wacom_unregister_inputs() is introduced.
> For consistency, the function wacom_register_input() is renamed into
> wacom_register_input().

wacom_register_inputs().

>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Reviewed-by: Ping Cheng <pingc@wacom.com>.

Ping

> ---
>
> Hi,
>
> I noticed this afternoon that the "pad-in-a-separate-device" was missing the
> conversion for the Wireless Receiver too :(
> So here is a fix.
>
> I also have a patch for hid-wacom to behave in the same way regarding the
> bluetooth devices. I'll send it once we know a little bit more about how will be
> handled wacom.ko in 3.17.
>
> Cheers,
> Benjamin
>
>  drivers/input/tablet/wacom_sys.c | 46 ++++++++++++++++++++--------------------
>  1 file changed, 23 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
> index 598efd4..a70aa01 100644
> --- a/drivers/input/tablet/wacom_sys.c
> +++ b/drivers/input/tablet/wacom_sys.c
> @@ -1148,7 +1148,17 @@ static struct input_dev *wacom_allocate_input(struct wacom *wacom)
>         return input_dev;
>  }
>
> -static int wacom_register_input(struct wacom *wacom)
> +static void wacom_unregister_inputs(struct wacom *wacom)
> +{
> +       if (wacom->wacom_wac.input)
> +               input_unregister_device(wacom->wacom_wac.input);
> +       if (wacom->wacom_wac.pad_input)
> +               input_unregister_device(wacom->wacom_wac.pad_input);
> +       wacom->wacom_wac.input = NULL;
> +       wacom->wacom_wac.pad_input = NULL;
> +}
> +
> +static int wacom_register_inputs(struct wacom *wacom)
>  {
>         struct input_dev *input_dev, *pad_input_dev;
>         struct wacom_wac *wacom_wac = &(wacom->wacom_wac);
> @@ -1220,16 +1230,12 @@ static void wacom_wireless_work(struct work_struct *work)
>         /* Stylus interface */
>         wacom1 = usb_get_intfdata(usbdev->config->interface[1]);
>         wacom_wac1 = &(wacom1->wacom_wac);
> -       if (wacom_wac1->input)
> -               input_unregister_device(wacom_wac1->input);
> -       wacom_wac1->input = NULL;
> +       wacom_unregister_inputs(wacom1);
>
>         /* Touch interface */
>         wacom2 = usb_get_intfdata(usbdev->config->interface[2]);
>         wacom_wac2 = &(wacom2->wacom_wac);
> -       if (wacom_wac2->input)
> -               input_unregister_device(wacom_wac2->input);
> -       wacom_wac2->input = NULL;
> +       wacom_unregister_inputs(wacom2);
>
>         if (wacom_wac->pid == 0) {
>                 dev_info(&wacom->intf->dev, "wireless tablet disconnected\n");
> @@ -1259,9 +1265,11 @@ static void wacom_wireless_work(struct work_struct *work)
>                 wacom_wac1->features.device_type = BTN_TOOL_PEN;
>                 snprintf(wacom_wac1->name, WACOM_NAME_MAX, "%s (WL) Pen",
>                          wacom_wac1->features.name);
> +               snprintf(wacom_wac1->pad_name, WACOM_NAME_MAX, "%s (WL) Pad",
> +                        wacom_wac1->features.name);
>                 wacom_wac1->shared->touch_max = wacom_wac1->features.touch_max;
>                 wacom_wac1->shared->type = wacom_wac1->features.type;
> -               error = wacom_register_input(wacom1);
> +               error = wacom_register_inputs(wacom1);
>                 if (error)
>                         goto fail;
>
> @@ -1279,7 +1287,9 @@ static void wacom_wireless_work(struct work_struct *work)
>                         else
>                                 snprintf(wacom_wac2->name, WACOM_NAME_MAX,
>                                          "%s (WL) Pad",wacom_wac2->features.name);
> -                       error = wacom_register_input(wacom2);
> +                       snprintf(wacom_wac2->pad_name, WACOM_NAME_MAX,
> +                                "%s (WL) Pad", wacom_wac2->features.name);
> +                       error = wacom_register_inputs(wacom2);
>                         if (error)
>                                 goto fail;
>
> @@ -1296,15 +1306,8 @@ static void wacom_wireless_work(struct work_struct *work)
>         return;
>
>  fail:
> -       if (wacom_wac2->input) {
> -               input_unregister_device(wacom_wac2->input);
> -               wacom_wac2->input = NULL;
> -       }
> -
> -       if (wacom_wac1->input) {
> -               input_unregister_device(wacom_wac1->input);
> -               wacom_wac1->input = NULL;
> -       }
> +       wacom_unregister_inputs(wacom1);
> +       wacom_unregister_inputs(wacom2);
>         return;
>  }
>
> @@ -1450,7 +1453,7 @@ static int wacom_probe(struct usb_interface *intf, const struct usb_device_id *i
>                 goto fail4;
>
>         if (!(features->quirks & WACOM_QUIRK_NO_INPUT)) {
> -               error = wacom_register_input(wacom);
> +               error = wacom_register_inputs(wacom);
>                 if (error)
>                         goto fail5;
>         }
> @@ -1490,10 +1493,7 @@ static void wacom_disconnect(struct usb_interface *intf)
>
>         usb_kill_urb(wacom->irq);
>         cancel_work_sync(&wacom->work);
> -       if (wacom->wacom_wac.input)
> -               input_unregister_device(wacom->wacom_wac.input);
> -       if (wacom->wacom_wac.pad_input)
> -               input_unregister_device(wacom->wacom_wac.pad_input);
> +       wacom_unregister_inputs(wacom);
>         wacom_destroy_battery(wacom);
>         wacom_destroy_leds(wacom);
>         usb_free_urb(wacom->irq);
> --
> 2.0.0
>
