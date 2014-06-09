Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbaFIUpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 16:45:41 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:51236 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaFIUpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 16:45:39 -0400
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH] PCI: Do not touch siblings in pci_assign_unassigned_bridge_resources
Date: Mon,  9 Jun 2014 22:45:30 +0200
Message-Id: <1402346730-2508-1-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_assign_unassigned_bridge_resources is used to assign resources below
a hotplug bridge. If the first attempt fails it will release some
resources and try again. If a resource allocation on the hotplug bridge
itself fails then pci_assign_unassigned_bridge_resources will invoke
pci_bus_release_bridge_resources on the parent bus of the hotplug
bridge. This in turn will release resources assigned to siblings of the
hotplug bridge which may already be in use.

This patch checks for this case and prevents
pci_bus_release_bridge_resources to be invoked on the parent bus.

The problem can be reproduced by having two sibling hotplug bridges A
and B. The problem will occour if the parent of A and B does not have
enough resources to satisfy window allocations for B during a hotplug
event.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---

I must admit that I do not fully understand how
pci_assign_unassigned_bridge_resources works. Under which scenario would the
second allocation attempt be successful?

Thanks,
Andreas

 drivers/pci/setup-bus.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 138bdd6..2e418d6 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1560,6 +1560,12 @@ void __init pci_assign_unassigned_resources(void)
 		pci_assign_unassigned_root_bus_resources(root_bus);
 }
 
+/**
+ * pci_assign_unassigned_bridge_resources - greenfield resource allocation
+ *
+ * Try to assign io and memory resources on and below @bridge. The caller must
+ * ensure that no device below @bridge is active.
+ */
 void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
 {
 	struct pci_bus *parent = bridge->subordinate;
@@ -1567,7 +1573,7 @@ void pci_assign_unassigned_bridge_resources(struct pci_dev *bridge)
 					want additional resources */
 	int tried_times = 0;
 	LIST_HEAD(fail_head);
-	struct pci_dev_resource *fail_res;
+	struct pci_dev_resource *fail_res, *tmp;
 	int retval;
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
@@ -1594,10 +1600,21 @@ again:
 	 * Try to release leaf bridge's resources that doesn't fit resource of
 	 * child device under that bridge
 	 */
-	list_for_each_entry(fail_res, &fail_head, list)
+	list_for_each_entry_safe(fail_res, tmp, &fail_head, list) {
+		 /*
+		  * The allocation of the mem/io window of the top level bridge
+		  * can fail.  Without the following check we would release our
+		  * siblings' resources.
+		  */
+		if (fail_res->dev == bridge) {
+			list_del(&fail_res->list);
+			kfree(fail_res);
+			continue;
+		}
 		pci_bus_release_bridge_resources(fail_res->dev->bus,
 						 fail_res->flags & type_mask,
 						 whole_subtree);
+	}
 
 	/* restore size and flags */
 	list_for_each_entry(fail_res, &fail_head, list) {
-- 
2.0.0

