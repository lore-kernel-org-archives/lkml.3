Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbaBZTiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:38:04 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:65013 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbaBZTh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:37:59 -0500
Subject: [PATCH 8/9] PCI: Ignore BAR contents when firmware left decoding
 disabled
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 26 Feb 2014 12:37:57 -0700
Message-ID: <20140226193757.10125.81865.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't rely on BAR contents when the command register says the BAR is
disabled.

If we receive a PCI device from firmware (or a hot-added device that was
just powered up) with the MEMORY or IO enable bits in the PCI command
register cleared, there's no reason to believe the BARs contain valid
addresses.

In that case, we still know the type and size of the BAR, but this
patch marks the resource as "unset" so we have a chance to reassign it.

Historically, we often used "BAR == 0" to decide the BAR is invalid.  But 0
is a legal BAR value, especially if the host bridge translates addresses,
so I think it's better to decide based on the PCI command register, and
store the conclusion in the IORESOURCE_UNSET bit.

Reference: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=679545
Reference: https://bugzilla.kernel.org/show_bug.cgi?id=48451
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/probe.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 6e34498ec9f0..02654b5ec1b9 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -177,9 +177,10 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 
 	mask = type ? PCI_ROM_ADDRESS_MASK : ~0;
 
+	pci_read_config_word(dev, PCI_COMMAND, &orig_cmd);
+
 	/* No printks while decoding is disabled! */
 	if (!dev->mmio_always_on) {
-		pci_read_config_word(dev, PCI_COMMAND, &orig_cmd);
 		if (orig_cmd & PCI_COMMAND_DECODE_ENABLE) {
 			pci_write_config_word(dev, PCI_COMMAND,
 				orig_cmd & ~PCI_COMMAND_DECODE_ENABLE);
@@ -215,9 +216,13 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		if (res->flags & IORESOURCE_IO) {
 			l &= PCI_BASE_ADDRESS_IO_MASK;
 			mask = PCI_BASE_ADDRESS_IO_MASK & (u32) IO_SPACE_LIMIT;
+			if (!(orig_cmd & PCI_COMMAND_IO))
+				res->flags |= IORESOURCE_UNSET;
 		} else {
 			l &= PCI_BASE_ADDRESS_MEM_MASK;
 			mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
+			if (!(orig_cmd & PCI_COMMAND_MEMORY))
+				res->flags |= IORESOURCE_UNSET;
 		}
 	} else {
 		res->flags |= (l & IORESOURCE_ROM_ENABLE);
@@ -252,6 +257,7 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 			/* Address above 32-bit boundary; disable the BAR */
 			pci_write_config_dword(dev, pos, 0);
 			pci_write_config_dword(dev, pos + 4, 0);
+			res->flags |= IORESOURCE_UNSET;
 			region.start = 0;
 			region.end = sz64;
 			bar_disabled = true;

