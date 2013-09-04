Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762707Ab3IDOPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:15:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab3IDOPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:15:17 -0400
Date: Wed, 4 Sep 2013 16:17:11 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v2 3/4] AHCI: Conserve interrupts with
 pci_enable_msi_block_part() interface
Message-ID: <20130904141710.GD8726@dhcp-26-207.brq.redhat.com>
References: <cover.1378111919.git.agordeev@redhat.com>
 <3bb1b4375655ecfde5017cc70973d078f2434d5d.1378111919.git.agordeev@redhat.com>
 <20130903141824.GD10522@htj.dyndns.org>
 <20130903161906.GC14221@dhcp-26-207.brq.redhat.com>
 <20130903182731.GA27092@mtj.dyndns.org>
 <20130904072256.GA8726@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904072256.GA8726@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the new pci_enable_msi_block_part() interface
and conserve on othewise wasted interrupt resources for 10
of 16 unused MSI vectors on Intel chipsets.
    
Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index db4380d..41f9c08 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1091,26 +1091,39 @@ static inline void ahci_gtf_filter_workaround(struct ata_host *host)
 {}
 #endif
 
-int ahci_init_interrupts(struct pci_dev *pdev, struct ahci_host_priv *hpriv)
+static int ahci_get_mrsm(struct ahci_host_priv *hpriv)
+{
+	void __iomem *mmio = hpriv->mmio;
+	u32 ctl = readl(mmio + HOST_CTL);
+
+	return (ctl & HOST_MRSM);
+}
+
+int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_ports,
+			 struct ahci_host_priv *hpriv)
 {
 	int rc;
-	unsigned int maxvec;
+	unsigned int n_msis;
 
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
+	if (hpriv->flags & AHCI_HFLAG_NO_MSI)
+		goto intx;
+
+	for (n_msis = roundup_pow_of_two(n_ports);
+	     n_msis <= AHCI_MAX_PORTS; n_msis *= 2) {
+		rc = pci_enable_msi_block_part(pdev, n_ports, n_msis);
+		if (rc < 0)
+			goto intx;
+		if (rc)
+			break;
+		if (!ahci_get_mrsm(hpriv))
+			return n_msis;
+		pci_disable_msi(pdev);
 	}
 
+	if (!pci_enable_msi(pdev))
+		return 1;
+
+intx:
 	pci_intx(pdev, 1);
 	return 0;
 }
@@ -1277,10 +1290,6 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	hpriv->mmio = pcim_iomap_table(pdev)[ahci_pci_bar];
 
-	n_msis = ahci_init_interrupts(pdev, hpriv);
-	if (n_msis > 1)
-		hpriv->flags |= AHCI_HFLAG_MULTI_MSI;
-
 	/* save initial config */
 	ahci_pci_save_initial_config(pdev, hpriv);
 
@@ -1327,6 +1336,10 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	n_ports = max(ahci_nr_ports(hpriv->cap), fls(hpriv->port_map));
 
+	n_msis = ahci_init_interrupts(pdev, n_ports, hpriv);
+	if (n_msis > 1)
+		hpriv->flags |= AHCI_HFLAG_MULTI_MSI;
+
 	host = ata_host_alloc_pinfo(&pdev->dev, ppi, n_ports);
 	if (!host)
 		return -ENOMEM;
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 1145637..19bc846 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -91,6 +91,7 @@ enum {
 	/* HOST_CTL bits */
 	HOST_RESET		= (1 << 0),  /* reset controller; self-clear */
 	HOST_IRQ_EN		= (1 << 1),  /* global IRQ enable */
+	HOST_MRSM		= (1 << 2),  /* MSI Revert to Single Message */
 	HOST_AHCI_EN		= (1 << 31), /* AHCI enabled */
 
 	/* HOST_CAP bits */

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
