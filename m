Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210AbaDTWA2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 18:00:28 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:44981 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbaDTWAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 18:00:25 -0400
MIME-Version: 1.0
In-Reply-To: <1533887.5nzvy1GCXV@sigyn>
References: <1609685.QRL9N9sQvX@sigyn>
	<1533887.5nzvy1GCXV@sigyn>
Date: Mon, 21 Apr 2014 00:00:24 +0200
Message-ID: <CADbOyBSNZ3QV7VRZELK3RH-4kVaPga0jrMufAk3P2bXjvqox6Q@mail.gmail.com>
Subject: Re: [PATCH 12/24] Port hid-lgff to ff-memless-next
From: Elias Vanderstuyft <elias.vds@gmail.com>
To: =?UTF-8?B?TWljaGFsIE1hbMO9?= <madcatxster@devoid-pointer.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 1:24 PM, Michal Malý
<madcatxster@devoid-pointer.net> wrote:
> Port hid-lgff to ff-memless-next
>
> Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>
> ---
>  drivers/hid/Kconfig    |  2 +-
>  drivers/hid/hid-lgff.c | 63 ++++++++++++++++++++++++++++++++++----------------
>  2 files changed, 44 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index d1d4e77..c7794ae 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -356,7 +356,7 @@ config HID_LOGITECH_DJ
>  config LOGITECH_FF
>         bool "Logitech force feedback support"
>         depends on HID_LOGITECH
> -       select INPUT_FF_MEMLESS
> +       select INPUT_FF_MEMLESS_NEXT
>         help
>           Say Y here if you have one of these devices:
>           - Logitech WingMan Cordless RumblePad
> diff --git a/drivers/hid/hid-lgff.c b/drivers/hid/hid-lgff.c
> index e1394af..b929a3a 100644
> --- a/drivers/hid/hid-lgff.c
> +++ b/drivers/hid/hid-lgff.c
> @@ -31,9 +31,12 @@
>
>  #include <linux/input.h>
>  #include <linux/hid.h>
> +#include <linux/input/ff-memless-next.h>
>
>  #include "hid-lg.h"
>
> +#define FF_UPDATE_RATE 50
> +
>  struct dev_type {
>         u16 idVendor;
>         u16 idProduct;
> @@ -47,6 +50,13 @@ static const signed short ff_rumble[] = {
>
>  static const signed short ff_joystick[] = {
>         FF_CONSTANT,
> +       FF_RAMP,
> +       FF_PERIODIC,
> +       FF_SQUARE,
> +       FF_TRIANGLE,
> +       FF_SINE,
> +       FF_SAW_UP,
> +       FF_SAW_DOWN,
>         -1
>  };

Also do the same for the ff_joystick_ac[] array, as it also contains
the FF_CONSTANT capability.

>
> @@ -66,45 +76,58 @@ static const struct dev_type devices[] = {
>         { 0x046d, 0xc295, ff_joystick },
>  };
>
> -static int hid_lgff_play(struct input_dev *dev, void *data, struct ff_effect *effect)
> +static int hid_lgff_play(struct input_dev *dev, void *data,
> +                        const struct mlnx_effect_command *command)
>  {
>         struct hid_device *hid = input_get_drvdata(dev);
>         struct list_head *report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
>         struct hid_report *report = list_entry(report_list->next, struct hid_report, list);
> -       int x, y;
> -       unsigned int left, right;
>
> -#define CLAMP(x) if (x < 0) x = 0; if (x > 0xff) x = 0xff
> +       switch (command->cmd) {
> +       case MLNX_START_COMBINED: {
> +               const struct mlnx_simple_force *simple_force = &command->u.simple_force;
> +               /* Scale down from MLNX range */
> +               const int x = 0x80 - (simple_force->x * 0xff / 0xffff);
> +               const int y = simple_force->y * 0xff / 0xffff;

This should be concentrated about the center, which is 0x7f (see * in
next comment.)
Something like this:
        const int x = 0x7f - (simple_force->x * 0xff / 0xffff);
        const int y = 0x7f - (simple_force->y * 0xff / 0xffff);

>
> -       switch (effect->type) {
> -       case FF_CONSTANT:
> -               x = effect->u.ramp.start_level + 0x7f;  /* 0x7f is center */

* Here.

> -               y = effect->u.ramp.end_level + 0x7f;
> -               CLAMP(x);
> -               CLAMP(y);
>                 report->field[0]->value[0] = 0x51;
>                 report->field[0]->value[1] = 0x08;
>                 report->field[0]->value[2] = x;
>                 report->field[0]->value[3] = y;
>                 dbg_hid("(x, y)=(%04x, %04x)\n", x, y);
> -               hid_hw_request(hid, report, HID_REQ_SET_REPORT);
>                 break;
> +       }
> +       case MLNX_STOP_COMBINED:
> +               report->field[0]->value[0] = 0x51;
> +               report->field[0]->value[1] = 0x08;
> +               report->field[0]->value[2] = 0;
> +               report->field[0]->value[3] = 0;

Then this should become the center-position:
        report->field[0]->value[2] = 0x7f;
        report->field[0]->value[3] = 0x7f;

> +               break;
> +       case MLNX_START_RUMBLE: {
> +               const struct mlnx_rumble_force *rumble_force = &command->u.rumble_force;
> +               /* Scale down from MLNX range */
> +               const unsigned int right = rumble_force->weak * 0xff / 0xffff;
> +               const unsigned int left = rumble_force->strong * 0xff / 0xffff;
>
> -       case FF_RUMBLE:
> -               right = effect->u.rumble.strong_magnitude;
> -               left = effect->u.rumble.weak_magnitude;
> -               right = right * 0xff / 0xffff;
> -               left = left * 0xff / 0xffff;
> -               CLAMP(left);
> -               CLAMP(right);
>                 report->field[0]->value[0] = 0x42;
>                 report->field[0]->value[1] = 0x00;
>                 report->field[0]->value[2] = left;
>                 report->field[0]->value[3] = right;
>                 dbg_hid("(left, right)=(%04x, %04x)\n", left, right);
> -               hid_hw_request(hid, report, HID_REQ_SET_REPORT);
>                 break;
>         }
> +       case MLNX_STOP_RUMBLE:
> +               report->field[0]->value[0] = 0x42;
> +               report->field[0]->value[1] = 0x00;
> +               report->field[0]->value[2] = 0;
> +               report->field[0]->value[3] = 0;
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       hid_hw_request(hid, report, HID_REQ_SET_REPORT);
> +
>         return 0;
>  }
>
> @@ -148,7 +171,7 @@ int lgff_init(struct hid_device* hid)
>         for (i = 0; ff_bits[i] >= 0; i++)
>                 set_bit(ff_bits[i], dev->ffbit);
>
> -       error = input_ff_create_memless(dev, NULL, hid_lgff_play);
> +       error = input_ff_create_mlnx(dev, NULL, hid_lgff_play, FF_UPDATE_RATE);
>         if (error)
>                 return error;
>
> --
> 1.9.1
>
>

These comments might fix the weird behaviour (when effects stopped
playing) Simon saw when testing the patchset with his Logitech Wingman
Force 3D.


Elias
