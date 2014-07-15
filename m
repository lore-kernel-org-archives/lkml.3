Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779AbaGODPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:15:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:37903 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757663AbaGODPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:15:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,662,1400050800"; 
   d="scan'208";a="569861460"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v2 04/10] ACPI/EC: Refine command storm prevention support.
Date: Tue, 15 Jul 2014 11:14:47 +0800
Message-Id: <8f414917277bc491ddc0f3862f9c10ba848f63d9.1405391679.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1405391678.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <cover.1405391678.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch refines EC command storm prevention support.

Ideally, we should only enable storm prevention for the current command so
that the next command can try the efficient interrupt mode again.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/ec.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 5049981..d4c07b9 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -76,7 +76,6 @@ enum ec_command {
 
 enum {
 	EC_FLAGS_QUERY_PENDING,		/* Query is pending */
-	EC_FLAGS_GPE_STORM,		/* GPE storm detected */
 	EC_FLAGS_HANDLERS_INSTALLED,	/* Handlers for GPE and
 					 * OpReg are installed */
 	EC_FLAGS_STARTED,		/* Driver is started */
@@ -243,8 +242,14 @@ err:
 	 * otherwise will take a not handled IRQ as a false one.
 	 */
 	if (!(status & ACPI_EC_FLAG_SCI)) {
-		if (in_interrupt() && t)
-			++t->irq_count;
+		if (in_interrupt() && t) {
+			if (t->irq_count < ec_storm_threshold)
+				++t->irq_count;
+			if (t->irq_count == ec_storm_threshold) {
+				pr_debug("+++++ Polling enabled +++++\n");
+				acpi_set_gpe(NULL, ec->gpe, ACPI_GPE_DISABLE);
+			}
+		}
 	}
 	return wakeup;
 }
@@ -318,23 +323,15 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 	acpi_enable_gpe(NULL, ec->gpe);
 	pr_debug("***** Command(%s) started *****\n",
 		 acpi_ec_cmd_string(t->command));
-	if (test_bit(EC_FLAGS_GPE_STORM, &ec->flags)) {
-		pr_debug("+++++ Polling enabled +++++\n");
-		acpi_set_gpe(NULL, ec->gpe, ACPI_GPE_DISABLE);
-	}
 	start_transaction(ec);
 	if (ec->curr->command == ACPI_EC_COMMAND_QUERY)
 		clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
 	spin_unlock_irqrestore(&ec->lock, tmp);
 	ret = ec_poll(ec);
 	spin_lock_irqsave(&ec->lock, tmp);
-	if (test_bit(EC_FLAGS_GPE_STORM, &ec->flags)) {
+	if (t->irq_count == ec_storm_threshold) {
 		acpi_set_gpe(NULL, ec->gpe, ACPI_GPE_ENABLE);
 		pr_debug("+++++ Polling disabled +++++\n");
-	} else if (t->irq_count > ec_storm_threshold) {
-		pr_debug("+++++ Polling scheduled (%d GPE) +++++\n",
-			 t->irq_count);
-		set_bit(EC_FLAGS_GPE_STORM, &ec->flags);
 	}
 	pr_debug("***** Command(%s) stopped *****\n",
 		 acpi_ec_cmd_string(t->command));
-- 
1.7.10

