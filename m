Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752459AbaFFHCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:02:36 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:41829 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbaFFHCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:02:34 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s56714EU012322, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>, <chris@printf.net>,
        <ulf.hansson@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <dan.carpenter@oracle.com>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH 1/2] mfd: rtsx: add dma transfer function
Date: Fri, 6 Jun 2014 15:05:44 +0800
Message-ID: <9021eae37d96aa027d00ae4a7b6cd84dbbd1b6b5.1402037564.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1402037562.git.micky_ching@realsil.com.cn>
References: <cover.1402037562.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

rtsx driver using a single function for transfer data, dma map/unmap are
placed in one fix function. We need map/unmap dma in different place(for
mmc async driver), so add three function for dma map, dma transfer and
dma unmap.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mfd/rtsx_pcr.c       |   76 ++++++++++++++++++++++++++----------------
 include/linux/mfd/rtsx_pci.h |    6 ++++
 2 files changed, 54 insertions(+), 28 deletions(-)

diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 1d15735..d01b8c2 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -337,40 +337,64 @@ static void rtsx_pci_add_sg_tbl(struct rtsx_pcr *pcr,
 int rtsx_pci_transfer_data(struct rtsx_pcr *pcr, struct scatterlist *sglist,
 		int num_sg, bool read, int timeout)
 {
-	struct completion trans_done;
-	u8 dir;
-	int err = 0, i, count;
-	long timeleft;
-	unsigned long flags;
-	struct scatterlist *sg;
-	enum dma_data_direction dma_dir;
-	u32 val;
-	dma_addr_t addr;
-	unsigned int len;
+	int err = 0, count;
 
 	dev_dbg(&(pcr->pci->dev), "--> %s: num_sg = %d\n", __func__, num_sg);
+	count = rtsx_pci_dma_map_sg(pcr, sglist, num_sg, read);
+	if (count < 1)
+		return -EINVAL;
+	dev_dbg(&(pcr->pci->dev), "DMA mapping count: %d\n", count);
+
+	err = rtsx_pci_dma_transfer(pcr, sglist, count, read, timeout);
+
+	rtsx_pci_dma_unmap_sg(pcr, sglist, num_sg, read);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(rtsx_pci_transfer_data);
+
+int rtsx_pci_dma_map_sg(struct rtsx_pcr *pcr, struct scatterlist *sglist,
+		int num_sg, bool read)
+{
+	enum dma_data_direction dir = read ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
 
-	/* don't transfer data during abort processing */
 	if (pcr->remove_pci)
 		return -EINVAL;
 
 	if ((sglist == NULL) || (num_sg <= 0))
 		return -EINVAL;
 
-	if (read) {
-		dir = DEVICE_TO_HOST;
-		dma_dir = DMA_FROM_DEVICE;
-	} else {
-		dir = HOST_TO_DEVICE;
-		dma_dir = DMA_TO_DEVICE;
-	}
+	return dma_map_sg(&(pcr->pci->dev), sglist, num_sg, dir);
+}
+EXPORT_SYMBOL_GPL(rtsx_pci_dma_map_sg);
 
-	count = dma_map_sg(&(pcr->pci->dev), sglist, num_sg, dma_dir);
-	if (count < 1) {
-		dev_err(&(pcr->pci->dev), "scatterlist map failed\n");
+void rtsx_pci_dma_unmap_sg(struct rtsx_pcr *pcr, struct scatterlist *sglist,
+		int num_sg, bool read)
+{
+	enum dma_data_direction dir = read ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+
+	dma_unmap_sg(&(pcr->pci->dev), sglist, num_sg, dir);
+}
+EXPORT_SYMBOL_GPL(rtsx_pci_dma_unmap_sg);
+
+int rtsx_pci_dma_transfer(struct rtsx_pcr *pcr, struct scatterlist *sglist,
+		int count, bool read, int timeout)
+{
+	struct completion trans_done;
+	struct scatterlist *sg;
+	dma_addr_t addr;
+	long timeleft;
+	unsigned long flags;
+	unsigned int len;
+	int i, err = 0;
+	u32 val;
+	u8 dir = read ? DEVICE_TO_HOST : HOST_TO_DEVICE;
+
+	if (pcr->remove_pci)
+		return -ENODEV;
+
+	if ((sglist == NULL) || (count < 1))
 		return -EINVAL;
-	}
-	dev_dbg(&(pcr->pci->dev), "DMA mapping count: %d\n", count);
 
 	val = ((u32)(dir & 0x01) << 29) | TRIG_DMA | ADMA_MODE;
 	pcr->sgi = 0;
@@ -400,12 +424,10 @@ int rtsx_pci_transfer_data(struct rtsx_pcr *pcr, struct scatterlist *sglist,
 	}
 
 	spin_lock_irqsave(&pcr->lock, flags);
-
 	if (pcr->trans_result == TRANS_RESULT_FAIL)
 		err = -EINVAL;
 	else if (pcr->trans_result == TRANS_NO_DEVICE)
 		err = -ENODEV;
-
 	spin_unlock_irqrestore(&pcr->lock, flags);
 
 out:
@@ -413,8 +435,6 @@ out:
 	pcr->done = NULL;
 	spin_unlock_irqrestore(&pcr->lock, flags);
 
-	dma_unmap_sg(&(pcr->pci->dev), sglist, num_sg, dma_dir);
-
 	if ((err < 0) && (err != -ENODEV))
 		rtsx_pci_stop_cmd(pcr);
 
@@ -423,7 +443,7 @@ out:
 
 	return err;
 }
-EXPORT_SYMBOL_GPL(rtsx_pci_transfer_data);
+EXPORT_SYMBOL_GPL(rtsx_pci_dma_transfer);
 
 int rtsx_pci_read_ppbuf(struct rtsx_pcr *pcr, u8 *buf, int buf_len)
 {
diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
index a383597..74346d5 100644
--- a/include/linux/mfd/rtsx_pci.h
+++ b/include/linux/mfd/rtsx_pci.h
@@ -943,6 +943,12 @@ void rtsx_pci_send_cmd_no_wait(struct rtsx_pcr *pcr);
 int rtsx_pci_send_cmd(struct rtsx_pcr *pcr, int timeout);
 int rtsx_pci_transfer_data(struct rtsx_pcr *pcr, struct scatterlist *sglist,
 		int num_sg, bool read, int timeout);
+int rtsx_pci_dma_map_sg(struct rtsx_pcr *pcr, struct scatterlist *sglist,
+		int num_sg, bool read);
+void rtsx_pci_dma_unmap_sg(struct rtsx_pcr *pcr, struct scatterlist *sglist,
+		int num_sg, bool read);
+int rtsx_pci_dma_transfer(struct rtsx_pcr *pcr, struct scatterlist *sglist,
+		int count, bool read, int timeout);
 int rtsx_pci_read_ppbuf(struct rtsx_pcr *pcr, u8 *buf, int buf_len);
 int rtsx_pci_write_ppbuf(struct rtsx_pcr *pcr, u8 *buf, int buf_len);
 int rtsx_pci_card_pull_ctl_enable(struct rtsx_pcr *pcr, int card);
-- 
1.7.9.5

