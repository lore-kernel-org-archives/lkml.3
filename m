Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab3BCMyT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 07:54:19 -0500
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:42272 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab3BCMyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 07:54:17 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiJlABldDlFV5qjOPGdsb2JhbABEhV+FILMvBIEAFwMBAQEBODSCHwEBBAEnExwjBQsIAyElDwUNGAoaExuHZAMJCrUeDYlWFYwIgS6DJmEDlEeBV4YAhUCID4FlAh4EAg
X-IronPort-AV: E=Sophos;i="4.84,594,1355094000"; 
   d="scan'208";a="275328507"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sun, 3 Feb 2013 14:00:13 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/9] HID: multitouch: add support for Nexio 42" panel
Message-ID: <20130203130013.GA2657@polaris.bitmath.org>
References: <1359649351-11092-1-git-send-email-benjamin.tissoires@gmail.com>
 <1359649351-11092-4-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359649351-11092-4-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> This device is the worst device I saw. It keeps TipSwitch and InRange
> at 1 for fingers that are not touching the panel.
> The solution is to rely on the field ContactCount, which is accurate
> as the correct information are packed at the begining of the frame.
> 
> Unfortunately, CountactCount is most of the time at the end of the report.
> The solution is to pick it when we have the whole report in raw_event.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
> ---
>  drivers/hid/hid-ids.h        |  3 +++
>  drivers/hid/hid-multitouch.c | 36 ++++++++++++++++++++++++++++++------
>  2 files changed, 33 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index dad56aa..0935012 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -597,6 +597,9 @@
>  #define USB_VENDOR_ID_NEC		0x073e
>  #define USB_DEVICE_ID_NEC_USB_GAME_PAD	0x0301
>  
> +#define USB_VENDOR_ID_NEXIO		0x1870
> +#define USB_DEVICE_ID_NEXIO_MULTITOUCH_420	0x010d
> +
>  #define USB_VENDOR_ID_NEXTWINDOW	0x1926
>  #define USB_DEVICE_ID_NEXTWINDOW_TOUCHSCREEN	0x0003
>  
> diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
> index 092c09b..c9b8fe5 100644
> --- a/drivers/hid/hid-multitouch.c
> +++ b/drivers/hid/hid-multitouch.c
> @@ -54,6 +54,7 @@ MODULE_LICENSE("GPL");
>  #define MT_QUIRK_NO_AREA		(1 << 9)
>  #define MT_QUIRK_IGNORE_DUPLICATES	(1 << 10)
>  #define MT_QUIRK_HOVERING		(1 << 11)
> +#define MT_QUIRK_CONTACT_CNT_ACCURATE	(1 << 12)
>  
>  struct mt_slot {
>  	__s32 x, y, cx, cy, p, w, h;
> @@ -83,6 +84,7 @@ struct mt_device {
>  	struct mt_class mtclass;	/* our mt device class */
>  	struct mt_fields *fields;	/* temporary placeholder for storing the
>  					   multitouch fields */
> +	__s32 *contactcount;		/* contact count value in the report */

Why not an index here?

>  	unsigned last_field_index;	/* last field index of the report */
>  	unsigned last_slot_field;	/* the last field of a slot */
>  	unsigned mt_report_id;	/* the report ID of the multitouch device */
> @@ -112,6 +114,7 @@ struct mt_device {
>  #define MT_CLS_DUAL_INRANGE_CONTACTNUMBER	0x0007
>  #define MT_CLS_DUAL_NSMU_CONTACTID		0x0008
>  #define MT_CLS_INRANGE_CONTACTNUMBER		0x0009
> +#define MT_CLS_ALWAYS_TRUE			0x000a
>  
>  /* vendor specific classes */
>  #define MT_CLS_3M				0x0101
> @@ -171,6 +174,9 @@ static struct mt_class mt_classes[] = {
>  	{ .name = MT_CLS_INRANGE_CONTACTNUMBER,
>  		.quirks = MT_QUIRK_VALID_IS_INRANGE |
>  			MT_QUIRK_SLOT_IS_CONTACTNUMBER },
> +	{ .name = MT_CLS_ALWAYS_TRUE,
> +		.quirks = MT_QUIRK_ALWAYS_VALID |
> +			MT_QUIRK_CONTACT_CNT_ACCURATE },
>  
>  	/*
>  	 * vendor specific classes
> @@ -251,6 +257,9 @@ static ssize_t mt_set_quirks(struct device *dev,
>  
>  	td->mtclass.quirks = val;
>  
> +	if (!td->contactcount)
> +		td->mtclass.quirks &= ~MT_QUIRK_CONTACT_CNT_ACCURATE;
> +

Why override the overrider here?

>  	return count;
>  }
>  
> @@ -461,6 +470,7 @@ static int mt_input_mapping(struct hid_device *hdev, struct hid_input *hi,
>  			td->last_field_index = field->index;
>  			return 1;
>  		case HID_DG_CONTACTCOUNT:
> +			td->contactcount = field->value + usage->usage_index;

An index into the the struct actually passed in mt_report() feels safer.

>  			td->last_field_index = field->index;
>  			return 1;
>  		case HID_DG_CONTACTMAX:
> @@ -525,6 +535,10 @@ static int mt_compute_slot(struct mt_device *td, struct input_dev *input)
>   */
>  static void mt_complete_slot(struct mt_device *td, struct input_dev *input)
>  {
> +	if ((td->mtclass.quirks & MT_QUIRK_CONTACT_CNT_ACCURATE) &&
> +	    td->num_received >= td->num_expected)
> +		return;
> +
>  	if (td->curvalid || (td->mtclass.quirks & MT_QUIRK_ALWAYS_VALID)) {
>  		int slotnum = mt_compute_slot(td, input);
>  		struct mt_slot *s = &td->curdata;
> @@ -635,12 +649,6 @@ static void mt_process_mt_event(struct hid_device *hid, struct hid_field *field,
>  			td->curdata.h = value;
>  			break;
>  		case HID_DG_CONTACTCOUNT:
> -			/*
> -			 * Includes multi-packet support where subsequent
> -			 * packets are sent with zero contactcount.
> -			 */
> -			if (value)
> -				td->num_expected = value;
>  			break;
>  		case HID_DG_TOUCH:
>  			/* do nothing */
> @@ -676,6 +684,13 @@ static void mt_report(struct hid_device *hid, struct hid_report *report)
>  	if (!(hid->claimed & HID_CLAIMED_INPUT))
>  		return;
>  
> +	/*
> +	 * Includes multi-packet support where subsequent
> +	 * packets are sent with zero contactcount.
> +	 */
> +	if (td->contactcount && *td->contactcount)
> +		td->num_expected = *td->contactcount;
> +

Here, that is.

>  	for (r = 0; r < report->maxfield; r++) {
>  		field = report->field[r];
>  		count = field->report_count;
> @@ -750,11 +765,15 @@ static void mt_post_parse_default_settings(struct mt_device *td)
>  static void mt_post_parse(struct mt_device *td)
>  {
>  	struct mt_fields *f = td->fields;
> +	struct mt_class *cls = &td->mtclass;
>  
>  	if (td->touches_by_report > 0) {
>  		int field_count_per_touch = f->length / td->touches_by_report;
>  		td->last_slot_field = f->usages[field_count_per_touch - 1];
>  	}
> +
> +	if (!td->contactcount)
> +		cls->quirks &= ~MT_QUIRK_CONTACT_CNT_ACCURATE;

Since MT_QUIRK_CONTACT_CNT_ACCURATE is a quirk, modifiable by the
user, it should probably not validate num_expected in the code. Better
use the contact count index or something equivalent for that.

>  }
>  
>  static void mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
> @@ -1087,6 +1106,11 @@ static const struct hid_device_id mt_devices[] = {
>  		MT_USB_DEVICE(USB_VENDOR_ID_TURBOX,
>  			USB_DEVICE_ID_TURBOX_TOUCHSCREEN_MOSART) },
>  
> +	/* Nexio panels */
> +	{ .driver_data = MT_CLS_ALWAYS_TRUE,
> +		MT_USB_DEVICE(USB_VENDOR_ID_NEXIO,
> +			USB_DEVICE_ID_NEXIO_MULTITOUCH_420)},
> +
>  	/* Panasonic panels */
>  	{ .driver_data = MT_CLS_PANASONIC,
>  		MT_USB_DEVICE(USB_VENDOR_ID_PANASONIC,
> -- 
> 1.8.1
> 

Thanks,
Henrik
