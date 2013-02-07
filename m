Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313Ab3BGA6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 19:58:47 -0500
Received: from mga01.intel.com ([192.55.52.88]:56721 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab3BGA6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 19:58:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,619,1355126400"; 
   d="scan'208";a="287605608"
Message-ID: <5112FC44.2000303@linux.intel.com>
Date: Wed, 06 Feb 2013 16:58:44 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Denis Turischev <denis@compulab.co.il>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: gpio-sch GPIO_SYSFS access
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm working with a TunnelCreek + EG20T platform which has two GPIO drivers:

gpio-sch - for the CPU GPIO lines
gpio-pch - for the EG20T GPIO lines

I can see the PCH GPIO lines in /sys/class/gpio, but not the CPU lines:

# dmesg | grep -i gpio
pch_gpio 0000:03:00.2: enabling device (0000 -> 0002)

gpiochip_find_base: found new base at 244

gpiochip_add: registered GPIOs 244 to 255 on device: 0000:03:00.2

gpiochip_add: registered GPIOs 0 to 4 on device: sch_gpio_core

gpiochip_add: registered GPIOs 5 to 13 on device: sch_gpio_resume

gpio_request: gpio-0 (sysfs) status -22

gpio_request: gpio-243 (sysfs) status -22

gpio_request: gpio-256 (sysfs) status -22


# ls /sys/class/gpio
export       gpiochip244  unexport

I can export 244-255 and manipulate and read them through the
sys interface. I cannot seem to access 0-13, although the dmesg
above seems to have successfully added them (and the core/resume
pin mapping is correct for a TunnelCreek CPU).

I'm not seeing any obvious difference in how the two drivers probe and
setup the chip that explains why one is accessible and the other is not.

I've enabled the following GPIO CONFIG* options:
$ cat config-minnow.gpio | grep -e "^CONFIG_.*GPIO"
CONFIG_GENERIC_GPIO=y
CONFIG_KEYBOARD_GPIO=y
CONFIG_KEYBOARD_GPIO_POLLED=y
CONFIG_SPI_GPIO=y
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_SYSFS=y
CONFIG_GPIO_GENERIC=y
CONFIG_GPIO_GENERIC_PLATFORM=y
CONFIG_GPIO_SCH=y
CONFIG_GPIO_PCH=y
CONFIG_LEDS_GPIO=y

I'm working with 3.4.26, but I have not seen anything in the gpio-sch.c
driver commit log that would suggest a fix has landed. I suspect I am
missing something fundamental about how these lines get exported.

Any ideas on what I might be missing?

Is it that some other driver has claimed these GPIO lines? If so, how do
I determine which one?

Thanks!

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
