Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbaGKOEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:04:36 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49142 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbaGKOEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:04:33 -0400
X-AuditID: cbfee61b-f79f86d00000144c-d4-53bfeeeeaa6c
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v4 00/21] LED / flash API integration
Date: Fri, 11 Jul 2014 16:04:03 +0200
Message-id: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNJMWRmVeSWpSXmKPExsVy+t9jQd337/YHG6xYxmSxccZ6Vov5R86x
	WvRefc5ocbbpDbvF5V1z2Cy2vlnHaNGzYSurA7tH35ZVjB6fN8kFMEVx2aSk5mSWpRbp2yVw
	ZVy8uIq9YGpaxZUZ91kbGL97dzFyckgImEjs3vmOHcIWk7hwbz1bFyMXh5DAdEaJydN+MYIk
	hATamSR+LpYEsdkEDCV+vnjNBGKLCJRL9Lx/xgZiMwukSaxZfx+sXljAUmLt/cVgNSwCqhJL
	+lrA4rwCHhLbr/YBxTmAlilIzJlkM4GRewEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M
	4CB4Jr2DcVWDxSFGAQ5GJR7eE2v2BQuxJpYVV+YeYpTgYFYS4b36Zn+wEG9KYmVValF+fFFp
	TmrxIUZpDhYlcd6DrdaBQgLpiSWp2ampBalFMFkmDk6pBkbNEh/x9PtJO/g73kz6+pvng8wq
	rWOqtc65olZe066IXM58XZWm/KUzgn/Zzfq06TNXHTuT9eFSorzY2mNTjl5uuDmnOnF1t+wS
	fkO9xRMad93qqArY1MBy+FnmR9cFvXHMYvUuZ17vcN4Uf7rG9UiU5bPEI6eOPT9m27NNSpGN
	afajiX9VOXWVWIozEg21mIuKEwErdXzH/gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is is the fourth version of the patch series being a follow up
of the discussion on Media summit 2013-10-23, related to the
LED / flash API integration (the notes from the discussion were
enclosed in the message [1], paragraph 5).
The series is based on linux-next-20140707

Description of the proposed modifications according to
the kernel components they are relevant to:
    - LED subsystem modifications
        * added led_flash module which, when enabled in the config,
          registers flash specific sysfs attributes, if the driver
	  declares related features:
            - flash_brightness
            - max_flash_brightness
            - indicator_brightness
            - max_indicator_brightness
            - flash_timeout
            - max_flash_timeout
            - flash_strobe
            - external_strobe
            - flash_fault
          and exposes kernel internal API:
            - led_classdev_flash_register
            - led_classdev_flash_unregister
            - led_set_flash_strobe
            - led_get_flash_strobe
            - led_set_flash_brightness
            - led_update_flash_brightness
            - led_set_indicator_brightness
            - led_update_indicator_brightness
            - led_set_flash_timeout
            - led_get_flash_fault
            - led_set_external_strobe
            - led_sysfs_lock
            - led_sysfs_unlock
        * added Flash Manager functionality, available when
          led_flash module is enable in the config;
          if the device tree node of a flash led device contains
          relevant subnodes, it registers following sysfs attributes:
            - strobe_provider
            - strobe_providerN
            - blocking_strobe
          following kernel internal API is exposed by the flash manager:
            - led_flash_manager_register_flash
            - led_flash_manager_unregister_flash 
            - led_flash_manager_setup_strobe
            - led_flash_manager_bind_async_mux
            - led_flash_manager_unbind_async_mux
    - Addition of a V4L2 Flash sub-device registration helpers
        * added v4l2-flash.c and v4l2-flash.h files with helper
          functions that facilitate registration/unregistration
          of a subdevice, which wrapps a LED subsystem device and
          exposes V4L2 Flash control interface
    - Addition of a LED Flash Class driver for the flash cell of
      the MAX77693 mfd
    - Addition of a LED Flash Class driver for the AAT1290 current
      regulator for flash leds along with its DT binding for the
      exynos4412-trats2 board, where standalone multiplexer is
      used for modifying strobe signal routing - either from the SoC
      GPIO or from a camera sensor. This arrangment is handled
      by the newly introduced Flash Manager functionality.
    - Update of the max77693.txt DT bindings documentation
    - Update of the common leds DT bindings documentation

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

================
Changes since v3
================

    - added Flash Manager feature
      - added generic LED Flash Class gpio mux driver
      - added sample async mux driver
      - added of helpers for parsing Flash Manager related
        device tree data
    - added V4L2_CID_FLASH_STROBE_PROVIDER control
    - introduced struct led_classdev_flash, which wrapps
      struct led_classdev
    - made all flash ops, except strobe_set, optional; if an op
      is absent the related sysfs attribute isn't created
    - added LED_DEV_CAP* flags
    - modified v4l2-flash helpers to create v4l2_device
      for v4l2_flash subdevices to register in it
    - modified max77693-flash driver and its DT bindings
      to allow for registering either one or two LED Flash
      Class devices, depending on the device tree settings.
    - added new API for setting torch_brightness
    - extended leds common DT binding documentation

Issues:

1) Who should register V4L2 Flash sub-device?

LED Flash Class devices, after introduction of the Flash Manager,
are not tightly coupled with any media controller. They are maintained
by the Flash Manager and made available for dynamic assignment to
any media system they are connected to through multiplexing devices.

In the proposed rough solution, when support for V4L2 Flash sub-devices
is enabled, there is a v4l2_device created for them to register in.
This however implies that V4L2 Flash device will not be available
in any media controller, which calls its existence into question.

Therefore I'd like to consult possible ways of solving this issue.
The option I see is implementing a mechanism for moving V4L2 Flash
sub-devices between media controllers. A V4L2 Flash sub-device
would initially be assigned to one media system in the relevant
device tree binding, but it could be dynamically reassigned to
the other one. However I'm not sure if media controller design
is prepared for dynamic modifications of its graph and how many
modifications in the existing drivers this solution would require.

2) Consequences of locking the Flash Manager during flash strobe

In case a LED Flash Class device depends on muxes involved in
routing the other LED Flash Class device's strobe signals,
the Flash Manager must be locked for the time of strobing
to prevent reconfiguration of the strobe signal routing
by the other device.

A blocking_strobe sysfs attribute was added to indicate whether
this is the case for the device.

Nonetheless, this modifies behaviour of led_set_external_strobe
API, which also must block the caller for the time of strobing
to protect the strobe signal routing while the external strobe
signal provider asserts the flash_en pin.

Use case for user space application would be following in this case:
  - spawn a new thread in which external strobe is activated
  - in the parent thread instruct the external strobe provider
    to strobe the flash

As an improvement there could be an op added for notifying
the application that the strobe signal routing has been
set up. It would have to be called from the function
led_flash_manager_setup_strobe after led_flash_manager_set_external_strobe
returns.

The blocking_strobe attribute would have to be also
mapped to a new V4L2 Flash control. Unfortunately it poses
a problem for the existing users of the V4L2 Flash API
which are not aware that setting V4L2_CID_FLASH_STROBE_SOURCE
may be blocking.

As a solution led_set_external_strobe API could be extended
by a parameter telling whether the caller is prepared for
the blocking call. led_flash_manager_setup_strobe should
be extended accordingly then.
In V4L2 "V4L2_FLASH_STROBE_SOURCE_EXTERNAL_BLOCKING" menu item
could be added to handle this.
With existing V4L2_FLASH_STROBE_SOURCE_EXTERNAL the flash manager
wouldn't protect muxes against reconfiguration.

TODO:
  - switch to using V4L2 array controls 
  - add s_power op to the LED Flash Class


I will be off-line for three weeks from now on and will respond
to any questions after getting back.


Thanks,
Jacek Anaszewski

Jacek Anaszewski (21):
  leds: make brightness type consistent across whole subsystem
  leds: implement sysfs interface locking mechanism
  leds: Improve and export led_update_brightness
  leds: Reorder include directives
  leds: avoid using deprecated DEVICE_ATTR macro
  leds: add API for setting torch brightness
  of: add of_node_ncmp wrapper
  leds: Add sysfs and kernel internal API for flash LEDs
  Documentation: leds: Add description of LED Flash Class extension
  Documentation: leds: add exemplary asynchronous mux driver
  DT: leds: Add flash led devices related properties
  DT: Add documentation for LED Class Flash Manger
  v4l2-device: add v4l2_device_register_subdev_node API
  v4l2-ctrls: add control for flash strobe signal providers
  media: Add registration helpers for V4L2 flash
  leds: Add support for max77693 mfd flash cell
  DT: Add documentation for the mfd Maxim max77693
  leds: Add driver for AAT1290 current regulator
  of: Add Skyworks Solutions, Inc. vendor prefix
  DT: Add documentation for the Skyworks AAT1290
  ARM: dts: add aat1290 current regulator device node

 Documentation/DocBook/media/v4l/controls.xml       |   11 +
 Documentation/devicetree/bindings/leds/common.txt  |   16 +
 .../devicetree/bindings/leds/leds-aat1290.txt      |   17 +
 .../bindings/leds/leds-flash-manager.txt           |  165 +++
 Documentation/devicetree/bindings/mfd/max77693.txt |   62 ++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 Documentation/leds/leds-async-mux.c                |   65 ++
 Documentation/leds/leds-class-flash.txt            |  126 +++
 arch/arm/boot/dts/exynos4412-trats2.dts            |   24 +
 drivers/leds/Kconfig                               |   28 +
 drivers/leds/Makefile                              |    7 +
 drivers/leds/led-class-flash.c                     |  715 +++++++++++++
 drivers/leds/led-class.c                           |   58 +-
 drivers/leds/led-core.c                            |   51 +-
 drivers/leds/led-flash-gpio-mux.c                  |  102 ++
 drivers/leds/led-flash-manager.c                   |  698 +++++++++++++
 drivers/leds/led-triggers.c                        |   16 +-
 drivers/leds/leds-aat1290.c                        |  455 +++++++++
 drivers/leds/leds-max77693.c                       | 1070 ++++++++++++++++++++
 drivers/leds/of_led_flash_manager.c                |  155 +++
 drivers/media/v4l2-core/Kconfig                    |   11 +
 drivers/media/v4l2-core/Makefile                   |    2 +
 drivers/media/v4l2-core/v4l2-ctrls.c               |    2 +
 drivers/media/v4l2-core/v4l2-device.c              |   63 +-
 drivers/media/v4l2-core/v4l2-flash.c               |  580 +++++++++++
 drivers/mfd/max77693.c                             |    5 +-
 include/linux/led-class-flash.h                    |  290 ++++++
 include/linux/led-flash-gpio-mux.h                 |   68 ++
 include/linux/led-flash-manager.h                  |  121 +++
 include/linux/leds.h                               |   73 +-
 include/linux/mfd/max77693.h                       |   40 +
 include/linux/of.h                                 |    1 +
 include/linux/of_led_flash_manager.h               |   80 ++
 include/media/v4l2-device.h                        |    7 +
 include/media/v4l2-flash.h                         |  137 +++
 include/uapi/linux/v4l2-controls.h                 |    2 +
 36 files changed, 5272 insertions(+), 52 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-aat1290.txt
 create mode 100644 Documentation/devicetree/bindings/leds/leds-flash-manager.txt
 create mode 100644 Documentation/leds/leds-async-mux.c
 create mode 100644 Documentation/leds/leds-class-flash.txt
 create mode 100644 drivers/leds/led-class-flash.c
 create mode 100644 drivers/leds/led-flash-gpio-mux.c
 create mode 100644 drivers/leds/led-flash-manager.c
 create mode 100644 drivers/leds/leds-aat1290.c
 create mode 100644 drivers/leds/leds-max77693.c
 create mode 100644 drivers/leds/of_led_flash_manager.c
 create mode 100644 drivers/media/v4l2-core/v4l2-flash.c
 create mode 100644 include/linux/led-class-flash.h
 create mode 100644 include/linux/led-flash-gpio-mux.h
 create mode 100644 include/linux/led-flash-manager.h
 create mode 100644 include/linux/of_led_flash_manager.h
 create mode 100644 include/media/v4l2-flash.h

-- 
1.7.9.5

