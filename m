Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab3ENC30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 22:29:26 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50351 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175Ab3ENC2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 22:28:54 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 5/7] PCI, ACPI: Don't glue ACPI dev with pci VFs
Date: Mon, 13 May 2013 19:28:24 -0700
Message-Id: <1368498506-25857-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368498506-25857-1-git-send-email-yinghai@kernel.org>
References: <1368498506-25857-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When sriov is enabled, VF could just start after PF in pci tree.
like c1:00.0 will be PF, and c1:00.1 and after will be VF.

acpi do have dev with same ADR. that will make them get glued
wrongly.

Skip that if it is virtfn.

Also need to set is_virtfn before pci_device_add(), as
gluing is triggered by device_add().

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/iov.c      |    6 +++---
 drivers/pci/pci-acpi.c |    4 ++++
 2 files changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/pci/iov.c
===================================================================
--- linux-2.6.orig/drivers/pci/iov.c
+++ linux-2.6/drivers/pci/iov.c
@@ -110,12 +110,12 @@ static int virtfn_add(struct pci_dev *de
 	if (reset)
 		__pci_reset_function(virtfn);
 
-	pci_device_add(virtfn, virtfn->bus);
-	mutex_unlock(&iov->dev->sriov->lock);
-
 	virtfn->physfn = pci_dev_get(dev);
 	virtfn->is_virtfn = 1;
 
+	pci_device_add(virtfn, virtfn->bus);
+	mutex_unlock(&iov->dev->sriov->lock);
+
 	rc = pci_bus_add_device(virtfn);
 	sprintf(buf, "virtfn%u", id);
 	rc = sysfs_create_link(&dev->dev.kobj, &virtfn->dev.kobj, buf);
Index: linux-2.6/drivers/pci/pci-acpi.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-acpi.c
+++ linux-2.6/drivers/pci/pci-acpi.c
@@ -321,6 +321,10 @@ static int acpi_pci_find_device(struct d
 	u64	addr;
 
 	pci_dev = to_pci_dev(dev);
+	/* don't mix vf with real pci device */
+	if (pci_dev->is_virtfn)
+		return -ENODEV;
+
 	/* Please ref to ACPI spec for the syntax of _ADR */
 	addr = (PCI_SLOT(pci_dev->devfn) << 16) | PCI_FUNC(pci_dev->devfn);
 	*handle = acpi_get_child(DEVICE_ACPI_HANDLE(dev->parent), addr);
