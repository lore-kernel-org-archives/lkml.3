Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbbALT11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:27:27 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46391 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863AbbALTZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:25:00 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org
Subject: [PATCH 08/10] PCI, parisc: clip firmware assigned resource under parent bridge's
Date: Mon, 12 Jan 2015 11:23:18 -0800
Message-Id: <1421090600-9750-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1421090600-9750-1-git-send-email-yinghai@kernel.org>
References: <1421090600-9750-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some bios put range that is not fully coverred by root bus resources.
Try to clip them and update them in pci bridge bars.

We'd like to fix other arches instead of just x86.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=85491
Reported-by: Marek Kordik <kordikmarek@gmail.com>
Fixes: 5b28541552ef ("PCI: Restrict 64-bit prefetchable bridge windows to 64-bit resources")
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
---
 drivers/parisc/lba_pci.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/parisc/lba_pci.c b/drivers/parisc/lba_pci.c
index 37e71ff..e6ab352 100644
--- a/drivers/parisc/lba_pci.c
+++ b/drivers/parisc/lba_pci.c
@@ -692,11 +692,25 @@ lba_fixup_bus(struct pci_bus *bus)
 	*/
 	if (bus->parent) {
 		int i;
+		bool changed = false;
+
+		dev = bus->self;
 		/* PCI-PCI Bridge */
 		pci_read_bridge_bases(bus);
 		for (i = PCI_BRIDGE_RESOURCES; i < PCI_NUM_RESOURCES; i++) {
-			pci_claim_resource(bus->self, i);
+			struct resource *res = &dev->resource[i];
+
+			if (pci_claim_resource(dev, i) >= 0)
+				continue;
+
+			if (pci_bus_clip_resource(dev, res)) {
+				changed = true;
+				if (pci_claim_resource(dev, i) >= 0)
+					continue;
+			}
 		}
+		if (changed)
+			pci_setup_bridge(bus);
 	} else {
 		/* Host-PCI Bridge */
 		int err;
@@ -776,7 +790,15 @@ lba_fixup_bus(struct pci_bus *bus)
 			** that share expansion ROMs (think quad tulip), but
 			** isn't harmful.
 			*/
-			pci_claim_resource(dev, i);
+			if (pci_claim_resource(dev, i) >= 0)
+				continue;
+
+			/* try again with clip */
+			if (i != PCI_ROM_RESOURCE &&
+			    pci_bus_clip_resource(dev, res)) {
+				pci_update_resource(dev, i);
+				pci_claim_resource(dev, i);
+			}
 		}
 
 #ifdef FBB_SUPPORT
-- 
1.8.4.5

