Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab3CZWnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:43:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:4199 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab3CZWnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:43:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,915,1355126400"; 
   d="scan'208";a="276349501"
Subject: [PATCH 05/10] ioatdma: skip legacy reset bits since v3.3 plattform
 doesn't need it
To: djbw@fb.com
From: Dave Jiang <dave.jiang@intel.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org
Date: Tue, 26 Mar 2013 15:42:59 -0700
Message-ID: <20130326224259.15072.83663.stgit@djiang5-linux2.ch.intel.com>
In-Reply-To: <20130326223953.15072.26605.stgit@djiang5-linux2.ch.intel.com>
References: <20130326223953.15072.26605.stgit@djiang5-linux2.ch.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it so only 3.2 and earlier platform need the PCI config register
clearings since this implementation does not have the registers.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/ioat/dma_v3.c |   34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index e66fead..c53204e 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -1339,20 +1339,28 @@ static int ioat3_reset_hw(struct ioat_chan_common *chan)
 	chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
 	writel(chanerr, chan->reg_base + IOAT_CHANERR_OFFSET);
 
-	/* clear any pending errors */
-	err = pci_read_config_dword(pdev, IOAT_PCI_CHANERR_INT_OFFSET, &chanerr);
-	if (err) {
-		dev_err(&pdev->dev, "channel error register unreachable\n");
-		return err;
-	}
-	pci_write_config_dword(pdev, IOAT_PCI_CHANERR_INT_OFFSET, chanerr);
+	if (device->version < IOAT_VER_3_3) {
+		/* clear any pending errors */
+		err = pci_read_config_dword(pdev,
+				IOAT_PCI_CHANERR_INT_OFFSET, &chanerr);
+		if (err) {
+			dev_err(&pdev->dev,
+				"channel error register unreachable\n");
+			return err;
+		}
+		pci_write_config_dword(pdev,
+				IOAT_PCI_CHANERR_INT_OFFSET, chanerr);
 
-	/* Clear DMAUNCERRSTS Cfg-Reg Parity Error status bit
-	 * (workaround for spurious config parity error after restart)
-	 */
-	pci_read_config_word(pdev, IOAT_PCI_DEVICE_ID_OFFSET, &dev_id);
-	if (dev_id == PCI_DEVICE_ID_INTEL_IOAT_TBG0)
-		pci_write_config_dword(pdev, IOAT_PCI_DMAUNCERRSTS_OFFSET, 0x10);
+		/* Clear DMAUNCERRSTS Cfg-Reg Parity Error status bit
+		 * (workaround for spurious config parity error after restart)
+		 */
+		pci_read_config_word(pdev, IOAT_PCI_DEVICE_ID_OFFSET, &dev_id);
+		if (dev_id == PCI_DEVICE_ID_INTEL_IOAT_TBG0) {
+			pci_write_config_dword(pdev,
+					       IOAT_PCI_DMAUNCERRSTS_OFFSET,
+					       0x10);
+		}
+	}
 
 	err = ioat2_reset_sync(chan, msecs_to_jiffies(200));
 	if (err) {

