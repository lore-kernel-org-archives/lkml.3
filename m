Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934686AbaGPRT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 13:19:29 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:41029 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933237AbaGPRTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 13:19:24 -0400
MIME-Version: 1.0
In-Reply-To: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 16 Jul 2014 10:19:01 -0700
Message-ID: <CAK5ve-L67=q-EpWvxD5-x+cFT7dh8p0HHuoUbAWA-j5BqCO52A@mail.gmail.com>
Subject: Re: [PATCH/RFC v4 00/21] LED / flash API integration
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, b.zolnierkie@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 7:04 AM, Jacek Anaszewski
<j.anaszewski@samsung.com> wrote:
> This is is the fourth version of the patch series being a follow up
> of the discussion on Media summit 2013-10-23, related to the
> LED / flash API integration (the notes from the discussion were
> enclosed in the message [1], paragraph 5).
> The series is based on linux-next-20140707
>

I really apologize that I missed your discussion email in my Gmail
inbox, it was archived some where. Even in this series some of these
patches are archived in different tab.

I will start to review and help to push this.

Thanks,
-Bryan


> Description of the proposed modifications according to
> the kernel components they are relevant to:
>     - LED subsystem modifications
>         * added led_flash module which, when enabled in the config,
>           registers flash specific sysfs attributes, if the driver
>           declares related features:
>             - flash_brightness
>             - max_flash_brightness
>             - indicator_brightness
>             - max_indicator_brightness
>             - flash_timeout
>             - max_flash_timeout
>             - flash_strobe
>             - external_strobe
>             - flash_fault
>           and exposes kernel internal API:
>             - led_classdev_flash_register
>             - led_classdev_flash_unregister
>             - led_set_flash_strobe
>             - led_get_flash_strobe
>             - led_set_flash_brightness
>             - led_update_flash_brightness
>             - led_set_indicator_brightness
>             - led_update_indicator_brightness
>             - led_set_flash_timeout
>             - led_get_flash_fault
>             - led_set_external_strobe
>             - led_sysfs_lock
>             - led_sysfs_unlock
>         * added Flash Manager functionality, available when
>           led_flash module is enable in the config;
>           if the device tree node of a flash led device contains
>           relevant subnodes, it registers following sysfs attributes:
>             - strobe_provider
>             - strobe_providerN
>             - blocking_strobe
>           following kernel internal API is exposed by the flash manager:
>             - led_flash_manager_register_flash
>             - led_flash_manager_unregister_flash
>             - led_flash_manager_setup_strobe
>             - led_flash_manager_bind_async_mux
>             - led_flash_manager_unbind_async_mux
>     - Addition of a V4L2 Flash sub-device registration helpers
>         * added v4l2-flash.c and v4l2-flash.h files with helper
>           functions that facilitate registration/unregistration
>           of a subdevice, which wrapps a LED subsystem device and
>           exposes V4L2 Flash control interface
>     - Addition of a LED Flash Class driver for the flash cell of
>       the MAX77693 mfd
>     - Addition of a LED Flash Class driver for the AAT1290 current
>       regulator for flash leds along with its DT binding for the
>       exynos4412-trats2 board, where standalone multiplexer is
>       used for modifying strobe signal routing - either from the SoC
>       GPIO or from a camera sensor. This arrangment is handled
>       by the newly introduced Flash Manager functionality.
>     - Update of the max77693.txt DT bindings documentation
>     - Update of the common leds DT bindings documentation
>
> ================
> Changes since v2
> ================
>
>     - refactored the code so that it is possible to build
>       led-core without led-flash module
>     - added v4l2-flash ops which slackens dependency from
>       the led-flash module
>     - implemented led_clamp_align_val function and led_ctrl
>       structure which allows to align led control values
>       in the manner compatible with V4L2 Flash controls;
>       the flash brightness and timeout units have been defined
>       as microamperes and microseconds respectively to properly
>       support devices which define current and time levels
>       as fractions of 1/1000.
>     - added support for the flash privacy leds
>     - modified LED sysfs locking mechanism - now it locks/unlocks
>       the interface on V4L2 Flash sub-device file open/close
>     - changed hw_triggered attribute name to external_strobe,
>       which maps on the V4L2_FLASH_STROBE_SOURCE_EXTERNAL name
>       more intuitively
>     - made external_strobe and indicator related sysfs attributes
>       created optionally only if related features are declared
>       by the led device driver
>     - removed from the series patches modifying exynos4-is media
>       controller - a proposal for "flash manager" which will take
>       care of flash devices registration is due to be submitted
>     - removed modifications to the LED class devices documentation,
>       it will be covered after the whole functionality is accepted
>
> ================
> Changes since v3
> ================
>
>     - added Flash Manager feature
>       - added generic LED Flash Class gpio mux driver
>       - added sample async mux driver
>       - added of helpers for parsing Flash Manager related
>         device tree data
>     - added V4L2_CID_FLASH_STROBE_PROVIDER control
>     - introduced struct led_classdev_flash, which wrapps
>       struct led_classdev
>     - made all flash ops, except strobe_set, optional; if an op
>       is absent the related sysfs attribute isn't created
>     - added LED_DEV_CAP* flags
>     - modified v4l2-flash helpers to create v4l2_device
>       for v4l2_flash subdevices to register in it
>     - modified max77693-flash driver and its DT bindings
>       to allow for registering either one or two LED Flash
>       Class devices, depending on the device tree settings.
>     - added new API for setting torch_brightness
>     - extended leds common DT binding documentation
>
> Issues:
>
> 1) Who should register V4L2 Flash sub-device?
>
> LED Flash Class devices, after introduction of the Flash Manager,
> are not tightly coupled with any media controller. They are maintained
> by the Flash Manager and made available for dynamic assignment to
> any media system they are connected to through multiplexing devices.
>
> In the proposed rough solution, when support for V4L2 Flash sub-devices
> is enabled, there is a v4l2_device created for them to register in.
> This however implies that V4L2 Flash device will not be available
> in any media controller, which calls its existence into question.
>
> Therefore I'd like to consult possible ways of solving this issue.
> The option I see is implementing a mechanism for moving V4L2 Flash
> sub-devices between media controllers. A V4L2 Flash sub-device
> would initially be assigned to one media system in the relevant
> device tree binding, but it could be dynamically reassigned to
> the other one. However I'm not sure if media controller design
> is prepared for dynamic modifications of its graph and how many
> modifications in the existing drivers this solution would require.
>
> 2) Consequences of locking the Flash Manager during flash strobe
>
> In case a LED Flash Class device depends on muxes involved in
> routing the other LED Flash Class device's strobe signals,
> the Flash Manager must be locked for the time of strobing
> to prevent reconfiguration of the strobe signal routing
> by the other device.
>
> A blocking_strobe sysfs attribute was added to indicate whether
> this is the case for the device.
>
> Nonetheless, this modifies behaviour of led_set_external_strobe
> API, which also must block the caller for the time of strobing
> to protect the strobe signal routing while the external strobe
> signal provider asserts the flash_en pin.
>
> Use case for user space application would be following in this case:
>   - spawn a new thread in which external strobe is activated
>   - in the parent thread instruct the external strobe provider
>     to strobe the flash
>
> As an improvement there could be an op added for notifying
> the application that the strobe signal routing has been
> set up. It would have to be called from the function
> led_flash_manager_setup_strobe after led_flash_manager_set_external_strobe
> returns.
>
> The blocking_strobe attribute would have to be also
> mapped to a new V4L2 Flash control. Unfortunately it poses
> a problem for the existing users of the V4L2 Flash API
> which are not aware that setting V4L2_CID_FLASH_STROBE_SOURCE
> may be blocking.
>
> As a solution led_set_external_strobe API could be extended
> by a parameter telling whether the caller is prepared for
> the blocking call. led_flash_manager_setup_strobe should
> be extended accordingly then.
> In V4L2 "V4L2_FLASH_STROBE_SOURCE_EXTERNAL_BLOCKING" menu item
> could be added to handle this.
> With existing V4L2_FLASH_STROBE_SOURCE_EXTERNAL the flash manager
> wouldn't protect muxes against reconfiguration.
>
> TODO:
>   - switch to using V4L2 array controls
>   - add s_power op to the LED Flash Class
>
>
> I will be off-line for three weeks from now on and will respond
> to any questions after getting back.
>
>
> Thanks,
> Jacek Anaszewski
>
> Jacek Anaszewski (21):
>   leds: make brightness type consistent across whole subsystem
>   leds: implement sysfs interface locking mechanism
>   leds: Improve and export led_update_brightness
>   leds: Reorder include directives
>   leds: avoid using deprecated DEVICE_ATTR macro
>   leds: add API for setting torch brightness
>   of: add of_node_ncmp wrapper
>   leds: Add sysfs and kernel internal API for flash LEDs
>   Documentation: leds: Add description of LED Flash Class extension
>   Documentation: leds: add exemplary asynchronous mux driver
>   DT: leds: Add flash led devices related properties
>   DT: Add documentation for LED Class Flash Manger
>   v4l2-device: add v4l2_device_register_subdev_node API
>   v4l2-ctrls: add control for flash strobe signal providers
>   media: Add registration helpers for V4L2 flash
>   leds: Add support for max77693 mfd flash cell
>   DT: Add documentation for the mfd Maxim max77693
>   leds: Add driver for AAT1290 current regulator
>   of: Add Skyworks Solutions, Inc. vendor prefix
>   DT: Add documentation for the Skyworks AAT1290
>   ARM: dts: add aat1290 current regulator device node
>
>  Documentation/DocBook/media/v4l/controls.xml       |   11 +
>  Documentation/devicetree/bindings/leds/common.txt  |   16 +
>  .../devicetree/bindings/leds/leds-aat1290.txt      |   17 +
>  .../bindings/leds/leds-flash-manager.txt           |  165 +++
>  Documentation/devicetree/bindings/mfd/max77693.txt |   62 ++
>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>  Documentation/leds/leds-async-mux.c                |   65 ++
>  Documentation/leds/leds-class-flash.txt            |  126 +++
>  arch/arm/boot/dts/exynos4412-trats2.dts            |   24 +
>  drivers/leds/Kconfig                               |   28 +
>  drivers/leds/Makefile                              |    7 +
>  drivers/leds/led-class-flash.c                     |  715 +++++++++++++
>  drivers/leds/led-class.c                           |   58 +-
>  drivers/leds/led-core.c                            |   51 +-
>  drivers/leds/led-flash-gpio-mux.c                  |  102 ++
>  drivers/leds/led-flash-manager.c                   |  698 +++++++++++++
>  drivers/leds/led-triggers.c                        |   16 +-
>  drivers/leds/leds-aat1290.c                        |  455 +++++++++
>  drivers/leds/leds-max77693.c                       | 1070 ++++++++++++++++++++
>  drivers/leds/of_led_flash_manager.c                |  155 +++
>  drivers/media/v4l2-core/Kconfig                    |   11 +
>  drivers/media/v4l2-core/Makefile                   |    2 +
>  drivers/media/v4l2-core/v4l2-ctrls.c               |    2 +
>  drivers/media/v4l2-core/v4l2-device.c              |   63 +-
>  drivers/media/v4l2-core/v4l2-flash.c               |  580 +++++++++++
>  drivers/mfd/max77693.c                             |    5 +-
>  include/linux/led-class-flash.h                    |  290 ++++++
>  include/linux/led-flash-gpio-mux.h                 |   68 ++
>  include/linux/led-flash-manager.h                  |  121 +++
>  include/linux/leds.h                               |   73 +-
>  include/linux/mfd/max77693.h                       |   40 +
>  include/linux/of.h                                 |    1 +
>  include/linux/of_led_flash_manager.h               |   80 ++
>  include/media/v4l2-device.h                        |    7 +
>  include/media/v4l2-flash.h                         |  137 +++
>  include/uapi/linux/v4l2-controls.h                 |    2 +
>  36 files changed, 5272 insertions(+), 52 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/leds/leds-aat1290.txt
>  create mode 100644 Documentation/devicetree/bindings/leds/leds-flash-manager.txt
>  create mode 100644 Documentation/leds/leds-async-mux.c
>  create mode 100644 Documentation/leds/leds-class-flash.txt
>  create mode 100644 drivers/leds/led-class-flash.c
>  create mode 100644 drivers/leds/led-flash-gpio-mux.c
>  create mode 100644 drivers/leds/led-flash-manager.c
>  create mode 100644 drivers/leds/leds-aat1290.c
>  create mode 100644 drivers/leds/leds-max77693.c
>  create mode 100644 drivers/leds/of_led_flash_manager.c
>  create mode 100644 drivers/media/v4l2-core/v4l2-flash.c
>  create mode 100644 include/linux/led-class-flash.h
>  create mode 100644 include/linux/led-flash-gpio-mux.h
>  create mode 100644 include/linux/led-flash-manager.h
>  create mode 100644 include/linux/of_led_flash_manager.h
>  create mode 100644 include/media/v4l2-flash.h
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
