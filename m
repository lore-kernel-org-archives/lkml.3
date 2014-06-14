Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289AbaFNA3A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 20:29:00 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:46395 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbaFNA26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 20:28:58 -0400
MIME-Version: 1.0
In-Reply-To: <1402691372-26282-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1402691372-26282-1-git-send-email-benjamin.tissoires@redhat.com>
Date: Fri, 13 Jun 2014 17:28:56 -0700
Message-ID: <CAF8JNhKBodDC0=M0evsN4xSn7+qPvQZ52XF+mfusgT_1L3Ks8w@mail.gmail.com>
Subject: Re: [PATCH] Input - wacom: put a flag when the led are initialized
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

Hi Benjamin,

On Fri, Jun 13, 2014 at 1:29 PM, Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
> This solves a bug with the wireless receiver:

Your patch does get rid of the crash. But, it does not fix it at the
root cause.

> - at plug, the wireless receiver does not know which Wacom device it is
>   connected to, so it does not actually creates all the LEDs

This is the root cause - LEDs are not created for wireless devices.
Neither here, nor later when a real device is connected.

> - when the tablet connects, wacom->wacom_wac.features.type is set to the
>   proper device so that wacom_wac can understand the packets

LEDs are not created for any wireless devices since we don't call
wacom_initialize_leds() when real tablets are connected.

> - when the receiver is unplugged, it detects that a LED should have been
>   created (based on wacom->wacom_wac.features.type) and tries to remove
>   it: crash when removing the sysfs group.

When receiver is unplugged, it remembers the last tablet that
connected to it. If that tablet supports LEDs, wacom_destroy_leds() is
called. But, no LEDs were initialized. That's why it crashes.

> Side effect, we can now safely call several times wacom_destroy_leds().

led_initialized will never be true if we keep wacom_initialize_leds()
inside probe().

To make initialize_leds() and desctroy_leds() work for wireless
devices, we need to move them to wacom_wireless_work() where we know
what type of tablet is connected/disconnected.

> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Thank you for your support. But, sorry

NAKed-by: Ping Cheng <pingc@wacom.com>

Ping

> ---
>  drivers/input/tablet/wacom.h     | 1 +
>  drivers/input/tablet/wacom_sys.c | 6 ++++++
>  2 files changed, 7 insertions(+)
>
> diff --git a/drivers/input/tablet/wacom.h b/drivers/input/tablet/wacom.h
> index 70b1e71..f13ad31 100644
> --- a/drivers/input/tablet/wacom.h
> +++ b/drivers/input/tablet/wacom.h
> @@ -120,6 +120,7 @@ struct wacom {
>                 u8 hlv;       /* status led brightness button pressed (1..127) */
>                 u8 img_lum;   /* OLED matrix display brightness */
>         } led;
> +       bool led_initialized;
>         struct power_supply battery;
>  };
>
> diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
> index 94096fd..7087b33 100644
> --- a/drivers/input/tablet/wacom_sys.c
> +++ b/drivers/input/tablet/wacom_sys.c
> @@ -1016,12 +1016,18 @@ static int wacom_initialize_leds(struct wacom *wacom)
>                 return error;
>         }
>         wacom_led_control(wacom);
> +       wacom->led_initialized = true;
>
>         return 0;
>  }
>
>  static void wacom_destroy_leds(struct wacom *wacom)
>  {
> +       if (!wacom->led_initialized)
> +               return;
> +
> +       wacom->led_initialized = false;
> +
>         switch (wacom->wacom_wac.features.type) {
>         case INTUOS4S:
>         case INTUOS4:
> --
> 1.9.0
>
