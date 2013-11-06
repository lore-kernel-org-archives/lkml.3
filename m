Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab3KFQDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 11:03:12 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:47229 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980Ab3KFQDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 11:03:09 -0500
From: Georgi Djakov <gdjakov@mm-sol.com>
To: linux-mmc@vger.kernel.org, cjb@laptop.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, subhashj@codeaurora.org,
        Georgi Djakov <gdjakov@mm-sol.com>
Subject: [PATCH v7 0/2] mmc: sdhci-msm: Add support for MSM chipsets
Date: Wed,  6 Nov 2013 17:56:43 +0200
Message-Id: <1383753405-23631-1-git-send-email-gdjakov@mm-sol.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds basic support of the Secure Digital Host Controller
Interface compliant controller found in Qualcomm MSM chipsets.

Tested with SD card on APQ8074 Dragonboard.

Patchset applies to mmc-next, as it depends on:
4525181 mmc: sdhci: add hooks for platform specific tuning

Changes from v6:
- Fixed wrong pointer in sdhci_msm_pwr_irq().
- Added platform_execute_tuning() callback as the MSM SDHC does not
  support tuning as in SDHC 3.0 spec and will need custom implementation
  in order to support SDR104, HS200 and HS400.
- Removed the always-on devicetree property - if the regulator is
  configured as always-on, it will not be disabled anyway.
- Removed devm_pinctrl_get_select_default() - the default pins are 
  already set from the device core.
- Removed wrapper function sdhci_msm_set_vdd_io_vol() and enum
  vdd_io_level and now calling regulator_set_voltage() directly.
- Converted #defines to use BIT() macro.
- Added IS_ERR(vreg->reg) check at the beginning of sdhci_msm_vreg
  functions.
- Do not print errors when regulators init return -EPROBE_DEFER as the
  deffered init is not an actual error.
- Handle each power irq status bit separately in sdhci_msm_pwr_irq().
- Ensure that any pending power irq is acknowledged before enabling it,
  otherwise the irq handler will be fired prematurely.
- Minor changes.

Changes from v5:
- Driver is split into multiple patches
- Do not initialize variables that are assigned later in code
- Remove some useless comments
- Use shorter variable names
- Change pr_err() to dev_err()
- Optimized sdhci_msm_setup_vreg()
- Some code alignment fixes
- Improved DT values sanity check
- Added dev_dbg print for sdhci controller version in probe()
- Added usleep_range() after SW reset - it can take some time
- Added SDHCI_QUIRK_SINGLE_POWER_WRITE - power handled by PMIC
- Renamed DT property vdd-io to vddio

Changes from v4:
- Simplified sdhci_msm_vreg_disable() and sdhci_msm_set_vdd_io_vol()
- Use devm_ioremap_resource() instead of devm_ioremap()
- Converted IS_ERR_OR_NULL to IS_ERR
- Disable regulators in sdhci_msm_remove()
- Check for DT node at the beginning in sdhci_msm_probe()
- Removed more redundant code
- Changes in some error messages
- Minor fixes

Changes from v3:
- Allocate memory for all required structs at once
- Added termination entry in sdhci_msm_dt_match[]
- Fixed a missing sdhci_pltfm_free() in probe()
- Removed redundant of_match_ptr
- Removed the unneeded function sdhci_msm_vreg_reset()

Changes from v2:
- Added DT bindings for clocks
- Moved voltage regulators data to platform data
- Removed unneeded includes
- Removed obsolete and wrapper functions
- Removed error checking where unnecessary
- Removed redundant _clk suffix from clock names
- Just return instead of goto where possible
- Minor fixes

Changes from v1:
- GPIO references are replaced by pinctrl
- DT parsing is done mostly by mmc_of_parse()
- Use of_match_device() for DT matching
- A few minor changes

Georgi Djakov (2):
  mmc: sdhci-msm: Initial SDHCI MSM driver documentation
  mmc: sdhci-msm: Initial support for MSM chipsets

 .../devicetree/bindings/mmc/sdhci-msm.txt          |   93 +++
 drivers/mmc/host/Kconfig                           |   13 +
 drivers/mmc/host/Makefile                          |    1 +
 drivers/mmc/host/sdhci-msm.c                       |  655 ++++++++++++++++++++
 4 files changed, 762 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mmc/sdhci-msm.txt
 create mode 100644 drivers/mmc/host/sdhci-msm.c

-- 
1.7.9.5

