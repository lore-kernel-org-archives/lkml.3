Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab3HGK0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:26:24 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:56395 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456Ab3HGK0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:26:21 -0400
Date: Wed, 7 Aug 2013 12:19:42 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: rubini@gnudd.com, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Subject: [PATCH 13/26] drivers/amba/pci-amba.c: use devicetree for amba
 device creation.
Message-ID: <941f70ce8d4ee1fbb617fb58e27cefeebbb31b29.1375867291.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1375867291.git.rubini@gnudd.com>
In-Reply-To: <cover.1375867291.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following scheme applies for each pci-amba device within the
devicetree:

	* sta2x11 pci express port (pci id = 0xcc17)
	  |
	  |
	  * pci-amba bridge node (pci id = 0xcc18)
	    |
	    +-------+
	    |	    |
	    |	    * amba-bus node (ranges, interrupt-map)
	    |	      |
	    |	      ...
	    ...	      |
	    |	      * amba side of pci-amba device
	    |
	    |
	    * pci side of pci-amba device

As far as the sta2x11 is concerned, there are 4 pci-amba bridge nodes (one
for each pci express endpoint).
A pci-amba bridge node contains an amba bus and all the pci side parts of
the pci-amba devices attached to the same pci express endpoint.
Finally, each child node of the amba bus represents the amba side of a
pci-amba device.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 drivers/amba/pci-amba.c |  126 ++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 109 insertions(+), 17 deletions(-)

diff --git a/drivers/amba/pci-amba.c b/drivers/amba/pci-amba.c
index 8ce526a..e56717b 100644
--- a/drivers/amba/pci-amba.c
+++ b/drivers/amba/pci-amba.c
@@ -12,42 +12,134 @@
 #include <linux/slab.h>
 #include <linux/irq.h>
 #include <linux/sizes.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
+
+/*
+  Length of an interrupt map row:
+  Child unit address (amba node, length is 1) +
+  Child interrupt specifier (amba node, length is 1) +
+  Interrupt parent (phandle, length is 1) +
+  Parent unit address (parent is msi controller, length is 1)
+  Parent interrupt specifier (parent is msi controller, length is 1)
+*/
+#define IMAP_ROW_LEN (1 + 1 + 1 + 1 + 1)
 
 static int pci_amba_probe(struct pci_dev *pdev,
 			  const struct pci_device_id *id)
 {
 	struct amba_device *adev;
+	int i, ret, len;
+	struct device_node *n, *node, *pci_amba_bridge, *amba_bus = NULL,
+		*amba_node = NULL;
+	const void *p;
 	char *name;
-	int ret;
+	struct property *newimap;
+	u32 *newv, *ptr;
+	const u32 *reg;
+	int found;
 
 	pci_enable_msi(pdev);
 	ret = pci_enable_device(pdev);
 	if (ret)
 		return ret;
 
-	/* Create a name: each of them must be different */
+	/* This bridge can host both APB and AHB devices, so set master */
+	pci_set_master(pdev);
+
+	node = pdev->dev.of_node;
+	if (!node)
+		return -EINVAL;
+
+	/* Get a reference to the pci amba bridge (our pci parent) */
+	pci_amba_bridge = of_get_parent(node);
+	if (!pci_amba_bridge)
+		return -EINVAL;
+	if (of_node_cmp(pci_amba_bridge->type, "pci"))
+		return -EINVAL;
+
+	/* Look for the relevant amba bus node */
+	for_each_child_of_node(pci_amba_bridge, n) {
+		if (of_device_is_compatible(n, "arm,amba-bus")) {
+			amba_bus = n;
+			break;
+		}
+	}
+	of_node_put(pci_amba_bridge);
+	if (!amba_bus)
+		return -ENODEV;
+
+	/*
+	   Now find out what the relevant amba device is by looking for
+	   a resource with the same initial address of this pci device's BAR0
+	*/
+	for_each_child_of_node(amba_bus, n) {
+		struct resource r;
+		if (of_address_to_resource(n, 0, &r))
+			continue;
+		if (r.start == pdev->resource[0].start) {
+			amba_node = n;
+			break;
+		}
+	}
+	if (!amba_node)
+		return -ENODEV;
+
+	/* Create a unique name for the device */
 	name = devm_kzalloc(&pdev->dev, strlen(dev_name(&pdev->dev)) + 6,
-		GFP_KERNEL);
+			    GFP_KERNEL);
 	sprintf(name, "amba-%s", dev_name(&pdev->dev));
 
-	/* Simply build an amba device and register it */
-	adev = amba_device_alloc(name,  pdev->resource[0].start, SZ_4K);
-	if (!adev)
-		return -ENOMEM;
-	adev->irq[0] = pdev->irq;
+	/*
+	  Since we're dealing with MSI IRQs, the value of a device's IRQ
+	  number is known at runtime only. Update the amba bus interrupt
+	  map to fix things up.
+	*/
+	if (of_get_property(amba_node, "interrupts", NULL)) {
+		p = of_get_property(amba_bus, "interrupt-map", &len);
+		if (!p)
+			/* No amba bus interrupt-map property */
+			return -EINVAL;
 
-	/* This bridge can host both APB and AHB devices, so set master */
-	pci_set_master(pdev);
-	if (pdev->vendor == PCI_VENDOR_ID_STMICRO) {
-		/* Under sta2x11, DMA is there but limited to 512M */
-		adev->dma_mask = SZ_512M - 1;
-		adev->dev.coherent_dma_mask = SZ_512M - 1;
+		newimap = devm_kzalloc(&pdev->dev, sizeof(*newimap),
+				       GFP_KERNEL);
+		if (!newimap)
+			return -ENOMEM;
+
+		newimap->name = kstrdup("interrupt-map", GFP_KERNEL);
+		if (!newimap->name)
+			return -ENOMEM;
+
+		newv = devm_kzalloc(&pdev->dev, len, GFP_KERNEL);
+		if (!newv) {
+			kfree(newimap->name);
+			return -ENOMEM;
+		}
+
+		newimap->value = newv;
+		newimap->length = len;
+		memcpy(newv, p, len);
+		for (ptr = newv, i = 0, found = 0;
+		     i < len/sizeof(u32);
+		     ptr += IMAP_ROW_LEN, i += IMAP_ROW_LEN) {
+			reg = of_get_property(amba_node, "reg", NULL);
+			if (ptr[0] == reg[0]) {
+				ptr[IMAP_ROW_LEN - 1] = cpu_to_be32(pdev->irq);
+				found = 1;
+				break;
+			}
+		}
+		if (!found) {
+			pr_err("Could not update amba irq\n");
+			return -EINVAL;
+		}
+		of_update_property(amba_bus, newimap);
 	}
 
-	adev->dev.platform_data = pdev->dev.platform_data;
+	/* And finally create the amba device */
+	adev = of_amba_device_create(n, name, NULL, NULL, &pdev->resource[0]);
 	pci_set_drvdata(pdev, adev);
-
-	return amba_device_add(adev, &pdev->resource[0]);
+	return 0;
 };
 
 static void pci_amba_remove(struct pci_dev *pdev)
-- 
1.7.7.2
