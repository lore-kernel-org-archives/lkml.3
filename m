Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaGUGF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 02:05:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:54826 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbaGUGFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 02:05:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,698,1400050800"; 
   d="scan'208";a="546449764"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH v3 05/14] ACPI/EC: Add reference counting for query handlers.
Date: Mon, 21 Jul 2014 14:05:33 +0800
Message-Id: <ac24feef2bd81e5d28975fd1e26e67b9c808b852.1405922585.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1405922585.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <cover.1405922585.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds reference counting for query handlers in order to eliminate
kmalloc()/kfree() usage.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Tested-by: Steffen Weber <steffen.weber@gmail.com>
---
 drivers/acpi/ec.c |   46 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 1c3704c..8195cd6 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -107,6 +107,7 @@ struct acpi_ec_query_handler {
 	acpi_handle handle;
 	void *data;
 	u8 query_bit;
+	struct kref kref;
 };
 
 struct transaction {
@@ -121,6 +122,10 @@ struct transaction {
 	u8 flags;
 };
 
+static struct acpi_ec_query_handler *
+acpi_ec_get_query_handler(struct acpi_ec_query_handler *handler);
+static void acpi_ec_put_query_handler(struct acpi_ec_query_handler *handler);
+
 struct acpi_ec *boot_ec, *first_ec;
 EXPORT_SYMBOL(first_ec);
 
@@ -624,6 +629,26 @@ static int acpi_ec_query_unlocked(struct acpi_ec *ec, u8 * data)
 /* --------------------------------------------------------------------------
                                 Event Management
    -------------------------------------------------------------------------- */
+static struct acpi_ec_query_handler *
+acpi_ec_get_query_handler(struct acpi_ec_query_handler *handler)
+{
+	if (handler)
+		kref_get(&handler->kref);
+	return handler;
+}
+
+static void acpi_ec_query_handler_release(struct kref *kref)
+{
+	struct acpi_ec_query_handler *handler =
+		container_of(kref, struct acpi_ec_query_handler, kref);
+	kfree(handler);
+}
+
+static void acpi_ec_put_query_handler(struct acpi_ec_query_handler *handler)
+{
+	kref_put(&handler->kref, acpi_ec_query_handler_release);
+}
+
 int acpi_ec_add_query_handler(struct acpi_ec *ec, u8 query_bit,
 			      acpi_handle handle, acpi_ec_query_func func,
 			      void *data)
@@ -638,6 +663,7 @@ int acpi_ec_add_query_handler(struct acpi_ec *ec, u8 query_bit,
 	handler->func = func;
 	handler->data = data;
 	mutex_lock(&ec->mutex);
+	kref_init(&handler->kref);
 	list_add(&handler->node, &ec->list);
 	mutex_unlock(&ec->mutex);
 	return 0;
@@ -648,14 +674,17 @@ EXPORT_SYMBOL_GPL(acpi_ec_add_query_handler);
 void acpi_ec_remove_query_handler(struct acpi_ec *ec, u8 query_bit)
 {
 	struct acpi_ec_query_handler *handler, *tmp;
+	LIST_HEAD(free_list);
 	mutex_lock(&ec->mutex);
 	list_for_each_entry_safe(handler, tmp, &ec->list, node) {
 		if (query_bit == handler->query_bit) {
-			list_del(&handler->node);
-			kfree(handler);
+			list_del_init(&handler->node);
+			list_add(&handler->node, &free_list);
 		}
 	}
 	mutex_unlock(&ec->mutex);
+	list_for_each_entry(handler, &free_list, node)
+		acpi_ec_put_query_handler(handler);
 }
 
 EXPORT_SYMBOL_GPL(acpi_ec_remove_query_handler);
@@ -671,14 +700,14 @@ static void acpi_ec_run(void *cxt)
 	else if (handler->handle)
 		acpi_evaluate_object(handler->handle, NULL, NULL, NULL);
 	pr_debug("stop query execution\n");
-	kfree(handler);
+	acpi_ec_put_query_handler(handler);
 }
 
 static int acpi_ec_sync_query(struct acpi_ec *ec, u8 *data)
 {
 	u8 value = 0;
 	int status;
-	struct acpi_ec_query_handler *handler, *copy;
+	struct acpi_ec_query_handler *handler;
 
 	status = acpi_ec_query_unlocked(ec, &value);
 	if (data)
@@ -689,15 +718,12 @@ static int acpi_ec_sync_query(struct acpi_ec *ec, u8 *data)
 	list_for_each_entry(handler, &ec->list, node) {
 		if (value == handler->query_bit) {
 			/* have custom handler for this bit */
-			copy = kmalloc(sizeof(*handler), GFP_KERNEL);
-			if (!copy)
-				return -ENOMEM;
-			memcpy(copy, handler, sizeof(*copy));
+			handler = acpi_ec_get_query_handler(handler);
 			pr_debug("push query execution (0x%2x) on queue\n",
 				value);
-			return acpi_os_execute((copy->func) ?
+			return acpi_os_execute((handler->func) ?
 				OSL_NOTIFY_HANDLER : OSL_GPE_HANDLER,
-				acpi_ec_run, copy);
+				acpi_ec_run, handler);
 		}
 	}
 	return 0;
-- 
1.7.10

