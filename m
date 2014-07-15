Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692AbaGODHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:07:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:2824 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757258AbaGODHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:07:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,662,1400050800"; 
   d="scan'208";a="569859739"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v2 2/9] ACPICA: Events: Fix an issue that GPE APIs cannot be invoked in atomic context.
Date: Tue, 15 Jul 2014 11:07:26 +0800
Message-Id: <73dfaaf9cbda3d681bec93b30c315ccc087dafc3.1405306438.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1405306438.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <cover.1405306438.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPE APIs should be invoked inside of an IRQ context GPE handler or in
the task context with a driver provided lock held. This driver provided
lock should be safe to be held in the GPE handler by the driver.

While currently we cannot do this, thus we can only use the GPE APIs for
limitted cases.

This patch adds reference counting for struct acpi_gpe_handler_info. Then the GPE
handler can be safely invoked without holding the GPE lock, thus
facilitates GPE APIs to be invoked in any atomic environment. Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/acevents.h |    1 +
 drivers/acpi/acpica/aclocal.h  |    1 +
 drivers/acpi/acpica/evgpe.c    |   71 ++++++++++++++++++++++++++++++++--------
 drivers/acpi/acpica/evxface.c  |   10 ++++++
 4 files changed, 70 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/acpica/acevents.h b/drivers/acpi/acpica/acevents.h
index 7a7811a..a3d5276 100644
--- a/drivers/acpi/acpica/acevents.h
+++ b/drivers/acpi/acpica/acevents.h
@@ -123,6 +123,7 @@ ACPI_HW_DEPENDENT_RETURN_OK(acpi_status
 u32
 acpi_ev_gpe_dispatch(struct acpi_namespace_node *gpe_device,
 		     struct acpi_gpe_event_info *gpe_event_info,
+		     struct acpi_gpe_handler_info *gpe_handler_info,
 		     u32 gpe_number);
 
 /*
diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index a9fa666..7363e2c 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -414,6 +414,7 @@ struct acpi_gpe_handler_info {
 	struct acpi_namespace_node *method_node;	/* Method node for this GPE level (saved) */
 	u8 original_flags;	/* Original (pre-handler) GPE info */
 	u8 originally_enabled;	/* True if GPE was originally enabled */
+	u16 reference_count;	/* For deletion management */
 };
 
 /* Notify info for implicit notify, multiple device objects */
diff --git a/drivers/acpi/acpica/evgpe.c b/drivers/acpi/acpica/evgpe.c
index 2095dfb..d629a21 100644
--- a/drivers/acpi/acpica/evgpe.c
+++ b/drivers/acpi/acpica/evgpe.c
@@ -339,6 +339,8 @@ u32 acpi_ev_gpe_detect(struct acpi_gpe_xrupt_info *gpe_xrupt_list)
 {
 	acpi_status status;
 	struct acpi_gpe_block_info *gpe_block;
+	struct acpi_gpe_event_info *gpe_event_info;
+	struct acpi_gpe_handler_info *gpe_handler_info;
 	struct acpi_gpe_register_info *gpe_register_info;
 	u32 int_status = ACPI_INTERRUPT_NOT_HANDLED;
 	u8 enabled_status_byte;
@@ -443,15 +445,45 @@ u32 acpi_ev_gpe_detect(struct acpi_gpe_xrupt_info *gpe_xrupt_list)
 				/* Examine one GPE bit */
 
 				if (enabled_status_byte & (1 << j)) {
+					gpe_event_info =
+					    &gpe_block->
+					    event_info[((acpi_size) i *
+							ACPI_GPE_REGISTER_WIDTH)
+						       + j];
+					gpe_handler_info =
+					    gpe_event_info->dispatch.handler;
+
+					/* Acquire the reference to protect the invocations */
+
+					if (gpe_handler_info) {
+						gpe_handler_info->
+						    reference_count++;
+					}
+
 					/*
 					 * Found an active GPE. Dispatch the event to a handler
-					 * or method.
+					 * or method. Invoke without GPE lock held.
 					 */
+					acpi_os_release_lock(acpi_gbl_gpe_lock,
+							     flags);
 					int_status |=
 					    acpi_ev_gpe_dispatch(gpe_block->
 								 node,
-								 &gpe_block->
-								 event_info[((acpi_size) i * ACPI_GPE_REGISTER_WIDTH) + j], j + gpe_register_info->base_gpe_number);
+								 gpe_event_info,
+								 gpe_handler_info,
+								 j +
+								 gpe_register_info->
+								 base_gpe_number);
+					flags =
+					    acpi_os_acquire_lock
+					    (acpi_gbl_gpe_lock);
+
+					/* Release the reference */
+
+					if (gpe_handler_info) {
+						gpe_handler_info->
+						    reference_count--;
+					}
 				}
 			}
 		}
@@ -676,19 +708,27 @@ acpi_status acpi_ev_finish_gpe(struct acpi_gpe_event_info * gpe_event_info)
  * DESCRIPTION: Dispatch a General Purpose Event to either a function (e.g. EC)
  *              or method (e.g. _Lxx/_Exx) handler.
  *
- *              This function executes at interrupt level.
+ *              This function executes at interrupt level with handler's
+ *              reference count held.
  *
  ******************************************************************************/
 
 u32
 acpi_ev_gpe_dispatch(struct acpi_namespace_node *gpe_device,
-		     struct acpi_gpe_event_info *gpe_event_info, u32 gpe_number)
+		     struct acpi_gpe_event_info *gpe_event_info,
+		     struct acpi_gpe_handler_info *gpe_handler_info,
+		     u32 gpe_number)
 {
 	acpi_status status;
 	u32 return_value;
+	acpi_cpu_flags flags;
 
 	ACPI_FUNCTION_TRACE(ev_gpe_dispatch);
 
+	/* We need to obtain the GPE lock again */
+
+	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+
 	/* Invoke global event handler if present */
 
 	acpi_gpe_count++;
@@ -711,6 +751,7 @@ acpi_ev_gpe_dispatch(struct acpi_namespace_node *gpe_device,
 	if (ACPI_FAILURE(status)) {
 		ACPI_EXCEPTION((AE_INFO, status,
 				"Unable to disable GPE %02X", gpe_number));
+		acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 		return_UINT32(ACPI_INTERRUPT_NOT_HANDLED);
 	}
 
@@ -727,6 +768,7 @@ acpi_ev_gpe_dispatch(struct acpi_namespace_node *gpe_device,
 					gpe_number));
 			(void)acpi_hw_low_set_gpe(gpe_event_info,
 						  ACPI_GPE_CONDITIONAL_ENABLE);
+			acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 			return_UINT32(ACPI_INTERRUPT_NOT_HANDLED);
 		}
 	}
@@ -741,14 +783,16 @@ acpi_ev_gpe_dispatch(struct acpi_namespace_node *gpe_device,
 	switch (gpe_event_info->flags & ACPI_GPE_DISPATCH_MASK) {
 	case ACPI_GPE_DISPATCH_HANDLER:
 
-		/* Invoke the installed handler (at interrupt level) */
-
-		return_value =
-		    gpe_event_info->dispatch.handler->address(gpe_device,
-							      gpe_number,
-							      gpe_event_info->
-							      dispatch.handler->
-							      context);
+		/*
+		 * Invoke the installed handler (at interrupt level), release
+		 * the GPE lock so that the GPE APIs can be invoked in the
+		 * dispatcher.
+		 */
+		acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+		return_value = gpe_handler_info->address(gpe_device, gpe_number,
+							 gpe_handler_info->
+							 context);
+		flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 
 		/* If requested, clear (if level-triggered) and reenable the GPE */
 
@@ -786,6 +830,7 @@ acpi_ev_gpe_dispatch(struct acpi_namespace_node *gpe_device,
 		break;
 	}
 
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	return_UINT32(ACPI_INTERRUPT_HANDLED);
 }
 
diff --git a/drivers/acpi/acpica/evxface.c b/drivers/acpi/acpica/evxface.c
index 1bcb55b..a538b03 100644
--- a/drivers/acpi/acpica/evxface.c
+++ b/drivers/acpi/acpica/evxface.c
@@ -787,6 +787,7 @@ acpi_install_gpe_handler(acpi_handle gpe_device,
 	handler->original_flags = (u8)(gpe_event_info->flags &
 				       (ACPI_GPE_XRUPT_TYPE_MASK |
 					ACPI_GPE_DISPATCH_MASK));
+	handler->reference_count = 0;
 
 	/*
 	 * If the GPE is associated with a method, it may have been enabled
@@ -888,6 +889,7 @@ acpi_remove_gpe_handler(acpi_handle gpe_device,
 	/* Remove the handler */
 
 	handler = gpe_event_info->dispatch.handler;
+	gpe_event_info->dispatch.handler = NULL;
 
 	/* Restore Method node (if any), set dispatch flags */
 
@@ -906,6 +908,14 @@ acpi_remove_gpe_handler(acpi_handle gpe_device,
 		(void)acpi_ev_add_gpe_reference(gpe_event_info);
 	}
 
+	/* Make sure all GPE handlers are completed */
+
+	while (handler->reference_count != 0) {
+		acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+		acpi_os_sleep((u64)10);
+		flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	}
+
 	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
 
-- 
1.7.10

