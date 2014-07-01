Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964872AbaGAURG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 16:17:06 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:58708 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964812AbaGAURE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 16:17:04 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Tue, 1 Jul 2014 22:16:27 +0200
From: Johan Hovold <johan@kernel.org>
To: Janne Kanniainen <janne.kanniainen@gmail.com>
Cc: johan@kernel.org, cooloney@gmail.com, jkosina@suse.cz, greg@kroah.com,
        bjorn@mork.no, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 2/2 v4] HID: leds: move led_mode attribute to led-class
 devices in MSI GT683R driver
Message-ID: <20140701201627.GA30605@localhost>
References: <20140630103911.GA2486@localhost>
 <1404237054-12906-1-git-send-email-janne.kanniainen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404237054-12906-1-git-send-email-janne.kanniainen@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 08:50:54PM +0300, Janne Kanniainen wrote:
  
> -static DEVICE_ATTR_RW(leds_mode);
> +static DEVICE_ATTR_RW(mode);
> +
> +static struct attribute *gt683r_led_attrs[] = {
> +	&dev_attr_mode.attr,
> +	NULL
> +};
> +
> +ATTRIBUTE_GROUPS(gt683r_led);

I was referring to the name field of struct attribute_group (and not of
struct hid_driver). Specifically, that means that you cannot use the
ATTRIBUTE_GROUPS macro (which leaves the name field unset), but rather
should define the two corresponding structs directly as follows:

	static const struct attribute_group gt683r_led_group = {
	       .name = "gt683r",
	       .attrs = gt683r_led_attrs,
	};
	
	static const struct attribute_group *gt683r_led_groups[] = {
	       &gt683r_led_group,
	       NULL
	};

That way the mode attribute will be created in a subdirectory (named
gt683r) of the led class device.

>  static int gt683r_led_probe(struct hid_device *hdev,
>  			const struct hid_device_id *id)
> @@ -261,6 +270,8 @@ static int gt683r_led_probe(struct hid_device *hdev,
>  		led->led_devs[i].name = name;
>  		led->led_devs[i].max_brightness = 1;
>  		led->led_devs[i].brightness_set = gt683r_brightness_set;
> +		led->led_devs[i].groups = gt683r_led_groups;
> +
>  		ret = led_classdev_register(&hdev->dev, &led->led_devs[i]);
>  		if (ret) {
>  			hid_err(hdev, "could not register led device\n");
> @@ -268,12 +279,6 @@ static int gt683r_led_probe(struct hid_device *hdev,
>  		}
>  	}

<snip>

> @@ -298,7 +302,7 @@ static void gt683r_led_remove(struct hid_device *hdev)
>  static struct hid_driver gt683r_led_driver = {
>  	.probe = gt683r_led_probe,
>  	.remove = gt683r_led_remove,
> -	.name = "gt683r_led",
> +	.name = "gt683r",

So you should skip this bit.

>  	.id_table = gt683r_led_id,
>  };

Johan
