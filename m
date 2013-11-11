Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab3KKNdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:33:31 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61606 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753508Ab3KKNdN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:33:13 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] ACPI / driver core: Store a device pointer in struct acpi_dev_node
Date: Mon, 11 Nov 2013 14:45:39 +0100
Message-ID: <1683079.zjqzsOAjXB@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <52803124.7000304@intel.com>
References: <3268437.YsusHvklcv@vostro.rjw.lan> <52803124.7000304@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 11, 2013 09:21:40 AM Lan Tianyu wrote:
> On 2013年11月10日 08:58, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Modify struct acpi_dev_node to contain a pointer to struct device
> > ambedded in the struct acpi_device associated with the given device
> > object (that is, its ACPI companion device) instead of an ACPI handle
> > corresponding to that struct acpi_device.  Introduce two new macros
> > for manipulating that pointer in a CONFIG_ACPI-safe way,
> > ACPI_COMPANION() and ACPI_COMPANION_SET(), and rework the
> > ACPI_HANDLE() macro to take the above changes into account.
> > Drop the ACPI_HANDLE_SET() macro entirely and rework its users to
> > use ACPI_COMPANION_SET() instead.  For some of them who used to
> > pass the result of acpi_get_child() directly to ACPI_HANDLE_SET()
> > introduce a helper routine acpi_preset_companion() doing an
> > equivalent thing.
> > 
> > The rationale for using a struct device pointer instead of a
> > struct acpi_device one as the member of struct acpi_dev_node is
> > that it allows device.h to avoid including linux/acpi.h which would
> > introduce quite a bit of compilation overhead for stuff that doesn't
> > care about ACPI.
> > In turn, moving the macros to linux/acpi.h forces
> > the stuff that does care about ACPI to include that file as
> > appropriate anyway.
> 
> How about declaring "struct acpi_device" in the device.h? This can help
> to use struct acpi_device without including linux/acpi.h.
> 
> struct iommu_ops and struct iommu_group have been used by the same way
> in the device.h.

Yes, they are.  Well, that appears to work too.

Updated patch is appended.  It also contains some fixes for problems reported
by the auto build system and it's been tested on x86-64 now, so it should be
reasonably close to final.

Thanks,
Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / driver core: Store an ACPI device pointer in struct acpi_dev_node

Modify struct acpi_dev_node to contain a pointer to struct acpi_device
associated with the given device object (that is, its ACPI companion
device) instead of an ACPI handle corresponding to it.  Introduce two
new macros for manipulating that pointer in a CONFIG_ACPI-safe way,
ACPI_COMPANION() and ACPI_COMPANION_SET(), and rework the
ACPI_HANDLE() macro to take the above changes into account.
Drop the ACPI_HANDLE_SET() macro entirely and rework its users to
use ACPI_COMPANION_SET() instead.  For some of them who used to
pass the result of acpi_get_child() directly to ACPI_HANDLE_SET()
introduce a helper routine acpi_preset_companion() doing an
equivalent thing.

The main motivation for doing this is that there are things
represented by struct acpi_device objects that don't have valid
ACPI handles (so called fixed ACPI hardware features, such as
power and sleep buttons) and we would like to create platform
device objects for them and "glue" them to their ACPI companions
in the usual way (which currently is impossible due to the
lack of valid ACPI handles).  However, there are more reasons
why it may be useful.

First, struct acpi_device pointers allow of much better type checking
than void pointers which are ACPI handles, so it should be more
difficult to write buggy code using modified struct acpi_dev_node
and the new macros.  Second, the change should help to reduce (over
time) the number of places in which the result of ACPI_HANDLE() is
passed to acpi_bus_get_device() in order to obtain a pointer to the
struct acpi_device associated with the given "physical" device,
because now that pointer is returned by ACPI_COMPANION() directly.
Finally, the change should make it easier to write generic code that
will build both for CONFIG_ACPI set and unset without adding explicit
compiler directives to it.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 arch/ia64/hp/common/sba_iommu.c              |    2 -
 arch/ia64/include/asm/pci.h                  |    2 -
 arch/ia64/pci/pci.c                          |    6 +--
 arch/ia64/sn/kernel/io_acpi_init.c           |    4 +-
 arch/x86/include/asm/pci.h                   |    2 -
 arch/x86/pci/acpi.c                          |    4 +-
 drivers/acpi/acpi_platform.c                 |    2 -
 drivers/acpi/device_pm.c                     |    6 ---
 drivers/acpi/glue.c                          |   47 +++++++++++++--------------
 drivers/ata/libata-acpi.c                    |    4 +-
 drivers/base/platform.c                      |    4 +-
 drivers/gpu/drm/radeon/radeon_atpx_handler.c |    3 -
 drivers/hid/i2c-hid/i2c-hid.c                |    2 -
 drivers/i2c/i2c-core.c                       |    4 +-
 drivers/ide/ide-acpi.c                       |    3 -
 drivers/mmc/core/sdio_bus.c                  |    3 -
 drivers/pci/hotplug/sgi_hotplug.c            |    4 +-
 drivers/spi/spi.c                            |    2 -
 include/acpi/acpi_bus.h                      |    2 -
 include/linux/acpi.h                         |   15 ++++++++
 include/linux/device.h                       |   12 +-----
 21 files changed, 67 insertions(+), 66 deletions(-)

Index: linux-pm/include/linux/device.h
===================================================================
--- linux-pm.orig/include/linux/device.h
+++ linux-pm/include/linux/device.h
@@ -623,9 +623,11 @@ struct device_dma_parameters {
 	unsigned long segment_boundary_mask;
 };
 
+struct acpi_device;
+
 struct acpi_dev_node {
 #ifdef CONFIG_ACPI
-	void	*handle;
+	struct acpi_device *companion;
 #endif
 };
 
@@ -769,14 +771,6 @@ static inline struct device *kobj_to_dev
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
@@ -44,6 +44,15 @@
 #include <acpi/acpi_numa.h>
 #include <asm/acpi.h>
 
+static inline acpi_handle acpi_device_handle(struct acpi_device *adev)
+{
+	return adev ? adev->handle : NULL;
+}
+
+#define ACPI_COMPANION(dev)		((dev)->acpi_node.companion)
+#define ACPI_COMPANION_SET(dev, adev)	ACPI_COMPANION(dev) = (adev)
+#define ACPI_HANDLE(dev)		acpi_device_handle(ACPI_COMPANION(dev))
+
 enum acpi_irq_model_id {
 	ACPI_IRQ_MODEL_PIC = 0,
 	ACPI_IRQ_MODEL_IOAPIC,
@@ -407,6 +416,10 @@ static inline bool acpi_driver_match_dev
 
 #define acpi_disabled 1
 
+#define ACPI_COMPANION(dev)		(NULL)
+#define ACPI_COMPANION_SET(dev, adev)	do { } while (0)
+#define ACPI_HANDLE(dev)		(NULL)
+
 static inline void acpi_early_init(void) { }
 
 static inline int early_acpi_boot_init(void)
@@ -475,6 +488,8 @@ static inline bool acpi_driver_match_dev
 
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
+	struct acpi_device *companion;
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
+	controller->companion = device;
 
-	pxm = acpi_get_pxm(controller->acpi_handle);
+	pxm = acpi_get_pxm(device->handle);
 #ifdef CONFIG_NUMA
 	if (pxm >= 0)
 		controller->node = pxm_to_node(pxm);
@@ -489,7 +489,7 @@ int pcibios_root_bridge_prepare(struct p
 {
 	struct pci_controller *controller = bridge->bus->sysdata;
 
-	ACPI_HANDLE_SET(&bridge->dev, controller->acpi_handle);
+	ACPI_COMPANION_SET(&bridge->dev, controller->companion);
 	return 0;
 }
 
Index: linux-pm/arch/ia64/hp/common/sba_iommu.c
===================================================================
--- linux-pm.orig/arch/ia64/hp/common/sba_iommu.c
+++ linux-pm/arch/ia64/hp/common/sba_iommu.c
@@ -1992,7 +1992,7 @@ sba_connect_bus(struct pci_bus *bus)
 	if (PCI_CONTROLLER(bus)->iommu)
 		return;
 
-	handle = PCI_CONTROLLER(bus)->acpi_handle;
+	handle = acpi_device_handle(PCI_CONTROLLER(bus)->companion);
 	if (!handle)
 		return;
 
Index: linux-pm/arch/ia64/sn/kernel/io_acpi_init.c
===================================================================
--- linux-pm.orig/arch/ia64/sn/kernel/io_acpi_init.c
+++ linux-pm/arch/ia64/sn/kernel/io_acpi_init.c
@@ -132,7 +132,7 @@ sn_get_bussoft_ptr(struct pci_bus *bus)
 	struct acpi_resource_vendor_typed *vendor;
 
 
-	handle = PCI_CONTROLLER(bus)->acpi_handle;
+	handle = acpi_device_handle(PCI_CONTROLLER(bus)->companion);
 	status = acpi_get_vendor_resource(handle, METHOD_NAME__CRS,
 					  &sn_uuid, &buffer);
 	if (ACPI_FAILURE(status)) {
@@ -360,7 +360,7 @@ sn_acpi_get_pcidev_info(struct pci_dev *
 	acpi_status status;
 	struct acpi_buffer name_buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 
-	rootbus_handle = PCI_CONTROLLER(dev)->acpi_handle;
+	rootbus_handle = acpi_device_handle(PCI_CONTROLLER(dev)->companion);
         status = acpi_evaluate_integer(rootbus_handle, METHOD_NAME__SEG, NULL,
                                        &segment);
         if (ACPI_SUCCESS(status)) {
Index: linux-pm/arch/x86/include/asm/pci.h
===================================================================
--- linux-pm.orig/arch/x86/include/asm/pci.h
+++ linux-pm/arch/x86/include/asm/pci.h
@@ -15,7 +15,7 @@ struct pci_sysdata {
 	int		domain;		/* PCI domain */
 	int		node;		/* NUMA node */
 #ifdef CONFIG_ACPI
-	void		*acpi;		/* ACPI-specific data */
+	struct acpi_device *companion;	/* ACPI companion device */
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
+	sd->companion = device;
 	/*
 	 * Maybe the desired pci bus has been already scanned. In such case
 	 * it is unnecessary to scan the pci bus with the given domain,busnum.
@@ -589,7 +589,7 @@ int pcibios_root_bridge_prepare(struct p
 {
 	struct pci_sysdata *sd = bridge->bus->sysdata;
 
-	ACPI_HANDLE_SET(&bridge->dev, sd->acpi);
+	ACPI_COMPANION_SET(&bridge->dev, sd->companion);
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
+			acpi_dev = ACPI_COMPANION(dev);
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
+			if (ACPI_COMPANION(dev) != acpi_dev)
 				goto err;
 
 			put_device(dev);
@@ -259,8 +256,8 @@ int acpi_bind_one(struct device *dev, ac
 	list_add(&physical_node->node, physnode_list);
 	acpi_dev->physical_node_count++;
 
-	if (!ACPI_HANDLE(dev))
-		ACPI_HANDLE_SET(dev, acpi_dev->handle);
+	if (!ACPI_COMPANION(dev))
+		ACPI_COMPANION_SET(dev, acpi_dev);
 
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
@@ -291,19 +288,12 @@ EXPORT_SYMBOL_GPL(acpi_bind_one);
 
 int acpi_unbind_one(struct device *dev)
 {
+	struct acpi_device *acpi_dev = ACPI_COMPANION(dev);
 	struct acpi_device_physical_node *entry;
-	struct acpi_device *acpi_dev;
-	acpi_status status;
 
-	if (!ACPI_HANDLE(dev))
+	if (!acpi_dev)
 		return 0;
 
-	status = acpi_bus_get_device(ACPI_HANDLE(dev), &acpi_dev);
-	if (ACPI_FAILURE(status)) {
-		dev_err(dev, "Oops, ACPI handle corrupt in %s()\n", __func__);
-		return -EINVAL;
-	}
-
 	mutex_lock(&acpi_dev->physical_node_lock);
 
 	list_for_each_entry(entry, &acpi_dev->physical_node_list, node)
@@ -316,7 +306,7 @@ int acpi_unbind_one(struct device *dev)
 			acpi_physnode_link_name(physnode_name, entry->node_id);
 			sysfs_remove_link(&acpi_dev->dev.kobj, physnode_name);
 			sysfs_remove_link(&dev->kobj, "firmware_node");
-			ACPI_HANDLE_SET(dev, NULL);
+			ACPI_COMPANION_SET(dev, NULL);
 			/* acpi_bind_one() increase refcnt by one. */
 			put_device(dev);
 			kfree(entry);
@@ -328,6 +318,15 @@ int acpi_unbind_one(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(acpi_unbind_one);
 
+void acpi_preset_companion(struct device *dev, acpi_handle parent, u64 addr)
+{
+	struct acpi_device *adev;
+
+	if (!acpi_bus_get_device(acpi_get_child(parent, addr), &adev))
+		ACPI_COMPANION_SET(dev, adev);
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
+	ACPI_COMPANION_SET(&pdev->dev, pdevinfo->acpi_node.companion);
 
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
+	pdevinfo.acpi_node.companion = adev;
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
+	ACPI_COMPANION_SET(&client->dev, info->acpi_node.companion);
 
 	/* For 10-bit clients, add an arbitrary offset to avoid collisions */
 	dev_set_name(&client->dev, "%d-%04x", i2c_adapter_id(adap),
@@ -1103,7 +1103,7 @@ static acpi_status acpi_i2c_add_device(a
 		return AE_OK;
 
 	memset(&info, 0, sizeof(info));
-	info.acpi_node.handle = handle;
+	info.acpi_node.companion = adev;
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
+	ACPI_COMPANION_SET(&spi->dev, adev);
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
Index: linux-pm/drivers/ide/ide-acpi.c
===================================================================
--- linux-pm.orig/drivers/ide/ide-acpi.c
+++ linux-pm/drivers/ide/ide-acpi.c
@@ -7,6 +7,7 @@
  * Copyright (C) 2006 Hannes Reinecke
  */
 
+#include <linux/acpi.h>
 #include <linux/ata.h>
 #include <linux/delay.h>
 #include <linux/device.h>
@@ -19,8 +20,6 @@
 #include <linux/dmi.h>
 #include <linux/module.h>
 
-#include <acpi/acpi_bus.h>
-
 #define REGS_PER_GTF		7
 
 struct GTM_buffer {
Index: linux-pm/drivers/pci/hotplug/sgi_hotplug.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/sgi_hotplug.c
+++ linux-pm/drivers/pci/hotplug/sgi_hotplug.c
@@ -9,6 +9,7 @@
  * Work to add BIOS PROM support was completed by Mike Habeck.
  */
 
+#include <linux/acpi.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -29,7 +30,6 @@
 #include <asm/sn/sn_feature_sets.h>
 #include <asm/sn/sn_sal.h>
 #include <asm/sn/types.h>
-#include <linux/acpi.h>
 #include <asm/sn/acpi.h>
 
 #include "../pci.h"
@@ -414,7 +414,7 @@ static int enable_slot(struct hotplug_sl
 		acpi_handle rethandle;
 		acpi_status ret;
 
-		phandle = PCI_CONTROLLER(slot->pci_bus)->acpi_handle;
+		phandle = acpi_device_handle(PCI_CONTROLLER(slot->pci_bus)->companion);
 
 		if (acpi_bus_get_device(phandle, &pdevice)) {
 			dev_dbg(&slot->pci_bus->self->dev,
Index: linux-pm/drivers/gpu/drm/radeon/radeon_atpx_handler.c
===================================================================
--- linux-pm.orig/drivers/gpu/drm/radeon/radeon_atpx_handler.c
+++ linux-pm/drivers/gpu/drm/radeon/radeon_atpx_handler.c
@@ -8,8 +8,7 @@
  */
 #include <linux/vga_switcheroo.h>
 #include <linux/slab.h>
-#include <acpi/acpi.h>
-#include <acpi/acpi_bus.h>
+#include <linux/acpi.h>
 #include <linux/pci.h>
 
 #include "radeon_acpi.h"

