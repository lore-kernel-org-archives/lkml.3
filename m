Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbaD3BAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 21:00:20 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:47125 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791AbaD3BAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 21:00:15 -0400
Subject: [PATCH 5/7] PCI: Don't print anything while decoding is disabled
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 29 Apr 2014 19:00:12 -0600
Message-ID: <20140430010012.13138.47492.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140430005642.13138.99577.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140430005642.13138.99577.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the console is a PCI device, and we try to print to it while its
decoding is disabled, the system will hang.  This particular printk hasn't
caused a problem yet, but it could, so this fixes it.

See also 0ff9514b579b ("PCI: Don't print anything while decoding is
disabled").

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/probe.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index dd710b12d34c..3bc149b848a8 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -174,7 +174,7 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 	u64 l64, sz64, mask64;
 	u16 orig_cmd;
 	struct pci_bus_region region, inverted_region;
-	bool bar_too_big = false, bar_too_high = false;
+	bool bar_too_big = false, bar_too_high = false, bar_invalid = false;
 
 	mask = type ? PCI_ROM_ADDRESS_MASK : ~0;
 
@@ -289,11 +289,10 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 	 * be claimed by the device.
 	 */
 	if (inverted_region.start != region.start) {
-		dev_info(&dev->dev, "reg 0x%x: initial BAR value %pa invalid; forcing reassignment\n",
-			 pos, &region.start);
 		res->flags |= IORESOURCE_UNSET;
-		res->end -= res->start;
 		res->start = 0;
+		res->end = region.end - region.start;
+		bar_invalid = true;
 	}
 
 	goto out;
@@ -312,6 +311,9 @@ out:
 	if (bar_too_high)
 		dev_info(&dev->dev, "reg 0x%x: can't handle BAR above 4G (bus address %#010llx)\n",
 			 pos, (unsigned long long) l64);
+	if (bar_invalid)
+		dev_info(&dev->dev, "reg 0x%x: initial BAR value %#010llx invalid\n",
+			 pos, (unsigned long long) region.start);
 	if (res->flags)
 		dev_printk(KERN_DEBUG, &dev->dev, "reg 0x%x: %pR\n", pos, res);
 

