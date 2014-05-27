Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaE0E5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 00:57:19 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:35972 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbaE0E5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 00:57:13 -0400
From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        lugovskoy@dev.rtsoft.ru, Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Subject: [PATCH] usb: pci-quirks: do not access OHCI_FMINTERVAL register on ULI hw
Date: Tue, 27 May 2014 08:56:42 +0400
Message-Id: <1401166602-26379-1-git-send-email-nyushchenko@dev.rtsoft.ru>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This access causes hang on Freescale P2020DS board (that has OHCI
provided by ULI 1533 chip).

Since preserving OHCI_FMINTERVAL was originally done only for NVIDIA
hardware and only later (in c6187597) was turned unconditional, and
c6187597 commit message again mentions only NVIDIA, I think it should be
safe to disable preserving OHCI_FMINTERVAL if device vendor is ULI.

Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
---
 drivers/usb/host/pci-quirks.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 00661d3..5acbd5b 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -571,7 +571,7 @@ static void quirk_usb_handoff_ohci(struct pci_dev *pdev)
 {
 	void __iomem *base;
 	u32 control;
-	u32 fminterval;
+	u32 uninitialized_var(fminterval);
 	int cnt;
 
 	if (!mmio_resource_enabled(pdev, 0))
@@ -619,7 +619,8 @@ static void quirk_usb_handoff_ohci(struct pci_dev *pdev)
 	}
 
 	/* software reset of the controller, preserving HcFmInterval */
-	fminterval = readl(base + OHCI_FMINTERVAL);
+	if (pdev->vendor != PCI_VENDOR_ID_AL)
+		fminterval = readl(base + OHCI_FMINTERVAL);
 	writel(OHCI_HCR, base + OHCI_CMDSTATUS);
 
 	/* reset requires max 10 us delay */
@@ -628,7 +629,8 @@ static void quirk_usb_handoff_ohci(struct pci_dev *pdev)
 			break;
 		udelay(1);
 	}
-	writel(fminterval, base + OHCI_FMINTERVAL);
+	if (pdev->vendor != PCI_VENDOR_ID_AL)
+		writel(fminterval, base + OHCI_FMINTERVAL);
 
 	/* Now the controller is safely in SUSPEND and nothing can wake it up */
 	iounmap(base);
-- 
1.7.10.4

