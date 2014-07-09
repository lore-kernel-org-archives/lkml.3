Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbaGIKqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 06:46:49 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:49401 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaGIKqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 06:46:47 -0400
Date: Wed, 9 Jul 2014 12:46:39 +0200 (CEST)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@denkbrett
To: Frank Haverkamp <haver@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] misc/GenWQE: fix pci_enable_msi usage
Message-ID: <alpine.LFD.2.11.1407091237030.1590@denkbrett>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070910-3548-0000-0000-00000078BD7F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GenWQE used to call pci_enable_msi_block to allocate a desired number
of MSI's. If that was not possible pci_enable_msi_block returned with a
smaller number which might be possible to allocate. GenWQE then called
pci_enable_msi_block with that number.

Since commit a30d0108b
"GenWQE: Use pci_enable_msi_exact() instead of pci_enable_msi_block()"
pci_enable_msi_exact is used which fails if the desired number of MSI's
was not possible to allocate. Change GenWQE to use pci_enable_msi_range
to restore the old behavior.

Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
---
 drivers/misc/genwqe/card_ddcb.c  |  4 +---
 drivers/misc/genwqe/card_utils.c | 10 ++++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/genwqe/card_ddcb.c b/drivers/misc/genwqe/card_ddcb.c
index c8046db..f66d43d 100644
--- a/drivers/misc/genwqe/card_ddcb.c
+++ b/drivers/misc/genwqe/card_ddcb.c
@@ -1237,9 +1237,7 @@ int genwqe_setup_service_layer(struct genwqe_dev *cd)
 	}
 
 	rc = genwqe_set_interrupt_capability(cd, GENWQE_MSI_IRQS);
-	if (rc > 0)
-		rc = genwqe_set_interrupt_capability(cd, rc);
-	if (rc != 0) {
+	if (rc) {
 		rc = -ENODEV;
 		goto stop_kthread;
 	}
diff --git a/drivers/misc/genwqe/card_utils.c b/drivers/misc/genwqe/card_utils.c
index 62cc6bb..6abc437 100644
--- a/drivers/misc/genwqe/card_utils.c
+++ b/drivers/misc/genwqe/card_utils.c
@@ -718,10 +718,12 @@ int genwqe_set_interrupt_capability(struct genwqe_dev *cd, int count)
 	int rc;
 	struct pci_dev *pci_dev = cd->pci_dev;
 
-	rc = pci_enable_msi_exact(pci_dev, count);
-	if (rc == 0)
-		cd->flags |= GENWQE_FLAG_MSI_ENABLED;
-	return rc;
+	rc = pci_enable_msi_range(pci_dev, 1, count);
+	if (rc < 0)
+		return rc;
+
+	cd->flags |= GENWQE_FLAG_MSI_ENABLED;
+	return 0;
 }
 
 /**
-- 
1.9.3

