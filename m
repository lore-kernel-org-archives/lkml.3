Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbaGUGIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 02:08:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:27135 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbaGUGGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 02:06:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,698,1400050800"; 
   d="scan'208";a="546449826"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH v3 07/14] ACPI/EC: Add a warning message to indicate event storms.
Date: Mon, 21 Jul 2014 14:05:48 +0800
Message-Id: <5ddcbe01e5ea22c42e926a7624e070c941c205c4.1405922585.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1405922585.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <cover.1405922585.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch splits query handler scheduling into a new seperate function
acpi_ec_notify_query_handlers() and adds a warning message in it to
indicate a BIOS bug. It is reported that EC event storm can happen in case
there is no _Qxx method prepared for the event. No functional changes.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=78091
Reported-by: Steffen Weber <steffen.weber@gmail.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/ec.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index c8d205c..81f4b17 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -757,32 +757,39 @@ static void acpi_ec_run(void *cxt)
 	acpi_ec_put_query_handler(handler);
 }
 
-static int acpi_ec_sync_query(struct acpi_ec *ec, u8 *data)
+static int acpi_ec_notify_query_handlers(struct acpi_ec *ec, u8 query_bit)
 {
-	u8 value = 0;
-	int status;
 	struct acpi_ec_query_handler *handler;
 
-	status = acpi_ec_query_unlocked(ec, &value);
-	if (data)
-		*data = value;
-	if (status)
-		return status;
-
 	list_for_each_entry(handler, &ec->list, node) {
-		if (value == handler->query_bit) {
+		if (query_bit == handler->query_bit) {
 			/* have custom handler for this bit */
 			handler = acpi_ec_get_query_handler(handler);
 			pr_debug("push query execution (0x%2x) on queue\n",
-				value);
+				 query_bit);
 			return acpi_os_execute((handler->func) ?
 				OSL_NOTIFY_HANDLER : OSL_GPE_HANDLER,
 				acpi_ec_run, handler);
 		}
 	}
+	pr_warn_once("BIOS bug: no handler for query (0x%02x)\n", query_bit);
 	return 0;
 }
 
+static int acpi_ec_sync_query(struct acpi_ec *ec, u8 *data)
+{
+	u8 value = 0;
+	int status;
+
+	status = acpi_ec_query_unlocked(ec, &value);
+	if (data)
+		*data = value;
+	if (status)
+		return status;
+
+	return acpi_ec_notify_query_handlers(ec, value);
+}
+
 static void acpi_ec_gpe_query(void *ec_cxt)
 {
 	struct acpi_ec *ec = ec_cxt;
-- 
1.7.10

