Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013AbaBEUgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:36:33 -0500
Received: from mail.windriver.com ([147.11.1.11]:55186 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276AbaBEUGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:49 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Matthew Garrett <mjg@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 136/213] xhci: Make handover code more robust
Date: Wed, 5 Feb 2014 15:01:31 -0500
Message-ID: <1391630568-49251-137-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit e955a1cd086de4d165ae0f4c7be7289d84b63bdc upstream.

My test platform (Intel DX79SI) boots reliably under BIOS, but frequently
crashes when booting via UEFI. I finally tracked this down to the xhci
handoff code. It seems that reads from the device occasionally just return
0xff, resulting in xhci_find_next_cap_offset generating a value that's
larger than the resource region. We then oops when attempting to read the
value. Sanity checking that value lets us avoid the crash.

I've no idea what's causing the underlying problem, and xhci still doesn't
actually *work* even with this, but the machine at least boots which will
probably make further debugging easier.

This should be backported to kernels as old as 2.6.31, that contain the
commit 66d4eadd8d067269ea8fead1a50fe87c2979a80d "USB: xhci: BIOS handoff
and HW initialization."

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/host/pci-quirks.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index eae8b18437cb..bfbc6b97eb8f 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -418,12 +418,12 @@ static void __devinit quirk_usb_handoff_xhci(struct pci_dev *pdev)
 	void __iomem *op_reg_base;
 	u32 val;
 	int timeout;
+	int len = pci_resource_len(pdev, 0);
 
 	if (!mmio_resource_enabled(pdev, 0))
 		return;
 
-	base = ioremap_nocache(pci_resource_start(pdev, 0),
-				pci_resource_len(pdev, 0));
+	base = ioremap_nocache(pci_resource_start(pdev, 0), len);
 	if (base == NULL)
 		return;
 
@@ -433,9 +433,17 @@ static void __devinit quirk_usb_handoff_xhci(struct pci_dev *pdev)
 	 */
 	ext_cap_offset = xhci_find_next_cap_offset(base, XHCI_HCC_PARAMS_OFFSET);
 	do {
+		if ((ext_cap_offset + sizeof(val)) > len) {
+			/* We're reading garbage from the controller */
+			dev_warn(&pdev->dev,
+				 "xHCI controller failing to respond");
+			return;
+		}
+
 		if (!ext_cap_offset)
 			/* We've reached the end of the extended capabilities */
 			goto hc_init;
+
 		val = readl(base + ext_cap_offset);
 		if (XHCI_EXT_CAPS_ID(val) == XHCI_EXT_CAPS_LEGACY)
 			break;
-- 
1.8.5.2

