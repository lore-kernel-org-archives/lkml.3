Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbbAVHEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:04:35 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:51202 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbbAVHDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:03:39 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0M73QBR021358, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v2 6/9] mfd: rtsx: remove LCTLR defination
Date: Thu, 22 Jan 2015 15:03:13 +0800
Message-ID: <9cb21eef6d2e9ef00f5a6aaff9697029f0696cde.1421909642.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1421909642.git.micky_ching@realsil.com.cn>
References: <cover.1421909642.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

To enable/disable ASPM we should find LINK CONTROL register
in PCI config space. All old chip use 0x80 address, but new
chip may use another address, so we using pci_find_capability()
to get LINK CONTROL address.

rtsx_gops.c was removed, we consider to put some common operations
to this file, but the actual thing is, only a group of chips
are in common ops1, and another group of chips in common ops2,
it is hard to decide put which ops into generic ops file.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mfd/Makefile         |  2 +-
 drivers/mfd/rts5227.c        |  2 +-
 drivers/mfd/rts5249.c        |  3 +--
 drivers/mfd/rtsx_gops.c      | 37 -------------------------------------
 drivers/mfd/rtsx_pcr.c       | 23 ++++++++++++++++++-----
 include/linux/mfd/rtsx_pci.h | 10 +---------
 6 files changed, 22 insertions(+), 55 deletions(-)
 delete mode 100644 drivers/mfd/rtsx_gops.c

diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 53467e2..2cd7e74 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -13,7 +13,7 @@ obj-$(CONFIG_MFD_CROS_EC)	+= cros_ec.o
 obj-$(CONFIG_MFD_CROS_EC_I2C)	+= cros_ec_i2c.o
 obj-$(CONFIG_MFD_CROS_EC_SPI)	+= cros_ec_spi.o
 
-rtsx_pci-objs			:= rtsx_pcr.o rtsx_gops.o rts5209.o rts5229.o rtl8411.o rts5227.o rts5249.o
+rtsx_pci-objs			:= rtsx_pcr.o rts5209.o rts5229.o rtl8411.o rts5227.o rts5249.o
 obj-$(CONFIG_MFD_RTSX_PCI)	+= rtsx_pci.o
 obj-$(CONFIG_MFD_RTSX_USB)	+= rtsx_usb.o
 
diff --git a/drivers/mfd/rts5227.c b/drivers/mfd/rts5227.c
index 1f387d4..0c02831 100644
--- a/drivers/mfd/rts5227.c
+++ b/drivers/mfd/rts5227.c
@@ -130,7 +130,7 @@ static int rts5227_optimize_phy(struct rtsx_pcr *pcr)
 {
 	int err;
 
-	err = rtsx_gops_pm_reset(pcr);
+	err = rtsx_pci_write_register(pcr, PM_CTRL3, D3_DELINK_MODE_EN, 0x00);
 	if (err < 0)
 		return err;
 
diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
index d8072f6..3977946 100644
--- a/drivers/mfd/rts5249.c
+++ b/drivers/mfd/rts5249.c
@@ -119,7 +119,6 @@ static int rts5249_extra_init_hw(struct rtsx_pcr *pcr)
 		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PETXCFG, 0xB0, 0xB0);
 	else
 		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PETXCFG, 0xB0, 0x80);
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, PM_CTRL3, 0x10, 0x00);
 
 	return rtsx_pci_send_cmd(pcr, 100);
 }
@@ -128,7 +127,7 @@ static int rts5249_optimize_phy(struct rtsx_pcr *pcr)
 {
 	int err;
 
-	err = rtsx_gops_pm_reset(pcr);
+	err = rtsx_pci_write_register(pcr, PM_CTRL3, D3_DELINK_MODE_EN, 0x00);
 	if (err < 0)
 		return err;
 
diff --git a/drivers/mfd/rtsx_gops.c b/drivers/mfd/rtsx_gops.c
deleted file mode 100644
index b1a98c6..0000000
--- a/drivers/mfd/rtsx_gops.c
+++ /dev/null
@@ -1,37 +0,0 @@
-/* Driver for Realtek PCI-Express card reader
- *
- * Copyright(c) 2009-2013 Realtek Semiconductor Corp. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the
- * Free Software Foundation; either version 2, or (at your option) any
- * later version.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, see <http://www.gnu.org/licenses/>.
- *
- * Author:
- *   Micky Ching <micky_ching@realsil.com.cn>
- */
-
-#include <linux/mfd/rtsx_pci.h>
-#include "rtsx_pcr.h"
-
-int rtsx_gops_pm_reset(struct rtsx_pcr *pcr)
-{
-	int err;
-
-	/* init aspm */
-	rtsx_pci_write_register(pcr, ASPM_FORCE_CTL, 0xFF, 0x00);
-	err = rtsx_pci_update_cfg_byte(pcr, LCTLR, ~LCTLR_ASPM_CTL_MASK, 0x00);
-	if (err < 0)
-		return err;
-
-	/* reset PM_CTRL3 before send buffer cmd */
-	return rtsx_pci_write_register(pcr, PM_CTRL3, D3_DELINK_MODE_EN, 0x00);
-}
diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 30f7ca8..717bfd7 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -63,6 +63,18 @@ static const struct pci_device_id rtsx_pci_ids[] = {
 
 MODULE_DEVICE_TABLE(pci, rtsx_pci_ids);
 
+static inline void rtsx_pci_enable_aspm(struct rtsx_pcr *pcr)
+{
+	rtsx_pci_update_cfg_byte(pcr, pcr->pcie_cap + PCI_EXP_LNKCTL,
+		0xFC, pcr->aspm_en);
+}
+
+static inline void rtsx_pci_disable_aspm(struct rtsx_pcr *pcr)
+{
+	rtsx_pci_update_cfg_byte(pcr, pcr->pcie_cap + PCI_EXP_LNKCTL,
+		0xFC, 0);
+}
+
 void rtsx_pci_start_run(struct rtsx_pcr *pcr)
 {
 	/* If pci device removed, don't queue idle work any more */
@@ -75,7 +87,8 @@ void rtsx_pci_start_run(struct rtsx_pcr *pcr)
 			pcr->ops->enable_auto_blink(pcr);
 
 		if (pcr->aspm_en)
-			rtsx_pci_write_config_byte(pcr, LCTLR, 0);
+			rtsx_pci_disable_aspm(pcr);
+
 	}
 
 	mod_delayed_work(system_wq, &pcr->idle_work, msecs_to_jiffies(200));
@@ -942,7 +955,7 @@ static void rtsx_pci_idle_work(struct work_struct *work)
 		pcr->ops->turn_off_led(pcr);
 
 	if (pcr->aspm_en)
-		rtsx_pci_write_config_byte(pcr, LCTLR, pcr->aspm_en);
+		rtsx_pci_enable_aspm(pcr);
 
 	mutex_unlock(&pcr->pcr_mutex);
 }
@@ -968,6 +981,7 @@ static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
 {
 	int err;
 
+	pcr->pcie_cap = pci_find_capability(pcr->pci, PCI_CAP_ID_EXP);
 	rtsx_pci_writel(pcr, RTSX_HCBAR, pcr->host_cmds_addr);
 
 	rtsx_pci_enable_bus_int(pcr);
@@ -980,6 +994,7 @@ static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
 	/* Wait SSC power stable */
 	udelay(200);
 
+	rtsx_pci_disable_aspm(pcr);
 	if (pcr->ops->optimize_phy) {
 		err = pcr->ops->optimize_phy(pcr);
 		if (err < 0)
@@ -1028,10 +1043,8 @@ static int rtsx_pci_init_hw(struct rtsx_pcr *pcr)
 	if (err < 0)
 		return err;
 
-	rtsx_pci_write_config_byte(pcr, LCTLR, 0);
-
 	/* Enable clk_request_n to enable clock power management */
-	rtsx_pci_write_config_byte(pcr, 0x81, 1);
+	rtsx_pci_write_config_byte(pcr, pcr->pcie_cap + PCI_EXP_LNKCTL + 1, 1);
 	/* Enter L1 when host tx idle */
 	rtsx_pci_write_config_byte(pcr, 0x70F, 0x5B);
 
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index 0103210..33cc63c 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -716,15 +716,6 @@
 
 #define PHY_DUM_REG			0x1F
 
-#define LCTLR				0x80
-#define   LCTLR_EXT_SYNC		0x80
-#define   LCTLR_COMMON_CLOCK_CFG	0x40
-#define   LCTLR_RETRAIN_LINK		0x20
-#define   LCTLR_LINK_DISABLE		0x10
-#define   LCTLR_RCB			0x08
-#define   LCTLR_RESERVED		0x04
-#define   LCTLR_ASPM_CTL_MASK		0x03
-
 #define PCR_SETTING_REG1		0x724
 #define PCR_SETTING_REG2		0x814
 #define PCR_SETTING_REG3		0x747
@@ -759,6 +750,7 @@ enum PDEV_STAT  {PDEV_STAT_IDLE, PDEV_STAT_RUN};
 struct rtsx_pcr {
 	struct pci_dev			*pci;
 	unsigned int			id;
+	int				pcie_cap;
 
 	/* pci resources */
 	unsigned long			addr;
-- 
1.9.1

