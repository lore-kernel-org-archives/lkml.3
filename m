Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab3KSFXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 00:23:54 -0500
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:24297
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751529Ab3KSFXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 00:23:44 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 8
X-BigFish: VS8(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6h1082kz70kd2iz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h20cfi1155h)
From: Bharat Bhushan <r65777@freescale.com>
To: <alex.williamson@redhat.com>, <joro@8bytes.org>, <bhelgaas@google.com>,
        <agraf@suse.de>, <scottwood@freescale.com>,
        <stuart.yoder@freescale.com>, <iommu@lists.linux-foundation.org>,
        <linux-pci@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
CC: Bharat Bhushan <Bharat.Bhushan@freescale.com>,
        Bharat Bhushan <bharat.bhushan@freescale.com>
Subject: [PATCH 3/9 v2] powerpc: pci: Add arch specific msi region interface
Date: Tue, 19 Nov 2013 10:47:07 +0530
Message-ID: <1384838233-24847-4-git-send-email-Bharat.Bhushan@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1384838233-24847-1-git-send-email-Bharat.Bhushan@freescale.com>
References: <1384838233-24847-1-git-send-email-Bharat.Bhushan@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the interface to get the msi region information from arch
specific code. The machine spicific code is not yet defined.

Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
---
v1->v2
 - None

 arch/powerpc/include/asm/machdep.h |    8 ++++++++
 arch/powerpc/kernel/msi.c          |   18 ++++++++++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
index 8b48090..8d1b787 100644
--- a/arch/powerpc/include/asm/machdep.h
+++ b/arch/powerpc/include/asm/machdep.h
@@ -30,6 +30,7 @@ struct file;
 struct pci_controller;
 struct kimage;
 struct pci_host_bridge;
+struct msi_region;
 
 struct machdep_calls {
 	char		*name;
@@ -124,6 +125,13 @@ struct machdep_calls {
 	int		(*setup_msi_irqs)(struct pci_dev *dev,
 					  int nvec, int type);
 	void		(*teardown_msi_irqs)(struct pci_dev *dev);
+
+	/* Returns the number of MSI regions (banks) */
+	int		(*msi_get_region_count)(void);
+
+	/* Returns the requested region's address and size */
+	int		(*msi_get_region)(int region_num,
+					  struct msi_region *region);
 #endif
 
 	void		(*restart)(char *cmd);
diff --git a/arch/powerpc/kernel/msi.c b/arch/powerpc/kernel/msi.c
index 8bbc12d..1a67787 100644
--- a/arch/powerpc/kernel/msi.c
+++ b/arch/powerpc/kernel/msi.c
@@ -13,6 +13,24 @@
 
 #include <asm/machdep.h>
 
+int arch_msi_get_region_count(void)
+{
+	if (ppc_md.msi_get_region_count) {
+		pr_debug("msi: Using platform get_region_count routine.\n");
+		return ppc_md.msi_get_region_count();
+	}
+	return 0;
+}
+
+int arch_msi_get_region(int region_num, struct msi_region *region)
+{
+	if (ppc_md.msi_get_region) {
+		pr_debug("msi: Using platform get_region routine.\n");
+		return ppc_md.msi_get_region(region_num, region);
+	}
+	return 0;
+}
+
 int arch_msi_check_device(struct pci_dev* dev, int nvec, int type)
 {
 	if (!ppc_md.setup_msi_irqs || !ppc_md.teardown_msi_irqs) {
-- 
1.7.0.4


