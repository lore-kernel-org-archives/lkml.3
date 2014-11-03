Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305AbaKCFQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 00:16:37 -0500
Received: from mga09.intel.com ([134.134.136.24]:31865 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaKCFQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 00:16:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,305,1413270000"; 
   d="scan'208";a="600877216"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 3/6] ACPI/EC: Add reference counting for query handlers.
Date: Mon,  3 Nov 2014 13:16:25 +0800
Message-Id: <a2f86ca94eb1bd2a0e1a06ba9486d5daafba7e8b.1414988981.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1414988981.git.lv.zheng@intel.com>
References: <cover.1414988981.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds reference counting for query handlers in order to eliminate
kmalloc()/kfree() usage.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Tested-by: Steffen Weber <steffen.weber@gmail.com>
Tested-by: Ortwin Glück <odi@odi.ch>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/ec.c |   47 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 9a51f7a..69e4f35 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -106,6 +106,7 @@ struct acpi_ec_query_handler {
 	acpi_handle handle;
 	void *data;
 	u8 query_bit;
+	struct kref kref;
 };
 
 struct transaction {
@@ -120,6 +121,10 @@ struct transaction {
 	u8 flags;
 };
 
+static struct acpi_ec_query_handler *
+acpi_ec_get_query_handler(struct acpi_ec_query_handler *handler);
+static void acpi_ec_put_query_handler(struct acpi_ec_query_handler *handler);
+
 struct acpi_ec *boot_ec, *first_ec;
 EXPORT_SYMBOL(first_ec);
 
@@ -619,6 +624,27 @@ static int acpi_ec_query_unlocked(struct acpi_ec *ec, u8 *data)
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
+
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
@@ -634,6 +660,7 @@ int acpi_ec_add_query_handler(struct acpi_ec *ec, u8 query_bit,
 	handler->func = func;
 	handler->data = data;
 	mutex_lock(&ec->mutex);
+	kref_init(&handler->kref);
 	list_add(&handler->node, &ec->list);
 	mutex_unlock(&ec->mutex);
 	return 0;
@@ -643,15 +670,18 @@ EXPORT_SYMBOL_GPL(acpi_ec_add_query_handler);
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
 
@@ -667,14 +697,14 @@ static void acpi_ec_run(void *cxt)
 	else if (handler->handle)
 		acpi_evaluate_object(handler->handle, NULL, NULL, NULL);
 	pr_debug("##### Query(0x%02x) stopped #####\n", handler->query_bit);
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
@@ -685,15 +715,12 @@ static int acpi_ec_sync_query(struct acpi_ec *ec, u8 *data)
 	list_for_each_entry(handler, &ec->list, node) {
 		if (value == handler->query_bit) {
 			/* have custom handler for this bit */
-			copy = kmalloc(sizeof(*handler), GFP_KERNEL);
-			if (!copy)
-				return -ENOMEM;
-			memcpy(copy, handler, sizeof(*copy));
+			handler = acpi_ec_get_query_handler(handler);
 			pr_debug("##### Query(0x%02x) scheduled #####\n",
 				 handler->query_bit);
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

