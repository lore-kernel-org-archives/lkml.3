Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaJAOx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:53:26 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35288 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751330AbaJAOxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:53:23 -0400
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Yao <mark.yao@rock-chips.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v7 00/11] drm: add support for Atmel HLCDC Display Controller
Date: Wed,  1 Oct 2014 16:52:57 +0200
Message-Id: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series is being sent for several weeks now and I wonder if I shouldn't
split it in several pieces:
1) the MFD driver + its DT doc
2) the PWM driver + its DT doc
3) the DRM/KMS driver + its DT doc
4) support for sama5d3 SoCs/boards

The first reason for doing this is that Lee already accepted the MFD part,
and I'm pretty sure he'd like me to stop sending him each new version of this
series.
The second reason being that smaller series are more likely to be reviewed by
subsystem maintainers :-).

Lee, if you still agree with this version, could you take the MTD part (other
drivers in this series depend on it).

Here is the usal description of the patch series :-) :

This patch series adds support for the Atmel HLCDC block (HLCD Controller)
available on some Atmel SoCs (i.e. the sama5d3 family).

The HLCDC actually provides a Display Controller and a PWM device, hence I
decided to declare an MFD device exposing 2 subdevices: a display
controller and a PWM chip.
This also solves a circular dependency issue preventing HLCDC driver from
unloading.
The HLCDC request a drm_panel device, which request a backlight device
(a PWM backlight), which depends on a PWM which is provided by the HLCDC
driver (hlcdc -> panel -> backlight -> hlcdc (pwm part)).

The current implementation only supports sama5d3 SoCs but other SoCs should
be easily ported by defining new compatible strings and adding HLCDC
description structures for these SoCs (Ludovic tested this driver on an
at91sam9x5 board).

The drivers supports basic CRTC functionalities, several overlays and an
hardware cursor.

At the moment, it only supports connection to LCD panels through an RGB
connector (defined as an LVDS connector in my implementation), though
connection to other kind of devices (like DRM bridges) could be added later.

It also supports several RGB formats on all planes and some YUV formats on
the HEO overlay plane.

This series depends on those ones: [1], [2] and [3].

Best Regards,

Boris

[1]http://lkml.iu.edu/hypermail/linux/kernel/1407.1/04171.html
[2]https://lkml.org/lkml/2014/9/29/330
[3]https://lkml.org/lkml/2014/9/22/575

Changes since v7:
- move interrupts property from hlcdc display controller node to its
  parent node (the MFD device)
- add mode_set_base implementation
- rework page flip handling to rely on vblank events instead of DMA
  transfer events (the end of a DMA transfer does not mean the frame
  is actually flipped: data are first copied to an output FIFO before
  being sent on the RGB/DPI connector)
- few minor coding style fixes

Changes since v5:
- fix Kconfig dependency bug
- use adjusted mode in crtc config
- move signal config (clk, hsync, vsync) from connector to crtc mode_set
  function
- use standard rotation property
- check display_mode validity in connecto mode_valid function
- remove dma_set_coherent mask call (now done in MFD core)
- do not use drm_platform_init

Changes since v4:
- fix a few more bugs in rotation handling (rotation was buggy on some
  formats)
- return connector_status_unknown until a panel is exposed by the
  drm_panel infrastructure (prevent fbdev creation until everyting is
  in place)
- rework Kconfig MFD_ATMEL_HLCDC selection to simplify the configuration
  (automatically select this option when selecting the HLCDC PMW or DRM
  driver, instead of depending on this option)

Changes since v3:
- rework the layer code to simplify several parts (locking and layer
  disabling)
- make use of the drm_flip_work infrastructure
- rely on default HW cursor implementation using on the cursor plane
- rework the display controller DT bindings (based on OF graph
  representation)
- add rotation support
- retrive RGB bus format from drm_display_info
- drop the dynamic pinctrl state selection
- rework HLCDC output handling (previously specialized to interface
  with LCD panels)
- drop ".module = THIS_MODULE" lines
- change display controller compatible string

Changes since v2:
- fix coding style issues (macro indentation)
- make use of GENMASK in several places
- declare regmap config as a static structure
- rework hlcdc plane update API
- rework cursor handling to make use of the new plane update API
- fix backporch config
- do not use devm_regmap_init_mmio_clk to avoid extra clk_enable
  clk disable calls when accessing registers
- explicitely include regmap and clk headers instead of relying on
  atmel-hlcdc.h inclusions
- make the atmel-hlcdc driver depends on CONFIG_OF
- separate DT bindings documentation from driver implementation
- support several pin muxing for HLCDC pins on sama5d3 SoCs

Changes since v1:
- replace the backlight driver by a PWM driver
- make use of drm_panel infrastructure
- split driver code in several subsystem: MFD, PWM and DRM
- add support for overlays
- add support for hardware cursor


Boris BREZILLON (10):
  mfd: add documentation for atmel-hlcdc DT bindings
  pwm: add support for atmel-hlcdc-pwm device
  pwm: add DT bindings documentation for atmel-hlcdc-pwm driver
  drm: add Atmel HLCDC Display Controller support
  drm: add DT bindings documentation for atmel-hlcdc-dc driver
  ARM: AT91/dt: split sama5d3 lcd pin definitions to match RGB mode
    configs
  ARM: AT91/dt: add alternative pin muxing for sama5d3 lcd pins
  ARM: at91/dt: define the HLCDC node available on sama5d3 SoCs
  ARM: at91/dt: add LCD panel description to sama5d3xdm.dtsi
  ARM: at91/dt: enable the LCD panel on sama5d3xek boards


Boris BREZILLON (10):
  mfd: add documentation for atmel-hlcdc DT bindings
  pwm: add support for atmel-hlcdc-pwm device
  pwm: add DT bindings documentation for atmel-hlcdc-pwm driver
  drm: add Atmel HLCDC Display Controller support
  drm: add DT bindings documentation for atmel-hlcdc-dc driver
  ARM: AT91/dt: split sama5d3 lcd pin definitions to match RGB mode
    configs
  ARM: AT91/dt: add alternative pin muxing for sama5d3 lcd pins
  ARM: at91/dt: define the HLCDC node available on sama5d3 SoCs
  ARM: at91/dt: add LCD panel description to sama5d3xdm.dtsi
  ARM: at91/dt: enable the LCD panel on sama5d3xek boards

Boris Brezillon (1):
  mfd: add atmel-hlcdc driver

 .../devicetree/bindings/drm/atmel-hlcdc-dc.txt     |  53 ++
 .../devicetree/bindings/mfd/atmel-hlcdc.txt        |  51 ++
 .../devicetree/bindings/pwm/atmel-hlcdc-pwm.txt    |  55 ++
 arch/arm/boot/dts/sama5d31ek.dts                   |  20 +
 arch/arm/boot/dts/sama5d33ek.dts                   |  20 +
 arch/arm/boot/dts/sama5d34ek.dts                   |  20 +
 arch/arm/boot/dts/sama5d36ek.dts                   |  20 +
 arch/arm/boot/dts/sama5d3_lcd.dtsi                 | 205 ++++-
 arch/arm/boot/dts/sama5d3xdm.dtsi                  |  58 ++
 drivers/gpu/drm/Kconfig                            |   2 +
 drivers/gpu/drm/Makefile                           |   1 +
 drivers/gpu/drm/atmel-hlcdc/Kconfig                |  13 +
 drivers/gpu/drm/atmel-hlcdc/Makefile               |   7 +
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c     | 390 ++++++++++
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.c       | 531 +++++++++++++
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.h       | 216 ++++++
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.c    | 638 ++++++++++++++++
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.h    | 394 ++++++++++
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_output.c   | 443 +++++++++++
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c    | 831 +++++++++++++++++++++
 drivers/mfd/Kconfig                                |   6 +
 drivers/mfd/Makefile                               |   1 +
 drivers/mfd/atmel-hlcdc.c                          | 122 +++
 drivers/pwm/Kconfig                                |  10 +
 drivers/pwm/Makefile                               |   1 +
 drivers/pwm/pwm-atmel-hlcdc.c                      | 229 ++++++
 include/linux/mfd/atmel-hlcdc.h                    |  85 +++
 27 files changed, 4391 insertions(+), 31 deletions(-)
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
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_output.c
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
 create mode 100644 drivers/mfd/atmel-hlcdc.c
 create mode 100644 drivers/pwm/pwm-atmel-hlcdc.c
 create mode 100644 include/linux/mfd/atmel-hlcdc.h

-- 
1.9.1

