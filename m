Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197AbaCRQMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 12:12:36 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:52222 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaCRQMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 12:12:05 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
        bruce.w.allan@intel.com, carolyn.wyborny@intel.com,
        donald.c.skidmore@intel.com, gregory.v.rose@intel.com,
        alexander.h.duyck@intel.com, john.ronciak@intel.com,
        mitch.a.williams@intel.com, linux.nics@intel.com,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 2/2] INTEL-IGB: Convert iounmap to pci_iounmap
Date: Tue, 18 Mar 2014 17:11:25 +0100
Message-Id: <1395159085-11691-2-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1395159085-11691-1-git-send-email-peter.senna@gmail.com>
References: <1395159085-11691-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pci_iounmap instead of iounmap when the virtual mapping was done
with pci_iomap. A simplified version of the semantic patch that finds this
issue is as follows: (http://coccinelle.lip6.fr/)
    
// <smpl>
@r@
expression addr;
@@
addr = pci_iomap(...)

@rr@
expression r.addr;
@@
* iounmap(addr)
// </smpl>

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 Tested by compilation only.

 drivers/net/ethernet/intel/igb/igb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 340a344..fc49177 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2623,7 +2623,7 @@ err_eeprom:
 		iounmap(hw->flash_address);
 err_sw_init:
 	igb_clear_interrupt_scheme(adapter);
-	iounmap(hw->hw_addr);
+	pci_iounmap(pdev, hw->hw_addr);
 err_ioremap:
 	free_netdev(netdev);
 err_alloc_etherdev:
@@ -2790,7 +2790,7 @@ static void igb_remove(struct pci_dev *pdev)
 	igb_disable_sriov(pdev);
 #endif
 
-	iounmap(hw->hw_addr);
+	pci_iounmap(pdev, hw->hw_addr);
 	if (hw->flash_address)
 		iounmap(hw->flash_address);
 	pci_release_selected_regions(pdev,
-- 
1.8.3.1

