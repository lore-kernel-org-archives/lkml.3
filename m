Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaJKQOr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:14:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:2781 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbaJKQOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:14:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="398750138"
From: Vinod Koul <vinod.koul@intel.com>
To: dmaengine@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Viresh Kumar <viresh.linux@gmail.com>,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] pata_arasan_cf: use dmaengine_terminate_all() API
Date: Sat, 11 Oct 2014 21:10:29 +0530
Message-Id: <1413042040-28222-1-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1413041973-28146-1-git-send-email-vinod.koul@intel.com>
References: <1413041973-28146-1-git-send-email-vinod.koul@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drivers should use dmaengine_terminate_all() API instead of accessing
the device_control which will be deprecated soon

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/ata/pata_arasan_cf.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index 4edb1a8..38216b9 100644
--- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -420,7 +420,7 @@ dma_xfer(struct arasan_cf_dev *acdev, dma_addr_t src, dma_addr_t dest, u32 len)
 
 	/* Wait for DMA to complete */
 	if (!wait_for_completion_timeout(&acdev->dma_completion, TIMEOUT)) {
-		chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
+		dmaengine_terminate_all(chan);
 		dev_err(acdev->host->dev, "wait_for_completion_timeout\n");
 		return -ETIMEDOUT;
 	}
@@ -928,8 +928,7 @@ static int arasan_cf_suspend(struct device *dev)
 	struct arasan_cf_dev *acdev = host->ports[0]->private_data;
 
 	if (acdev->dma_chan)
-		acdev->dma_chan->device->device_control(acdev->dma_chan,
-				DMA_TERMINATE_ALL, 0);
+		dmaengine_terminate_all(acdev->dma_chan);
 
 	cf_exit(acdev);
 	return ata_host_suspend(host, PMSG_SUSPEND);
-- 
1.7.0.4

