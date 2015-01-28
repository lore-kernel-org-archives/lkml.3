Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934489AbbA1EYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:24:42 -0500
Received: from mail.kernel.org ([198.145.29.136]:40766 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934469AbbA1EYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:24:37 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 133/177] xhci: no switching back on non-ULT Haswell
Date: Wed, 28 Jan 2015 12:09:51 +0800
Message-Id: <1422418236-12852-224-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Neukum <oneukum@suse.de>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit b45abacde3d551c6696c6738bef4a1805d0bf27a upstream.

The switch back is limited to ULT even on HP. The contrary
finding arose by bad luck in BIOS versions for testing.
This fixes spontaneous resume from S3 on some HP laptops.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/host/xhci-pci.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 8882d65..c8835d5 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -118,20 +118,6 @@ static void xhci_pci_quirks(struct device *dev, struct xhci_hcd *xhci)
 		xhci->quirks |= XHCI_SPURIOUS_REBOOT;
 		xhci->quirks |= XHCI_AVOID_BEI;
 	}
-	if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
-	    (pdev->device == PCI_DEVICE_ID_INTEL_LYNXPOINT_XHCI ||
-	     pdev->device == PCI_DEVICE_ID_INTEL_LYNXPOINT_LP_XHCI)) {
-		/* Workaround for occasional spurious wakeups from S5 (or
-		 * any other sleep) on Haswell machines with LPT and LPT-LP
-		 * with the new Intel BIOS
-		 */
-		/* Limit the quirk to only known vendors, as this triggers
-		 * yet another BIOS bug on some other machines
-		 * https://bugzilla.kernel.org/show_bug.cgi?id=66171
-		 */
-		if (pdev->subsystem_vendor == PCI_VENDOR_ID_HP)
-			xhci->quirks |= XHCI_SPURIOUS_WAKEUP;
-	}
 	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
 			pdev->device == PCI_DEVICE_ID_ASROCK_P67) {
 		xhci->quirks |= XHCI_RESET_ON_RESUME;
-- 
1.9.1

