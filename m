Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076AbaBRKNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:13:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755371AbaBRKLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:11:22 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH net-next 12/35] e1000e: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Tue, 18 Feb 2014 11:11:41 +0100
Message-Id: <535cdf2dd9a61b8272b6323b72f1dca6a2460ab3.1392717503.git.agordeev@redhat.com>
In-Reply-To: <cover.1392717502.git.agordeev@redhat.com>
References: <cover.1392717502.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Bruce Allan <bruce.w.allan@intel.com>
Cc: e1000-devel@lists.sourceforge.net
Cc: netdev@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/net/ethernet/intel/e1000e/netdev.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 6d91933..e6f8961d 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -2038,13 +2038,16 @@ void e1000e_set_interrupt_capability(struct e1000_adapter *adapter)
 							       msix_entry),
 							GFP_KERNEL);
 			if (adapter->msix_entries) {
+				struct e1000_adapter *a = adapter;
+
 				for (i = 0; i < adapter->num_vectors; i++)
 					adapter->msix_entries[i].entry = i;
 
-				err = pci_enable_msix(adapter->pdev,
-						      adapter->msix_entries,
-						      adapter->num_vectors);
-				if (err == 0)
+				err = pci_enable_msix_range(a->pdev,
+							    a->msix_entries,
+							    a->num_vectors,
+							    a->num_vectors);
+				if (err > 0)
 					return;
 			}
 			/* MSI-X failed, so fall through and try MSI */
-- 
1.7.7.6

