Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919Ab3FKUHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:07:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42052 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820Ab3FKUES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:04:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Brian King <brking@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: [ 65/79] powerpc/pseries: Make 32-bit MSI quirk work on systems lacking firmware support
Date: Tue, 11 Jun 2013 13:03:31 -0700
Message-Id: <20130611195324.600483375@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian King <brking@linux.vnet.ibm.com>

commit f1dd153121dcb872ae6cba8d52bec97519eb7d97 upstream.

Recent commit e61133dda480062d221f09e4fc18f66763f8ecd0 added support
for a new firmware feature to force an adapter to use 32 bit MSIs.
However, this firmware is not available for all systems. The hack below
allows devices needing 32 bit MSIs to work on these systems as well.
It is careful to only enable this on Gen2 slots, which should limit
this to configurations where this hack is needed and tested to work.

[Small change to factor out the hack into a separate function -- BenH]

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/pseries/msi.c |   40 ++++++++++++++++++++++++++++++++---
 1 file changed, 37 insertions(+), 3 deletions(-)

--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -394,6 +394,23 @@ static int check_msix_entries(struct pci
 	return 0;
 }
 
+static void rtas_hack_32bit_msi_gen2(struct pci_dev *pdev)
+{
+	u32 addr_hi, addr_lo;
+
+	/*
+	 * We should only get in here for IODA1 configs. This is based on the
+	 * fact that we using RTAS for MSIs, we don't have the 32 bit MSI RTAS
+	 * support, and we are in a PCIe Gen2 slot.
+	 */
+	dev_info(&pdev->dev,
+		 "rtas_msi: No 32 bit MSI firmware support, forcing 32 bit MSI\n");
+	pci_read_config_dword(pdev, pdev->msi_cap + PCI_MSI_ADDRESS_HI, &addr_hi);
+	addr_lo = 0xffff0000 | ((addr_hi >> (48 - 32)) << 4);
+	pci_write_config_dword(pdev, pdev->msi_cap + PCI_MSI_ADDRESS_LO, addr_lo);
+	pci_write_config_dword(pdev, pdev->msi_cap + PCI_MSI_ADDRESS_HI, 0);
+}
+
 static int rtas_setup_msi_irqs(struct pci_dev *pdev, int nvec_in, int type)
 {
 	struct pci_dn *pdn;
@@ -401,6 +418,7 @@ static int rtas_setup_msi_irqs(struct pc
 	struct msi_desc *entry;
 	struct msi_msg msg;
 	int nvec = nvec_in;
+	int use_32bit_msi_hack = 0;
 
 	pdn = get_pdn(pdev);
 	if (!pdn)
@@ -428,15 +446,31 @@ static int rtas_setup_msi_irqs(struct pc
 	 */
 again:
 	if (type == PCI_CAP_ID_MSI) {
-		if (pdn->force_32bit_msi)
+		if (pdn->force_32bit_msi) {
 			rc = rtas_change_msi(pdn, RTAS_CHANGE_32MSI_FN, nvec);
-		else
+			if (rc < 0) {
+				/*
+				 * We only want to run the 32 bit MSI hack below if
+				 * the max bus speed is Gen2 speed
+				 */
+				if (pdev->bus->max_bus_speed != PCIE_SPEED_5_0GT)
+					return rc;
+
+				use_32bit_msi_hack = 1;
+			}
+		} else
+			rc = -1;
+
+		if (rc < 0)
 			rc = rtas_change_msi(pdn, RTAS_CHANGE_MSI_FN, nvec);
 
-		if (rc < 0 && !pdn->force_32bit_msi) {
+		if (rc < 0) {
 			pr_debug("rtas_msi: trying the old firmware call.\n");
 			rc = rtas_change_msi(pdn, RTAS_CHANGE_FN, nvec);
 		}
+
+		if (use_32bit_msi_hack && rc > 0)
+			rtas_hack_32bit_msi_gen2(pdev);
 	} else
 		rc = rtas_change_msi(pdn, RTAS_CHANGE_MSIX_FN, nvec);
 


