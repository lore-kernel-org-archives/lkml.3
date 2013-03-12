Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802Ab3CLK6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:58:45 -0400
Received: from multi.imgtec.com ([194.200.65.239]:44029 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623Ab3CLK6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:58:44 -0400
From: Markos Chandras <markos.chandras@imgtec.com>
To: <linux-mmc@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        "Jaehoon Chung" <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>
Subject: [PATCH 3/3] dw_mmc: Handle unaligned data submission correctly
Date: Tue, 12 Mar 2013 10:53:13 +0000
Message-ID: <1363085593-22214-3-git-send-email-markos.chandras@imgtec.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1363085593-22214-1-git-send-email-markos.chandras@imgtec.com>
References: <1363085593-22214-1-git-send-email-markos.chandras@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_12_10_58_31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f9c2a0dc42a6938ff2a80e55ca2bbd1d5581c72e
"mmc: dw_mmc: Fix PIO mode with support of highmem" introduced
a regression since v3.2 making the mmc_test hang on test #13
with a "Data starvation by host timeout" interrupt.

This is because, sg_mapping_iter is used to iterate through the
data which spans on multiple pages. The problem is detected on
unaligned data submission where the code previously checked for
!(sg_next(host->sg)) which is true because we only have a single
scatter/gather list which then expands to multiple pages.
Therefore, the driver incorrectly assumed that this was the last
list item and submitted unaligned data to the mmc device. This
overflowed the FIFO on the device before all the data were written
to it. The code was fixed to only submit unaligned data when we are
handling the last sg_miter item by checking whether we reached
the desired data length or not.

The patch was tested against mmc_test and all the tests passed.

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Cc: Seungwon Jeon <tgih.jun@samsung.com>
Cc: Jaehoon Chung <jh80.chung@samsung.com>
Cc: Chris Ball <cjb@laptop.org>
---
The patch is based on Chris Ball's mmc-next branch

 drivers/mmc/host/dw_mmc.c |   33 ++++++++++++++++++++++++---------
 1 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 4e7a5c8..d3f68d4 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1191,12 +1191,15 @@ static void dw_mci_pull_final_bytes(struct dw_mci *host, void *buf, int cnt)
 
 static void dw_mci_push_data16(struct dw_mci *host, void *buf, int cnt)
 {
+	struct mmc_data *data = host->data;
+	int init_cnt = cnt;
+
 	/* try and push anything in the part_buf */
 	if (unlikely(host->part_buf_count)) {
 		int len = dw_mci_push_part_bytes(host, buf, cnt);
 		buf += len;
 		cnt -= len;
-		if (!sg_next(host->sg) || host->part_buf_count == 2) {
+		if (host->part_buf_count == 2) {
 			mci_writew(host, DATA(host->data_offset),
 					host->part_buf16);
 			host->part_buf_count = 0;
@@ -1229,9 +1232,11 @@ static void dw_mci_push_data16(struct dw_mci *host, void *buf, int cnt)
 	/* put anything remaining in the part_buf */
 	if (cnt) {
 		dw_mci_set_part_bytes(host, buf, cnt);
-		if (!sg_next(host->sg))
+		 /* Push data if we have reached the expected data length */
+		if ((data->bytes_xfered + init_cnt) ==
+		    (data->blksz * data->blocks))
 			mci_writew(host, DATA(host->data_offset),
-					host->part_buf16);
+				   host->part_buf16);
 	}
 }
 
@@ -1269,12 +1274,15 @@ static void dw_mci_pull_data16(struct dw_mci *host, void *buf, int cnt)
 
 static void dw_mci_push_data32(struct dw_mci *host, void *buf, int cnt)
 {
+	struct mmc_data *data = host->data;
+	int init_cnt = cnt;
+
 	/* try and push anything in the part_buf */
 	if (unlikely(host->part_buf_count)) {
 		int len = dw_mci_push_part_bytes(host, buf, cnt);
 		buf += len;
 		cnt -= len;
-		if (!sg_next(host->sg) || host->part_buf_count == 4) {
+		if (host->part_buf_count == 4) {
 			mci_writel(host, DATA(host->data_offset),
 					host->part_buf32);
 			host->part_buf_count = 0;
@@ -1307,9 +1315,11 @@ static void dw_mci_push_data32(struct dw_mci *host, void *buf, int cnt)
 	/* put anything remaining in the part_buf */
 	if (cnt) {
 		dw_mci_set_part_bytes(host, buf, cnt);
-		if (!sg_next(host->sg))
+		 /* Push data if we have reached the expected data length */
+		if ((data->bytes_xfered + init_cnt) ==
+		    (data->blksz * data->blocks))
 			mci_writel(host, DATA(host->data_offset),
-						host->part_buf32);
+				   host->part_buf32);
 	}
 }
 
@@ -1347,12 +1357,15 @@ static void dw_mci_pull_data32(struct dw_mci *host, void *buf, int cnt)
 
 static void dw_mci_push_data64(struct dw_mci *host, void *buf, int cnt)
 {
+	struct mmc_data *data = host->data;
+	int init_cnt = cnt;
+
 	/* try and push anything in the part_buf */
 	if (unlikely(host->part_buf_count)) {
 		int len = dw_mci_push_part_bytes(host, buf, cnt);
 		buf += len;
 		cnt -= len;
-		if (!sg_next(host->sg) || host->part_buf_count == 8) {
+		if (host->part_buf_count == 8) {
 			mci_writew(host, DATA(host->data_offset),
 					host->part_buf);
 			host->part_buf_count = 0;
@@ -1385,9 +1398,11 @@ static void dw_mci_push_data64(struct dw_mci *host, void *buf, int cnt)
 	/* put anything remaining in the part_buf */
 	if (cnt) {
 		dw_mci_set_part_bytes(host, buf, cnt);
-		if (!sg_next(host->sg))
+		/* Push data if we have reached the expected data length */
+		if ((data->bytes_xfered + init_cnt) ==
+		    (data->blksz * data->blocks))
 			mci_writeq(host, DATA(host->data_offset),
-					host->part_buf);
+				   host->part_buf);
 	}
 }
 
-- 
1.7.1


