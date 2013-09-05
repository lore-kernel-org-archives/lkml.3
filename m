Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965335Ab3IEMwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 08:52:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28514 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935636Ab3IEMwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 08:52:23 -0400
Date: Thu, 5 Sep 2013 14:54:17 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-pci@vger.kernel.org, linux-ide@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v2 5/6] AHCI: Check MRSM bit when multiple MSIs enabled
Message-ID: <4bc31d6ccf3f84399b977fe8ed4fe77aadfa1c79.1378383792.git.agordeev@redhat.com>
References: <cover.1378383792.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1378383792.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not trust the hardware and always check if MSI
Revert to Single Message mode was enforced. Fall
back to the single MSI mode in case it did. Not
doing so might screw up the interrupt handling.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/ata/ahci.c |   16 ++++++++++++++++
 drivers/ata/ahci.h |    1 +
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index a6bb618..af5d535 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1091,6 +1091,14 @@ static inline void ahci_gtf_filter_workaround(struct ata_host *host)
 {}
 #endif
 
+static int ahci_get_mrsm(struct ahci_host_priv *hpriv)
+{
+	void __iomem *mmio = hpriv->mmio;
+	u32 ctl = readl(mmio + HOST_CTL);
+
+	return (ctl & HOST_MRSM);
+}
+
 int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_ports,
 			 struct ahci_host_priv *hpriv)
 {
@@ -1111,6 +1119,14 @@ int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_ports,
 		goto intx;
 	if (rc)
 		goto single_msi;
+	if (maxvec == 1)
+		return 1;
+
+	if (ahci_get_mrsm(hpriv)) {
+		pci_disable_msi(pdev);
+		printk(KERN_INFO "ahci: MRSM is on, fallback to single MSI\n");
+		goto single_msi;
+	}
 
 	return maxvec;
 
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
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
