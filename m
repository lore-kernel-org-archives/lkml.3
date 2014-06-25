Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbaFYRlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 13:41:45 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:49951 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910AbaFYRln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 13:41:43 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 25 Jun 2014 19:41:09 +0200
From: Johan Hovold <johan@kernel.org>
To: Janne Kanniainen <janne.kanniainen@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Cc: johan@kernel.org, greg@kroah.com, bjorn@mork.no, cooloney@gmail.com,
        linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] HID: leds: Use attribute-groups in MSI GT683R
 driver
Message-ID: <20140625174109.GE1409@localhost>
References: <20140625115541.GA1409@localhost>
 <1403711966-13003-1-git-send-email-janne.kanniainen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403711966-13003-1-git-send-email-janne.kanniainen@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 06:59:26PM +0300, Janne Kanniainen wrote:
> Use attribute-groups to fix race condition.

The primary thing you're doing here is moving and renaming the attribute
to the led class devices, so you need to mention that (and update the
patch subject). But you can mention the race as well.

> Signed-off-by: Janne Kanniainen <janne.kanniainen@gmail.com>
> ---
>  .../ABI/testing/sysfs-class-hid-driver-gt683r      |  6 +++--
>  drivers/hid/hid-gt683r.c                           | 31 +++++++++++++---------
>  2 files changed, 22 insertions(+), 15 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r b/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
> index 317e9d5..c97970a 100644
> --- a/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r
> +++ b/Documentation/ABI/testing/sysfs-class-hid-driver-gt683r

I think you need to rename this file as well to
sysfs-class-leds-driver-gt683r (use git mv).
	
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

Missing period ('.').

>  
>  		0 - normal
>  		1 - audio
> diff --git a/drivers/hid/hid-gt683r.c b/drivers/hid/hid-gt683r.c
> index 073bd80..aba6636 100644
> --- a/drivers/hid/hid-gt683r.c
> +++ b/drivers/hid/hid-gt683r.c
> @@ -84,12 +84,13 @@ static void gt683r_brightness_set(struct led_classdev *led_cdev,
>  	}
>  }
>  
> -static ssize_t leds_mode_show(struct device *dev,
> +static ssize_t msi_mode_show(struct device *led_dev,

No need to rename dev.

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
> @@ -102,15 +103,15 @@ static ssize_t leds_mode_show(struct device *dev,
>  	return scnprintf(buf, PAGE_SIZE, "%u\n", sysfs_mode);
>  }
>  
> -static ssize_t leds_mode_store(struct device *dev,
> +static ssize_t msi_mode_store(struct device *led_dev,

Same here.

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

You should not include random whitespace fixes in your patches (there
are two more below). If needed you can do that in a separate patch.

>  	if (kstrtou8(buf, 10, &sysfs_mode) || sysfs_mode > 2)
>  		return -EINVAL;
>  
> @@ -212,7 +213,14 @@ fail:
>  	mutex_unlock(&led->lock);
>  }
>  
> -static DEVICE_ATTR_RW(leds_mode);
> +static DEVICE_ATTR_RW(msi_mode);
> +
> +static struct attribute *gt683r_led_attrs[] = {
> +	&dev_attr_msi_mode.attr,
> +	NULL
> +};
> +
> +ATTRIBUTE_GROUPS(gt683r_led);
>  
>  static int gt683r_led_probe(struct hid_device *hdev,
>  			const struct hid_device_id *id)
> @@ -261,6 +269,8 @@ static int gt683r_led_probe(struct hid_device *hdev,
>  		led->led_devs[i].name = name;
>  		led->led_devs[i].max_brightness = 1;
>  		led->led_devs[i].brightness_set = gt683r_brightness_set;
> +		led->led_devs[i].groups = gt683r_led_groups;
> +

Great. This fixes the race with userspace.

Did you see the attribute-race series I posted? Not sure how best to
handle the dependency, as those patches should probably go in through
the LEDs tree, while the first patch in that series (adding the groups
field) is a dependency for this patch.

Jiri, how would this best be solved?

Thanks,
Johan

>  		ret = led_classdev_register(&hdev->dev, &led->led_devs[i]);
>  		if (ret) {
>  			hid_err(hdev, "could not register led device\n");
> @@ -268,17 +278,12 @@ static int gt683r_led_probe(struct hid_device *hdev,
>  		}
>  	}
>  
> -	ret = device_create_file(&led->hdev->dev, &dev_attr_leds_mode);
> -	if (ret) {
> -		hid_err(hdev, "could not make mode attribute file\n");
> -		goto fail;
> -	}
> -
>  	return 0;
>  
>  fail:
>  	for (i = i - 1; i >= 0; i--)
>  		led_classdev_unregister(&led->led_devs[i]);
> +
>  	hid_hw_stop(hdev);
>  	return ret;
>  }
> @@ -288,9 +293,9 @@ static void gt683r_led_remove(struct hid_device *hdev)
>  	int i;
>  	struct gt683r_led *led = hid_get_drvdata(hdev);
>  
> -	device_remove_file(&hdev->dev, &dev_attr_leds_mode);
>  	for (i = 0; i < GT683R_LED_COUNT; i++)
>  		led_classdev_unregister(&led->led_devs[i]);
> +
>  	flush_work(&led->work);
>  	hid_hw_stop(hdev);
>  }
