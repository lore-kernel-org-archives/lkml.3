Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbaKFRVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:21:10 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:52798 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750955AbaKFRVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:21:07 -0500
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org
Cc: LAKML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] DMA: Fix allocation size for PL330 data buffer depth.
Date: Thu,  6 Nov 2014 17:20:12 +0000
Message-Id: <1415294412-13818-1-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The datasheet for PL330 says that the data buffer value in the CRD
register is 10bits wide. However, the value stored is "minus one",
which the driver corrects for. Maximum value that the data buffer
depth can have is 1024 lines, which requires 11 bits for storage.

While making updates I found printing the peripheral ID as a hex
value to be more useful as the datasheet shows the values that way.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 drivers/dma/pl330.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 4839bfa..7f62b73 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -271,7 +271,7 @@ struct pl330_config {
 #define DMAC_MODE_NS	(1 << 0)
 	unsigned int	mode;
 	unsigned int	data_bus_width:10; /* In number of bits */
-	unsigned int	data_buf_dep:10;
+	unsigned int	data_buf_dep:11;
 	unsigned int	num_chan:4;
 	unsigned int	num_peri:6;
 	u32		peri_ns;
@@ -2732,7 +2732,7 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 
 
 	dev_info(&adev->dev,
-		"Loaded driver for PL330 DMAC-%d\n", adev->periphid);
+		"Loaded driver for PL330 DMAC-%x\n", adev->periphid);
 	dev_info(&adev->dev,
 		"\tDBUFF-%ux%ubytes Num_Chans-%u Num_Peri-%u Num_Events-%u\n",
 		pcfg->data_buf_dep, pcfg->data_bus_width / 8, pcfg->num_chan,
-- 
2.1.3

