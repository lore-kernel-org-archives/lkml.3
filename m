Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbaI2ObI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:31:08 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50437 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752540AbaI2ObF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:31:05 -0400
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: [PATCH v13 07/12] PCI: Add generic domain handling
Date: Mon, 29 Sep 2014 15:29:26 +0100
Message-Id: <1412000971-9242-8-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1412000971-9242-1-git-send-email-Liviu.Dudau@arm.com>
References: <1412000971-9242-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

The handling of PCI domains (or PCI segments in ACPI speak) is usually a
straightforward affair but its implementation is currently left to the
architectural code, with pci_domain_nr(b) querying the value of the domain
associated with bus b.

This patch introduces CONFIG_PCI_DOMAINS_GENERIC as an option that can be
selected if an architecture wants a simple implementation where the value
of the domain associated with a bus is stored in struct pci_bus.

The architectures that select CONFIG_PCI_DOMAINS_GENERIC will then have to
implement pci_bus_assign_domain_nr() as a way of setting the domain number
associated with a root bus.  All child buses except the root bus will
inherit the domain_nr value from their parent.

Signed-off-by: Catalin Marinas <Catalin.Marinas@arm.com>
[Renamed pci_set_domain_nr() to pci_bus_assign_domain_nr()]
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: Arnd Bergmann <arnd@arndb.de>
---
 drivers/pci/probe.c | 11 ++++++++---
 include/linux/pci.h | 21 +++++++++++++++++++++
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index e3cf8a2..636d1c9 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -485,7 +485,7 @@ void pci_read_bridge_bases(struct pci_bus *child)
 	}
 }
 
-static struct pci_bus *pci_alloc_bus(void)
+static struct pci_bus *pci_alloc_bus(struct pci_bus *parent)
 {
 	struct pci_bus *b;
 
@@ -500,6 +500,10 @@ static struct pci_bus *pci_alloc_bus(void)
 	INIT_LIST_HEAD(&b->resources);
 	b->max_bus_speed = PCI_SPEED_UNKNOWN;
 	b->cur_bus_speed = PCI_SPEED_UNKNOWN;
+#ifdef CONFIG_PCI_DOMAINS_GENERIC
+	if (parent)
+		b->domain_nr = parent->domain_nr;
+#endif
 	return b;
 }
 
@@ -671,7 +675,7 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 	/*
 	 * Allocate a new bus, and inherit stuff from the parent..
 	 */
-	child = pci_alloc_bus();
+	child = pci_alloc_bus(parent);
 	if (!child)
 		return NULL;
 
@@ -1761,13 +1765,14 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	char bus_addr[64];
 	char *fmt;
 
-	b = pci_alloc_bus();
+	b = pci_alloc_bus(NULL);
 	if (!b)
 		return NULL;
 
 	b->sysdata = sysdata;
 	b->ops = ops;
 	b->number = b->busn_res.start = bus;
+	pci_bus_assign_domain_nr(b, parent);
 	b2 = pci_find_bus(pci_domain_nr(b), bus);
 	if (b2) {
 		/* If we already got to this bus through a different bridge, ignore it */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 61978a4..a494e5d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -456,6 +456,9 @@ struct pci_bus {
 	unsigned char	primary;	/* number of primary bridge */
 	unsigned char	max_bus_speed;	/* enum pci_bus_speed */
 	unsigned char	cur_bus_speed;	/* enum pci_bus_speed */
+#ifdef CONFIG_PCI_DOMAINS_GENERIC
+	int		domain_nr;
+#endif
 
 	char		name[48];
 
@@ -1288,6 +1291,24 @@ static inline int pci_domain_nr(struct pci_bus *bus) { return 0; }
 static inline int pci_proc_domain(struct pci_bus *bus) { return 0; }
 #endif /* CONFIG_PCI_DOMAINS */
 
+/*
+ * Generic implementation for PCI domain support. If your
+ * architecture does not need custom management of PCI
+ * domains then this implementation will be used
+ */
+#ifdef CONFIG_PCI_DOMAINS_GENERIC
+static inline int pci_domain_nr(struct pci_bus *bus)
+{
+	return bus->domain_nr;
+}
+void pci_bus_assign_domain_nr(struct pci_bus *bus, struct device *parent);
+#else
+static inline void pci_bus_assign_domain_nr(struct pci_bus *bus,
+					struct device *parent)
+{
+}
+#endif
+
 /* some architectures require additional setup to direct VGA traffic */
 typedef int (*arch_set_vga_state_t)(struct pci_dev *pdev, bool decode,
 		      unsigned int command_bits, u32 flags);
-- 
2.1.1

