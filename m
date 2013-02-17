Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3BQW7j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:59:39 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45807 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756350Ab3BQWzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:43 -0500
Message-Id: <20130217225005.247273845@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:32 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Alessandro Rubini <rubini@gnudd.com>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: [ 31/66] ahci: support the STA2X11 I/O Hub
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alessandro Rubini <rubini@gnudd.com>

commit 318893e1429a9d50569a0379d1e20b0ecc45c555 upstream.

The AHCI controller found in the STA2X11 chip uses BAR number 0
instead of 5. Also, the chip's fixup code sets a special DMA mask
for all of its PCI functions, and the mask must be preserved here.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/ahci.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index cf26222..d07bf03 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -52,7 +52,8 @@
 #define DRV_VERSION	"3.0"
 
 enum {
-	AHCI_PCI_BAR		= 5,
+	AHCI_PCI_BAR_STA2X11	= 0,
+	AHCI_PCI_BAR_STANDARD	= 5,
 };
 
 enum board_ids {
@@ -375,6 +376,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(SI, 0x1185), board_ahci },		/* SiS 968 */
 	{ PCI_VDEVICE(SI, 0x0186), board_ahci },		/* SiS 968 */
 
+	/* ST Microelectronics */
+	{ PCI_VDEVICE(STMICRO, 0xCC06), board_ahci },		/* ST ConneXt */
+
 	/* Marvell */
 	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
 	{ PCI_VDEVICE(MARVELL, 0x6121), board_ahci_mv },	/* 6121 */
@@ -622,6 +626,13 @@ static int ahci_configure_dma_masks(struct pci_dev *pdev, int using_dac)
 {
 	int rc;
 
+	/*
+	 * If the device fixup already set the dma_mask to some non-standard
+	 * value, don't extend it here. This happens on STA2X11, for example.
+	 */
+	if (pdev->dma_mask && pdev->dma_mask < DMA_BIT_MASK(32))
+		return 0;
+
 	if (using_dac &&
 	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
@@ -1026,6 +1037,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct ahci_host_priv *hpriv;
 	struct ata_host *host;
 	int n_ports, i, rc;
+	int ahci_pci_bar = AHCI_PCI_BAR_STANDARD;
 
 	VPRINTK("ENTER\n");
 
@@ -1057,6 +1069,10 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_info(&pdev->dev,
 			 "PDC42819 can only drive SATA devices with this driver\n");
 
+	/* The Connext uses non-standard BAR */
+	if (pdev->vendor == PCI_VENDOR_ID_STMICRO && pdev->device == 0xCC06)
+		ahci_pci_bar = AHCI_PCI_BAR_STA2X11;
+
 	/* acquire resources */
 	rc = pcim_enable_device(pdev);
 	if (rc)
@@ -1065,7 +1081,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* AHCI controllers often implement SFF compatible interface.
 	 * Grab all PCI BARs just in case.
 	 */
-	rc = pcim_iomap_regions_request_all(pdev, 1 << AHCI_PCI_BAR, DRV_NAME);
+	rc = pcim_iomap_regions_request_all(pdev, 1 << ahci_pci_bar, DRV_NAME);
 	if (rc == -EBUSY)
 		pcim_pin_device(pdev);
 	if (rc)
@@ -1108,7 +1124,7 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if ((hpriv->flags & AHCI_HFLAG_NO_MSI) || pci_enable_msi(pdev))
 		pci_intx(pdev, 1);
 
-	hpriv->mmio = pcim_iomap_table(pdev)[AHCI_PCI_BAR];
+	hpriv->mmio = pcim_iomap_table(pdev)[ahci_pci_bar];
 
 	/* save initial config */
 	ahci_pci_save_initial_config(pdev, hpriv);
@@ -1172,8 +1188,8 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 
-		ata_port_pbar_desc(ap, AHCI_PCI_BAR, -1, "abar");
-		ata_port_pbar_desc(ap, AHCI_PCI_BAR,
+		ata_port_pbar_desc(ap, ahci_pci_bar, -1, "abar");
+		ata_port_pbar_desc(ap, ahci_pci_bar,
 				   0x100 + ap->port_no * 0x80, "port");
 
 		/* set enclosure management message type */


