Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab3C1E2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 00:28:30 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26357 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab3C1E20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 00:28:26 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Matthew Whitehead <mwhitehe@redhat.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        stable@kernel.org
Subject: [PATCH 1/2] eisa, PCI: Fix bus res reference
Date: Wed, 27 Mar 2013 21:28:04 -0700
Message-Id: <1364444885-19751-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364444885-19751-1-git-send-email-yinghai@kernel.org>
References: <1364444885-19751-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthem found that 3.8.3 is having problems with an old (ancient)
PCI-to-EISA bridge, the Intel 82375. It worked with the 3.2 kernel.
He identified the 82375, but doesn't assign the struct resource *res
pointer inside the struct eisa_root_device, and panics.

After looking at pci_eisa_init(), found it referring bus resource
directly instead of pci_bus_resource_n().

After commit 45ca9e97 (PCI: add helpers for building PCI bus resource lists)
and commit 0efd5aab (PCI: add struct pci_host_bridge_window with CPU/bus
address offset), bus->resource[] is not used for pci root bus any more.

Fix it by using pci_bus_resource_n() and correct idx for root bus.

Reported-by: Matthew Whitehead <mwhitehe@redhat.com>
Tested-by: Matthew Whitehead <mwhitehe@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: stable@kernel.org

---
 drivers/eisa/pci_eisa.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/eisa/pci_eisa.c
===================================================================
--- linux-2.6.orig/drivers/eisa/pci_eisa.c
+++ linux-2.6/drivers/eisa/pci_eisa.c
@@ -22,7 +22,8 @@ static struct eisa_root_device pci_eisa_
 static int __init pci_eisa_init(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
-	int rc;
+	int rc, n = 0;
+	struct resource *bus_res;
 
 	if ((rc = pci_enable_device (pdev))) {
 		printk (KERN_ERR "pci_eisa : Could not enable device %s\n",
@@ -30,9 +31,12 @@ static int __init pci_eisa_init(struct p
 		return rc;
 	}
 
+	if (pci_is_root_bus(pdev->bus))
+		n = PCI_BRIDGE_RESOURCE_NUM;
+	bus_res = pci_bus_resource_n(pdev->bus, n);
 	pci_eisa_root.dev              = &pdev->dev;
-	pci_eisa_root.res	       = pdev->bus->resource[0];
-	pci_eisa_root.bus_base_addr    = pdev->bus->resource[0]->start;
+	pci_eisa_root.res	       = bus_res;
+	pci_eisa_root.bus_base_addr    = bus_res->start;
 	pci_eisa_root.slots	       = EISA_MAX_SLOTS;
 	pci_eisa_root.dma_mask         = pdev->dma_mask;
 	dev_set_drvdata(pci_eisa_root.dev, &pci_eisa_root);
