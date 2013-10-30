Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab3J3Gi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 02:38:57 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:35880 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab3J3Gi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 02:38:56 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.37 with qID r9U6ceBP016705, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>
CC: <sameo@linux.intel.com>, <maximlevitsky@gmail.com>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>,
        <oakad@yahoo.com>, <wei_wang@realsil.com.cn>,
        Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH] memstick: rtsx: fix ms card data transfer bug
Date: Wed, 30 Oct 2013 14:40:16 +0800
Message-ID: <1383115216-11967-1-git-send-email-micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

unlike mspro card, ms card use normal read/write mode for DMA
data transfer.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/memstick/host/rtsx_pci_ms.c |   87 ++++++++++++++++++++++++++++++++---
 1 file changed, 81 insertions(+), 6 deletions(-)

diff --git a/drivers/memstick/host/rtsx_pci_ms.c b/drivers/memstick/host/rtsx_pci_ms.c
index 25f8f93..95eb208 100644
--- a/drivers/memstick/host/rtsx_pci_ms.c
+++ b/drivers/memstick/host/rtsx_pci_ms.c
@@ -137,8 +137,9 @@ static int ms_power_off(struct realtek_pci_ms *host)
 	return rtsx_pci_card_pull_ctl_disable(pcr, RTSX_MS_CARD);
 }
 
-static int ms_transfer_data(struct realtek_pci_ms *host, unsigned char data_dir,
-		u8 tpc, u8 cfg, struct scatterlist *sg)
+static int mspro_transfer_data(struct realtek_pci_ms *host,
+			unsigned char data_dir, u8 tpc, u8 cfg,
+			struct scatterlist *sg)
 {
 	struct rtsx_pcr *pcr = host->pcr;
 	int err;
@@ -198,6 +199,77 @@ static int ms_transfer_data(struct realtek_pci_ms *host, unsigned char data_dir,
 	return 0;
 }
 
+static int ms_transfer_data(struct realtek_pci_ms *host,
+			unsigned char data_dir, u8 tpc, u8 cfg,
+			struct scatterlist *sg)
+{
+	struct rtsx_pcr *pcr = host->pcr;
+	int err;
+	unsigned int length = sg->length;
+	u8 val, trans_mode, dma_dir;
+	struct completion trans_done;
+	int timeleft;
+
+	dev_dbg(ms_dev(host), "%s: tpc = 0x%02x, data_dir = %s, length = %d\n",
+			__func__, tpc, (data_dir == READ) ? "READ" : "WRITE",
+			length);
+
+	if (data_dir == READ) {
+		dma_dir = DMA_DIR_FROM_CARD;
+		trans_mode = MS_TM_NORMAL_READ;
+	} else {
+		dma_dir = DMA_DIR_TO_CARD;
+		trans_mode = MS_TM_NORMAL_WRITE;
+	}
+
+	rtsx_pci_init_cmd(pcr);
+
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, MS_TPC, 0xFF, tpc);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, MS_TRANS_CFG, 0xFF, cfg);
+
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, IRQSTAT0,
+			DMA_DONE_INT, DMA_DONE_INT);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, DMATC3, 0xFF, (u8)(length >> 24));
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, DMATC2, 0xFF, (u8)(length >> 16));
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, DMATC1, 0xFF, (u8)(length >> 8));
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, DMATC0, 0xFF, (u8)length);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, DMACTL,
+			0x03 | DMA_PACK_SIZE_MASK, dma_dir | DMA_EN | DMA_512);
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, CARD_DATA_SOURCE,
+			0x01, RING_BUFFER);
+
+	rtsx_pci_add_cmd(pcr, WRITE_REG_CMD, MS_TRANSFER,
+			0xFF, MS_TRANSFER_START | trans_mode);
+	rtsx_pci_add_cmd(pcr, CHECK_REG_CMD, MS_TRANSFER,
+			MS_TRANSFER_END, MS_TRANSFER_END);
+
+	rtsx_pci_send_cmd_no_wait(pcr);
+
+	err = rtsx_pci_transfer_data(pcr, sg, 1, data_dir == READ, 10000);
+	if (err < 0) {
+		ms_print_debug_regs(host);
+		ms_clear_error(host);
+		return err;
+	}
+
+	if (pcr->trans_result == TRANS_NOT_READY) {
+		init_completion(&trans_done);
+		timeleft = wait_for_completion_interruptible_timeout(
+			&trans_done, 1000);
+		if (timeleft < 0) {
+			dev_dbg(ms_dev(host),
+				"%s: timeout wait for ok interrupt.\n",
+				__func__);
+			return -ETIMEDOUT;
+		}
+	}
+	rtsx_pci_read_register(pcr, MS_TRANS_CFG, &val);
+	if (val & (MS_CRC16_ERR | MS_RDY_TIMEOUT))
+		return -EIO;
+
+	return 0;
+}
+
 static int ms_write_bytes(struct realtek_pci_ms *host, u8 tpc,
 		u8 cfg, u8 cnt, u8 *data, u8 *int_reg)
 {
@@ -340,6 +412,7 @@ static int ms_read_bytes(struct realtek_pci_ms *host, u8 tpc,
 static int rtsx_pci_ms_issue_cmd(struct realtek_pci_ms *host)
 {
 	struct memstick_request *req = host->req;
+	struct memstick_dev *card = host->msh->card;
 	int err = 0;
 	u8 cfg = 0, int_reg;
 
@@ -350,9 +423,12 @@ static int rtsx_pci_ms_issue_cmd(struct realtek_pci_ms *host)
 			cfg = WAIT_INT;
 	}
 
-	if (req->long_data) {
+	if (req->long_data && card->id.type != MEMSTICK_TYPE_PRO) {
 		err = ms_transfer_data(host, req->data_dir,
 				req->tpc, cfg, &(req->sg));
+	} else if (req->long_data) {
+		err = mspro_transfer_data(host, req->data_dir,
+				req->tpc, cfg, &(req->sg));
 	} else {
 		if (req->data_dir == READ) {
 			err = ms_read_bytes(host, req->tpc, cfg,
@@ -461,9 +537,8 @@ static int rtsx_pci_ms_set_param(struct memstick_host *msh,
 		if (value == MEMSTICK_SERIAL) {
 			clock = 19000000;
 			ssc_depth = RTSX_SSC_DEPTH_500K;
-
-			err = rtsx_pci_write_register(pcr, MS_CFG,
-					0x18, MS_BUS_WIDTH_1);
+			err = rtsx_pci_write_register(pcr, MS_CFG, 0x58,
+					MS_BUS_WIDTH_1 | PUSH_TIME_DEFAULT);
 			if (err < 0)
 				return err;
 		} else if (value == MEMSTICK_PAR4) {
-- 
1.7.9.5

