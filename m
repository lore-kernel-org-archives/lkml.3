Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbaC1P3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 11:29:22 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40144 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaC1P3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 11:29:19 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-ae-5335954dd07e
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v2 0/8] LED / flash API integration
Date: Fri, 28 Mar 2014 16:28:57 +0100
Message-id: <1396020545-15727-1-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIJMWRmVeSWpSXmKPExsVy+t9jQV3fqabBBvfPmlncWneO1WL+ESDR
	e/U5o8XZpjfsFpd3zWGz2PpmHaNFz4atrBaH37SzOnB49G1ZxejxeZNcAFMUl01Kak5mWWqR
	vl0CV8a8A3vZC9qUKva8/8rewPhIvIuRk0NCwESi9+A2JghbTOLCvfVsXYxcHEIC0xklmq/O
	YIdwOpkkrv6Zwg5SxSZgKPHzxWuwDhGBcolpUx+B2cwClRKfr+5hA7GFBcwlPl2bBlbPIqAq
	MXXmPrA4r4CHRHPTPOYuRg6gbQoScybZTGDkXsDIsIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/
	dxMjOCCeSe1gXNlgcYhRgINRiYdXoNU0WIg1say4MvcQowQHs5IIb9ZEoBBvSmJlVWpRfnxR
	aU5q8SFGaQ4WJXHeA63WgUIC6YklqdmpqQWpRTBZJg5OqQbGHhN27YVZ6o09SzQ7s58e32hc
	Y6HwN+RszJ05Xdvvbtpiay/zbrqizavOZ+/3+smdirsrELa1uo1pUs2kc1UvxSoSvky08I9U
	njd/r1aEU3LE34UtYnprnOZ2cHbLLIxZc7KwMFX1QZz5tNnB6Skzt+7nUhZPC21o7V28b9l3
	bf3VSrUyb3mUWIozEg21mIuKEwEajs/FBAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is is a second version of the patch series being a follow up
of the discussion on Media summit 2013-10-23, related to the
LED / flash API integration (the notes from the discussion were
enclosed in the message [1], paragraph 5).
The series is based on linux-next next-20140328 and contains
significant number of modifications in comparison to its first
version (Lee, Richard and Sakari - thanks for the review).

In order to show the exemplary usage of the proposed mechanism
the patch series includes implementation of a Flash LED device
driver along with the suitable modifications in a media controller
driver.

Description of the proposed modifications according to
the kernel components they are relevant to:
    - LED subsystem modifications
        * added led_flash module which, when enabled in the config,
	  registers flash specific sysfs attributes:
            - flash_brightness
	    - max_flash_brightness
            - flash_timeout
            - max_flash_timeout
	    - flash_strobe
            - flash_fault
            - hw_triggered
	and exposes kernel internal API
            - led_set_flash_strobe
            - led_get_flash_strobe
            - led_set_flash_brightness
            - led_update_flash_brightness
            - led_set_flash_timeout
            - led_get_flash_fault
            - led_set_hw_triggered
            - led_sysfs_lock
            - led_sysfs_unlock
    - Addition of a V4L2 Flash sub-device registration helpers
        * added v4l2-flash.c and v4l2-flash.h files with helper
          functions that facilitate registration/unregistration
          of a subdevice, which wrapps a LED subsystem device and
          exposes V4L2 Flash control interface
    - exynos4-is media controller modifications
    - Addition of a driver for the flash cell of the MAX77693 mfd
        * the driver exploits the newly introduced mechanism
    - Update of the samsung-fimc.txt DT bindings documentation
    - Update of the max77693.txt DT bindings documentation
    - Update of the LED subsystem documentation

Thanks,
Jacek Anaszewski

[1] http://www.spinics.net/lists/linux-media/msg69253.html

Jacek Anaszewski (8):
  leds: Add sysfs and kernel internal API for flash LEDs
  leds: Improve and export led_update_brightness function
  Documentation: leds: Add description of flash mode
  leds: Add support for max77693 mfd flash cell
  DT: Add documentation for the mfd Maxim max77693 flash cell
  media: Add registration helpers for V4L2 flash sub-devices
  media: exynos4-is: Add support for v4l2-flash subdevs
  DT: Add documentation for exynos4-is camera-flash property

 .../devicetree/bindings/media/samsung-fimc.txt     |    3 +
 Documentation/devicetree/bindings/mfd/max77693.txt |   47 ++
 Documentation/leds/leds-class.txt                  |   52 ++
 drivers/leds/Kconfig                               |   18 +
 drivers/leds/Makefile                              |    2 +
 drivers/leds/led-class.c                           |   62 +-
 drivers/leds/led-core.c                            |   17 +
 drivers/leds/led-flash.c                           |  375 +++++++++
 drivers/leds/led-triggers.c                        |   16 +-
 drivers/leds/leds-max77693.c                       |  864 ++++++++++++++++++++
 drivers/leds/leds.h                                |    3 +
 drivers/media/platform/exynos4-is/media-dev.c      |   34 +-
 drivers/media/platform/exynos4-is/media-dev.h      |   14 +-
 drivers/media/v4l2-core/Kconfig                    |   10 +
 drivers/media/v4l2-core/Makefile                   |    2 +
 drivers/media/v4l2-core/v4l2-flash.c               |  302 +++++++
 drivers/mfd/max77693.c                             |    3 +-
 include/linux/leds.h                               |   34 +-
 include/linux/leds_flash.h                         |  189 +++++
 include/linux/mfd/max77693.h                       |   32 +
 include/media/v4l2-flash.h                         |  104 +++
 21 files changed, 2157 insertions(+), 26 deletions(-)
 create mode 100644 drivers/leds/led-flash.c
 create mode 100644 drivers/leds/leds-max77693.c
 create mode 100644 drivers/media/v4l2-core/v4l2-flash.c
 create mode 100644 include/linux/leds_flash.h
 create mode 100644 include/media/v4l2-flash.h

-- 
1.7.9.5

