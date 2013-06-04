Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632Ab3FDWof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:44:35 -0400
Received: from 1wt.eu ([62.212.114.60]:35910 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab3FDWoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:44:32 -0400
Message-Id: <20130604172134.583897847@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:13 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 103/184] xhci: Make handover code more robust
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Garrett <mjg@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/usb/host/pci-quirks.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 981b604..01e7fae 100644
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
1.7.12.2.21.g234cd45.dirty



