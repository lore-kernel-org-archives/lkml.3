Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967746Ab3HIB73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:59:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967713Ab3HIB7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Subject: [ 071/102] PCI: Retry allocation of only the resource type that failed
Date: Thu,  8 Aug 2013 18:57:47 -0700
Message-Id: <20130809015026.972948516@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit aa914f5ec25e4371ba18b312971314be1b9b1076 upstream.

Ben Herrenschmidt reported the following problem:

  - The bus has space for all desired MMIO resources, including optional
    space for SR-IOV devices
  - We attempt to allocate I/O port space, but it fails because the bus
    has no I/O space
  - Because of the I/O allocation failure, we retry MMIO allocation,
    requesting only the required space, without the optional SR-IOV space

This means we don't allocate the optional SR-IOV space, even though we
could.

This is related to 0c5be0cb0e ("PCI: Retry on IORESOURCE_IO type
allocations").

This patch changes how we handle allocation failures.  We will now retry
allocation of only the resource type that failed.  If MMIO allocation
fails, we'll retry only MMIO allocation.  If I/O port allocation fails,
we'll retry only I/O port allocation.

[bhelgaas: changelog]
Reference: https://lkml.kernel.org/r/1367712653.11982.19.camel@pasglop
Reported-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Tested-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/setup-bus.c |   69 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 68 insertions(+), 1 deletion(-)

--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -300,6 +300,47 @@ static void assign_requested_resources_s
 	}
 }
 
+static unsigned long pci_fail_res_type_mask(struct list_head *fail_head)
+{
+	struct pci_dev_resource *fail_res;
+	unsigned long mask = 0;
+
+	/* check failed type */
+	list_for_each_entry(fail_res, fail_head, list)
+		mask |= fail_res->flags;
+
+	/*
+	 * one pref failed resource will set IORESOURCE_MEM,
+	 * as we can allocate pref in non-pref range.
+	 * Will release all assigned non-pref sibling resources
+	 * according to that bit.
+	 */
+	return mask & (IORESOURCE_IO | IORESOURCE_MEM | IORESOURCE_PREFETCH);
+}
+
+static bool pci_need_to_release(unsigned long mask, struct resource *res)
+{
+	if (res->flags & IORESOURCE_IO)
+		return !!(mask & IORESOURCE_IO);
+
+	/* check pref at first */
+	if (res->flags & IORESOURCE_PREFETCH) {
+		if (mask & IORESOURCE_PREFETCH)
+			return true;
+		/* count pref if its parent is non-pref */
+		else if ((mask & IORESOURCE_MEM) &&
+			 !(res->parent->flags & IORESOURCE_PREFETCH))
+			return true;
+		else
+			return false;
+	}
+
+	if (res->flags & IORESOURCE_MEM)
+		return !!(mask & IORESOURCE_MEM);
+
+	return false;	/* should not get here */
+}
+
 static void __assign_resources_sorted(struct list_head *head,
 				 struct list_head *realloc_head,
 				 struct list_head *fail_head)
@@ -312,11 +353,24 @@ static void __assign_resources_sorted(st
 	 *  if could do that, could get out early.
 	 *  if could not do that, we still try to assign requested at first,
 	 *    then try to reassign add_size for some resources.
+	 *
+	 * Separate three resource type checking if we need to release
+	 * assigned resource after requested + add_size try.
+	 *	1. if there is io port assign fail, will release assigned
+	 *	   io port.
+	 *	2. if there is pref mmio assign fail, release assigned
+	 *	   pref mmio.
+	 *	   if assigned pref mmio's parent is non-pref mmio and there
+	 *	   is non-pref mmio assign fail, will release that assigned
+	 *	   pref mmio.
+	 *	3. if there is non-pref mmio assign fail or pref mmio
+	 *	   assigned fail, will release assigned non-pref mmio.
 	 */
 	LIST_HEAD(save_head);
 	LIST_HEAD(local_fail_head);
 	struct pci_dev_resource *save_res;
-	struct pci_dev_resource *dev_res;
+	struct pci_dev_resource *dev_res, *tmp_res;
+	unsigned long fail_type;
 
 	/* Check if optional add_size is there */
 	if (!realloc_head || list_empty(realloc_head))
@@ -348,6 +402,19 @@ static void __assign_resources_sorted(st
 		return;
 	}
 
+	/* check failed type */
+	fail_type = pci_fail_res_type_mask(&local_fail_head);
+	/* remove not need to be released assigned res from head list etc */
+	list_for_each_entry_safe(dev_res, tmp_res, head, list)
+		if (dev_res->res->parent &&
+		    !pci_need_to_release(fail_type, dev_res->res)) {
+			/* remove it from realloc_head list */
+			remove_from_list(realloc_head, dev_res->res);
+			remove_from_list(&save_head, dev_res->res);
+			list_del(&dev_res->list);
+			kfree(dev_res);
+		}
+
 	free_list(&local_fail_head);
 	/* Release assigned resource */
 	list_for_each_entry(dev_res, head, list)


