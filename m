Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab3GWIK3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:10:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:5044 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400Ab3GWIJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:09:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,725,1367996400"; 
   d="scan'208";a="374543371"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Corey Minyard <minyard@acm.org>,
        Zhao Yakui <yakui.zhao@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, linux-acpi@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH 06/13] ACPI/IPMI: Add reference counting for ACPI operation region handlers
Date: Tue, 23 Jul 2013 16:09:43 +0800
Message-Id: <d9d5acba01eb80580e7696c50db4263ded86a86c.1374566394.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1374566394.git.lv.zheng@intel.com>
References: <cover.1370652213.git.lv.zheng@intel.com> <cover.1374566394.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds reference couting for ACPI operation region handlers to fix
races caused by the ACPICA address space callback invocations.

ACPICA address space callback invocation is not suitable for Linux
CONFIG_MODULE=y execution environment.  This patch tries to protect the
address space callbacks by invoking them under a module safe environment.
The IPMI address space handler is also upgraded in this patch.
The acpi_unregister_region() is designed to meet the following
requirements:
1. It acts as a barrier for operation region callbacks - no callback will
   happen after acpi_unregister_region().
2. acpi_unregister_region() is safe to be called in moudle->exit()
   functions.
Using reference counting rather than module referencing allows
such benefits to be achieved even when acpi_unregister_region() is called
in the environments other than module->exit().
The header file of include/acpi/acpi_bus.h should contain the declarations
that have references to some ACPICA defined types.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Reviewed-by: Huang Ying <ying.huang@intel.com>
---
 drivers/acpi/acpi_ipmi.c |   16 ++--
 drivers/acpi/osl.c       |  224 ++++++++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_bus.h  |    5 ++
 3 files changed, 235 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/acpi_ipmi.c b/drivers/acpi/acpi_ipmi.c
index 5f8f495..2a09156 100644
--- a/drivers/acpi/acpi_ipmi.c
+++ b/drivers/acpi/acpi_ipmi.c
@@ -539,20 +539,18 @@ out_ref:
 static int __init acpi_ipmi_init(void)
 {
 	int result = 0;
-	acpi_status status;
 
 	if (acpi_disabled)
 		return result;
 
 	mutex_init(&driver_data.ipmi_lock);
 
-	status = acpi_install_address_space_handler(ACPI_ROOT_OBJECT,
-						    ACPI_ADR_SPACE_IPMI,
-						    &acpi_ipmi_space_handler,
-						    NULL, NULL);
-	if (ACPI_FAILURE(status)) {
+	result = acpi_register_region(ACPI_ADR_SPACE_IPMI,
+				      &acpi_ipmi_space_handler,
+				      NULL, NULL);
+	if (result) {
 		pr_warn("Can't register IPMI opregion space handle\n");
-		return -EINVAL;
+		return result;
 	}
 
 	result = ipmi_smi_watcher_register(&driver_data.bmc_events);
@@ -596,9 +594,7 @@ static void __exit acpi_ipmi_exit(void)
 	}
 	mutex_unlock(&driver_data.ipmi_lock);
 
-	acpi_remove_address_space_handler(ACPI_ROOT_OBJECT,
-					  ACPI_ADR_SPACE_IPMI,
-					  &acpi_ipmi_space_handler);
+	acpi_unregister_region(ACPI_ADR_SPACE_IPMI);
 }
 
 module_init(acpi_ipmi_init);
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 6ab2c35..8398e51 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -86,6 +86,42 @@ static struct workqueue_struct *kacpid_wq;
 static struct workqueue_struct *kacpi_notify_wq;
 static struct workqueue_struct *kacpi_hotplug_wq;
 
+struct acpi_region {
+	unsigned long flags;
+#define ACPI_REGION_DEFAULT		0x01
+#define ACPI_REGION_INSTALLED		0x02
+#define ACPI_REGION_REGISTERED		0x04
+#define ACPI_REGION_UNREGISTERING	0x08
+#define ACPI_REGION_INSTALLING		0x10
+	/*
+	 * NOTE: Upgrading All Region Handlers
+	 * This flag is only used during the period where not all of the
+	 * region handers are upgraded to the new interfaces.
+	 */
+#define ACPI_REGION_MANAGED		0x80
+	acpi_adr_space_handler handler;
+	acpi_adr_space_setup setup;
+	void *context;
+	/* Invoking references */
+	atomic_t refcnt;
+};
+
+static struct acpi_region acpi_regions[ACPI_NUM_PREDEFINED_REGIONS] = {
+	[ACPI_ADR_SPACE_SYSTEM_MEMORY] = {
+		.flags = ACPI_REGION_DEFAULT,
+	},
+	[ACPI_ADR_SPACE_SYSTEM_IO] = {
+		.flags = ACPI_REGION_DEFAULT,
+	},
+	[ACPI_ADR_SPACE_PCI_CONFIG] = {
+		.flags = ACPI_REGION_DEFAULT,
+	},
+	[ACPI_ADR_SPACE_IPMI] = {
+		.flags = ACPI_REGION_MANAGED,
+	},
+};
+static DEFINE_MUTEX(acpi_mutex_region);
+
 /*
  * This list of permanent mappings is for memory that may be accessed from
  * interrupt context, where we can't do the ioremap().
@@ -1799,3 +1835,191 @@ void alloc_acpi_hp_work(acpi_handle handle, u32 type, void *context,
 		kfree(hp_work);
 }
 EXPORT_SYMBOL_GPL(alloc_acpi_hp_work);
+
+static bool acpi_region_managed(struct acpi_region *rgn)
+{
+	/*
+	 * NOTE: Default and Managed
+	 * We only need to avoid region management on the regions managed
+	 * by ACPICA (ACPI_REGION_DEFAULT).  Currently, we need additional
+	 * check as many operation region handlers are not upgraded, so
+	 * only those known to be safe are managed (ACPI_REGION_MANAGED).
+	 */
+	return !(rgn->flags & ACPI_REGION_DEFAULT) &&
+	       (rgn->flags & ACPI_REGION_MANAGED);
+}
+
+static bool acpi_region_callable(struct acpi_region *rgn)
+{
+	return (rgn->flags & ACPI_REGION_REGISTERED) &&
+	       !(rgn->flags & ACPI_REGION_UNREGISTERING);
+}
+
+static acpi_status
+acpi_region_default_handler(u32 function,
+			    acpi_physical_address address,
+			    u32 bit_width, u64 *value,
+			    void *handler_context, void *region_context)
+{
+	acpi_adr_space_handler handler;
+	struct acpi_region *rgn = (struct acpi_region *)handler_context;
+	void *context;
+	acpi_status status = AE_NOT_EXIST;
+
+	mutex_lock(&acpi_mutex_region);
+	if (!acpi_region_callable(rgn) || !rgn->handler) {
+		mutex_unlock(&acpi_mutex_region);
+		return status;
+	}
+
+	atomic_inc(&rgn->refcnt);
+	handler = rgn->handler;
+	context = rgn->context;
+	mutex_unlock(&acpi_mutex_region);
+
+	status = handler(function, address, bit_width, value, context,
+			 region_context);
+	atomic_dec(&rgn->refcnt);
+
+	return status;
+}
+
+static acpi_status
+acpi_region_default_setup(acpi_handle handle, u32 function,
+			  void *handler_context, void **region_context)
+{
+	acpi_adr_space_setup setup;
+	struct acpi_region *rgn = (struct acpi_region *)handler_context;
+	void *context;
+	acpi_status status = AE_OK;
+
+	mutex_lock(&acpi_mutex_region);
+	if (!acpi_region_callable(rgn) || !rgn->setup) {
+		mutex_unlock(&acpi_mutex_region);
+		return status;
+	}
+
+	atomic_inc(&rgn->refcnt);
+	setup = rgn->setup;
+	context = rgn->context;
+	mutex_unlock(&acpi_mutex_region);
+
+	status = setup(handle, function, context, region_context);
+	atomic_dec(&rgn->refcnt);
+
+	return status;
+}
+
+static int __acpi_install_region(struct acpi_region *rgn,
+				 acpi_adr_space_type space_id)
+{
+	int res = 0;
+	acpi_status status;
+	int installing = 0;
+
+	mutex_lock(&acpi_mutex_region);
+	if (rgn->flags & ACPI_REGION_INSTALLED)
+		goto out_lock;
+	if (rgn->flags & ACPI_REGION_INSTALLING) {
+		res = -EBUSY;
+		goto out_lock;
+	}
+
+	installing = 1;
+	rgn->flags |= ACPI_REGION_INSTALLING;
+	status = acpi_install_address_space_handler(ACPI_ROOT_OBJECT, space_id,
+						    acpi_region_default_handler,
+						    acpi_region_default_setup,
+						    rgn);
+	rgn->flags &= ~ACPI_REGION_INSTALLING;
+	if (ACPI_FAILURE(status))
+		res = -EINVAL;
+	else
+		rgn->flags |= ACPI_REGION_INSTALLED;
+
+out_lock:
+	mutex_unlock(&acpi_mutex_region);
+	if (installing) {
+		if (res)
+			pr_err("Failed to install region %d\n", space_id);
+		else
+			pr_info("Region %d installed\n", space_id);
+	}
+	return res;
+}
+
+int acpi_register_region(acpi_adr_space_type space_id,
+			 acpi_adr_space_handler handler,
+			 acpi_adr_space_setup setup, void *context)
+{
+	int res;
+	struct acpi_region *rgn;
+
+	if (space_id >= ACPI_NUM_PREDEFINED_REGIONS)
+		return -EINVAL;
+
+	rgn = &acpi_regions[space_id];
+	if (!acpi_region_managed(rgn))
+		return -EINVAL;
+
+	res = __acpi_install_region(rgn, space_id);
+	if (res)
+		return res;
+
+	mutex_lock(&acpi_mutex_region);
+	if (rgn->flags & ACPI_REGION_REGISTERED) {
+		mutex_unlock(&acpi_mutex_region);
+		return -EBUSY;
+	}
+
+	rgn->handler = handler;
+	rgn->setup = setup;
+	rgn->context = context;
+	rgn->flags |= ACPI_REGION_REGISTERED;
+	atomic_set(&rgn->refcnt, 1);
+	mutex_unlock(&acpi_mutex_region);
+
+	pr_info("Region %d registered\n", space_id);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(acpi_register_region);
+
+void acpi_unregister_region(acpi_adr_space_type space_id)
+{
+	struct acpi_region *rgn;
+
+	if (space_id >= ACPI_NUM_PREDEFINED_REGIONS)
+		return;
+
+	rgn = &acpi_regions[space_id];
+	if (!acpi_region_managed(rgn))
+		return;
+
+	mutex_lock(&acpi_mutex_region);
+	if (!(rgn->flags & ACPI_REGION_REGISTERED)) {
+		mutex_unlock(&acpi_mutex_region);
+		return;
+	}
+	if (rgn->flags & ACPI_REGION_UNREGISTERING) {
+		mutex_unlock(&acpi_mutex_region);
+		return;
+	}
+
+	rgn->flags |= ACPI_REGION_UNREGISTERING;
+	rgn->handler = NULL;
+	rgn->setup = NULL;
+	rgn->context = NULL;
+	mutex_unlock(&acpi_mutex_region);
+
+	while (atomic_read(&rgn->refcnt) > 1)
+		schedule_timeout_uninterruptible(usecs_to_jiffies(5));
+	atomic_dec(&rgn->refcnt);
+
+	mutex_lock(&acpi_mutex_region);
+	rgn->flags &= ~(ACPI_REGION_REGISTERED | ACPI_REGION_UNREGISTERING);
+	mutex_unlock(&acpi_mutex_region);
+
+	pr_info("Region %d unregistered\n", space_id);
+}
+EXPORT_SYMBOL_GPL(acpi_unregister_region);
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index a2c2fbb..15fad0d 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -542,4 +542,9 @@ static inline int unregister_acpi_bus_type(void *bus) { return 0; }
 
 #endif				/* CONFIG_ACPI */
 
+int acpi_register_region(acpi_adr_space_type space_id,
+			 acpi_adr_space_handler handler,
+			 acpi_adr_space_setup setup, void *context);
+void acpi_unregister_region(acpi_adr_space_type space_id);
+
 #endif /*__ACPI_BUS_H__*/
-- 
1.7.10

