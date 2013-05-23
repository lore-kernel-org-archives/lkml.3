Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350Ab3EWROW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 13:14:22 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:24984 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758540Ab3EWROT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 13:14:19 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] PCI: Don't let mmio fallback to must-only, if ioport fails with must+optional
Date: Thu, 23 May 2013 10:11:39 -0700
Message-Id: <1369329099-8501-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <519dcfbe.89e9420a.4934.488bSMTPIN_ADDED_BROKEN@mx.google.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BenH reported that there is some assign unassigned resource problem
in powerpc.

It turns out after
| commit 0c5be0cb0edfe3b5c4b62eac68aa2aa15ec681af
| Date:   Thu Feb 23 19:23:29 2012 -0800
|
|    PCI: Retry on IORESOURCE_IO type allocations

even the root bus does not have io port range, it will keep retrying
to realloc with mmio.

Current retry logic is : try with must+optional at first, and if
it fails with any ioport or mmio, it will try must then try to extend
must with optional.
That will fail as mmio-non-pref and mmio-pref for bridge will
be next to each other. So we have no chance to extend mmio-non-pref.

We can check fail type and only fall back for io port only, that will
keep mmio type still have must+optional.

This will be become more often when we have x86 8 sockets or 32 sockets
system, and those system will have one root bus per socket.
They will have some root buses do not have ioport range.

-v2: need to remove assigned entries from optional list too.

Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Tested-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -317,6 +317,10 @@ static void __assign_resources_sorted(st
 	LIST_HEAD(local_fail_head);
 	struct pci_dev_resource *save_res;
 	struct pci_dev_resource *dev_res;
+	unsigned long fail_type = 0;
+	struct pci_dev_resource *fail_res;
+	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
+				  IORESOURCE_PREFETCH;
 
 	/* Check if optional add_size is there */
 	if (!realloc_head || list_empty(realloc_head))
@@ -348,6 +352,25 @@ static void __assign_resources_sorted(st
 		return;
 	}
 
+	/* check failed type */
+	list_for_each_entry(fail_res, &local_fail_head, list)
+		fail_type |= fail_res->flags & type_mask;
+	/* only io port fails */
+	if ((fail_type & type_mask) == IORESOURCE_IO) {
+		struct pci_dev_resource *tmp_res;
+
+		/* remove assigned non ioport from head list etc */
+		list_for_each_entry_safe(dev_res, tmp_res, head, list)
+			if (dev_res->res->parent &&
+			    !(dev_res->res->flags & IORESOURCE_IO)) {
+				/* remove it from realloc_head list */
+				remove_from_list(realloc_head, dev_res->res);
+				remove_from_list(&save_head, dev_res->res);
+				list_del(&dev_res->list);
+				kfree(dev_res);
+			}
+	}
+
 	free_list(&local_fail_head);
 	/* Release assigned resource */
 	list_for_each_entry(dev_res, head, list)
