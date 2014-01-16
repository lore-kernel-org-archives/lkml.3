Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbaAPE1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:27:53 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34777 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaAPE1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:27:49 -0500
Message-ID: <52D75FB1.9090704@oracle.com>
Date: Thu, 16 Jan 2014 12:27:29 +0800
From: ethan zhao <ethan.zhao@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: aaron.f.brown@intel.com, jeffrey.t.kirsher@intel.com
CC: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ethan.kernel@gmail.com
Subject: [PATCH 2/2 Net-next] ixgbe: set driver_max_VFs should be done before
 enabling SRIOV
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit 43dc4e01 Limit number of reported VFs to device specific value
It doesn't work and always returns -EBUSY because VFs ware already enabled.

ixgbe_enable_sriov()
         pci_enable_sriov()
                 sriov_enable()
                 {
                 ... ..
                 iov->ctrl |= PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE;
                 pci_cfg_access_lock(dev);
                 ... ...
                 }

pci_sriov_set_totalvfs()
{
... ...
if (dev->sriov->ctrl & PCI_SRIOV_CTRL_VFE)
                 return -EBUSY;
...
}

So should set driver_max_VFs with pci_sriov_set_totalvfs() before
enable VFs with ixgbe_enable_sriov().

V2: revised for net-next tree.

Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
---
  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c 
b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index bea2cec..6e6af0d 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -7972,8 +7972,8 @@ static int ixgbe_probe(struct pci_dev *pdev, const 
struct pci_device_id *ent)
      /* Mailbox */
      ixgbe_init_mbx_params_pf(hw);
      memcpy(&hw->mbx.ops, ii->mbx_ops, sizeof(hw->mbx.ops));
-    ixgbe_enable_sriov(adapter);
      pci_sriov_set_totalvfs(pdev, IXGBE_MAX_VFS_DRV_LIMIT);
+    ixgbe_enable_sriov(adapter);
  skip_sriov:

  #endif
-- 
1.7.1

