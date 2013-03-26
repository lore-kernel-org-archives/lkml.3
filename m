Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934499Ab3CZOWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 10:22:47 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:35497 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933449Ab3CZOWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 10:22:46 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] firewire: Enable physical DMA above 4GB
Date: Tue, 26 Mar 2013 10:22:14 -0400
Message-Id: <1364307734-27709-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quadlet reads to memory above 4GB is painfully slow when serviced
by the AR DMA context. In addition, the CPU(s) may be locked-up,
preventing any transfer at all.

Write the PhyUpperBound register with the end-of-memory value. If
end-of-memory is beyond the OHCI limit of 0x0000ffff00000000,
clamp to that value.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/firewire/ohci.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 044ace3..b4135a5 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2249,6 +2249,7 @@ static int ohci_enable(struct fw_card *card,
 	struct pci_dev *dev = to_pci_dev(card->device);
 	u32 lps, version, irqs;
 	int i, ret;
+	u32 phys_upper;
 
 	if (software_reset(ohci)) {
 		dev_err(card->device, "failed to reset ohci card\n");
@@ -2323,7 +2324,10 @@ static int ohci_enable(struct fw_card *card,
 	reg_write(ohci, OHCI1394_FairnessControl, 0);
 	card->priority_budget_implemented = ohci->pri_req_max != 0;
 
-	reg_write(ohci, OHCI1394_PhyUpperBound, 0x00010000);
+	phys_upper = min(0xffff0000ULL,
+			 (dma_get_required_mask(card->device) >> 16) + 1);
+	reg_write(ohci, OHCI1394_PhyUpperBound, max(phys_upper, 0x00010000U));
+
 	reg_write(ohci, OHCI1394_IntEventClear, ~0);
 	reg_write(ohci, OHCI1394_IntMaskClear, ~0);
 
-- 
1.8.1.2

