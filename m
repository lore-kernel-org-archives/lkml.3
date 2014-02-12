Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbaBLIgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:36:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50092 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751676AbaBLINv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:51 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Yijing Wang" <wangyijing@huawei.com>,
        "Jiang Liu" <jiang.liu@huawei.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.798732969@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 19/79] PCI: Enable ARI if dev and upstream bridge
 support it; disable otherwise
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

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
[yijing: replace PCIe Cap accessor with legacy PCI accessor]
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pci/pci.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1915,10 +1915,6 @@ void pci_enable_ari(struct pci_dev *dev)
 	if (!pci_is_pcie(dev) || dev->devfn)
 		return;
 
-	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ARI);
-	if (!pos)
-		return;
-
 	bridge = dev->bus->self;
 	if (!bridge || !pci_is_pcie(bridge))
 		return;
@@ -1937,10 +1933,14 @@ void pci_enable_ari(struct pci_dev *dev)
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

