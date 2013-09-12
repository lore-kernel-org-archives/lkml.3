Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab3ILHeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 03:34:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:31918 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182Ab3ILHeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 03:34:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,889,1371106800"; 
   d="scan'208";a="394579331"
From: tianyu.lan@intel.com
To: tianyu.lan@intel.com, lenb@kernel.org, rjw@sisk.pl,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ACPI/EC: Convert all printk to dynamic debug function
Date: Thu, 12 Sep 2013 03:32:04 -0400
Message-Id: <1378971125-8896-3-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1378971125-8896-1-git-send-email-tianyu.lan@intel.com>
References: <1378971125-8896-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lan Tianyu <tianyu.lan@intel.com>

This patch is to convert all printks in the ec driver to pr_debug/info/err
and define pr_fmt macro to replace PREFIX.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/ec.c | 49 ++++++++++++++++++++++++-------------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index a06d983..d5309fd 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -28,6 +28,7 @@
 
 /* Uncomment next line to get verbose printout */
 /* #define DEBUG */
+#define pr_fmt(fmt) "ACPI : EC: " fmt
 
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -49,9 +50,6 @@
 #define ACPI_EC_DEVICE_NAME		"Embedded Controller"
 #define ACPI_EC_FILE_INFO		"info"
 
-#undef PREFIX
-#define PREFIX				"ACPI: EC: "
-
 /* EC status register */
 #define ACPI_EC_FLAG_OBF	0x01	/* Output buffer full */
 #define ACPI_EC_FLAG_IBF	0x02	/* Input buffer full */
@@ -131,26 +129,26 @@ static int EC_FLAGS_SKIP_DSDT_SCAN; /* Not all BIOS survive early DSDT scan */
 static inline u8 acpi_ec_read_status(struct acpi_ec *ec)
 {
 	u8 x = inb(ec->command_addr);
-	pr_debug(PREFIX "---> status = 0x%2.2x\n", x);
+	pr_debug("---> status = 0x%2.2x\n", x);
 	return x;
 }
 
 static inline u8 acpi_ec_read_data(struct acpi_ec *ec)
 {
 	u8 x = inb(ec->data_addr);
-	pr_debug(PREFIX "---> data = 0x%2.2x\n", x);
+	pr_debug("---> data = 0x%2.2x\n", x);
 	return x;
 }
 
 static inline void acpi_ec_write_cmd(struct acpi_ec *ec, u8 command)
 {
-	pr_debug(PREFIX "<--- command = 0x%2.2x\n", command);
+	pr_debug("<--- command = 0x%2.2x\n", command);
 	outb(command, ec->command_addr);
 }
 
 static inline void acpi_ec_write_data(struct acpi_ec *ec, u8 data)
 {
-	pr_debug(PREFIX "<--- data = 0x%2.2x\n", data);
+	pr_debug("<--- data = 0x%2.2x\n", data);
 	outb(data, ec->data_addr);
 }
 
@@ -241,7 +239,7 @@ static int ec_poll(struct acpi_ec *ec)
 			}
 			advance_transaction(ec, acpi_ec_read_status(ec));
 		} while (time_before(jiffies, delay));
-		pr_debug(PREFIX "controller reset, restart transaction\n");
+		pr_debug("controller reset, restart transaction\n");
 		spin_lock_irqsave(&ec->lock, flags);
 		start_transaction(ec);
 		spin_unlock_irqrestore(&ec->lock, flags);
@@ -309,12 +307,12 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
 		}
 	}
 	if (ec_wait_ibf0(ec)) {
-		pr_err(PREFIX "input buffer is not empty, "
+		pr_err("input buffer is not empty, "
 				"aborting transaction\n");
 		status = -ETIME;
 		goto end;
 	}
-	pr_debug(PREFIX "transaction start (cmd=0x%02x, addr=0x%02x)\n",
+	pr_debug("transaction start (cmd=0x%02x, addr=0x%02x)\n",
 			t->command, t->wdata ? t->wdata[0] : 0);
 	/* disable GPE during transaction if storm is detected */
 	if (test_bit(EC_FLAGS_GPE_STORM, &ec->flags)) {
@@ -331,12 +329,12 @@ static int acpi_ec_transaction(struct acpi_ec *ec, struct transaction *t)
 		/* It is safe to enable the GPE outside of the transaction. */
 		acpi_enable_gpe(NULL, ec->gpe);
 	} else if (t->irq_count > ec_storm_threshold) {
-		pr_info(PREFIX "GPE storm detected(%d GPEs), "
+		pr_info("GPE storm detected(%d GPEs), "
 			"transactions will use polling mode\n",
 			t->irq_count);
 		set_bit(EC_FLAGS_GPE_STORM, &ec->flags);
 	}
-	pr_debug(PREFIX "transaction end\n");
+	pr_debug("transaction end\n");
 end:
 	if (ec->global_lock)
 		acpi_release_global_lock(glk);
@@ -570,12 +568,12 @@ static void acpi_ec_run(void *cxt)
 	struct acpi_ec_query_handler *handler = cxt;
 	if (!handler)
 		return;
-	pr_debug(PREFIX "start query execution\n");
+	pr_debug("start query execution\n");
 	if (handler->func)
 		handler->func(handler->data);
 	else if (handler->handle)
 		acpi_evaluate_object(handler->handle, NULL, NULL, NULL);
-	pr_debug(PREFIX "stop query execution\n");
+	pr_debug("stop query execution\n");
 	kfree(handler);
 }
 
@@ -593,7 +591,8 @@ static int acpi_ec_sync_query(struct acpi_ec *ec)
 			if (!copy)
 				return -ENOMEM;
 			memcpy(copy, handler, sizeof(*copy));
-			pr_debug(PREFIX "push query execution (0x%2x) on queue\n", value);
+			pr_debug("push query execution (0x%2x) on queue\n",
+				value);
 			return acpi_os_execute((copy->func) ?
 				OSL_NOTIFY_HANDLER : OSL_GPE_HANDLER,
 				acpi_ec_run, copy);
@@ -616,7 +615,7 @@ static int ec_check_sci(struct acpi_ec *ec, u8 state)
 {
 	if (state & ACPI_EC_FLAG_SCI) {
 		if (!test_and_set_bit(EC_FLAGS_QUERY_PENDING, &ec->flags)) {
-			pr_debug(PREFIX "push gpe query to the queue\n");
+			pr_debug("push gpe query to the queue\n");
 			return acpi_os_execute(OSL_NOTIFY_HANDLER,
 				acpi_ec_gpe_query, ec);
 		}
@@ -630,7 +629,7 @@ static u32 acpi_ec_gpe_handler(acpi_handle gpe_device,
 	struct acpi_ec *ec = data;
 	u8 status = acpi_ec_read_status(ec);
 
-	pr_debug(PREFIX "~~~> interrupt, status:0x%02x\n", status);
+	pr_debug("~~~> interrupt, status:0x%02x\n", status);
 
 	advance_transaction(ec, status);
 	if (ec_transaction_done(ec) &&
@@ -776,7 +775,7 @@ static int ec_install_handlers(struct acpi_ec *ec)
 			 * The AE_NOT_FOUND error will be ignored and OS
 			 * continue to initialize EC.
 			 */
-			printk(KERN_ERR "Fail in evaluating the _REG object"
+			pr_err("Fail in evaluating the _REG object"
 				" of EC device. Broken bios is suspected.\n");
 		} else {
 			acpi_remove_gpe_handler(NULL, ec->gpe,
@@ -795,10 +794,10 @@ static void ec_remove_handlers(struct acpi_ec *ec)
 	acpi_disable_gpe(NULL, ec->gpe);
 	if (ACPI_FAILURE(acpi_remove_address_space_handler(ec->handle,
 				ACPI_ADR_SPACE_EC, &acpi_ec_space_handler)))
-		pr_err(PREFIX "failed to remove space handler\n");
+		pr_err("failed to remove space handler\n");
 	if (ACPI_FAILURE(acpi_remove_gpe_handler(NULL, ec->gpe,
 				&acpi_ec_gpe_handler)))
-		pr_err(PREFIX "failed to remove gpe handler\n");
+		pr_err("failed to remove gpe handler\n");
 	clear_bit(EC_FLAGS_HANDLERS_INSTALLED, &ec->flags);
 }
 
@@ -840,7 +839,7 @@ static int acpi_ec_add(struct acpi_device *device)
 	ret = !!request_region(ec->command_addr, 1, "EC cmd");
 	WARN(!ret, "Could not request EC cmd io port 0x%lx", ec->command_addr);
 
-	pr_info(PREFIX "GPE = 0x%lx, I/O: command/status = 0x%lx, data = 0x%lx\n",
+	pr_info("GPE = 0x%lx, I/O: command/status = 0x%lx, data = 0x%lx\n",
 			  ec->gpe, ec->command_addr, ec->data_addr);
 
 	ret = ec_install_handlers(ec);
@@ -931,7 +930,7 @@ static int ec_validate_ecdt(const struct dmi_system_id *id)
 /* MSI EC needs special treatment, enable it */
 static int ec_flag_msi(const struct dmi_system_id *id)
 {
-	printk(KERN_DEBUG PREFIX "Detected MSI hardware, enabling workarounds.\n");
+	pr_debug("Detected MSI hardware, enabling workarounds.\n");
 	EC_FLAGS_MSI = 1;
 	EC_FLAGS_VALIDATE_ECDT = 1;
 	return 0;
@@ -1010,7 +1009,7 @@ int __init acpi_ec_ecdt_probe(void)
 	status = acpi_get_table(ACPI_SIG_ECDT, 1,
 				(struct acpi_table_header **)&ecdt_ptr);
 	if (ACPI_SUCCESS(status)) {
-		pr_info(PREFIX "EC description table is found, configuring boot EC\n");
+		pr_info("EC description table is found, configuring boot EC\n");
 		boot_ec->command_addr = ecdt_ptr->control.address;
 		boot_ec->data_addr = ecdt_ptr->data.address;
 		boot_ec->gpe = ecdt_ptr->gpe;
@@ -1030,7 +1029,7 @@ int __init acpi_ec_ecdt_probe(void)
 
 	/* This workaround is needed only on some broken machines,
 	 * which require early EC, but fail to provide ECDT */
-	printk(KERN_DEBUG PREFIX "Look up EC in DSDT\n");
+	pr_debug("Look up EC in DSDT\n");
 	status = acpi_get_devices(ec_device_ids[0].id, ec_parse_device,
 					boot_ec, NULL);
 	/* Check that acpi_get_devices actually find something */
@@ -1042,7 +1041,7 @@ int __init acpi_ec_ecdt_probe(void)
 		    saved_ec->data_addr != boot_ec->data_addr ||
 		    saved_ec->gpe != boot_ec->gpe ||
 		    saved_ec->handle != boot_ec->handle)
-			pr_info(PREFIX "ASUSTek keeps feeding us with broken "
+			pr_info("ASUSTek keeps feeding us with broken "
 			"ECDT tables, which are very hard to workaround. "
 			"Trying to use DSDT EC info instead. Please send "
 			"output of acpidump to linux-acpi@vger.kernel.org\n");
-- 
1.8.2.1

