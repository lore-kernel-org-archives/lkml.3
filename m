Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965272Ab3GCTK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:10:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20027 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964961Ab3GCTAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:25 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=AXpxkQuaOfYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=RJ2ZuU4W1FQA:10 a=VnNF1IyMAAAA:8 a=wMNdZWldAAAA:8 a=pQFG53Joc4AfjvbZiugA:9 a=jeBq3FmKZ4MA:10 a=6msDpI0TN33lU8Bz:21 a=F07DzN7q9QhikdLu:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184104.002972047@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Brian King <brking@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [104/141] powerpc/pseries: Force 32 bit MSIs for devices that require it
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0104-powerpc-pseries-Force-32-bit-MSIs-for-devices-that-r.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Brian King <brking@linux.vnet.ibm.com>

[ Upstream commit e61133dda480062d221f09e4fc18f66763f8ecd0 ]

The following patch implements a new PAPR change which allows
the OS to force the use of 32 bit MSIs, regardless of what
the PCI capabilities indicate. This is required for some
devices that advertise support for 64 bit MSIs but don't
actually support them.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/powerpc/include/asm/pci-bridge.h |    2 ++
 arch/powerpc/platforms/pseries/msi.c  |   21 ++++++++++++++++++---
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/pci-bridge.h b/arch/powerpc/include/asm/pci-bridge.h
index 78326de..271af40 100644
--- a/arch/powerpc/include/asm/pci-bridge.h
+++ b/arch/powerpc/include/asm/pci-bridge.h
@@ -154,6 +154,8 @@ struct pci_dn {
 
 	int	pci_ext_config_space;	/* for pci devices */
 
+	int	force_32bit_msi:1;
+
 	struct	pci_dev *pcidev;	/* back-pointer to the pci device */
 #ifdef CONFIG_EEH
 	struct eeh_dev *edev;		/* eeh device */
diff --git a/arch/powerpc/platforms/pseries/msi.c b/arch/powerpc/platforms/pseries/msi.c
index 109fdb7..5c9aa89 100644
--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -24,6 +24,7 @@ static int query_token, change_token;
 #define RTAS_RESET_FN		2
 #define RTAS_CHANGE_MSI_FN	3
 #define RTAS_CHANGE_MSIX_FN	4
+#define RTAS_CHANGE_32MSI_FN	5
 
 static struct pci_dn *get_pdn(struct pci_dev *pdev)
 {
@@ -58,7 +59,8 @@ static int rtas_change_msi(struct pci_dn *pdn, u32 func, u32 num_irqs)
 
 	seq_num = 1;
 	do {
-		if (func == RTAS_CHANGE_MSI_FN || func == RTAS_CHANGE_MSIX_FN)
+		if (func == RTAS_CHANGE_MSI_FN || func == RTAS_CHANGE_MSIX_FN ||
+		    func == RTAS_CHANGE_32MSI_FN)
 			rc = rtas_call(change_token, 6, 4, rtas_ret, addr,
 					BUID_HI(buid), BUID_LO(buid),
 					func, num_irqs, seq_num);
@@ -407,9 +409,12 @@ static int rtas_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 	 * return MSI-Xs.
 	 */
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
@@ -489,3 +494,13 @@ static int rtas_msi_init(void)
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
-- 
1.7.10.4


