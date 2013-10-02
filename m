Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab3JBRCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 13:02:14 -0400
Received: from 221-186-24-89.in-addr.arpa ([89.24.186.221]:25464 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753274Ab3JBRCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 13:02:11 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, Andy King <acking@vmware.com>,
        Jon Mason <jon.mason@intel.com>,
        Matt Porter <mporter@kernel.crashing.org>, linux-pci@vger.kernel.org,
        linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        linux390@de.ibm.com, linux-s390@vger.kernel.org, x86@kernel.org,
        linux-ide@vger.kernel.org, iss_storagedev@hp.com,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-driver@qlogic.com,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        "VMware, Inc." <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org
Subject: [PATCH RFC 68/77] sfc: Update MSI/MSI-X interrupts enablement code
Date: Wed,  2 Oct 2013 12:49:24 +0200
Message-Id: <d1d4c1c82e340283193c6a56e2e21c691956e605.1380703263.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1380703262.git.agordeev@redhat.com>
References: <cover.1380703262.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of recent re-design of the MSI/MSI-X interrupts enabling
pattern this driver has to be updated to use the new technique to
obtain a optimal number of MSI/MSI-X interrupts required.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/net/ethernet/sfc/efx.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 07c9bc4..184ef9f 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1261,21 +1261,24 @@ static int efx_probe_interrupts(struct efx_nic *efx)
 		n_channels += extra_channels;
 		n_channels = min(n_channels, efx->max_channels);
 
-		for (i = 0; i < n_channels; i++)
-			xentries[i].entry = i;
-		rc = pci_enable_msix(efx->pci_dev, xentries, n_channels);
-		if (rc > 0) {
+		rc = pci_msix_table_size(efx->pci_dev);
+		if (rc < 0)
+			goto msi;
+
+		if (rc < n_channels) {
 			netif_err(efx, drv, efx->net_dev,
 				  "WARNING: Insufficient MSI-X vectors"
 				  " available (%d < %u).\n", rc, n_channels);
 			netif_err(efx, drv, efx->net_dev,
 				  "WARNING: Performance may be reduced.\n");
-			EFX_BUG_ON_PARANOID(rc >= n_channels);
 			n_channels = rc;
-			rc = pci_enable_msix(efx->pci_dev, xentries,
-					     n_channels);
 		}
 
+		EFX_BUG_ON_PARANOID(n_channels > ARRAY_SIZE(xentries));
+		for (i = 0; i < n_channels; i++)
+			xentries[i].entry = i;
+
+		rc = pci_enable_msix(efx->pci_dev, xentries, n_channels);
 		if (rc == 0) {
 			efx->n_channels = n_channels;
 			if (n_channels > extra_channels)
@@ -1293,6 +1296,7 @@ static int efx_probe_interrupts(struct efx_nic *efx)
 				efx_get_channel(efx, i)->irq =
 					xentries[i].vector;
 		} else {
+msi:
 			/* Fall back to single channel MSI */
 			efx->interrupt_mode = EFX_INT_MODE_MSI;
 			netif_err(efx, drv, efx->net_dev,
-- 
1.7.7.6

