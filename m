Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbaFKHlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 03:41:36 -0400
Received: from smtp205.alice.it ([82.57.200.101]:1524 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbaFKHle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 03:41:34 -0400
Date: Wed, 11 Jun 2014 09:41:18 +0200
From: Antonio Ospite <ao2@ao2.it>
To: Jamie Lentin <jm@lentin.co.uk>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] Loosen seams to allow support of other keyboards
Message-Id: <20140611094118.5b057b389e639cfb7c46785b@ao2.it>
In-Reply-To: <1402439094-25464-2-git-send-email-jm@lentin.co.uk>
References: <1402439094-25464-1-git-send-email-jm@lentin.co.uk>
	<1402439094-25464-2-git-send-email-jm@lentin.co.uk>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jamie,

some few ideas in case there will be a v3, most of them are really just
nitpicks.

On Tue, 10 Jun 2014 23:24:53 +0100
Jamie Lentin <jm@lentin.co.uk> wrote:

> Signed-off-by: Jamie Lentin <jm@lentin.co.uk>
> ---
>  drivers/hid/hid-lenovo-tpkbd.c | 33 ++++++++++++++++++++++++---------
>  1 file changed, 24 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/hid/hid-lenovo-tpkbd.c b/drivers/hid/hid-lenovo-tpkbd.c
> index 2d25b6c..3bec9f5 100644
> --- a/drivers/hid/hid-lenovo-tpkbd.c
> +++ b/drivers/hid/hid-lenovo-tpkbd.c
> @@ -1,5 +1,6 @@
>  /*
> - *  HID driver for Lenovo ThinkPad USB Keyboard with TrackPoint
> + *  HID driver for Lenovo:-
> + *  * ThinkPad USB Keyboard with TrackPoint
>   *

Remove the - after the : and use the - as the bullet.
The asterisk is used for the comment already.

>   *  Copyright (c) 2012 Bernhard Seibold
>   */
> @@ -35,7 +36,7 @@ struct tpkbd_data_pointer {
>  
>  #define map_key_clear(c) hid_map_usage_clear(hi, usage, bit, max, EV_KEY, (c))
>  
> -static int tpkbd_input_mapping(struct hid_device *hdev,
> +static int tpkbd_input_mapping_tp(struct hid_device *hdev,
>  		struct hid_input *hi, struct hid_field *field,
>  		struct hid_usage *usage, unsigned long **bit, int *max)
>  {
> @@ -48,6 +49,15 @@ static int tpkbd_input_mapping(struct hid_device *hdev,
>  	return 0;
>  }
>  
> +static int tpkbd_input_mapping(struct hid_device *hdev,
> +		struct hid_input *hi, struct hid_field *field,
> +		struct hid_usage *usage, unsigned long **bit, int *max)
> +{
> +	if (hdev->product == USB_DEVICE_ID_LENOVO_TPKBD)
> +		return tpkbd_input_mapping_tp(hdev, hi, field, usage, bit, max);
> +	return 0;
> +}
> +
>  #undef map_key_clear
>  
>  static int tpkbd_features_set(struct hid_device *hdev)
> @@ -338,6 +348,11 @@ static int tpkbd_probe_tp(struct hid_device *hdev)
>  	char *name_mute, *name_micmute;
>  	int i;
>  
> +	/* Ignore unless tpkbd_input_mapping_tp marked it as a pointer */
> +	if (!hid_get_drvdata(hdev))
> +		return 0;
> +	hid_set_drvdata(hdev, NULL);
> +

Maybe add a blank line before hid_set_drvdata().

JFTR this logic, already in the original code, relies on the fact that
the input_mapping callback is invoked before tpkbd_probe_tp():

	hid_hw_start()
		hid_connect()
			hidinput_connect()
				hidinput_configure_usage()
					device->driver->input_mapping()
	tpkbd_probe_tp()

which was not completely trivial to an occasional reader like me.

>  	/* Validate required reports. */
>  	for (i = 0; i < 4; i++) {
>  		if (!hid_validate_values(hdev, HID_FEATURE_REPORT, 4, i, 1))
> @@ -408,12 +423,9 @@ static int tpkbd_probe(struct hid_device *hdev,
>  		goto err;
>  	}
>  
> -	if (hid_get_drvdata(hdev)) {
> -		hid_set_drvdata(hdev, NULL);
> -		ret = tpkbd_probe_tp(hdev);
> -		if (ret)
> -			goto err_hid;
> -	}
> +	if (hdev->product == USB_DEVICE_ID_LENOVO_TPKBD
> +			&& tpkbd_probe_tp(hdev))
> +		goto err_hid;
>

I'd avoid calling functions in conditions, especially when mixed with
other checks, but that's mostly personal taste. If you decide to call
the function in the if body you also get that the hdev->product check
will be exactly the same as in the symmetric one in tpkbd_remove().

>  	return 0;
>  err_hid:
> @@ -437,7 +449,10 @@ static void tpkbd_remove_tp(struct hid_device *hdev)
>  
>  static void tpkbd_remove(struct hid_device *hdev)
>  {
> -	if (hid_get_drvdata(hdev))
> +	if (!hid_get_drvdata(hdev))
> +		return;
> +

I think this check can just become a:

	if (data_pointer == NULL)
		return;

early in tpkbd_remove_tp().

Also, I don't think you could just return in tpkbd_remove() like
you are doing as hid_hw_stop() must be always called.

> +	if (hdev->product == USB_DEVICE_ID_LENOVO_TPKBD)
>  		tpkbd_remove_tp(hdev);
>  
>  	hid_hw_stop(hdev);
> -- 
> 2.0.0.rc2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Ciao Ciao,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
