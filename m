Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbaGNKTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:19:50 -0400
Received: from smtp209.alice.it ([82.57.200.105]:42074 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754898AbaGNKTi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:19:38 -0400
Date: Mon, 14 Jul 2014 12:19:19 +0200
From: Antonio Ospite <ao2@ao2.it>
To: Jamie Lentin <jm@lentin.co.uk>
Cc: Jiri Kosina <jkosina@suse.cz>, Hans de Goede <hdegoede@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/4] Make all base functions switch depending on
 product ID
Message-Id: <20140714121919.e9fedb18df02e174e439e16f@ao2.it>
In-Reply-To: <1405236262-8070-3-git-send-email-jm@lentin.co.uk>
References: <1405236262-8070-1-git-send-email-jm@lentin.co.uk>
	<1405236262-8070-3-git-send-email-jm@lentin.co.uk>
X-Mailer: Sylpheed 3.5.0beta1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2014 08:24:20 +0100
Jamie Lentin <jm@lentin.co.uk> wrote:

> Signed-off-by: Jamie Lentin <jm@lentin.co.uk>

The commit message could be improved, it's not obvious to me what "base
functions" means here, I am thinking to something like the following:

---------------------------------------------------------------------
HID: lenovo: prepare support for adding other devices

Add a common lenovo_input_mapping(), and call device specific functions
conditionally in order to ease the task of adding support for other
devices.
---------------------------------------------------------------------

This way you explain the WHAT and WHY and point that this is a
_preparatory_ patch, the HOW is explained by the code anyway.

> ---
>  drivers/hid/hid-lenovo.c | 45 ++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 38 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/hid/hid-lenovo.c b/drivers/hid/hid-lenovo.c
> index 0320b96..d11e337 100644
> --- a/drivers/hid/hid-lenovo.c
> +++ b/drivers/hid/hid-lenovo.c
> @@ -1,5 +1,6 @@
>  /*
> - *  HID driver for Lenovo ThinkPad USB Keyboard with TrackPoint
> + *  HID driver for Lenovo:
> + *  - ThinkPad USB Keyboard with TrackPoint (tpkbd)
>   *
>   *  Copyright (c) 2012 Bernhard Seibold
>   */
> @@ -47,6 +48,19 @@ static int lenovo_input_mapping_tpkbd(struct hid_device *hdev,
>  	return 0;
>  }
>  
> +static int lenovo_input_mapping(struct hid_device *hdev,
> +		struct hid_input *hi, struct hid_field *field,
> +		struct hid_usage *usage, unsigned long **bit, int *max)
> +{
> +	switch (hdev->product) {
> +	case USB_DEVICE_ID_LENOVO_TPKBD:
> +		return lenovo_input_mapping_tpkbd(hdev, hi, field,
> +							usage, bit, max);
> +	}
> +
> +	return 0;
> +}
> +
>  #undef map_key_clear
>  
>  static int lenovo_features_set_tpkbd(struct hid_device *hdev)
> @@ -337,6 +351,16 @@ static int lenovo_probe_tpkbd(struct hid_device *hdev)
>  	char *name_mute, *name_micmute;
>  	int i;
>  
> +	/*
> +	 * If this is the pointer half of the keyboard, input_mapping should

s/pointer/trackpoint/ ? ;)

> +	 * have set drvdata to 1. Otherwise, it's the keyboard which needs
> +	 * nothing special doing to it.
> +	 */
> +	if (!hid_get_drvdata(hdev))
> +		return 0;
> +
> +	hid_set_drvdata(hdev, NULL);
> +
>  	/* Validate required reports. */
>  	for (i = 0; i < 4; i++) {
>  		if (!hid_validate_values(hdev, HID_FEATURE_REPORT, 4, i, 1))
> @@ -409,12 +433,13 @@ static int lenovo_probe(struct hid_device *hdev,
>  		goto err;
>  	}
>  
> -	if (hid_get_drvdata(hdev)) {
> -		hid_set_drvdata(hdev, NULL);
> +	switch (hdev->product) {
> +	case USB_DEVICE_ID_LENOVO_TPKBD:
>  		ret = lenovo_probe_tpkbd(hdev);
> -		if (ret)
> -			goto err_hid;
> +		break;
>  	}
> +	if (ret)
> +		goto err_hid;
>  

It is not immediately clear what this "ret" contains; the code seems to
be correct because if "ret" contains the previous return value of
hid_hw_start() it's from a successful invocation, but it took me some
reasoning to figure it out.

I'd leave the check right after the call to lenovo_probe_tpkbd(), and
repeat it when you add the other case it's slightly more code but it's
way more readable, it does not force you to remember the past or reason
on the switch logic when you read the code.

Anyhow, if you really want to have only one check after the switch, what
about adding a default case to the former switch:

	default:
		ret = 0;
		break;

Having always the default case is also a good practice IMVHO, consider
adding it to the other switch statements too.

>  	return 0;
>  err_hid:
> @@ -430,6 +455,9 @@ static void lenovo_remove_tpkbd(struct hid_device *hdev)
>  	sysfs_remove_group(&hdev->dev.kobj,
>  			&lenovo_attr_group_tpkbd);
>  
> +	if (data_pointer == NULL)
> +		return;
> +

This is OK here, as sysfs_remove_group() is safe to call
unconditionally (it will give warnings where there are no groups
AFAICS), but it could also go at the very start of lenovo_remove_tpkbd
(). It would be more symmetrical because you create the sysfs entries
only for the trackpoint half in the probe function. Maybe add a comment
like the useful one in the probe function.

>  	led_classdev_unregister(&data_pointer->led_micmute);
>  	led_classdev_unregister(&data_pointer->led_mute);
>  
> @@ -438,8 +466,11 @@ static void lenovo_remove_tpkbd(struct hid_device *hdev)
>  
>  static void lenovo_remove(struct hid_device *hdev)
>  {
> -	if (hid_get_drvdata(hdev))
> +	switch (hdev->product) {
> +	case USB_DEVICE_ID_LENOVO_TPKBD:
>  		lenovo_remove_tpkbd(hdev);
> +		break;
> +	}
>  
>  	hid_hw_stop(hdev);
>  }
> @@ -454,7 +485,7 @@ MODULE_DEVICE_TABLE(hid, lenovo_devices);
>  static struct hid_driver lenovo_driver = {
>  	.name = "lenovo",
>  	.id_table = lenovo_devices,
> -	.input_mapping = lenovo_input_mapping_tpkbd,
> +	.input_mapping = lenovo_input_mapping,
>  	.probe = lenovo_probe,
>  	.remove = lenovo_remove,
>  };
> -- 
> 2.0.0
> 
> 


-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
