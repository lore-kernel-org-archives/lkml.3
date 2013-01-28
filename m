Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751603Ab3A1PIr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:08:47 -0500
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:33065 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab3A1PIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:08:44 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtdHAJSTBlFV5qjOPGdsb2JhbABEin6zWhcDAQEBATg0gh4BAQQBOhwjBQsIAyElDwUNGAoaEx6HYQMJCrYGDYlVFYt7hDRhA5Q3gVWFe4NSgWqICg
X-IronPort-AV: E=Sophos;i="4.84,552,1355094000"; 
   d="scan'208";a="488905534"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 28 Jan 2013 16:13:57 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/25] HID: multitouch: make MT_CLS_ALWAYS_TRUE the new
 default class
Message-ID: <20130128151357.GA3476@polaris.bitmath.org>
References: <1359120190-18281-1-git-send-email-benjamin.tissoires@gmail.com>
 <1359120190-18281-26-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359120190-18281-26-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> By running a test on all the traces of the devices I have,
> I noticed that the class MT_CLS_ALWAYS_TRUE could handle all
> the devices I've seen so far without any other quirks.
> I guess this is the behavior Win 7 requires in its driver.
> 
> We can change the default class then and keep the existing classes
> for backward compatibility and performances for some of them.

Nice observation. A simpler route is to add new devices according the
new scheme, and leave the current code intact. Don't fix what ain't
broken.

> 
> Two operations have been done:
>  - replaced MT_CLS_DEFAULT by MT_CLS_NSMU
>  - then replaced MT_CLS_ALWAYS_TRUE by MT_CLS_DEFAULT
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/hid-multitouch.c | 53 ++++++++++++++++++++++----------------------
>  1 file changed, 27 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index e3f0bf7..25b1d2c 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -117,7 +117,7 @@ struct mt_device {
>  #define MT_CLS_DUAL_INRANGE_CONTACTID		0x0006
>  #define MT_CLS_DUAL_INRANGE_CONTACTNUMBER	0x0007
>  #define MT_CLS_INRANGE_CONTACTNUMBER		0x0009
> -#define MT_CLS_ALWAYS_TRUE			0x000a
> +#define MT_CLS_NSMU				0x000a
>  #define MT_CLS_CONTACT_ID			0x0011
>  #define MT_CLS_MINUS_ONE			0x0012
>  #define MT_CLS_DUAL_CONTACT_ID			0x0013
> @@ -155,6 +155,9 @@ static int cypress_compute_slot(struct mt_device *td)
>  
>  static struct mt_class mt_classes[] = {
>  	{ .name = MT_CLS_DEFAULT,
> +		.quirks = MT_QUIRK_ALWAYS_VALID |
> +			MT_QUIRK_CONTACT_CNT_ACCURATE },
> +	{ .name = MT_CLS_NSMU,
>  		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP },
>  	{ .name = MT_CLS_SERIAL,
>  		.quirks = MT_QUIRK_ALWAYS_VALID},
> @@ -177,9 +180,7 @@ static struct mt_class mt_classes[] = {
>  	{ .name = MT_CLS_INRANGE_CONTACTNUMBER,
>  		.quirks = MT_QUIRK_VALID_IS_INRANGE |
>  			MT_QUIRK_SLOT_IS_CONTACTNUMBER },
> -	{ .name = MT_CLS_ALWAYS_TRUE,
> -		.quirks = MT_QUIRK_ALWAYS_VALID |
> -			MT_QUIRK_CONTACT_CNT_ACCURATE },
> +
>  	{ .name = MT_CLS_CONTACT_ID,
>  		.quirks = MT_QUIRK_ALWAYS_VALID |
>  			MT_QUIRK_CONTACT_CNT_ACCURATE |
> @@ -963,7 +964,7 @@ static const struct hid_device_id mt_devices[] = {
>  			USB_DEVICE_ID_ATMEL_MXT_DIGITIZER) },
>  
>  	/* Baanto multitouch devices */
> -	{ .driver_data = MT_CLS_DEFAULT,
> +	{ .driver_data = MT_CLS_NSMU,
>  		MT_USB_DEVICE(USB_VENDOR_ID_BAANTO,
>  			USB_DEVICE_ID_BAANTO_MT_190W2) },
>  	/* Cando panels */
> @@ -981,12 +982,12 @@ static const struct hid_device_id mt_devices[] = {
>  			USB_DEVICE_ID_CANDO_MULTI_TOUCH_15_6) },
>  
>  	/* Chunghwa Telecom touch panels */
> -	{  .driver_data = MT_CLS_DEFAULT,
> +	{  .driver_data = MT_CLS_NSMU,
>  		MT_USB_DEVICE(USB_VENDOR_ID_CHUNGHWAT,
>  			USB_DEVICE_ID_CHUNGHWAT_MULTITOUCH) },
>  
>  	/* CVTouch panels */
> -	{ .driver_data = MT_CLS_DEFAULT,
> +	{ .driver_data = MT_CLS_NSMU,
>  		MT_USB_DEVICE(USB_VENDOR_ID_CVTOUCH,
>  			USB_DEVICE_ID_CVTOUCH_SCREEN) },
>  
> @@ -1075,12 +1076,12 @@ static const struct hid_device_id mt_devices[] = {
>  			USB_DEVICE_ID_GENERAL_TOUCH_WIN8_PWT_TENFINGERS) },
>  
>  	/* Gametel game controller */
> -	{ .driver_data = MT_CLS_DEFAULT,
> +	{ .driver_data = MT_CLS_NSMU,
>  		MT_BT_DEVICE(USB_VENDOR_ID_FRUCTEL,
>  			USB_DEVICE_ID_GAMETEL_MT_MODE) },
>  
>  	/* GoodTouch panels */
> -	{ .driver_data = MT_CLS_DEFAULT,
> +	{ .driver_data = MT_CLS_NSMU,
>  		MT_USB_DEVICE(USB_VENDOR_ID_GOODTOUCH,
>  			USB_DEVICE_ID_GOODTOUCH_000f) },
>  
> @@ -1098,7 +1099,7 @@ static const struct hid_device_id mt_devices[] = {
>  			USB_DEVICE_ID_IDEACOM_IDC6651) },
>  
>  	/* Ilitek dual touch panel */
> -	{  .driver_data = MT_CLS_DEFAULT,
> +	{  .driver_data = MT_CLS_NSMU,
>  		MT_USB_DEVICE(USB_VENDOR_ID_ILITEK,
>  			USB_DEVICE_ID_ILITEK_MULTITOUCH) },
>  
> @@ -1145,7 +1146,7 @@ static const struct hid_device_id mt_devices[] = {
>  			USB_DEVICE_ID_PANABOARD_UBT880) },
>  
>  	/* Novatek Panel */
> -	{ .driver_data = MT_CLS_DEFAULT,
> +	{ .driver_data = MT_CLS_NSMU,
>  		MT_USB_DEVICE(USB_VENDOR_ID_NOVATEK,
>  			USB_DEVICE_ID_NOVATEK_PCT) },
>  
> @@ -1185,13 +1186,13 @@ static const struct hid_device_id mt_devices[] = {
>  			USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3008) },
>  
>  	/* Stantum panels */
> -	{ .driver_data = MT_CLS_ALWAYS_TRUE,
> +	{ .driver_data = MT_CLS_DEFAULT,
>  		MT_USB_DEVICE(USB_VENDOR_ID_STANTUM,
>  			USB_DEVICE_ID_MTP)},
>  	{ .driver_data = MT_CLS_CONFIDENCE,
>  		MT_USB_DEVICE(USB_VENDOR_ID_STANTUM_STM,
>  			USB_DEVICE_ID_MTP_STM)},
> -	{ .driver_data = MT_CLS_ALWAYS_TRUE,
> +	{ .driver_data = MT_CLS_DEFAULT,
>  		MT_USB_DEVICE(USB_VENDOR_ID_STANTUM_SITRONIX,
>  			USB_DEVICE_ID_MTP_SITRONIX)},
>  
> @@ -1201,48 +1202,48 @@ static const struct hid_device_id mt_devices[] = {
>  			USB_DEVICE_ID_TOPSEED2_PERIPAD_701) },
>  
>  	/* Touch International panels */
> -	{ .driver_data = MT_CLS_DEFAULT,
> +	{ .driver_data = MT_CLS_NSMU,
>  		MT_USB_DEVICE(USB_VENDOR_ID_TOUCH_INTL,
>  			USB_DEVICE_ID_TOUCH_INTL_MULTI_TOUCH) },
>  
>  	/* Unitec panels */
> -	{ .driver_data = MT_CLS_DEFAULT,
> +	{ .driver_data = MT_CLS_NSMU,
>  		MT_USB_DEVICE(USB_VENDOR_ID_UNITEC,
>  			USB_DEVICE_ID_UNITEC_USB_TOUCH_0709) },
> -	{ .driver_data = MT_CLS_DEFAULT,
> +	{ .driver_data = MT_CLS_NSMU,
>  		MT_USB_DEVICE(USB_VENDOR_ID_UNITEC,
>  			USB_DEVICE_ID_UNITEC_USB_TOUCH_0A19) },
>  	/* XAT */
> -	{ .driver_data = MT_CLS_DEFAULT,
> +	{ .driver_data = MT_CLS_NSMU,
>  		MT_USB_DEVICE(USB_VENDOR_ID_XAT,
>  			USB_DEVICE_ID_XAT_CSR) },
>  
>  	/* Xiroku */
> -	{ .driver_data = MT_CLS_DEFAULT,
> +	{ .driver_data = MT_CLS_NSMU,
>  		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
>  			USB_DEVICE_ID_XIROKU_SPX) },
> -	{ .driver_data = MT_CLS_DEFAULT,
> +	{ .driver_data = MT_CLS_NSMU,
>  		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
>  			USB_DEVICE_ID_XIROKU_MPX) },
> -	{ .driver_data = MT_CLS_DEFAULT,
> +	{ .driver_data = MT_CLS_NSMU,
>  		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
>  			USB_DEVICE_ID_XIROKU_CSR) },
> -	{ .driver_data = MT_CLS_DEFAULT,
> +	{ .driver_data = MT_CLS_NSMU,
>  		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
>  			USB_DEVICE_ID_XIROKU_SPX1) },
> -	{ .driver_data = MT_CLS_DEFAULT,
> +	{ .driver_data = MT_CLS_NSMU,
>  		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
>  			USB_DEVICE_ID_XIROKU_MPX1) },
> -	{ .driver_data = MT_CLS_DEFAULT,
> +	{ .driver_data = MT_CLS_NSMU,
>  		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
>  			USB_DEVICE_ID_XIROKU_CSR1) },
> -	{ .driver_data = MT_CLS_DEFAULT,
> +	{ .driver_data = MT_CLS_NSMU,
>  		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
>  			USB_DEVICE_ID_XIROKU_SPX2) },
> -	{ .driver_data = MT_CLS_DEFAULT,
> +	{ .driver_data = MT_CLS_NSMU,
>  		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
>  			USB_DEVICE_ID_XIROKU_MPX2) },
> -	{ .driver_data = MT_CLS_DEFAULT,
> +	{ .driver_data = MT_CLS_NSMU,
>  		MT_USB_DEVICE(USB_VENDOR_ID_XIROKU,
>  			USB_DEVICE_ID_XIROKU_CSR2) },
>  
> -- 
> 1.8.1
> 

Thanks,
Henrik
