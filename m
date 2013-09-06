Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751103Ab3IFGC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 02:02:29 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64715 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab3IFGCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 02:02:25 -0400
X-AuditID: 9c930197-b7b44ae00000347f-d8-52296fef5abd
From: Chanho Min <chanho.min@lge.com>
To: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Cc: HyoJun Im <hyojun.im@lge.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gunho Lee <gunho.lee@lge.com>,
        Chanho Min <chanho.min@lge.com>
Subject: [PATCH] mmc: sdhci: add support for pre_req and post_req
Date: Fri,  6 Sep 2013 15:01:53 +0900
Message-Id: <1378447313-12935-1-git-send-email-chanho.min@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports non-blocking mmc request function for the sdchi driver.
(commit: aa8b683a7d392271ed349c6ab9f36b8c313794b7)

pre_req() runs dma_map_sg(), post_req() runs dma_unmap_sg.  If not calling
pre_req() before sdhci_request(), dma_map_sg will be issued before
starting the transfer.  It is optional to use pre_req().  If issuing
pre_req(), post_req() must be called as well.

benchmark results:
 ARM CA9 1GHz, UHS DDR50 mode

 Before:
 dd if=/dev/mmcblk0p15 of=/dev/null bs=64k count=1024
 67108864 bytes (64.0MB) copied, 1.188846 seconds, 53.8MB/s

 After:
 dd if=/dev/mmcblk0p15 of=/dev/null bs=64k count=1024
 67108864 bytes (64.0MB) copied, 0.993098 seconds, 64.4MB/s

Signed-off-by: Chanho Min <chanho.min@lge.com>
---
 drivers/mmc/host/sdhci.c  |   96 +++++++++++++++++++++++++++++++++++++++------
 include/linux/mmc/sdhci.h |    6 +++
 2 files changed, 90 insertions(+), 12 deletions(-)

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 2ea429c..0465a9a 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -465,6 +465,42 @@ static void sdhci_set_adma_desc(u8 *desc, u32 addr, int len, unsigned cmd)
 	dataddr[0] = cpu_to_le32(addr);
 }
 
+static int sdhci_pre_dma_transfer(struct sdhci_host *host,
+				       struct mmc_data *data,
+				       struct sdhci_next *next)
+{
+	int sg_count = 0;
+
+	if (!next && data->host_cookie &&
+	    data->host_cookie != host->next_data.cookie) {
+		pr_warn("[%s] invalid cookie: data->host_cookie %d"
+			" host->next_data.cookie %d\n",
+			__func__, data->host_cookie, host->next_data.cookie);
+		data->host_cookie = 0;
+	}
+
+	/* Check if next job is already prepared */
+	if (next ||
+	    (!next && data->host_cookie != host->next_data.cookie)) {
+		sg_count = dma_map_sg(mmc_dev(host->mmc), data->sg,
+					data->sg_len,
+					(data->flags & MMC_DATA_READ) ?
+						DMA_FROM_DEVICE :
+						DMA_TO_DEVICE);
+	} else {
+		sg_count = host->next_data.sg_count;
+		host->next_data.sg_count = 0;
+	}
+
+	if (next) {
+		next->sg_count = sg_count;
+		data->host_cookie = ++next->cookie < 0 ? 1 : next->cookie;
+	} else
+		host->sg_count = sg_count;
+
+	return sg_count;
+}
+
 static int sdhci_adma_table_pre(struct sdhci_host *host,
 	struct mmc_data *data)
 {
@@ -502,8 +538,8 @@ static int sdhci_adma_table_pre(struct sdhci_host *host,
 		goto fail;
 	BUG_ON(host->align_addr & 0x3);
 
-	host->sg_count = dma_map_sg(mmc_dev(host->mmc),
-		data->sg, data->sg_len, direction);
+	host->sg_count = sdhci_pre_dma_transfer(host, data, NULL);
+
 	if (host->sg_count == 0)
 		goto unmap_align;
 
@@ -643,9 +679,10 @@ static void sdhci_adma_table_post(struct sdhci_host *host,
 			}
 		}
 	}
-
-	dma_unmap_sg(mmc_dev(host->mmc), data->sg,
-		data->sg_len, direction);
+	if (!data->host_cookie) {
+		dma_unmap_sg(mmc_dev(host->mmc), data->sg,
+			data->sg_len, direction);
+	}
 }
 
 static u8 sdhci_calc_timeout(struct sdhci_host *host, struct mmc_command *cmd)
@@ -824,12 +861,8 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_command *cmd)
 			}
 		} else {
 			int sg_cnt;
+			sg_cnt = sdhci_pre_dma_transfer(host, data, NULL);
 
-			sg_cnt = dma_map_sg(mmc_dev(host->mmc),
-					data->sg, data->sg_len,
-					(data->flags & MMC_DATA_READ) ?
-						DMA_FROM_DEVICE :
-						DMA_TO_DEVICE);
 			if (sg_cnt == 0) {
 				/*
 				 * This only happens when someone fed
@@ -928,9 +961,12 @@ static void sdhci_finish_data(struct sdhci_host *host)
 		if (host->flags & SDHCI_USE_ADMA)
 			sdhci_adma_table_post(host, data);
 		else {
-			dma_unmap_sg(mmc_dev(host->mmc), data->sg,
-				data->sg_len, (data->flags & MMC_DATA_READ) ?
+			if (!data->host_cookie) {
+				dma_unmap_sg(mmc_dev(host->mmc), data->sg,
+					data->sg_len,
+					(data->flags & MMC_DATA_READ) ?
 					DMA_FROM_DEVICE : DMA_TO_DEVICE);
+			}
 		}
 	}
 
@@ -2066,8 +2102,42 @@ static void sdhci_card_event(struct mmc_host *mmc)
 	spin_unlock_irqrestore(&host->lock, flags);
 }
 
+static void sdhci_post_req(struct mmc_host *mmc, struct mmc_request *mrq,
+				int err)
+{
+	struct sdhci_host *host = mmc_priv(mmc);
+	struct mmc_data *data = mrq->data;
+
+	if (host->flags & SDHCI_REQ_USE_DMA) {
+		dma_unmap_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
+			(data->flags & MMC_DATA_READ) ?
+			DMA_FROM_DEVICE :
+			DMA_TO_DEVICE);
+		data->host_cookie = 0;
+	}
+}
+
+static void sdhci_pre_req(struct mmc_host *mmc, struct mmc_request *mrq,
+			       bool is_first_req)
+{
+	struct sdhci_host *host = mmc_priv(mmc);
+	struct mmc_data *data = mrq->data;
+
+	if (mrq->data->host_cookie) {
+		mrq->data->host_cookie = 0;
+		return;
+	}
+
+	if (host->flags & SDHCI_REQ_USE_DMA) {
+		if (!sdhci_pre_dma_transfer(host, data, &host->next_data))
+			mrq->data->host_cookie = 0;
+	}
+}
+
 static const struct mmc_host_ops sdhci_ops = {
 	.request	= sdhci_request,
+	.post_req	= sdhci_post_req,
+	.pre_req	= sdhci_pre_req,
 	.set_ios	= sdhci_set_ios,
 	.get_cd		= sdhci_get_cd,
 	.get_ro		= sdhci_get_ro,
@@ -3204,6 +3274,8 @@ int sdhci_add_host(struct sdhci_host *host)
 	}
 #endif
 
+	host->next_data.cookie = 1;
+
 	mmiowb();
 
 	mmc_add_host(mmc);
diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
index b838ffc..220a515 100644
--- a/include/linux/mmc/sdhci.h
+++ b/include/linux/mmc/sdhci.h
@@ -17,6 +17,11 @@
 #include <linux/io.h>
 #include <linux/mmc/host.h>
 
+struct sdhci_next {
+	unsigned int	sg_count;
+	s32		cookie;
+};
+
 struct sdhci_host {
 	/* Data set by hardware interface driver */
 	const char *hw_name;	/* Hardware bus name */
@@ -177,5 +182,6 @@ struct sdhci_host {
 	struct timer_list	tuning_timer;	/* Timer for tuning */
 
 	unsigned long private[0] ____cacheline_aligned;
+	struct sdhci_next	next_data;
 };
 #endif /* LINUX_MMC_SDHCI_H */
-- 
1.7.9.5

