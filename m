Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab3BPEQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 23:16:19 -0500
Received: from mail-qe0-f73.google.com ([209.85.128.73]:54091 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab3BPEQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 23:16:17 -0500
X-Greylist: delayed 163549 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Feb 2013 23:16:17 EST
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Simon Glass <sjg@chromium.org>,
        Rob Landley <rob@landley.net>, Felipe Balbi <balbi@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Luigi Semenzato <semenzato@chromium.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Che-Liang Chiou <clchiou@chromium.org>,
        Jonathan Kliegman <kliegs@chromium.org>, linux-input@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org,
        "Mike A. Chan" <mikechan@google.com>,
        Alban Bedel <alban.bedel@avionic-design.de>,
        Sourav Poddar <sourav.poddar@ti.com>, Tom Keel <thomas.keel@intel.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-doc@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH v4 0/6] Add ChromeOS Embedded Controller support
Date: Fri, 15 Feb 2013 20:16:06 -0800
Message-Id: <1360988172-15380-1-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ChromeOS Embedded Controller (EC) is an Open Source EC implementation
used on ARM and Intel Chromebooks. Current implementations use a Cortex-M3
connected on a bus (such as I2C, SPI, LPC) to the AP. A separate interrupt
line is used to indicate when the EC needs service.

Functions performed by the EC vary by platform, but typically include
battery charging, keyboard scanning and power sequencing.

This series includes support for the EC message protocol, and implements
a matrix keyboard handler for Linux using the protocol. The EC performs
key scanning and passes scan data in response to AP requests. This is
used on the Samsung ARM Chromebook. No driver is available for LPC at
present.

This series can in principle operate on any hardware, but for it to actually
work on the Samsung ARM Chromebook, it needs patches which are currently in
progress to mainline: Exynos FDT interrupt support and I2C bus arbitration.

The driver is device-tree-enabled and a suitable binding is included in
this series. Example device tree nodes are included in the examples,
but no device tree patch for exynos5250-snow is provided at this stage, since
we must wait for the above-mentioned patches to land to avoid errors from
dtc. This can be added with a follow-on patch when that work is complete.

Changes in v4:
- Fix up trvial logging comments
- Remove messages reporting out of memory
- Add compatible string for cros-ec-keyb
- Remove wake notifier and let drivers use their own handlers instead
- Add 'depends on MFD_CROS_EC' to Kconfig
- Remove use of wake_notifier
- Remove manual code to locate device tree node
- Add resume handler to clear keyboard scan buffer if required

Changes in v3:
- Add stub for matrix_keypad_parse_of_params() when no CONFIG_OF
- Put back full DT range checking in tca8418 driver
- Remove 'select MFD_CROS_EC' from Kconfig as it isn't necessary
- Remove old_state by using input layer's idev->key
- Move inner loop of cros_ec_keyb_has_ghosting() into its own function and simplify
- Add check for not finding the device tree node
- Remove comment about leaking matrix_keypad_build_keymap()
- Use platform_get_drvdata() where possible
- Remove call to input_free_device() after input_unregister_device()

Changes in v2:
- Remove use of __devinit/__devexit
- Remove use of __devinit/__devexit
- Remove use of __devinit/__devexit
- Add new patch to decode matrix-keypad DT binding
- Remove use of __devinit/__devexit
- Use function to read matrix-keypad parameters from DT
- Remove key autorepeat parameters from DT binding and driver
- Use unsigned int for rows/cols

Simon Glass (6):
  mfd: Add ChromeOS EC messages header
  mfd: Add ChromeOS EC implementation
  mfd: Add ChromeOS EC I2C driver
  mfd: Add ChromeOS EC SPI driver
  Input: matrix-keymap: Add function to read the new DT binding
  Input: Add ChromeOS EC keyboard driver

 .../devicetree/bindings/input/cros-ec-keyb.txt     |   72 +
 Documentation/devicetree/bindings/mfd/cros-ec.txt  |   56 +
 drivers/input/keyboard/Kconfig                     |   12 +
 drivers/input/keyboard/Makefile                    |    1 +
 drivers/input/keyboard/cros_ec_keyb.c              |  356 +++++
 drivers/input/keyboard/lpc32xx-keys.c              |   11 +-
 drivers/input/keyboard/omap4-keypad.c              |   16 +-
 drivers/input/keyboard/tca8418_keypad.c            |    7 +-
 drivers/input/matrix-keymap.c                      |   19 +
 drivers/mfd/Kconfig                                |   28 +
 drivers/mfd/Makefile                               |    3 +
 drivers/mfd/cros_ec.c                              |  206 +++
 drivers/mfd/cros_ec_i2c.c                          |  262 ++++
 drivers/mfd/cros_ec_spi.c                          |  412 ++++++
 include/linux/input/matrix_keypad.h                |   19 +
 include/linux/mfd/cros_ec.h                        |  189 +++
 include/linux/mfd/cros_ec_commands.h               | 1369 ++++++++++++++++++++
 17 files changed, 3020 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/cros-ec-keyb.txt
 create mode 100644 Documentation/devicetree/bindings/mfd/cros-ec.txt
 create mode 100644 drivers/input/keyboard/cros_ec_keyb.c
 create mode 100644 drivers/mfd/cros_ec.c
 create mode 100644 drivers/mfd/cros_ec_i2c.c
 create mode 100644 drivers/mfd/cros_ec_spi.c
 create mode 100644 include/linux/mfd/cros_ec.h
 create mode 100644 include/linux/mfd/cros_ec_commands.h

-- 
1.8.1.3

