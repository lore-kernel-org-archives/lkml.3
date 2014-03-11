Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbaCKRsQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:48:16 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:40228 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaCKRsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:48:11 -0400
Subject: [PATCH] PCI: Do not enable INTx in pci_reenable_device()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Chris Cheng <chris.cheng@atrustcorp.com>,
        Jamie Chen <jamie.chen@intel.com>,
        Andreas Noever <andreas.noever@gmail.com>
Date: Tue, 11 Mar 2014 11:48:09 -0600
Message-ID: <20140311174809.23257.77363.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140311174555.23257.66798.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140311174555.23257.66798.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
CC: stable@vger.kernel.org
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>
---
 drivers/pci/pci.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 8dc3e701ec57..79fc89c6c3f3 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1192,6 +1192,9 @@ static int do_pci_enable_device(struct pci_dev *dev, int bars)
 		return err;
 	pci_fixup_device(pci_fixup_enable, dev);
 
+	if (dev->msi_enabled || dev->msix_enabled)
+		return 0;
+
 	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 	if (pin) {
 		pci_read_config_word(dev, PCI_COMMAND, &cmd);

