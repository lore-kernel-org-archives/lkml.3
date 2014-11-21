Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751967AbaKUSYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:24:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbaKUSYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:24:11 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 1/4] PCI: Allow device quirks to exclude D3->D0 PM reset
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Date: Fri, 21 Nov 2014 11:24:08 -0700
Message-ID: <20141121182408.26669.23377.stgit@gimli.home>
In-Reply-To: <20141121180322.26669.65689.stgit@gimli.home>
References: <20141121180322.26669.65689.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI PM spec indicates that when No_Soft_Reset is clear
(NoSoftRst-) that the device performs an internal reset when
transitioning From D3hot to D0.  Configuration context is lost and
the device requires a full reinitialization sequence.

Unfortunately the definition of "internal reset", beyond the
application of the configuration context, is largely left to the
interpretation of the specific device.  For some devices, setting
NoSoftRst- appears arbitrary and no obvious "internal reset" occurs
on D3hot to D0 transition.

We still need to honor the PCI specification and restore PCI config
context in the event that we do a PM reset, so we don't cache and
modify the PCI_PM_CTRL_NO_SOFT_RESET bit for the device, but for
interfaces where the intention is to reset the device, like
pci_reset_function(), we need a mechanism to flag that PM reset
doesn't perform any significant "internal reset" of the device.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

 drivers/pci/pci.c   |    2 +-
 include/linux/pci.h |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 625a4ac..ba54a5a 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3206,7 +3206,7 @@ static int pci_pm_reset(struct pci_dev *dev, int probe)
 {
 	u16 csr;
 
-	if (!dev->pm_cap)
+	if (!dev->pm_cap || dev->dev_flags & PCI_DEV_FLAGS_NO_PM_RESET)
 		return -ENOTTY;
 
 	pci_read_config_word(dev, dev->pm_cap + PCI_PM_CTRL, &csr);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5be8db4..aea347d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -175,6 +175,8 @@ enum pci_dev_flags {
 	PCI_DEV_FLAGS_DMA_ALIAS_DEVFN = (__force pci_dev_flags_t) (1 << 4),
 	/* Use a PCIe-to-PCI bridge alias even if !pci_is_pcie */
 	PCI_DEV_FLAG_PCIE_BRIDGE_ALIAS = (__force pci_dev_flags_t) (1 << 5),
+	/* Do not use PM reset even if device advertises NoSoftRst- */
+	PCI_DEV_FLAGS_NO_PM_RESET = (__force pci_dev_flags_t) (1 << 6),
 };
 
 enum pci_irq_reroute_variant {

