Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933748AbaCTOve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:51:34 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54051 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbaCTOvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:51:31 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-3a-532b00715c01
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC 0/8] LED / flash API integration
Date: Thu, 20 Mar 2014 15:51:02 +0100
Message-id: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPJMWRmVeSWpSXmKPExsVy+t9jQd1CBu1ggzXHJSxurTvHajH/CJDo
	vfqc0eJs0xt2i8u75rBZbH2zjtGiZ8NWVovDb9pZHTg8+rasYvT4vEkugCmKyyYlNSezLLVI
	3y6BK+Pl3B1sBRvlKhrW6zYwThbtYuTkkBAwkTjQvoIZwhaTuHBvPVsXIxeHkMB0RomX/VuY
	IZxOJonHf+eygFSxCRhK/HzxmgnEFhEol5g29RGYzSxQKfH56h6gbg4OYaCp1xfKg4RZBFQl
	duz7DraAV8BDYsHuucwgJRICChJzJtlMYORewMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93
	EyM4GJ5J7WBc2WBxiFGAg1GJh3fFHs1gIdbEsuLK3EOMEhzMSiK8ds+1goV4UxIrq1KL8uOL
	SnNSiw8xSnOwKInzHmi1DhQSSE8sSc1OTS1ILYLJMnFwSjUw1m1+9ZjH+tv0IMn/q/bLSl3y
	e382c0HeO4WXTYdkpzOuS9v4/X5oZ+UbvjObwj6rBfCZ3HKevsSI40G23bxlmkUJDmwZ/xbX
	HvmRKrJdKkGUcR/TDLfTz4J6a5dt2HDy2XE/9TvLzhcWPNbg5s2NCr1zJzPuK+PrLA6ucD/N
	nt/yV3xyr59+pcRSnJFoqMVcVJwIAGSBfxICAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is a follow up of the discussion on Media
summit 2013-10-23, related to the LED / flash API integration.
The notes from the discussion were enclosed in the message [1],
paragraph 5. The series is based on linux-next 20140319.

In order to show the exemplary usage of the proposed mechanism
the patch series includes implementation of a Flash LED device
driver along with the suitable modifications in a media controller
driver.

Description of the proposed modifications according to
the kernel components they are relevant to:
    - LED subsystem modifications
        * added following sysfs attributes:
            - flash_mode
            - flash_timeout
            - max_flash_timeout
            - flash_fault
            - hw_triggered
        * added following public API functions:
            - led_set_flash_mode
            - led_set_flash_timeout
            - led_get_flash_fault
            - led_set_hw_triggered
            - led_sysfs_lock
            - led_sysfs_unlock
            - led_sysfs_is_locked
            - led_is_flash_mode
        * added led_flash structure containing flash specific
	  ops and flash timeout related data
	* added led_classdev_init_flash function to be called
	  by a led driver
    - Addition of a v4l2_flash helpers
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
  media: Add registration helpers for V4L2 flash sub-devices
  media: exynos4-is: Add support for v4l2-flash subdevs
  leds: Add support for max77693 mfd flash cell
  DT: Add documentation for the mfd Maxim max77693 flash cell
  DT: Add documentation for exynos4-is camera-flash property

 .../devicetree/bindings/media/samsung-fimc.txt     |    3 +
 Documentation/devicetree/bindings/mfd/max77693.txt |   47 ++
 Documentation/leds/leds-class.txt                  |   25 +
 drivers/leds/Kconfig                               |    9 +
 drivers/leds/Makefile                              |    1 +
 drivers/leds/led-class.c                           |  222 +++++-
 drivers/leds/led-core.c                            |  141 +++-
 drivers/leds/led-triggers.c                        |   17 +-
 drivers/leds/leds-max77693.c                       |  768 ++++++++++++++++++++
 drivers/leds/leds.h                                |    9 +
 drivers/media/platform/exynos4-is/media-dev.c      |   34 +-
 drivers/media/platform/exynos4-is/media-dev.h      |   14 +-
 drivers/media/v4l2-core/Makefile                   |    2 +-
 drivers/media/v4l2-core/v4l2-flash.c               |  320 ++++++++
 drivers/mfd/max77693.c                             |   21 +-
 include/linux/leds.h                               |  146 ++++
 include/linux/mfd/max77693.h                       |   32 +
 include/media/v4l2-flash.h                         |  102 +++
 18 files changed, 1879 insertions(+), 34 deletions(-)
 create mode 100644 drivers/leds/leds-max77693.c
 create mode 100644 drivers/media/v4l2-core/v4l2-flash.c
 create mode 100644 include/media/v4l2-flash.h

-- 
1.7.9.5

