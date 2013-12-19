Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab3LSSIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:08:51 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:42309 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab3LSSIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:08:50 -0500
From: Betty Dall <betty.dall@hp.com>
To: jcliburn@gmail.com, chris.snook@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Betty Dall <betty.dall@hp.com>
Subject: [PATCH] Check return from pci_find_ext_capability() in atl1c_reset_pcie()
Date: Thu, 19 Dec 2013 10:59:09 -0700
Message-Id: <1387475949-30452-1-git-send-email-betty.dall@hp.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function atl1c_reset_pcie() does not check the return from
pci_find_ext_cabability() where it is getting the postion of the
PCI_EXT_CAP_ID_ERR. It is possible for the return to be 0.

Signed-off-by: Betty Dall <betty.dall@hp.com>
---

 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)


diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index a36a760..2980175 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -145,9 +145,11 @@ static void atl1c_reset_pcie(struct atl1c_hw *hw, u32 flag)
 	 * Mask some pcie error bits
 	 */
 	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ERR);
-	pci_read_config_dword(pdev, pos + PCI_ERR_UNCOR_SEVER, &data);
-	data &= ~(PCI_ERR_UNC_DLP | PCI_ERR_UNC_FCP);
-	pci_write_config_dword(pdev, pos + PCI_ERR_UNCOR_SEVER, data);
+	if (pos) {
+		pci_read_config_dword(pdev, pos + PCI_ERR_UNCOR_SEVER, &data);
+		data &= ~(PCI_ERR_UNC_DLP | PCI_ERR_UNC_FCP);
+		pci_write_config_dword(pdev, pos + PCI_ERR_UNCOR_SEVER, data);
+	}
 	/* clear error status */
 	pcie_capability_write_word(pdev, PCI_EXP_DEVSTA,
 			PCI_EXP_DEVSTA_NFED |
