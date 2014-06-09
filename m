Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569AbaFIQEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 12:04:32 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50289 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752662AbaFIQE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 12:04:26 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        David Airlie <airlied@linux.ie>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v2 0/7] drm: add support for Atmel HLCDC Display Controller
Date: Mon,  9 Jun 2014 18:04:13 +0200
Message-Id: <1402329860-27520-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series adds support for Atmel HLCDC (High LCD Controller)
available on some Atmel SoCs (i.e. the sama5d3 family).

The HLCDC actually provides a Display Controller and a PWM device, hence I
decided to declare an MFD device that exposes 2 subdevices: a display
controller and a PWM chip.
This also solves a circular dependency issue preventing HLCDC driver from
unloading.
The HLCDC request a drm_panel device, which request a backlight device
(a PWM backlight), which depends on a PWM which is provided by the HLCDC
driver (hlcdc -> panel -> backlight -> hlcdc (pwm part)).

The current implementation only support sama5d3 SoCs but other SoCs should
be easily ported by defining new compatible strings and adding HLCDC
description structures for these SoCs.

The drivers supports basic CRTC functionalities, several overlays and an
hardware cursor.

It alse supports several RGB format on all planes and some YUV formats on
the HEO overlay plane, though YUV formats have not been tested yet.

Best Regards,

Boris

Changes since v1:
- replace the backlight driver by a PWM driver
- make use of drm_panel infrastructure
- split driver code in several subsystem: MFD, PWM and DRM
- add support for overlays
- add support for hardware cursor

Boris BREZILLON (7):
  mfd: add atmel-hlcdc driver
  pwm: add support for atmel-hlcdc-pwm device
  drm: add Atmel HLCDC Display Controller support
  ARM: AT91/dt: split sama5d3 lcd pin definitions to match RGB mode
    configs
  ARM: at91/dt: define the HLCDC node available on sama5d3 SoCs
  ARM: at91/dt: add LCD panel description to sama5d3xdm.dtsi
  ARM: at91/dt: enable the LCD panel on sama5d3xek boards

 .../devicetree/bindings/drm/atmel-hlcdc-dc.txt     |  59 ++
 .../devicetree/bindings/mfd/atmel-hlcdc.txt        |  41 ++
 .../devicetree/bindings/pwm/atmel-hlcdc-pwm.txt    |  40 ++
 arch/arm/boot/dts/sama5d31ek.dts                   |  24 +
 arch/arm/boot/dts/sama5d33ek.dts                   |  24 +
 arch/arm/boot/dts/sama5d34ek.dts                   |  24 +
 arch/arm/boot/dts/sama5d36ek.dts                   |  24 +
 arch/arm/boot/dts/sama5d3_lcd.dtsi                 | 153 ++++-
 arch/arm/boot/dts/sama5d3xdm.dtsi                  |  32 +
 drivers/gpu/drm/Kconfig                            |   2 +
 drivers/gpu/drm/Makefile                           |   1 +
 drivers/gpu/drm/atmel-hlcdc/Kconfig                |  11 +
 drivers/gpu/drm/atmel-hlcdc/Makefile               |   7 +
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c     | 529 ++++++++++++++++
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.c       | 477 ++++++++++++++
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.h       | 178 ++++++
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.c    | 701 +++++++++++++++++++++
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.h    | 417 ++++++++++++
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_panel.c    | 351 +++++++++++
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c    | 658 +++++++++++++++++++
 drivers/gpu/drm/atmel_hlcdc/Kconfig                |  11 +
 drivers/gpu/drm/atmel_hlcdc/Makefile               |   8 +
 drivers/mfd/Kconfig                                |  11 +
 drivers/mfd/Makefile                               |   1 +
 drivers/mfd/atmel-hlcdc.c                          | 116 ++++
 drivers/pwm/Kconfig                                |   9 +
 drivers/pwm/Makefile                               |   1 +
 drivers/pwm/pwm-atmel-hlcdc.c                      | 216 +++++++
 include/linux/mfd/atmel-hlcdc.h                    |  78 +++
 29 files changed, 4173 insertions(+), 31 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/drm/atmel-hlcdc-dc.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/atmel-hlcdc.txt
 create mode 100644 Documentation/devicetree/bindings/pwm/atmel-hlcdc-pwm.txt
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/Kconfig
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/Makefile
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.c
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.h
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.c
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.h
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_panel.c
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
 create mode 100644 drivers/gpu/drm/atmel_hlcdc/Kconfig
 create mode 100644 drivers/gpu/drm/atmel_hlcdc/Makefile
 create mode 100644 drivers/mfd/atmel-hlcdc.c
 create mode 100644 drivers/pwm/pwm-atmel-hlcdc.c
 create mode 100644 include/linux/mfd/atmel-hlcdc.h

-- 
1.8.3.2

