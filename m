Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab3EVGjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 02:39:14 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:28390 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab3EVGjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 02:39:10 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v4 6/8] PCI: Skip IORESOURCE_MMIO allocation for root bus without MMIO range
Date: Tue, 21 May 2013 23:38:46 -0700
Message-Id: <1369204728-11165-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369204728-11165-1-git-send-email-yinghai@kernel.org>
References: <1369204728-11165-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For x86 8 sockets or 32 sockets system that will have one root bus per socket,
They may have some root buses do not have mmio non-pref range.

We should not fall into retry in this case, as root bus does
not mmio non-pref range.

We check if the root bus has mmio-nonpref range, and set bus_res_type_mask,
and pass it to assign_resources and don't add mmio-nonpref res to failed list
for root bus that does not have mmio-nonpref range.
So even BIOS set wrong value to pci devices and bridges will still
get cleared.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -299,9 +299,17 @@ static void assign_requested_resources_s
 				bool is_ioport_res_without_bus_support =
 					 (!(bus_res_type_mask & IORESOURCE_IO)) &&
 					 (res->flags & IORESOURCE_IO);
+				/*
+				 * if the failed res is mmio, but bus does
+				 * not have io port support, don't add it
+				 */
+				bool is_mmio_nonpref_res_without_bus_support =
+					 (!(bus_res_type_mask & IORESOURCE_MEM)) &&
+					 ((res->flags & (IORESOURCE_MEM | IORESOURCE_PREFETCH)) == IORESOURCE_MEM);
 
 				if (!is_rom_res_not_enabled &&
-				    !is_ioport_res_without_bus_support)
+				    !is_ioport_res_without_bus_support &&
+				    !is_mmio_nonpref_res_without_bus_support)
 					add_to_list(fail_head,
 						    dev_res->dev, res,
 						    0 /* dont care */,
@@ -1416,12 +1424,24 @@ static unsigned long pci_bus_res_type_ma
 	int i;
 	struct resource *r;
 	unsigned long mask = 0;
-	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
-				  IORESOURCE_PREFETCH;
 
-	pci_bus_for_each_resource(bus, r, i)
-		if (r)
-			mask |= r->flags & type_mask;
+	pci_bus_for_each_resource(bus, r, i) {
+		if (!r)
+			continue;
+
+		if (r->flags & IORESOURCE_IO) {
+			mask |= IORESOURCE_IO;
+			continue;
+		}
+		if (r->flags & IORESOURCE_PREFETCH) {
+			mask |= IORESOURCE_PREFETCH;
+			continue;
+		}
+		if ((r->flags & (IORESOURCE_MEM | IORESOURCE_PREFETCH)) == IORESOURCE_MEM) {
+			mask |= IORESOURCE_MEM; /* nonpref only */
+			continue;
+		}
+	}
 
 	return mask;
 }
