Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab3LQJc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:32:27 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:43101 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab3LQJcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:32:25 -0500
Date: Tue, 17 Dec 2013 15:02:14 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-acpi@vger.kernel.org, josh@joshtriplett.org
Subject: [PATCH 09/11] drivers: acpi: Remove unused function in ec.c and add
 prototype declaration in header file internal.h
Message-ID: <5cb8c4062f65223dbde9e595af87bea0fc690b85.1387271324.git.rashika.kheria@gmail.com>
References: <c676af6619fc5a84208740bfc7edcf56bb78ed4e.1387271324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c676af6619fc5a84208740bfc7edcf56bb78ed4e.1387271324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds the prototype declarations of functions acpi_ec_add_query_handler()
and acpi_ec_remove_query_handler() in header file internal.h and removes
unused functions ec_burst_enable() and ec_burst_disable() in ec.c.

This eliminates the following warnings in ec.c:
drivers/acpi/ec.c:393:5: warning: no previous prototype for ‘ec_burst_enable’ [-Wmissing-prototypes]
drivers/acpi/ec.c:402:5: warning: no previous prototype for ‘ec_burst_disable’ [-Wmissing-prototypes]
drivers/acpi/ec.c:531:5: warning: no previous prototype for ‘acpi_ec_add_query_handler’ [-Wmissing-prototypes]
drivers/acpi/ec.c:552:6: warning: no previous prototype for ‘acpi_ec_remove_query_handler’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/acpi/ec.c       |   25 -------------------------
 drivers/acpi/internal.h |    9 +++++++++
 2 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index ba5b56d..5391e02 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -91,10 +91,6 @@ static unsigned int ec_storm_threshold  __read_mostly = 8;
 module_param(ec_storm_threshold, uint, 0644);
 MODULE_PARM_DESC(ec_storm_threshold, "Maxim false GPE numbers not considered as GPE storm");
 
-/* If we find an EC via the ECDT, we need to keep a ptr to its context */
-/* External interfaces use first EC only, so remember */
-typedef int (*acpi_ec_query_func) (void *data);
-
 struct acpi_ec_query_handler {
 	struct list_head node;
 	acpi_ec_query_func func;
@@ -387,27 +383,6 @@ static int acpi_ec_write(struct acpi_ec *ec, u8 address, u8 data)
 	return acpi_ec_transaction(ec, &t);
 }
 
-/*
- * Externally callable EC access functions. For now, assume 1 EC only
- */
-int ec_burst_enable(void)
-{
-	if (!first_ec)
-		return -ENODEV;
-	return acpi_ec_burst_enable(first_ec);
-}
-
-EXPORT_SYMBOL(ec_burst_enable);
-
-int ec_burst_disable(void)
-{
-	if (!first_ec)
-		return -ENODEV;
-	return acpi_ec_burst_disable(first_ec);
-}
-
-EXPORT_SYMBOL(ec_burst_disable);
-
 int ec_read(u8 addr, u8 *val)
 {
 	int err;
diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index a29739c..8ef9787 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -127,12 +127,21 @@ struct acpi_ec {
 
 extern struct acpi_ec *first_ec;
 
+/* If we find an EC via the ECDT, we need to keep a ptr to its context */
+/* External interfaces use first EC only, so remember */
+typedef int (*acpi_ec_query_func) (void *data);
+
 int acpi_ec_init(void);
 int acpi_ec_ecdt_probe(void);
 int acpi_boot_ec_enable(void);
 void acpi_ec_block_transactions(void);
 void acpi_ec_unblock_transactions(void);
 void acpi_ec_unblock_transactions_early(void);
+int acpi_ec_add_query_handler(struct acpi_ec *ec, u8 query_bit,
+			      acpi_handle handle, acpi_ec_query_func func,
+			      void *data);
+void acpi_ec_remove_query_handler(struct acpi_ec *ec, u8 query_bit);
+
 
 /*--------------------------------------------------------------------------
                                   Suspend/Resume
-- 
1.7.9.5

