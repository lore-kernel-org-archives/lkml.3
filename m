Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaLEW4c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:56:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440AbaLEW40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.14 70/73] powerpc/powernv: Honor the generic "no_64bit_msi" flag
Date: Fri,  5 Dec 2014 14:45:16 -0800
Message-Id: <20141205224436.032649520@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205224433.921659956@linuxfoundation.org>
References: <20141205224433.921659956@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 360743814c4082515581aa23ab1d8e699e1fbe88 upstream.

Instead of the arch specific quirk which we are deprecating
and that drivers don't understand.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/powernv/pci-ioda.c |    3 +--
 arch/powerpc/platforms/powernv/pci.c      |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -902,7 +902,6 @@ static int pnv_pci_ioda_msi_setup(struct
 				  unsigned int is_64, struct msi_msg *msg)
 {
 	struct pnv_ioda_pe *pe = pnv_ioda_get_pe(dev);
-	struct pci_dn *pdn = pci_get_pdn(dev);
 	struct irq_data *idata;
 	struct irq_chip *ichip;
 	unsigned int xive_num = hwirq - phb->msi_base;
@@ -918,7 +917,7 @@ static int pnv_pci_ioda_msi_setup(struct
 		return -ENXIO;
 
 	/* Force 32-bit MSI on some broken devices */
-	if (pdn && pdn->force_32bit_msi)
+	if (dev->no_64bit_msi)
 		is_64 = 0;
 
 	/* Assign XIVE to PE */
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -1,3 +1,4 @@
+
 /*
  * Support PCI/PCIe on PowerNV platforms
  *
@@ -50,9 +51,8 @@ static int pnv_msi_check_device(struct p
 {
 	struct pci_controller *hose = pci_bus_to_host(pdev->bus);
 	struct pnv_phb *phb = hose->private_data;
-	struct pci_dn *pdn = pci_get_pdn(pdev);
 
-	if (pdn && pdn->force_32bit_msi && !phb->msi32_support)
+	if (pdev->no_64bit_msi && !phb->msi32_support)
 		return -ENODEV;
 
 	return (phb && phb->msi_bmp.bitmap) ? 0 : -ENODEV;


