Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759531AbaJaN0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 09:26:43 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:45945 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758645AbaJaN0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 09:26:41 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        kishon@ti.com, balbi@ti.com, stern@rowland.harvard.edu,
        kgene.kim@samsung.com, heikki.krogerus@linux.intel.com,
        mathias.nyman@intel.com, sergei.shtylyov@cogentembedded.com,
        jwerner@google.com, jg1.han@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v7 0/2] Fine tune USB 3.0 PHY on exynos5420
Date: Fri, 31 Oct 2014 18:56:27 +0530
Message-Id: <1414761989-21088-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is tested with V3 of Heikki's patches for simpliefied phy lookup table:
[PATCHv3 0/6] phy: simplified phy lookup [1] on 'usb-next' branch.
V4 of this series is giving some issue, which i have already pointed out in the
patch: [PATCHv4 2/6] phy: improved lookup method

Changes since v6:
 - Dropped the changes for adding additional phy_calibrate() callback.
 - Added phy_init() and phy_power_on() sequence in xhci-plat driver;
   NOTE: both phy_init() and phy_power_on() will now require PHY's
         'init_count' and 'power_count' to be reset to '0' so that
         we can actually re-initialize the phy. Though this has already been
         pointed out in discussion for the previous patch-series. [2]
 - Refactored return codes and error handling in cr_port functions as pointed
   out by Felipe.

Changes since v5:
 - Assigned NULL to hcd->gen_phy in error path in xhci-plat.c, so that
   we don't need to check for IS_ERR() while calibrating the PHYs in
   core/hcd.c
 - Removed extra empty lines in register definitions in exynos5-usbdrd
   phy driver.
 - Added write access for EXYNOS5_DRD_PHYREG0 register before any
   crport_handshake() call as suggested by Jingoo Han.
 - Renamed member 'calibrate' to 'phy_exynos_calibrate' of
   struct exynos5_usbdrd_phy_drvdata.

Changes since v4:
 - Rebased on latest patches by Heikki.
 - Took care of handling -EPROBE_DEFER error number while getting PHY in
   xhci plat.

Changes from v3:
 - Modified error message as per review comments from Julius.

Changes since v2:
 - Removed any check for DWC3 in xhci-plat for getting usb2-phy and usb3-phy,
   in order to make it more generic.
 - Moved the phy_calibration calls to core/hcd.c to enable a more generic
   solution for issues of calibrating the PHYs.

Changes since v1:
 - Using 'gen_phy' member of 'hcd' instead of declaring more variables
   to hold phys.
 - Added a check for compatible match for 'Synopsys-dwc3' controller,
   since the 'gen_phy' member of 'hcd' already gets the 'usb' PHY
   in core/hcd.c; but XHCI on Synopsys-dwc3 doesn't need that,
   instead two separate PHYs for UTMI+ and PIPE3 for the two HCDs
   (main hcd and shared hcd).
 - Restructured the code in 'xhci_plat_setup()' and 'xhci_plat_resume()'
   to use hcd->gen_phy directly. Also added the check for Synopsys's DWC3
   controller while trying to calibrate the PHY.

Explanation for the need of this patch-series:
"The DWC3-exynos eXtensible host controller present on Exynos5420/5800
SoCs is quirky. The PHY serving this controller operates at High-Speed
by default, so it detects even Super-speed devices as high-speed ones.
Certain PHY parameters like Tx LOS levels and Boost levels need to be
calibrated further post initialization of xHCI controller, to get
SuperSpeed operations working."

[1] https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg710094.html
[2] https://lkml.org/lkml/2014/9/2/170;   (to be specific https://lkml.org/lkml/2014/9/10/132)

Vivek Gautam (2):
  usb: host: xhci-plat: Get PHYs for xhci's hcds
  phy: exynos5-usbdrd: Calibrate LOS levels for exynos5420/5800

 drivers/phy/phy-exynos5-usbdrd.c |  219 +++++++++++++++++++++++++++++++++++---
 drivers/usb/host/xhci-plat.c     |   74 +++++++++++++
 2 files changed, 277 insertions(+), 16 deletions(-)

-- 
1.7.10.4

