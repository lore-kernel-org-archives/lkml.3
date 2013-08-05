Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab3HEEaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 00:30:09 -0400
Received: from plane.gmane.org ([80.91.229.3]:41060 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab3HEEaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 00:30:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ian Pilcher <arequipeno@gmail.com>
Subject: LED module not creating /sys/class/leds entry
Date: Sun, 04 Aug 2013 23:27:08 -0500
Message-ID: <ktn9im$tc2$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pool-71-252-209-206.dllstx.fios.verizon.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to understand the LED API.  I have created an extremely
simple "dummy" LED module (see below), which loads without any errors,
but /sys/class/leds is empty.

Any pointers on what additional steps I need to take to get my "LED" to
show up are greatly appreciated.

Thanks!

#include <linux/leds.h>
#include <linux/module.h>
#include <linux/platform_device.h>

static enum led_brightness dummy_led_brightness = LED_OFF;

static void dummy_led_set_brightness(struct led_classdev *cdev,
				     enum led_brightness brightness)
{
	dummy_led_brightness = brightness;
}

static enum led_brightness dummy_led_get_brightness(struct led_classdev
*cdev)
{
	return dummy_led_brightness;
}

static struct led_classdev dummy_led_cdev = {
	.name = "dummy",
	.brightness_set = dummy_led_set_brightness,
	.brightness_get = dummy_led_get_brightness,
};

static int dummy_led_probe(struct platform_device *pdev)
{
	return led_classdev_register(&pdev->dev, &dummy_led_cdev);
}

static int dummy_led_remove(struct platform_device *pdev)
{
	led_classdev_unregister(&dummy_led_cdev);
	return 0;
}

static struct platform_driver dummy_led_driver = {
	.probe = dummy_led_probe,
	.remove = dummy_led_remove,
	.driver = {
		.name = "dummy-led",
		.owner = THIS_MODULE,
	},
};

static int __init dummy_led_init(void)
{
	return platform_driver_register(&dummy_led_driver);
}

static void __exit dummy_led_exit(void)
{
    platform_driver_unregister(&dummy_led_driver);
}

module_init(dummy_led_init);
module_exit(dummy_led_exit);

MODULE_LICENSE("GPL");
MODULE_DESCRIPTION("Dummy LED driver");
MODULE_AUTHOR("Ian Pilcher <arequipeno@gmail.com>");

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
Sometimes there's nothing left to do but crash and burn...or die trying.
========================================================================

