Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbaFKIgk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:36:40 -0400
Received: from smtp206.alice.it ([82.57.200.102]:48613 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbaFKIgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:36:32 -0400
Date: Wed, 11 Jun 2014 10:36:16 +0200
From: Antonio Ospite <ao2@ao2.it>
To: Jamie Lentin <jm@lentin.co.uk>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] Add support for Compact (Bluetooth|USB) keyboard
 with Trackpoint
Message-Id: <20140611103616.79b40e7b0bbf3447837921fc@ao2.it>
In-Reply-To: <1402439094-25464-3-git-send-email-jm@lentin.co.uk>
References: <1402439094-25464-1-git-send-email-jm@lentin.co.uk>
	<1402439094-25464-3-git-send-email-jm@lentin.co.uk>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014 23:24:54 +0100
Jamie Lentin <jm@lentin.co.uk> wrote:

> Signed-off-by: Jamie Lentin <jm@lentin.co.uk>

Some minor comments here too.

> ---
>  drivers/hid/hid-core.c         |   2 +
>  drivers/hid/hid-ids.h          |   2 +
>  drivers/hid/hid-lenovo-tpkbd.c | 203 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/hid.h            |   1 +
>  4 files changed, 208 insertions(+)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 8a5384c..6591f4e 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1738,6 +1738,8 @@ static const struct hid_device_id hid_have_special_driver[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LCPOWER, USB_DEVICE_ID_LCPOWER_LC1000 ) },
>  #if IS_ENABLED(CONFIG_HID_LENOVO_TPKBD)
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_TPKBD) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_CUSBKBD) },
> +	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_CBTKBD) },
>  #endif
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_MX3000_RECEIVER) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, USB_DEVICE_ID_S510_RECEIVER) },
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 6e12cd0..1763a07 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -551,6 +551,8 @@
>  
>  #define USB_VENDOR_ID_LENOVO		0x17ef
>  #define USB_DEVICE_ID_LENOVO_TPKBD	0x6009
> +#define USB_DEVICE_ID_LENOVO_CUSBKBD	0x6047
> +#define USB_DEVICE_ID_LENOVO_CBTKBD		0x6048
>  
>  #define USB_VENDOR_ID_LG		0x1fd2
>  #define USB_DEVICE_ID_LG_MULTITOUCH	0x0064
> diff --git a/drivers/hid/hid-lenovo-tpkbd.c b/drivers/hid/hid-lenovo-tpkbd.c
> index 3bec9f5..1671e7a 100644
> --- a/drivers/hid/hid-lenovo-tpkbd.c
> +++ b/drivers/hid/hid-lenovo-tpkbd.c
> @@ -1,8 +1,11 @@
>  /*
>   *  HID driver for Lenovo:-
>   *  * ThinkPad USB Keyboard with TrackPoint
> + *  * ThinkPad Compact Bluetooth Keyboard with TrackPoint
> + *  * ThinkPad Compact USB Keyboard with TrackPoint

Use - as the bullet.

>   *
>   *  Copyright (c) 2012 Bernhard Seibold
> + *  Copyright (c) 2014 Jamie Lentin <jm@lentin.co.uk>
>   */
>  
>  /*
> @@ -34,6 +37,10 @@ struct tpkbd_data_pointer {
>  	int press_speed;
>  };
>  
> +struct tpcompactkbd_sc {
> +	unsigned int fn_lock;
> +};
> +
>  #define map_key_clear(c) hid_map_usage_clear(hi, usage, bit, max, EV_KEY, (c))
>  
>  static int tpkbd_input_mapping_tp(struct hid_device *hdev,
> @@ -49,17 +56,154 @@ static int tpkbd_input_mapping_tp(struct hid_device *hdev,
>  	return 0;
>  }
>  
> +static int tpcompactkbd_input_mapping(struct hid_device *hdev,

Maybe name these functions like tpkbd_input_mapping_compact()?

This way the namespace is more consistent, and follows the logic of
patch 1/2 more closely.

Use this scheme at least for functions which have a _tp() counterpart.

> +		struct hid_input *hi, struct hid_field *field,
> +		struct hid_usage *usage, unsigned long **bit, int *max)
> +{
> +	/* HID_UP_LNVENDOR = USB, HID_UP_MSVENDOR = BT */
> +	if ((usage->hid & HID_USAGE_PAGE) == HID_UP_MSVENDOR ||
> +	    (usage->hid & HID_USAGE_PAGE) == HID_UP_LNVENDOR) {
> +		set_bit(EV_REP, hi->input->evbit);
> +		switch (usage->hid & HID_USAGE) {
> +		case 0x00f1: /* Fn-F4: Mic mute */
> +			map_key_clear(KEY_MICMUTE);
> +			return 1;
> +		case 0x00f2: /* Fn-F5: Brightness down */
> +			map_key_clear(KEY_BRIGHTNESSDOWN);
> +			return 1;
> +		case 0x00f3: /* Fn-F6: Brightness up */
> +			map_key_clear(KEY_BRIGHTNESSUP);
> +			return 1;
> +		case 0x00f4: /* Fn-F7: External display (projector) */
> +			map_key_clear(KEY_SWITCHVIDEOMODE);
> +			return 1;
> +		case 0x00f5: /* Fn-F8: Wireless */
> +			map_key_clear(KEY_WLAN);
> +			return 1;
> +		case 0x00f6: /* Fn-F9: Control panel */
> +			map_key_clear(KEY_CONFIG);
> +			return 1;
> +		case 0x00f8: /* Fn-F11: View open applications (3 boxes) */
> +			map_key_clear(KEY_FN_F11);
> +			return 1;
> +		case 0x00fa: /* Fn-Esc: Fn-lock toggle */
> +			map_key_clear(KEY_FN_ESC);
> +			return 1;
> +		case 0x00fb: /* Fn-F12: Open My computer (6 boxes) USB-only */
> +			/* NB: This mapping is invented in raw_event below */
> +			map_key_clear(KEY_FILE);
> +			return 1;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  static int tpkbd_input_mapping(struct hid_device *hdev,
>  		struct hid_input *hi, struct hid_field *field,
>  		struct hid_usage *usage, unsigned long **bit, int *max)
>  {
>  	if (hdev->product == USB_DEVICE_ID_LENOVO_TPKBD)
>  		return tpkbd_input_mapping_tp(hdev, hi, field, usage, bit, max);
> +	if (hdev->product == USB_DEVICE_ID_LENOVO_CUSBKBD)
> +		return tpcompactkbd_input_mapping(hdev, hi, field, usage, bit, max);
> +	if (hdev->product == USB_DEVICE_ID_LENOVO_CBTKBD)

What about combining the checks?

	if (hdev->product == USB_DEVICE_ID_LENOVO_CUSBKBD ||
	    hdev->product == USB_DEVICE_ID_LENOVO_CBTKBD)

> +		return tpcompactkbd_input_mapping(hdev, hi, field, usage, bit, max);
>  	return 0;
>  }
>  
>  #undef map_key_clear
>  
> +/* Send a config command to the keyboard */
> +static int tpcompactkbd_send_cmd(struct hid_device *hdev,
> +			unsigned char byte2, unsigned char byte3)
> +{
> +	int ret;
> +	unsigned char buf[] = {0x18, byte2, byte3};
> +	unsigned char report_type = HID_OUTPUT_REPORT;
> +
> +	/* The USB keyboard accepts commands via SET_FEATURE */
> +	if (hdev->product == USB_DEVICE_ID_LENOVO_CUSBKBD) {
> +		buf[0] = 0x13;
> +		report_type = HID_FEATURE_REPORT;
> +	}
> +
> +	ret = hdev->hid_output_raw_report(hdev, buf, sizeof(buf), report_type);
> +	return ret < 0 ? ret : 0; /* BT returns 0, USB returns sizeof(buf) */
> +}
> +
> +static void tpcompactkbd_features_set(struct hid_device *hdev)
> +{
> +	struct tpcompactkbd_sc *tpcsc = hid_get_drvdata(hdev);
> +
> +	if (tpcompactkbd_send_cmd(hdev, 0x05, tpcsc->fn_lock ? 0x01 : 0x00))
> +		hid_err(hdev, "Fn-lock setting failed\n");
> +}
> +
> +static ssize_t tpcompactkbd_fn_lock_show(struct device *dev,
> +		struct device_attribute *attr,
> +		char *buf)
> +{
> +	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
> +	struct tpcompactkbd_sc *tpcsc = hid_get_drvdata(hdev);
> +
> +	return snprintf(buf, PAGE_SIZE, "%u\n", tpcsc->fn_lock);
> +}
> +
> +static ssize_t tpcompactkbd_fn_lock_store(struct device *dev,
> +		struct device_attribute *attr,
> +		const char *buf,
> +		size_t count)
> +{
> +	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
> +	struct tpcompactkbd_sc *tpcsc = hid_get_drvdata(hdev);
> +	int value;
> +
> +	if (kstrtoint(buf, 10, &value))
> +		return -EINVAL;
> +	if (value < 0 || value > 1)
> +		return -EINVAL;
> +
> +	tpcsc->fn_lock = value;
> +	tpcompactkbd_features_set(hdev);
> +
> +	return count;
> +}
> +
> +static struct device_attribute dev_attr_pointer_fn_lock =
> +	__ATTR(fn_lock, S_IWUSR | S_IRUGO,
> +			tpcompactkbd_fn_lock_show,
> +			tpcompactkbd_fn_lock_store);
> +
> +static struct attribute *tpcompactkbd_attributes[] = {
> +	&dev_attr_pointer_fn_lock.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group tpcompactkbd_attr_group = {
> +	.attrs = tpcompactkbd_attributes,
> +};
> +
> +static int tpkbd_raw_event(struct hid_device *hdev,
> +			struct hid_report *report, u8 *data, int size)
> +{
> +	/*
> +	 * USB keyboard's Fn-F12 report holds down many other keys, and it's
> +	 * own key is outside the usage page range. Remove extra keypresses and
> +	 * remap to inside usage page.
> +	 */
> +	if (unlikely(hdev->product == USB_DEVICE_ID_LENOVO_CUSBKBD
> +			&& size == 3
> +			&& data[0] == 0x15
> +			&& data[1] == 0x94
> +			&& data[2] == 0x01)) {
> +		data[1] = 0x0;
> +		data[2] = 0x4;
> +	}
> +
> +	return 0;
> +}
> +
>  static int tpkbd_features_set(struct hid_device *hdev)
>  {
>  	struct hid_report *report;
> @@ -406,6 +550,46 @@ static int tpkbd_probe_tp(struct hid_device *hdev)
>  	return 0;
>  }
>  
> +static int tpcompactkbd_probe(struct hid_device *hdev,
> +			const struct hid_device_id *id)
> +{
> +	int ret;
> +	struct tpcompactkbd_sc *tpcsc;
> +
> +	tpcsc = devm_kzalloc(&hdev->dev, sizeof(*tpcsc), GFP_KERNEL);
> +	if (tpcsc == NULL) {
> +		hid_err(hdev, "can't alloc keyboard descriptor\n");
> +		return -ENOMEM;
> +	}
> +	hid_set_drvdata(hdev, tpcsc);
> +
> +	/* All the custom action happens on the mouse device for USB */
> +	if (hdev->product == USB_DEVICE_ID_LENOVO_CUSBKBD
> +			&& hdev->type != HID_TYPE_USBMOUSE) {
> +		pr_debug("Ignoring keyboard half of device\n");
> +		return 0;
> +	}
> +
> +	/*
> +	 * Tell the keyboard a driver understands it, and turn F7, F9, F11 into
> +	 * regular keys
> +	 */
> +	ret = tpcompactkbd_send_cmd(hdev, 0x01, 0x03);
> +	if (ret)
> +		hid_warn(hdev, "Failed to switch F7/9/11 into regular keys\n");
> +
> +	/* Turn Fn-Lock on by default */
> +	tpcsc->fn_lock = 1;
> +	tpcompactkbd_features_set(hdev);
> +
> +	if (sysfs_create_group(&hdev->dev.kobj,
> +				&tpcompactkbd_attr_group)) {

Use:
	ret = sysfs_create_group()
	if (ret) {

> +		hid_warn(hdev, "Could not create sysfs group\n");
> +	}

with only one statement in the if body curly braces are not needed.

> +
> +	return 0;
> +}
> +
>  static int tpkbd_probe(struct hid_device *hdev,
>  		const struct hid_device_id *id)
>  {
> @@ -426,6 +610,12 @@ static int tpkbd_probe(struct hid_device *hdev,
>  	if (hdev->product == USB_DEVICE_ID_LENOVO_TPKBD
>  			&& tpkbd_probe_tp(hdev))
>  		goto err_hid;
> +	if (hdev->product == USB_DEVICE_ID_LENOVO_CUSBKBD
> +			&& tpcompactkbd_probe(hdev, id))
> +		goto err_hid;
> +	if (hdev->product == USB_DEVICE_ID_LENOVO_CBTKBD
> +			&& tpcompactkbd_probe(hdev, id))

Again, what about combining the checks?
Calling the function in the if body (and checking the return value of
course :P).

> +		goto err_hid;
>  
>  	return 0;
>  err_hid:
> @@ -447,6 +637,12 @@ static void tpkbd_remove_tp(struct hid_device *hdev)
>  	hid_set_drvdata(hdev, NULL);
>  }
>  
> +static void tpcompactkbd_remove(struct hid_device *hdev)
> +{
> +	sysfs_remove_group(&hdev->dev.kobj,
> +			&tpcompactkbd_attr_group);
> +}
> +
>  static void tpkbd_remove(struct hid_device *hdev)
>  {
>  	if (!hid_get_drvdata(hdev))
> @@ -454,12 +650,18 @@ static void tpkbd_remove(struct hid_device *hdev)
>  
>  	if (hdev->product == USB_DEVICE_ID_LENOVO_TPKBD)
>  		tpkbd_remove_tp(hdev);
> +	if (hdev->product == USB_DEVICE_ID_LENOVO_CUSBKBD)
> +		tpcompactkbd_remove(hdev);
> +	if (hdev->product == USB_DEVICE_ID_LENOVO_CBTKBD)

Here too.

> +		tpcompactkbd_remove(hdev);
>  
>  	hid_hw_stop(hdev);
>  }
>  
>  static const struct hid_device_id tpkbd_devices[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_TPKBD) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_CUSBKBD) },
> +	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_CBTKBD) },
>  	{ }
>  };
>  
> @@ -471,6 +673,7 @@ static struct hid_driver tpkbd_driver = {
>  	.input_mapping = tpkbd_input_mapping,
>  	.probe = tpkbd_probe,
>  	.remove = tpkbd_remove,
> +	.raw_event = tpkbd_raw_event,
>  };
>  module_hid_driver(tpkbd_driver);
>  
> diff --git a/include/linux/hid.h b/include/linux/hid.h
> index 31b9d29..ed23d6a 100644
> --- a/include/linux/hid.h
> +++ b/include/linux/hid.h
> @@ -167,6 +167,7 @@ struct hid_item {
>  #define HID_UP_MSVENDOR		0xff000000
>  #define HID_UP_CUSTOM		0x00ff0000
>  #define HID_UP_LOGIVENDOR	0xffbc0000
> +#define HID_UP_LNVENDOR		0xffa00000
>  #define HID_UP_SENSOR		0x00200000
>  
>  #define HID_USAGE		0x0000ffff
> -- 
> 2.0.0.rc2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Ciao ciao,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
