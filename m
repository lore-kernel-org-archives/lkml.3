Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbbALTZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:25:43 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46854 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829AbbALTZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:25:40 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org
Subject: [PATCH 03/10] PCI, alpha: clip firmware assigned resource under parent bridge's
Date: Mon, 12 Jan 2015 11:23:13 -0800
Message-Id: <1421090600-9750-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1421090600-9750-1-git-send-email-yinghai@kernel.org>
References: <1421090600-9750-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
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
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: linux-alpha@vger.kernel.org
---
 arch/alpha/kernel/pci.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/kernel/pci.c b/arch/alpha/kernel/pci.c
index 076c35c..b54b40f 100644
--- a/arch/alpha/kernel/pci.c
+++ b/arch/alpha/kernel/pci.c
@@ -277,6 +277,7 @@ pcibios_claim_one_bus(struct pci_bus *b)
 	struct pci_bus *child_bus;
 
 	list_for_each_entry(dev, &b->devices, bus_list) {
+		bool changed = false;
 		int i;
 
 		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
@@ -285,9 +286,28 @@ pcibios_claim_one_bus(struct pci_bus *b)
 			if (r->parent || !r->start || !r->flags)
 				continue;
 			if (pci_has_flag(PCI_PROBE_ONLY) ||
-			    (r->flags & IORESOURCE_PCI_FIXED))
-				pci_claim_resource(dev, i);
+			    (r->flags & IORESOURCE_PCI_FIXED)) {
+				if (pci_claim_resource(dev, i) >= 0)
+					continue;
+
+				if (dev->subordinate &&
+				    i >= PCI_BRIDGE_RESOURCES &&
+				    i < PCI_NUM_RESOURCES &&
+				    (dev->class >> 8) == PCI_CLASS_BRIDGE_PCI &&
+				    pci_bus_clip_resource(dev, r)) {
+					changed = true;
+					pci_claim_resource(dev, i);
+				} else if (i < PCI_BRIDGE_RESOURCES &&
+					   i != PCI_ROM_RESOURCE &&
+					   pci_bus_clip_resource(dev, r)) {
+						pci_update_resource(dev, i);
+						pci_claim_resource(dev, i);
+				}
+			}
 		}
+
+		if (changed)
+			pci_setup_bridge(dev->subordinate);
 	}
 
 	list_for_each_entry(child_bus, &b->children, node)
-- 
1.8.4.5

