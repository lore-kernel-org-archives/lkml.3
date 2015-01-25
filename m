Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543AbbAYScZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:32:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993AbbAYSK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arseny Solokha <asolokha@kb.kras.ru>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3.18 140/183] OHCI: add a quirk for ULi M5237 blocking on reset
Date: Sun, 25 Jan 2015 10:07:42 -0800
Message-Id: <20150125180816.261501737@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arseny Solokha <asolokha@kb.kras.ru>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/pci-quirks.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -571,7 +571,8 @@ static void quirk_usb_handoff_ohci(struc
 {
 	void __iomem *base;
 	u32 control;
-	u32 fminterval;
+	u32 fminterval = 0;
+	bool no_fminterval = false;
 	int cnt;
 
 	if (!mmio_resource_enabled(pdev, 0))
@@ -581,6 +582,13 @@ static void quirk_usb_handoff_ohci(struc
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
@@ -619,7 +627,9 @@ static void quirk_usb_handoff_ohci(struc
 	}
 
 	/* software reset of the controller, preserving HcFmInterval */
-	fminterval = readl(base + OHCI_FMINTERVAL);
+	if (!no_fminterval)
+		fminterval = readl(base + OHCI_FMINTERVAL);
+
 	writel(OHCI_HCR, base + OHCI_CMDSTATUS);
 
 	/* reset requires max 10 us delay */
@@ -628,7 +638,9 @@ static void quirk_usb_handoff_ohci(struc
 			break;
 		udelay(1);
 	}
-	writel(fminterval, base + OHCI_FMINTERVAL);
+
+	if (!no_fminterval)
+		writel(fminterval, base + OHCI_FMINTERVAL);
 
 	/* Now the controller is safely in SUSPEND and nothing can wake it up */
 	iounmap(base);


