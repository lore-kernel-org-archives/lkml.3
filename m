Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbaDQNNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 09:13:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756333AbaDQNMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 09:12:09 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, linux-ide@vger.kernel.org
Subject: [PATCH v2 1/2] ahci: Ensure "MSI Revert to Single Message" mode is not enforced
Date: Thu, 17 Apr 2014 14:13:49 +0200
Message-Id: <478405194e01e8b7f98942b8673af3b1a157aadf.1397736364.git.agordeev@redhat.com>
In-Reply-To: <cover.1397736364.git.agordeev@redhat.com>
References: <cover.1397736364.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AHCI specification allows hardware to choose to revert to
single MSI mode when fewer messages are allocated than requested.
Yet, at least ICH10 chipset reverts to single MSI mode even when
enough messages are allocated in some cases (see below).

This update forces the driver do not rely on initialization of
multiple MSIs mode alone and always check if "MSI Revert to
Single Message" (MRSM) mode was enforced by the controller and
fallback to the single MSI mode in case it did.

That prevents a situation when the driver configured multiple
per-port IRQ handlers, but the controller sends all port's
interrupts to a single IRQ, which could easily screw up the
interrupt handling and lead to delays and possibly crashes.

The fix was tested on a 6-port controller that successfully
reverted to the single MSI mode:

00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA
AHCI Controller (prog-if 01 [AHCI 1.0])
	Subsystem: Super Micro Computer Inc Device 10a7
	Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 101
	I/O ports at f110 [size=8]
	I/O ports at f100 [size=4]
	I/O ports at f0f0 [size=8]
	I/O ports at f0e0 [size=4]
	I/O ports at f020 [size=32]
	Memory at fbf00000 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] MSI: Enable+ Count=1/16 Maskable- 64bit-
	Capabilities: [70] Power Management version 3
	Capabilities: [a8] SATA HBA v1.0
	Capabilities: [b0] PCI Advanced Features
	Kernel driver in use: ahci

With 6 ports just 8 MSI vectors should be enough, but the adapter
enforces the MRSM mode when less than 16 vectors are written to
the Multiple Messages Enable PCI register. I instigated MRSM mode
with the patch below:

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 1e493e6..14799f2 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1171,7 +1171,7 @@ static int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_ports,
 	if (hpriv->flags & AHCI_HFLAG_NO_MSI)
 		goto intx;

-	nvec = pci_msi_vec_count(pdev);
+	nvec = 8;
 	if (nvec < 0)
 		goto intx;

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-ide@vger.kernel.org
---
 drivers/ata/ahci.c |   11 ++++++++++-
 drivers/ata/ahci.h |    1 +
 2 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 5a0bf8e..649ac1c 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1164,7 +1164,7 @@ static inline void ahci_gtf_filter_workaround(struct ata_host *host)
 #endif
 
 static int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_ports,
-			 struct ahci_host_priv *hpriv)
+				struct ahci_host_priv *hpriv)
 {
 	int nvec;
 
@@ -1189,6 +1189,15 @@ static int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_ports,
 	else if (nvec < 0)
 		goto intx;
 
+	/*
+	 * Fallback to single MSI mode if the controller enforced MRSM mode
+	 */
+	if (readl(hpriv->mmio + HOST_CTL) & HOST_MRSM) {
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

