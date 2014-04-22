Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaDVID7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:03:59 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:54691 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaDVIDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:03:40 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org, kishon@ti.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        t.figa@samsung.com, k.debski@samsung.com, sylvester.nawrocki@gmail.com
Subject: [PATCH v5 0/2] Add Exynos5 USB 3.0 phy driver based on generic PHY framework
Date: Tue, 22 Apr 2014 13:33:13 +0530
Message-Id: <1398153795-28475-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on 'next' branch of Kishon's phy tree (linux-phy).
Tested on 'usb-next' of Greg's usb tree.

Changes from v4:
1) Separated out the device tree related arch patches from this patch series.
   Shall be posting these below mentioned patches (which were part of
   V4 version of this series) in a separate patch series based on
   Kgene's next branch.
   [PATCH v4 2/5]dt: exynos5420: Enable support for USB 3.0 PHY controller
   [PATCH v4 3/5]dt: exynos5420: Enable support for DWC3 controller
   [PATCH v4 4/5]dt: exynos5250: Enable support for generic USB DRD phy
   [PATCH v4 5/5]usb-phy: samsung-usb3: Remove older phy-samsung-usb3 driver

2) Also clubbed the reworked VBUS patch for usb3-drd phy, which was earlier
   sent as a separate patch:
   [PATCH] phy: exynos5-usbdrd: Add facility to toggle vbus gpio on/off.
   https://lkml.org/lkml/2014/4/9/186

1) Removed the mention of separate sclk_usbphy30*, instead this clock
   will be used as 'ref' phy reference clock while adding the device
   nodes.
2) Reading the PHYCLKRST register to restore any previous settings,
   instead of using a separate variable for saving/restoring purpose.
3) Renamed 'samsung,syscon-phandle' property to 'samsung,pmu-syscon'.
4) Removed unnecessary check for of_node property at the starting of
   driver probe, since this is exclusively DT enabled driver.

Changes from V3:
1) Separated out the phy init sequences for utmi and pipe3 phys.
2) Changed the nomenclature across the phy to 'usbdrd-phy' to
   indicate USB 3.0 DRD PHY controller; and thereby changed the names                
   of functions correspondingly, including specific functions for
   utmi and pipe3 phys.                                                              
3) Modified the DT nodes for the updated nomenclature.
4) Using BIT macro for single bit definitions.                                       
5) Keeping track of reference clock after getting till the removal of                
   phy, and getting the ref clock using devm_clk_get() api.
6) Removed aliases for mutiple channel PHYs, and instead using
   'samsung,pmu-offset' property for PHY power control register offset.
7) Keeping the phy_init() and phy_power_on() separately in order to
   align with phy handling in the consumer (DWC3).

Changes from v2:
1) Added support for multiple PHYs (UTMI+ and PIPE3) and                   
   related changes in the driver structuring.
2) Added a xlate function to get the required phy out of
   number of PHYs in mutiple PHY scenerio.
3) Changed the names of few structures and variables to                
   have a clearer meaning. 
4) Added 'usb3phy_config' structure to take care of mutiple
   phys for a SoC having 'exynos5_usb3phy_drv_data' driver data.      
5) Not deleting support for old driver 'phy-samsung-usb3' until
   required support for generic phy is added to DWC3.  
 
Changes from RFC patch-set:
1) fixes in documentation file
 - added provision for syscon interface for using PMU register.
 - added clock names and description
 - modified description style for 'compatible property'                    
 - made usb30_sclk as additional clock rather then making it optional, since
   it is actually an additional clock for Exynos5420 Soc.
2) fixes in phy-exynos5-usb3 driver file
 - removed unnecessary #ifndef around KHZ and MHZ definitions            
 - removed 'samsung_cpu_type', 'usb3phy_state' enums; and merged necessary
   necessary from 'usb3phy_instance' structure to 'usb3phy_driver'.
 - changed name 'sclk_usbphy30' to 'usb30_sclk_100m' since this is the name
   indicated as input to the PHY block; and also added (!IS_ERR()) check for
   using usb30_sclk.
 - removed unnecessary 'state' check code.
 - moved 'of_device_id' structure definitions before 'probe()' to avoid
   unnecessary declaration.
 - added (pdev->dev.of_node == NULL) check at the starting of probe()
 - moved 'devm_of_phy_provider_register()' call to end of the probe().
 - removed 'label' for usb3drd phy.
 - corrected macros definition 'PHYCLKRST_MPLL_MULTIPLIER_50M_REF' from
   0x02 to 0x32 after confirming same from PHY's data sheet.
 - replaced pmu register handling, used for power-isolation, with syscon
   interface api's.
 - added '.init' and '.exit' callbacks and using them for one time
   PHY-initialization and deinitialization.
 - Filtering out the PHY 'power-on' and 'power-off' sequence to '.power_on"
   and ".power_off" callbacks.
 - Removed drivers/usb/phy/phy-samsung-usb3.c driver and related code.
3) fixes in dt files
 - added reference for 'samsung,syscon-phandle' to used for PMU register.
 - removed second register field which was earlier used for PMU.

Vivek Gautam (2):
  phy: Add new Exynos5 USB 3.0 PHY driver
  phy: exynos5-usbdrd: Add facility for VBUS supply

 .../devicetree/bindings/phy/samsung-phy.txt        |   40 ++
 drivers/phy/Kconfig                                |   11 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-exynos5-usbdrd.c                   |  663 ++++++++++++++++++++
 4 files changed, 715 insertions(+)
 create mode 100644 drivers/phy/phy-exynos5-usbdrd.c

-- 
1.7.10.4

