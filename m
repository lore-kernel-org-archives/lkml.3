Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab3EVGlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 02:41:06 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28382 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab3EVGjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 02:39:10 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v4 2/8] PCI: Use pci_walk_bus to detect unassigned resources
Date: Tue, 21 May 2013 23:38:42 -0700
Message-Id: <1369204728-11165-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369204728-11165-1-git-send-email-yinghai@kernel.org>
References: <1369204728-11165-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per Bjorn, use pci_walk_bus instead of for_each_pci_dev or
calling pci_realloc_detect() recursively.

And separate it to different patch.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   46 +++++++++++++++++++++++++++++++---------------
 1 file changed, 31 insertions(+), 15 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -1359,30 +1359,46 @@ static bool __init pci_realloc_enabled(v
 	return pci_realloc_enable >= user_enabled;
 }
 
-static void __init pci_realloc_detect(void)
-{
 #if defined(CONFIG_PCI_IOV) && defined(CONFIG_PCI_REALLOC_ENABLE_AUTO)
-	struct pci_dev *dev = NULL;
+static int __init check_unassigned_resources(struct pci_dev *dev, void *data)
+{
+	int i;
+	int *unassigned = data;
 
-	if (pci_realloc_enable != undefined)
-		return;
+	for (i = PCI_IOV_RESOURCES; i <= PCI_IOV_RESOURCE_END; i++) {
+		struct resource *r = &dev->resource[i];
 
-	for_each_pci_dev(dev) {
-		int i;
+		/* Not assigned, or rejected by kernel ? */
+		if (r->flags && !r->start) {
+			(*unassigned)++;
+			return 1; /* return early from pci_walk_bus */
+		}
+	}
 
-		for (i = PCI_IOV_RESOURCES; i <= PCI_IOV_RESOURCE_END; i++) {
-			struct resource *r = &dev->resource[i];
+	return 0;
+}
 
-			/* Not assigned, or rejected by kernel ? */
-			if (r->flags && !r->start) {
-				pci_realloc_enable = auto_enabled;
+static void  __init pci_realloc_detect(void)
+{
+	int unassigned = 0;
+	struct pci_bus *bus;
 
-				return;
-			}
+	if (pci_realloc_enable != undefined)
+		return;
+
+	list_for_each_entry(bus, &pci_root_buses, node) {
+		pci_walk_bus(bus, check_unassigned_resources, &unassigned);
+		if (unassigned) {
+			pci_realloc_enable = auto_enabled;
+			return;
 		}
 	}
-#endif
 }
+#else
+static void __init pci_realloc_detect(void)
+{
+}
+#endif
 
 /*
  * first try will not touch pci bridge res
