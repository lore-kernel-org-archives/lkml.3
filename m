Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab3GWIKY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:10:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:12670 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363Ab3GWIJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:09:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,725,1367996400"; 
   d="scan'208";a="271952007"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Corey Minyard <minyard@acm.org>,
        Zhao Yakui <yakui.zhao@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, linux-acpi@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH 04/13] ACPI/IPMI: Fix race caused by the unprotected ACPI IPMI user
Date: Tue, 23 Jul 2013 16:09:26 +0800
Message-Id: <c892cf17953e500992137d90dd6fc5884024fe2a.1374566394.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1374566394.git.lv.zheng@intel.com>
References: <cover.1370652213.git.lv.zheng@intel.com> <cover.1374566394.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses reference counting to fix the race caused by the
unprotected ACPI IPMI user.

As the acpi_ipmi_device->user_interface check in acpi_ipmi_space_handler()
can happen before setting user_interface to NULL and codes after the check
in acpi_ipmi_space_handler() can happen after user_interface becoming NULL,
then the on-going acpi_ipmi_space_handler() still can pass an invalid
acpi_ipmi_device->user_interface to ipmi_request_settime().  Such race
condition is not allowed by the IPMI layer's API design as crash will
happen in ipmi_request_settime().
In IPMI layer, smi_gone()/new_smi() callbacks are protected by
smi_watchers_mutex, thus their invocations are serialized.  But as a new
smi can re-use the freed intf_num, it requires that the callback
implementation must not use intf_num as an identification mean or it must
ensure all references to the previous smi are all dropped before exiting
smi_gone() callback.  In case of acpi_ipmi module, this means
ipmi_flush_tx_msg() must ensure all on-going IPMI transfers are completed
before exiting ipmi_flush_tx_msg().

This patch follows ipmi_devintf.c design:
1. Invoking ipmi_destroy_user() after the reference count of
   acpi_ipmi_device dropping to 0, this matches IPMI layer's API calling
   rule on ipmi_destroy_user() and ipmi_request_settime().
2. References of acpi_ipmi_device dropping to 1 means tx_msg related to
   this acpi_ipmi_device are all freed, this can be used to implement the
   new flushing mechanism.  Note complete() must be retried so that the
   on-going tx_msg won't block flushing at the point to add tx_msg into
   tx_msg_list where reference of acpi_ipmi_device is held.  This matches
   the IPMI layer's callback rule on smi_gone()/new_smi() serialization.
3. ipmi_flush_tx_msg() is performed after deleting acpi_ipmi_device from
   the list so that no new tx_msg can be created after entering flushing
   process.
4. The flushing of tx_msg is also moved out of ipmi_lock in this patch.

The forthcoming IPMI operation region handler installation changes also
requires acpi_ipmi_device be handled in the reference counting style.

Authorship is also updated due to this design change.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Reviewed-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/acpi_ipmi.c |  249 +++++++++++++++++++++++++++-------------------
 1 file changed, 149 insertions(+), 100 deletions(-)

diff --git a/drivers/acpi/acpi_ipmi.c b/drivers/acpi/acpi_ipmi.c
index 527ee43..cbf25e0 100644
--- a/drivers/acpi/acpi_ipmi.c
+++ b/drivers/acpi/acpi_ipmi.c
@@ -1,8 +1,9 @@
 /*
  *  acpi_ipmi.c - ACPI IPMI opregion
  *
- *  Copyright (C) 2010 Intel Corporation
- *  Copyright (C) 2010 Zhao Yakui <yakui.zhao@intel.com>
+ *  Copyright (C) 2010, 2013 Intel Corporation
+ *    Author: Zhao Yakui <yakui.zhao@intel.com>
+ *            Lv Zheng <lv.zheng@intel.com>
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *
@@ -67,6 +68,7 @@ struct acpi_ipmi_device {
 	long curr_msgid;
 	unsigned long flags;
 	struct ipmi_smi_info smi_data;
+	atomic_t refcnt;
 };
 
 struct ipmi_driver_data {
@@ -107,8 +109,8 @@ struct acpi_ipmi_buffer {
 static void ipmi_register_bmc(int iface, struct device *dev);
 static void ipmi_bmc_gone(int iface);
 static void ipmi_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data);
-static void acpi_add_ipmi_device(struct acpi_ipmi_device *ipmi_device);
-static void acpi_remove_ipmi_device(struct acpi_ipmi_device *ipmi_device);
+static int ipmi_install_space_handler(struct acpi_ipmi_device *ipmi);
+static void ipmi_remove_space_handler(struct acpi_ipmi_device *ipmi);
 
 static struct ipmi_driver_data driver_data = {
 	.ipmi_devices = LIST_HEAD_INIT(driver_data.ipmi_devices),
@@ -122,6 +124,80 @@ static struct ipmi_driver_data driver_data = {
 	},
 };
 
+static struct acpi_ipmi_device *
+ipmi_dev_alloc(int iface, struct ipmi_smi_info *smi_data, acpi_handle handle)
+{
+	struct acpi_ipmi_device *ipmi_device;
+	int err;
+	ipmi_user_t user;
+
+	ipmi_device = kzalloc(sizeof(*ipmi_device), GFP_KERNEL);
+	if (!ipmi_device)
+		return NULL;
+
+	atomic_set(&ipmi_device->refcnt, 1);
+	INIT_LIST_HEAD(&ipmi_device->head);
+	INIT_LIST_HEAD(&ipmi_device->tx_msg_list);
+	spin_lock_init(&ipmi_device->tx_msg_lock);
+
+	ipmi_device->handle = handle;
+	ipmi_device->pnp_dev = to_pnp_dev(get_device(smi_data->dev));
+	memcpy(&ipmi_device->smi_data, smi_data, sizeof(struct ipmi_smi_info));
+	ipmi_device->ipmi_ifnum = iface;
+
+	err = ipmi_create_user(iface, &driver_data.ipmi_hndlrs,
+			       ipmi_device, &user);
+	if (err) {
+		put_device(smi_data->dev);
+		kfree(ipmi_device);
+		return NULL;
+	}
+	ipmi_device->user_interface = user;
+	ipmi_install_space_handler(ipmi_device);
+
+	return ipmi_device;
+}
+
+static struct acpi_ipmi_device *
+acpi_ipmi_dev_get(struct acpi_ipmi_device *ipmi_device)
+{
+	if (ipmi_device)
+		atomic_inc(&ipmi_device->refcnt);
+	return ipmi_device;
+}
+
+static void ipmi_dev_release(struct acpi_ipmi_device *ipmi_device)
+{
+	ipmi_remove_space_handler(ipmi_device);
+	ipmi_destroy_user(ipmi_device->user_interface);
+	put_device(ipmi_device->smi_data.dev);
+	kfree(ipmi_device);
+}
+
+static void acpi_ipmi_dev_put(struct acpi_ipmi_device *ipmi_device)
+{
+	if (ipmi_device && atomic_dec_and_test(&ipmi_device->refcnt))
+		ipmi_dev_release(ipmi_device);
+}
+
+static struct acpi_ipmi_device *acpi_ipmi_get_targeted_smi(int iface)
+{
+	int dev_found = 0;
+	struct acpi_ipmi_device *ipmi_device;
+
+	mutex_lock(&driver_data.ipmi_lock);
+	list_for_each_entry(ipmi_device, &driver_data.ipmi_devices, head) {
+		if (ipmi_device->ipmi_ifnum == iface) {
+			dev_found = 1;
+			acpi_ipmi_dev_get(ipmi_device);
+			break;
+		}
+	}
+	mutex_unlock(&driver_data.ipmi_lock);
+
+	return dev_found ? ipmi_device : NULL;
+}
+
 static struct acpi_ipmi_msg *acpi_alloc_ipmi_msg(struct acpi_ipmi_device *ipmi)
 {
 	struct acpi_ipmi_msg *ipmi_msg;
@@ -228,25 +304,24 @@ static void acpi_format_ipmi_response(struct acpi_ipmi_msg *msg,
 static void ipmi_flush_tx_msg(struct acpi_ipmi_device *ipmi)
 {
 	struct acpi_ipmi_msg *tx_msg, *temp;
-	int count = HZ / 10;
-	struct pnp_dev *pnp_dev = ipmi->pnp_dev;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ipmi->tx_msg_lock, flags);
-	list_for_each_entry_safe(tx_msg, temp, &ipmi->tx_msg_list, head) {
-		/* wake up the sleep thread on the Tx msg */
-		complete(&tx_msg->tx_complete);
-	}
-	spin_unlock_irqrestore(&ipmi->tx_msg_lock, flags);
-
-	/* wait for about 100ms to flush the tx message list */
-	while (count--) {
-		if (list_empty(&ipmi->tx_msg_list))
-			break;
-		schedule_timeout(1);
+	/*
+	 * NOTE: Synchronous Flushing
+	 * Wait until refnct dropping to 1 - no other users unless this
+	 * context.  This function should always be called before
+	 * acpi_ipmi_device destruction.
+	 */
+	while (atomic_read(&ipmi->refcnt) > 1) {
+		spin_lock_irqsave(&ipmi->tx_msg_lock, flags);
+		list_for_each_entry_safe(tx_msg, temp,
+					 &ipmi->tx_msg_list, head) {
+			/* wake up the sleep thread on the Tx msg */
+			complete(&tx_msg->tx_complete);
+		}
+		spin_unlock_irqrestore(&ipmi->tx_msg_lock, flags);
+		schedule_timeout_uninterruptible(msecs_to_jiffies(1));
 	}
-	if (!list_empty(&ipmi->tx_msg_list))
-		dev_warn(&pnp_dev->dev, "tx msg list is not NULL\n");
 }
 
 static void ipmi_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data)
@@ -304,22 +379,26 @@ static void ipmi_register_bmc(int iface, struct device *dev)
 {
 	struct acpi_ipmi_device *ipmi_device, *temp;
 	struct pnp_dev *pnp_dev;
-	ipmi_user_t		user;
 	int err;
 	struct ipmi_smi_info smi_data;
 	acpi_handle handle;
 
 	err = ipmi_get_smi_info(iface, &smi_data);
-
 	if (err)
 		return;
 
-	if (smi_data.addr_src != SI_ACPI) {
-		put_device(smi_data.dev);
-		return;
-	}
-
+	if (smi_data.addr_src != SI_ACPI)
+		goto err_ref;
 	handle = smi_data.addr_info.acpi_info.acpi_handle;
+	if (!handle)
+		goto err_ref;
+	pnp_dev = to_pnp_dev(smi_data.dev);
+
+	ipmi_device = ipmi_dev_alloc(iface, &smi_data, handle);
+	if (!ipmi_device) {
+		dev_warn(&pnp_dev->dev, "Can't create IPMI user interface\n");
+		goto err_ref;
+	}
 
 	mutex_lock(&driver_data.ipmi_lock);
 	list_for_each_entry(temp, &driver_data.ipmi_devices, head) {
@@ -328,54 +407,42 @@ static void ipmi_register_bmc(int iface, struct device *dev)
 		 * to the device list, don't add it again.
 		 */
 		if (temp->handle == handle)
-			goto out;
+			goto err_lock;
 	}
 
-	ipmi_device = kzalloc(sizeof(*ipmi_device), GFP_KERNEL);
-
-	if (!ipmi_device)
-		goto out;
-
-	pnp_dev = to_pnp_dev(smi_data.dev);
-	ipmi_device->handle = handle;
-	ipmi_device->pnp_dev = pnp_dev;
-
-	err = ipmi_create_user(iface, &driver_data.ipmi_hndlrs,
-					ipmi_device, &user);
-	if (err) {
-		dev_warn(&pnp_dev->dev, "Can't create IPMI user interface\n");
-		kfree(ipmi_device);
-		goto out;
-	}
-	acpi_add_ipmi_device(ipmi_device);
-	ipmi_device->user_interface = user;
-	ipmi_device->ipmi_ifnum = iface;
+	list_add_tail(&ipmi_device->head, &driver_data.ipmi_devices);
 	mutex_unlock(&driver_data.ipmi_lock);
-	memcpy(&ipmi_device->smi_data, &smi_data, sizeof(struct ipmi_smi_info));
+	put_device(smi_data.dev);
 	return;
 
-out:
+err_lock:
 	mutex_unlock(&driver_data.ipmi_lock);
+	ipmi_dev_release(ipmi_device);
+err_ref:
 	put_device(smi_data.dev);
 	return;
 }
 
 static void ipmi_bmc_gone(int iface)
 {
-	struct acpi_ipmi_device *ipmi_device, *temp;
+	int dev_found = 0;
+	struct acpi_ipmi_device *ipmi_device;
 
 	mutex_lock(&driver_data.ipmi_lock);
-	list_for_each_entry_safe(ipmi_device, temp,
-				&driver_data.ipmi_devices, head) {
-		if (ipmi_device->ipmi_ifnum != iface)
-			continue;
-
-		acpi_remove_ipmi_device(ipmi_device);
-		put_device(ipmi_device->smi_data.dev);
-		kfree(ipmi_device);
-		break;
+	list_for_each_entry(ipmi_device, &driver_data.ipmi_devices, head) {
+		if (ipmi_device->ipmi_ifnum == iface) {
+			dev_found = 1;
+			break;
+		}
 	}
+	if (dev_found)
+		list_del(&ipmi_device->head);
 	mutex_unlock(&driver_data.ipmi_lock);
+
+	if (dev_found) {
+		ipmi_flush_tx_msg(ipmi_device);
+		acpi_ipmi_dev_put(ipmi_device);
+	}
 }
 
 /* --------------------------------------------------------------------------
@@ -400,7 +467,8 @@ acpi_ipmi_space_handler(u32 function, acpi_physical_address address,
 			void *handler_context, void *region_context)
 {
 	struct acpi_ipmi_msg *tx_msg;
-	struct acpi_ipmi_device *ipmi_device = handler_context;
+	int iface = (long)handler_context;
+	struct acpi_ipmi_device *ipmi_device;
 	int err, rem_time;
 	acpi_status status;
 	unsigned long flags;
@@ -414,12 +482,15 @@ acpi_ipmi_space_handler(u32 function, acpi_physical_address address,
 	if ((function & ACPI_IO_MASK) == ACPI_READ)
 		return AE_TYPE;
 
-	if (!ipmi_device->user_interface)
+	ipmi_device = acpi_ipmi_get_targeted_smi(iface);
+	if (!ipmi_device)
 		return AE_NOT_EXIST;
 
 	tx_msg = acpi_alloc_ipmi_msg(ipmi_device);
-	if (!tx_msg)
-		return AE_NO_MEMORY;
+	if (!tx_msg) {
+		status = AE_NO_MEMORY;
+		goto out_ref;
+	}
 
 	if (acpi_format_ipmi_request(tx_msg, address, value) != 0) {
 		status = AE_TYPE;
@@ -449,6 +520,8 @@ out_list:
 	spin_unlock_irqrestore(&ipmi_device->tx_msg_lock, flags);
 out_msg:
 	kfree(tx_msg);
+out_ref:
+	acpi_ipmi_dev_put(ipmi_device);
 	return status;
 }
 
@@ -473,7 +546,7 @@ static int ipmi_install_space_handler(struct acpi_ipmi_device *ipmi)
 	status = acpi_install_address_space_handler(ipmi->handle,
 						    ACPI_ADR_SPACE_IPMI,
 						    &acpi_ipmi_space_handler,
-						    NULL, ipmi);
+						    NULL, (void *)((long)ipmi->ipmi_ifnum));
 	if (ACPI_FAILURE(status)) {
 		struct pnp_dev *pnp_dev = ipmi->pnp_dev;
 		dev_warn(&pnp_dev->dev, "Can't register IPMI opregion space "
@@ -484,36 +557,6 @@ static int ipmi_install_space_handler(struct acpi_ipmi_device *ipmi)
 	return 0;
 }
 
-static void acpi_add_ipmi_device(struct acpi_ipmi_device *ipmi_device)
-{
-
-	INIT_LIST_HEAD(&ipmi_device->head);
-
-	spin_lock_init(&ipmi_device->tx_msg_lock);
-	INIT_LIST_HEAD(&ipmi_device->tx_msg_list);
-	ipmi_install_space_handler(ipmi_device);
-
-	list_add_tail(&ipmi_device->head, &driver_data.ipmi_devices);
-}
-
-static void acpi_remove_ipmi_device(struct acpi_ipmi_device *ipmi_device)
-{
-	/*
-	 * If the IPMI user interface is created, it should be
-	 * destroyed.
-	 */
-	if (ipmi_device->user_interface) {
-		ipmi_destroy_user(ipmi_device->user_interface);
-		ipmi_device->user_interface = NULL;
-	}
-	/* flush the Tx_msg list */
-	if (!list_empty(&ipmi_device->tx_msg_list))
-		ipmi_flush_tx_msg(ipmi_device);
-
-	list_del(&ipmi_device->head);
-	ipmi_remove_space_handler(ipmi_device);
-}
-
 static int __init acpi_ipmi_init(void)
 {
 	int result = 0;
@@ -530,7 +573,7 @@ static int __init acpi_ipmi_init(void)
 
 static void __exit acpi_ipmi_exit(void)
 {
-	struct acpi_ipmi_device *ipmi_device, *temp;
+	struct acpi_ipmi_device *ipmi_device;
 
 	if (acpi_disabled)
 		return;
@@ -544,11 +587,17 @@ static void __exit acpi_ipmi_exit(void)
 	 * handler and free it.
 	 */
 	mutex_lock(&driver_data.ipmi_lock);
-	list_for_each_entry_safe(ipmi_device, temp,
-				&driver_data.ipmi_devices, head) {
-		acpi_remove_ipmi_device(ipmi_device);
-		put_device(ipmi_device->smi_data.dev);
-		kfree(ipmi_device);
+	while (!list_empty(&driver_data.ipmi_devices)) {
+		ipmi_device = list_first_entry(&driver_data.ipmi_devices,
+					       struct acpi_ipmi_device,
+					       head);
+		list_del(&ipmi_device->head);
+		mutex_unlock(&driver_data.ipmi_lock);
+
+		ipmi_flush_tx_msg(ipmi_device);
+		acpi_ipmi_dev_put(ipmi_device);
+
+		mutex_lock(&driver_data.ipmi_lock);
 	}
 	mutex_unlock(&driver_data.ipmi_lock);
 }
-- 
1.7.10

