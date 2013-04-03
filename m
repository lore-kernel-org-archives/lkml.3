Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762381Ab3DCOtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:49:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55069 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761594Ab3DCOp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:45:59 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v3 04/12] PCI: Introduce new MSI chip infrastructure
Date: Wed,  3 Apr 2013 16:45:10 +0200
Message-Id: <1365000318-28256-5-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de>
References: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:UANQsPNbqmgzaekUG2cRAm/03AW/cP5jJ2tVcy+yldg
 WdauCYoqR/psDvLg0ul9HEGz+vcxKNIMF63veVWLONBLhzOz1o
 LqX4HMUF6KmgarYlU6EttWWWzVGpNTa8udgTVGQnS8r7FYvp+z
 bCln8AtM0VVcQyCYeCZyw6BC08xgfu4FkYHTppWwHMtmQY0zM8
 /hJCVTXZ+qy60WivFxh8MapBNYKTED8O9Zva8vYD4t8cljFkiI
 5cIAxTmNpb4w/GwhJ1OHfVf2kcyPPzJ5o+SCsihRZhBWIfzhK1
 v4vqkGY7/ZG9EivDY4JgI3lq68hTBTwxsmNL6e/5sN9k+o2uLq
 JTIOn7MWezZJikvTLUsppBbK6jqnSk98oOCBJW3kPbFlsCs87c
 mrfTZjSlunGCWWuP8B+Ez0VRDKFDj19RJLiHcU4vCPInSS08+b
 P+WWH
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new struct msi_chip is used to associated an MSI controller with a
PCI bus. It is automatically handed down from the root to its children
during bus enumeration.

This patch provides default (weak) implementations for the architecture-
specific MSI functions (arch_setup_msi_irq(), arch_teardown_msi_irq()
and arch_msi_check_device()) which check if a PCI device's bus has an
attached MSI chip and forward the call appropriately.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/pci/msi.c   | 35 +++++++++++++++++++++++++++++++----
 drivers/pci/probe.c |  1 +
 include/linux/msi.h | 10 ++++++++++
 include/linux/pci.h |  1 +
 4 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 00cc78c..fce3549 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -26,14 +26,41 @@
 
 static int pci_msi_enable = 1;
 
-/* Arch hooks */
+int __weak arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *desc)
+{
+	struct msi_chip *chip = dev->bus->msi;
+
+	if (chip && chip->setup_irq) {
+		int err;
+
+		err = chip->setup_irq(chip, dev, desc);
+		if (err < 0)
+			return err;
+
+		irq_set_chip_data(desc->irq, chip);
+		return err;
+	}
+
+	return -EINVAL;
+}
 
-#ifndef arch_msi_check_device
-int arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
+void __weak arch_teardown_msi_irq(unsigned int irq)
 {
+	struct msi_chip *chip = irq_get_chip_data(irq);
+
+	if (chip && chip->teardown_irq)
+		chip->teardown_irq(chip, irq);
+}
+
+int __weak arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
+{
+	struct msi_chip *chip = dev->bus->msi;
+
+	if (chip && chip->check_device)
+		return chip->check_device(chip, dev, nvec, type);
+
 	return 0;
 }
-#endif
 
 #ifndef arch_setup_msi_irqs
 # define arch_setup_msi_irqs default_setup_msi_irqs
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index b494066..9307550 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -634,6 +634,7 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 
 	child->parent = parent;
 	child->ops = parent->ops;
+	child->msi = parent->msi;
 	child->sysdata = parent->sysdata;
 	child->bus_flags = parent->bus_flags;
 
diff --git a/include/linux/msi.h b/include/linux/msi.h
index ce93a34..ea4a5be 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -58,5 +58,15 @@ extern int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
 extern void arch_teardown_msi_irqs(struct pci_dev *dev);
 extern int arch_msi_check_device(struct pci_dev* dev, int nvec, int type);
 
+struct msi_chip {
+	struct module *owner;
+	struct device *dev;
+
+	int (*setup_irq)(struct msi_chip *chip, struct pci_dev *dev,
+			 struct msi_desc *desc);
+	void (*teardown_irq)(struct msi_chip *chip, unsigned int irq);
+	int (*check_device)(struct msi_chip *chip, struct pci_dev *dev,
+			    int nvec, int type);
+};
 
 #endif /* LINUX_MSI_H */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index f42cdc6..7e44085 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -431,6 +431,7 @@ struct pci_bus {
 	struct resource busn_res;	/* bus numbers routed to this bus */
 
 	struct pci_ops	*ops;		/* configuration access functions */
+	struct msi_chip	*msi;		/* MSI controller */
 	void		*sysdata;	/* hook for sys-specific extension */
 	struct proc_dir_entry *procdir;	/* directory entry in /proc/bus/pci */
 
-- 
1.8.2

