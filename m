Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbaFWOfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:35:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49781 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbaFWOfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:35:16 -0400
Message-ID: <1403534113.10017.22.camel@linux-fkkt.site>
Subject: Re: [PATCH v9] leds: USB: HID: Add support for MSI GT683R led panels
From: Oliver Neukum <oneukum@suse.de>
To: Janne Kanniainen <janne.kanniainen@gmail.com>
Cc: jkosina@suse.cz, johan@kernel.org, cooloney@gmail.com,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org
Date: Mon, 23 Jun 2014 16:35:13 +0200
In-Reply-To: <1403107502-14106-1-git-send-email-janne.kanniainen@gmail.com>
References: <20140618073950.GC31163@localhost>
	 <1403107502-14106-1-git-send-email-janne.kanniainen@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-18 at 19:05 +0300, Janne Kanniainen wrote:
> This driver adds support for USB controlled led panels that exists in
> MSI GT683R laptop
> 

> +static int gt683r_led_probe(struct hid_device *hdev,
> +			const struct hid_device_id *id)
> +{
> +	int i;
> +	int ret;
> +	int name_sz;
> +	char *name;
> +	struct gt683r_led *led;
> +
> +	led = devm_kzalloc(&hdev->dev, sizeof(*led), GFP_KERNEL);
> +	if (!led)
> +		return -ENOMEM;
> +
> +	led->mode = GT683R_LED_NORMAL;
> +	led->hdev = hdev;
> +	hid_set_drvdata(hdev, led);
> +
> +	ret = hid_parse(hdev);
> +	if (ret) {
> +		hid_err(hdev, "hid parsing failed\n");
> +		return ret;
> +	}
> +
> +	ret = hid_hw_start(hdev, HID_CONNECT_HIDRAW);
> +	if (ret) {
> +		hid_err(hdev, "hw start failed\n");
> +		return ret;
> +	}
> +
> +	for (i = 0; i < GT683R_LED_COUNT; i++) {
> +		name_sz = strlen(dev_name(&hdev->dev)) +
> +				strlen(gt683r_panel_names[i]) + 3;
> +
> +		name = devm_kzalloc(&hdev->dev, name_sz, GFP_KERNEL);
> +		if (!name) {
> +			ret = -ENOMEM;
> +			goto fail;
> +		}
> +
> +		snprintf(name, name_sz, "%s::%s",
> +				dev_name(&hdev->dev), gt683r_panel_names[i]);
> +		led->led_devs[i].name = name;
> +		led->led_devs[i].max_brightness = 1;
> +		led->led_devs[i].brightness_set = gt683r_brightness_set;
> +		ret = led_classdev_register(&hdev->dev, &led->led_devs[i]);
> +		if (ret) {
> +			hid_err(hdev, "could not register led device\n");
> +			goto fail;
> +		}
> +	}
> +
> +	ret = device_create_file(&led->hdev->dev, &dev_attr_leds_mode);
> +	if (ret) {
> +		hid_err(hdev, "could not make mode attribute file\n");
> +		goto fail;
> +	}
> +

This is the window.

> +	mutex_init(&led->lock);
> +	INIT_WORK(&led->work, gt683r_led_work);
> +

And here we have a problem. This is a race condition.
At this time you've already created the sysfs files. So
their methods can be called. They will lock a mutex and/or
schedule work that hasn't been initialized.
The initialization must be done before anything in sysfs
is created. 

> +	return 0;
> +
> +fail:
> +	for (i = i - 1; i >= 0; i--)
> +		led_classdev_unregister(&led->led_devs[i]);
> +	hid_hw_stop(hdev);
> +	return ret;
> +}
> +

Sorry for noticing this thread late.

	Regards
		Oliver


