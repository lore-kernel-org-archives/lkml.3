Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981Ab3CYVhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 17:37:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:16158 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758665Ab3CYVhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 17:37:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,907,1355126400"; 
   d="scan'208";a="275798164"
Subject: [PATCH] ioatdma: Adding Haswell devid for ioatdma
To: djbw@fb.com
From: Dave Jiang <dave.jiang@intel.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org
Date: Mon, 25 Mar 2013 14:37:31 -0700
Message-ID: <20130325213731.19210.21417.stgit@djiang5-linux2.ch.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Haswell PCI device IDs for ioatdma and simplify the detection of
certain Xeon CPUs that has alignment bugs so that modifications can be
changed at a single place going forward.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/ioat/dma_v3.c |   28 +++++++++++++++++++++++++++-
 drivers/dma/ioat/hw.h     |   22 +++++++++++++++++-----
 drivers/dma/ioat/pci.c    |   11 +++++++++++
 3 files changed, 55 insertions(+), 6 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index a1dcfb2..ab5655e 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -1260,6 +1260,32 @@ static bool is_ivb_ioat(struct pci_dev *pdev)
 
 }
 
+static bool is_hsw_ioat(struct pci_dev *pdev)
+{
+	switch (pdev->device) {
+	case PCI_DEVICE_ID_INTEL_IOAT_HSW0:
+	case PCI_DEVICE_ID_INTEL_IOAT_HSW1:
+	case PCI_DEVICE_ID_INTEL_IOAT_HSW2:
+	case PCI_DEVICE_ID_INTEL_IOAT_HSW3:
+	case PCI_DEVICE_ID_INTEL_IOAT_HSW4:
+	case PCI_DEVICE_ID_INTEL_IOAT_HSW5:
+	case PCI_DEVICE_ID_INTEL_IOAT_HSW6:
+	case PCI_DEVICE_ID_INTEL_IOAT_HSW7:
+	case PCI_DEVICE_ID_INTEL_IOAT_HSW8:
+	case PCI_DEVICE_ID_INTEL_IOAT_HSW9:
+		return true;
+	default:
+		return false;
+	}
+
+}
+
+static bool is_xeon_cb32(struct pci_dev *pdev)
+{
+	return is_jf_ioat(pdev) || is_snb_ioat(pdev) || is_ivb_ioat(pdev) ||
+		is_hsw_ioat(pdev);
+}
+
 int ioat3_dma_probe(struct ioatdma_device *device, int dca)
 {
 	struct pci_dev *pdev = device->pdev;
@@ -1280,7 +1306,7 @@ int ioat3_dma_probe(struct ioatdma_device *device, int dca)
 	dma->device_alloc_chan_resources = ioat2_alloc_chan_resources;
 	dma->device_free_chan_resources = ioat2_free_chan_resources;
 
-	if (is_jf_ioat(pdev) || is_snb_ioat(pdev) || is_ivb_ioat(pdev))
+	if (is_xeon_cb32(pdev))
 		dma->copy_align = 6;
 
 	dma_cap_set(DMA_INTERRUPT, dma->cap_mask);
diff --git a/drivers/dma/ioat/hw.h b/drivers/dma/ioat/hw.h
index 7cb74c6..8cfa077 100644
--- a/drivers/dma/ioat/hw.h
+++ b/drivers/dma/ioat/hw.h
@@ -30,11 +30,6 @@
 #define IOAT_PCI_DID_SCNB       0x65FF
 #define IOAT_PCI_DID_SNB        0x402F
 
-#define IOAT_VER_1_2            0x12    /* Version 1.2 */
-#define IOAT_VER_2_0            0x20    /* Version 2.0 */
-#define IOAT_VER_3_0            0x30    /* Version 3.0 */
-#define IOAT_VER_3_2            0x32    /* Version 3.2 */
-
 #define PCI_DEVICE_ID_INTEL_IOAT_IVB0	0x0e20
 #define PCI_DEVICE_ID_INTEL_IOAT_IVB1	0x0e21
 #define PCI_DEVICE_ID_INTEL_IOAT_IVB2	0x0e22
@@ -46,6 +41,23 @@
 #define PCI_DEVICE_ID_INTEL_IOAT_IVB8	0x0e2e
 #define PCI_DEVICE_ID_INTEL_IOAT_IVB9	0x0e2f
 
+#define PCI_DEVICE_ID_INTEL_IOAT_HSW0	0x2f20
+#define PCI_DEVICE_ID_INTEL_IOAT_HSW1	0x2f21
+#define PCI_DEVICE_ID_INTEL_IOAT_HSW2	0x2f22
+#define PCI_DEVICE_ID_INTEL_IOAT_HSW3	0x2f23
+#define PCI_DEVICE_ID_INTEL_IOAT_HSW4	0x2f24
+#define PCI_DEVICE_ID_INTEL_IOAT_HSW5	0x2f25
+#define PCI_DEVICE_ID_INTEL_IOAT_HSW6	0x2f26
+#define PCI_DEVICE_ID_INTEL_IOAT_HSW7	0x2f27
+#define PCI_DEVICE_ID_INTEL_IOAT_HSW8	0x2f2e
+#define PCI_DEVICE_ID_INTEL_IOAT_HSW9	0x2f2f
+
+#define IOAT_VER_1_2            0x12    /* Version 1.2 */
+#define IOAT_VER_2_0            0x20    /* Version 2.0 */
+#define IOAT_VER_3_0            0x30    /* Version 3.0 */
+#define IOAT_VER_3_2            0x32    /* Version 3.2 */
+
+
 int system_has_dca_enabled(struct pci_dev *pdev);
 
 struct ioat_dma_descriptor {
diff --git a/drivers/dma/ioat/pci.c b/drivers/dma/ioat/pci.c
index 71c7ecd..67c8e83 100644
--- a/drivers/dma/ioat/pci.c
+++ b/drivers/dma/ioat/pci.c
@@ -94,6 +94,17 @@ static struct pci_device_id ioat_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_IVB8) },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_IVB9) },
 
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_HSW0) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_HSW1) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_HSW2) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_HSW3) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_HSW4) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_HSW5) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_HSW6) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_HSW7) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_HSW8) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_HSW9) },
+
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, ioat_pci_tbl);

