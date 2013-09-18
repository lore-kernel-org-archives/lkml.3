Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab3IRN02 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 09:26:28 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:36890 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab3IRN0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 09:26:24 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 04/10] irqdomain: Return errors from irq_create_of_mapping()
Date: Wed, 18 Sep 2013 15:24:46 +0200
Message-Id: <1379510692-32435-5-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1379510692-32435-1-git-send-email-treding@nvidia.com>
References: <1379510692-32435-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of returning 0 for all errors, allow the precise error code to
be propagated. This will be used in subsequent patches to allow further
propagation of error codes.

The interrupt number corresponding to the new mapping is returned in an
output parameter so that the return value is reserved to signal success
(== 0) or failure (< 0).

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- convert existing callers instead of using compatible wrapper

 arch/arm/mach-integrator/pci_v3.c              |  8 ++++++--
 arch/microblaze/pci/pci-common.c               |  6 ++++--
 arch/mips/pci/fixup-lantiq.c                   | 12 +++++++----
 arch/mips/pci/pci-rt3883.c                     |  9 +++++----
 arch/powerpc/kernel/pci-common.c               |  7 +++++--
 arch/powerpc/platforms/cell/celleb_scc_sio.c   |  8 +++++---
 arch/powerpc/platforms/cell/spu_manage.c       |  6 +++---
 arch/powerpc/platforms/fsl_uli1575.c           |  7 +++----
 arch/powerpc/platforms/pseries/event_sources.c | 12 ++++++-----
 arch/x86/kernel/devicetree.c                   | 11 +++++-----
 drivers/pci/host/pci-mvebu.c                   |  9 +++++++--
 include/linux/of_irq.h                         |  6 +++---
 kernel/irq/irqdomain.c                         | 28 ++++++++++++++++----------
 13 files changed, 78 insertions(+), 51 deletions(-)

diff --git a/arch/arm/mach-integrator/pci_v3.c b/arch/arm/mach-integrator/pci_v3.c
index bef1005..aa0f867 100644
--- a/arch/arm/mach-integrator/pci_v3.c
+++ b/arch/arm/mach-integrator/pci_v3.c
@@ -847,8 +847,12 @@ static int __init pci_v3_map_irq_dt(const struct pci_dev *dev, u8 slot, u8 pin)
 		return 0;
 	}
 
-	return irq_create_of_mapping(oirq.controller, oirq.specifier,
-				     oirq.size);
+	ret = irq_create_of_mapping(oirq.controller, oirq.specifier,
+				    oirq.size, &virq);
+	if (ret)
+		return 0;
+
+	return virq;
 }
 
 static int __init pci_v3_dtprobe(struct platform_device *pdev,
diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index 1b93bf0..80b6e0f 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -246,8 +246,10 @@ int pci_read_irq_line(struct pci_dev *pci_dev)
 			 oirq.size, oirq.specifier[0], oirq.specifier[1],
 			 of_node_full_name(oirq.controller));
 
-		virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
-					     oirq.size);
+		ret = irq_create_of_mapping(oirq.controller, oirq.specifier,
+					    oirq.size, &virq);
+		if (ret)
+			virq = 0;
 	}
 	if (!virq) {
 		pr_debug(" Failed to map !\n");
diff --git a/arch/mips/pci/fixup-lantiq.c b/arch/mips/pci/fixup-lantiq.c
index 6c829df..dfe7bf1 100644
--- a/arch/mips/pci/fixup-lantiq.c
+++ b/arch/mips/pci/fixup-lantiq.c
@@ -26,15 +26,19 @@ int pcibios_plat_dev_init(struct pci_dev *dev)
 int __init pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	struct of_irq dev_irq;
-	int irq;
+	unsigned int irq;
+	int err;
 
 	if (of_irq_map_pci(dev, &dev_irq)) {
 		dev_err(&dev->dev, "trying to map irq for unknown slot:%d pin:%d\n",
 			slot, pin);
 		return 0;
 	}
-	irq = irq_create_of_mapping(dev_irq.controller, dev_irq.specifier,
-					dev_irq.size);
-	dev_info(&dev->dev, "SLOT:%d PIN:%d IRQ:%d\n", slot, pin, irq);
+	err = irq_create_of_mapping(dev_irq.controller, dev_irq.specifier,
+				    dev_irq.size, &irq);
+	if (err)
+		return 0;
+
+	dev_info(&dev->dev, "SLOT:%d PIN:%d IRQ:%u\n", slot, pin, irq);
 	return irq;
 }
diff --git a/arch/mips/pci/pci-rt3883.c b/arch/mips/pci/pci-rt3883.c
index 95c9d41..79b49b5 100644
--- a/arch/mips/pci/pci-rt3883.c
+++ b/arch/mips/pci/pci-rt3883.c
@@ -584,8 +584,8 @@ err_put_intc_node:
 int __init pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	struct of_irq dev_irq;
+	unsigned int irq = 0;
 	int err;
-	int irq;
 
 	err = of_irq_map_pci(dev, &dev_irq);
 	if (err) {
@@ -594,11 +594,12 @@ int __init pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 		return 0;
 	}
 
-	irq = irq_create_of_mapping(dev_irq.controller,
+	err = irq_create_of_mapping(dev_irq.controller,
 				    dev_irq.specifier,
-				    dev_irq.size);
+				    dev_irq.size,
+				    &irq);
 
-	if (irq == 0)
+	if (err)
 		pr_crit("pci %s: no irq found for pin %u\n",
 			pci_name((struct pci_dev *) dev), pin);
 	else
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 905a24b..ae71b14 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -230,6 +230,7 @@ static int pci_read_irq_line(struct pci_dev *pci_dev)
 {
 	struct of_irq oirq;
 	unsigned int virq;
+	int ret;
 
 	pr_debug("PCI: Try to map irq for %s...\n", pci_name(pci_dev));
 
@@ -266,8 +267,10 @@ static int pci_read_irq_line(struct pci_dev *pci_dev)
 			 oirq.size, oirq.specifier[0], oirq.specifier[1],
 			 of_node_full_name(oirq.controller));
 
-		virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
-					     oirq.size);
+		ret = irq_create_of_mapping(oirq.controller, oirq.specifier,
+					    oirq.size, &virq);
+		if (ret)
+			virq = NO_IRQ;
 	}
 	if(virq == NO_IRQ) {
 		pr_debug(" Failed to map !\n");
diff --git a/arch/powerpc/platforms/cell/celleb_scc_sio.c b/arch/powerpc/platforms/cell/celleb_scc_sio.c
index 9c339ec..94b771e 100644
--- a/arch/powerpc/platforms/cell/celleb_scc_sio.c
+++ b/arch/powerpc/platforms/cell/celleb_scc_sio.c
@@ -43,7 +43,7 @@ static int __init txx9_serial_init(void)
 {
 	extern int early_serial_txx9_setup(struct uart_port *port);
 	struct device_node *node;
-	int i;
+	int i, err;
 	struct uart_port req;
 	struct of_irq irq;
 	struct resource res;
@@ -66,8 +66,10 @@ static int __init txx9_serial_init(void)
 #ifdef CONFIG_SERIAL_TXX9_CONSOLE
 			req.membase = ioremap(req.mapbase, 0x24);
 #endif
-			req.irq = irq_create_of_mapping(irq.controller,
-				irq.specifier, irq.size);
+			err = irq_create_of_mapping(irq.controller,
+				irq.specifier, irq.size, &req.irq);
+			if (err)
+				req.irq = 0;
 			req.flags |= UPF_IOREMAP | UPF_BUGGY_UART
 				/*HAVE_CTS_LINE*/;
 			req.uartclk = 83300000;
diff --git a/arch/powerpc/platforms/cell/spu_manage.c b/arch/powerpc/platforms/cell/spu_manage.c
index 2bb6977..b78c7a4 100644
--- a/arch/powerpc/platforms/cell/spu_manage.c
+++ b/arch/powerpc/platforms/cell/spu_manage.c
@@ -190,9 +190,9 @@ static int __init spu_map_interrupts(struct spu *spu, struct device_node *np)
 		ret = -EINVAL;
 		pr_debug("  irq %d no 0x%x on %s\n", i, oirq.specifier[0],
 			 oirq.controller->full_name);
-		spu->irqs[i] = irq_create_of_mapping(oirq.controller,
-					oirq.specifier, oirq.size);
-		if (spu->irqs[i] == NO_IRQ) {
+		ret = irq_create_of_mapping(oirq.controller, oirq.specifier,
+					    oirq.size, &spu->irqs[i]);
+		if (ret) {
 			pr_debug("spu_new: failed to map it !\n");
 			goto err;
 		}
diff --git a/arch/powerpc/platforms/fsl_uli1575.c b/arch/powerpc/platforms/fsl_uli1575.c
index 92ac9b5..575b215 100644
--- a/arch/powerpc/platforms/fsl_uli1575.c
+++ b/arch/powerpc/platforms/fsl_uli1575.c
@@ -322,7 +322,7 @@ static void hpcd_final_uli5288(struct pci_dev *dev)
 	struct pci_controller *hose = pci_bus_to_host(dev->bus);
 	struct device_node *hosenode = hose ? hose->dn : NULL;
 	struct of_irq oirq;
-	int virq, pin = 2;
+	int pin = 2;
 	u32 laddr[3];
 
 	if (!machine_is(mpc86xx_hpcd))
@@ -334,9 +334,8 @@ static void hpcd_final_uli5288(struct pci_dev *dev)
 	laddr[0] = (hose->first_busno << 16) | (PCI_DEVFN(31, 0) << 8);
 	laddr[1] = laddr[2] = 0;
 	of_irq_map_raw(hosenode, &pin, 1, laddr, &oirq);
-	virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
-				     oirq.size);
-	dev->irq = virq;
+	irq_create_of_mapping(oirq.controller, oirq.specifier, oirq.size,
+			      &dev->irq);
 }
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AL, 0x1575, hpcd_quirk_uli1575);
diff --git a/arch/powerpc/platforms/pseries/event_sources.c b/arch/powerpc/platforms/pseries/event_sources.c
index 2605c31..4367fdd 100644
--- a/arch/powerpc/platforms/pseries/event_sources.c
+++ b/arch/powerpc/platforms/pseries/event_sources.c
@@ -24,7 +24,7 @@ void request_event_sources_irqs(struct device_node *np,
 				irq_handler_t handler,
 				const char *name)
 {
-	int i, index, count = 0;
+	int i, index, err, count = 0;
 	struct of_irq oirq;
 	const u32 *opicprop;
 	unsigned int opicplen;
@@ -59,10 +59,12 @@ void request_event_sources_irqs(struct device_node *np,
 		     index++) {
 			if (count > 15)
 				break;
-			virqs[count] = irq_create_of_mapping(oirq.controller,
-							    oirq.specifier,
-							    oirq.size);
-			if (virqs[count] == NO_IRQ) {
+
+			err = irq_create_of_mapping(oirq.controller,
+						    oirq.specifier,
+						    oirq.size,
+						    &virqs[count]);
+			if (err) {
 				pr_err("event-sources: Unable to allocate "
 				       "interrupt number for %s\n",
 				       np->full_name);
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 376dc78..7adede6 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -106,7 +106,6 @@ struct device_node *pcibios_get_phb_of_node(struct pci_bus *bus)
 static int x86_of_pci_irq_enable(struct pci_dev *dev)
 {
 	struct of_irq oirq;
-	u32 virq;
 	int ret;
 	u8 pin;
 
@@ -120,11 +119,11 @@ static int x86_of_pci_irq_enable(struct pci_dev *dev)
 	if (ret)
 		return ret;
 
-	virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
-			oirq.size);
-	if (virq == 0)
-		return -EINVAL;
-	dev->irq = virq;
+	ret = irq_create_of_mapping(oirq.controller, oirq.specifier, oirq.size,
+				    &dev->irq);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index 77f8a7c..7773a17 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -656,14 +656,19 @@ static int mvebu_pcie_setup(int nr, struct pci_sys_data *sys)
 static int mvebu_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
 	struct of_irq oirq;
+	unsigned int virq;
 	int ret;
 
 	ret = of_irq_map_pci(dev, &oirq);
 	if (ret)
 		return ret;
 
-	return irq_create_of_mapping(oirq.controller, oirq.specifier,
-				     oirq.size);
+	ret = irq_create_of_mapping(oirq.controller, oirq.specifier, oirq.size,
+				    &virq);
+	if (ret)
+		return 0;
+
+	return virq;
 }
 
 static struct pci_bus *mvebu_pcie_scan_bus(int nr, struct pci_sys_data *sys)
diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index 535cecf..138266d 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -63,9 +63,9 @@ extern int of_irq_map_raw(struct device_node *parent, const __be32 *intspec,
 			  struct of_irq *out_irq);
 extern int of_irq_map_one(struct device_node *device, int index,
 			  struct of_irq *out_irq);
-extern unsigned int irq_create_of_mapping(struct device_node *controller,
-					  const u32 *intspec,
-					  unsigned int intsize);
+extern int irq_create_of_mapping(struct device_node *controller,
+				 const u32 *intspec, unsigned int intsize,
+				 unsigned int *virqp);
 extern int of_irq_to_resource(struct device_node *dev, int index,
 			      struct resource *r);
 extern int of_irq_count(struct device_node *dev);
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index d2a3b01..5f8401c 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -484,40 +484,46 @@ int irq_create_strict_mappings(struct irq_domain *domain, unsigned int irq_base,
 }
 EXPORT_SYMBOL_GPL(irq_create_strict_mappings);
 
-unsigned int irq_create_of_mapping(struct device_node *controller,
-				   const u32 *intspec, unsigned int intsize)
+int irq_create_of_mapping(struct device_node *controller, const u32 *intspec,
+			  unsigned int intsize, unsigned int *virqp)
 {
+	unsigned int type = IRQ_TYPE_NONE;
 	struct irq_domain *domain;
 	irq_hw_number_t hwirq;
-	unsigned int type = IRQ_TYPE_NONE;
 	unsigned int virq;
+	int ret;
 
 	domain = controller ? irq_find_host(controller) : irq_default_domain;
 	if (!domain) {
 		pr_warn("no irq domain found for %s !\n",
 			of_node_full_name(controller));
-		return 0;
+		return -EPROBE_DEFER;
 	}
 
 	/* If domain has no translation, then we assume interrupt line */
 	if (domain->ops->xlate == NULL)
 		hwirq = intspec[0];
 	else {
-		if (domain->ops->xlate(domain, controller, intspec, intsize,
-				     &hwirq, &type))
-			return 0;
+		ret = domain->ops->xlate(domain, controller, intspec, intsize,
+					 &hwirq, &type);
+		if (ret)
+			return ret;
 	}
 
 	/* Create mapping */
-	virq = irq_create_mapping(domain, hwirq);
-	if (!virq)
-		return virq;
+	ret = __irq_create_mapping(domain, hwirq, &virq);
+	if (ret)
+		return ret;
 
 	/* Set type if specified and different than the current one */
 	if (type != IRQ_TYPE_NONE &&
 	    type != irq_get_trigger_type(virq))
 		irq_set_irq_type(virq, type);
-	return virq;
+
+	if (virqp)
+		*virqp = virq;
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(irq_create_of_mapping);
 
-- 
1.8.4

