Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbaIBLMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 07:12:40 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:35904 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbaIBLMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 07:12:38 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        kishon@ti.com, balbi@ti.com, stern@rowland.harvard.edu,
        kgene.kim@samsung.com, heikki.krogerus@linux.intel.com,
        mathias.nyman@intel.com, sergei.shtylyov@cogentembedded.com,
        jg1.han@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v6 0/4] Fine tune USB 3.0 PHY on exynos5420
Date: Tue,  2 Sep 2014 16:42:14 +0530
Message-Id: <1409656338-20337-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is based on Heikki's patches for simpliefied phy lookup table:
[PATCHv3 0/6] phy: simplified phy lookup [1], applied against 'usb-next' branch
alongwith Sergei's patch for adding generic phy support to usb hcd [2].

NOTE: We need to get above dependencies merged first in order to merge this
      series.
      As of now patches @ [1] are posted with all the comments addressed
      and we are waiting for an ACK on them, but
      patch @ [2] needs to be re-spined as Sergie says in [3]:
            "Yes, I'm planning this since Greg has lost v4."

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
[2] http://comments.gmane.org/gmane.linux.ports.sh.devel/35932
[3] http://www.spinics.net/lists/linux-usb/msg112300.html

Vivek Gautam (4):
  phy: Add provision for calibrating phy.
  usb: host: xhci-plat: Get PHYs for xhci's hcds
  usb: hcd: Calibrate PHY post hcd reset
  phy: exynos5-usbdrd: Calibrate LOS levels for exynos5420/5800

 drivers/phy/phy-core.c           |   36 ++++++++
 drivers/phy/phy-exynos5-usbdrd.c |  185 ++++++++++++++++++++++++++++++++++----
 drivers/usb/core/hcd.c           |   18 ++++
 drivers/usb/host/xhci-plat.c     |   27 ++++++
 include/linux/phy/phy.h          |    8 ++
 5 files changed, 259 insertions(+), 15 deletions(-)

-- 
1.7.10.4

