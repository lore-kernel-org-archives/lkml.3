Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab3GWIK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:10:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:13272 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398Ab3GWIJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:09:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,725,1367996400"; 
   d="scan'208";a="350032264"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Corey Minyard <minyard@acm.org>,
        Zhao Yakui <yakui.zhao@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, linux-acpi@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH 05/13] ACPI/IPMI: Fix issue caused by the per-device registration of the IPMI operation region handler
Date: Tue, 23 Jul 2013 16:09:35 +0800
Message-Id: <c4642cf2ebe568815030966a3741eec88ad4ae3f.1374566394.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1374566394.git.lv.zheng@intel.com>
References: <cover.1370652213.git.lv.zheng@intel.com> <cover.1374566394.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is found on a real machine, in its ACPI namespace, the IPMI
OperationRegions (in the ACPI000D - ACPI power meter) are not defined under
the IPMI system interface device (the IPI0001 with KCS type returned from
_IFT control method):
  Device (PMI0)
  {
      Name (_HID, "ACPI000D")  // _HID: Hardware ID
      OperationRegion (SYSI, IPMI, 0x0600, 0x0100)
      Field (SYSI, BufferAcc, Lock, Preserve)
      {
          AccessAs (BufferAcc, 0x01),
          Offset (0x58),
          SCMD,   8,
          GCMD,   8
      }

      OperationRegion (POWR, IPMI, 0x3000, 0x0100)
      Field (POWR, BufferAcc, Lock, Preserve)
      {
          AccessAs (BufferAcc, 0x01),
          Offset (0xB3),
          GPMM,   8
      }
  }

  Device (PCI0)
  {
      Device (ISA)
      {
          Device (NIPM)
          {
              Name (_HID, EisaId ("IPI0001"))  // _HID: Hardware ID
              Method (_IFT, 0, NotSerialized)  // _IFT: IPMI Interface Type
              {
                  Return (0x01)
              }
          }
      }
  }
Current ACPI_IPMI code registers IPMI operation region handler on a
per-device basis, so that for above namespace, the IPMI operation region
handler is registered only under the scope of \_SB.PCI0.ISA.NIPM.  Thus
when an IPMI operation region field of \PMI0 is accessed, there are errors
reported on such platform:
  ACPI Error: No handlers for Region [IPMI]
  ACPI Error: Region IPMI(7) has no handler
The solution is to install IPMI operation region handler from root node so
that every object that defines IPMI OperationRegion can get an address
space handler registered.

When an IPMI operation region field is accessed, the Network Function
(0x06 for SYSI and 0x30 for POWR) and the Command (SCMD, GCMD, GPMM) are
passed to the operation region handler, there is no system interface
specified by the BIOS.  The patch tries to select one system interface by
monitoring the system interface notification.  IPMI messages passed from
the ACPI codes are sent to this selected global IPMI system interface.

Known issues:
- How to select the IPMI system interface:
  Currently, the ACPI_IPMI always selects the first registered one with the
  ACPI handle set (i.e., defined in the ACPI namespace).  It's hard to
  determine the selection when there are multiple IPMI system interfaces
  defined in the ACPI namespace.
  According to the IPMI specification:
  A BMC device may make available multiple system interfaces, but only one
  management controller is allowed to be 'active' BMC that provides BMC
  functionality for the system (in case of a 'partitioned' system, there
  can be only one active BMC per partition).  Only the system interface(s)
  for the active BMC allowed to respond to the 'Get Device Id' command.
  According to the ipmi_si desigin:
  The ipmi_si registeration notifications can only happen after a
  successful "Get Device ID" command.
  Thus it should be OK for non-partitioned systems to do such selection.
  But we do not have too much knowledges on 'partitioned' systems.
- Lack of smi_gone()/new_smi() testability:
  It is not possible to do module(ipmi_si) load/unload test, and I can't
  find any multiple IPMI system interfaces platforms available for testing.
  There might be issues in the untested code path.

Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=46741
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Reviewed-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/acpi_ipmi.c |  111 +++++++++++++++++++++++-----------------------
 1 file changed, 55 insertions(+), 56 deletions(-)

diff --git a/drivers/acpi/acpi_ipmi.c b/drivers/acpi/acpi_ipmi.c
index cbf25e0..5f8f495 100644
--- a/drivers/acpi/acpi_ipmi.c
+++ b/drivers/acpi/acpi_ipmi.c
@@ -46,7 +46,8 @@ MODULE_AUTHOR("Zhao Yakui");
 MODULE_DESCRIPTION("ACPI IPMI Opregion driver");
 MODULE_LICENSE("GPL");
 
-#define IPMI_FLAGS_HANDLER_INSTALL	0
+#undef PREFIX
+#define PREFIX				"ACPI: IPMI: "
 
 #define ACPI_IPMI_OK			0
 #define ACPI_IPMI_TIMEOUT		0x10
@@ -66,7 +67,6 @@ struct acpi_ipmi_device {
 	ipmi_user_t	user_interface;
 	int ipmi_ifnum; /* IPMI interface number */
 	long curr_msgid;
-	unsigned long flags;
 	struct ipmi_smi_info smi_data;
 	atomic_t refcnt;
 };
@@ -76,6 +76,14 @@ struct ipmi_driver_data {
 	struct ipmi_smi_watcher	bmc_events;
 	struct ipmi_user_hndl	ipmi_hndlrs;
 	struct mutex		ipmi_lock;
+	/*
+	 * NOTE: IPMI System Interface Selection
+	 * There is no system interface specified by the IPMI operation
+	 * region access.  We try to select one system interface with ACPI
+	 * handle set.  IPMI messages passed from the ACPI codes are sent
+	 * to this selected global IPMI system interface.
+	 */
+	struct acpi_ipmi_device *selected_smi;
 };
 
 struct acpi_ipmi_msg {
@@ -109,8 +117,6 @@ struct acpi_ipmi_buffer {
 static void ipmi_register_bmc(int iface, struct device *dev);
 static void ipmi_bmc_gone(int iface);
 static void ipmi_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data);
-static int ipmi_install_space_handler(struct acpi_ipmi_device *ipmi);
-static void ipmi_remove_space_handler(struct acpi_ipmi_device *ipmi);
 
 static struct ipmi_driver_data driver_data = {
 	.ipmi_devices = LIST_HEAD_INIT(driver_data.ipmi_devices),
@@ -153,7 +159,6 @@ ipmi_dev_alloc(int iface, struct ipmi_smi_info *smi_data, acpi_handle handle)
 		return NULL;
 	}
 	ipmi_device->user_interface = user;
-	ipmi_install_space_handler(ipmi_device);
 
 	return ipmi_device;
 }
@@ -168,7 +173,6 @@ acpi_ipmi_dev_get(struct acpi_ipmi_device *ipmi_device)
 
 static void ipmi_dev_release(struct acpi_ipmi_device *ipmi_device)
 {
-	ipmi_remove_space_handler(ipmi_device);
 	ipmi_destroy_user(ipmi_device->user_interface);
 	put_device(ipmi_device->smi_data.dev);
 	kfree(ipmi_device);
@@ -180,22 +184,15 @@ static void acpi_ipmi_dev_put(struct acpi_ipmi_device *ipmi_device)
 		ipmi_dev_release(ipmi_device);
 }
 
-static struct acpi_ipmi_device *acpi_ipmi_get_targeted_smi(int iface)
+static struct acpi_ipmi_device *acpi_ipmi_get_selected_smi(void)
 {
-	int dev_found = 0;
 	struct acpi_ipmi_device *ipmi_device;
 
 	mutex_lock(&driver_data.ipmi_lock);
-	list_for_each_entry(ipmi_device, &driver_data.ipmi_devices, head) {
-		if (ipmi_device->ipmi_ifnum == iface) {
-			dev_found = 1;
-			acpi_ipmi_dev_get(ipmi_device);
-			break;
-		}
-	}
+	ipmi_device = acpi_ipmi_dev_get(driver_data.selected_smi);
 	mutex_unlock(&driver_data.ipmi_lock);
 
-	return dev_found ? ipmi_device : NULL;
+	return ipmi_device;
 }
 
 static struct acpi_ipmi_msg *acpi_alloc_ipmi_msg(struct acpi_ipmi_device *ipmi)
@@ -410,6 +407,9 @@ static void ipmi_register_bmc(int iface, struct device *dev)
 			goto err_lock;
 	}
 
+	if (!driver_data.selected_smi)
+		driver_data.selected_smi = acpi_ipmi_dev_get(ipmi_device);
+
 	list_add_tail(&ipmi_device->head, &driver_data.ipmi_devices);
 	mutex_unlock(&driver_data.ipmi_lock);
 	put_device(smi_data.dev);
@@ -426,22 +426,34 @@ err_ref:
 static void ipmi_bmc_gone(int iface)
 {
 	int dev_found = 0;
-	struct acpi_ipmi_device *ipmi_device;
+	struct acpi_ipmi_device *ipmi_gone, *ipmi_new;
 
 	mutex_lock(&driver_data.ipmi_lock);
-	list_for_each_entry(ipmi_device, &driver_data.ipmi_devices, head) {
-		if (ipmi_device->ipmi_ifnum == iface) {
+	list_for_each_entry(ipmi_gone, &driver_data.ipmi_devices, head) {
+		if (ipmi_gone->ipmi_ifnum == iface) {
 			dev_found = 1;
 			break;
 		}
 	}
-	if (dev_found)
-		list_del(&ipmi_device->head);
+	if (dev_found) {
+		list_del(&ipmi_gone->head);
+		if (driver_data.selected_smi == ipmi_gone) {
+			acpi_ipmi_dev_put(ipmi_gone);
+			driver_data.selected_smi = NULL;
+		}
+	}
+	if (!driver_data.selected_smi &&
+	    !list_empty(&driver_data.ipmi_devices)) {
+		ipmi_new = list_first_entry(&driver_data.ipmi_devices,
+					    struct acpi_ipmi_device,
+					    head);
+		driver_data.selected_smi = acpi_ipmi_dev_get(ipmi_new);
+	}
 	mutex_unlock(&driver_data.ipmi_lock);
 
 	if (dev_found) {
-		ipmi_flush_tx_msg(ipmi_device);
-		acpi_ipmi_dev_put(ipmi_device);
+		ipmi_flush_tx_msg(ipmi_gone);
+		acpi_ipmi_dev_put(ipmi_gone);
 	}
 }
 
@@ -467,7 +479,6 @@ acpi_ipmi_space_handler(u32 function, acpi_physical_address address,
 			void *handler_context, void *region_context)
 {
 	struct acpi_ipmi_msg *tx_msg;
-	int iface = (long)handler_context;
 	struct acpi_ipmi_device *ipmi_device;
 	int err, rem_time;
 	acpi_status status;
@@ -482,7 +493,7 @@ acpi_ipmi_space_handler(u32 function, acpi_physical_address address,
 	if ((function & ACPI_IO_MASK) == ACPI_READ)
 		return AE_TYPE;
 
-	ipmi_device = acpi_ipmi_get_targeted_smi(iface);
+	ipmi_device = acpi_ipmi_get_selected_smi();
 	if (!ipmi_device)
 		return AE_NOT_EXIST;
 
@@ -525,48 +536,28 @@ out_ref:
 	return status;
 }
 
-static void ipmi_remove_space_handler(struct acpi_ipmi_device *ipmi)
-{
-	if (!test_bit(IPMI_FLAGS_HANDLER_INSTALL, &ipmi->flags))
-		return;
-
-	acpi_remove_address_space_handler(ipmi->handle,
-				ACPI_ADR_SPACE_IPMI, &acpi_ipmi_space_handler);
-
-	clear_bit(IPMI_FLAGS_HANDLER_INSTALL, &ipmi->flags);
-}
-
-static int ipmi_install_space_handler(struct acpi_ipmi_device *ipmi)
+static int __init acpi_ipmi_init(void)
 {
+	int result = 0;
 	acpi_status status;
 
-	if (test_bit(IPMI_FLAGS_HANDLER_INSTALL, &ipmi->flags))
-		return 0;
+	if (acpi_disabled)
+		return result;
 
-	status = acpi_install_address_space_handler(ipmi->handle,
+	mutex_init(&driver_data.ipmi_lock);
+
+	status = acpi_install_address_space_handler(ACPI_ROOT_OBJECT,
 						    ACPI_ADR_SPACE_IPMI,
 						    &acpi_ipmi_space_handler,
-						    NULL, (void *)((long)ipmi->ipmi_ifnum));
+						    NULL, NULL);
 	if (ACPI_FAILURE(status)) {
-		struct pnp_dev *pnp_dev = ipmi->pnp_dev;
-		dev_warn(&pnp_dev->dev, "Can't register IPMI opregion space "
-			"handle\n");
+		pr_warn("Can't register IPMI opregion space handle\n");
 		return -EINVAL;
 	}
-	set_bit(IPMI_FLAGS_HANDLER_INSTALL, &ipmi->flags);
-	return 0;
-}
-
-static int __init acpi_ipmi_init(void)
-{
-	int result = 0;
-
-	if (acpi_disabled)
-		return result;
-
-	mutex_init(&driver_data.ipmi_lock);
 
 	result = ipmi_smi_watcher_register(&driver_data.bmc_events);
+	if (result)
+		pr_err("Can't register IPMI system interface watcher\n");
 
 	return result;
 }
@@ -592,6 +583,10 @@ static void __exit acpi_ipmi_exit(void)
 					       struct acpi_ipmi_device,
 					       head);
 		list_del(&ipmi_device->head);
+		if (ipmi_device == driver_data.selected_smi) {
+			acpi_ipmi_dev_put(driver_data.selected_smi);
+			driver_data.selected_smi = NULL;
+		}
 		mutex_unlock(&driver_data.ipmi_lock);
 
 		ipmi_flush_tx_msg(ipmi_device);
@@ -600,6 +595,10 @@ static void __exit acpi_ipmi_exit(void)
 		mutex_lock(&driver_data.ipmi_lock);
 	}
 	mutex_unlock(&driver_data.ipmi_lock);
+
+	acpi_remove_address_space_handler(ACPI_ROOT_OBJECT,
+					  ACPI_ADR_SPACE_IPMI,
+					  &acpi_ipmi_space_handler);
 }
 
 module_init(acpi_ipmi_init);
-- 
1.7.10

