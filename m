Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaLEIkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:40:35 -0500
Received: from ispman.iskranet.ru ([62.213.33.10]:59946 "EHLO
	ispman.iskranet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaLEIkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:40:32 -0500
X-Greylist: delayed 696 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Dec 2014 03:40:30 EST
From: Arseny Solokha <asolokha@kb.kras.ru>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arseny Solokha <asolokha@kb.kras.ru>
Subject: [PATCH] OHCI: add a quirk for ULi M5237 blocking on reset
Date: Fri,  5 Dec 2014 15:27:09 +0700
Message-Id: <1417768029-31901-1-git-send-email-asolokha@kb.kras.ru>
X-Mailer: git-send-email 2.2.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arseny Solokha <asolokha@kb.kras.ru>

Commit 8dccddbc2368 ("OHCI: final fix for NVIDIA problems (I hope)")
introduced into 3.1.9 broke boot on e.g. Freescale P2020DS development
board. The code path that was previously specific to NVIDIA controllers
had then become taken for all chips.

However, the M5237 installed on the board wedges solid when accessing
its base+OHCI_FMINTERVAL register, making it impossible to boot any
kernel newer than 3.1.8 on this particular and apparently other similar
machines.

Don't readl() and writel() base+OHCI_FMINTERVAL on PCI ID 10b9:5237.

The patch is suitable for the -next tree as well as all maintained
kernels up to 3.2 inclusive.

Signed-off-by: Arseny Solokha <asolokha@kb.kras.ru>
---
 drivers/usb/host/pci-quirks.c | 14 +++++++++++---
 include/linux/pci_ids.h       |  1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 2f3aceb..3b29478 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -571,7 +571,7 @@ static void quirk_usb_handoff_ohci(struct pci_dev *pdev)
 {
 	void __iomem *base;
 	u32 control;
-	u32 fminterval;
+	u32 fminterval = 0;
 	int cnt;
 
 	if (!mmio_resource_enabled(pdev, 0))
@@ -619,7 +619,13 @@ static void quirk_usb_handoff_ohci(struct pci_dev *pdev)
 	}
 
 	/* software reset of the controller, preserving HcFmInterval */
-	fminterval = readl(base + OHCI_FMINTERVAL);
+	if (!(pdev->vendor == PCI_VENDOR_ID_AL &&
+	      pdev->device == PCI_DEVICE_ID_AL_M5237)) {
+		/* ULi M5237 OHCI controller (10b9:5237) locks the whole system
+		 * when accessing the OHCI_FMINTERVAL offset.
+		 */
+		fminterval = readl(base + OHCI_FMINTERVAL);
+	}
 	writel(OHCI_HCR, base + OHCI_CMDSTATUS);
 
 	/* reset requires max 10 us delay */
@@ -628,7 +634,9 @@ static void quirk_usb_handoff_ohci(struct pci_dev *pdev)
 			break;
 		udelay(1);
 	}
-	writel(fminterval, base + OHCI_FMINTERVAL);
+	if (!(pdev->vendor == PCI_VENDOR_ID_AL &&
+	      pdev->device == PCI_DEVICE_ID_AL_M5237))
+		writel(fminterval, base + OHCI_FMINTERVAL);
 
 	/* Now the controller is safely in SUSPEND and nothing can wake it up */
 	iounmap(base);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 1fa99a3..266fc5c 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1107,6 +1107,7 @@
 #define PCI_DEVICE_ID_AL_M5219		0x5219
 #define PCI_DEVICE_ID_AL_M5228		0x5228
 #define PCI_DEVICE_ID_AL_M5229		0x5229
+#define PCI_DEVICE_ID_AL_M5237		0x5237
 #define PCI_DEVICE_ID_AL_M5451		0x5451
 #define PCI_DEVICE_ID_AL_M7101		0x7101
 
-- 
2.2.0

