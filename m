Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab3IBI6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:58:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758149Ab3IBI6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:58:34 -0400
Date: Mon, 2 Sep 2013 11:00:28 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-pci@vger.kernel.org, linux-ide@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 3/4] AHCI: Conserve interrupts with
 pci_enable_msi_block_part() interface
Message-ID: <3bb1b4375655ecfde5017cc70973d078f2434d5d.1378111919.git.agordeev@redhat.com>
References: <cover.1378111919.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1378111919.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the new pci_enable_msi_block_part() interface
and conserve on othewise wasted interrupt resources for 10
of 16 unused MSI vectors on Intel chipsets.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/ata/ahci.c |   48 +++++++++++++++++++++++++++++-------------------
 1 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index db4380d..b0c1648 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1091,26 +1091,36 @@ static inline void ahci_gtf_filter_workaround(struct ata_host *host)
 {}
 #endif
 
-int ahci_init_interrupts(struct pci_dev *pdev, struct ahci_host_priv *hpriv)
+int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_ports,
+			 struct ahci_host_priv *hpriv)
 {
 	int rc;
 	unsigned int maxvec;
 
-	if (!(hpriv->flags & AHCI_HFLAG_NO_MSI)) {
-		rc = pci_enable_msi_block_auto(pdev, &maxvec);
-		if (rc > 0) {
-			if ((rc == maxvec) || (rc == 1))
-				return rc;
-			/*
-			 * Assume that advantage of multipe MSIs is negated,
-			 * so fallback to single MSI mode to save resources
-			 */
-			pci_disable_msi(pdev);
-			if (!pci_enable_msi(pdev))
-				return 1;
-		}
-	}
+	if (hpriv->flags & AHCI_HFLAG_NO_MSI)
+		goto intx;
+
+	rc = pci_enable_msi_block_part(pdev, n_ports, AHCI_MAX_PORTS);
+	if (!rc)
+		return AHCI_MAX_PORTS;
+	if (rc < 0)
+		goto intx;
+
+	maxvec = rc;
+	rc = pci_enable_msi_block_part(pdev, n_ports, maxvec);
+	if (!rc)
+		return maxvec;
+	if (rc < 0)
+		goto intx;
+
+	/*
+	 * Assume that advantage of multipe MSIs is negated,
+	 * so fallback to single MSI mode to save resources
+	 */
+	if (!pci_enable_msi(pdev))
+		return 1;
 
+intx:
 	pci_intx(pdev, 1);
 	return 0;
 }
@@ -1277,10 +1287,6 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	hpriv->mmio = pcim_iomap_table(pdev)[ahci_pci_bar];
 
-	n_msis = ahci_init_interrupts(pdev, hpriv);
-	if (n_msis > 1)
-		hpriv->flags |= AHCI_HFLAG_MULTI_MSI;
-
 	/* save initial config */
 	ahci_pci_save_initial_config(pdev, hpriv);
 
@@ -1327,6 +1333,10 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	n_ports = max(ahci_nr_ports(hpriv->cap), fls(hpriv->port_map));
 
+	n_msis = ahci_init_interrupts(pdev, n_ports, hpriv);
+	if (n_msis > 1)
+		hpriv->flags |= AHCI_HFLAG_MULTI_MSI;
+
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
 	if (!host)
 		return -ENOMEM;
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
