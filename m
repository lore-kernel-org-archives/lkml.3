Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772AbaDKO5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 10:57:22 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:14518 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaDKO5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 10:57:18 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-06-534802cca094
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v3 0/5] LED / flash API integration
Date: Fri, 11 Apr 2014 16:56:51 +0200
Message-id: <1397228216-6657-1-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAJMWRmVeSWpSXmKPExsVy+t9jAd0zTB7BBr3zVS1urTvHajH/CJDo
	vfqc0eJs0xt2i8u75rBZbH2zjtGiZ8NWVovDb9pZHTg8+rasYvT4vEkugCmKyyYlNSezLLVI
	3y6BK+PQ6mNsBb/UKq52rGVrYFwg3cXIySEhYCJxfkMLG4QtJnHh3nogm4tDSGARo8TsxStY
	IZx2Jon+r0sZQarYBAwlfr54zQRiiwiUS0yb+gjMZhaolPh8dQ/YJGEBc4nGaw/AbBYBVYm2
	znssXYwcHLwC7hI39/mAmBICChJzJtlMYORewMiwilE0tSC5oDgpPddIrzgxt7g0L10vOT93
	EyM4HJ5J72Bc1WBxiFGAg1GJh/fAJbdgIdbEsuLK3EOMEhzMSiK8m666BwvxpiRWVqUW5ccX
	leakFh9ilOZgURLnPdhqHSgkkJ5YkpqdmlqQWgSTZeLglGpg1DR/9c//5Is9b2+wtBhXp60I
	5q/6tmz1Mfa29Lgt/d1HznYv5vh2p+/6kftq69QrLrjo+7bPvNN1yDW7bc+8axsz5P/MupY2
	b4XR0b8JTrl1ga57rViXN6w7LLrofqDBy+SZ5ZVHvqdFmYmYZKjoLlv6KvavalrjYYGCP6++
	Swr2L1nBM5ktU4mlOCPRUIu5qDgRAMn19hEDAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is is the third version of the patch series being a follow up
of the discussion on Media summit 2013-10-23, related to the
LED / flash API integration (the notes from the discussion were
enclosed in the message [1], paragraph 5).
The series is based on linux-next next-20140328

Description of the proposed modifications according to
the kernel components they are relevant to:
    - LED subsystem modifications
        * added led_flash module which, when enabled in the config,
	  registers flash specific sysfs attributes:
            - flash_brightness
	    - max_flash_brightness
	    - indicator_brightness
	    - max_indicator_brightness
            - flash_timeout
            - max_flash_timeout
	    - flash_strobe
            - flash_fault
            - external_strobe
	and exposes kernel internal API
            - led_set_flash_strobe
            - led_get_flash_strobe
            - led_set_indicator_brightness
            - led_update_indicator_brightness
            - led_set_flash_timeout
            - led_get_flash_fault
            - led_set_external_strobe
            - led_sysfs_lock
            - led_sysfs_unlock
    - Addition of a V4L2 Flash sub-device registration helpers
        * added v4l2-flash.c and v4l2-flash.h files with helper
          functions that facilitate registration/unregistration
          of a subdevice, which wrapps a LED subsystem device and
          exposes V4L2 Flash control interface
    - Addition of a driver for the flash cell of the MAX77693 mfd
        * the driver exploits the newly introduced mechanism
    - Update of the max77693.txt DT bindings documentation

================
Changes since v2
================

    - refactored the code so that it is possible to build
      led-core without led-flash module
    - added v4l2-flash ops which slackens dependency from
      the led-flash module
    - implemented led_clamp_align_val function and led_ctrl
      structure which allows to align led control values
      in the manner compatible with V4L2 Flash controls;
      the flash brightness and timeout units have been defined
      as microamperes and microseconds respectively to properly
      support devices which define current and time levels
      as fractions of 1/1000.
    - added support for the flash privacy leds
    - modified LED sysfs locking mechanism - now it locks/unlocks
      the interface on V4L2 Flash sub-device file open/close
    - changed hw_triggered attribute name to external_strobe,
      which maps on the V4L2_FLASH_STROBE_SOURCE_EXTERNAL name 
      more intuitively
    - made external_strobe and indicator related sysfs attributes
      created optionally only if related features are declared
      by the led device driver
    - removed from the series patches modifying exynos4-is media
      controller - a proposal for "flash manager" which will take
      care of flash devices registration is due to be submitted
    - removed modifications to the LED class devices documentation,
      it will be covered after the whole functionality is accepted

Thanks,
Jacek Anaszewski

[1] http://www.spinics.net/lists/linux-media/msg69253.html

Jacek Anaszewski (5):
  leds: Add sysfs and kernel internal API for flash LEDs
  leds: Improve and export led_update_brightness function
  leds: Add support for max77693 mfd flash cell
  DT: Add documentation for the mfd Maxim max77693 flash cell
  media: Add registration helpers for V4L2 flash sub-devices

 Documentation/devicetree/bindings/mfd/max77693.txt |   57 ++
 drivers/leds/Kconfig                               |   18 +
 drivers/leds/Makefile                              |    2 +
 drivers/leds/led-class.c                           |   42 +-
 drivers/leds/led-core.c                            |   16 +
 drivers/leds/led-flash.c                           |  627 ++++++++++++++++
 drivers/leds/led-triggers.c                        |   16 +-
 drivers/leds/leds-max77693.c                       |  794 ++++++++++++++++++++
 drivers/leds/leds.h                                |    6 +
 drivers/media/v4l2-core/Kconfig                    |   10 +
 drivers/media/v4l2-core/Makefile                   |    2 +
 drivers/media/v4l2-core/v4l2-flash.c               |  393 ++++++++++
 drivers/mfd/max77693.c                             |    2 +-
 include/linux/leds.h                               |   60 +-
 include/linux/leds_flash.h                         |  252 +++++++
 include/linux/mfd/max77693.h                       |   38 +
 include/media/v4l2-flash.h                         |  119 +++
 17 files changed, 2433 insertions(+), 21 deletions(-)
 create mode 100644 drivers/leds/led-flash.c
 create mode 100644 drivers/leds/leds-max77693.c
 create mode 100644 drivers/media/v4l2-core/v4l2-flash.c
 create mode 100644 include/linux/leds_flash.h
 create mode 100644 include/media/v4l2-flash.h

-- 
1.7.9.5

