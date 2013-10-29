Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab3J2Lfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:35:36 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:16023
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752167Ab3J2Lef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:34:35 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzd2iz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h1155h)
From: Bharat Bhushan <r65777@freescale.com>
To: <alex.williamson@redhat.com>, <joro@8bytes.org>,
        <galak@kernel.crashing.org>, <scottwood@freescale.com>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-pci@vger.kernel.org>, <agraf@suse.de>,
        <stuart.yoder@freescale.com>
CC: Bharat Bhushan <Bharat.Bhushan@freescale.com>,
        Bharat Bhushan <bharat.bhushan@freescale.com>
Subject: [PATCH 2/5 RFC] powerpc: pci: Add arch specific msi region interface
Date: Tue, 29 Oct 2013 16:57:40 +0530
Message-ID: <1383046062-16520-4-git-send-email-Bharat.Bhushan@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1383046062-16520-1-git-send-email-Bharat.Bhushan@freescale.com>
References: <1383046062-16520-1-git-send-email-Bharat.Bhushan@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the interface to get the msi region information from arch
specific code. The machine spicific code is not yet defined.

Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
---
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


