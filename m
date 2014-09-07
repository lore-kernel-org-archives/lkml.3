Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbaIGSDp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 14:03:45 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:64003 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183AbaIGSDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 14:03:43 -0400
Date: Sun, 7 Sep 2014 20:03:32 +0200
From: Quentin Lambert <lambert.quentin@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Scott Murray <scott@spiteful.org>
Cc: linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] PCI: remove assignement from if conditions
Message-ID: <20140907180332.GA12411@greed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following Coccinelle semantic patch was used to
find and correct cases of assignements in if conditions:

@@
expression var, expr;
statement S;
@@

+ var = expr;
  if(
- (var = expr)
+ var
  ) S

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
---
 drivers/pci/hotplug/acpi_pcihp.c        |  3 ++-
 drivers/pci/hotplug/cpci_hotplug_core.c |  9 ++++++---
 drivers/pci/hotplug/cpcihp_zt5550.c     |  5 +++--
 drivers/pci/hotplug/ibmphp_core.c       | 15 ++++++++++-----
 drivers/pci/hotplug/ibmphp_pci.c        |  6 ++++--
 drivers/pci/hotplug/ibmphp_res.c        | 30 +++++++++++++++++++++---------
 drivers/pci/hotplug/shpchp_ctrl.c       | 12 ++++++++----
 drivers/pci/hotplug/shpchp_hpc.c        |  3 ++-
 drivers/pci/pci.c                       | 13 ++++++++++---
 9 files changed, 66 insertions(+), 30 deletions(-)

diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acpi_pcihp.c
index a94d850..2cac548 100644
--- a/drivers/pci/hotplug/acpi_pcihp.c
+++ b/drivers/pci/hotplug/acpi_pcihp.c
@@ -433,7 +433,8 @@ int acpi_pci_check_ejectable(struct pci_bus *pbus, acpi_handle handle)
 {
 	acpi_handle bridge_handle, parent_handle;
 
-	if (!(bridge_handle = acpi_pci_get_bridge_handle(pbus)))
+	bridge_handle = acpi_pci_get_bridge_handle(pbus);
+	if (!bridge_handle)
 		return 0;
 	if ((ACPI_FAILURE(acpi_get_parent(handle, &parent_handle))))
 		return 0;
diff --git a/drivers/pci/hotplug/cpci_hotplug_core.c b/drivers/pci/hotplug/cpci_hotplug_core.c
index 8359e29..a5a7fd8 100644
--- a/drivers/pci/hotplug/cpci_hotplug_core.c
+++ b/drivers/pci/hotplug/cpci_hotplug_core.c
@@ -125,7 +125,8 @@ disable_slot(struct hotplug_slot *hotplug_slot)
 
 	/* Unconfigure device */
 	dbg("%s - unconfiguring slot %s", __func__, slot_name(slot));
-	if ((retval = cpci_unconfigure_slot(slot))) {
+	retval = cpci_unconfigure_slot(slot);
+	if (retval) {
 		err("%s - could not unconfigure slot %s",
 		    __func__, slot_name(slot));
 		goto disable_error;
@@ -141,9 +142,11 @@ disable_slot(struct hotplug_slot *hotplug_slot)
 	}
 	cpci_led_on(slot);
 
-	if (controller->ops->set_power)
-		if ((retval = controller->ops->set_power(slot, 0)))
+	if (controller->ops->set_power) {
+		retval = controller->ops->set_power(slot, 0);
+		if (retval)
 			goto disable_error;
+	}
 
 	if (update_adapter_status(slot->hotplug_slot, 0))
 		warn("failure to update adapter file");
diff --git a/drivers/pci/hotplug/cpcihp_zt5550.c b/drivers/pci/hotplug/cpcihp_zt5550.c
index cfd01e9..7ecf34e 100644
--- a/drivers/pci/hotplug/cpcihp_zt5550.c
+++ b/drivers/pci/hotplug/cpcihp_zt5550.c
@@ -237,8 +237,9 @@ static int zt5550_hc_init_one (struct pci_dev *pdev, const struct pci_device_id
 	dbg("registered controller");
 
 	/* Look for first device matching cPCI bus's bridge vendor and device IDs */
-	if (!(bus0_dev = pci_get_device(PCI_VENDOR_ID_DEC,
-					 PCI_DEVICE_ID_DEC_21154, NULL))) {
+	bus0_dev = pci_get_device(PCI_VENDOR_ID_DEC,
+				  PCI_DEVICE_ID_DEC_21154, NULL);
+	if (!bus0_dev) {
 		status = -ENODEV;
 		goto init_register_error;
 	}
diff --git a/drivers/pci/hotplug/ibmphp_core.c b/drivers/pci/hotplug/ibmphp_core.c
index cfe2afe..3efaf4c 100644
--- a/drivers/pci/hotplug/ibmphp_core.c
+++ b/drivers/pci/hotplug/ibmphp_core.c
@@ -1023,7 +1023,8 @@ static int enable_slot(struct hotplug_slot *hs)
 	debug("ENABLING SLOT........\n");
 	slot_cur = hs->private;
 
-	if ((rc = validate(slot_cur, ENABLE))) {
+	rc = validate(slot_cur, ENABLE);
+	if (rc) {
 		err("validate function failed\n");
 		goto error_nopower;
 	}
@@ -1335,17 +1336,20 @@ static int __init ibmphp_init(void)
 	for (i = 0; i < 16; i++)
 		irqs[i] = 0;
 
-	if ((rc = ibmphp_access_ebda()))
+	rc = ibmphp_access_ebda();
+	if (rc)
 		goto error;
 	debug("after ibmphp_access_ebda()\n");
 
-	if ((rc = ibmphp_rsrc_init()))
+	rc = ibmphp_rsrc_init();
+	if (rc)
 		goto error;
 	debug("AFTER Resource & EBDA INITIALIZATIONS\n");
 
 	max_slots = get_max_slots();
 
-	if ((rc = ibmphp_register_pci()))
+	rc = ibmphp_register_pci();
+	if (rc)
 		goto error;
 
 	if (init_ops()) {
@@ -1354,7 +1358,8 @@ static int __init ibmphp_init(void)
 	}
 
 	ibmphp_print_test();
-	if ((rc = ibmphp_hpc_start_poll_thread()))
+	rc = ibmphp_hpc_start_poll_thread();
+	if (rc)
 		goto error;
 
 exit:
diff --git a/drivers/pci/hotplug/ibmphp_pci.c b/drivers/pci/hotplug/ibmphp_pci.c
index 2fd2967..814cea2 100644
--- a/drivers/pci/hotplug/ibmphp_pci.c
+++ b/drivers/pci/hotplug/ibmphp_pci.c
@@ -145,7 +145,8 @@ int ibmphp_configure_card (struct pci_func *func, u8 slotno)
 				case PCI_HEADER_TYPE_NORMAL:
 					debug ("single device case.... vendor id = %x, hdr_type = %x, class = %x\n", vendor_id, hdr_type, class);
 					assign_alt_irq (cur_func, class_code);
-					if ((rc = configure_device (cur_func)) < 0) {
+					rc = configure_device(cur_func);
+					if (rc < 0) {
 						/* We need to do this in case some other BARs were properly inserted */
 						err ("was not able to configure devfunc %x on bus %x.\n",
 						     cur_func->device, cur_func->busno);
@@ -157,7 +158,8 @@ int ibmphp_configure_card (struct pci_func *func, u8 slotno)
 					break;
 				case PCI_HEADER_TYPE_MULTIDEVICE:
 					assign_alt_irq (cur_func, class_code);
-					if ((rc = configure_device (cur_func)) < 0) {
+					rc = configure_device(cur_func);
+					if (rc < 0) {
 						/* We need to do this in case some other BARs were properly inserted */
 						err ("was not able to configure devfunc %x on bus %x...bailing out\n",
 						     cur_func->device, cur_func->busno);
diff --git a/drivers/pci/hotplug/ibmphp_res.c b/drivers/pci/hotplug/ibmphp_res.c
index f34745a..e07f34e 100644
--- a/drivers/pci/hotplug/ibmphp_res.c
+++ b/drivers/pci/hotplug/ibmphp_res.c
@@ -224,7 +224,8 @@ int __init ibmphp_rsrc_init (void)
 			if ((curr->rsrc_type & RESTYPE) == MMASK) {
 				/* no bus structure exists in place yet */
 				if (list_empty (&gbuses)) {
-					if ((rc = alloc_bus_range (&newbus, &newrange, curr, MEM, 1)))
+					rc = alloc_bus_range(&newbus, &newrange, curr, MEM, 1);
+					if (rc)
 						return rc;
 					list_add_tail (&newbus->bus_list, &gbuses);
 					debug ("gbuses = NULL, Memory Primary Bus %x [%x - %x]\n", newbus->busno, newrange->start, newrange->end);
@@ -237,7 +238,8 @@ int __init ibmphp_rsrc_init (void)
 							return rc;
 					} else {
 						/* went through all the buses and didn't find ours, need to create a new bus node */
-						if ((rc = alloc_bus_range (&newbus, &newrange, curr, MEM, 1)))
+						rc = alloc_bus_range(&newbus, &newrange, curr, MEM, 1);
+						if (rc)
 							return rc;
 
 						list_add_tail (&newbus->bus_list, &gbuses);
@@ -248,7 +250,8 @@ int __init ibmphp_rsrc_init (void)
 				/* prefetchable memory */
 				if (list_empty (&gbuses)) {
 					/* no bus structure exists in place yet */
-					if ((rc = alloc_bus_range (&newbus, &newrange, curr, PFMEM, 1)))
+					rc = alloc_bus_range(&newbus, &newrange, curr, PFMEM, 1);
+					if (rc)
 						return rc;
 					list_add_tail (&newbus->bus_list, &gbuses);
 					debug ("gbuses = NULL, PFMemory Primary Bus %x [%x - %x]\n", newbus->busno, newrange->start, newrange->end);
@@ -261,7 +264,8 @@ int __init ibmphp_rsrc_init (void)
 							return rc;
 					} else {
 						/* went through all the buses and didn't find ours, need to create a new bus node */
-						if ((rc = alloc_bus_range (&newbus, &newrange, curr, PFMEM, 1)))
+						rc = alloc_bus_range(&newbus, &newrange, curr, PFMEM, 1);
+						if (rc)
 							return rc;
 						list_add_tail (&newbus->bus_list, &gbuses);
 						debug ("1st Bus, PFMemory Primary Bus %x [%x - %x]\n", newbus->busno, newrange->start, newrange->end);
@@ -271,7 +275,8 @@ int __init ibmphp_rsrc_init (void)
 				/* IO */
 				if (list_empty (&gbuses)) {
 					/* no bus structure exists in place yet */
-					if ((rc = alloc_bus_range (&newbus, &newrange, curr, IO, 1)))
+					rc = alloc_bus_range(&newbus, &newrange, curr, IO, 1);
+					if (rc)
 						return rc;
 					list_add_tail (&newbus->bus_list, &gbuses);
 					debug ("gbuses = NULL, IO Primary Bus %x [%x - %x]\n", newbus->busno, newrange->start, newrange->end);
@@ -283,7 +288,8 @@ int __init ibmphp_rsrc_init (void)
 							return rc;
 					} else {
 						/* went through all the buses and didn't find ours, need to create a new bus node */
-						if ((rc = alloc_bus_range (&newbus, &newrange, curr, IO, 1)))
+						rc = alloc_bus_range(&newbus, &newrange, curr, IO, 1);
+						if (rc)
 							return rc;
 						list_add_tail (&newbus->bus_list, &gbuses);
 						debug ("1st Bus, IO Primary Bus %x [%x - %x]\n", newbus->busno, newrange->start, newrange->end);
@@ -1153,7 +1159,9 @@ int ibmphp_check_resource (struct resource_node *res, u8 bridge)
 				}
 			} else {
 				/* in the same range */
-				if ((len_tmp = res_cur->start - 1 - res_prev->end - 1) >= res->len) {
+				len_tmp = res_cur->start - 1 - res_prev->end - 1;
+
+				if (len_tmp >= res->len) {
 					if ((len_tmp < len_cur) || (len_cur == 0)) {
 						if (((res_prev->end + 1) % tmp_divide) == 0) {
 							/* just perfect, starting address's divisible by length */
@@ -1212,7 +1220,9 @@ int ibmphp_check_resource (struct resource_node *res, u8 bridge)
 				break;
 		}
 		while (range) {
-			if ((len_tmp = range->end - range->start) >= res->len) {
+			len_tmp = range->end - range->start;
+
+			if (len_tmp >= res->len) {
 				if ((len_tmp < len_cur) || (len_cur == 0)) {
 					if ((range->start % tmp_divide) == 0) {
 						/* just perfect, starting address's divisible by length */
@@ -1276,7 +1286,9 @@ int ibmphp_check_resource (struct resource_node *res, u8 bridge)
 					break;
 			}
 			while (range) {
-				if ((len_tmp = range->end - range->start) >= res->len) {
+				len_tmp = range->end - range->start;
+
+				if (len_tmp >= res->len) {
 					if ((len_tmp < len_cur) || (len_cur == 0)) {
 						if ((range->start % tmp_divide) == 0) {
 							/* just perfect, starting address's divisible by length */
diff --git a/drivers/pci/hotplug/shpchp_ctrl.c b/drivers/pci/hotplug/shpchp_ctrl.c
index a81fb67..21f148d 100644
--- a/drivers/pci/hotplug/shpchp_ctrl.c
+++ b/drivers/pci/hotplug/shpchp_ctrl.c
@@ -195,7 +195,8 @@ static int change_bus_speed(struct controller *ctrl, struct slot *p_slot,
 	int rc = 0;
 
 	ctrl_dbg(ctrl, "Change speed to %d\n", speed);
-	if ((rc = p_slot->hpc_ops->set_bus_speed_mode(p_slot, speed))) {
+	rc = p_slot->hpc_ops->set_bus_speed_mode(p_slot, speed);
+	if (rc) {
 		ctrl_err(ctrl, "%s: Issue of set bus speed mode command failed\n",
 			 __func__);
 		return WRONG_BUS_FREQUENCY;
@@ -261,14 +262,16 @@ static int board_added(struct slot *p_slot)
 	}
 
 	if ((ctrl->pci_dev->vendor == 0x8086) && (ctrl->pci_dev->device == 0x0332)) {
-		if ((rc = p_slot->hpc_ops->set_bus_speed_mode(p_slot, PCI_SPEED_33MHz))) {
+		rc = p_slot->hpc_ops->set_bus_speed_mode(p_slot, PCI_SPEED_33MHz);
+		if (rc) {
 			ctrl_err(ctrl, "%s: Issue of set bus speed mode command failed\n",
 				 __func__);
 			return WRONG_BUS_FREQUENCY;
 		}
 
 		/* turn on board, blink green LED, turn off Amber LED */
-		if ((rc = p_slot->hpc_ops->slot_enable(p_slot))) {
+		rc = p_slot->hpc_ops->slot_enable(p_slot);
+		if (rc) {
 			ctrl_err(ctrl, "Issue of Slot Enable command failed\n");
 			return rc;
 		}
@@ -296,7 +299,8 @@ static int board_added(struct slot *p_slot)
 		return rc;
 
 	/* turn on board, blink green LED, turn off Amber LED */
-	if ((rc = p_slot->hpc_ops->slot_enable(p_slot))) {
+	rc = p_slot->hpc_ops->slot_enable(p_slot);
+	if (rc) {
 		ctrl_err(ctrl, "Issue of Slot Enable command failed\n");
 		return rc;
 	}
diff --git a/drivers/pci/hotplug/shpchp_hpc.c b/drivers/pci/hotplug/shpchp_hpc.c
index 29e2235..8cda079 100644
--- a/drivers/pci/hotplug/shpchp_hpc.c
+++ b/drivers/pci/hotplug/shpchp_hpc.c
@@ -466,7 +466,8 @@ static int hpc_get_adapter_speed(struct slot *slot, enum pci_bus_speed *value)
 	u8 m66_cap  = !!(slot_reg & MHZ66_CAP);
 	u8 pi, pcix_cap;
 
-	if ((retval = hpc_get_prog_int(slot, &pi)))
+	retval = hpc_get_prog_int(slot, &pi);
+	if (retval)
 		return retval;
 
 	switch (pi) {
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 2c9ac70..8b63a5b 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1003,12 +1003,19 @@ int pci_save_state(struct pci_dev *dev)
 	for (i = 0; i < 16; i++)
 		pci_read_config_dword(dev, i * 4, &dev->saved_config_space[i]);
 	dev->state_saved = true;
-	if ((i = pci_save_pcie_state(dev)) != 0)
+
+	i = pci_save_pcie_state(dev);
+	if (i != 0)
 		return i;
-	if ((i = pci_save_pcix_state(dev)) != 0)
+
+	i = pci_save_pcix_state(dev);
+	if (i != 0)
 		return i;
-	if ((i = pci_save_vc_state(dev)) != 0)
+
+	i = pci_save_vc_state(dev);
+	if (i != 0)
 		return i;
+
 	return 0;
 }
 EXPORT_SYMBOL(pci_save_state);
-- 
1.9.1

