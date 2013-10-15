Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934068Ab3JOUmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:42:05 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33863 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933944Ab3JOUji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:39:38 -0400
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [RFC 2/9] of/irq: Replace of_irq with of_phandle_args
Date: Tue, 15 Oct 2013 21:39:16 +0100
Message-Id: <1381869563-16083-3-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct of_irq and struct of_phandle_args are exactly the same structure.
This patch makes the kernel use of_phandle_args everywhere. This in
itself isn't a big deal, but it makes some follow-on patches simpler.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/arm/mach-integrator/pci_v3.c              |  5 ++---
 arch/microblaze/pci/pci-common.c               |  9 ++++-----
 arch/mips/pci/fixup-lantiq.c                   |  5 ++---
 arch/mips/pci/pci-rt3883.c                     |  6 ++----
 arch/powerpc/kernel/pci-common.c               |  9 ++++-----
 arch/powerpc/platforms/cell/celleb_scc_pciex.c |  5 ++---
 arch/powerpc/platforms/cell/celleb_scc_sio.c   |  5 ++---
 arch/powerpc/platforms/cell/spider-pic.c       |  6 +++---
 arch/powerpc/platforms/cell/spu_manage.c       | 12 ++++++------
 arch/powerpc/platforms/fsl_uli1575.c           |  8 +++-----
 arch/powerpc/platforms/powermac/pic.c          |  8 ++++----
 arch/powerpc/platforms/pseries/event_sources.c |  7 +++----
 arch/powerpc/sysdev/mpic_msi.c                 |  6 +++---
 arch/x86/kernel/devicetree.c                   |  5 ++---
 drivers/of/irq.c                               | 15 +++++++--------
 drivers/of/of_pci_irq.c                        |  2 +-
 drivers/pci/host/pci-mvebu.c                   |  5 ++---
 include/linux/of_irq.h                         | 24 ++++--------------------
 include/linux/of_pci.h                         |  4 ++--
 19 files changed, 58 insertions(+), 88 deletions(-)

diff --git a/arch/arm/mach-integrator/pci_v3.c b/arch/arm/mach-integrator/pci_v3.c
index 0f496cc..2d6b4da 100644
--- a/arch/arm/mach-integrator/pci_v3.c
+++ b/arch/arm/mach-integrator/pci_v3.c
@@ -837,7 +837,7 @@ static struct hw_pci pci_v3 __initdata = {
 
 static int __init pci_v3_map_irq_dt(const struct pci_dev *dev, u8 slot, u8 pin)
 {
-	struct of_irq oirq;
+	struct of_phandle_args oirq;
 	int ret;
 
 	ret = of_irq_parse_pci(dev, &oirq);
@@ -847,8 +847,7 @@ static int __init pci_v3_map_irq_dt(const struct pci_dev *dev, u8 slot, u8 pin)
 		return 0;
 	}
 
-	return irq_create_of_mapping(oirq.controller, oirq.specifier,
-				     oirq.size);
+	return irq_create_of_mapping(oirq.np, oirq.args, oirq.args_count);
 }
 
 static int __init pci_v3_dtprobe(struct platform_device *pdev,
diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index 4d5b1a9..c9302c4 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -199,7 +199,7 @@ void pcibios_set_master(struct pci_dev *dev)
  */
 int pci_read_irq_line(struct pci_dev *pci_dev)
 {
-	struct of_irq oirq;
+	struct of_phandle_args oirq;
 	unsigned int virq;
 
 	/* The current device-tree that iSeries generates from the HV
@@ -243,11 +243,10 @@ int pci_read_irq_line(struct pci_dev *pci_dev)
 			irq_set_irq_type(virq, IRQ_TYPE_LEVEL_LOW);
 	} else {
 		pr_debug(" Got one, spec %d cells (0x%08x 0x%08x...) on %s\n",
-			 oirq.size, oirq.specifier[0], oirq.specifier[1],
-			 of_node_full_name(oirq.controller));
+			 oirq.args_count, oirq.args[0], oirq.args[1],
+			 of_node_full_name(oirq.np));
 
-		virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
-					     oirq.size);
+		virq = irq_create_of_mapping(oirq.np, oirq.args, oirq.args_count);
 	}
 	if (!virq) {
 		pr_debug(" Failed to map !\n");
diff --git a/arch/mips/pci/fixup-lantiq.c b/arch/mips/pci/fixup-lantiq.c
index 2e8dbfe..81ff0b5 100644
--- a/arch/mips/pci/fixup-lantiq.c
+++ b/arch/mips/pci/fixup-lantiq.c
@@ -25,7 +25,7 @@ int pcibios_plat_dev_init(struct pci_dev *dev)
 
 int __init pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
-	struct of_irq dev_irq;
+	struct of_phandle_args dev_irq;
 	int irq;
 
 	if (of_irq_parse_pci(dev, &dev_irq)) {
@@ -33,8 +33,7 @@ int __init pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 			slot, pin);
 		return 0;
 	}
-	irq = irq_create_of_mapping(dev_irq.controller, dev_irq.specifier,
-					dev_irq.size);
+	irq = irq_create_of_mapping(dev_irq.np, dev_irq.args, dev_irq.args_count);
 	dev_info(&dev->dev, "SLOT:%d PIN:%d IRQ:%d\n", slot, pin, irq);
 	return irq;
 }
diff --git a/arch/mips/pci/pci-rt3883.c b/arch/mips/pci/pci-rt3883.c
index cae92a0..0f08a5b 100644
--- a/arch/mips/pci/pci-rt3883.c
+++ b/arch/mips/pci/pci-rt3883.c
@@ -583,7 +583,7 @@ err_put_intc_node:
 
 int __init pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
-	struct of_irq dev_irq;
+	struct of_phandle_args dev_irq;
 	int err;
 	int irq;
 
@@ -594,9 +594,7 @@ int __init pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 		return 0;
 	}
 
-	irq = irq_create_of_mapping(dev_irq.controller,
-				    dev_irq.specifier,
-				    dev_irq.size);
+	irq = irq_create_of_mapping(dev_irq.np, dev_irq.args, dev_irq.args_count);
 
 	if (irq == 0)
 		pr_crit("pci %s: no irq found for pin %u\n",
diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
index 2f41854..96c4623 100644
--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -228,7 +228,7 @@ int pcibios_add_platform_entries(struct pci_dev *pdev)
  */
 static int pci_read_irq_line(struct pci_dev *pci_dev)
 {
-	struct of_irq oirq;
+	struct of_phandle_args oirq;
 	unsigned int virq;
 
 	pr_debug("PCI: Try to map irq for %s...\n", pci_name(pci_dev));
@@ -263,11 +263,10 @@ static int pci_read_irq_line(struct pci_dev *pci_dev)
 			irq_set_irq_type(virq, IRQ_TYPE_LEVEL_LOW);
 	} else {
 		pr_debug(" Got one, spec %d cells (0x%08x 0x%08x...) on %s\n",
-			 oirq.size, oirq.specifier[0], oirq.specifier[1],
-			 of_node_full_name(oirq.controller));
+			 oirq.args_count, oirq.args[0], oirq.args[1],
+			 of_node_full_name(oirq.np));
 
-		virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
-					     oirq.size);
+		virq = irq_create_of_mapping(oirq.np, oirq.args, oirq.args_count);
 	}
 	if(virq == NO_IRQ) {
 		pr_debug(" Failed to map !\n");
diff --git a/arch/powerpc/platforms/cell/celleb_scc_pciex.c b/arch/powerpc/platforms/cell/celleb_scc_pciex.c
index 40bc371..e8d34d1 100644
--- a/arch/powerpc/platforms/cell/celleb_scc_pciex.c
+++ b/arch/powerpc/platforms/cell/celleb_scc_pciex.c
@@ -486,7 +486,7 @@ static __init int celleb_setup_pciex(struct device_node *node,
 				     struct pci_controller *phb)
 {
 	struct resource	r;
-	struct of_irq oirq;
+	struct of_phandle_args oirq;
 	int virq;
 
 	/* SMMIO registers; used inside this file */
@@ -511,8 +511,7 @@ static __init int celleb_setup_pciex(struct device_node *node,
 		pr_err("PCIEXC:Failed to map irq\n");
 		goto error;
 	}
-	virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
-				     oirq.size);
+	virq = irq_create_of_mapping(oirq.np, oirq.args, oirq.args_count);
 	if (request_irq(virq, pciex_handle_internal_irq,
 			0, "pciex", (void *)phb)) {
 		pr_err("PCIEXC:Failed to request irq\n");
diff --git a/arch/powerpc/platforms/cell/celleb_scc_sio.c b/arch/powerpc/platforms/cell/celleb_scc_sio.c
index 96388b2..06046d5 100644
--- a/arch/powerpc/platforms/cell/celleb_scc_sio.c
+++ b/arch/powerpc/platforms/cell/celleb_scc_sio.c
@@ -45,7 +45,7 @@ static int __init txx9_serial_init(void)
 	struct device_node *node;
 	int i;
 	struct uart_port req;
-	struct of_irq irq;
+	struct of_phandle_args irq;
 	struct resource res;
 
 	for_each_compatible_node(node, "serial", "toshiba,sio-scc") {
@@ -66,8 +66,7 @@ static int __init txx9_serial_init(void)
 #ifdef CONFIG_SERIAL_TXX9_CONSOLE
 			req.membase = ioremap(req.mapbase, 0x24);
 #endif
-			req.irq = irq_create_of_mapping(irq.controller,
-				irq.specifier, irq.size);
+			req.irq = irq_create_of_mapping(irq.np, irq.args, irq.args_count);
 			req.flags |= UPF_IOREMAP | UPF_BUGGY_UART
 				/*HAVE_CTS_LINE*/;
 			req.uartclk = 83300000;
diff --git a/arch/powerpc/platforms/cell/spider-pic.c b/arch/powerpc/platforms/cell/spider-pic.c
index b491f40..6e842fd 100644
--- a/arch/powerpc/platforms/cell/spider-pic.c
+++ b/arch/powerpc/platforms/cell/spider-pic.c
@@ -235,10 +235,10 @@ static unsigned int __init spider_find_cascade_and_node(struct spider_pic *pic)
 	/* First, we check whether we have a real "interrupts" in the device
 	 * tree in case the device-tree is ever fixed
 	 */
-	struct of_irq oirq;
+	struct of_phandle_args oirq;
 	if (of_irq_parse_one(pic->host->of_node, 0, &oirq) == 0) {
-		virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
-					     oirq.size);
+		virq = irq_create_of_mapping(oirq.np, oirq.args,
+					     oirq.args_count);
 		return virq;
 	}
 
diff --git a/arch/powerpc/platforms/cell/spu_manage.c b/arch/powerpc/platforms/cell/spu_manage.c
index e6cdb81..e9eb4f8 100644
--- a/arch/powerpc/platforms/cell/spu_manage.c
+++ b/arch/powerpc/platforms/cell/spu_manage.c
@@ -177,7 +177,7 @@ out:
 
 static int __init spu_map_interrupts(struct spu *spu, struct device_node *np)
 {
-	struct of_irq oirq;
+	struct of_phandle_args oirq;
 	int ret;
 	int i;
 
@@ -188,10 +188,10 @@ static int __init spu_map_interrupts(struct spu *spu, struct device_node *np)
 			goto err;
 		}
 		ret = -EINVAL;
-		pr_debug("  irq %d no 0x%x on %s\n", i, oirq.specifier[0],
-			 oirq.controller->full_name);
-		spu->irqs[i] = irq_create_of_mapping(oirq.controller,
-					oirq.specifier, oirq.size);
+		pr_debug("  irq %d no 0x%x on %s\n", i, oirq.args[0],
+			 oirq.np->full_name);
+		spu->irqs[i] = irq_create_of_mapping(oirq.np,
+					oirq.args, oirq.args_count);
 		if (spu->irqs[i] == NO_IRQ) {
 			pr_debug("spu_new: failed to map it !\n");
 			goto err;
@@ -200,7 +200,7 @@ static int __init spu_map_interrupts(struct spu *spu, struct device_node *np)
 	return 0;
 
 err:
-	pr_debug("failed to map irq %x for spu %s\n", *oirq.specifier,
+	pr_debug("failed to map irq %x for spu %s\n", *oirq.args,
 		spu->name);
 	for (; i >= 0; i--) {
 		if (spu->irqs[i] != NO_IRQ)
diff --git a/arch/powerpc/platforms/fsl_uli1575.c b/arch/powerpc/platforms/fsl_uli1575.c
index ac539c1..288226d 100644
--- a/arch/powerpc/platforms/fsl_uli1575.c
+++ b/arch/powerpc/platforms/fsl_uli1575.c
@@ -321,8 +321,8 @@ static void hpcd_final_uli5288(struct pci_dev *dev)
 {
 	struct pci_controller *hose = pci_bus_to_host(dev->bus);
 	struct device_node *hosenode = hose ? hose->dn : NULL;
-	struct of_irq oirq;
-	int virq, pin = 2;
+	struct of_phandle_args oirq;
+	int pin = 2;
 	u32 laddr[3];
 
 	if (!machine_is(mpc86xx_hpcd))
@@ -334,9 +334,7 @@ static void hpcd_final_uli5288(struct pci_dev *dev)
 	laddr[0] = (hose->first_busno << 16) | (PCI_DEVFN(31, 0) << 8);
 	laddr[1] = laddr[2] = 0;
 	of_irq_parse_raw(hosenode, &pin, 1, laddr, &oirq);
-	virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
-				     oirq.size);
-	dev->irq = virq;
+	dev->irq = irq_create_of_mapping(oirq.np, oirq.args, oirq.args_count);
 }
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_AL, 0x1575, hpcd_quirk_uli1575);
diff --git a/arch/powerpc/platforms/powermac/pic.c b/arch/powerpc/platforms/powermac/pic.c
index 720663e..4c24bf6 100644
--- a/arch/powerpc/platforms/powermac/pic.c
+++ b/arch/powerpc/platforms/powermac/pic.c
@@ -394,7 +394,7 @@ static void __init pmac_pic_probe_oldstyle(void)
 }
 
 int of_irq_parse_oldworld(struct device_node *device, int index,
-			struct of_irq *out_irq)
+			struct of_phandle_args *out_irq)
 {
 	const u32 *ints = NULL;
 	int intlen;
@@ -422,9 +422,9 @@ int of_irq_parse_oldworld(struct device_node *device, int index,
 	if (index >= intlen)
 		return -EINVAL;
 
-	out_irq->controller = NULL;
-	out_irq->specifier[0] = ints[index];
-	out_irq->size = 1;
+	out_irq->np = NULL;
+	out_irq->args[0] = ints[index];
+	out_irq->args_count = 1;
 
 	return 0;
 }
diff --git a/arch/powerpc/platforms/pseries/event_sources.c b/arch/powerpc/platforms/pseries/event_sources.c
index 850c18c..6dcf9cc 100644
--- a/arch/powerpc/platforms/pseries/event_sources.c
+++ b/arch/powerpc/platforms/pseries/event_sources.c
@@ -25,7 +25,7 @@ void request_event_sources_irqs(struct device_node *np,
 				const char *name)
 {
 	int i, index, count = 0;
-	struct of_irq oirq;
+	struct of_phandle_args oirq;
 	const u32 *opicprop;
 	unsigned int opicplen;
 	unsigned int virqs[16];
@@ -59,9 +59,8 @@ void request_event_sources_irqs(struct device_node *np,
 		     index++) {
 			if (count > 15)
 				break;
-			virqs[count] = irq_create_of_mapping(oirq.controller,
-							    oirq.specifier,
-							    oirq.size);
+			virqs[count] = irq_create_of_mapping(oirq.np, oirq.args,
+							    oirq.args_count);
 			if (virqs[count] == NO_IRQ) {
 				pr_err("event-sources: Unable to allocate "
 				       "interrupt number for %s\n",
diff --git a/arch/powerpc/sysdev/mpic_msi.c b/arch/powerpc/sysdev/mpic_msi.c
index 463e3a7..7dc39f3 100644
--- a/arch/powerpc/sysdev/mpic_msi.c
+++ b/arch/powerpc/sysdev/mpic_msi.c
@@ -35,7 +35,7 @@ static int mpic_msi_reserve_u3_hwirqs(struct mpic *mpic)
 	const struct irq_domain_ops *ops = mpic->irqhost->ops;
 	struct device_node *np;
 	int flags, index, i;
-	struct of_irq oirq;
+	struct of_phandle_args oirq;
 
 	pr_debug("mpic: found U3, guessing msi allocator setup\n");
 
@@ -64,8 +64,8 @@ static int mpic_msi_reserve_u3_hwirqs(struct mpic *mpic)
 
 		index = 0;
 		while (of_irq_parse_one(np, index++, &oirq) == 0) {
-			ops->xlate(mpic->irqhost, NULL, oirq.specifier,
-						oirq.size, &hwirq, &flags);
+			ops->xlate(mpic->irqhost, NULL, oirq.args,
+						oirq.args_count, &hwirq, &flags);
 			msi_bitmap_reserve_hwirq(&mpic->msi_bitmap, hwirq);
 		}
 	}
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 3ac6398..0098698 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -105,7 +105,7 @@ struct device_node *pcibios_get_phb_of_node(struct pci_bus *bus)
 
 static int x86_of_pci_irq_enable(struct pci_dev *dev)
 {
-	struct of_irq oirq;
+	struct of_phandle_args oirq;
 	u32 virq;
 	int ret;
 	u8 pin;
@@ -120,8 +120,7 @@ static int x86_of_pci_irq_enable(struct pci_dev *dev)
 	if (ret)
 		return ret;
 
-	virq = irq_create_of_mapping(oirq.controller, oirq.specifier,
-			oirq.size);
+	virq = irq_create_of_mapping(oirq.np, oirq.args, oirq.args_count);
 	if (virq == 0)
 		return -EINVAL;
 	dev->irq = virq;
diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 410aa24..a7db38a 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -36,13 +36,12 @@
  */
 unsigned int irq_of_parse_and_map(struct device_node *dev, int index)
 {
-	struct of_irq oirq;
+	struct of_phandle_args oirq;
 
 	if (of_irq_parse_one(dev, index, &oirq))
 		return 0;
 
-	return irq_create_of_mapping(oirq.controller, oirq.specifier,
-				     oirq.size);
+	return irq_create_of_mapping(oirq.np, oirq.args, oirq.args_count);
 }
 EXPORT_SYMBOL_GPL(irq_of_parse_and_map);
 
@@ -94,7 +93,7 @@ struct device_node *of_irq_find_parent(struct device_node *child)
  * node exist for the parent.
  */
 int of_irq_parse_raw(struct device_node *parent, const __be32 *intspec,
-		   u32 ointsize, const __be32 *addr, struct of_irq *out_irq)
+		   u32 ointsize, const __be32 *addr, struct of_phandle_args *out_irq)
 {
 	struct device_node *ipar, *tnode, *old = NULL, *newpar = NULL;
 	const __be32 *tmp, *imap, *imask;
@@ -156,10 +155,10 @@ int of_irq_parse_raw(struct device_node *parent, const __be32 *intspec,
 				NULL) {
 			pr_debug(" -> got it !\n");
 			for (i = 0; i < intsize; i++)
-				out_irq->specifier[i] =
+				out_irq->args[i] =
 						of_read_number(intspec +i, 1);
-			out_irq->size = intsize;
-			out_irq->controller = ipar;
+			out_irq->args_count = intsize;
+			out_irq->np = ipar;
 			of_node_put(old);
 			return 0;
 		}
@@ -280,7 +279,7 @@ EXPORT_SYMBOL_GPL(of_irq_parse_raw);
  * This function resolves an interrupt, walking the tree, for a given
  * device-tree node. It's the high level pendant to of_irq_parse_raw().
  */
-int of_irq_parse_one(struct device_node *device, int index, struct of_irq *out_irq)
+int of_irq_parse_one(struct device_node *device, int index, struct of_phandle_args *out_irq)
 {
 	struct device_node *p;
 	const __be32 *intspec, *tmp, *addr;
diff --git a/drivers/of/of_pci_irq.c b/drivers/of/of_pci_irq.c
index dceec10..ee3293d 100644
--- a/drivers/of/of_pci_irq.c
+++ b/drivers/of/of_pci_irq.c
@@ -15,7 +15,7 @@
  * PCI tree until an device-node is found, at which point it will finish
  * resolving using the OF tree walking.
  */
-int of_irq_parse_pci(const struct pci_dev *pdev, struct of_irq *out_irq)
+int of_irq_parse_pci(const struct pci_dev *pdev, struct of_phandle_args *out_irq)
 {
 	struct device_node *dn, *ppnode;
 	struct pci_dev *ppdev;
diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index 05f8180..c5e57f8 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -647,15 +647,14 @@ static int __init mvebu_pcie_setup(int nr, struct pci_sys_data *sys)
 
 static int __init mvebu_pcie_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 {
-	struct of_irq oirq;
+	struct of_phandle_args oirq;
 	int ret;
 
 	ret = of_irq_parse_pci(dev, &oirq);
 	if (ret)
 		return ret;
 
-	return irq_create_of_mapping(oirq.controller, oirq.specifier,
-				     oirq.size);
+	return irq_create_of_mapping(oirq.np, oirq.args, oirq.args_count);
 }
 
 static struct pci_bus *mvebu_pcie_scan_bus(int nr, struct pci_sys_data *sys)
diff --git a/include/linux/of_irq.h b/include/linux/of_irq.h
index a00bc71..8d9f855 100644
--- a/include/linux/of_irq.h
+++ b/include/linux/of_irq.h
@@ -8,22 +8,6 @@
 #include <linux/ioport.h>
 #include <linux/of.h>
 
-/**
- * of_irq - container for device_node/irq_specifier pair for an irq controller
- * @controller: pointer to interrupt controller device tree node
- * @size: size of interrupt specifier
- * @specifier: array of cells @size long specifing the specific interrupt
- *
- * This structure is returned when an interrupt is mapped. The controller
- * field needs to be put() after use
- */
-#define OF_MAX_IRQ_SPEC		4 /* We handle specifiers of at most 4 cells */
-struct of_irq {
-	struct device_node *controller; /* Interrupt controller node */
-	u32 size; /* Specifier size */
-	u32 specifier[OF_MAX_IRQ_SPEC]; /* Specifier copy */
-};
-
 typedef int (*of_irq_init_cb_t)(struct device_node *, struct device_node *);
 
 /*
@@ -36,12 +20,12 @@ typedef int (*of_irq_init_cb_t)(struct device_node *, struct device_node *);
 extern unsigned int of_irq_workarounds;
 extern struct device_node *of_irq_dflt_pic;
 extern int of_irq_parse_oldworld(struct device_node *device, int index,
-			       struct of_irq *out_irq);
+			       struct of_phandle_args *out_irq);
 #else /* CONFIG_PPC32 && CONFIG_PPC_PMAC */
 #define of_irq_workarounds (0)
 #define of_irq_dflt_pic (NULL)
 static inline int of_irq_parse_oldworld(struct device_node *device, int index,
-				      struct of_irq *out_irq)
+				      struct of_phandle_args *out_irq)
 {
 	return -EINVAL;
 }
@@ -50,9 +34,9 @@ static inline int of_irq_parse_oldworld(struct device_node *device, int index,
 
 extern int of_irq_parse_raw(struct device_node *parent, const __be32 *intspec,
 			  u32 ointsize, const __be32 *addr,
-			  struct of_irq *out_irq);
+			  struct of_phandle_args *out_irq);
 extern int of_irq_parse_one(struct device_node *device, int index,
-			  struct of_irq *out_irq);
+			  struct of_phandle_args *out_irq);
 extern unsigned int irq_create_of_mapping(struct device_node *controller,
 					  const u32 *intspec,
 					  unsigned int intsize);
diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
index 839ba20..f297237 100644
--- a/include/linux/of_pci.h
+++ b/include/linux/of_pci.h
@@ -5,8 +5,8 @@
 #include <linux/msi.h>
 
 struct pci_dev;
-struct of_irq;
-int of_irq_parse_pci(const struct pci_dev *pdev, struct of_irq *out_irq);
+struct of_phandle_args;
+int of_irq_parse_pci(const struct pci_dev *pdev, struct of_phandle_args *out_irq);
 
 struct device_node;
 struct device_node *of_pci_find_child_device(struct device_node *parent,
-- 
1.8.1.2

