Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbaDUEgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 00:36:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbaDUEet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 00:34:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [PATCH 3.13 08/32] PCI: Enable INTx in pci_reenable_device() only when MSI/MSI-X not enabled
Date: Sun, 20 Apr 2014 19:13:25 -0700
Message-Id: <20140421021135.009538358@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140421021133.865086647@linuxfoundation.org>
References: <20140421021133.865086647@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit 866d54177b4e671cd52bed1fb487d140d7b691f5 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pci.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1134,6 +1134,9 @@ static int do_pci_enable_device(struct p
 	if (dev->msi_enabled || dev->msix_enabled)
 		return 0;
 
+	if (dev->msi_enabled || dev->msix_enabled)
+		return 0;
+
 	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 	if (pin) {
 		pci_read_config_word(dev, PCI_COMMAND, &cmd);


