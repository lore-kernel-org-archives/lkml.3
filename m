Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaFXT5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:57:05 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59407 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751963AbaFXT5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:57:03 -0400
X-Sasl-enc: tPPZRVHwHL92DMbKh5IkS0bD5RCTf0R+ACGnPn5sSe3Z 1403639821
Date: Tue, 24 Jun 2014 15:56:51 -0400
From: Greg KH <greg@kroah.com>
To: Janne Kanniainen <janne.kanniainen@gmail.com>
Cc: johan@kernel.org, bjorn@mork.no, jkosina@suse.cz, cooloney@gmail.com,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 2/2] HID: leds: move led_mode attribute to led-class
 devices in MSI GT683R driver
Message-ID: <20140624195651.GA13694@kroah.com>
References: <20140624145003.GA6607@localhost>
 <1403638718-11448-1-git-send-email-janne.kanniainen@gmail.com>
 <1403638718-11448-2-git-send-email-janne.kanniainen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403638718-11448-2-git-send-email-janne.kanniainen@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 10:38:38PM +0300, Janne Kanniainen wrote:
> Move led_mode attribute from HID device to led-class devices and rename it
> msi_mode.
> 
> Signed-off-by: Janne Kanniainen <janne.kanniainen@gmail.com>
> ---
>  .../ABI/testing/sysfs-class-hid-driver-gt683r      |  6 ++-
>  drivers/hid/hid-gt683r.c                           | 50 +++++++++++++++++-----
>  2 files changed, 43 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r b/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
> index 317e9d5..c97970a 100644
> --- a/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
> +++ b/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
> @@ -1,9 +1,11 @@
> -What:		/sys/class/hidraw/<hidraw>/device/leds_mode
> +What:		/sys/class/leds/<led>/msi_mode
>  Date:		Jun 2014
>  KernelVersion:	3.17
>  Contact:	Janne Kanniainen <janne.kanniainen@gmail.com>
>  Description:
> -		Set the mode of LEDs
> +		Set the mode of LEDs. You should notice that changing the mode
> +		of one LED will update the mode of its two sibling devices as
> +		well
>  
>  		0 - normal
>  		1 - audio
> diff --git a/drivers/hid/hid-gt683r.c b/drivers/hid/hid-gt683r.c
> index 073bd80..1c942eb 100644
> --- a/drivers/hid/hid-gt683r.c
> +++ b/drivers/hid/hid-gt683r.c
> @@ -58,6 +58,7 @@ struct gt683r_led {
>  	struct work_struct work;
>  	enum led_brightness brightnesses[GT683R_LED_COUNT];
>  	enum gt683r_led_mode mode;
> +	const struct attribute_group *dev_attr_group[GT683R_LED_COUNT];
>  };
>  
>  static const struct hid_device_id gt683r_led_id[] = {
> @@ -84,12 +85,13 @@ static void gt683r_brightness_set(struct led_classdev *led_cdev,
>  	}
>  }
>  
> -static ssize_t leds_mode_show(struct device *dev,
> +static ssize_t msi_mode_show(struct device *led_dev,
>  				struct device_attribute *attr,
>  				char *buf)
>  {
>  	u8 sysfs_mode;
> -	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
> +	struct hid_device *hdev = container_of(led_dev->parent,
> +					struct hid_device, dev);
>  	struct gt683r_led *led = hid_get_drvdata(hdev);
>  
>  	if (led->mode == GT683R_LED_NORMAL)
> @@ -102,15 +104,15 @@ static ssize_t leds_mode_show(struct device *dev,
>  	return scnprintf(buf, PAGE_SIZE, "%u\n", sysfs_mode);
>  }
>  
> -static ssize_t leds_mode_store(struct device *dev,
> +static ssize_t msi_mode_store(struct device *led_dev,
>  				struct device_attribute *attr,
>  				const char *buf, size_t count)
>  {
>  	u8 sysfs_mode;
> -	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
> +	struct hid_device *hdev = container_of(led_dev->parent,
> +					struct hid_device, dev);
>  	struct gt683r_led *led = hid_get_drvdata(hdev);
>  
> -
>  	if (kstrtou8(buf, 10, &sysfs_mode) || sysfs_mode > 2)
>  		return -EINVAL;
>  
> @@ -212,7 +214,16 @@ fail:
>  	mutex_unlock(&led->lock);
>  }
>  
> -static DEVICE_ATTR_RW(leds_mode);
> +static DEVICE_ATTR_RW(msi_mode);
> +
> +static struct attribute *gt683r_attributes[] = {
> +	&dev_attr_msi_mode.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group gt683r_group = {
> +	.attrs = gt683r_attributes
> +};
>  
>  static int gt683r_led_probe(struct hid_device *hdev,
>  			const struct hid_device_id *id)
> @@ -261,6 +272,7 @@ static int gt683r_led_probe(struct hid_device *hdev,
>  		led->led_devs[i].name = name;
>  		led->led_devs[i].max_brightness = 1;
>  		led->led_devs[i].brightness_set = gt683r_brightness_set;
> +
>  		ret = led_classdev_register(&hdev->dev, &led->led_devs[i]);
>  		if (ret) {
>  			hid_err(hdev, "could not register led device\n");
> @@ -268,17 +280,29 @@ static int gt683r_led_probe(struct hid_device *hdev,
>  		}
>  	}
>  
> -	ret = device_create_file(&led->hdev->dev, &dev_attr_leds_mode);
> -	if (ret) {
> -		hid_err(hdev, "could not make mode attribute file\n");
> -		goto fail;
> +	for (i = 0; i < GT683R_LED_COUNT; i++) {
> +		led->dev_attr_group[i] = &gt683r_group;
> +
> +		ret = sysfs_create_group(&led->led_devs[i].dev->kobj,
> +					led->dev_attr_group[i]);

why not use sysfs_create_groups()?

And why are you doing it this way, the led device should have the
attribute group and it should be created automatically by the driver
core, no driver should need to create it like you are doing so here.

thanks,

greg k-h
