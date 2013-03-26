Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab3CZWnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:43:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:2075 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754209Ab3CZWnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:43:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,915,1355126400"; 
   d="scan'208";a="219198828"
Subject: [PATCH 10/10] ioatdma: S1200 platforms ioatdma channel 2 and 3
 falsely advertise RAID cap
To: djbw@fb.com
From: Dave Jiang <dave.jiang@intel.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org
Date: Tue, 26 Mar 2013 15:43:33 -0700
Message-ID: <20130326224333.15072.51156.stgit@djiang5-linux2.ch.intel.com>
In-Reply-To: <20130326223953.15072.26605.stgit@djiang5-linux2.ch.intel.com>
References: <20130326223953.15072.26605.stgit@djiang5-linux2.ch.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This workaround checks for channel 2&3 and remove RAID cap.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/ioat/dma_v3.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 83d44f3..6f6d2ec 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -238,6 +238,18 @@ static bool is_bwd_ioat(struct pci_dev *pdev)
 	}
 }
 
+static bool is_bwd_noraid(struct pci_dev *pdev)
+{
+	switch (pdev->device) {
+	case PCI_DEVICE_ID_INTEL_IOAT_BWD2:
+	case PCI_DEVICE_ID_INTEL_IOAT_BWD3:
+		return true;
+	default:
+		return false;
+	}
+
+}
+
 static void pq16_set_src(struct ioat_raw_descriptor *desc[3],
 			dma_addr_t addr, u32 offset, u8 coef, int idx)
 {
@@ -1890,6 +1902,9 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
 
 	cap = readl(device->reg_base + IOAT_DMA_CAP_OFFSET);
 
+	if (is_bwd_noraid(pdev))
+		cap &= ~(IOAT_CAP_XOR | IOAT_CAP_PQ | IOAT_CAP_RAID16SS);
+
 	/* dca is incompatible with raid operations */
 	if (dca_en && (cap & (IOAT_CAP_XOR|IOAT_CAP_PQ)))
 		cap &= ~(IOAT_CAP_XOR|IOAT_CAP_PQ);

