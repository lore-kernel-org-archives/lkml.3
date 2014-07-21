Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaGUGJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 02:09:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:30036 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbaGUGGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 02:06:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,698,1400050800"; 
   d="scan'208";a="459362850"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH v3 08/14] ACPI/EC: Refine event/query debugging messages.
Date: Mon, 21 Jul 2014 14:05:56 +0800
Message-Id: <38117596fb81f2a6be04fdaba0d22deb6bfee8b8.1405922585.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1405922585.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <cover.1405922585.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch refines event/query debugging messages to use a unified format
as commands. Developers can clearly find different processes by checking
different log seperators. No functional changes.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/ec.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 81f4b17..a729f31 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -405,8 +405,10 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 	pr_debug("***** Command(%s) started *****\n",
 		 acpi_ec_cmd_string(t->command));
 	start_transaction(ec);
-	if (ec->curr->command == ACPI_EC_COMMAND_QUERY)
+	if (ec->curr->command == ACPI_EC_COMMAND_QUERY) {
 		clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
+		pr_debug("***** Event stopped *****\n");
+	}
 	spin_unlock_irqrestore(&ec->lock, tmp);
 	ret = ec_poll(ec);
 	spin_lock_irqsave(&ec->lock, tmp);
@@ -748,12 +750,12 @@ static void acpi_ec_run(void *cxt)
 	struct acpi_ec_query_handler *handler = cxt;
 	if (!handler)
 		return;
-	pr_debug("start query execution\n");
+	pr_debug("##### Query(0x%02x) started #####\n", handler->query_bit);
 	if (handler->func)
 		handler->func(handler->data);
 	else if (handler->handle)
 		acpi_evaluate_object(handler->handle, NULL, NULL, NULL);
-	pr_debug("stop query execution\n");
+	pr_debug("##### Query(0x%02x) stopped #####\n", handler->query_bit);
 	acpi_ec_put_query_handler(handler);
 }
 
@@ -765,8 +767,8 @@ static int acpi_ec_notify_query_handlers(struct acpi_ec *ec, u8 query_bit)
 		if (query_bit == handler->query_bit) {
 			/* have custom handler for this bit */
 			handler = acpi_ec_get_query_handler(handler);
-			pr_debug("push query execution (0x%2x) on queue\n",
-				 query_bit);
+			pr_debug("##### Query(0x%02x) scheduled #####\n",
+				 handler->query_bit);
 			return acpi_os_execute((handler->func) ?
 				OSL_NOTIFY_HANDLER : OSL_GPE_HANDLER,
 				acpi_ec_run, handler);
@@ -804,7 +806,7 @@ static int ec_check_sci(struct acpi_ec *ec, u8 state)
 {
 	if (state & ACPI_EC_FLAG_SCI) {
 		if (!test_and_set_bit(EC_FLAGS_QUERY_PENDING, &ec->flags)) {
-			pr_debug("push gpe query to the queue\n");
+			pr_debug("***** Event started *****\n");
 			return acpi_os_execute(OSL_NOTIFY_HANDLER,
 				acpi_ec_gpe_query, ec);
 		}
-- 
1.7.10

