Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267AbaBUN1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:27:25 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47567 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771AbaBUNBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:01:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 01/60] PCI: Enable ARI if dev and upstream bridge support it; disable otherwise
Date: Fri, 21 Feb 2014 13:00:28 +0000
Message-Id: <1392987687-15367-2-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
References: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.31 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yijing Wang <wangyijing@huawei.com>

commit b0cc6020e1cc62f1253215f189611b34be4a83c7 upstream.

Currently, we enable ARI in a device's upstream bridge if the bridge and
the device support it.  But we never disable ARI, even if the device is
removed and replaced with a device that doesn't support ARI.

This means that if we hot-remove an ARI device and replace it with a
non-ARI multi-function device, we find only function 0 of the new device
because the upstream bridge still has ARI enabled, and next_ari_fn()
only returns function 0 for the new non-ARI device.

This patch disables ARI in the upstream bridge if the device doesn't
support ARI.  See the PCIe spec, r3.0, sec 6.13.

[bhelgaas: changelog, function comment]
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
[ luis: backported to 3.5: used Yijing Wang's backport to 3.4 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pci/pci.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index fa7c0f0..caeddd4 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1974,6 +1974,9 @@ void pci_free_cap_save_buffers(struct pci_dev *dev)
 /**
  * pci_enable_ari - enable ARI forwarding if hardware support it
  * @dev: the PCI device
+ *
+ * If @dev and its upstream bridge both support ARI, enable ARI in the
+ * bridge.  Otherwise, disable ARI in the bridge.
  */
 void pci_enable_ari(struct pci_dev *dev)
 {
@@ -1985,10 +1988,6 @@ void pci_enable_ari(struct pci_dev *dev)
 	if (pcie_ari_disabled || !pci_is_pcie(dev) || dev->devfn)
 		return;
 
-	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ARI);
-	if (!pos)
-		return;
-
 	bridge = dev->bus->self;
 	if (!bridge || !pci_is_pcie(bridge))
 		return;
@@ -2007,10 +2006,14 @@ void pci_enable_ari(struct pci_dev *dev)
 		return;
 
 	pci_read_config_word(bridge, pos + PCI_EXP_DEVCTL2, &ctrl);
-	ctrl |= PCI_EXP_DEVCTL2_ARI;
+	if (pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ARI)) {
+		ctrl |= PCI_EXP_DEVCTL2_ARI;
+		bridge->ari_enabled = 1;
+	} else {
+		ctrl &= ~PCI_EXP_DEVCTL2_ARI;
+		bridge->ari_enabled = 0;
+	}
 	pci_write_config_word(bridge, pos + PCI_EXP_DEVCTL2, ctrl);
-
-	bridge->ari_enabled = 1;
 }
 
 /**
-- 
1.9.0

