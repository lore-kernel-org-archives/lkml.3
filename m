Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbaFYL4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:56:20 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:62723 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbaFYL4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:56:17 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 25 Jun 2014 13:55:41 +0200
From: Johan Hovold <johan@kernel.org>
To: Greg KH <greg@kroah.com>
Cc: Janne Kanniainen <janne.kanniainen@gmail.com>, johan@kernel.org,
        bjorn@mork.no, jkosina@suse.cz, cooloney@gmail.com,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 2/2] HID: leds: move led_mode attribute to led-class
 devices in MSI GT683R driver
Message-ID: <20140625115541.GA1409@localhost>
References: <20140624145003.GA6607@localhost>
 <1403638718-11448-1-git-send-email-janne.kanniainen@gmail.com>
 <1403638718-11448-2-git-send-email-janne.kanniainen@gmail.com>
 <20140624195651.GA13694@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140624195651.GA13694@kroah.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 03:56:51PM -0400, Greg KH wrote:
> On Tue, Jun 24, 2014 at 10:38:38PM +0300, Janne Kanniainen wrote:

> >  static int gt683r_led_probe(struct hid_device *hdev,
> >  			const struct hid_device_id *id)
> > @@ -261,6 +272,7 @@ static int gt683r_led_probe(struct hid_device *hdev,
> >  		led->led_devs[i].name = name;
> >  		led->led_devs[i].max_brightness = 1;
> >  		led->led_devs[i].brightness_set = gt683r_brightness_set;
> > +
> >  		ret = led_classdev_register(&hdev->dev, &led->led_devs[i]);
> >  		if (ret) {
> >  			hid_err(hdev, "could not register led device\n");
> > @@ -268,17 +280,29 @@ static int gt683r_led_probe(struct hid_device *hdev,
> >  		}
> >  	}
> >  
> > -	ret = device_create_file(&led->hdev->dev, &dev_attr_leds_mode);
> > -	if (ret) {
> > -		hid_err(hdev, "could not make mode attribute file\n");
> > -		goto fail;
> > +	for (i = 0; i < GT683R_LED_COUNT; i++) {
> > +		led->dev_attr_group[i] = &gt683r_group;
> > +
> > +		ret = sysfs_create_group(&led->led_devs[i].dev->kobj,
> > +					led->dev_attr_group[i]);
> 
> why not use sysfs_create_groups()?
> 
> And why are you doing it this way, the led device should have the
> attribute group and it should be created automatically by the driver
> core, no driver should need to create it like you are doing so here.

Turns out it was easier said than done when I asked Janne to move the
attribute. And all led drivers with custom attributes currently suffer
from this race.

Janne, you'll need to apply patch below and then set the groups field of
the led_devs before registering them. You can use the ATTRIBUTE_GROUPS
macro in the following way:

	static struct attribute *gt683r_led_attrs[] = {
       		&dev_attr_msi_mode.attr,
       		NULL,
	};
	ATTRIBUTE_GROUPS(gt683r_led);

and then set .groups to gt683r_led_groups.

I have started fixing some of the other led drivers and I'll try to
submit a series (including the below patch) later today.

Thanks,
Johan


>From 226f1de5e094f2ec99f45d486652505ef915af73 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Wed, 25 Jun 2014 12:33:18 +0200
Subject: [PATCH] leds: add led-class attribute-group support

Allow led-class devices to be created with optional attribute groups.

This is needed in order to allow led drivers to create custom device
attributes in a race-free manner.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/leds/led-class.c | 5 +++--
 include/linux/leds.h     | 2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index f37d63cf726b..aa29198fca3e 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -210,8 +210,9 @@ static const struct dev_pm_ops leds_class_dev_pm_ops = {
  */
 int led_classdev_register(struct device *parent, struct led_classdev *led_cdev)
 {
-	led_cdev->dev = device_create(leds_class, parent, 0, led_cdev,
-				      "%s", led_cdev->name);
+	led_cdev->dev = device_create_with_groups(leds_class, parent, 0,
+					led_cdev, led_cdev->groups,
+					"%s", led_cdev->name);
 	if (IS_ERR(led_cdev->dev))
 		return PTR_ERR(led_cdev->dev);
 
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 0287ab296689..e43686472197 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -63,6 +63,8 @@ struct led_classdev {
 				     unsigned long *delay_off);
 
 	struct device		*dev;
+	const struct attribute_group	**groups;
+
 	struct list_head	 node;			/* LED Device list */
 	const char		*default_trigger;	/* Trigger to use */
 
-- 
1.8.5.5

