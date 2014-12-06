Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaLFCz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 21:55:58 -0500
Received: from ispman.iskranet.ru ([62.213.33.10]:59599 "EHLO
	ispman.iskranet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaLFCz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 21:55:57 -0500
From: Arseny Solokha <asolokha@kb.kras.ru>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Arseny Solokha <asolokha@kb.kras.ru>
Subject: [PATCH v2] OHCI: add a quirk for ULi M5237 blocking on reset
Date: Sat,  6 Dec 2014 09:54:06 +0700
Message-Id: <1417834446-21257-1-git-send-email-asolokha@kb.kras.ru>
X-Mailer: git-send-email 2.2.0
In-Reply-To: <1417768029-31901-1-git-send-email-asolokha@kb.kras.ru>
References: <1417768029-31901-1-git-send-email-asolokha@kb.kras.ru>
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
Changes in v2:
- review comments applied
---
 drivers/usb/host/pci-quirks.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 2f3aceb..f4e6b94 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -571,7 +571,8 @@ static void quirk_usb_handoff_ohci(struct pci_dev *pdev)
 {
 	void __iomem *base;
 	u32 control;
-	u32 fminterval;
+	u32 fminterval = 0;
+	bool no_fminterval = false;
 	int cnt;
 
 	if (!mmio_resource_enabled(pdev, 0))
@@ -581,6 +582,13 @@ static void quirk_usb_handoff_ohci(struct pci_dev *pdev)
 	if (base == NULL)
 		return;
 
+	/*
+	 * ULi M5237 OHCI controller locks the whole system when accessing
+	 * the OHCI_FMINTERVAL offset.
+	 */
+	if (pdev->vendor == PCI_VENDOR_ID_AL && pdev->device == 0x5237)
+		no_fminterval = true;
+
 	control = readl(base + OHCI_CONTROL);
 
 /* On PA-RISC, PDC can leave IR set incorrectly; ignore it there. */
@@ -619,7 +627,9 @@ static void quirk_usb_handoff_ohci(struct pci_dev *pdev)
 	}
 
 	/* software reset of the controller, preserving HcFmInterval */
-	fminterval = readl(base + OHCI_FMINTERVAL);
+	if (!no_fminterval)
+		fminterval = readl(base + OHCI_FMINTERVAL);
+
 	writel(OHCI_HCR, base + OHCI_CMDSTATUS);
 
 	/* reset requires max 10 us delay */
@@ -628,7 +638,9 @@ static void quirk_usb_handoff_ohci(struct pci_dev *pdev)
 			break;
 		udelay(1);
 	}
-	writel(fminterval, base + OHCI_FMINTERVAL);
+
+	if (!no_fminterval)
+		writel(fminterval, base + OHCI_FMINTERVAL);
 
 	/* Now the controller is safely in SUSPEND and nothing can wake it up */
 	iounmap(base);
-- 
2.2.0

