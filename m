Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbbAOLWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:22:30 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:50058 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbbAOLTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:19:39 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0FBJLF5002318, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH 03/10] mfd: rtsx: add debug info when access register failed
Date: Thu, 15 Jan 2015 19:19:00 +0800
Message-ID: <12574843e5abb5c02430c4f0cdf0c615c5eaebc3.1421320541.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1421320541.git.micky_ching@realsil.com.cn>
References: <cover.1421320541.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

Add debug info when access register failed, this is useful for
debug.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mfd/rtsx_pcr.c       | 22 +++++++++++++++++-----
 include/linux/mfd/rtsx_pci.h |  2 ++
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 30f7ca8..92f5a41 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -96,12 +96,16 @@ int rtsx_pci_write_register(struct rtsx_pcr *pcr, u16 addr, u8 mask, u8 data)
 	for (i = 0; i < MAX_RW_REG_CNT; i++) {
 		val = rtsx_pci_readl(pcr, RTSX_HAIMR);
 		if ((val & HAIMR_TRANS_END) == 0) {
-			if (data != (u8)val)
+			if (data != (u8)val) {
+				pcr_dbg(pcr, "write register 0x%02x failed\n",
+					addr);
 				return -EIO;
+			}
 			return 0;
 		}
 	}
 
+	pcr_dbg(pcr, "write register 0x%02x failed\n", addr);
 	return -ETIMEDOUT;
 }
 EXPORT_SYMBOL_GPL(rtsx_pci_write_register);
@@ -120,8 +124,10 @@ int rtsx_pci_read_register(struct rtsx_pcr *pcr, u16 addr, u8 *data)
 			break;
 	}
 
-	if (i >= MAX_RW_REG_CNT)
+	if (i >= MAX_RW_REG_CNT) {
+		pcr_dbg(pcr, "read register 0x%02x failed\n", addr);
 		return -ETIMEDOUT;
+	}
 
 	if (data)
 		*data = (u8)(val & 0xFF);
@@ -157,8 +163,10 @@ int rtsx_pci_write_phy_register(struct rtsx_pcr *pcr, u8 addr, u16 val)
 		}
 	}
 
-	if (!finished)
+	if (!finished) {
+		pcr_dbg(pcr, "write phy 0x%x failed\n", addr);
 		return -ETIMEDOUT;
+	}
 
 	return 0;
 }
@@ -190,8 +198,10 @@ int rtsx_pci_read_phy_register(struct rtsx_pcr *pcr, u8 addr, u16 *val)
 		}
 	}
 
-	if (!finished)
+	if (!finished) {
+		pcr_dbg(pcr, "read phy 0x%x failed\n", addr);
 		return -ETIMEDOUT;
+	}
 
 	rtsx_pci_init_cmd(pcr);
 
@@ -199,8 +209,10 @@ int rtsx_pci_read_phy_register(struct rtsx_pcr *pcr, u8 addr, u16 *val)
 	rtsx_pci_add_cmd(pcr, READ_REG_CMD, PHYDATA1, 0, 0);
 
 	err = rtsx_pci_send_cmd(pcr, 100);
-	if (err < 0)
+	if (err < 0) {
+		pcr_dbg(pcr, "read phy 0x%x failed\n", addr);
 		return err;
+	}
 
 	ptr = rtsx_pci_get_cmd_data(pcr);
 	data = ((u16)ptr[1] << 8) | ptr[0];
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index e81f2bb..a680427 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -838,6 +838,8 @@ struct rtsx_pcr {
 #define PCI_VID(pcr)			((pcr)->pci->vendor)
 #define PCI_PID(pcr)			((pcr)->pci->device)
 
+#define pcr_dbg(pcr, fmt, arg...)			\
+	dev_dbg(&(pcr)->pci->dev, fmt, ##arg)
 #define SDR104_PHASE(val)		((val) & 0xFF)
 #define SDR50_PHASE(val)		(((val) >> 8) & 0xFF)
 #define DDR50_PHASE(val)		(((val) >> 16) & 0xFF)
-- 
1.9.1

