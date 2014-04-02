Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111AbaDBITX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 04:19:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757307AbaDBISP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 04:18:15 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-ide@vger.kernel.org
Subject: [PATCH 1/2] ahci: Ensure "MSI Revert to Single Message" mode is not enforced
Date: Wed,  2 Apr 2014 10:19:56 +0200
Message-Id: <fe4097ff2b486092108663532c015a40984bc5f9.1396426390.git.agordeev@redhat.com>
In-Reply-To: <cover.1396426390.git.agordeev@redhat.com>
References: <cover.1396426390.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not rely on successful initialization of multiple MSIs mode
alone and always check if "MSI Revert to Single Message" mode
was enforced by the controller. Fall back to the single MSI
mode in case it did. Not doing so might screw up the interrupt
handling.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-ide@vger.kernel.org
---
 drivers/ata/ahci.c |   17 +++++++++++++++++
 drivers/ata/ahci.h |    1 +
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 5a0bf8e..838d97e 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1163,6 +1163,14 @@ static inline void ahci_gtf_filter_workaround(struct ata_host *host)
 {}
 #endif
 
+static int ahci_is_mrsm(struct ahci_host_priv *hpriv)
+{
+	void __iomem *mmio = hpriv->mmio;
+	u32 ctl = readl(mmio + HOST_CTL);
+
+	return ctl & HOST_MRSM;
+}
+
 static int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_ports,
 			 struct ahci_host_priv *hpriv)
 {
@@ -1189,6 +1197,15 @@ static int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_ports,
 	else if (nvec < 0)
 		goto intx;
 
+	/*
+	 * Fallback to single MSI mode if the controller enforced MRSM mode 
+	 */
+	if (ahci_is_mrsm(hpriv)) {
+		pci_disable_msi(pdev);
+		printk(KERN_INFO "ahci: MRSM is on, fallback to single MSI\n");
+		goto single_msi;
+	}
+
 	return nvec;
 
 single_msi:
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 51af275..b5eb886 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -94,6 +94,7 @@ enum {
 	/* HOST_CTL bits */
 	HOST_RESET		= (1 << 0),  /* reset controller; self-clear */
 	HOST_IRQ_EN		= (1 << 1),  /* global IRQ enable */
+	HOST_MRSM		= (1 << 2),  /* MSI Revert to Single Message */
 	HOST_AHCI_EN		= (1 << 31), /* AHCI enabled */
 
 	/* HOST_CAP bits */
-- 
1.7.7.6

