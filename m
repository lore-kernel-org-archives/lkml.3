Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab3KGDRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 22:17:35 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:55300 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab3KGDRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 22:17:32 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.37 with qID rA73GiYi019235, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>
CC: <sameo@linux.intel.com>, <maximlevitsky@gmail.com>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <oakad@yahoo.com>, <wei_wang@realsil.com.cn>,
        Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH] memstick: rtsx: fix ms card data transfer bug
Date: Thu, 7 Nov 2013 11:18:23 +0800
Message-ID: <1383794303-9447-1-git-send-email-micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

This patch is used to add support for ms card. The main difference
between ms card and mspro card is long data transfer mode. mspro card
can use auto mode DMA for long data transfer, but ms can not use this
mode, it should use normal mode DMA.

The memstick core add support for ms card, but the original driver will
make ms card fail at initialize, because it use auto mode DMA. This
patch can make ms card work properly.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/memstick/host/rtsx_pci_ms.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/memstick/host/rtsx_pci_ms.c b/drivers/memstick/host/rtsx_pci_ms.c
index 25f8f93..2a635b6 100644
--- a/drivers/memstick/host/rtsx_pci_ms.c
+++ b/drivers/memstick/host/rtsx_pci_ms.c
@@ -145,6 +145,8 @@ static int ms_transfer_data(struct realtek_pci_ms *host, unsigned char data_dir,
 	unsigned int length = sg->length;
 	u16 sec_cnt = (u16)(length / 512);
 	u8 val, trans_mode, dma_dir;
+	struct memstick_dev *card = host->msh->card;
+	bool pro_card = card->id.type == MEMSTICK_TYPE_PRO;
 
 	dev_dbg(ms_dev(host), "%s: tpc = 0x%02x, data_dir = %s, length = %d\n",
 			__func__, tpc, (data_dir == READ) ? "READ" : "WRITE",
@@ -152,19 +154,21 @@ static int ms_transfer_data(struct realtek_pci_ms *host, unsigned char data_dir,
 
 	if (data_dir == READ) {
 		dma_dir = DMA_DIR_FROM_CARD;
-		trans_mode = MS_TM_AUTO_READ;
+		trans_mode = pro_card ? MS_TM_AUTO_READ : MS_TM_NORMAL_READ;
 	} else {
 		dma_dir = DMA_DIR_TO_CARD;
-		trans_mode = MS_TM_AUTO_WRITE;
+		trans_mode = pro_card ? MS_TM_AUTO_WRITE : MS_TM_NORMAL_WRITE;
 	}
 
 	rtsx_pci_init_cmd(pcr);
 
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, MS_TPC, 0xFF, tpc);
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, MS_SECTOR_CNT_H,
-			0xFF, (u8)(sec_cnt >> 8));
-	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, MS_SECTOR_CNT_L,
-			0xFF, (u8)sec_cnt);
+	if (pro_card) {
+		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, MS_SECTOR_CNT_H,
+				0xFF, (u8)(sec_cnt >> 8));
+		rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, MS_SECTOR_CNT_L,
+				0xFF, (u8)sec_cnt);
+	}
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, MS_TRANS_CFG, 0xFF, cfg);
 
 	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, IRQSTAT0,
@@ -192,8 +196,14 @@ static int ms_transfer_data(struct realtek_pci_ms *host, unsigned char data_dir,
 	}
 
 	rtsx_pci_read_register(pcr, MS_TRANS_CFG, &val);
-	if (val & (MS_INT_CMDNK | MS_INT_ERR | MS_CRC16_ERR | MS_RDY_TIMEOUT))
-		return -EIO;
+	if (pro_card) {
+		if (val & (MS_INT_CMDNK | MS_INT_ERR |
+				MS_CRC16_ERR | MS_RDY_TIMEOUT))
+			return -EIO;
+	} else {
+		if (val & (MS_CRC16_ERR | MS_RDY_TIMEOUT))
+			return -EIO;
+	}
 
 	return 0;
 }
@@ -462,8 +472,8 @@ static int rtsx_pci_ms_set_param(struct memstick_host *msh,
 			clock = 19000000;
 			ssc_depth = RTSX_SSC_DEPTH_500K;
 
-			err = rtsx_pci_write_register(pcr, MS_CFG,
-					0x18, MS_BUS_WIDTH_1);
+			err = rtsx_pci_write_register(pcr, MS_CFG, 0x58,
+					MS_BUS_WIDTH_1 | PUSH_TIME_DEFAULT);
 			if (err < 0)
 				return err;
 		} else if (value == MEMSTICK_PAR4) {
-- 
1.7.9.5

