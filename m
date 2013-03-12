Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637Ab3CLV0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 17:26:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932723Ab3CLV0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 17:26:00 -0400
Subject: [PATCH] igb: SR-IOV init reordering
To: gregory.v.rose@intel.com, jeffrey.t.kirsher@intel.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: netdev@vger.kernel.org, ddutile@redhat.com, linux-kernel@vger.kernel.org,
        sassmann@redhat.com
Date: Tue, 12 Mar 2013 15:25:58 -0600
Message-ID: <20130312212533.19552.92159.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

igb is ineffective at setting a lower total VFs because:

int pci_sriov_set_totalvfs(struct pci_dev *dev, u16 numvfs)
{
        ...
        /* Shouldn't change if VFs already enabled */
        if (dev->sriov->ctrl & PCI_SRIOV_CTRL_VFE)
                return -EBUSY;

Swap init ordering.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index d5b8289..ac65c39 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2546,8 +2546,8 @@ static void igb_probe_vfs(struct igb_adapter *adapter)
 	if ((hw->mac.type == e1000_i210) || (hw->mac.type == e1000_i211))
 		return;
 
-	igb_enable_sriov(pdev, max_vfs);
 	pci_sriov_set_totalvfs(pdev, 7);
+	igb_enable_sriov(pdev, max_vfs);
 
 #endif /* CONFIG_PCI_IOV */
 }

