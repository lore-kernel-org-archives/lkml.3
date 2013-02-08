Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760426Ab3BHT3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:29:05 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:33354 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760341Ab3BHT3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:29:00 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 25/26] PCI: Disable mem in the ioapic removing path
Date: Fri,  8 Feb 2013 11:28:22 -0800
Message-Id: <1360351703-20571-26-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For physical hot plug should be ok, but for remove/rescan path will
need us to disable that.

otherwise rescan mmio resource for pci ioapic device will not be
sized and allocated, aka skiped.
For ioapic_probe:pci_enable_device will not enable the device
correctly, and will bail out early.

So we can just disable mmio for all removing case, and that will not hurt
real hotplug path.

Signed-off-by: <yinghai@kernel.org>
---
 drivers/pci/ioapic.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
index 3c6bbdd..8dacfd0 100644
--- a/drivers/pci/ioapic.c
+++ b/drivers/pci/ioapic.c
@@ -88,6 +88,17 @@ exit_free:
 	return -ENODEV;
 }
 
+static void pci_disable_device_mem(struct pci_dev *dev)
+{
+	u16 pci_command;
+
+	pci_read_config_word(dev, PCI_COMMAND, &pci_command);
+	if (pci_command & PCI_COMMAND_MEMORY) {
+		pci_command &= ~PCI_COMMAND_MEMORY;
+		pci_write_config_word(dev, PCI_COMMAND, pci_command);
+	}
+}
+
 static void ioapic_remove(struct pci_dev *dev)
 {
 	struct ioapic *ioapic = pci_get_drvdata(dev);
@@ -95,6 +106,8 @@ static void ioapic_remove(struct pci_dev *dev)
 	acpi_unregister_ioapic(ioapic->handle, ioapic->gsi_base);
 	pci_release_region(dev, 0);
 	pci_disable_device(dev);
+	/* need to disable it, otherwise remove/rescan will not work */
+	pci_disable_device_mem(dev);
 	kfree(ioapic);
 }
 
-- 
1.7.10.4

