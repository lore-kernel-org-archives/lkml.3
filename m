Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934178AbaEKTxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:53:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932964AbaEKTW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:22:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>,
        linux-ide@vger.kernel.org
Subject: [PATCH 3.14 36/83] ahci: Ensure "MSI Revert to Single Message" mode is not enforced
Date: Sun, 11 May 2014 21:19:37 +0200
Message-Id: <20140511191911.954666115@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Gordeev <agordeev@redhat.com>

commit ab0f9e78b97f5193dd38b3757b42b6fbded05fb7 upstream.

The AHCI specification allows hardware to choose to revert to
single MSI mode when fewer messages are allocated than requested.
Yet, at least ICH10 chipset reverts to single MSI mode even when
enough messages are allocated in some cases (see below).

This update forces the driver to not rely on initialization of
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
by forcing @nvec to 8 in ahci_init_interrupts().

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-ide@vger.kernel.org
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci.c |    9 ++++++++-
 drivers/ata/ahci.h |    1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1163,7 +1163,7 @@ static inline void ahci_gtf_filter_worka
 #endif
 
 static int ahci_init_interrupts(struct pci_dev *pdev, unsigned int n_ports,
-			 struct ahci_host_priv *hpriv)
+				struct ahci_host_priv *hpriv)
 {
 	int rc, nvec;
 
@@ -1189,6 +1189,13 @@ static int ahci_init_interrupts(struct p
 	else if (rc > 0)
 		goto single_msi;
 
+	/* fallback to single MSI mode if the controller enforced MRSM mode */
+	if (readl(hpriv->mmio + HOST_CTL) & HOST_MRSM) {
+		pci_disable_msi(pdev);
+		printk(KERN_INFO "ahci: MRSM is on, fallback to single MSI\n");
+		goto single_msi;
+	}
+
 	return nvec;
 
 single_msi:
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -91,6 +91,7 @@ enum {
 	/* HOST_CTL bits */
 	HOST_RESET		= (1 << 0),  /* reset controller; self-clear */
 	HOST_IRQ_EN		= (1 << 1),  /* global IRQ enable */
+	HOST_MRSM		= (1 << 2),  /* MSI Revert to Single Message */
 	HOST_AHCI_EN		= (1 << 31), /* AHCI enabled */
 
 	/* HOST_CAP bits */


