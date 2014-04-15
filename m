Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbaDOSyC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 14:54:02 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:37156 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751012AbaDOSx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 14:53:59 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtINANh/TVNXQzum/2dsb2JhbABYgwaDUsBqAgKBJxd0glMTHCMYgQIkE4gAAcxljmOEPwEDjl+KAgGSRYMzOw
Date: Tue, 15 Apr 2014 20:55:52 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Bjorn <bhelgaas@google.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1]  Drivers/PCI: Logging clean-up [1]
Message-Id: <20140415205552.e358a533cf0632026f6bd342@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Convert printk(KERN_WARNING|KERN_ERR|KERN_INFO to pr_foo()
-Define pr_fmt where it doesn't break existing format.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/pci/bus.c                   |  4 +++-
 drivers/pci/hotplug-pci.c           |  4 ++--
 drivers/pci/hotplug/acpi_pcihp.c    | 17 +++++++---------
 drivers/pci/hotplug/cpqphp_core.c   |  5 +++--
 drivers/pci/hotplug/rpadlpar_core.c | 39 ++++++++++++++++---------------------
 drivers/pci/hotplug/sgi_hotplug.c   | 10 +++++-----
 drivers/pci/pci-stub.c              | 11 ++++-------
 drivers/pci/pci-sysfs.c             |  6 +++---
 drivers/pci/pci.c                   |  5 +++--
 drivers/pci/pcie/aer/aer_inject.c   |  8 +++-----
 drivers/pci/pcie/aspm.c             |  4 ++--
 drivers/pci/pcie/portdrv_pci.c      |  3 ++-
 drivers/pci/probe.c                 |  9 ++++-----
 drivers/pci/quirks.c                |  2 +-
 drivers/pci/slot.c                  |  3 ++-
 15 files changed, 61 insertions(+), 69 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index fb8aed3..a565452 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -7,6 +7,8 @@
  *	David Miller (davem@redhat.com)
  *	Ivan Kokshaysky (ink@jurassic.park.msu.ru)
  */
+#define pr_fmt(fmt) "PCI: " fmt
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
@@ -25,7 +27,7 @@ void pci_add_resource_offset(struct list_head *resources, struct resource *res,
 
 	window = kzalloc(sizeof(struct pci_host_bridge_window), GFP_KERNEL);
 	if (!window) {
-		printk(KERN_ERR "PCI: can't add host bridge window %pR\n", res);
+		pr_err("can't add host bridge window %pR\n", res);
 		return;
 	}
 
diff --git a/drivers/pci/hotplug-pci.c b/drivers/pci/hotplug-pci.c
index 6258dc2..c76dfd4 100644
--- a/drivers/pci/hotplug-pci.c
+++ b/drivers/pci/hotplug-pci.c
@@ -15,8 +15,8 @@ int __ref pci_hp_add_bridge(struct pci_dev *dev)
 			break;
 	}
 	if (busnr-- > end) {
-		printk(KERN_ERR "No bus number available for hot-added bridge %s\n",
-				pci_name(dev));
+		pr_err("No bus number available for hot-added bridge %s\n",
+		       pci_name(dev));
 		return -1;
 	}
 	for (pass = 0; pass < 2; pass++)
diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acpi_pcihp.c
index a94d850..90253ab 100644
--- a/drivers/pci/hotplug/acpi_pcihp.c
+++ b/drivers/pci/hotplug/acpi_pcihp.c
@@ -68,8 +68,7 @@ decode_type0_hpx_record(union acpi_object *record, struct hotplug_params *hpx)
 		hpx->t0->enable_perr     = fields[5].integer.value;
 		break;
 	default:
-		printk(KERN_WARNING
-		       "%s: Type 0 Revision %d record not supported\n",
+		pr_warn("%s: Type 0 Revision %d record not supported\n",
 		       __func__, revision);
 		return AE_ERROR;
 	}
@@ -97,9 +96,8 @@ decode_type1_hpx_record(union acpi_object *record, struct hotplug_params *hpx)
 		hpx->t1->tot_max_split = fields[4].integer.value;
 		break;
 	default:
-		printk(KERN_WARNING
-		       "%s: Type 1 Revision %d record not supported\n",
-		       __func__, revision);
+		pr_warn("%s: Type 1 Revision %d record not supported\n",
+			__func__, revision);
 		return AE_ERROR;
 	}
 	return AE_OK;
@@ -139,8 +137,7 @@ decode_type2_hpx_record(union acpi_object *record, struct hotplug_params *hpx)
 		hpx->t2->sec_unc_err_mask_or   = fields[17].integer.value;
 		break;
 	default:
-		printk(KERN_WARNING
-		       "%s: Type 2 Revision %d record not supported\n",
+		pr_warn("%s: Type 2 Revision %d record not supported\n",
 		       __func__, revision);
 		return AE_ERROR;
 	}
@@ -201,7 +198,7 @@ acpi_run_hpx(acpi_handle handle, struct hotplug_params *hpx)
 				goto exit;
 			break;
 		default:
-			printk(KERN_ERR "%s: Type %d record not supported\n",
+			pr_err("%s: Type %d record not supported\n",
 			       __func__, type);
 			status = AE_ERROR;
 			goto exit;
@@ -270,8 +267,8 @@ static acpi_status acpi_run_oshp(acpi_handle handle)
 	status = acpi_evaluate_object(handle, METHOD_NAME_OSHP, NULL, NULL);
 	if (ACPI_FAILURE(status))
 		if (status != AE_NOT_FOUND)
-			printk(KERN_ERR "%s:%s OSHP fails=0x%x\n",
-			       __func__, (char *)string.pointer, status);
+			pr_err("%s:%s OSHP fails=0x%x\n", __func__,
+			       (char *)string.pointer, status);
 		else
 			dbg("%s:%s OSHP not found\n",
 			    __func__, (char *)string.pointer);
diff --git a/drivers/pci/hotplug/cpqphp_core.c b/drivers/pci/hotplug/cpqphp_core.c
index 037e261..1795b9f 100644
--- a/drivers/pci/hotplug/cpqphp_core.c
+++ b/drivers/pci/hotplug/cpqphp_core.c
@@ -27,6 +27,7 @@
  * Jan 12, 2003 -	Added 66/100/133MHz PCI-X support,
  *			Torben Mathiasen <torben.mathiasen@hp.com>
  */
+#define pr_fmt(fmt) MY_NAME ": " fmt
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
@@ -830,8 +831,8 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = pci_enable_device(pdev);
 	if (err) {
-		printk(KERN_ERR MY_NAME ": cannot enable PCI device %s (%d)\n",
-			pci_name(pdev), err);
+		pr_err("cannot enable PCI device %s (%d)\n", pci_name(pdev),
+		       err);
 		return err;
 	}
 
diff --git a/drivers/pci/hotplug/rpadlpar_core.c b/drivers/pci/hotplug/rpadlpar_core.c
index 4fcdeed..82e9b7d 100644
--- a/drivers/pci/hotplug/rpadlpar_core.c
+++ b/drivers/pci/hotplug/rpadlpar_core.c
@@ -151,8 +151,8 @@ static void dlpar_pci_add_bus(struct device_node *dn)
 	/* Add EADS device to PHB bus, adding new entry to bus->devices */
 	dev = of_create_pci_dev(dn, phb->bus, pdn->devfn);
 	if (!dev) {
-		printk(KERN_ERR "%s: failed to create pci dev for %s\n",
-				__func__, dn->full_name);
+		pr_err("%s: failed to create pci dev for %s\n", __func__,
+		       dn->full_name);
 		return;
 	}
 
@@ -188,21 +188,20 @@ static int dlpar_add_pci_slot(char *drc_name, struct device_node *dn)
 	dev = dlpar_find_new_dev(phb->bus, dn);
 
 	if (!dev) {
-		printk(KERN_ERR "%s: unable to add bus %s\n", __func__,
-			drc_name);
+		pr_err("%s: unable to add bus %s\n", __func__, drc_name);
 		return -EIO;
 	}
 
 	if (dev->hdr_type != PCI_HEADER_TYPE_BRIDGE) {
-		printk(KERN_ERR "%s: unexpected header type %d, unable to add bus %s\n",
+		pr_err("%s: unexpected header type %d, unable to add bus %s\n",
 			__func__, dev->hdr_type, drc_name);
 		return -EIO;
 	}
 
 	/* Add hotplug slot */
 	if (rpaphp_add_slot(dn)) {
-		printk(KERN_ERR "%s: unable to add hotplug slot %s\n",
-			__func__, drc_name);
+		pr_err("%s: unable to add hotplug slot %s\n", __func__,
+		       drc_name);
 		return -EIO;
 	}
 	return 0;
@@ -220,8 +219,8 @@ static int dlpar_remove_phb(char *drc_name, struct device_node *dn)
 	/* If pci slot is hotpluggable, use hotplug to remove it */
 	slot = find_php_slot(dn);
 	if (slot && rpaphp_deregister_slot(slot)) {
-		printk(KERN_ERR "%s: unable to remove hotplug slot %s\n",
-		       __func__, drc_name);
+		pr_err("%s: unable to remove hotplug slot %s\n", __func__,
+		       drc_name);
 		return -EIO;
 	}
 
@@ -250,8 +249,8 @@ static int dlpar_add_phb(char *drc_name, struct device_node *dn)
 		return -EIO;
 
 	if (rpaphp_add_slot(dn)) {
-		printk(KERN_ERR "%s: unable to add hotplug slot %s\n",
-			__func__, drc_name);
+		pr_err("%s: unable to add hotplug slot %s\n", __func__,
+		       drc_name);
 		return -EIO;
 	}
 	return 0;
@@ -263,9 +262,8 @@ static int dlpar_add_vio_slot(char *drc_name, struct device_node *dn)
 		return -EINVAL;
 
 	if (!vio_register_device_node(dn)) {
-		printk(KERN_ERR
-			"%s: failed to register vio node %s\n",
-			__func__, drc_name);
+		pr_err("%s: failed to register vio node %s\n", __func__,
+		       drc_name);
 		return -EIO;
 	}
 	return 0;
@@ -311,7 +309,7 @@ int dlpar_add_slot(char *drc_name)
 			break;
 	}
 
-	printk(KERN_INFO "%s: slot %s added\n", DLPAR_MODULE_NAME, drc_name);
+	pr_info("%s: slot %s added\n", DLPAR_MODULE_NAME, drc_name);
 exit:
 	mutex_unlock(&rpadlpar_mutex);
 	return rc;
@@ -373,8 +371,7 @@ int dlpar_remove_pci_slot(char *drc_name, struct device_node *dn)
 			 pci_domain_nr(bus), bus->number);
 
 		if (rpaphp_deregister_slot(slot)) {
-			printk(KERN_ERR
-				"%s: unable to remove hotplug slot %s\n",
+			pr_err("%s: unable to remove hotplug slot %s\n",
 				__func__, drc_name);
 			ret = -EIO;
 			goto out;
@@ -386,8 +383,7 @@ int dlpar_remove_pci_slot(char *drc_name, struct device_node *dn)
 
 	/* Unmap PCI IO space */
 	if (pcibios_unmap_io_space(bus)) {
-		printk(KERN_ERR "%s: failed to unmap bus range\n",
-			__func__);
+		pr_err("%s: failed to unmap bus range\n", __func__);
 		ret = -ERANGE;
 		goto out;
 	}
@@ -442,7 +438,7 @@ int dlpar_remove_slot(char *drc_name)
 	}
 	vm_unmap_aliases();
 
-	printk(KERN_INFO "%s: slot %s removed\n", DLPAR_MODULE_NAME, drc_name);
+	pr_info("%s: slot %s removed\n", DLPAR_MODULE_NAME, drc_name);
 exit:
 	mutex_unlock(&rpadlpar_mutex);
 	return rc;
@@ -460,8 +456,7 @@ int __init rpadlpar_io_init(void)
 	int rc = 0;
 
 	if (!is_dlpar_capable()) {
-		printk(KERN_WARNING "%s: partition not DLPAR capable\n",
-			__func__);
+		pr_warn("%s: partition not DLPAR capable\n", __func__);
 		return -EPERM;
 	}
 
diff --git a/drivers/pci/hotplug/sgi_hotplug.c b/drivers/pci/hotplug/sgi_hotplug.c
index 613043f..b907c29 100644
--- a/drivers/pci/hotplug/sgi_hotplug.c
+++ b/drivers/pci/hotplug/sgi_hotplug.c
@@ -362,7 +362,7 @@ static int enable_slot(struct hotplug_slot *bss_hotplug_slot)
 
 		ret = acpi_load_table((struct acpi_table_header *)ssdt);
 		if (ACPI_FAILURE(ret)) {
-			printk(KERN_ERR "%s: acpi_load_table failed (0x%x)\n",
+			pr_err("%s: acpi_load_table failed (0x%x)\n",
 			       __func__, ret);
 			/* try to continue on */
 		}
@@ -447,7 +447,7 @@ static int enable_slot(struct hotplug_slot *bss_hotplug_slot)
 
 				ret = acpi_bus_scan(chandle);
 				if (ACPI_FAILURE(ret)) {
-					printk(KERN_ERR "%s: acpi_bus_scan "
+					pr_err("%s: acpi_bus_scan "
 					       "failed (0x%x) for slot %d "
 					       "func %d\n", __func__,
 					       ret, (int)(adr>>16),
@@ -561,7 +561,7 @@ static int disable_slot(struct hotplug_slot *bss_hotplug_slot)
 		acpi_status ret;
 		ret = acpi_unload_table_id(ssdt_id);
 		if (ACPI_FAILURE(ret)) {
-			printk(KERN_ERR "%s: acpi_unload_table_id "
+			pr_err("%s: acpi_unload_table_id "
 			       "failed (0x%x) for id %d\n",
 			       __func__, ret, ssdt_id);
 			/* try to continue on */
@@ -682,7 +682,7 @@ static int __init sn_pci_hotplug_init(void)
 	int registered = 0;
 
 	if (!sn_prom_feature_available(PRF_HOTPLUG_SUPPORT)) {
-		printk(KERN_ERR "%s: PROM version does not support hotplug.\n",
+		pr_err("%s: PROM version does not support hotplug.\n",
 		       __func__);
 		return -EPERM;
 	}
@@ -720,7 +720,7 @@ static void __exit sn_pci_hotplug_exit(void)
 		pci_hp_deregister(bss_hotplug_slot);
 
 	if (!list_empty(&sn_hp_list))
-		printk(KERN_ERR "%s: internal list is not empty\n", __FILE__);
+		pr_err("%s: internal list is not empty\n", __FILE__);
 }
 
 module_init(sn_pci_hotplug_init);
diff --git a/drivers/pci/pci-stub.c b/drivers/pci/pci-stub.c
index 2ff7750..1f46ae5 100644
--- a/drivers/pci/pci-stub.c
+++ b/drivers/pci/pci-stub.c
@@ -15,7 +15,7 @@
  * # ls -l /sys/bus/pci/devices/0000:00:19.0/driver
  * .../0000:00:19.0/driver -> ../../../bus/pci/drivers/pci-stub
  */
-
+#define pr_fmt(fmt) "pci-stub: " fmt
 #include <linux/module.h>
 #include <linux/pci.h>
 
@@ -66,20 +66,17 @@ static int __init pci_stub_init(void)
 				&class, &class_mask);
 
 		if (fields < 2) {
-			printk(KERN_WARNING
-			       "pci-stub: invalid id string \"%s\"\n", id);
+			pr_warn("invalid id string \"%s\"\n", id);
 			continue;
 		}
 
-		printk(KERN_INFO
-		       "pci-stub: add %04X:%04X sub=%04X:%04X cls=%08X/%08X\n",
+		pr_info("add %04X:%04X sub=%04X:%04X cls=%08X/%08X\n",
 		       vendor, device, subvendor, subdevice, class, class_mask);
 
 		rc = pci_add_dynid(&stub_driver, vendor, device,
 				   subvendor, subdevice, class, class_mask, 0);
 		if (rc)
-			printk(KERN_WARNING
-			       "pci-stub: failed to add dynamic id (%d)\n", rc);
+			pr_warn("failed to add dynamic id (%d)\n", rc);
 	}
 
 	return 0;
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 4e0acef..6afd1ef 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -14,7 +14,7 @@
  *
  */
 
-
+#define pr_fmt(fmt) "PCI: " fmt
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/pci.h>
@@ -903,8 +903,8 @@ legacy_io_err:
 	kfree(b->legacy_io);
 	b->legacy_io = NULL;
 kzalloc_err:
-	printk(KERN_WARNING "pci: warning: could not create legacy I/O port "
-	       "and ISA memory resources to sysfs\n");
+	pr_warn("warning: could not create legacy I/O port "
+		"and ISA memory resources to sysfs\n");
 	return;
 }
 
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 7325d43..f25e152 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -6,6 +6,7 @@
  *
  *	Copyright 1997 -- 2000 Martin Mares <mj@ucw.cz>
  */
+#define pr_fmt(fmt) "PCI: " fmt
 
 #include <linux/kernel.h>
 #include <linux/delay.h>
@@ -4203,7 +4204,7 @@ static resource_size_t pci_specified_resource_alignment(struct pci_dev *dev)
 			if (sscanf(p, "%x:%x.%x%n",
 					&bus, &slot, &func, &count) != 3) {
 				/* Invalid format */
-				printk(KERN_ERR "PCI: Can't parse resource_alignment parameter: %s\n",
+				pr_err("PCI: Can't parse resource_alignment parameter: %s\n",
 					p);
 				break;
 			}
@@ -4405,7 +4406,7 @@ static int __init pci_setup(char *str)
 			} else if (!strncmp(str, "pcie_scan_all", 13)) {
 				pci_add_flags(PCI_SCAN_ALL_PCIE_DEVS);
 			} else {
-				printk(KERN_ERR "PCI: Unknown option `%s'\n",
+				pr_err("PCI: Unknown option `%s'\n",
 						str);
 			}
 		}
diff --git a/drivers/pci/pcie/aer/aer_inject.c b/drivers/pci/pcie/aer/aer_inject.c
index 587e7e8..ff69275 100644
--- a/drivers/pci/pcie/aer/aer_inject.c
+++ b/drivers/pci/pcie/aer/aer_inject.c
@@ -397,16 +397,14 @@ static int aer_inject(struct aer_error_inj *einj)
 	if (!aer_mask_override && einj->cor_status &&
 	    !(einj->cor_status & ~cor_mask)) {
 		ret = -EINVAL;
-		printk(KERN_WARNING "The correctable error(s) is masked "
-				"by device\n");
+		pr_warn("The correctable error(s) is masked by device\n");
 		spin_unlock_irqrestore(&inject_lock, flags);
 		goto out_put;
 	}
 	if (!aer_mask_override && einj->uncor_status &&
 	    !(einj->uncor_status & ~uncor_mask)) {
 		ret = -EINVAL;
-		printk(KERN_WARNING "The uncorrectable error(s) is masked "
-				"by device\n");
+		pr_warn("The uncorrectable error(s) is masked by device\n");
 		spin_unlock_irqrestore(&inject_lock, flags);
 		goto out_put;
 	}
@@ -459,7 +457,7 @@ static int aer_inject(struct aer_error_inj *einj)
 
 	if (find_aer_device(rpdev, &edev)) {
 		if (!get_service_data(edev)) {
-			printk(KERN_WARNING "AER service is not initialized\n");
+			pr_warn("AER service is not initialized\n");
 			ret = -EINVAL;
 			goto out_put;
 		}
diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index e1e7026..c6075da 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -960,10 +960,10 @@ static int __init pcie_aspm_disable(char *str)
 		aspm_policy = POLICY_DEFAULT;
 		aspm_disabled = 1;
 		aspm_support_enabled = false;
-		printk(KERN_INFO "PCIe ASPM is disabled\n");
+		pr_info("PCIe ASPM is disabled\n");
 	} else if (!strcmp(str, "force")) {
 		aspm_force = 1;
-		printk(KERN_INFO "PCIe ASPM is forcibly enabled\n");
+		pr_info("PCIe ASPM is forcibly enabled\n");
 	}
 	return 1;
 }
diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index 0d8fdc4..b526d24 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2004 Intel
  * Copyright (C) Tom Long Nguyen (tom.l.nguyen@intel.com)
  */
+#define pr_fmt(fmt) "PCIE: " fmt
 
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -429,7 +430,7 @@ static int __init pcie_portdrv_init(void)
 
 	retval = pcie_port_bus_register();
 	if (retval) {
-		printk(KERN_WARNING "PCIE: bus_register error: %d\n", retval);
+		pr_warn("bus_register error: %d\n", retval);
 		goto out;
 	}
 	retval = pci_register_driver(&pcie_portdriver);
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index ef09f5f..22b441b 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1258,10 +1258,9 @@ bool pci_bus_read_dev_vendor_id(struct pci_bus *bus, int devfn, u32 *l,
 			return false;
 		/* Card hasn't responded in 60 seconds?  Must be stuck. */
 		if (delay > crs_timeout) {
-			printk(KERN_WARNING "pci %04x:%02x:%02x.%d: not "
-					"responding\n", pci_domain_nr(bus),
-					bus->number, PCI_SLOT(devfn),
-					PCI_FUNC(devfn));
+			pr_warn("pci %04x:%02x:%02x.%d: not responding\n",
+				pci_domain_nr(bus), bus->number,
+				PCI_SLOT(devfn), PCI_FUNC(devfn));
 			return false;
 		}
 	}
@@ -1772,7 +1771,7 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	if (parent)
 		dev_info(parent, "PCI host bridge to bus %s\n", dev_name(&b->dev));
 	else
-		printk(KERN_INFO "PCI host bridge to bus %s\n", dev_name(&b->dev));
+		pr_info("PCI host bridge to bus %s\n", dev_name(&b->dev));
 
 	/* Add initial resources to the bus */
 	list_for_each_entry_safe(window, n, resources, list) {
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e729206..bd48bae 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2308,7 +2308,7 @@ static void nvbridge_check_legacy_irq_routing(struct pci_dev *dev)
 	pci_read_config_dword(dev, 0x74, &cfg);
 
 	if (cfg & ((1 << 2) | (1 << 15))) {
-		printk(KERN_INFO "Rewriting irq routing register on MCP55\n");
+		pr_info("Rewriting irq routing register on MCP55\n");
 		cfg &= ~((1 << 2) | (1 << 15));
 		pci_write_config_dword(dev, 0x74, cfg);
 	}
diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index 396c200..f5dc156 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2006-2009 Hewlett-Packard Development Company, L.P.
  *	Alex Chiang <achiang@hp.com>
  */
+#define pr_fmt(fmt) "PCI: " fmt
 
 #include <linux/kobject.h>
 #include <linux/slab.h>
@@ -388,7 +389,7 @@ static int pci_slot_init(void)
 	pci_slots_kset = kset_create_and_add("slots", NULL,
 						&pci_bus_kset->kobj);
 	if (!pci_slots_kset) {
-		printk(KERN_ERR "PCI: Slot initialization failure\n");
+		pr_err("Slot initialization failure\n");
 		return -ENOMEM;
 	}
 	return 0;
-- 
1.8.4.5

