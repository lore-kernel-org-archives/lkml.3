Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbaFPVEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 17:04:20 -0400
Received: from smtp207.alice.it ([82.57.200.103]:52005 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbaFPVES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 17:04:18 -0400
Date: Mon, 16 Jun 2014 23:03:59 +0200
From: Antonio Ospite <ao2@ao2.it>
To: Jamie Lentin <jm@lentin.co.uk>
Cc: Jiri Kosina <jkosina@suse.cz>, Alexander Clouter <alex@digriz.org.uk>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] Add support for Compact (Bluetooth|USB) keyboard
 with Trackpoint
Message-Id: <20140616230359.4f994e6af5da8df3622076b5@ao2.it>
In-Reply-To: <1402864790-7478-3-git-send-email-jm@lentin.co.uk>
References: <1402864790-7478-1-git-send-email-jm@lentin.co.uk>
	<1402864790-7478-3-git-send-email-jm@lentin.co.uk>
X-Mailer: Sylpheed 3.5.0beta1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jun 2014 21:39:50 +0100
Jamie Lentin <jm@lentin.co.uk> wrote:

This one does not compile on 3.15, see below.

Maybe you can take the chance to split the series in 4 patches:
	1. rename only
	2. cleanup of already existing code
	3. preparatory changes to support multiple devices (the original
	   1/2)
	4. support for the Compact keyboard (the original 2/2).

but two patches are fine too as long as the important issues are sorted
out.

> Signed-off-by: Jamie Lentin <jm@lentin.co.uk>
> ---
>  drivers/hid/Kconfig      |   2 +
>  drivers/hid/hid-core.c   |   2 +
>  drivers/hid/hid-ids.h    |   2 +
>  drivers/hid/hid-lenovo.c | 202 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/hid.h      |   1 +
>  5 files changed, 209 insertions(+)
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index dd07d59..48b4777 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -334,6 +334,8 @@ config HID_LENOVO
>  	Thinkpad standalone keyboards, e.g:
>  	- ThinkPad USB Keyboard with TrackPoint (supports extra LEDs and trackpoint
>  	  configuration)
> +	- ThinkPad Compact Bluetooth Keyboard with TrackPoint (supports Fn keys)
> +	- ThinkPad Compact USB Keyboard with TrackPoint (supports Fn keys)
>  
>  config HID_LOGITECH
>  	tristate "Logitech devices" if EXPERT
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index e8ce932..bce37c3 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1738,6 +1738,8 @@ static const struct hid_device_id hid_have_special_driver[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LCPOWER, USB_DEVICE_ID_LCPOWER_LC1000 ) },
>  #if IS_ENABLED(CONFIG_HID_LENOVO)
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

One TAB is enough here to align the second entry.

>  
>  #define USB_VENDOR_ID_LG		0x1fd2
>  #define USB_DEVICE_ID_LG_MULTITOUCH	0x0064
> diff --git a/drivers/hid/hid-lenovo.c b/drivers/hid/hid-lenovo.c
> index aabf084..0a19f84 100644
> --- a/drivers/hid/hid-lenovo.c
> +++ b/drivers/hid/hid-lenovo.c
> @@ -1,8 +1,11 @@
>  /*
>   *  HID driver for Lenovo:-
>   *  - ThinkPad USB Keyboard with TrackPoint (tpkbd)
> + *  - ThinkPad Compact Bluetooth Keyboard with TrackPoint (cptkbd)
> + *  - ThinkPad Compact USB Keyboard with TrackPoint (cptkbd)
>   *
>   *  Copyright (c) 2012 Bernhard Seibold
> + *  Copyright (c) 2014 Jamie Lentin <jm@lentin.co.uk>
>   */
>  
>  /*
> @@ -33,6 +36,10 @@ struct lenovo_drvdata_tpkbd {
>  	int press_speed;
>  };
>  
> +struct lenovo_drvdata_cptkbd {
> +	unsigned int fn_lock;

bool? 

> +};
> +
>  #define map_key_clear(c) hid_map_usage_clear(hi, usage, bit, max, EV_KEY, (c))
>  
>  static int lenovo_input_mapping_tpkbd(struct hid_device *hdev,
> @@ -48,6 +55,49 @@ static int lenovo_input_mapping_tpkbd(struct hid_device *hdev,
>  	return 0;
>  }
>  
> +static int lenovo_input_mapping_cptkbd(struct hid_device *hdev,
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
>  static int lenovo_input_mapping(struct hid_device *hdev,
>  		struct hid_input *hi, struct hid_field *field,
>  		struct hid_usage *usage, unsigned long **bit, int *max)
> @@ -57,6 +107,11 @@ static int lenovo_input_mapping(struct hid_device *hdev,
>  		return lenovo_input_mapping_tpkbd(hdev, hi, field,
>  							usage, bit, max);
>  		break;
> +	case USB_DEVICE_ID_LENOVO_CUSBKBD:
> +	case USB_DEVICE_ID_LENOVO_CBTKBD:
> +		return lenovo_input_mapping_cptkbd(hdev, hi, field,
> +							usage, bit, max);
> +		break;

break after return not needed.

>  	}
>  
>  	return 0;
> @@ -64,6 +119,96 @@ static int lenovo_input_mapping(struct hid_device *hdev,
>  
>  #undef map_key_clear
>  
> +/* Send a config command to the keyboard */
> +static int lenovo_send_cmd_cptkbd(struct hid_device *hdev,
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

This makes the driver fail to compile on 3.15.

The hid_output_raw_report() handler is not present anymore since
3.15-rc1, see commit 6fd182028c43baf1c7d017d52b0134ecadbdc447 in
current linus tree, I think you need to use something like:

	ret = hid_hw_raw_request(hdev, buf[0], buf, sizeof(buf),
	 			 report_type, HID_REQ_SET_REPORT);

but I cannot test that.

Please test the driver at least on 3.15, or even better on 3.16rc if you
can.

> +	return ret < 0 ? ret : 0; /* BT returns 0, USB returns sizeof(buf) */
> +}

The callers never propagate the error code, so maybe this function can
be declared to return a bool directly, and:
	return (ret >= 0);

just an idea.

> +
> +static void lenovo_features_set_cptkbd(struct hid_device *hdev)
> +{
> +	struct lenovo_drvdata_cptkbd *tpcsc = hid_get_drvdata(hdev);
> +
> +	if (lenovo_send_cmd_cptkbd(hdev, 0x05, tpcsc->fn_lock ? 0x01 : 0x00))
> +		hid_err(hdev, "Fn-lock setting failed\n");
> +}
> +
> +static ssize_t attr_fn_lock_show_cptkbd(struct device *dev,
> +		struct device_attribute *attr,
> +		char *buf)
> +{
> +	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
> +	struct lenovo_drvdata_cptkbd *tpcsc = hid_get_drvdata(hdev);
> +
> +	return snprintf(buf, PAGE_SIZE, "%u\n", tpcsc->fn_lock);
> +}
> +
> +static ssize_t attr_fn_lock_store_cptkbd(struct device *dev,
> +		struct device_attribute *attr,
> +		const char *buf,
> +		size_t count)
> +{
> +	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
> +	struct lenovo_drvdata_cptkbd *tpcsc = hid_get_drvdata(hdev);
> +	int value;
> +
> +	if (kstrtoint(buf, 10, &value))
> +		return -EINVAL;
> +	if (value < 0 || value > 1)
> +		return -EINVAL;
> +
> +	tpcsc->fn_lock = value;

if tpcsc->fn_lock is bool you can use "!!value" here to convert value
to bool.

> +	lenovo_features_set_cptkbd(hdev);
> +
> +	return count;
> +}
> +
> +static struct device_attribute dev_attr_fn_lock_cptkbd =
> +	__ATTR(fn_lock, S_IWUSR | S_IRUGO,
> +			attr_fn_lock_show_cptkbd,
> +			attr_fn_lock_store_cptkbd);
> +
> +static struct attribute *lenovo_attributes_cptkbd[] = {
> +	&dev_attr_fn_lock_cptkbd.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group lenovo_attr_group_cptkbd = {
> +	.attrs = lenovo_attributes_cptkbd,
> +};
> +
> +static int lenovo_raw_event(struct hid_device *hdev,
> +			struct hid_report *report, u8 *data, int size)
> +{
> +	/*
> +	 * Compact USB keyboard's Fn-F12 report holds down many other keys, and
> +	 * it's own key is outside the usage page range. Remove extra
           ^^^^
its?

> +	 * keypresses and remap to inside usage page.
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
>  static int lenovo_features_set_tpkbd(struct hid_device *hdev)
>  {
>  	struct hid_report *report;
> @@ -417,6 +562,46 @@ static int lenovo_probe_tpkbd(struct hid_device *hdev,
>  	return 0;
>  }
>  
> +static int lenovo_probe_cptkbd(struct hid_device *hdev,
> +			const struct hid_device_id *id)

The id argument is not needed for the "internal" probe function.

> +{
> +	int ret;
> +	struct lenovo_drvdata_cptkbd *tpcsc;
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

hid_dbg(hdev, ...); can also be used

> +		return 0;
> +	}
> +
> +	/*
> +	 * Tell the keyboard a driver understands it, and turn F7, F9, F11 into
> +	 * regular keys
> +	 */
> +	ret = lenovo_send_cmd_cptkbd(hdev, 0x01, 0x03);
> +	if (ret)
> +		hid_warn(hdev, "Failed to switch F7/9/11 into regular keys\n");
> +
> +	/* Turn Fn-Lock on by default */
> +	tpcsc->fn_lock = 1;
> +	lenovo_features_set_cptkbd(hdev);
> +
> +	if (sysfs_create_group(&hdev->dev.kobj,
> +				&lenovo_attr_group_cptkbd)) {

	ret = sysfs_create_group(...);
	if (ret)
		hid_warn(...)

no curly braces needed.

> +		hid_warn(hdev, "Could not create sysfs group\n");
> +	}
> +
> +	return 0;
> +}
> +
>  static int lenovo_probe(struct hid_device *hdev,
>  		const struct hid_device_id *id)
>  {
> @@ -438,6 +623,10 @@ static int lenovo_probe(struct hid_device *hdev,
>  	case USB_DEVICE_ID_LENOVO_TPKBD:
>  		ret = lenovo_probe_tpkbd(hdev, id);
>  		break;
> +	case USB_DEVICE_ID_LENOVO_CUSBKBD:
> +	case USB_DEVICE_ID_LENOVO_CBTKBD:
> +		ret = lenovo_probe_cptkbd(hdev, id);
> +		break;
>  	}
>  	if (ret)
>  		goto err_hid;
> @@ -465,12 +654,22 @@ static void lenovo_remove_tpkbd(struct hid_device *hdev)
>  	hid_set_drvdata(hdev, NULL);
>  }
>  
> +static void lenovo_remove_cptkbd(struct hid_device *hdev)
> +{
> +	sysfs_remove_group(&hdev->dev.kobj,
> +			&lenovo_attr_group_cptkbd);
> +}
> +
>  static void lenovo_remove(struct hid_device *hdev)
>  {
>  	switch (hdev->product) {
>  	case USB_DEVICE_ID_LENOVO_TPKBD:
>  		lenovo_remove_tpkbd(hdev);
>  		break;
> +	case USB_DEVICE_ID_LENOVO_CUSBKBD:
> +	case USB_DEVICE_ID_LENOVO_CBTKBD:
> +		lenovo_remove_cptkbd(hdev);
> +		break;
>  	}
>  
>  	hid_hw_stop(hdev);
> @@ -478,6 +677,8 @@ static void lenovo_remove(struct hid_device *hdev)
>  
>  static const struct hid_device_id lenovo_devices[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_TPKBD) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_CUSBKBD) },
> +	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_LENOVO, USB_DEVICE_ID_LENOVO_CBTKBD) },
>  	{ }
>  };
>  
> @@ -489,6 +690,7 @@ static struct hid_driver lenovo_driver = {
>  	.input_mapping = lenovo_input_mapping,
>  	.probe = lenovo_probe,
>  	.remove = lenovo_remove,
> +	.raw_event = lenovo_raw_event,
>  };
>  module_hid_driver(lenovo_driver);
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
> 


-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
