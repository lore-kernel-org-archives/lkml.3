Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbaBLTqv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 14:46:51 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:52376 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbaBLTqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 14:46:47 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Gilad Avidov <gavidov@codeaurora.org>,
        Sagar Dharia <sdharia@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v6 0/6] Add support for the System Power Management Interface (SPMI)
Date: Wed, 12 Feb 2014 13:44:21 -0600
Message-Id: <1392234267-10880-1-git-send-email-joshc@codeaurora.org>
X-Mailer: git-send-email 1.8.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Greg-

Is it possible for you to pick this up for 3.15?  It'd be nice if we could get
an Ack from devicetree folks on patches 2 and 5, but there has been many months
worth of opportunity for that.

Thanks,
   Josh

---

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
    Qualcomm SPMI PMIC Arbiter, currently used on the 8x74 SoCs.
  - Patch 6 rounds out regmap support for SPMI

Changes from v5[2]:
  - Changed PMIC Arbiter locking to use a raw_spinlock_t over the non-raw
    variant due to it's use in an irqchip implementation (feedback from Thomas
    Gleixner)
  - Reworded descriptions of the reg and reg-names properties in the PMIC
    Arbiter devicetree binding document

Changes from v4[3]:
  - Fixed a few minor error-handling bugs found with further testing
  - Addressed Courtney Cavin's feedback regarding device tree bindings
  - Reworked Kconfig options a bit (allow for building PMIC arb when COMPILE_TEST=y)

Changes from v3[4]:
  - Dropped the pm8x41 PMIC driver and pm8xxx-rtc changes as part of this patchset.
     (will be sent out separately)
  - Rebased on v3.13-rc2
  - Move to simple_ida_* for controller ID allocation
  - Addressed documentation fixes and nits
  - Provide pm_runtime implementation, which leverages SPMI's SLEEP and WAKEUP
    commands
  - Address spmi_controller object lifetime issues

Changes from v2[5]:
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

Changes from v1[6]:
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
[2]: http://lkml.kernel.org/r/1391468739-20987-1-git-send-email-joshc@codeaurora.org
[3]: http://lkml.kernel.org/r/cover.1389738151.git.joshc@codeaurora.org
[4]: http://lkml.kernel.org/r/cover.1382985169.git.joshc@codeaurora.org
[5]: http://lkml.kernel.org/r/cover.1377202730.git.joshc@codeaurora.org
[6]: http://lkml.kernel.org/r/cover.1376596224.git.joshc@codeaurora.org

Josh Cartwright (4):
  spmi: add generic SPMI controller binding documentation
  spmi: pmic_arb: add support for interrupt handling
  spmi: document the PMIC arbiter SPMI bindings
  regmap: spmi: support base and extended register spaces

Kenneth Heitke (2):
  spmi: Linux driver framework for SPMI
  spmi: Add MSM PMIC Arbiter SPMI controller

 .../bindings/spmi/qcom,spmi-pmic-arb.txt           |  61 ++
 Documentation/devicetree/bindings/spmi/spmi.txt    |  41 ++
 drivers/Kconfig                                    |   2 +
 drivers/Makefile                                   |   1 +
 drivers/base/regmap/regmap-spmi.c                  | 228 +++++-
 drivers/spmi/Kconfig                               |  27 +
 drivers/spmi/Makefile                              |   6 +
 drivers/spmi/spmi-pmic-arb.c                       | 778 +++++++++++++++++++++
 drivers/spmi/spmi.c                                | 609 ++++++++++++++++
 include/dt-bindings/spmi/spmi.h                    |  18 +
 include/linux/mod_devicetable.h                    |   8 +
 include/linux/regmap.h                             |  12 +-
 include/linux/spmi.h                               | 191 +++++
 13 files changed, 1947 insertions(+), 35 deletions(-)
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

