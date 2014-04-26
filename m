Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaDZNPM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 09:15:12 -0400
Received: from smtp205.alice.it ([82.57.200.101]:49365 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbaDZNPK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 09:15:10 -0400
Date: Sat, 26 Apr 2014 15:09:44 +0200
From: Antonio Ospite <ao2@ao2.it>
To: Michal =?ISO-8859-1?Q?Mal=FD?= <madcatxster@devoid-pointer.net>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
Subject: Re: [PATCH v3 16/24] hid: Port hid-sony to ff-memless-next
Message-Id: <20140426150944.b119fd7f8c4334353b77d3d2@ao2.it>
In-Reply-To: <1398513696-12626-17-git-send-email-madcatxster@devoid-pointer.net>
References: <1398513696-12626-1-git-send-email-madcatxster@devoid-pointer.net>
	<1398513696-12626-17-git-send-email-madcatxster@devoid-pointer.net>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Apr 2014 13:57:53 +0200
Michal Malý <madcatxster@devoid-pointer.net> wrote:

> Port hid-sony to ff-memless-next
> 
> Signed-off-by: Michal Malý <madcatxster@devoid-pointer.net>

Not a big deal, but note that the patch adds an unneeded
blank line. Pointed out below.

> ---
>  drivers/hid/Kconfig    |  2 +-
>  drivers/hid/hid-sony.c | 24 ++++++++++++++++++------
>  2 files changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index 9260d14..e97c382 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -634,7 +634,7 @@ config HID_SONY
>  config SONY_FF
>  	bool "Sony PS2/3/4 accessories force feedback support" 
>  	depends on HID_SONY
> -	select INPUT_FF_MEMLESS
> +	select INPUT_FF_MEMLESS_NEXT
>  	---help---
>  	Say Y here if you have a Sony PS2/3/4 accessory and want to enable
>  	force feedback support for it.
> diff --git a/drivers/hid/hid-sony.c b/drivers/hid/hid-sony.c
> index 908de27..95bb2e1 100644
> --- a/drivers/hid/hid-sony.c
> +++ b/drivers/hid/hid-sony.c
> @@ -34,6 +34,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/list.h>
>  #include <linux/input/mt.h>
> +#include <linux/input/ff-memless-next.h>
>  
>  #include "hid-ids.h"
>  
> @@ -53,6 +54,7 @@
>  #define SONY_BATTERY_SUPPORT (SIXAXIS_CONTROLLER | DUALSHOCK4_CONTROLLER)
>  #define SONY_FF_SUPPORT (SIXAXIS_CONTROLLER | DUALSHOCK4_CONTROLLER)
>  
> +#define FF_UPDATE_RATE 50
>  #define MAX_LEDS 4
>  
>  static const u8 sixaxis_rdesc_fixup[] = {
> @@ -1308,16 +1310,25 @@ static void dualshock4_state_worker(struct work_struct *work)
>  
>  #ifdef CONFIG_SONY_FF
>  static int sony_play_effect(struct input_dev *dev, void *data,
> -			    struct ff_effect *effect)
> +			    const struct mlnx_effect_command *command)
>  {
>  	struct hid_device *hid = input_get_drvdata(dev);
>  	struct sony_sc *sc = hid_get_drvdata(hid);
> +	const struct mlnx_rumble_force *rumble_force = &command->u.rumble_force;
>  
> -	if (effect->type != FF_RUMBLE)
> -		return 0;
>  
> -	sc->left = effect->u.rumble.strong_magnitude / 256;
> -	sc->right = effect->u.rumble.weak_magnitude / 256;
> +	switch (command->cmd) {
> +	case MLNX_START_RUMBLE:
> +		sc->left = rumble_force->strong / 256;
> +		sc->right = rumble_force->weak / 256;
> +		break;
> +	case MLNX_STOP_RUMBLE:
> +		sc->left = 0;
> +		sc->right = 0;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
>  
>  	schedule_work(&sc->state_worker);
>  	return 0;
> @@ -1330,7 +1341,7 @@ static int sony_init_ff(struct hid_device *hdev)
>  	struct input_dev *input_dev = hidinput->input;
>  
>  	input_set_capability(input_dev, EV_FF, FF_RUMBLE);
> -	return input_ff_create_memless(input_dev, NULL, sony_play_effect);
> +	return input_ff_create_mlnx(input_dev, NULL, sony_play_effect, FF_UPDATE_RATE);
>  }
>  
>  #else
> @@ -1762,6 +1773,7 @@ static const struct hid_device_id sony_devices[] = {
>  		.driver_data = DUALSHOCK4_CONTROLLER_USB },
>  	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_SONY, USB_DEVICE_ID_SONY_PS4_CONTROLLER),
>  		.driver_data = DUALSHOCK4_CONTROLLER_BT },
> +

Extra blank line here.

>  	{ }
>  };
>  MODULE_DEVICE_TABLE(hid, sony_devices);
> -- 
> 1.9.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
