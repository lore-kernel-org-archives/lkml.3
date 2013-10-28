Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab3J1TQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 15:16:08 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45249 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153Ab3J1TOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 15:14:10 -0400
Message-Id: <cover.1382985169.git.joshc@codeaurora.org>
From: Josh Cartwright <joshc@codeaurora.org>
Date: Mon, 28 Oct 2013 13:32:49 -0500
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: [PATCH v3 00/10] Add support for the System Power Management Interface (SPMI)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The System Power Management Interface (SPMI) is a high-speed,
low-latency, bi-directional, two-wire serial bus suitable for real-time
control of voltage and frequency scaled multi-core application
processors and its power management of auxiliary components. SPMI
obsoletes a number of legacy, custom point-to-point interfaces and
provides a low pin count, high-speed control bus for up to 4 Master and
16 Slave devices.

SPMI is specified by the MIPI (Mobile Industry Process Interface)
Alliance [1].

This patchset is intended both to provide a core implementation of SPMI and
also to provide a more-or-less complete example of it's use.
  - Patch 1 provides a stubbed implementation of for_each_available_child_of_node()
    to allow SPMI to build with !CONFIG_OF
  - Patches 2-3 implement the SPMI core functionality.
  - Patches 4-6 provide an implementation of an SPMI controller, the Qualcomm
    "PMIC Arbiter", currently used on the 8x74 series SoCs.
  - Patch 7 provides an implementation of regmap for SPMI
  - Patches 8-9 is an implementation of a client driver for the PM8x41 PMICs paired
    with the 800 series SoCs.
  - Patch 10 reworks the existing pm8xxx-rtc driver to work with the PM8x41 PMIC.

Changes from v2[2]:
  - Dropped RFC.
  - Add basic regmap support at Mark Brown's suggestion
  - Drop debugfs interface.  Debugging SPMI accesses can happen via the regmap
    debugfs interface if necessary.
  - Add second address-cell in SPMI generic device tree binding, encoding the
    address type (suggestion by Stephen Warren)
  - Implement interrupt handling functionality within the PMIC Arbiter driver
  - Provide basic MFD driver for the PMIC8x41 PMICs, demonstrating SPMI regmap
    client use
  - Adapt existing pm8xxx-rtc driver to work as a child of the PM8x41 mfd device

Changes from v1[3]:
  - Adopted patch (1/5) to #define for_each_available_node() shim
    in the !CONFIG_OF case
  - Moved device tree logic out of drivers/of and into spmi.c core (this
    mirrors what SPI is doing, and what i2c will soon be doing)
  - Move of_spmi_add_devices() call into spmi_device_add(), so drivers don't
    have to call it explicitly
  - Unconditionally build in debugfs code (rely on the underlying
    CONFIG_DEBUG_FS switch to throw unused code away)
  - Change pr_* print functions to their dev_* equivalents
  - Fix copy_{to,from}_user error handling
  - Renamed "board_lock" to "ctrl_idr_lock" to better describe it's purpose
  - Rework device object lifetime management
  - Rename PMIC arb binding document, add description of PMIC arb
  - Add generic SPMI device tree bindings

[1]: http://www.mipi.org/specifications/system-power-management-interface
[2]: http://marc.info/?l=linux-arm-kernel&m=137721241427533&w=2
[3]: http://thread.gmane.org/gmane.linux.ports.arm.msm/4886

Josh Cartwright (7):
  spmi: add generic SPMI controller binding documentation
  spmi: pmic_arb: add support for interrupt handling
  spmi: document the PMIC arbiter SPMI bindings
  regmap: add SPMI support
  mfd: pm8x41: add support for Qualcomm 8x41 PMICs
  mfd: pm8x41: document device tree bindings
  rtc: pm8xxx: add support for pm8941

Kenneth Heitke (2):
  spmi: Linux driver framework for SPMI
  spmi: Add MSM PMIC Arbiter SPMI controller

Sylwester Nawrocki (1):
  of: Add empty for_each_available_child_of_node() macro definition

 Documentation/devicetree/bindings/mfd/pm8x41.txt   |  33 +
 .../bindings/spmi/qcom,spmi-pmic-arb.txt           |  42 ++
 Documentation/devicetree/bindings/spmi/spmi.txt    |  41 ++
 drivers/Kconfig                                    |   2 +
 drivers/Makefile                                   |   1 +
 drivers/base/regmap/Kconfig                        |   5 +-
 drivers/base/regmap/Makefile                       |   1 +
 drivers/base/regmap/regmap-spmi.c                  |  90 +++
 drivers/mfd/Kconfig                                |  10 +
 drivers/mfd/Makefile                               |   1 +
 drivers/mfd/pm8x41.c                               |  64 ++
 drivers/rtc/Kconfig                                |   1 -
 drivers/rtc/rtc-pm8xxx.c                           | 229 ++++---
 drivers/spmi/Kconfig                               |  24 +
 drivers/spmi/Makefile                              |   6 +
 drivers/spmi/spmi-pmic-arb.c                       | 758 +++++++++++++++++++++
 drivers/spmi/spmi.c                                | 491 +++++++++++++
 include/dt-bindings/spmi/spmi.h                    |  18 +
 include/linux/mod_devicetable.h                    |   8 +
 include/linux/of.h                                 |   3 +
 include/linux/regmap.h                             |   5 +
 include/linux/spmi.h                               | 342 ++++++++++
 22 files changed, 2087 insertions(+), 88 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/pm8x41.txt
 create mode 100644 Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
 create mode 100644 Documentation/devicetree/bindings/spmi/spmi.txt
 create mode 100644 drivers/base/regmap/regmap-spmi.c
 create mode 100644 drivers/mfd/pm8x41.c
 create mode 100644 drivers/spmi/Kconfig
 create mode 100644 drivers/spmi/Makefile
 create mode 100644 drivers/spmi/spmi-pmic-arb.c
 create mode 100644 drivers/spmi/spmi.c
 create mode 100644 include/dt-bindings/spmi/spmi.h
 create mode 100644 include/linux/spmi.h

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

