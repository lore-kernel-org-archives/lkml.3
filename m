Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbaGNMuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 08:50:15 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:34424 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbaGNMuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 08:50:10 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, kishon@ti.com, kgene.kim@samsung.com,
        mathias.nyman@intel.com, jwerner@chromium.org,
        sergei.shtylyov@cogentembedded.com, heikki.krogerus@linux.intel.com,
        pratyush.anand@st.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v3 0/4] Fine tune USB 3.0 PHY on exynos5420
Date: Mon, 14 Jul 2014 18:19:54 +0530
Message-Id: <1405342198-3870-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is based on Heikki's patches for simpliefied phy lookup table:
[PATCHv2 0/6] phy: simplified phy lookup [1], applied against 'next' branch
of Kishon's linux-phy tree.

Changes since v2:
1) Removed any check for DWC3 in xhci-plat for getting usb2-phy and usb3-phy,
   in order to make it more generic.
2) Moved the phy_calibration calls to core/hcd.c to enable a more generic
   solution for issues of calibrating the PHYs.

Changes since v1:
1) Using 'gen_phy' member of 'hcd' instead of declaring more variables
   to hold phys.
2) Added a check for compatible match for 'Synopsys-dwc3' controller,
   since the 'gen_phy' member of 'hcd' already gets the 'usb' PHY
   in core/hcd.c; but XHCI on Synopsys-dwc3 doesn't need that,
   instead two separate PHYs for UTMI+ and PIPE3 for the two HCDs
   (main hcd and shared hcd).
3) Restructured the code in 'xhci_plat_setup()' and 'xhci_plat_resume()'
   to use hcd->gen_phy directly. Also added the check for Synopsys's DWC3
   controller while trying to calibrate the PHY.

Explanation for the need of this patch-series:
"The DWC3-exynos eXtensible host controller present on Exynos5420/5800
SoCs is quirky. The PHY serving this controller operates at High-Speed
by default, so it detects even Super-speed devices as high-speed ones.
Certain PHY parameters like Tx LOS levels and Boost levels need to be
calibrated further post initialization of xHCI controller, to get
SuperSpeed operations working."

[1] https://lkml.org/lkml/2014/6/5/358

Vivek Gautam (4):
  phy: Add provision for calibrating phy.
  usb: host: xhci-plat: Get PHYs for xhci's hcds
  usb: hcd: Caibrate PHY post hcd reset
  phy: exynos5-usbdrd: Calibrate LOS levels for exynos5420/5800

 drivers/phy/phy-core.c           |   36 ++++++++
 drivers/phy/phy-exynos5-usbdrd.c |  169 ++++++++++++++++++++++++++++++++++++++
 drivers/usb/core/hcd.c           |   22 +++++
 drivers/usb/host/xhci-plat.c     |   17 ++++
 include/linux/phy/phy.h          |    8 ++
 5 files changed, 252 insertions(+)

-- 
1.7.10.4

