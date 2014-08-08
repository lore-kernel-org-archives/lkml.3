Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbaHHPeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:34:22 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:37771 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944AbaHHPeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:34:19 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] PCI: mvebu: Fix uninitialized variable in mvebu_get_tgt_attr()
Date: Fri,  8 Aug 2014 17:34:05 +0200
Message-Id: <1407512045-26969-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/pci/host/pci-mvebu.c: In function 'mvebu_get_tgt_attr':
drivers/pci/host/pci-mvebu.c:887:39: warning: 'rtype' may be used uninitialized in this function [-Wmaybe-uninitialized]
   if (slot == PCI_SLOT(devfn) && type == rtype) {
                                       ^

If there's ever gonna be a configuration space or 64-bit memory space
entry in DT, rtype will be uninitialized, and the wrong entry may be
returned.

Initialize rtype to 0 (which is an unused IORESOURCE_* type) to fix this.

Introduced in commit 11be65472a427dcf7a11ab6e3e3628f1c6768b5b ("PCI:
mvebu: Adapt to the new device tree layout").

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Alternatively, should the "else if (DT_FLAGS_TO_TYPE(flags) ==
DT_TYPE_MEM32)" just be changed to "else", assuming there can never be
other entries than for I/O or 32-bit memory space?
---
 drivers/pci/host/pci-mvebu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index ce23e0f076b6..9515f0d13fd4 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -877,7 +877,7 @@ static int mvebu_get_tgt_attr(struct device_node *np, int devfn,
 		u32 flags = of_read_number(range, 1);
 		u32 slot = of_read_number(range + 1, 1);
 		u64 cpuaddr = of_read_number(range + na, pna);
-		unsigned long rtype;
+		unsigned long rtype = 0;
 
 		if (DT_FLAGS_TO_TYPE(flags) == DT_TYPE_IO)
 			rtype = IORESOURCE_IO;
-- 
1.9.1

