Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785Ab3CLK5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:57:14 -0400
Received: from multi.imgtec.com ([194.200.65.239]:44002 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab3CLK5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:57:11 -0400
From: Markos Chandras <markos.chandras@imgtec.com>
To: <linux-mmc@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        "Jaehoon Chung" <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>
Subject: [PATCH 2/3] dw_mmc: Avoid adding the number of transmitted bytes twice
Date: Tue, 12 Mar 2013 10:53:12 +0000
Message-ID: <1363085593-22214-2-git-send-email-markos.chandras@imgtec.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1363085593-22214-1-git-send-email-markos.chandras@imgtec.com>
References: <1363085593-22214-1-git-send-email-markos.chandras@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_12_10_57_08
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, it was possible to add either 0 bytes or add nbytes
twice if we broke out of the outer loop and then carry on to the
"done" label. This is now fixed by adding the transferred bytes
right after the pull/pop operation

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Cc: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Chris Ball <cjb@laptop.org>
---
The patch is based on Chris Ball's mmc-next branch

 drivers/mmc/host/dw_mmc.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 78c7251..4e7a5c8 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1446,7 +1446,7 @@ static void dw_mci_read_data_pio(struct dw_mci *host)
 	struct mmc_data	*data = host->data;
 	int shift = host->data_shift;
 	u32 status;
-	unsigned int nbytes = 0, len;
+	unsigned int len;
 	unsigned int remain, fcnt;
 
 	do {
@@ -1465,8 +1465,8 @@ static void dw_mci_read_data_pio(struct dw_mci *host)
 			if (!len)
 				break;
 			dw_mci_pull_data(host, (void *)(buf + offset), len);
+			data->bytes_xfered += len;
 			offset += len;
-			nbytes += len;
 			remain -= len;
 		} while (remain);
 
@@ -1474,7 +1474,6 @@ static void dw_mci_read_data_pio(struct dw_mci *host)
 		status = mci_readl(host, MINTSTS);
 		mci_writel(host, RINTSTS, SDMMC_INT_RXDR);
 	} while (status & SDMMC_INT_RXDR); /*if the RXDR is ready read again*/
-	data->bytes_xfered += nbytes;
 
 	if (!remain) {
 		if (!sg_miter_next(sg_miter))
@@ -1485,7 +1484,6 @@ static void dw_mci_read_data_pio(struct dw_mci *host)
 	return;
 
 done:
-	data->bytes_xfered += nbytes;
 	sg_miter_stop(sg_miter);
 	host->sg = NULL;
 	smp_wmb();
@@ -1500,7 +1498,7 @@ static void dw_mci_write_data_pio(struct dw_mci *host)
 	struct mmc_data	*data = host->data;
 	int shift = host->data_shift;
 	u32 status;
-	unsigned int nbytes = 0, len;
+	unsigned int len;
 	unsigned int fifo_depth = host->fifo_depth;
 	unsigned int remain, fcnt;
 
@@ -1521,8 +1519,8 @@ static void dw_mci_write_data_pio(struct dw_mci *host)
 			if (!len)
 				break;
 			host->push_data(host, (void *)(buf + offset), len);
+			data->bytes_xfered += len;
 			offset += len;
-			nbytes += len;
 			remain -= len;
 		} while (remain);
 
@@ -1530,7 +1528,6 @@ static void dw_mci_write_data_pio(struct dw_mci *host)
 		status = mci_readl(host, MINTSTS);
 		mci_writel(host, RINTSTS, SDMMC_INT_TXDR);
 	} while (status & SDMMC_INT_TXDR); /* if TXDR write again */
-	data->bytes_xfered += nbytes;
 
 	if (!remain) {
 		if (!sg_miter_next(sg_miter))
@@ -1541,7 +1538,6 @@ static void dw_mci_write_data_pio(struct dw_mci *host)
 	return;
 
 done:
-	data->bytes_xfered += nbytes;
 	sg_miter_stop(sg_miter);
 	host->sg = NULL;
 	smp_wmb();
-- 
1.7.1


