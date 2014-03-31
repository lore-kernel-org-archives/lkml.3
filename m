Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbaCaNY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:24:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35729 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbaCaNYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:24:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 44/71] PCI: Enable INTx in pci_reenable_device() only when MSI/MSI-X not enabled
Date: Mon, 31 Mar 2014 14:22:50 +0100
Message-Id: <1396272197-13394-45-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit 3cdeb713dc66057b50682048c151eae07b186c42 upstream.

Andreas reported that after 1f42db786b14 ("PCI: Enable INTx if BIOS left
them disabled"), pciehp surprise removal stopped working.

This happens because pci_reenable_device() on the hotplug bridge (used in
the pciehp_configure_device() path) clears the Interrupt Disable bit, which
apparently breaks the bridge's MSI hotplug event reporting.

Previously we cleared the Interrupt Disable bit in do_pci_enable_device(),
which is used by both pci_enable_device() and pci_reenable_device().  But
we use pci_reenable_device() after the driver may have enabled MSI or
MSI-X, and we *set* Interrupt Disable as part of enabling MSI/MSI-X.

This patch clears Interrupt Disable only when MSI/MSI-X has not been
enabled.

Fixes: 1f42db786b14 PCI: Enable INTx if BIOS left them disabled
Link: https://bugzilla.kernel.org/show_bug.cgi?id=71691
Reported-and-tested-by: Andreas Noever <andreas.noever@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pci/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 42b9983..bf0df20 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1145,6 +1145,9 @@ static int do_pci_enable_device(struct pci_dev *dev, int bars)
 		return err;
 	pci_fixup_device(pci_fixup_enable, dev);
 
+	if (dev->msi_enabled || dev->msix_enabled)
+		return 0;
+
 	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 	if (pin) {
 		pci_read_config_word(dev, PCI_COMMAND, &cmd);
-- 
1.9.1

