Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbaBZXmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:42:23 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:35609 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbaBZXmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:42:18 -0500
Subject: [PATCH 7/7] s390/PCI: Use generic pci_enable_resources()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jan Glauber <jang@linux.vnet.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com
Date: Wed, 26 Feb 2014 16:42:15 -0700
Message-ID: <20140226234215.18970.1743.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140226233541.18970.83328.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140226233541.18970.83328.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic pci_enable_resources() does essentially the same thing as the
code in the s390 version of pcibios_enable_device().

There are differences, but I don't think any of them are a problem.  The
generic code:

  - Checks everything up to PCI_NUM_RESOURCES, not PCI_BAR_COUNT (6), so
    we'll now check the ROM resource, IOV resources, and bridge windows.

  - Checks for res->flags & IORESOURCE_UNSET.  The s390 code never sets
    IORESOURCE_UNSET, so this isn't a problem.

  - Checks res->parent.  The s390 pcibios_add_device() calls
    pci_claim_resource() on all BARs (except ROM, IOV, and bridge windows)
    so this isn't a problem either.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Sebastian Ott <sebott@linux.vnet.ibm.com>
CC: Jan Glauber <jang@linux.vnet.ibm.com>
CC: linux390@de.ibm.com
---
 arch/s390/pci/pci.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 66670ff262a0..7d5fcaed3361 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -695,18 +695,7 @@ int pcibios_enable_device(struct pci_dev *pdev, int mask)
 	zpci_fmb_enable_device(zdev);
 	zpci_map_resources(zdev);
 
-	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
-	for (i = 0; i < PCI_BAR_COUNT; i++) {
-		res = &pdev->resource[i];
-
-		if (res->flags & IORESOURCE_IO)
-			return -EINVAL;
-
-		if (res->flags & IORESOURCE_MEM)
-			cmd |= PCI_COMMAND_MEMORY;
-	}
-	pci_write_config_word(pdev, PCI_COMMAND, cmd);
-	return 0;
+	return pci_enable_resources(pdev, mask);
 }
 
 void pcibios_disable_device(struct pci_dev *pdev)

