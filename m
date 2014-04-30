Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120AbaD3BAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 21:00:25 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:61911 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421AbaD3BAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 21:00:07 -0400
Subject: [PATCH 4/7] PCI: Don't set BAR to zero if dma_addr_t is too small
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 29 Apr 2014 19:00:05 -0600
Message-ID: <20140430010005.13138.18200.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140430005642.13138.99577.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140430005642.13138.99577.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a BAR is above 4GB and our dma_addr_t is too small, don't clear the BAR
to zero: that doesn't disable the BAR, and it makes it more likely that the
BAR will conflict with things if we turn on the memory enable bit (as we
will at "out:" if the BIOS left it enabled).

We should also print the BAR info and its original size so we can see what
happens when we try to assign space to it.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/probe.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 82cd75f6118a..dd710b12d34c 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -174,7 +174,7 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 	u64 l64, sz64, mask64;
 	u16 orig_cmd;
 	struct pci_bus_region region, inverted_region;
-	bool bar_too_big = false, bar_disabled = false;
+	bool bar_too_big = false, bar_too_high = false;
 
 	mask = type ? PCI_ROM_ADDRESS_MASK : ~0;
 
@@ -254,13 +254,11 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		}
 
 		if ((sizeof(dma_addr_t) < 8) && l) {
-			/* Address above 32-bit boundary; disable the BAR */
-			pci_write_config_dword(dev, pos, 0);
-			pci_write_config_dword(dev, pos + 4, 0);
+			/* Above 32-bit boundary; try to reallocate */
 			res->flags |= IORESOURCE_UNSET;
 			res->start = 0;
 			res->end = sz64;
-			bar_disabled = true;
+			bar_too_high = true;
 			goto out;
 		} else {
 			region.start = l64;
@@ -311,7 +309,10 @@ out:
 	if (bar_too_big)
 		dev_err(&dev->dev, "reg 0x%x: can't handle BAR larger than 4GB (size %#010llx)\n",
 			pos, (unsigned long long) sz64);
-	if (res->flags && !bar_disabled)
+	if (bar_too_high)
+		dev_info(&dev->dev, "reg 0x%x: can't handle BAR above 4G (bus address %#010llx)\n",
+			 pos, (unsigned long long) l64);
+	if (res->flags)
 		dev_printk(KERN_DEBUG, &dev->dev, "reg 0x%x: %pR\n", pos, res);
 
 	return (res->flags & IORESOURCE_MEM_64) ? 1 : 0;

