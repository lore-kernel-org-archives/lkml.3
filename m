Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbaEFWtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 18:49:13 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:36284 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409AbaEFWsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 18:48:24 -0400
Subject: [PATCH v2 3/5] sh/PCI: Pass GAPSPCI_DMA_BASE CPU address to
 dma_declare_coherent_memory()
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-doc@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>, Randy Dunlap <rdunlap@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>, linux-pci@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>
Date: Tue, 06 May 2014 16:48:33 -0600
Message-ID: <20140506224833.17968.87108.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140506223250.17968.27054.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140506223250.17968.27054.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_declare_coherent_memory() needs both the CPU physical address and the
bus address of the device memory.  They are likely the same on this
platform, but in general we should use pcibios_bus_to_resource() to account
for any address translation done by the PCI host bridge.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: Magnus Damm <damm@opensource.se>
CC: linux-sh@vger.kernel.org
---
 arch/sh/drivers/pci/fixups-dreamcast.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/sh/drivers/pci/fixups-dreamcast.c b/arch/sh/drivers/pci/fixups-dreamcast.c
index d6cde700e316..987c788f5a4f 100644
--- a/arch/sh/drivers/pci/fixups-dreamcast.c
+++ b/arch/sh/drivers/pci/fixups-dreamcast.c
@@ -31,6 +31,8 @@
 static void gapspci_fixup_resources(struct pci_dev *dev)
 {
 	struct pci_channel *p = dev->sysdata;
+	struct pci_bus_region region;
+	struct resource res;
 
 	printk(KERN_NOTICE "PCI: Fixing up device %s\n", pci_name(dev));
 
@@ -51,8 +53,12 @@ static void gapspci_fixup_resources(struct pci_dev *dev)
 		/*
 		 * Redirect dma memory allocations to special memory window.
 		 */
+		region.start = GAPSPCI_DMA_BASE;
+		region.end = GAPSPCI_DMA_BASE + GAPSPCI_DMA_SIZE - 1;
+		res.flags = IORESOURCE_MEM;
+		pcibios_bus_to_resource(dev->bus, &res, &region);
 		BUG_ON(!dma_declare_coherent_memory(&dev->dev,
-						GAPSPCI_DMA_BASE,
+						res->start,
 						GAPSPCI_DMA_BASE,
 						GAPSPCI_DMA_SIZE,
 						DMA_MEMORY_MAP |

