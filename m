Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab3FKUEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:04:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819Ab3FKUER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:04:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Brian King <brking@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: [ 64/79] powerpc/pseries: Force 32 bit MSIs for devices that require it
Date: Tue, 11 Jun 2013 13:03:30 -0700
Message-Id: <20130611195324.480116556@linuxfoundation.org>
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

commit e61133dda480062d221f09e4fc18f66763f8ecd0 upstream.

The following patch implements a new PAPR change which allows
the OS to force the use of 32 bit MSIs, regardless of what
the PCI capabilities indicate. This is required for some
devices that advertise support for 64 bit MSIs but don't
actually support them.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/pci-bridge.h |    2 ++
 arch/powerpc/platforms/pseries/msi.c  |   21 ++++++++++++++++++---
 2 files changed, 20 insertions(+), 3 deletions(-)

--- a/arch/powerpc/include/asm/pci-bridge.h
+++ b/arch/powerpc/include/asm/pci-bridge.h
@@ -154,6 +154,8 @@ struct pci_dn {
 
 	int	pci_ext_config_space;	/* for pci devices */
 
+	int	force_32bit_msi:1;
+
 	struct	pci_dev *pcidev;	/* back-pointer to the pci device */
 #ifdef CONFIG_EEH
 	struct eeh_dev *edev;		/* eeh device */
--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -24,6 +24,7 @@ static int query_token, change_token;
 #define RTAS_RESET_FN		2
 #define RTAS_CHANGE_MSI_FN	3
 #define RTAS_CHANGE_MSIX_FN	4
+#define RTAS_CHANGE_32MSI_FN	5
 
 static struct pci_dn *get_pdn(struct pci_dev *pdev)
 {
@@ -58,7 +59,8 @@ static int rtas_change_msi(struct pci_dn
 
 	seq_num = 1;
 	do {
-		if (func == RTAS_CHANGE_MSI_FN || func == RTAS_CHANGE_MSIX_FN)
+		if (func == RTAS_CHANGE_MSI_FN || func == RTAS_CHANGE_MSIX_FN ||
+		    func == RTAS_CHANGE_32MSI_FN)
 			rc = rtas_call(change_token, 6, 4, rtas_ret, addr,
 					BUID_HI(buid), BUID_LO(buid),
 					func, num_irqs, seq_num);
@@ -426,9 +428,12 @@ static int rtas_setup_msi_irqs(struct pc
 	 */
 again:
 	if (type == PCI_CAP_ID_MSI) {
-		rc = rtas_change_msi(pdn, RTAS_CHANGE_MSI_FN, nvec);
+		if (pdn->force_32bit_msi)
+			rc = rtas_change_msi(pdn, RTAS_CHANGE_32MSI_FN, nvec);
+		else
+			rc = rtas_change_msi(pdn, RTAS_CHANGE_MSI_FN, nvec);
 
-		if (rc < 0) {
+		if (rc < 0 && !pdn->force_32bit_msi) {
 			pr_debug("rtas_msi: trying the old firmware call.\n");
 			rc = rtas_change_msi(pdn, RTAS_CHANGE_FN, nvec);
 		}
@@ -512,3 +517,13 @@ static int rtas_msi_init(void)
 	return 0;
 }
 arch_initcall(rtas_msi_init);
+
+static void quirk_radeon(struct pci_dev *dev)
+{
+	struct pci_dn *pdn = get_pdn(dev);
+
+	if (pdn)
+		pdn->force_32bit_msi = 1;
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x68f2, quirk_radeon);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0xaa68, quirk_radeon);


