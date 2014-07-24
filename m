Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934362AbaGXToU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 15:44:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933784AbaGXToR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 15:44:17 -0400
Date: Thu, 24 Jul 2014 15:43:52 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Ping Cheng <pinglinux@gmail.com>,
        Jason Gerecke <killertofu@gmail.com>, Przemo Firszt <przemo@firszt.eu>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v2 07/10] Input - wacom: handle Graphire BT tablets in
 wacom.ko
Message-ID: <20140724194352.GB4190@mail.corp.redhat.com>
References: <1406225645-32141-1-git-send-email-benjamin.tissoires@redhat.com>
 <1406225645-32141-8-git-send-email-benjamin.tissoires@redhat.com>
 <20140724193509.GB26752@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140724193509.GB26752@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 24 2014 or thereabouts, Dmitry Torokhov wrote:
> Hi Benjamin,
> 
> On Thu, Jul 24, 2014 at 02:14:02PM -0400, Benjamin Tissoires wrote:
> > First, merge the Graphire BT tablet.
> > 
> > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > ---
> > 
> > changes in v2:
> > - simplified because part of it has been splitted out in the previous commit.
> > 
> >  drivers/hid/hid-core.c  |  1 -
> >  drivers/hid/hid-wacom.c |  1 -
> >  drivers/hid/wacom_sys.c | 42 +++++++++++++++++++++
> >  drivers/hid/wacom_wac.c | 98 ++++++++++++++++++++++++++++++++++++++++++++++++-
> >  drivers/hid/wacom_wac.h |  2 +
> >  5 files changed, 140 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> > index 7cff1c2..4db6804 100644
> > --- a/drivers/hid/hid-core.c
> > +++ b/drivers/hid/hid-core.c
> > @@ -1920,7 +1920,6 @@ static const struct hid_device_id hid_have_special_driver[] = {
> >  	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP_LTD, USB_DEVICE_ID_SUPER_JOY_BOX_3_PRO) },
> >  	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP_LTD, USB_DEVICE_ID_SUPER_DUAL_BOX_PRO) },
> >  	{ HID_USB_DEVICE(USB_VENDOR_ID_WISEGROUP_LTD, USB_DEVICE_ID_SUPER_JOY_BOX_5_PRO) },
> > -	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_WACOM, USB_DEVICE_ID_WACOM_GRAPHIRE_BLUETOOTH) },
> >  	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_WACOM, USB_DEVICE_ID_WACOM_INTUOS4_BLUETOOTH) },
> >  	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP, USB_DEVICE_ID_WALTOP_SLIM_TABLET_5_8_INCH) },
> >  	{ HID_USB_DEVICE(USB_VENDOR_ID_WALTOP, USB_DEVICE_ID_WALTOP_SLIM_TABLET_12_1_INCH) },
> > diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
> > index 4874f4e..967c457 100644
> > --- a/drivers/hid/hid-wacom.c
> > +++ b/drivers/hid/hid-wacom.c
> > @@ -952,7 +952,6 @@ static void wacom_remove(struct hid_device *hdev)
> >  }
> >  
> >  static const struct hid_device_id wacom_devices[] = {
> > -	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_WACOM, USB_DEVICE_ID_WACOM_GRAPHIRE_BLUETOOTH) },
> >  	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_WACOM, USB_DEVICE_ID_WACOM_INTUOS4_BLUETOOTH) },
> >  
> >  	{ }
> > diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
> > index add76ec..8492177 100644
> > --- a/drivers/hid/wacom_sys.c
> > +++ b/drivers/hid/wacom_sys.c
> > @@ -265,6 +265,48 @@ static int wacom_set_device_mode(struct hid_device *hdev, int report_id,
> >  static int wacom_bt_query_tablet_data(struct hid_device *hdev, u8 speed,
> >  		struct wacom_features *features)
> >  {
> > +	struct wacom *wacom = hid_get_drvdata(hdev);
> > +	int limit, ret;
> > +	__u8 rep_data[2];
> 
> I think just u8 in kerneli proper.

OK, I will adjust.

> 
> > +
> > +	switch (features->type) {
> > +	case GRAPHIRE_BT:
> > +		rep_data[0] = 0x03 ; rep_data[1] = 0x00;
> > +		limit = 3;
> > +		do {
> > +			ret = hid_hw_raw_request(hdev, rep_data[0], rep_data, 2,
> > +					HID_FEATURE_REPORT, HID_REQ_SET_REPORT);
> > +		} while (ret < 0 && limit-- > 0);
> > +
> > +		if (ret >= 0) {
> > +			if (speed == 0)
> > +				rep_data[0] = 0x05;
> > +			else
> > +				rep_data[0] = 0x06;
> 
> I am a fan of
> 
> 			rep_data[0] = speed == 0 ? 0x05 : 0x06;
> 
> as it takes 1 line vs 3.
> 

hehe

BTW, actually, I just copied/pasted the chunks from hid-wacom. But you
are right, a little cleanup is definitively better.

> > +
> > +			rep_data[1] = 0x00;
> > +			limit = 3;
> > +			do {
> > +				ret = hid_hw_raw_request(hdev, rep_data[0],
> > +					rep_data, 2, HID_FEATURE_REPORT,
> > +					HID_REQ_SET_REPORT);
> > +			} while (ret < 0 && limit-- > 0);
> > +
> > +			if (ret >= 0) {
> > +				wacom->wacom_wac.bt_high_speed = speed;
> > +				return 0;
> > +			}
> > +		}
> > +
> > +		/*
> > +		 * Note that if the raw queries fail, it's not a hard failure
> > +		 * and it is safe to continue
> > +		 */
> > +		hid_warn(hdev, "failed to poke device, command %d, err %d\n",
> > +			 rep_data[0], ret);
> > +		break;
> > +	}
> > +
> >  	return 0;
> >  }
> >  
> > diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
> > index 2c69326..06bc600 100644
> > --- a/drivers/hid/wacom_wac.c
> > +++ b/drivers/hid/wacom_wac.c
> > @@ -30,6 +30,10 @@
> >   */
> >  #define WACOM_CONTACT_AREA_SCALE 2607
> >  
> > +/*percent of battery capacity for Graphire
> > +  8th value means AC online and show 100% capacity */
> > +static unsigned short batcap_gr[8] = { 1, 15, 25, 35, 50, 70, 100, 100 };
> > +
> >  static int wacom_penpartner_irq(struct wacom_wac *wacom)
> >  {
> >  	unsigned char *data = wacom->data;
> > @@ -263,11 +267,19 @@ static int wacom_graphire_irq(struct wacom_wac *wacom)
> >  	unsigned char *data = wacom->data;
> >  	struct input_dev *input = wacom->input;
> >  	struct input_dev *pad_input = wacom->pad_input;
> > +	int battery_capacity, ps_connected;
> >  	int prox;
> >  	int rw = 0;
> >  	int retval = 0;
> >  
> > -	if (data[0] != WACOM_REPORT_PENABLED) {
> > +	if (features->type == GRAPHIRE_BT) {
> > +		if (data[0] != WACOM_REPORT_PENABLED_BT) {
> > +			dev_dbg(input->dev.parent,
> > +				"%s: received unknown report #%d\n", __func__,
> > +				data[0]);
> > +			goto exit;
> > +		}
> > +	} else if (data[0] != WACOM_REPORT_PENABLED) {
> >  		dev_dbg(input->dev.parent,
> >  			"%s: received unknown report #%d\n", __func__, data[0]);
> >  		goto exit;
> > @@ -301,7 +313,12 @@ static int wacom_graphire_irq(struct wacom_wac *wacom)
> >  		input_report_abs(input, ABS_X, le16_to_cpup((__le16 *)&data[2]));
> >  		input_report_abs(input, ABS_Y, le16_to_cpup((__le16 *)&data[4]));
> >  		if (wacom->tool[0] != BTN_TOOL_MOUSE) {
> > -			input_report_abs(input, ABS_PRESSURE, data[6] | ((data[7] & 0x03) << 8));
> > +			if (features->type == GRAPHIRE_BT)
> > +				input_report_abs(input, ABS_PRESSURE, data[6] |
> > +					(((__u16) (data[1] & 0x08)) << 5));
> > +			else
> > +				input_report_abs(input, ABS_PRESSURE, data[6] |
> > +					((data[7] & 0x03) << 8));
> >  			input_report_key(input, BTN_TOUCH, data[1] & 0x01);
> >  			input_report_key(input, BTN_STYLUS, data[1] & 0x02);
> >  			input_report_key(input, BTN_STYLUS2, data[1] & 0x04);
> > @@ -312,6 +329,23 @@ static int wacom_graphire_irq(struct wacom_wac *wacom)
> >  					features->type == WACOM_MO) {
> >  				input_report_abs(input, ABS_DISTANCE, data[6] & 0x3f);
> >  				rw = (data[7] & 0x04) - (data[7] & 0x03);
> > +			} else if (features->type == GRAPHIRE_BT) {
> > +				/* Compute distance between mouse and tablet */
> > +				rw = 44 - (data[6] >> 2);
> > +				if (rw < 0)
> > +					rw = 0;
> > +				else if (rw > 31)
> > +					rw = 31;
> 
> 				rw = clamp_val(rw, 0, 31);
> 
> ?

could be...

I'll do the tests and resubmit later the v3. I'll wait a little in case
you have other comments on the other patches :)

Cheers,
Benjamin

> 
> > +				input_report_abs(input, ABS_DISTANCE, rw);
> > +				if (((data[1] >> 5) & 3) == 2) {
> > +					/* Mouse with wheel */
> > +					input_report_key(input, BTN_MIDDLE,
> > +							data[1] & 0x04);
> > +					rw = (data[6] & 0x01) ? -1 :
> > +						(data[6] & 0x02) ? 1 : 0;
> > +				} else {
> > +					rw = 0;
> > +				}
> >  			} else {
> >  				input_report_abs(input, ABS_DISTANCE, data[7] & 0x3f);
> >  				rw = -(signed char)data[6];
> > @@ -358,6 +392,31 @@ static int wacom_graphire_irq(struct wacom_wac *wacom)
> >  			retval = 1;
> >  		}
> >  		break;
> > +	case GRAPHIRE_BT:
> > +		prox = data[7] & 0x03;
> > +		if (prox || wacom->id[1]) {
> > +			wacom->id[1] = PAD_DEVICE_ID;
> > +			input_report_key(pad_input, BTN_0, (data[7] & 0x02));
> > +			input_report_key(pad_input, BTN_1, (data[7] & 0x01));
> > +			if (!prox)
> > +				wacom->id[1] = 0;
> > +			input_report_abs(pad_input, ABS_MISC, wacom->id[1]);
> > +			retval = 1;
> > +		}
> > +		break;
> > +	}
> > +
> > +	/* Store current battery capacity and power supply state */
> > +	if (features->type == GRAPHIRE_BT) {
> > +		rw = (data[7] >> 2 & 0x07);
> > +		battery_capacity = batcap_gr[rw];
> > +		ps_connected = rw == 7;
> > +		if ((wacom->battery_capacity != battery_capacity) ||
> > +		    (wacom->ps_connected != ps_connected)) {
> > +			wacom->battery_capacity = battery_capacity;
> > +			wacom->ps_connected = ps_connected;
> > +			wacom_notify_battery(wacom);
> > +		}
> >  	}
> >  exit:
> >  	return retval;
> > @@ -1418,6 +1477,7 @@ void wacom_wac_irq(struct wacom_wac *wacom_wac, size_t len)
> >  
> >  	case WACOM_G4:
> >  	case GRAPHIRE:
> > +	case GRAPHIRE_BT:
> >  	case WACOM_MO:
> >  		sync = wacom_graphire_irq(wacom_wac);
> >  		break;
> > @@ -1654,6 +1714,27 @@ int wacom_setup_input_capabilities(struct input_dev *input_dev,
> >  		__set_bit(INPUT_PROP_POINTER, input_dev->propbit);
> >  		break;
> >  
> > +	case GRAPHIRE_BT:
> > +		__clear_bit(ABS_MISC, input_dev->absbit);
> > +		input_set_abs_params(input_dev, ABS_DISTANCE, 0,
> > +					      features->distance_max,
> > +					      0, 0);
> > +
> > +		input_set_capability(input_dev, EV_REL, REL_WHEEL);
> > +
> > +		__set_bit(BTN_LEFT, input_dev->keybit);
> > +		__set_bit(BTN_RIGHT, input_dev->keybit);
> > +		__set_bit(BTN_MIDDLE, input_dev->keybit);
> > +
> > +		__set_bit(BTN_TOOL_RUBBER, input_dev->keybit);
> > +		__set_bit(BTN_TOOL_PEN, input_dev->keybit);
> > +		__set_bit(BTN_TOOL_MOUSE, input_dev->keybit);
> > +		__set_bit(BTN_STYLUS, input_dev->keybit);
> > +		__set_bit(BTN_STYLUS2, input_dev->keybit);
> > +
> > +		__set_bit(INPUT_PROP_POINTER, input_dev->propbit);
> > +		break;
> > +
> >  	case WACOM_24HD:
> >  		input_set_abs_params(input_dev, ABS_Z, -900, 899, 0, 0);
> >  		input_set_abs_params(input_dev, ABS_THROTTLE, 0, 71, 0, 0);
> > @@ -1848,6 +1929,11 @@ int wacom_setup_pad_input_capabilities(struct input_dev *input_dev,
> >  	input_set_abs_params(input_dev, ABS_Y, 0, 1, 0, 0);
> >  
> >  	switch (features->type) {
> > +	case GRAPHIRE_BT:
> > +		__set_bit(BTN_0, input_dev->keybit);
> > +		__set_bit(BTN_1, input_dev->keybit);
> > +		break;
> > +
> >  	case WACOM_MO:
> >  		__set_bit(BTN_BACK, input_dev->keybit);
> >  		__set_bit(BTN_LEFT, input_dev->keybit);
> > @@ -2017,6 +2103,9 @@ static const struct wacom_features wacom_features_0x00 =
> >  static const struct wacom_features wacom_features_0x10 =
> >  	{ "Wacom Graphire", 10206, 7422, 511, 63,
> >  	  GRAPHIRE, WACOM_GRAPHIRE_RES, WACOM_GRAPHIRE_RES };
> > +static const struct wacom_features wacom_features_0x81 =
> > +	{ "Wacom Graphire BT", 16704, 12064, 511, 32,
> > +	  GRAPHIRE_BT, WACOM_GRAPHIRE_RES, WACOM_GRAPHIRE_RES };
> >  static const struct wacom_features wacom_features_0x11 =
> >  	{ "Wacom Graphire2 4x5", 10206, 7422, 511, 63,
> >  	  GRAPHIRE, WACOM_GRAPHIRE_RES, WACOM_GRAPHIRE_RES };
> > @@ -2412,6 +2501,10 @@ static const struct wacom_features wacom_features_0x309 =
> >  	HID_DEVICE(BUS_USB, HID_GROUP_WACOM, USB_VENDOR_ID_WACOM, prod),\
> >  	.driver_data = (kernel_ulong_t)&wacom_features_##prod
> >  
> > +#define BT_DEVICE_WACOM(prod)						\
> > +	HID_DEVICE(BUS_BLUETOOTH, HID_GROUP_WACOM, USB_VENDOR_ID_WACOM, prod),\
> > +	.driver_data = (kernel_ulong_t)&wacom_features_##prod
> > +
> >  #define USB_DEVICE_LENOVO(prod)					\
> >  	HID_USB_DEVICE(USB_VENDOR_ID_LENOVO, prod),			\
> >  	.driver_data = (kernel_ulong_t)&wacom_features_##prod
> > @@ -2469,6 +2562,7 @@ const struct hid_device_id wacom_ids[] = {
> >  	{ USB_DEVICE_WACOM(0x69) },
> >  	{ USB_DEVICE_WACOM(0x6A) },
> >  	{ USB_DEVICE_WACOM(0x6B) },
> > +	{ BT_DEVICE_WACOM(0x81) },
> >  	{ USB_DEVICE_WACOM(0x84) },
> >  	{ USB_DEVICE_WACOM(0x90) },
> >  	{ USB_DEVICE_WACOM(0x93) },
> > diff --git a/drivers/hid/wacom_wac.h b/drivers/hid/wacom_wac.h
> > index 3aa55d9..0f3df34 100644
> > --- a/drivers/hid/wacom_wac.h
> > +++ b/drivers/hid/wacom_wac.h
> > @@ -46,6 +46,7 @@
> >  
> >  /* wacom data packet report IDs */
> >  #define WACOM_REPORT_PENABLED		2
> > +#define WACOM_REPORT_PENABLED_BT	3
> >  #define WACOM_REPORT_INTUOSREAD		5
> >  #define WACOM_REPORT_INTUOSWRITE	6
> >  #define WACOM_REPORT_INTUOSPAD		12
> > @@ -73,6 +74,7 @@
> >  enum {
> >  	PENPARTNER = 0,
> >  	GRAPHIRE,
> > +	GRAPHIRE_BT,
> >  	WACOM_G4,
> >  	PTU,
> >  	PL,
> > -- 
> > 2.0.1
> > 
> 
> -- 
> Dmitry
