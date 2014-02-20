Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340AbaBTQWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:22:22 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:47107 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbaBTQWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:22:21 -0500
From: Julien Grall <julien.grall@linaro.org>
To: linux-kernel@vger.kernel.org, stefano.stabellini@eu.citrix.com
Cc: linux-arm-kernel@lists.infradead.org, ian.campbell@citrix.com,
        xen-devel@lists.xenproject.org, Julien Grall <julien.grall@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org
Subject: [PATCH 2/2] arm/xen: Don't use xen DMA ops when the device is protected by an IOMMU
Date: Thu, 20 Feb 2014 16:21:41 +0000
Message-Id: <1392913301-25524-1-git-send-email-julien.grall@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only Xen is able to know if a device can safely avoid to use xen-swiotlb.
This patch introduce a new property "protected-devices" for the hypervisor
node which list device which the IOMMU are been correctly programmed by Xen.

During Linux boot, Xen specific code will create an hash table which
contains all these devices. The hash table will be used in need_xen_dma_ops
to check if the Xen DMA ops needs to be used for the current device.

Signed-off-by: Julien Grall <julien.grall@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Rob Landley <rob@landley.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: devicetree@vger.kernel.org
---
 Documentation/devicetree/bindings/arm/xen.txt |    2 +
 arch/arm/include/asm/xen/dma-mapping.h        |   11 +++-
 arch/arm/xen/enlighten.c                      |   75 +++++++++++++++++++++++++
 3 files changed, 87 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/arm/xen.txt b/Documentation/devicetree/bindings/arm/xen.txt
index 0f7b9c2..ee25a57 100644
--- a/Documentation/devicetree/bindings/arm/xen.txt
+++ b/Documentation/devicetree/bindings/arm/xen.txt
@@ -15,6 +15,8 @@ the following properties:
 - interrupts: the interrupt used by Xen to inject event notifications.
   A GIC node is also required.
 
+- protected-devices: (optional) List of phandles to device node where the
+IOMMU has been programmed by Xen.
 
 Example (assuming #address-cells = <2> and #size-cells = <2>):
 
diff --git a/arch/arm/include/asm/xen/dma-mapping.h b/arch/arm/include/asm/xen/dma-mapping.h
index 002fc57..da8e4fe 100644
--- a/arch/arm/include/asm/xen/dma-mapping.h
+++ b/arch/arm/include/asm/xen/dma-mapping.h
@@ -5,9 +5,18 @@
 
 extern struct dma_map_ops *xen_dma_ops;
 
+#ifdef CONFIG_XEN
+bool xen_is_protected_device(const struct device *dev);
+#else
+static inline bool xen_is_protected_device(const struct device *dev)
+{
+	return 0;
+}
+#endif
+
 static inline bool need_xen_dma_ops(struct device *dev)
 {
-	return xen_initial_domain();
+	return xen_initial_domain() && !xen_is_protected_device(dev);
 }
 
 #endif /* _ASM_ARM_XEN_DMA_MAPPING_H */
diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index b96723e..f124c8c 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -24,6 +24,7 @@
 #include <linux/cpuidle.h>
 #include <linux/cpufreq.h>
 #include <linux/cpu.h>
+#include <linux/hashtable.h>
 
 #include <linux/mm.h>
 
@@ -53,6 +54,42 @@ EXPORT_SYMBOL_GPL(xen_platform_pci_unplug);
 
 static __read_mostly int xen_events_irq = -1;
 
+/* Hash table for list of devices protected by an IOMMU in Xen */
+#define DEV_HASH_BITS	4
+#define DEV_HASH_SIZE	(1 << DEV_HASH_BITS)
+
+static struct hlist_head *protected_devices;
+
+struct protected_device
+{
+	struct hlist_node hlist;
+	struct device_node *node;
+};
+
+static unsigned long pdev_hash(const struct device_node *node)
+{
+	return (node->phandle % DEV_HASH_SIZE);
+}
+
+bool xen_is_protected_device(const struct device *dev)
+{
+	const struct device_node *node = dev->of_node;
+	unsigned long hash;
+	const struct protected_device *pdev;
+
+	if (!node->phandle)
+		return 0;
+
+	hash = pdev_hash(node);
+
+	hlist_for_each_entry(pdev, &protected_devices[hash], hlist) {
+		if (node == pdev->node)
+			return 1;
+	}
+
+	return 0;
+}
+
 /* map fgmfn of domid to lpfn in the current domain */
 static int map_foreign_page(unsigned long lpfn, unsigned long fgmfn,
 			    unsigned int domid)
@@ -235,6 +272,8 @@ static int __init xen_guest_init(void)
 	const char *xen_prefix = "xen,xen-";
 	struct resource res;
 	phys_addr_t grant_frames;
+	int i = 0;
+	struct device_node *dev;
 
 	node = of_find_compatible_node(NULL, NULL, "xen,xen");
 	if (!node) {
@@ -259,6 +298,31 @@ static int __init xen_guest_init(void)
 	if (xen_events_irq < 0)
 		return -ENODEV;
 
+	protected_devices = kmalloc(DEV_HASH_SIZE * sizeof (*protected_devices),
+				    GFP_KERNEL);
+	if (!protected_devices)
+		return -ENOMEM;
+
+	for (i = 0; i < DEV_HASH_SIZE; i++)
+		INIT_HLIST_HEAD(&protected_devices[i]);
+
+	pr_info("List of protected devices:\n");
+	i = 0;
+	while ((dev = of_parse_phandle(node, "protected-devices", i))) {
+		struct protected_device *pdev;
+		unsigned long hash;
+
+		pr_info(" - %s\n", of_node_full_name(dev));
+		pdev = kmalloc(sizeof (*pdev), GFP_KERNEL);
+		if (!pdev)
+			goto free_hash;
+
+		pdev->node = dev;
+		hash = pdev_hash(dev);
+		hlist_add_head(&pdev->hlist, &protected_devices[hash]);
+		i++;
+	}
+
 	xen_domain_type = XEN_HVM_DOMAIN;
 
 	xen_setup_features();
@@ -324,6 +388,17 @@ static int __init xen_guest_init(void)
 	register_cpu_notifier(&xen_cpu_notifier);
 
 	return 0;
+free_hash:
+	for (i = 0; i < DEV_HASH_SIZE; i++) {
+		struct protected_device *pdev;
+		struct hlist_node *next;
+
+		hlist_for_each_entry_safe(pdev, next, &protected_devices[i],
+					  hlist)
+			kfree(pdev);
+	}
+	kfree(protected_devices);
+	return -ENOMEM;
 }
 early_initcall(xen_guest_init);
 
-- 
1.7.10.4

