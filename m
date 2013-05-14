Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab3ENC3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 22:29:32 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:19624 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993Ab3ENC33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 22:29:29 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org
Subject: [PATCH 7/7] PCI: use pf as dma_dev for vf that does not have func0 sibling
Date: Mon, 13 May 2013 19:28:26 -0700
Message-Id: <1368498506-25857-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368498506-25857-1-git-send-email-yinghai@kernel.org>
References: <1368498506-25857-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix crash:
[  122.181002] pci 0000:c4:00.4: [10df:e228] type 00 class 0x020000
[  122.188541] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[  122.197324] IP: [<ffffffff81f58f78>] intel_iommu_add_device+0x108/0x1e0
[  122.204753] PGD 0 
[  122.207019] Oops: 0000 [#1] SMP 
[  122.210655] Modules linked in:
[  122.214084] CPU: 49 PID: 1 Comm: swapper/0 Tainted: G          I  3.9.0-yh-09240-g8a69c01-dirty #1571
...
[  122.365363] Call Trace:
[  122.368112]  [<ffffffff81f4ee2e>] iommu_bus_notifier+0x3e/0xd0
[  122.374645]  [<ffffffff820b702e>] notifier_call_chain+0x6e/0xb0
[  122.381277]  [<ffffffff810b912e>] __blocking_notifier_call_chain+0x5e/0x90
[  122.388963]  [<ffffffff810b9176>] blocking_notifier_call_chain+0x16/0x20
[  122.396471]  [<ffffffff81762fc5>] device_add+0x475/0x6f0

pv is c3:00.0, and vf is from c4:00.4 and there is no c4:00.0,
as we have
     Initial VFs: 64, Total VFs: 64, Number of VFs: 63, Function Dependency Link: 00
     VF offset: 260, stride: 1

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: iommu@lists.linux-foundation.org

---
 drivers/iommu/intel-iommu.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/iommu/intel-iommu.c
===================================================================
--- linux-2.6.orig/drivers/iommu/intel-iommu.c
+++ linux-2.6/drivers/iommu/intel-iommu.c
@@ -4185,11 +4185,15 @@ static int intel_iommu_add_device(struct
 	 * required ACS flags, add to the same group as function 0.
 	 */
 	if (dma_pdev->multifunction &&
-	    !pci_acs_enabled(dma_pdev, REQ_ACS_FLAGS))
-		swap_pci_ref(&dma_pdev,
-			     pci_get_slot(dma_pdev->bus,
+	    !pci_acs_enabled(dma_pdev, REQ_ACS_FLAGS)) {
+		struct pci_dev *dev_tmp = pci_get_slot(dma_pdev->bus,
 					  PCI_DEVFN(PCI_SLOT(dma_pdev->devfn),
-					  0)));
+					  0));
+
+		if (!dev_tmp && dma_pdev->is_virtfn)
+			dev_tmp = pci_dev_get(dma_pdev->physfn);
+		swap_pci_ref(&dma_pdev, dev_tmp);
+	}
 
 	/*
 	 * Devices on the root bus go through the iommu.  If that's not us,
