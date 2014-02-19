Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaBSKNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 05:13:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbaBSKNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 05:13:47 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy King <acking@vmware.com>, Dmitry Torokhov <dtor@vmware.com>,
        linux-pci@vger.kernel.org
Subject: [PATCH] vmw_vmci: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Wed, 19 Feb 2014 11:15:25 +0100
Message-Id: <1392804931-30671-5-git-send-email-agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andy King <acking@vmware.com>
Cc: Dmitry Torokhov <dtor@vmware.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/misc/vmw_vmci/vmci_guest.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_guest.c b/drivers/misc/vmw_vmci/vmci_guest.c
index d35cda0..877ec8a 100644
--- a/drivers/misc/vmw_vmci/vmci_guest.c
+++ b/drivers/misc/vmw_vmci/vmci_guest.c
@@ -383,13 +383,18 @@ static int vmci_enable_msix(struct pci_dev *pdev,
 		vmci_dev->msix_entries[i].vector = i;
 	}
 
-	result = pci_enable_msix(pdev, vmci_dev->msix_entries, VMCI_MAX_INTRS);
-	if (result == 0)
+	result = pci_enable_msix_range(pdev, vmci_dev->msix_entries,
+				       VMCI_MAX_INTRS, VMCI_MAX_INTRS);
+	if (result > 0) {
 		vmci_dev->exclusive_vectors = true;
-	else if (result > 0)
-		result = pci_enable_msix(pdev, vmci_dev->msix_entries, 1);
+	} else if (result == -ENOSPC) {
+		result = pci_enable_msix_range(pdev, vmci_dev->msix_entries,
+					       1, 1);
+		if (result < 0)
+			return result;
+	}
 
-	return result;
+	return 0;
 }
 
 /*
-- 
1.7.7.6

