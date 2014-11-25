Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbaKYMBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:01:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:39173 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226AbaKYMBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:01:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,455,1413270000"; 
   d="scan'208";a="613686934"
Message-ID: <54746FA2.9030408@intel.com>
Date: Tue, 25 Nov 2014 20:01:38 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Lee Jones <lee.jones@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yegnesh Iyer <yegnesh.s.iyer@intel.com>, linux-acpi@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>
Subject: Re: [PATCH v3 updated 3/3] ACPI / PMIC: AXP288: support virtual GPIO
 in ACPI table
References: <1416553911-22990-1-git-send-email-aaron.lu@intel.com> <1648486.coeVgHKNdn@vostro.rjw.lan> <5472FB31.8000408@intel.com> <2204417.orosXAozvY@vostro.rjw.lan>
In-Reply-To: <2204417.orosXAozvY@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 11:19 PM, Rafael J. Wysocki wrote:
> On Monday, November 24, 2014 05:32:33 PM Aaron Lu wrote:
>> On 11/24/2014 09:06 AM, Rafael J. Wysocki wrote:
>>> On Friday, November 21, 2014 03:11:51 PM Aaron Lu wrote:
>>>> +	if (!result) {
>>>> +		status = acpi_install_address_space_handler(
>>>> +				ACPI_HANDLE(parent), ACPI_ADR_SPACE_GPIO,
>>>> +				intel_xpower_pmic_gpio_handler, NULL, NULL);
>>>
>>> So here we have a problem, because we can't unregister the opregion handler
>>> registered above if this fails.  Not nice.
>>
>> I'm not correct in the cover letter, the actual problem with operation
>> region remove is with module unload, it happens like this:
>>
>> The acpi_remove_address_space_handler doesn't wait for the current
>> running handler to return, so if we call
>> acpi_remove_address_space_handler in a module's exit function, the
>> handler's memory will be freed and the running handler will access to
>> a no longer valid memory place.
>>
>> So as long as we can make sure the handler will not go away from the
>> memory, we are safe.
> 
> This only means that address space handlers cannot be removed from kernel
> modules.

If the module can not be unloaded(no module exit call), then we should
be safe.

> 
> Lv was trying to add a wrapper for that some time ago, maybe it's a good
> idea to revive that?

Is it this one? If it is, I'll test it and then add the unload
functionality to the PMIC drivers.

From: Lv Zheng <lv.zheng@intel.com>
Date: Tue, 25 Nov 2014 15:42:44 +0800
Subject: [PATCH] ACPICA: Events: Add invocation protection for operation region callbacks.

This patch adds invocation protection around operation region callbacks to
offer a module safe environment for OSPM provided address space handlers.

It is likely that OSPM where ModuleDevice is supported will implement
specific address space handlers in the modules.  Thus the unloading of
the handlers' owner modules may lead to program crash around the invocation
if the handler callbacks are invoked without protection.  Since the
handler callbacks are invoked inside of ACPICA, it is better to implement
invocation protection inside of ACPICA.
As address space handlers are expected to be executed in parallel, it is
not a good choice to implement protection using locks.  This patch uses
reference counting based protection mechanism.  When OSPM calls
acpi_remove_address_space_handler(), the function waits until all invocations
exit to ensure no invocation can happen after the unloading of the modules.

Note that this might be a workaround and not tested, better solution could
be implemented to tune the design of the namespace objects. Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/acevents.h  |   9 ++++
 drivers/acpi/acpica/acobject.h  |   1 +
 drivers/acpi/acpica/evhandler.c | 117 ++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/acpica/evregion.c  |  11 +++-
 drivers/acpi/acpica/evxfregn.c  |   9 ++++
 include/acpi/actypes.h          |   2 +
 6 files changed, 147 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpica/acevents.h b/drivers/acpi/acpica/acevents.h
index 7a7811a9fc26..3020ac4ab7a8 100644
--- a/drivers/acpi/acpica/acevents.h
+++ b/drivers/acpi/acpica/acevents.h
@@ -175,6 +175,15 @@ acpi_ev_install_space_handler(struct acpi_namespace_node *node,
 			      acpi_adr_space_handler handler,
 			      acpi_adr_space_setup setup, void *context);
 
+acpi_status
+acpi_ev_get_space_handler(union acpi_operand_object *handler_desc);
+
+void acpi_ev_put_space_handler(union acpi_operand_object *handler_desc);
+
+void acpi_ev_flush_space_handler(union acpi_operand_object *handler_desc);
+
+s16 acpi_ev_space_handler_count(union acpi_operand_object *handler_desc);
+
 /*
  * evregion - Operation region support
  */
diff --git a/drivers/acpi/acpica/acobject.h b/drivers/acpi/acpica/acobject.h
index 8abb393dafab..a719d9733e6b 100644
--- a/drivers/acpi/acpica/acobject.h
+++ b/drivers/acpi/acpica/acobject.h
@@ -304,6 +304,7 @@ struct acpi_object_notify_handler {
 
 struct acpi_object_addr_handler {
 	ACPI_OBJECT_COMMON_HEADER u8 space_id;
+	s16 invocation_count;
 	u8 handler_flags;
 	acpi_adr_space_handler handler;
 	struct acpi_namespace_node *node;	/* Parent device */
diff --git a/drivers/acpi/acpica/evhandler.c b/drivers/acpi/acpica/evhandler.c
index 78ac29351c9e..b27cc8e0507f 100644
--- a/drivers/acpi/acpica/evhandler.c
+++ b/drivers/acpi/acpica/evhandler.c
@@ -499,6 +499,7 @@ acpi_ev_install_space_handler(struct acpi_namespace_node * node,
 	handler_obj->address_space.space_id = (u8)space_id;
 	handler_obj->address_space.handler_flags = flags;
 	handler_obj->address_space.region_list = NULL;
+	handler_obj->address_space.invocation_count = 0;
 	handler_obj->address_space.node = node;
 	handler_obj->address_space.handler = handler;
 	handler_obj->address_space.context = context;
@@ -534,3 +535,119 @@ acpi_ev_install_space_handler(struct acpi_namespace_node * node,
 unlock_and_exit:
 	return_ACPI_STATUS(status);
 }
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_ev_flush_space_handler
+ *
+ * PARAMETERS:  handler_desc     - Address space object
+ *                                 (ACPI_TYPE_LOCAL_ADDRESS_HANDLER)
+ *
+ * RETURN:      None.
+ *
+ * DESCRIPTION: Flush the reference of the given address space handler object.
+ *
+ ******************************************************************************/
+
+void acpi_ev_flush_space_handler(union acpi_operand_object *handler_desc)
+{
+	acpi_cpu_flags lock_flags;
+
+	ACPI_FUNCTION_TRACE_PTR(acpi_ev_flush_space_handler, handler_desc);
+
+	if (handler_desc && handler_desc->address_space.invocation_count >= 0) {
+		lock_flags =
+		    acpi_os_acquire_lock(acpi_gbl_reference_count_lock);
+		handler_desc->address_space.invocation_count |= ACPI_INT16_MIN;
+		acpi_os_release_lock(acpi_gbl_reference_count_lock, lock_flags);
+	}
+
+	return_VOID;
+}
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_ev_get_space_handler
+ *
+ * PARAMETERS:  handler_desc     - Address space object
+ *                                 (ACPI_TYPE_LOCAL_ADDRESS_HANDLER)
+ *
+ * RETURN:      Status.
+ *
+ * DESCRIPTION: Acquire an reference of the given address space handler object.
+ *
+ ******************************************************************************/
+
+acpi_status acpi_ev_get_space_handler(union acpi_operand_object *handler_desc)
+{
+	acpi_cpu_flags lock_flags;
+
+	ACPI_FUNCTION_TRACE_PTR(acpi_ev_get_space_handler, handler_desc);
+
+	if (handler_desc && handler_desc->address_space.invocation_count >= 0) {
+		lock_flags =
+		    acpi_os_acquire_lock(acpi_gbl_reference_count_lock);
+		handler_desc->address_space.invocation_count++;
+		acpi_os_release_lock(acpi_gbl_reference_count_lock, lock_flags);
+		return_ACPI_STATUS(AE_OK);
+	}
+
+	return_ACPI_STATUS(AE_ERROR);
+}
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_ev_put_space_handler
+ *
+ * PARAMETERS:  handler_desc     - Address space object
+ *                                 (ACPI_TYPE_LOCAL_ADDRESS_HANDLER)
+ *
+ * RETURN:      None.
+ *
+ * DESCRIPTION: Release an reference of the given address space handler object.
+ *
+ ******************************************************************************/
+
+void acpi_ev_put_space_handler(union acpi_operand_object *handler_desc)
+{
+	acpi_cpu_flags lock_flags;
+
+	ACPI_FUNCTION_TRACE_PTR(acpi_ev_put_space_handler, handler_desc);
+
+	if (handler_desc) {
+		lock_flags =
+		    acpi_os_acquire_lock(acpi_gbl_reference_count_lock);
+		handler_desc->address_space.invocation_count--;
+		acpi_os_release_lock(acpi_gbl_reference_count_lock, lock_flags);
+	}
+
+	return_VOID;
+}
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_ev_space_handler_count
+ *
+ * PARAMETERS:  handler_desc     - Address space object
+ *                                 (ACPI_TYPE_LOCAL_ADDRESS_HANDLER)
+ *
+ * RETURN:      Invocation count of the handler.
+ *
+ * DESCRIPTION: Get the reference of the given address space handler object.
+ *
+ ******************************************************************************/
+
+s16 acpi_ev_space_handler_count(union acpi_operand_object *handler_desc)
+{
+	s16 count = 0;
+	acpi_cpu_flags lock_flags;
+
+	if (handler_desc) {
+		lock_flags =
+		    acpi_os_acquire_lock(acpi_gbl_reference_count_lock);
+		count = handler_desc->address_space.invocation_count;
+		acpi_os_release_lock(acpi_gbl_reference_count_lock, lock_flags);
+	}
+
+	return (count);
+}
diff --git a/drivers/acpi/acpica/evregion.c b/drivers/acpi/acpica/evregion.c
index 8eb8575e8c16..dcdd779257d0 100644
--- a/drivers/acpi/acpica/evregion.c
+++ b/drivers/acpi/acpica/evregion.c
@@ -165,6 +165,10 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 		return_ACPI_STATUS(AE_NOT_EXIST);
 	}
 
+	status = acpi_ev_get_space_handler(handler_desc);
+	if (ACPI_FAILURE(status)) {
+		return_ACPI_STATUS(AE_NOT_EXIST);
+	}
 	context = handler_desc->address_space.context;
 
 	/*
@@ -185,7 +189,8 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 				    region_obj,
 				    acpi_ut_get_region_name(region_obj->region.
 							    space_id)));
-			return_ACPI_STATUS(AE_NOT_EXIST);
+			status = AE_NOT_EXIST;
+			goto error_exit;
 		}
 
 		/*
@@ -210,7 +215,7 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 					acpi_ut_get_region_name(region_obj->
 								region.
 								space_id)));
-			return_ACPI_STATUS(status);
+			goto error_exit;
 		}
 
 		/* Region initialization may have been completed by region_setup */
@@ -306,6 +311,8 @@ acpi_ev_address_space_dispatch(union acpi_operand_object *region_obj,
 		acpi_ex_enter_interpreter();
 	}
 
+error_exit:
+	acpi_ev_put_space_handler(handler_desc);
 	return_ACPI_STATUS(status);
 }
 
diff --git a/drivers/acpi/acpica/evxfregn.c b/drivers/acpi/acpica/evxfregn.c
index 2d6f187939c7..c8c8538aae40 100644
--- a/drivers/acpi/acpica/evxfregn.c
+++ b/drivers/acpi/acpica/evxfregn.c
@@ -266,6 +266,15 @@ acpi_remove_address_space_handler(acpi_handle device,
 
 			*last_obj_ptr = handler_obj->address_space.next;
 
+			/* Wait for handlers to exit */
+
+			acpi_ev_flush_space_handler(handler_obj);
+			while (acpi_ev_space_handler_count(handler_obj) != ACPI_INT16_MIN) {
+				(void)acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
+				acpi_os_sleep((u64)10);
+				(void)acpi_ut_acquire_mutex(ACPI_MTX_NAMESPACE);
+			}
+
 			/* Now we can delete the handler object */
 
 			acpi_ut_remove_reference(handler_obj);
diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index 7000e66f768e..a341a9a8157f 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -65,6 +65,8 @@
 #define ACPI_UINT16_MAX                 (u16)(~((u16) 0))	/* 0xFFFF             */
 #define ACPI_UINT32_MAX                 (u32)(~((u32) 0))	/* 0xFFFFFFFF         */
 #define ACPI_UINT64_MAX                 (u64)(~((u64) 0))	/* 0xFFFFFFFFFFFFFFFF */
+#define ACPI_INT16_MAX                  ((s16)(ACPI_UINT16_MAX>>1))
+#define ACPI_INT16_MIN                  ((s16)(-ACPI_INT16_MAX - 1))
 #define ACPI_ASCII_MAX                  0x7F
 
 /*
-- 
1.9.3

