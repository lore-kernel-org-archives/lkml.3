Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535Ab3KJAqW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 19:46:22 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49162 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758445Ab3KJAqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 19:46:19 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: [PATCH] ACPI / driver core: Store a device pointer in struct acpi_dev_node
Date: Sun, 10 Nov 2013 01:58:42 +0100
Message-ID: <3268437.YsusHvklcv@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Modify struct acpi_dev_node to contain a pointer to struct device
ambedded in the struct acpi_device associated with the given device
object (that is, its ACPI companion device) instead of an ACPI handle
corresponding to that struct acpi_device.  Introduce two new macros
for manipulating that pointer in a CONFIG_ACPI-safe way,
ACPI_COMPANION() and ACPI_COMPANION_SET(), and rework the
ACPI_HANDLE() macro to take the above changes into account.
Drop the ACPI_HANDLE_SET() macro entirely and rework its users to
use ACPI_COMPANION_SET() instead.  For some of them who used to
pass the result of acpi_get_child() directly to ACPI_HANDLE_SET()
introduce a helper routine acpi_preset_companion() doing an
equivalent thing.

The rationale for using a struct device pointer instead of a
struct acpi_device one as the member of struct acpi_dev_node is
that it allows device.h to avoid including linux/acpi.h which would
introduce quite a bit of compilation overhead for stuff that doesn't
care about ACPI.  In turn, moving the macros to linux/acpi.h forces
the stuff that does care about ACPI to include that file as
appropriate anyway.

The main motivation for doing this is that there are things
represented by struct acpi_device objects that don't have valid
ACPI handles (so called fixed ACPI hardware features, such as
power and sleep buttons) and we would like to create platform
device objects for them and "glue" them to their ACPI companions
in the usual way (which currently is impossible due to the
lack of valid ACPI handles).  However, there are more reasons
why it may be useful.

First, struct device pointers allow of much better type checking
than void pointers which are ACPI handles, so it should be more
difficult to write buggy code using modified struct acpi_dev_node
and the new macros.  Second, it should help to reduce the number
of places in which the result of ACPI_HANDLE() is passed to
acpi_bus_get_device() in order to obtain a pointer to the
struct acpi_device associated with the given "physical" device,
because now that pointer can be obtained directly by applying
to_acpi_device() to the result of the ACPI_COMPANION() macro.
Finally, it should make it easier to write generic code that will
build both for CONFIG_ACPI set and unset without adding explicit
compiler directives to it.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Hi Everybody,

First of all, I haven't tested this yet, so caveat emptor.  I have compiled
it on x86-64 for CONFIG_ACPI set and unset and I'm going to feed it to the
auto build system shortly in case I overlooked something build-related.

Please have a look and let me know if you have any problems with this in
principle.  If not, I'd like to queue it up for inclusion by the end of
the merge window or in the -rc2 time frame (to avoid collisions with any
big merges), as I'd like to be able to work on top of it during the 3.14
cycle if possible.

Thanks,
Rafael

---
 arch/ia64/include/asm/pci.h   |    2 -
 arch/ia64/pci/pci.c           |    6 ++---
 arch/x86/include/asm/pci.h    |    2 -
 arch/x86/pci/acpi.c           |    4 +--
 drivers/acpi/acpi_platform.c  |    2 -
 drivers/acpi/device_pm.c      |    6 -----
 drivers/acpi/glue.c           |   45 +++++++++++++++++++++---------------------
 drivers/ata/libata-acpi.c     |    4 +--
 drivers/base/platform.c       |    4 +--
 drivers/hid/i2c-hid/i2c-hid.c |    2 -
 drivers/i2c/i2c-core.c        |    4 +--
 drivers/mmc/core/sdio_bus.c   |    3 --
 drivers/spi/spi.c             |    2 -
 include/acpi/acpi_bus.h       |    2 -
 include/linux/acpi.h          |   14 +++++++++++++
 include/linux/device.h        |   10 ---------
 16 files changed, 57 insertions(+), 55 deletions(-)

Index: linux-pm/include/linux/device.h
===================================================================
--- linux-pm.orig/include/linux/device.h
+++ linux-pm/include/linux/device.h
@@ -625,7 +625,7 @@ struct device_dma_parameters {
 
 struct acpi_dev_node {
 #ifdef CONFIG_ACPI
-	void	*handle;
+	struct device *dev;
 #endif
 };
 
@@ -769,14 +769,6 @@ static inline struct device *kobj_to_dev
 	return container_of(kobj, struct device, kobj);
 }
 
-#ifdef CONFIG_ACPI
-#define ACPI_HANDLE(dev)	((dev)->acpi_node.handle)
-#define ACPI_HANDLE_SET(dev, _handle_)	(dev)->acpi_node.handle = (_handle_)
-#else
-#define ACPI_HANDLE(dev)	(NULL)
-#define ACPI_HANDLE_SET(dev, _handle_)	do { } while (0)
-#endif
-
 /* Get the wakeup routines, which depend on struct device */
 #include <linux/pm_wakeup.h>
 
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -431,9 +431,9 @@ static inline acpi_handle acpi_get_child
 {
 	return acpi_find_child(handle, addr, false);
 }
+void acpi_preset_companion(struct device *dev, acpi_handle parent, u64 addr);
 int acpi_is_root_bridge(acpi_handle);
 struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle);
-#define DEVICE_ACPI_HANDLE(dev) ((acpi_handle)ACPI_HANDLE(dev))
 
 int acpi_enable_wakeup_device_power(struct acpi_device *dev, int state);
 int acpi_disable_wakeup_device_power(struct acpi_device *dev);
Index: linux-pm/include/linux/acpi.h
===================================================================
--- linux-pm.orig/include/linux/acpi.h
+++ linux-pm/include/linux/acpi.h
@@ -44,6 +44,14 @@
 #include <acpi/acpi_numa.h>
 #include <asm/acpi.h>
 
+#define ACPI_COMPANION(device)		((device)->acpi_node.dev)
+#define ACPI_COMPANION_SET(dev, acc)	ACPI_COMPANION(dev) = (acc)
+#define ACPI_HANDLE(dev)				\
+({							\
+	struct device *acc = ACPI_COMPANION(dev);	\
+	acc ? to_acpi_device(acc)->handle : NULL;	\
+})
+
 enum acpi_irq_model_id {
 	ACPI_IRQ_MODEL_PIC = 0,
 	ACPI_IRQ_MODEL_IOAPIC,
@@ -407,6 +415,10 @@ static inline bool acpi_driver_match_dev
 
 #define acpi_disabled 1
 
+#define ACPI_COMPANION(device)		(NULL)
+#define ACPI_COMPANION_SET(dev, acc)	do { } while (0)
+#define ACPI_HANDLE(dev)		(NULL)
+
 static inline void acpi_early_init(void) { }
 
 static inline int early_acpi_boot_init(void)
@@ -475,6 +487,8 @@ static inline bool acpi_driver_match_dev
 
 #endif	/* !CONFIG_ACPI */
 
+#define DEVICE_ACPI_HANDLE(dev)	ACPI_HANDLE(dev)
+
 #ifdef CONFIG_ACPI
 void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
 			       u32 pm1a_ctrl,  u32 pm1b_ctrl));
Index: linux-pm/arch/ia64/include/asm/pci.h
===================================================================
--- linux-pm.orig/arch/ia64/include/asm/pci.h
+++ linux-pm/arch/ia64/include/asm/pci.h
@@ -95,7 +95,7 @@ struct iospace_resource {
 };
 
 struct pci_controller {
-	void *acpi_handle;
+	struct device *acpi_companion;
 	void *iommu;
 	int segment;
 	int node;		/* nearest node with memory or -1 for global allocation */
Index: linux-pm/arch/ia64/pci/pci.c
===================================================================
--- linux-pm.orig/arch/ia64/pci/pci.c
+++ linux-pm/arch/ia64/pci/pci.c
@@ -436,9 +436,9 @@ struct pci_bus *pci_acpi_scan_root(struc
 	if (!controller)
 		return NULL;
 
-	controller->acpi_handle = device->handle;
+	controller->acpi_companion = &device->dev;
 
-	pxm = acpi_get_pxm(controller->acpi_handle);
+	pxm = acpi_get_pxm(device->handle);
 #ifdef CONFIG_NUMA
 	if (pxm >= 0)
 		controller->node = pxm_to_node(pxm);
@@ -489,7 +489,7 @@ int pcibios_root_bridge_prepare(struct p
 {
 	struct pci_controller *controller = bridge->bus->sysdata;
 
-	ACPI_HANDLE_SET(&bridge->dev, controller->acpi_handle);
+	ACPI_COMPANION_SET(&bridge->dev, controller->acpi_companion);
 	return 0;
 }
 
Index: linux-pm/arch/x86/include/asm/pci.h
===================================================================
--- linux-pm.orig/arch/x86/include/asm/pci.h
+++ linux-pm/arch/x86/include/asm/pci.h
@@ -15,7 +15,7 @@ struct pci_sysdata {
 	int		domain;		/* PCI domain */
 	int		node;		/* NUMA node */
 #ifdef CONFIG_ACPI
-	void		*acpi;		/* ACPI-specific data */
+	struct device	*acpi_companion;	/* ACPI companion device */
 #endif
 #ifdef CONFIG_X86_64
 	void		*iommu;		/* IOMMU private data */
Index: linux-pm/arch/x86/pci/acpi.c
===================================================================
--- linux-pm.orig/arch/x86/pci/acpi.c
+++ linux-pm/arch/x86/pci/acpi.c
@@ -518,7 +518,7 @@ struct pci_bus *pci_acpi_scan_root(struc
 	sd = &info->sd;
 	sd->domain = domain;
 	sd->node = node;
-	sd->acpi = device->handle;
+	sd->acpi_companion = &device->dev;
 	/*
 	 * Maybe the desired pci bus has been already scanned. In such case
 	 * it is unnecessary to scan the pci bus with the given domain,busnum.
@@ -589,7 +589,7 @@ int pcibios_root_bridge_prepare(struct p
 {
 	struct pci_sysdata *sd = bridge->bus->sysdata;
 
-	ACPI_HANDLE_SET(&bridge->dev, sd->acpi);
+	ACPI_COMPANION_SET(&bridge->dev, sd->acpi_companion);
 	return 0;
 }
 
Index: linux-pm/drivers/acpi/glue.c
===================================================================
--- linux-pm.orig/drivers/acpi/glue.c
+++ linux-pm/drivers/acpi/glue.c
@@ -197,30 +197,27 @@ static void acpi_physnode_link_name(char
 
 int acpi_bind_one(struct device *dev, acpi_handle handle)
 {
-	struct acpi_device *acpi_dev;
-	acpi_status status;
+	struct acpi_device *acpi_dev = NULL;
 	struct acpi_device_physical_node *physical_node, *pn;
 	char physical_node_name[PHYSICAL_NODE_NAME_SIZE];
 	struct list_head *physnode_list;
 	unsigned int node_id;
 	int retval = -EINVAL;
 
-	if (ACPI_HANDLE(dev)) {
+	if (ACPI_COMPANION(dev)) {
 		if (handle) {
-			dev_warn(dev, "ACPI handle is already set\n");
+			dev_warn(dev, "ACPI companion already set\n");
 			return -EINVAL;
 		} else {
-			handle = ACPI_HANDLE(dev);
+			acpi_dev = to_acpi_device(ACPI_COMPANION(dev));
 		}
+	} else {
+		acpi_bus_get_device(handle, &acpi_dev);
 	}
-	if (!handle)
+	if (!acpi_dev)
 		return -EINVAL;
 
 	get_device(dev);
-	status = acpi_bus_get_device(handle, &acpi_dev);
-	if (ACPI_FAILURE(status))
-		goto err;
-
 	physical_node = kzalloc(sizeof(*physical_node), GFP_KERNEL);
 	if (!physical_node) {
 		retval = -ENOMEM;
@@ -242,7 +239,7 @@ int acpi_bind_one(struct device *dev, ac
 
 			dev_warn(dev, "Already associated with ACPI node\n");
 			kfree(physical_node);
-			if (ACPI_HANDLE(dev) != handle)
+			if (ACPI_COMPANION(dev) != &acpi_dev->dev)
 				goto err;
 
 			put_device(dev);
@@ -259,8 +256,8 @@ int acpi_bind_one(struct device *dev, ac
 	list_add(&physical_node->node, physnode_list);
 	acpi_dev->physical_node_count++;
 
-	if (!ACPI_HANDLE(dev))
-		ACPI_HANDLE_SET(dev, acpi_dev->handle);
+	if (!ACPI_COMPANION(dev))
+		ACPI_COMPANION_SET(dev, &acpi_dev->dev);
 
 	acpi_physnode_link_name(physical_node_name, node_id);
 	retval = sysfs_create_link(&acpi_dev->dev.kobj, &dev->kobj,
@@ -283,7 +280,7 @@ int acpi_bind_one(struct device *dev, ac
 	return 0;
 
  err:
-	ACPI_HANDLE_SET(dev, NULL);
+	ACPI_COMPANION_SET(dev, NULL);
 	put_device(dev);
 	return retval;
 }
@@ -293,16 +290,11 @@ int acpi_unbind_one(struct device *dev)
 {
 	struct acpi_device_physical_node *entry;
 	struct acpi_device *acpi_dev;
-	acpi_status status;
 
-	if (!ACPI_HANDLE(dev))
+	if (!ACPI_COMPANION(dev))
 		return 0;
 
-	status = acpi_bus_get_device(ACPI_HANDLE(dev), &acpi_dev);
-	if (ACPI_FAILURE(status)) {
-		dev_err(dev, "Oops, ACPI handle corrupt in %s()\n", __func__);
-		return -EINVAL;
-	}
+	acpi_dev = to_acpi_device(ACPI_COMPANION(dev));
 
 	mutex_lock(&acpi_dev->physical_node_lock);
 
@@ -316,7 +308,7 @@ int acpi_unbind_one(struct device *dev)
 			acpi_physnode_link_name(physnode_name, entry->node_id);
 			sysfs_remove_link(&acpi_dev->dev.kobj, physnode_name);
 			sysfs_remove_link(&dev->kobj, "firmware_node");
-			ACPI_HANDLE_SET(dev, NULL);
+			ACPI_COMPANION_SET(dev, NULL);
 			/* acpi_bind_one() increase refcnt by one. */
 			put_device(dev);
 			kfree(entry);
@@ -328,6 +320,15 @@ int acpi_unbind_one(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(acpi_unbind_one);
 
+void acpi_preset_companion(struct device *dev, acpi_handle parent, u64 addr)
+{
+	struct acpi_device *adev;
+
+	if (!acpi_bus_get_device(acpi_get_child(parent, addr), &adev))
+		ACPI_COMPANION_SET(dev, &adev->dev);
+}
+EXPORT_SYMBOL_GPL(acpi_preset_companion);
+
 static int acpi_platform_notify(struct device *dev)
 {
 	struct acpi_bus_type *type = acpi_get_bus_type(dev);
Index: linux-pm/drivers/ata/libata-acpi.c
===================================================================
--- linux-pm.orig/drivers/ata/libata-acpi.c
+++ linux-pm/drivers/ata/libata-acpi.c
@@ -185,7 +185,7 @@ void ata_acpi_bind_port(struct ata_port
 	if (libata_noacpi || ap->flags & ATA_FLAG_ACPI_SATA || !host_handle)
 		return;
 
-	ACPI_HANDLE_SET(&ap->tdev, acpi_get_child(host_handle, ap->port_no));
+	acpi_preset_companion(&ap->tdev, host_handle, ap->port_no);
 
 	if (ata_acpi_gtm(ap, &ap->__acpi_init_gtm) == 0)
 		ap->pflags |= ATA_PFLAG_INIT_GTM_VALID;
@@ -222,7 +222,7 @@ void ata_acpi_bind_dev(struct ata_device
 		parent_handle = port_handle;
 	}
 
-	ACPI_HANDLE_SET(&dev->tdev, acpi_get_child(parent_handle, adr));
+	acpi_preset_companion(&dev->tdev, parent_handle, adr);
 
 	register_hotplug_dock_device(ata_dev_acpi_handle(dev),
 				     &ata_acpi_dev_dock_ops, dev, NULL, NULL);
Index: linux-pm/drivers/base/platform.c
===================================================================
--- linux-pm.orig/drivers/base/platform.c
+++ linux-pm/drivers/base/platform.c
@@ -432,7 +432,7 @@ struct platform_device *platform_device_
 		goto err_alloc;
 
 	pdev->dev.parent = pdevinfo->parent;
-	ACPI_HANDLE_SET(&pdev->dev, pdevinfo->acpi_node.handle);
+	ACPI_COMPANION_SET(&pdev->dev, pdevinfo->acpi_node.dev);
 
 	if (pdevinfo->dma_mask) {
 		/*
@@ -463,7 +463,7 @@ struct platform_device *platform_device_
 	ret = platform_device_add(pdev);
 	if (ret) {
 err:
-		ACPI_HANDLE_SET(&pdev->dev, NULL);
+		ACPI_COMPANION_SET(&pdev->dev, NULL);
 		kfree(pdev->dev.dma_mask);
 
 err_alloc:
Index: linux-pm/drivers/acpi/acpi_platform.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_platform.c
+++ linux-pm/drivers/acpi/acpi_platform.c
@@ -111,7 +111,7 @@ int acpi_create_platform_device(struct a
 	pdevinfo.id = -1;
 	pdevinfo.res = resources;
 	pdevinfo.num_res = count;
-	pdevinfo.acpi_node.handle = adev->handle;
+	pdevinfo.acpi_node.dev = &adev->dev;
 	pdev = platform_device_register_full(&pdevinfo);
 	if (IS_ERR(pdev)) {
 		dev_err(&adev->dev, "platform device creation failed: %ld\n",
Index: linux-pm/drivers/hid/i2c-hid/i2c-hid.c
===================================================================
--- linux-pm.orig/drivers/hid/i2c-hid/i2c-hid.c
+++ linux-pm/drivers/hid/i2c-hid/i2c-hid.c
@@ -1012,7 +1012,7 @@ static int i2c_hid_probe(struct i2c_clie
 	hid->hid_get_raw_report = i2c_hid_get_raw_report;
 	hid->hid_output_raw_report = i2c_hid_output_raw_report;
 	hid->dev.parent = &client->dev;
-	ACPI_HANDLE_SET(&hid->dev, ACPI_HANDLE(&client->dev));
+	ACPI_COMPANION_SET(&hid->dev, ACPI_COMPANION(&client->dev));
 	hid->bus = BUS_I2C;
 	hid->version = le16_to_cpu(ihid->hdesc.bcdVersion);
 	hid->vendor = le16_to_cpu(ihid->hdesc.wVendorID);
Index: linux-pm/drivers/i2c/i2c-core.c
===================================================================
--- linux-pm.orig/drivers/i2c/i2c-core.c
+++ linux-pm/drivers/i2c/i2c-core.c
@@ -674,7 +674,7 @@ i2c_new_device(struct i2c_adapter *adap,
 	client->dev.bus = &i2c_bus_type;
 	client->dev.type = &i2c_client_type;
 	client->dev.of_node = info->of_node;
-	ACPI_HANDLE_SET(&client->dev, info->acpi_node.handle);
+	ACPI_COMPANION_SET(&client->dev, info->acpi_node.dev);
 
 	/* For 10-bit clients, add an arbitrary offset to avoid collisions */
 	dev_set_name(&client->dev, "%d-%04x", i2c_adapter_id(adap),
@@ -1103,7 +1103,7 @@ static acpi_status acpi_i2c_add_device(a
 		return AE_OK;
 
 	memset(&info, 0, sizeof(info));
-	info.acpi_node.handle = handle;
+	info.acpi_node.dev = &adev->dev;
 	info.irq = -1;
 
 	INIT_LIST_HEAD(&resource_list);
Index: linux-pm/drivers/mmc/core/sdio_bus.c
===================================================================
--- linux-pm.orig/drivers/mmc/core/sdio_bus.c
+++ linux-pm/drivers/mmc/core/sdio_bus.c
@@ -305,8 +305,7 @@ static void sdio_acpi_set_handle(struct
 	struct mmc_host *host = func->card->host;
 	u64 addr = (host->slotno << 16) | func->num;
 
-	ACPI_HANDLE_SET(&func->dev,
-			acpi_get_child(ACPI_HANDLE(host->parent), addr));
+	acpi_preset_companion(&func->dev, ACPI_HANDLE(host->parent), addr);
 }
 #else
 static inline void sdio_acpi_set_handle(struct sdio_func *func) {}
Index: linux-pm/drivers/spi/spi.c
===================================================================
--- linux-pm.orig/drivers/spi/spi.c
+++ linux-pm/drivers/spi/spi.c
@@ -1024,7 +1024,7 @@ static acpi_status acpi_spi_add_device(a
 		return AE_NO_MEMORY;
 	}
 
-	ACPI_HANDLE_SET(&spi->dev, handle);
+	ACPI_COMPANION_SET(&spi->dev, &adev->dev);
 	spi->irq = -1;
 
 	INIT_LIST_HEAD(&resource_list);
Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -22,16 +22,12 @@
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
 
-#include <linux/device.h>
+#include <linux/acpi.h>
 #include <linux/export.h>
 #include <linux/mutex.h>
 #include <linux/pm_qos.h>
 #include <linux/pm_runtime.h>
 
-#include <acpi/acpi.h>
-#include <acpi/acpi_bus.h>
-#include <acpi/acpi_drivers.h>
-
 #include "internal.h"
 
 #define _COMPONENT	ACPI_POWER_COMPONENT

