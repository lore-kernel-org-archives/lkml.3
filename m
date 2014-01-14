Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbaANW73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 17:59:29 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:55242 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaANW7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 17:59:24 -0500
Message-Id: <cover.1389738151.git.joshc@codeaurora.org>
From: Josh Cartwright <joshc@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: [PATCH v4 0/6] Add support for the System Power Management Interface (SPMI)
Date: Tue, 14 Jan 2014 12:41:34 -0600
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
also to provide a controller driver implementation.
  - Patches 1-2 implement the SPMI core functionality and provide basic
    DT binding documentation
  - Patches 3-5 provide an implementation of an SPMI controller, the
    Qualcomm SPMI PMIC Arbiter", currently used on the 8x74 series SoCs.
  - Patch 6 rounds out regmap support for SPMI

Changes from v3[2]:
  - Dropped the pm8x41 PMIC driver and pm8xxx-rtc changes as part of this patchset.
    I'll be working with Stephen Boyd to see if we can't adapt his pm8xxx
    patches[3] to suit the needs of the pm8x41.
  - Rebased on v3.13-rc2
  - Move to simple_ida_* for controller ID allocation
  - Addressed documentation fixes and nits
  - Provide pm_runtime implementation, which leverages SPMI's SLEEP and WAKEUP
    commands
  - Address spmi_controller object lifetime issues

Changes from v2[4]:
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

Changes from v1[5]:
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
[2]: http://lkml.kernel.org/r/cover.1382985169.git.joshc@codeaurora.org
[3]: http://lkml.kernel.org/r/1389206270-3728-1-git-send-email-sboyd@codeaurora.org
[4]: http://lkml.kernel.org/r/cover.1377202730.git.joshc@codeaurora.org
[5]: http://lkml.kernel.org/r/cover.1376596224.git.joshc@codeaurora.org

Josh Cartwright (4):
  spmi: add generic SPMI controller binding documentation
  spmi: pmic_arb: add support for interrupt handling
  spmi: document the PMIC arbiter SPMI bindings
  regmap: spmi: support base and extended register spaces

Kenneth Heitke (2):
  spmi: Linux driver framework for SPMI
  spmi: Add MSM PMIC Arbiter SPMI controller

 .../bindings/spmi/qcom,spmi-pmic-arb.txt           |  46 ++
 Documentation/devicetree/bindings/spmi/spmi.txt    |  41 ++
 drivers/Kconfig                                    |   2 +
 drivers/Makefile                                   |   1 +
 drivers/base/regmap/regmap-spmi.c                  | 228 +++++-
 drivers/spmi/Kconfig                               |  24 +
 drivers/spmi/Makefile                              |   6 +
 drivers/spmi/spmi-pmic-arb.c                       | 802 +++++++++++++++++++++
 drivers/spmi/spmi.c                                | 609 ++++++++++++++++
 include/dt-bindings/spmi/spmi.h                    |  18 +
 include/linux/mod_devicetable.h                    |   8 +
 include/linux/regmap.h                             |  12 +-
 include/linux/spmi.h                               | 191 +++++
 13 files changed, 1953 insertions(+), 35 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
 create mode 100644 Documentation/devicetree/bindings/spmi/spmi.txt
 create mode 100644 drivers/spmi/Kconfig
 create mode 100644 drivers/spmi/Makefile
 create mode 100644 drivers/spmi/spmi-pmic-arb.c
 create mode 100644 drivers/spmi/spmi.c
 create mode 100644 include/dt-bindings/spmi/spmi.h
 create mode 100644 include/linux/spmi.h

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

