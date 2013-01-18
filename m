Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab3ARLhs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 06:37:48 -0500
Received: from service87.mimecast.com ([91.220.42.44]:42351 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab3ARLhq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 06:37:46 -0500
Date: Fri, 18 Jan 2013 11:37:42 +0000
From: Andrew Murray <Andrew.Murray@arm.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH RFC 1/2] Implementation of pci_fixup_irqs for descendants
 of a specified bus
Message-ID: <20130118113742.GA9006@arm.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 18 Jan 2013 11:37:44.0010 (UTC) FILETIME=[3B16BAA0:01CDF570]
X-MC-Unique: 113011811374409601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Continuing from discussion with Thierry (lkml.org/lkml/2013/1/18/107) perhaps
this will be useful to fold into your patchset. 
---
This patch provides pci_bus_fixup_irqs which performs the same
function as pci_fixup_irqs but only to descendants of the specified
bus.

This can reduce unnecessary fixing up of device irqs when new buses
are added.

Signed-off-by: Andrew Murray <Andrew.Murray@arm.com>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 drivers/pci/setup-irq.c |   15 +++++++++++++++
 include/linux/pci.h     |    3 +++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/setup-irq.c b/drivers/pci/setup-irq.c
index eb219a1..ea91874 100644
--- a/drivers/pci/setup-irq.c
+++ b/drivers/pci/setup-irq.c
@@ -62,3 +62,18 @@ pci_fixup_irqs(u8 (*swizzle)(struct pci_dev *, u8 *),
 	for_each_pci_dev(dev)
 		pdev_fixup_irq(dev, swizzle, map_irq);
 }
+
+void __init
+pci_bus_fixup_irqs(struct pci_bus *bus,
+		u8 (*swizzle)(struct pci_dev *, u8 *),
+		int (*map_irq)(const struct pci_dev *, u8, u8))
+{
+	struct pci_dev *dev;
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		pdev_fixup_irq(dev, swizzle, map_irq);
+
+		if (dev->subordinate)
+			pci_bus_fixup_irqs(dev->subordinate, swizzle, map_irq);
+	}
+}
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5faa831..1b3c2eb 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -953,6 +953,9 @@ void pdev_enable_device(struct pci_dev *);
 int pci_enable_resources(struct pci_dev *, int mask);
 void pci_fixup_irqs(u8 (*)(struct pci_dev *, u8 *),
 		    int (*)(const struct pci_dev *, u8, u8));
+void pci_bus_fixup_irqs(struct pci_bus *bus,
+		u8 (*swizzle)(struct pci_dev *, u8 *),
+		int (*map_irq)(const struct pci_dev *, u8, u8));
 #define HAVE_PCI_REQ_REGIONS	2
 int __must_check pci_request_regions(struct pci_dev *, const char *);
 int __must_check pci_request_regions_exclusive(struct pci_dev *, const char *);
-- 
1.7.0.4


