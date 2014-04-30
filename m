Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbaD3A7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 20:59:53 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:43508 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbaD3A7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 20:59:47 -0400
Subject: [PATCH 1/7] PCI: Fail safely if we can't handle BARs larger than 4GB
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 29 Apr 2014 18:59:45 -0600
Message-ID: <20140430005944.13138.29465.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140430005642.13138.99577.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140430005642.13138.99577.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can only handle BARs larger than 4GB if both dma_addr_t and
resource_size_t are 64 bits wide.  If dma_addr_t is 32 bits, we can't
represent all the bus addresses, and if resource_size_t is 32 bits, we
can't represent all the CPU addresses.

Previously we cleared res->flags (at "fail:") for resources that were too
large.  That means we think the BAR doesn't exist at all, which in turn
means that we could enable the device even though we can't keep track of
where the BAR is and we can't make sure it doesn't overlap something else.

This preserves the type flags (MEM/IO) so we can keep from enabling the
device.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/probe.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index ef09f5f2fe6c..c7f8b717c2e7 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -171,6 +171,7 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 			struct resource *res, unsigned int pos)
 {
 	u32 l, sz, mask;
+	u64 l64, sz64, mask64;
 	u16 orig_cmd;
 	struct pci_bus_region region, inverted_region;
 	bool bar_too_big = false, bar_disabled = false;
@@ -226,9 +227,9 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 	}
 
 	if (res->flags & IORESOURCE_MEM_64) {
-		u64 l64 = l;
-		u64 sz64 = sz;
-		u64 mask64 = mask | (u64)~0 << 32;
+		l64 = l;
+		sz64 = sz;
+		mask64 = mask | (u64)~0 << 32;
 
 		pci_read_config_dword(dev, pos + 4, &l);
 		pci_write_config_dword(dev, pos + 4, ~0);
@@ -243,9 +244,13 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 		if (!sz64)
 			goto fail;
 
-		if ((sizeof(resource_size_t) < 8) && (sz64 > 0x100000000ULL)) {
+		if ((sizeof(dma_addr_t) < 8 || sizeof(resource_size_t) < 8) &&
+		    sz64 > 0x100000000ULL) {
+			res->flags |= IORESOURCE_UNSET | IORESOURCE_DISABLED;
+			res->start = 0;
+			res->end = 0;
 			bar_too_big = true;
-			goto fail;
+			goto out;
 		}
 
 		if ((sizeof(resource_size_t) < 8) && l) {
@@ -303,7 +308,8 @@ out:
 		pci_write_config_word(dev, PCI_COMMAND, orig_cmd);
 
 	if (bar_too_big)
-		dev_err(&dev->dev, "reg 0x%x: can't handle 64-bit BAR\n", pos);
+		dev_err(&dev->dev, "reg 0x%x: can't handle BAR larger than 4GB (size %#010llx)\n",
+			pos, (unsigned long long) sz64);
 	if (res->flags && !bar_disabled)
 		dev_printk(KERN_DEBUG, &dev->dev, "reg 0x%x: %pR\n", pos, res);
 

