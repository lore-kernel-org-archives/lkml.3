Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbaKUA52 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 19:57:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:35290 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756640AbaKUA50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 19:57:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,426,1413270000"; 
   d="scan'208";a="635596286"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [UPDATE RFC PATCH 2] ACPICA: Events: Introduce ACPI_GPE_HANDLER_RAW to fix 2 issues for the current GPE APIs.
Date: Fri, 21 Nov 2014 08:57:14 +0800
Message-Id: <1416531434-3454-1-git-send-email-lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
Data: Mon, 16 Jun 2014 21:34:24 +0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(update due to a missing flag set in ec.c)

Since whether the GPE should be disabled/enabled/cleared should only be
determined by the GPE driver's state machine:
1. GPE should be disabled if the driver wants to switch to the GPE polling
   mode when a GPE storm condition is indicated and should be enabled if
   the driver wants to switch back to the GPE interrupt mode when all of
   the storm conditions are cleared. The conditions should be protected by
   the driver's specific lock.
2. GPE should be enabled if the driver has accepted more than one request
   and should be disabled if the driver has completed all of the requests.
   The request count should be protected by the driver's specific lock.
3. GPE should be cleared either when the driver is about to handle an edge
   triggered GPE or when the driver has completed to handle a level
   triggered GPE. The handling code should be protected by the driver's
   specific lock.
Thus the GPE enabling/disabling/clearing operations are likely to be
performed with the driver's specific lock held while we currently cannot do
this. This is because:
1. We have the acpi_gbl_gpe_lock held before invoking the GPE driver's
   handler. Driver's specific lock is likely to be held inside of the
   handler, thus we can see some dead lock issues due to the reversed
   locking order or recursive locking. In order to solve such dead lock
   issues, we need to unlock the acpi_gbl_gpe_lock before invoking the
   handler. BZ 1100.
2. Since GPE disabling/enabling/clearing should be determined by the GPE
   driver's state machine, we shouldn't perform such operations inside of
   ACPICA for a GPE handler to mess up the driver's state machine. BZ 1101.
Originally this patch includes a logic to flush GPE handlers, it is dropped
due to the following reasons:
1. This is a different issue;
2. Currently all Linux GPE drivers are either protected by acpi_gbl_gpe_lock
   or not a removable module, thus this is not an existing issue for now.
We will pick up this topic when a removable GPE driver uses the raw GPE
handling model.

Note that currently the internal operations and the acpi_gbl_gpe_lock are
also used by ACPI_GPE_DISPATCH_METHOD and ACPI_GPE_DISPATCH_NOTIFY, in
order not to introduce regressions, we add one ACPI_GPE_HANDLER_RAW flag to
be paired with ACPI_GPE_DISPATCH_HANDLER. For which the acpi_gbl_gpe_lock is
unlocked before invoking the GPE handler and the internal
enabling/disabling/clearing operations are bypassed to allow drivers to
perform them at a proper position using the GPE APIs. Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/acevents.h |    9 -
 drivers/acpi/acpica/aclocal.h  |    1 
 drivers/acpi/acpica/evgpe.c    |  331 +++++++++++++++++++++++++++++++++++------
 drivers/acpi/acpica/evgpeblk.c |    3 
 drivers/acpi/acpica/evxface.c  |   21 +-
 drivers/acpi/acpica/evxfgpe.c  |    8 
 include/acpi/acpixf.h          |    3 
 include/acpi/actypes.h         |   24 +-
 8 files changed, 336 insertions(+), 64 deletions(-)

Index: linux-acpica/drivers/acpi/acpica/acevents.h
===================================================================
--- linux-acpica.orig/drivers/acpi/acpica/acevents.h
+++ linux-acpica/drivers/acpi/acpica/acevents.h
@@ -80,12 +80,19 @@ acpi_status acpi_ev_remove_global_lock_h
 u32 acpi_ev_gpe_detect(struct acpi_gpe_xrupt_info *gpe_xrupt_list);
 
 acpi_status
+acpi_ev_clear_gpe_status(struct acpi_gpe_event_info *gpe_event_info);
+
+acpi_status
+acpi_ev_update_gpe_status(struct acpi_gpe_event_info *gpe_event_info);
+
+acpi_status
 acpi_ev_update_gpe_enable_mask(struct acpi_gpe_event_info *gpe_event_info);
 
 acpi_status acpi_ev_enable_gpe(struct acpi_gpe_event_info *gpe_event_info);
 
 acpi_status
-acpi_ev_add_gpe_reference(struct acpi_gpe_event_info *gpe_event_info);
+acpi_ev_add_gpe_reference(struct acpi_gpe_event_info *gpe_event_info,
+			  u8 clear_stale_events);
 
 acpi_status
 acpi_ev_remove_gpe_reference(struct acpi_gpe_event_info *gpe_event_info);
Index: linux-acpica/drivers/acpi/acpica/aclocal.h
===================================================================
--- linux-acpica.orig/drivers/acpi/acpica/aclocal.h
+++ linux-acpica/drivers/acpi/acpica/aclocal.h
@@ -454,6 +454,7 @@ struct acpi_gpe_register_info {
 	u16 base_gpe_number;	/* Base GPE number for this register */
 	u8 enable_for_wake;	/* GPEs to keep enabled when sleeping */
 	u8 enable_for_run;	/* GPEs to keep enabled when running */
+	u8 raw_enabled_status_byte;	/* Track of status reg for raw handlers */
 };
 
 /*
Index: linux-acpica/drivers/acpi/acpica/evgpe.c
===================================================================
--- linux-acpica.orig/drivers/acpi/acpica/evgpe.c
+++ linux-acpica/drivers/acpi/acpica/evgpe.c
@@ -54,6 +54,149 @@ static void ACPI_SYSTEM_XFACE acpi_ev_as
 
 static void ACPI_SYSTEM_XFACE acpi_ev_asynch_enable_gpe(void *context);
 
+static acpi_status
+acpi_ev_get_gpe_enabled_status(struct acpi_gpe_register_info *gpe_register_info,
+			       u8 *enabled_status_byte);
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_ev_get_gpe_enabled_status
+ *
+ * PARAMETERS:  gpe_event_info          - GPE to update
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Update GPE register status mask to clear the saved raw GPE
+ *              status indication.
+ *
+ ******************************************************************************/
+
+static acpi_status
+acpi_ev_get_gpe_enabled_status(struct acpi_gpe_register_info *gpe_register_info,
+			       u8 *enabled_status_byte)
+{
+	u32 status_reg;
+	u32 enable_reg;
+	acpi_status status;
+
+	ACPI_FUNCTION_TRACE(ev_get_gpe_enabled_status);
+
+	/* Read the Status Register */
+
+	status = acpi_hw_read(&status_reg, &gpe_register_info->status_address);
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(status);
+	}
+
+	/* Read the Enable Register */
+
+	status = acpi_hw_read(&enable_reg, &gpe_register_info->enable_address);
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(status);
+	}
+
+	ACPI_DEBUG_PRINT((ACPI_DB_INTERRUPTS,
+			  "Read registers for GPE %02X-%02X: Status=%02X, Enable=%02X, "
+			  "RunEnable=%02X, WakeEnable=%02X\n",
+			  gpe_register_info->base_gpe_number,
+			  gpe_register_info->base_gpe_number +
+			  (ACPI_GPE_REGISTER_WIDTH - 1), status_reg, enable_reg,
+			  gpe_register_info->enable_for_run,
+			  gpe_register_info->enable_for_wake));
+
+	*enabled_status_byte = (u8)(status_reg & enable_reg);
+	return_ACPI_STATUS(AE_OK);
+}
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_ev_clear_gpe_status
+ *
+ * PARAMETERS:  gpe_event_info          - GPE to update
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Update GPE register status mask to clear the saved raw GPE
+ *              status indication.
+ *
+ ******************************************************************************/
+
+acpi_status acpi_ev_clear_gpe_status(struct acpi_gpe_event_info *gpe_event_info)
+{
+	struct acpi_gpe_register_info *gpe_register_info;
+	u32 register_bit;
+
+	ACPI_FUNCTION_TRACE(ev_clear_gpe_status);
+
+	if (!(gpe_event_info->flags & ACPI_GPE_HANDLER_RAW)) {
+		return_ACPI_STATUS(AE_BAD_PARAMETER);
+	}
+
+	gpe_register_info = gpe_event_info->register_info;
+	if (!gpe_register_info) {
+		return_ACPI_STATUS(AE_NOT_EXIST);
+	}
+
+	/* Clear the raw status bit */
+
+	register_bit = acpi_hw_get_gpe_register_bit(gpe_event_info);
+	ACPI_CLEAR_BIT(gpe_register_info->raw_enabled_status_byte,
+		       register_bit);
+
+	return_ACPI_STATUS(AE_OK);
+}
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_ev_update_gpe_status
+ *
+ * PARAMETERS:  gpe_event_info          - GPE to update
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Update GPE register status mask to set the saved raw GPE status
+ *              indication.
+ *
+ ******************************************************************************/
+
+acpi_status
+acpi_ev_update_gpe_status(struct acpi_gpe_event_info *gpe_event_info)
+{
+	struct acpi_gpe_register_info *gpe_register_info;
+	u32 register_bit;
+	u8 enabled_status_byte;
+	acpi_status status;
+
+	ACPI_FUNCTION_TRACE(ev_update_gpe_status);
+
+	if (!(gpe_event_info->flags & ACPI_GPE_HANDLER_RAW)) {
+		return_ACPI_STATUS(AE_BAD_PARAMETER);
+	}
+
+	gpe_register_info = gpe_event_info->register_info;
+	if (!gpe_register_info) {
+		return_ACPI_STATUS(AE_NOT_EXIST);
+	}
+
+	status = acpi_ev_get_gpe_enabled_status(gpe_register_info,
+						&enabled_status_byte);
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(status);
+	}
+
+	/* Update the raw status bit */
+
+	register_bit = acpi_hw_get_gpe_register_bit(gpe_event_info);
+	if ((enabled_status_byte & (1 << register_bit)) &&
+	    !(gpe_register_info->
+	      raw_enabled_status_byte & (1 << register_bit))) {
+		ACPI_SET_BIT(gpe_register_info->raw_enabled_status_byte,
+			     register_bit);
+	}
+
+	return_ACPI_STATUS(AE_OK);
+}
+
 /*******************************************************************************
  *
  * FUNCTION:    acpi_ev_update_gpe_enable_mask
@@ -132,6 +275,7 @@ acpi_status acpi_ev_enable_gpe(struct ac
  * FUNCTION:    acpi_ev_add_gpe_reference
  *
  * PARAMETERS:  gpe_event_info          - Add a reference to this GPE
+ *              clear_stale_events      - Whether stale events should be cleared
  *
  * RETURN:      Status
  *
@@ -141,7 +285,8 @@ acpi_status acpi_ev_enable_gpe(struct ac
  ******************************************************************************/
 
 acpi_status
-acpi_ev_add_gpe_reference(struct acpi_gpe_event_info *gpe_event_info)
+acpi_ev_add_gpe_reference(struct acpi_gpe_event_info *gpe_event_info,
+			  u8 clear_stale_events)
 {
 	acpi_status status = AE_OK;
 
@@ -158,7 +303,16 @@ acpi_ev_add_gpe_reference(struct acpi_gp
 
 		status = acpi_ev_update_gpe_enable_mask(gpe_event_info);
 		if (ACPI_SUCCESS(status)) {
-			status = acpi_ev_enable_gpe(gpe_event_info);
+			if (clear_stale_events) {
+				status = acpi_ev_enable_gpe(gpe_event_info);
+			} else {
+				status =
+				    acpi_hw_low_set_gpe(gpe_event_info,
+							ACPI_GPE_ENABLE);
+			}
+			if (ACPI_SUCCESS(status)) {
+				(void)acpi_ev_update_gpe_status(gpe_event_info);
+			}
 		}
 
 		if (ACPI_FAILURE(status)) {
@@ -203,6 +357,9 @@ acpi_ev_remove_gpe_reference(struct acpi
 			status =
 			    acpi_hw_low_set_gpe(gpe_event_info,
 						ACPI_GPE_DISABLE);
+			if (ACPI_SUCCESS(status)) {
+				(void)acpi_ev_clear_gpe_status(gpe_event_info);
+			}
 		}
 
 		if (ACPI_FAILURE(status)) {
@@ -329,10 +486,12 @@ u32 acpi_ev_gpe_detect(struct acpi_gpe_x
 	acpi_status status;
 	struct acpi_gpe_block_info *gpe_block;
 	struct acpi_gpe_register_info *gpe_register_info;
+	struct acpi_gpe_event_info *gpe_event_info;
+	struct acpi_gpe_handler_info *gpe_handler_info;
+	struct acpi_namespace_node *gpe_device;
+	u32 gpe_number;
 	u32 int_status = ACPI_INTERRUPT_NOT_HANDLED;
 	u8 enabled_status_byte;
-	u32 status_reg;
-	u32 enable_reg;
 	acpi_cpu_flags flags;
 	u32 i;
 	u32 j;
@@ -387,37 +546,17 @@ u32 acpi_ev_gpe_detect(struct acpi_gpe_x
 				continue;
 			}
 
-			/* Read the Status Register */
+			/* Get the (Enable & Status) register value */
 
 			status =
-			    acpi_hw_read(&status_reg,
-					 &gpe_register_info->status_address);
+			    acpi_ev_get_gpe_enabled_status(gpe_register_info,
+							   &enabled_status_byte);
 			if (ACPI_FAILURE(status)) {
 				goto unlock_and_exit;
 			}
 
-			/* Read the Enable Register */
-
-			status =
-			    acpi_hw_read(&enable_reg,
-					 &gpe_register_info->enable_address);
-			if (ACPI_FAILURE(status)) {
-				goto unlock_and_exit;
-			}
-
-			ACPI_DEBUG_PRINT((ACPI_DB_INTERRUPTS,
-					  "Read registers for GPE %02X-%02X: Status=%02X, Enable=%02X, "
-					  "RunEnable=%02X, WakeEnable=%02X\n",
-					  gpe_register_info->base_gpe_number,
-					  gpe_register_info->base_gpe_number +
-					  (ACPI_GPE_REGISTER_WIDTH - 1),
-					  status_reg, enable_reg,
-					  gpe_register_info->enable_for_run,
-					  gpe_register_info->enable_for_wake));
-
 			/* Check if there is anything active at all in this register */
 
-			enabled_status_byte = (u8)(status_reg & enable_reg);
 			if (!enabled_status_byte) {
 
 				/* No active GPEs in this register, move on */
@@ -428,19 +567,130 @@ u32 acpi_ev_gpe_detect(struct acpi_gpe_x
 			/* Now look at the individual GPEs in this byte register */
 
 			for (j = 0; j < ACPI_GPE_REGISTER_WIDTH; j++) {
+				gpe_event_info =
+				    &gpe_block->
+				    event_info[((acpi_size) i *
+						ACPI_GPE_REGISTER_WIDTH) + j];
 
 				/* Examine one GPE bit */
 
 				if (enabled_status_byte & (1 << j)) {
-					/*
-					 * Found an active GPE. Dispatch the event to a handler
-					 * or method.
-					 */
-					int_status |=
-					    acpi_ev_gpe_dispatch(gpe_block->
-								 node,
-								 &gpe_block->
-								 event_info[((acpi_size) i * ACPI_GPE_REGISTER_WIDTH) + j], j + gpe_register_info->base_gpe_number);
+
+					/* Found an active GPE */
+
+					acpi_gpe_count++;
+
+					/* Invoke global event handler if present */
+
+					if (acpi_gbl_global_event_handler) {
+						acpi_gbl_global_event_handler
+						    (ACPI_EVENT_TYPE_GPE,
+						     gpe_block->node,
+						     j +
+						     gpe_register_info->
+						     base_gpe_number,
+						     acpi_gbl_global_event_handler_context);
+					}
+
+					if (gpe_event_info->
+					    flags & ACPI_GPE_HANDLER_RAW) {
+
+						/* Prepare handling for a raw handler */
+
+						gpe_register_info->
+						    raw_enabled_status_byte |=
+						    (1 << j);
+					} else {
+						/*
+						 * Dispatch the event to a standard handler or
+						 * method.
+						 */
+						int_status |=
+						    acpi_ev_gpe_dispatch
+						    (gpe_block->node,
+						     gpe_event_info,
+						     j +
+						     gpe_register_info->
+						     base_gpe_number);
+					}
+				}
+			}
+		}
+
+		gpe_block = gpe_block->next;
+	}
+
+	/*
+	 * Examine the GPE status bits for raw handlers. And if an active GPE
+	 * is found, dispatch the event to a raw handler. The raw handler is
+	 * invoked without the GPE lock held because:
+	 * 1. Whether the GPE should be enabled/disabled/cleared is actually
+	 *    determined by the GPE driver, thus the GPE operations should be
+	 *    performed with the GPE driver's specific lock held.
+	 * 2. Since the GPE APIs need to be invoked with the GPE driver's
+	 *    specific lock held, we need to unlock before invoking the handler
+	 *    to avoid recurisive locking or reversed ordered locking.
+	 */
+	gpe_block = gpe_xrupt_list->gpe_block_list_head;
+	while (gpe_block) {
+
+		/* Find all currently active events for raw GPE handlers */
+
+		for (i = 0; i < gpe_block->register_count; i++) {
+
+			/* Get the next saved status/enable pair */
+
+			gpe_register_info = &gpe_block->register_info[i];
+
+			if (gpe_register_info->raw_enabled_status_byte) {
+				for (j = 0; j < ACPI_GPE_REGISTER_WIDTH; j++) {
+					gpe_event_info =
+					    &gpe_block->
+					    event_info[((acpi_size) i *
+							ACPI_GPE_REGISTER_WIDTH)
+						       + j];
+
+					if (gpe_register_info->
+					    raw_enabled_status_byte & (1 << j))
+					{
+
+						/* Clear the raw status bit */
+
+						gpe_register_info->
+						    raw_enabled_status_byte &=
+						    ~(1 << j);
+
+						gpe_device = gpe_block->node;
+						gpe_handler_info =
+						    gpe_event_info->dispatch.
+						    handler;
+						gpe_number =
+						    j +
+						    gpe_register_info->
+						    base_gpe_number;
+
+						/*
+						 * There is no protection around the namespace node
+						 * and the GPE handler to ensure a safe destruction
+						 * because:
+						 * 1. The namespace node is expected to always
+						 *    exist after loading a table.
+						 * 2. The GPE handler is expected to be flushed by
+						 *    acpi_os_wait_events_complete() before the
+						 *    destruction.
+						 */
+						acpi_os_release_lock
+						    (acpi_gbl_gpe_lock, flags);
+						int_status |=
+						    gpe_handler_info->
+						    address(gpe_device,
+							    gpe_number,
+							    gpe_handler_info->
+							    context);
+						flags =
+						    acpi_os_acquire_lock
+						    (acpi_gbl_gpe_lock);
+					}
 				}
 			}
 		}
@@ -678,15 +928,6 @@ acpi_ev_gpe_dispatch(struct acpi_namespa
 
 	ACPI_FUNCTION_TRACE(ev_gpe_dispatch);
 
-	/* Invoke global event handler if present */
-
-	acpi_gpe_count++;
-	if (acpi_gbl_global_event_handler) {
-		acpi_gbl_global_event_handler(ACPI_EVENT_TYPE_GPE, gpe_device,
-					      gpe_number,
-					      acpi_gbl_global_event_handler_context);
-	}
-
 	/*
 	 * Always disable the GPE so that it does not keep firing before
 	 * any asynchronous activity completes (either from the execution
Index: linux-acpica/drivers/acpi/acpica/evgpeblk.c
===================================================================
--- linux-acpica.orig/drivers/acpi/acpica/evgpeblk.c
+++ linux-acpica/drivers/acpi/acpica/evgpeblk.c
@@ -482,7 +482,8 @@ acpi_ev_initialize_gpe_block(struct acpi
 				continue;
 			}
 
-			status = acpi_ev_add_gpe_reference(gpe_event_info);
+			status =
+			    acpi_ev_add_gpe_reference(gpe_event_info, TRUE);
 			if (ACPI_FAILURE(status)) {
 				ACPI_EXCEPTION((AE_INFO, status,
 					"Could not enable GPE 0x%02X",
Index: linux-acpica/drivers/acpi/acpica/evxface.c
===================================================================
--- linux-acpica.orig/drivers/acpi/acpica/evxface.c
+++ linux-acpica/drivers/acpi/acpica/evxface.c
@@ -723,7 +723,9 @@ ACPI_EXPORT_SYMBOL(acpi_remove_fixed_eve
  *                                defined GPEs)
  *              gpe_number      - The GPE number within the GPE block
  *              type            - Whether this GPE should be treated as an
- *                                edge- or level-triggered interrupt.
+ *                                edge- or level-triggered interrupt, and
+ *                                whether this GPE should be handled using
+ *                                the special GPE handler mode.
  *              address         - Address of the handler
  *              context         - Value passed to the handler on each GPE
  *
@@ -746,7 +748,8 @@ acpi_install_gpe_handler(acpi_handle gpe
 
 	/* Parameter validation */
 
-	if ((!address) || (type & ~ACPI_GPE_XRUPT_TYPE_MASK)) {
+	if ((!address) ||
+	    (type & ~(ACPI_GPE_XRUPT_TYPE_MASK | ACPI_GPE_HANDLER_MASK))) {
 		return_ACPI_STATUS(AE_BAD_PARAMETER);
 	}
 
@@ -801,7 +804,7 @@ acpi_install_gpe_handler(acpi_handle gpe
 
 		/* Sanity check of original type against new type */
 
-		if (type !=
+		if ((type & ACPI_GPE_XRUPT_TYPE_MASK) !=
 		    (u32)(gpe_event_info->flags & ACPI_GPE_XRUPT_TYPE_MASK)) {
 			ACPI_WARNING((AE_INFO,
 				      "GPE type mismatch (level/edge)"));
@@ -893,6 +896,10 @@ acpi_remove_gpe_handler(acpi_handle gpe_
 		goto unlock_and_exit;
 	}
 
+	/* Clearing software "status" indication for re-enabling */
+
+	acpi_ev_clear_gpe_status(gpe_event_info);
+
 	/* Remove the handler */
 
 	handler = gpe_event_info->dispatch.handler;
@@ -901,7 +908,8 @@ acpi_remove_gpe_handler(acpi_handle gpe_
 
 	gpe_event_info->dispatch.method_node = handler->method_node;
 	gpe_event_info->flags &=
-	    ~(ACPI_GPE_XRUPT_TYPE_MASK | ACPI_GPE_DISPATCH_MASK);
+	    ~(ACPI_GPE_XRUPT_TYPE_MASK | ACPI_GPE_DISPATCH_MASK |
+	      ACPI_GPE_HANDLER_MASK);
 	gpe_event_info->flags |= handler->original_flags;
 
 	/*
@@ -912,7 +920,10 @@ acpi_remove_gpe_handler(acpi_handle gpe_
 	if (((handler->original_flags & ACPI_GPE_DISPATCH_METHOD) ||
 	     (handler->original_flags & ACPI_GPE_DISPATCH_NOTIFY)) &&
 	    handler->originally_enabled) {
-		(void)acpi_ev_add_gpe_reference(gpe_event_info);
+
+		/* Clearing hardware "status" indication for re-enabling */
+
+		(void)acpi_ev_add_gpe_reference(gpe_event_info, TRUE);
 	}
 
 	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
Index: linux-acpica/drivers/acpi/acpica/evxfgpe.c
===================================================================
--- linux-acpica.orig/drivers/acpi/acpica/evxfgpe.c
+++ linux-acpica/drivers/acpi/acpica/evxfgpe.c
@@ -108,6 +108,7 @@ ACPI_EXPORT_SYMBOL(acpi_update_all_gpes)
  *
  * PARAMETERS:  gpe_device          - Parent GPE Device. NULL for GPE0/GPE1
  *              gpe_number          - GPE level within the GPE block
+ *              clear_stale_events  - Whether stale events should be cleared
  *
  * RETURN:      Status
  *
@@ -115,7 +116,8 @@ ACPI_EXPORT_SYMBOL(acpi_update_all_gpes)
  *              hardware-enabled.
  *
  ******************************************************************************/
-acpi_status acpi_enable_gpe(acpi_handle gpe_device, u32 gpe_number)
+acpi_status
+acpi_enable_gpe(acpi_handle gpe_device, u32 gpe_number, u8 clear_stale_events)
 {
 	acpi_status status = AE_BAD_PARAMETER;
 	struct acpi_gpe_event_info *gpe_event_info;
@@ -134,7 +136,9 @@ acpi_status acpi_enable_gpe(acpi_handle 
 	if (gpe_event_info) {
 		if ((gpe_event_info->flags & ACPI_GPE_DISPATCH_MASK) !=
 		    ACPI_GPE_DISPATCH_NONE) {
-			status = acpi_ev_add_gpe_reference(gpe_event_info);
+			status =
+			    acpi_ev_add_gpe_reference(gpe_event_info,
+						      clear_stale_events);
 		} else {
 			status = AE_NO_HANDLER;
 		}
Index: linux-acpica/include/acpi/acpixf.h
===================================================================
--- linux-acpica.orig/include/acpi/acpixf.h
+++ linux-acpica/include/acpi/acpixf.h
@@ -654,7 +654,8 @@ ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_sta
 
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
 				acpi_enable_gpe(acpi_handle gpe_device,
-						u32 gpe_number))
+						u32 gpe_number,
+						u8 clear_stale_events))
 
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
 				acpi_disable_gpe(acpi_handle gpe_device,
Index: linux-acpica/include/acpi/actypes.h
===================================================================
--- linux-acpica.orig/include/acpi/actypes.h
+++ linux-acpica/include/acpi/actypes.h
@@ -739,14 +739,15 @@ typedef u32 acpi_event_status;
 
 /*
  * GPE info flags - Per GPE
- * +-------+-+-+---+
- * |  7:4  |3|2|1:0|
- * +-------+-+-+---+
- *     |    | |  |
- *     |    | |  +-- Type of dispatch:to method, handler, notify, or none
- *     |    | +----- Interrupt type: edge or level triggered
- *     |    +------- Is a Wake GPE
- *     +------------ <Reserved>
+ * +-------+-+-+-+---+
+ * |  7:5  |4|3|2|1:0|
+ * +-------+-+-+-+---+
+ *     |    | | |  |
+ *     |    | | |  +-- Type of dispatch:to method, handler, notify, or none
+ *     |    | | +----- Interrupt type: edge or level triggered
+ *     |    | +------- Allow driver to full control GPE handling
+ *     |    +--------- Is a Wake GPE
+ *     +-------------- <Reserved>
  */
 #define ACPI_GPE_DISPATCH_NONE          (u8) 0x00
 #define ACPI_GPE_DISPATCH_METHOD        (u8) 0x01
@@ -754,11 +755,16 @@ typedef u32 acpi_event_status;
 #define ACPI_GPE_DISPATCH_NOTIFY        (u8) 0x03
 #define ACPI_GPE_DISPATCH_MASK          (u8) 0x03
 
+/*
+ * Flags used to install a GPE handler
+ */
 #define ACPI_GPE_LEVEL_TRIGGERED        (u8) 0x04
 #define ACPI_GPE_EDGE_TRIGGERED         (u8) 0x00
 #define ACPI_GPE_XRUPT_TYPE_MASK        (u8) 0x04
+#define ACPI_GPE_HANDLER_RAW            (u8) 0x08
+#define ACPI_GPE_HANDLER_MASK           (u8) 0x08
 
-#define ACPI_GPE_CAN_WAKE               (u8) 0x08
+#define ACPI_GPE_CAN_WAKE               (u8) 0x10
 
 /*
  * Flags for GPE and Lock interfaces
Index: linux-acpica/arch/x86/platform/olpc/olpc-xo15-sci.c
===================================================================
--- linux-acpica.orig/arch/x86/platform/olpc/olpc-xo15-sci.c
+++ linux-acpica/arch/x86/platform/olpc/olpc-xo15-sci.c
@@ -173,7 +173,7 @@ static int xo15_sci_add(struct acpi_devi
 	process_sci_queue();
 	olpc_ec_mask_write(EC_SCI_SRC_ALL);
 
-	acpi_enable_gpe(NULL, xo15_sci_gpe);
+	acpi_enable_gpe(NULL, xo15_sci_gpe, TRUE);
 
 	/* Enable wake-on-EC */
 	if (device->wakeup.flags.valid)
Index: linux-acpica/drivers/acpi/device_pm.c
===================================================================
--- linux-acpica.orig/drivers/acpi/device_pm.c
+++ linux-acpica/drivers/acpi/device_pm.c
@@ -680,7 +680,8 @@ static int acpi_device_wakeup(struct acp
 		if (error)
 			return error;
 
-		res = acpi_enable_gpe(wakeup->gpe_device, wakeup->gpe_number);
+		res = acpi_enable_gpe(wakeup->gpe_device, wakeup->gpe_number,
+				      TRUE);
 		if (ACPI_FAILURE(res)) {
 			acpi_disable_wakeup_device_power(adev);
 			return -EIO;
Index: linux-acpica/drivers/acpi/ec.c
===================================================================
--- linux-acpica.orig/drivers/acpi/ec.c
+++ linux-acpica/drivers/acpi/ec.c
@@ -157,7 +157,7 @@ static void acpi_ec_submit_request(struc
 {
 	ec->reference_count++;
 	if (ec->reference_count == 1)
-		acpi_enable_gpe(NULL, ec->gpe);
+		acpi_enable_gpe(NULL, ec->gpe, TRUE);
 }
 
 static void acpi_ec_complete_request(struct acpi_ec *ec)
@@ -445,7 +445,7 @@ static int acpi_ec_transaction(struct ac
 	if (test_bit(EC_FLAGS_GPE_STORM, &ec->flags)) {
 		msleep(1);
 		/* It is safe to enable the GPE outside of the transaction. */
-		acpi_enable_gpe(NULL, ec->gpe);
+		acpi_enable_gpe(NULL, ec->gpe, TRUE);
 	} else if (t->irq_count > ec_storm_threshold) {
 		pr_info("GPE storm detected(%d GPEs), "
 			"transactions will use polling mode\n",
@@ -945,7 +945,8 @@ static int ec_install_handlers(struct ac
 	if (test_bit(EC_FLAGS_HANDLERS_INSTALLED, &ec->flags))
 		return 0;
 	status = acpi_install_gpe_handler(NULL, ec->gpe,
-				  ACPI_GPE_EDGE_TRIGGERED,
+				  ACPI_GPE_EDGE_TRIGGERED |
+				  ACPI_GPE_HANDLER_RAW,
 				  &acpi_ec_gpe_handler, ec);
 	if (ACPI_FAILURE(status))
 		return -ENODEV;
Index: linux-acpica/drivers/acpi/sysfs.c
===================================================================
--- linux-acpica.orig/drivers/acpi/sysfs.c
+++ linux-acpica/drivers/acpi/sysfs.c
@@ -593,7 +593,7 @@ static ssize_t counter_set(struct kobjec
 			result = acpi_disable_gpe(handle, index);
 		else if (!strcmp(buf, "enable\n") &&
 			 !(status & ACPI_EVENT_FLAG_ENABLED))
-			result = acpi_enable_gpe(handle, index);
+			result = acpi_enable_gpe(handle, index, TRUE);
 		else if (!strcmp(buf, "clear\n") &&
 			 (status & ACPI_EVENT_FLAG_SET))
 			result = acpi_clear_gpe(handle, index);
Index: linux-acpica/drivers/acpi/wakeup.c
===================================================================
--- linux-acpica.orig/drivers/acpi/wakeup.c
+++ linux-acpica/drivers/acpi/wakeup.c
@@ -88,7 +88,8 @@ int __init acpi_wakeup_device_init(void)
 		if (device_can_wakeup(&dev->dev)) {
 			/* Button GPEs are supposed to be always enabled. */
 			acpi_enable_gpe(dev->wakeup.gpe_device,
-					dev->wakeup.gpe_number);
+					dev->wakeup.gpe_number,
+					TRUE);
 			device_set_wakeup_enable(&dev->dev, true);
 		}
 	}
Index: linux-acpica/drivers/platform/x86/apple-gmux.c
===================================================================
--- linux-acpica.orig/drivers/platform/x86/apple-gmux.c
+++ linux-acpica/drivers/platform/x86/apple-gmux.c
@@ -541,7 +541,7 @@ static int gmux_probe(struct pnp_dev *pn
 			goto err_notify;
 		}
 
-		status = acpi_enable_gpe(NULL, gmux_data->gpe);
+		status = acpi_enable_gpe(NULL, gmux_data->gpe, TRUE);
 		if (ACPI_FAILURE(status)) {
 			pr_err("Cannot enable gpe: %s\n",
 			       acpi_format_exception(status));
Index: linux-acpica/drivers/platform/x86/xo15-ebook.c
===================================================================
--- linux-acpica.orig/drivers/platform/x86/xo15-ebook.c
+++ linux-acpica/drivers/platform/x86/xo15-ebook.c
@@ -136,7 +136,8 @@ static int ebook_switch_add(struct acpi_
 	if (device->wakeup.flags.valid) {
 		/* Button's GPE is run-wake GPE */
 		acpi_enable_gpe(device->wakeup.gpe_device,
-				device->wakeup.gpe_number);
+				device->wakeup.gpe_number,
+				TRUE);
 		device_set_wakeup_enable(&device->dev, true);
 	}
 
