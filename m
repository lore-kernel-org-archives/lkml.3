Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbaFWOne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:43:34 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:65047 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645AbaFWOnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:43:32 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Mon, 23 Jun 2014 16:42:55 +0200
From: Johan Hovold <johan@kernel.org>
To: Oliver Neukum <oneukum@suse.de>
Cc: Janne Kanniainen <janne.kanniainen@gmail.com>, jkosina@suse.cz,
        johan@kernel.org, cooloney@gmail.com, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v9] leds: USB: HID: Add support for MSI GT683R led panels
Message-ID: <20140623144255.GA19911@localhost>
References: <20140618073950.GC31163@localhost>
 <1403107502-14106-1-git-send-email-janne.kanniainen@gmail.com>
 <1403534113.10017.22.camel@linux-fkkt.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403534113.10017.22.camel@linux-fkkt.site>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 04:35:13PM +0200, Oliver Neukum wrote:
> On Wed, 2014-06-18 at 19:05 +0300, Janne Kanniainen wrote:
> > This driver adds support for USB controlled led panels that exists in
> > MSI GT683R laptop
> > 
> 
> > +static int gt683r_led_probe(struct hid_device *hdev,
> > +			const struct hid_device_id *id)
> > +{
> > +	int i;
> > +	int ret;
> > +	int name_sz;
> > +	char *name;
> > +	struct gt683r_led *led;
> > +
> > +	led = devm_kzalloc(&hdev->dev, sizeof(*led), GFP_KERNEL);
> > +	if (!led)
> > +		return -ENOMEM;
> > +
> > +	led->mode = GT683R_LED_NORMAL;
> > +	led->hdev = hdev;
> > +	hid_set_drvdata(hdev, led);
> > +
> > +	ret = hid_parse(hdev);
> > +	if (ret) {
> > +		hid_err(hdev, "hid parsing failed\n");
> > +		return ret;
> > +	}
> > +
> > +	ret = hid_hw_start(hdev, HID_CONNECT_HIDRAW);
> > +	if (ret) {
> > +		hid_err(hdev, "hw start failed\n");
> > +		return ret;
> > +	}
> > +
> > +	for (i = 0; i < GT683R_LED_COUNT; i++) {
> > +		name_sz = strlen(dev_name(&hdev->dev)) +
> > +				strlen(gt683r_panel_names[i]) + 3;
> > +
> > +		name = devm_kzalloc(&hdev->dev, name_sz, GFP_KERNEL);
> > +		if (!name) {
> > +			ret = -ENOMEM;
> > +			goto fail;
> > +		}
> > +
> > +		snprintf(name, name_sz, "%s::%s",
> > +				dev_name(&hdev->dev), gt683r_panel_names[i]);
> > +		led->led_devs[i].name = name;
> > +		led->led_devs[i].max_brightness = 1;
> > +		led->led_devs[i].brightness_set = gt683r_brightness_set;
> > +		ret = led_classdev_register(&hdev->dev, &led->led_devs[i]);
> > +		if (ret) {
> > +			hid_err(hdev, "could not register led device\n");
> > +			goto fail;
> > +		}
> > +	}
> > +
> > +	ret = device_create_file(&led->hdev->dev, &dev_attr_leds_mode);
> > +	if (ret) {
> > +		hid_err(hdev, "could not make mode attribute file\n");
> > +		goto fail;
> > +	}
> > +
> 
> This is the window.
> 
> > +	mutex_init(&led->lock);
> > +	INIT_WORK(&led->work, gt683r_led_work);
> > +
> 
> And here we have a problem. This is a race condition.
> At this time you've already created the sysfs files. So
> their methods can be called. They will lock a mutex and/or
> schedule work that hasn't been initialized.
> The initialization must be done before anything in sysfs
> is created. 

Just move the initialisation of the lock and work to the other private
data initialisations directly after it's allocated.

Can you send a follow up patch, Janne?

Thanks Oliver!

Johan
