Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbbAOEcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 23:32:35 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21570 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbbAOEcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 23:32:32 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: [PATCH v2 06/10] PCI, microblaze: clip firmware assigned resource under parent bridge's
Date: Wed, 14 Jan 2015 20:31:33 -0800
Message-Id: <1421296297-6371-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1421296297-6371-1-git-send-email-yinghai@kernel.org>
References: <1421296297-6371-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
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
Cc: Michal Simek <monstr@monstr.eu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
---
 arch/microblaze/pci/pci-common.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index b30e41c..48528fb 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -1026,6 +1026,8 @@ static void pcibios_allocate_bus_resources(struct pci_bus *bus)
 			 pr, (pr && pr->name) ? pr->name : "nil");
 
 		if (pr && !(pr->flags & IORESOURCE_UNSET)) {
+			struct pci_dev *dev = bus->self;
+
 			if (request_resource(pr, res) == 0)
 				continue;
 			/*
@@ -1035,6 +1037,12 @@ static void pcibios_allocate_bus_resources(struct pci_bus *bus)
 			 */
 			if (reparent_resources(pr, res) == 0)
 				continue;
+
+			if (dev && i < PCI_BRIDGE_RESOURCE_NUM &&
+			    pci_claim_bridge_resource(dev,
+						 i + PCI_BRIDGE_RESOURCES) == 0)
+				continue;
+
 		}
 		pr_warn("PCI: Cannot allocate resource region ");
 		pr_cont("%d of PCI bridge %d, will remap\n", i, bus->number);
@@ -1227,7 +1235,10 @@ void pcibios_claim_one_bus(struct pci_bus *bus)
 				 (unsigned long long)r->end,
 				 (unsigned int)r->flags);
 
-			pci_claim_resource(dev, i);
+			if (pci_claim_resource(dev, i) == 0)
+				continue;
+
+			pci_claim_bridge_resource(dev, i);
 		}
 	}
 
-- 
1.8.4.5

