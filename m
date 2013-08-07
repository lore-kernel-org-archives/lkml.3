Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824Ab3HGK2C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:28:02 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:56453 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932662Ab3HGK16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:27:58 -0400
Date: Wed, 7 Aug 2013 12:21:20 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: rubini@gnudd.com, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Subject: [PATCH 22/26] AMBA: pci-amba bridge: extend number of amba devs
 per pci device
Message-ID: <404568d195a70561a04ff1c534ac1db7c015f53b.1375867291.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1375867291.git.rubini@gnudd.com>
In-Reply-To: <cover.1375867291.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes it possible to create multiple AMBA devices
per PCI device (multiple AMBA devices on the same PCI bar, or
one/more AMBA devices referring to more than one PCI BAR).
This feature is needed to completely support the Connext chip,
which has, for instance, multiple devices on the same BAR
(former mfd device) and multiple devices on multiple PCI BARs
(6 msp ports, 2 ports per PCI BAR).

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 drivers/amba/pci-amba.c |  152 +++++++++++++++++++++++++++++++++++++----------
 1 files changed, 121 insertions(+), 31 deletions(-)

diff --git a/drivers/amba/pci-amba.c b/drivers/amba/pci-amba.c
index c825c7a..f272d38 100644
--- a/drivers/amba/pci-amba.c
+++ b/drivers/amba/pci-amba.c
@@ -25,9 +25,47 @@
 */
 #define IMAP_ROW_LEN (1 + 1 + 1 + 1 + 1)
 
-static int fixup_amba_irq(struct device_node *amba_node,
-			  struct device_node *amba_bus,
-			  struct pci_dev *pdev)
+static inline int resource_fits(struct resource *r1, struct resource *r2)
+{
+	return (r1->start >= r2->start) && (r1->end <= r2->end);
+}
+
+static const char *get_platform_prefix(struct pci_dev *pdev)
+{
+	switch (pdev->device) {
+	case PCI_DEVICE_ID_STMICRO_ESRAM:
+		return "mmio";
+	case PCI_DEVICE_ID_STMICRO_GPIO:
+		return "gpio";
+	default:
+		return "pci-amba-platform";
+	}
+	return NULL;
+}
+
+static inline int is_platform_device(struct pci_dev *pdev)
+{
+	return pdev->device == PCI_DEVICE_ID_STMICRO_ESRAM ||
+		pdev->device == PCI_DEVICE_ID_STMICRO_GPIO ||
+		pdev->device == PCI_DEVICE_ID_STMICRO_VIC;
+}
+
+static int get_dev_name(char **name, struct pci_dev *pdev, int index)
+{
+	const char *prefix = is_platform_device(pdev) ?
+		get_platform_prefix(pdev) : "amba";
+	const char *core = dev_name(&pdev->dev);
+	*name = devm_kzalloc(&pdev->dev, strlen(core) + strlen(prefix) + 3,
+			     GFP_KERNEL);
+	if (!*name)
+		return -ENOMEM;
+	sprintf(*name, "%s-%s-%1d", prefix, core, index);
+	return 0;
+}
+
+static int fixup_irq(struct device_node *node,
+		     struct device_node *amba_bus,
+		     struct pci_dev *pdev)
 {
 	const void *p;
 	struct property *newimap;
@@ -59,7 +97,7 @@ static int fixup_amba_irq(struct device_node *amba_node,
 	memcpy(newv, p, len);
 	for (ptr = newv, i = 0, found = 0;
 	     i < len/sizeof(u32); ptr += IMAP_ROW_LEN, i += IMAP_ROW_LEN) {
-		reg = of_get_property(amba_node, "reg", NULL);
+		reg = of_get_property(node, "reg", NULL);
 		if (ptr[0] == reg[0]) {
 			ptr[IMAP_ROW_LEN - 1] = cpu_to_be32(pdev->irq);
 			found = 1;
@@ -77,10 +115,12 @@ static int fixup_amba_irq(struct device_node *amba_node,
 static int pci_amba_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *id)
 {
-	struct amba_device *adev;
-	int ret;
+	struct amba_device **adev = NULL;
+	struct platform_device **platdev = NULL;
+	int ret, i, dncnt = 0;
+	void *drvdata;
 	struct device_node *n, *node, *pci_amba_bridge, *amba_bus = NULL,
-		*amba_node = NULL;
+		*dev_nodes[8];
 	char *name;
 
 	pci_enable_msi(pdev);
@@ -95,6 +135,8 @@ static int pci_amba_probe(struct pci_dev *pdev,
 	if (!node)
 		return -EINVAL;
 
+	memset(dev_nodes, 0, sizeof(dev_nodes));
+
 	/* Get a reference to the pci amba bridge (our pci parent) */
 	pci_amba_bridge = of_get_parent(node);
 	if (!pci_amba_bridge)
@@ -114,47 +156,93 @@ static int pci_amba_probe(struct pci_dev *pdev,
 		return -ENODEV;
 
 	/*
+	  Allocate an array of amba or platform devices pointers
+	*/
+	if (is_platform_device(pdev))
+		platdev = devm_kzalloc(&pdev->dev, sizeof(*platdev) * 8,
+				       GFP_KERNEL);
+	else
+		adev = devm_kzalloc(&pdev->dev, sizeof(*adev) * 8, GFP_KERNEL);
+	if (!adev && !platdev)
+		return -ENOMEM;
+
+	/*
 	   Now find out what the relevant amba device is by looking for
 	   a resource with the same initial address of this pci device's BAR0
 	*/
 	for_each_child_of_node(amba_bus, n) {
-		struct resource r;
-		if (of_address_to_resource(n, 0, &r))
+		struct resource r[8];
+		if (of_address_to_resource(n, 0, &r[dncnt]))
 			continue;
-		if (r.start == pdev->resource[0].start) {
-			amba_node = n;
-			break;
+		for (i = PCI_STD_RESOURCES; (i < PCI_STD_RESOURCE_END) &&
+			     (dncnt < ARRAY_SIZE(dev_nodes)); i++) {
+			if (resource_fits(&r[dncnt], &pdev->resource[i])) {
+				dev_nodes[dncnt++] = n;
+				break;
+			}
 		}
 	}
-	if (!amba_node)
+	if (!dncnt)
 		return -ENODEV;
 
-	/* Create a unique name for the device */
-	name = devm_kzalloc(&pdev->dev, strlen(dev_name(&pdev->dev)) + 6,
-			    GFP_KERNEL);
-	sprintf(name, "amba-%s", dev_name(&pdev->dev));
-
-	/*
-	  Since we're dealing with MSI IRQs, the value of a device's IRQ
-	  number is known at runtime only. Update the amba bus interrupt
-	  map to fix things up.
-	*/
-	if (of_get_property(amba_node, "interrupts", NULL)) {
-		ret = fixup_amba_irq(amba_node, amba_bus, pdev);
+	for (i = 0; i < dncnt && dev_nodes[i]; i++) {
+		/* Create a unique name for the device */
+		ret = get_dev_name(&name, pdev, i);
 		if (ret < 0)
 			return ret;
+		/*
+		  Since we're dealing with MSI IRQs, the value of a device's
+		  IRQ number is known at runtime only. Update the amba bus
+		  interrupt map property to fix things up.
+		*/
+		if (of_get_property(dev_nodes[i], "interrupts", NULL)) {
+			ret = fixup_irq(dev_nodes[i], amba_bus, pdev);
+			if (ret < 0)
+				return ret;
+		}
+		/* And finally create the amba or platform device */
+		if (is_platform_device(pdev)) {
+			platdev[i] = of_platform_device_create(dev_nodes[i],
+							       name, NULL);
+			continue;
+		}
+		adev[i] = of_amba_device_create(dev_nodes[i], name, NULL, NULL,
+						&pdev->resource[0]);
 	}
-
-	/* And finally create the amba device */
-	adev = of_amba_device_create(n, name, NULL, NULL, &pdev->resource[0]);
-	pci_set_drvdata(pdev, adev);
+	drvdata = is_platform_device(pdev) ? (void *)platdev : (void *)adev;
+	pci_set_drvdata(pdev, drvdata);
 	return 0;
 };
 
+static void platform_remove(void *__platdev)
+{
+	int i;
+	struct platform_device **platdev = __platdev;
+	for (i = 0; i < 8; i++) {
+		if (!platdev[i])
+			break;
+		platform_device_unregister(platdev[i]);
+	}
+}
+
+static void amba_remove(void *__ambadev)
+{
+	int i;
+	struct amba_device **ambadev = __ambadev;
+	for (i = 0; i < 8; i++) {
+		if (!ambadev[i])
+			break;
+		amba_device_unregister(ambadev[i]);
+	}
+}
+
 static void pci_amba_remove(struct pci_dev *pdev)
 {
-	struct amba_device *adev = pci_get_drvdata(pdev);
-	amba_device_unregister(adev);
+	void *drvdata = pci_get_drvdata(pdev);
+	if (is_platform_device(pdev))
+		platform_remove(drvdata);
+	else
+		amba_remove(drvdata);
 	pci_disable_msi(pdev);
 }
 
@@ -168,6 +256,8 @@ static DEFINE_PCI_DEVICE_TABLE(pci_amba_table) = {
 	{PCI_VDEVICE(STMICRO, PCI_DEVICE_ID_STMICRO_SDIO)},
 	{PCI_VDEVICE(STMICRO, PCI_DEVICE_ID_STMICRO_AUDIO_ROUTER_DMA)},
 	{PCI_VDEVICE(STMICRO, PCI_DEVICE_ID_STMICRO_AUDIO_ROUTER_MSPS)},
+	{PCI_VDEVICE(STMICRO, PCI_DEVICE_ID_STMICRO_ESRAM)},
+	{PCI_VDEVICE(STMICRO, PCI_DEVICE_ID_STMICRO_GPIO)},
 	{0,}
 };
 
-- 
1.7.7.2
