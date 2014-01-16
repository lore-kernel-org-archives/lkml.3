Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaAPGQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 01:16:34 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28368 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaAPGQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 01:16:32 -0500
Message-ID: <52D7792F.8040303@oracle.com>
Date: Thu, 16 Jan 2014 14:16:15 +0800
From: ethan zhao <ethan.zhao@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: aaron.f.brown@intel.com, jeffrey.t.kirsher@intel.com
CC: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ethan.kernel@gmail.com
Subject: [PATCH 1/2 net-next v4] ixgbe: define IXGBE_MAX_VFS_DRV_LIMIT macro
 and cleanup const 63
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Because ixgbe driver limit the max number of VF functions could be enalbed
to 63, so define one macro IXGBE_MAX_VFS_DRV_LIMIT and cleanup the const 63
in code.

v3: revised for net-next tree.
V4: remove one signoff of two.

Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
---
  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c  |    4 ++--
  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c |    4 ++--
  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.h |    5 +++++
  3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c 
b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index cc06854..bea2cec 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -5028,7 +5028,7 @@ static int ixgbe_sw_init(struct ixgbe_adapter 
*adapter)

      /* assign number of SR-IOV VFs */
      if (hw->mac.type != ixgbe_mac_82598EB) {
-        if (max_vfs > 63) {
+        if (max_vfs > IXGBE_MAX_VFS_DRV_LIMIT) {
              adapter->num_vfs = 0;
              e_dev_warn("max_vfs parameter out of range. Not assigning 
any SR-IOV VFs\n");
          } else {
@@ -7973,7 +7973,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const 
struct pci_device_id *ent)
      ixgbe_init_mbx_params_pf(hw);
      memcpy(&hw->mbx.ops, ii->mbx_ops, sizeof(hw->mbx.ops));
      ixgbe_enable_sriov(adapter);
-    pci_sriov_set_totalvfs(pdev, 63);
+    pci_sriov_set_totalvfs(pdev, IXGBE_MAX_VFS_DRV_LIMIT);
  skip_sriov:

  #endif
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c 
b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index 359f6e6..b324260 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -148,7 +148,7 @@ void ixgbe_enable_sriov(struct ixgbe_adapter *adapter)
           * physical function.  If the user requests greater thn
           * 63 VFs then it is an error - reset to default of zero.
           */
-        adapter->num_vfs = min_t(unsigned int, adapter->num_vfs, 63);
+        adapter->num_vfs = min_t(unsigned int, adapter->num_vfs, 
IXGBE_MAX_VFS_DRV_LIMIT);

          err = pci_enable_sriov(adapter->pdev, adapter->num_vfs);
          if (err) {
@@ -257,7 +257,7 @@ static int ixgbe_pci_sriov_enable(struct pci_dev 
*dev, int num_vfs)
       * PF.  The PCI bus driver already checks for other values out of
       * range.
       */
-    if (num_vfs > 63) {
+    if (num_vfs > IXGBE_MAX_VFS_DRV_LIMIT) {
          err = -EPERM;
          goto err_out;
      }
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.h 
b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.h
index 4713f9f..8bd2919 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.h
@@ -28,6 +28,11 @@
  #ifndef _IXGBE_SRIOV_H_
  #define _IXGBE_SRIOV_H_

+/*  ixgbe driver limit the max number of VFs could be enabled to
+ *  63 (IXGBE_MAX_VF_FUNCTIONS - 1)
+ */
+#define IXGBE_MAX_VFS_DRV_LIMIT  (IXGBE_MAX_VF_FUNCTIONS - 1)
+
  void ixgbe_restore_vf_multicasts(struct ixgbe_adapter *adapter);
  void ixgbe_msg_task(struct ixgbe_adapter *adapter);
  int ixgbe_vf_configuration(struct pci_dev *pdev, unsigned int event_mask);
-- 
1.7.1

