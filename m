Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbaAWVAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 16:00:07 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:52045 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379AbaAWVAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 16:00:04 -0500
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        bhelgaas@google.com
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH 6/8] PCI: Remove pci_fixup_parent_subordinate_busnr.
Date: Thu, 23 Jan 2014 21:59:26 +0100
Message-Id: <1390510768-5652-7-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390510768-5652-1-git-send-email-andreas.noever@gmail.com>
References: <1390510768-5652-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function has no effect.

If pcibios_assign_all_busses() is not set then the function does nothing.

If it is set then in pci_scan_bridge we are always in the branch where
we assign the bus numbers ourselves and the subordinate values of all
parent busses will be set to 0xff since that is what they inherited from
their parent bus and ultimately from the root bus.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/pci/probe.c | 30 ------------------------------
 1 file changed, 30 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 42ee0c0..90d5c48 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -731,22 +731,6 @@ struct pci_bus *__ref pci_add_new_bus(struct pci_bus *parent, struct pci_dev *de
 	return child;
 }
 
-static void pci_fixup_parent_subordinate_busnr(struct pci_bus *child, int max)
-{
-	struct pci_bus *parent = child->parent;
-
-	/* Attempts to fix that up are really dangerous unless
-	   we're going to re-assign all bus numbers. */
-	if (!pcibios_assign_all_busses())
-		return;
-
-	while (parent->parent && parent->busn_res.end < max) {
-		parent->busn_res.end = max;
-		pci_write_config_byte(parent->self, PCI_SUBORDINATE_BUS, max);
-		parent = parent->parent;
-	}
-}
-
 /*
  * If it's a bridge, configure it and scan the bus behind it.
  * For CardBus bridges, we don't scan behind as the devices will
@@ -879,20 +863,7 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
 
 		if (!is_cardbus) {
 			child->bridge_ctl = bctl;
-			/*
-			 * Adjust subordinate busnr in parent buses.
-			 * We do this before scanning for children because
-			 * some devices may not be detected if the bios
-			 * was lazy.
-			 */
-			pci_fixup_parent_subordinate_busnr(child, max);
-			/* Now we can scan all subordinate buses... */
 			max = pci_scan_child_bus(child);
-			/*
-			 * now fix it up again since we have found
-			 * the real value of max.
-			 */
-			pci_fixup_parent_subordinate_busnr(child, max);
 		} else {
 			/*
 			 * For CardBus bridges, we leave 4 bus numbers
@@ -923,7 +894,6 @@ int pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max, int pass)
 				}
 			}
 			max += i;
-			pci_fixup_parent_subordinate_busnr(child, max);
 		}
 		/*
 		 * Set the subordinate bus number to its real value.
-- 
1.8.5.3

