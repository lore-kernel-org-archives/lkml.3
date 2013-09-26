Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab3IZHd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:33:28 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:12053 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab3IZHd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:33:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 26 Sep 2013 00:33:26 -0700
Message-ID: <5243E341.2070109@nvidia.com>
Date: Thu, 26 Sep 2013 13:03:21 +0530
From: Vishal Annapurve <vannapurve@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] mmc: Reducing cache operations in the host driver
Content-Type: multipart/mixed;
	boundary="------------000509020609050902040907"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------000509020609050902040907
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I am attaching a patch which attempts to reduce the cache operations 
while doing
MMC transactions. I have tested it only on arm and the tests performed 
with benchmarks
like iozone/bonnie showed that the data integrity is maintained while 
I/O bandwidth is increased.
I have tested it with K3.1 and I believe it can apply to 3.12 also.

My understanding from the important API's dealing with DMA memory is as 
follows:
1) dma_map_sg/ dma_sync_sg_for_device -> make sure that cache is flushed 
after CPU is done
updating the memory allocated for DMA and is called before giving 
control of DMA memory to
the device.
2) dma_unmap_sg/dma_sync_sg_for_cpu -> Make sure that cache is 
invalidated before
reading from the DMA area which was used by the device to write the data.

About the patch:
Changes in sdhci_adma_table_pre make sure that we only flush if we have 
updated DMA
area after the call to dma_map_sg.

Changes in sdhci_adma_table_post take care of following:
1) Remove invalidation of cache for memory locations which are going to 
be updated by CPU,
as they are not being read.
2) Perform the unmap of sg before CPU accesses DMA area as the changes 
we did for unaligned
cases might get lost due to invalidation afterwards. I was not able to 
induce unaligned buffer
accesses using normal filesystem/raw device operations. Maybe that's why 
this issue was not
discovered so far.
3) Only drawback is sg->dma_address gets used after the call to 
dma_unmap_sg.

I would like to understand if this patch can cause any regressions for 
any of the architectures
or with the MMC functionality.

Thanks & Regards,
Vishal Annapurve



--------------000509020609050902040907
Content-Type: text/x-patch; name="arm_mmc_reduce_cache_ops.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="arm_mmc_reduce_cache_ops.patch"

Author: Vishal Annapurve <vannapurve@nvidia.com>

    MMC: Remove unnecessary cache operations
    
    1) This change removes unnecessary cache operations happening
    after and before DMA setup in MMC host driver.
    
    Signed-off-by: Vishal Annapurve <vannapurve@nvidia.com>

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 6e43c84..d5cd0ae 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -434,6 +434,7 @@ static int sdhci_adma_table_pre(struct sdhci_host *host,
 	dma_addr_t addr;
 	dma_addr_t align_addr;
 	int len, offset;
+	int align_buf_modified_len = 0;
 
 	struct scatterlist *sg;
 	int i;
@@ -498,6 +499,7 @@ static int sdhci_adma_table_pre(struct sdhci_host *host,
 
 			align += 4;
 			align_addr += 4;
+			align_buf_modified_len += 4;
 
 			desc += 8;
 
@@ -538,9 +540,10 @@ static int sdhci_adma_table_pre(struct sdhci_host *host,
 	/*
 	 * Resync align buffer as we might have changed it.
 	 */
-	if (data->flags & MMC_DATA_WRITE) {
+	if ((data->flags & MMC_DATA_WRITE) &&
+			align_buf_modified_len) {
 		dma_sync_single_for_device(mmc_dev(host->mmc),
-			host->align_addr, 128 * 4, direction);
+			host->align_addr, align_buf_modified_len, direction);
 	}
 
 	host->adma_addr = dma_map_single(mmc_dev(host->mmc),
@@ -583,9 +586,10 @@ static void sdhci_adma_table_post(struct sdhci_host *host,
 	dma_unmap_single(mmc_dev(host->mmc), host->align_addr,
 		128 * 4, direction);
 
+	dma_unmap_sg(mmc_dev(host->mmc), data->sg,
+		data->sg_len, direction);
+
 	if (data->flags & MMC_DATA_READ) {
-		dma_sync_sg_for_cpu(mmc_dev(host->mmc), data->sg,
-			data->sg_len, direction);
 
 		align = host->align_buffer;
 
@@ -602,9 +606,6 @@ static void sdhci_adma_table_post(struct sdhci_host *host,
 			}
 		}
 	}
-
-	dma_unmap_sg(mmc_dev(host->mmc), data->sg,
-		data->sg_len, direction);
 }
 
 static u8 sdhci_calc_timeout(struct sdhci_host *host, struct mmc_command *cmd)

--------------000509020609050902040907--
