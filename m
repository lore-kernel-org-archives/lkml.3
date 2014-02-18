Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbaBRKLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:11:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702AbaBRKLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:11:19 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH net-next 13/35] i40e: Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Tue, 18 Feb 2014 11:11:42 +0100
Message-Id: <3655fd750c2f1c00c2474900539a305d50fdeb6f.1392717503.git.agordeev@redhat.com>
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
Cc: e1000-devel@lists.sourceforge.net
Cc: netdev@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |   33 +++++----------------------
 1 files changed, 6 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 628e917..3116861 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -5856,37 +5856,16 @@ err_out:
  **/
 static int i40e_reserve_msix_vectors(struct i40e_pf *pf, int vectors)
 {
-	int err = 0;
-
-	pf->num_msix_entries = 0;
-	while (vectors >= I40E_MIN_MSIX) {
-		err = pci_enable_msix(pf->pdev, pf->msix_entries, vectors);
-		if (err == 0) {
-			/* good to go */
-			pf->num_msix_entries = vectors;
-			break;
-		} else if (err < 0) {
-			/* total failure */
-			dev_info(&pf->pdev->dev,
-				 "MSI-X vector reservation failed: %d\n", err);
-			vectors = 0;
-			break;
-		} else {
-			/* err > 0 is the hint for retry */
-			dev_info(&pf->pdev->dev,
-				 "MSI-X vectors wanted %d, retrying with %d\n",
-				 vectors, err);
-			vectors = err;
-		}
-	}
-
-	if (vectors > 0 && vectors < I40E_MIN_MSIX) {
+	vectors = pci_enable_msix_range(pf->pdev, pf->msix_entries,
+					I40E_MIN_MSIX, vectors);
+	if (vectors < 0) {
 		dev_info(&pf->pdev->dev,
-			 "Couldn't get enough vectors, only %d available\n",
-			 vectors);
+			 "MSI-X vector reservation failed: %d\n", vectors);
 		vectors = 0;
 	}
 
+	pf->num_msix_entries = vectors;
+
 	return vectors;
 }
 
-- 
1.7.7.6

