Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933076AbbA2Jzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:55:38 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44793 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751787AbbA2JDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:03:21 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arseny Solokha <asolokha@kb.kras.ru>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 106/176] OHCI: add a quirk for ULi M5237 blocking on reset
Date: Wed, 28 Jan 2015 15:28:56 +0100
Message-Id: <a6f25626d9f61c46ec3160c055fc72645294ead8.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arseny Solokha <asolokha@kb.kras.ru>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 56abcab833fafcfaeb2f5b25e0364c1dec45f53e upstream.

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
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/host/pci-quirks.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 877f87f9513b..5a45437da097 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -560,7 +560,8 @@ static void quirk_usb_handoff_ohci(struct pci_dev *pdev)
 {
 	void __iomem *base;
 	u32 control;
-	u32 fminterval;
+	u32 fminterval = 0;
+	bool no_fminterval = false;
 	int cnt;
 
 	if (!mmio_resource_enabled(pdev, 0))
@@ -570,6 +571,13 @@ static void quirk_usb_handoff_ohci(struct pci_dev *pdev)
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
@@ -608,7 +616,9 @@ static void quirk_usb_handoff_ohci(struct pci_dev *pdev)
 	}
 
 	/* software reset of the controller, preserving HcFmInterval */
-	fminterval = readl(base + OHCI_FMINTERVAL);
+	if (!no_fminterval)
+		fminterval = readl(base + OHCI_FMINTERVAL);
+
 	writel(OHCI_HCR, base + OHCI_CMDSTATUS);
 
 	/* reset requires max 10 us delay */
@@ -617,7 +627,9 @@ static void quirk_usb_handoff_ohci(struct pci_dev *pdev)
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
2.2.2

