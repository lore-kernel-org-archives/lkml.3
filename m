Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617Ab3CVIw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 04:52:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54975 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab3CVIvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 04:51:53 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 1/2] PCI: Introduce new MSI chip infrastructure
Date: Fri, 22 Mar 2013 09:51:46 +0100
Message-Id: <1363942307-9327-2-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363942307-9327-1-git-send-email-thierry.reding@avionic-design.de>
References: <1363942307-9327-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:rkDVKhvXQMYqmmjgB3tL3x/2MJuEJMYYRuo6V00UtSH
 PLzJUbE9CWOffsuOQX68aqYm869xvDKnk3ZL/U3ZjWAIhqCEHL
 L2SvJoP1Urm69jqFz90IDJgVKupKHKw/htJwkZlh3PwZ55Aotr
 7b02gPM3zdSQXB6Zpth0bCwR5/FeMMhO6373cOq3B2aKY8wo/n
 bFicOWQJa7Xgmih2Fp1BIlL/RQdtfYHdl5fMdsHg7+8otBMZe6
 OzBpEt/UTmAg1f2ux9IjP3sQ03PoL1fx6UX4S8UR2sfihlS5/m
 rpyXlffQGk5ItKuVREEXhE4EwcrMPHZxHH0PF2nXlvMFFJ/OZb
 R61IM+BUeIzwYdBk3FbmU1qqdAYmgnNLUAwbLSC9RQRJPTrm4j
 M9jrUiU+ygEPjtUmDLMw7fO6DmSKOx0bLitFcg8mVpi2f0mcV/
 ukecw
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
TODO:
- remove arch_msi_check_device (and other arch-specificities)
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
index 2461033a..6aca43ea 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -416,6 +416,7 @@ struct pci_bus {
 	struct resource busn_res;	/* bus numbers routed to this bus */
 
 	struct pci_ops	*ops;		/* configuration access functions */
+	struct msi_chip	*msi;		/* MSI controller */
 	void		*sysdata;	/* hook for sys-specific extension */
 	struct proc_dir_entry *procdir;	/* directory entry in /proc/bus/pci */
 
-- 
1.8.1.5

