Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbaBKTIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:08:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40625 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419AbaBKTIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:08:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 3.4 22/30] PCI: Enable ARI if dev and upstream bridge support it; disable otherwise
Date: Tue, 11 Feb 2014 11:06:22 -0800
Message-Id: <20140211184647.775796791@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184647.149512538@linuxfoundation.org>
References: <20140211184647.149512538@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/pci/pci.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1984,10 +1984,6 @@ void pci_enable_ari(struct pci_dev *dev)
 	if (pcie_ari_disabled || !pci_is_pcie(dev) || dev->devfn)
 		return;
 
-	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ARI);
-	if (!pos)
-		return;
-
 	bridge = dev->bus->self;
 	if (!bridge || !pci_is_pcie(bridge))
 		return;
@@ -2006,10 +2002,14 @@ void pci_enable_ari(struct pci_dev *dev)
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


