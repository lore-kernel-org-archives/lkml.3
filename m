Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbaBSKPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:15:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbaBSKOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:14:00 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, linux-pci@vger.kernel.org
Subject: [PATCH] xen-pciback: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Wed, 19 Feb 2014 11:15:30 +0100
Message-Id: <1392804931-30671-10-git-send-email-agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/xen/xen-pciback/pciback_ops.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/xen-pciback/pciback_ops.c b/drivers/xen/xen-pciback/pciback_ops.c
index 64eb0cd..f5b4c3e 100644
--- a/drivers/xen/xen-pciback/pciback_ops.c
+++ b/drivers/xen/xen-pciback/pciback_ops.c
@@ -213,9 +213,15 @@ int xen_pcibk_enable_msix(struct xen_pcibk_device *pdev,
 		entries[i].vector = op->msix_entries[i].vector;
 	}
 
-	result = pci_enable_msix(dev, entries, op->value);
+	result = pci_enable_msix_range(dev, entries, op->value, op->value);
+	if (result < op->value) {
+		if (result > 0)
+			pci_disable_msix(dev);
 
-	if (result == 0) {
+		pr_warn_ratelimited("%s: error enabling MSI-X for guest %u: err %d!\n",
+				    pci_name(dev), pdev->xdev->otherend_id,
+				    result);
+	} else {
 		for (i = 0; i < op->value; i++) {
 			op->msix_entries[i].entry = entries[i].entry;
 			if (entries[i].vector)
@@ -227,10 +233,8 @@ int xen_pcibk_enable_msix(struct xen_pcibk_device *pdev,
 						pci_name(dev), i,
 						op->msix_entries[i].vector);
 		}
-	} else
-		pr_warn_ratelimited("%s: error enabling MSI-X for guest %u: err %d!\n",
-				    pci_name(dev), pdev->xdev->otherend_id,
-				    result);
+	}
+
 	kfree(entries);
 
 	op->value = result;
-- 
1.7.7.6

