Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab3KSFY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 00:24:58 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:55665
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751858Ab3KSFYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 00:24:06 -0500
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
Subject: [PATCH 6/9 v2] powerpc: pci: Extend msi iova page setup to arch specific
Date: Tue, 19 Nov 2013 10:47:10 +0530
Message-ID: <1384838233-24847-7-git-send-email-Bharat.Bhushan@freescale.com>
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

This patch extend the interface to arch specific code for setting
msi iova address for a msi page. Machine specific code is not yet
implemented.

Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
---
v2
 - new patch

 arch/powerpc/include/asm/machdep.h |    2 ++
 arch/powerpc/kernel/msi.c          |   10 ++++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/machdep.h b/arch/powerpc/include/asm/machdep.h
index 8d1b787..e87b806 100644
--- a/arch/powerpc/include/asm/machdep.h
+++ b/arch/powerpc/include/asm/machdep.h
@@ -132,6 +132,8 @@ struct machdep_calls {
 	/* Returns the requested region's address and size */
 	int		(*msi_get_region)(int region_num,
 					  struct msi_region *region);
+	int		(*msi_set_iova)(struct pci_dev *pdev, int region_num,
+					dma_addr_t iova, bool set);
 #endif
 
 	void		(*restart)(char *cmd);
diff --git a/arch/powerpc/kernel/msi.c b/arch/powerpc/kernel/msi.c
index 1a67787..e2bd555 100644
--- a/arch/powerpc/kernel/msi.c
+++ b/arch/powerpc/kernel/msi.c
@@ -13,6 +13,16 @@
 
 #include <asm/machdep.h>
 
+int arch_msi_set_iova(struct pci_dev *pdev, int region_num,
+		      dma_addr_t iova, bool set)
+{
+	if (ppc_md.msi_set_iova) {
+		pr_debug("msi: Using platform get_region_count routine.\n");
+		return ppc_md.msi_set_iova(pdev, region_num, iova, set);
+	}
+	return 0;
+}
+
 int arch_msi_get_region_count(void)
 {
 	if (ppc_md.msi_get_region_count) {
-- 
1.7.0.4


