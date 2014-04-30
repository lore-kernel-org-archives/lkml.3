Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbaD3CFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:05:24 -0400
Received: from mga03.intel.com ([143.182.124.21]:42637 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755973AbaD3CFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:05:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,955,1389772800"; 
   d="scan'208";a="425690061"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 15/27] ACPICA: OSL: Add configurability for generic external functions.
Date: Wed, 30 Apr 2014 10:05:08 +0800
Message-Id: <1200ae832212a9e702680b668a425c6db2087ef5.1398817612.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1398817612.git.lv.zheng@intel.com>
References: <cover.1398817612.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OSPMs like Linux trend to include all header files but leave empty inline
stub functions for a feature that is not configured during build.
This patch adds wrappers mechanism to be used around ACPICA external
interfaces to facilitate OSPM with such configurability.

This patch doesn't include code for Linux to use this new mechanism, thus
no functional change.  Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Bob Moore <robert.moore@intel.com>
---
 include/acpi/acpixf.h |  483 +++++++++++++++++++++++++++++--------------------
 1 file changed, 283 insertions(+), 200 deletions(-)

diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index 7980c87..ac04985 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -81,6 +81,33 @@ extern u8 acpi_gbl_permanent_mmap;
 #endif
 #endif
 
+/* ACPICA prototypes */
+
+#ifndef ACPI_EXTERNAL_RETURN_STATUS
+#define ACPI_EXTERNAL_RETURN_STATUS(prototype) \
+	prototype;
+#endif
+
+#ifndef ACPI_EXTERNAL_RETURN_OK
+#define ACPI_EXTERNAL_RETURN_OK(prototype) \
+	prototype;
+#endif
+
+#ifndef ACPI_EXTERNAL_RETURN_VOID
+#define ACPI_EXTERNAL_RETURN_VOID(prototype) \
+	prototype;
+#endif
+
+#ifndef ACPI_EXTERNAL_RETURN_UINT32
+#define ACPI_EXTERNAL_RETURN_UINT32(prototype) \
+	prototype;
+#endif
+
+#ifndef ACPI_EXTERNAL_RETURN_PTR
+#define ACPI_EXTERNAL_RETURN_PTR(prototype) \
+	prototype;
+#endif
+
 /* Public globals, available from outside ACPICA subsystem */
 
 /*****************************************************************************
@@ -220,13 +247,13 @@ ACPI_GLOBAL(u8, acpi_gbl_system_awake_and_running);
  */
 #if (!ACPI_REDUCED_HARDWARE)
 #define ACPI_HW_DEPENDENT_RETURN_STATUS(prototype) \
-	prototype;
+	ACPI_EXTERNAL_RETURN_STATUS(prototype)
 
 #define ACPI_HW_DEPENDENT_RETURN_OK(prototype) \
-	prototype;
+	ACPI_EXTERNAL_RETURN_OK(prototype)
 
 #define ACPI_HW_DEPENDENT_RETURN_VOID(prototype) \
-	prototype;
+	ACPI_EXTERNAL_RETURN_VOID(prototype)
 
 #else
 #define ACPI_HW_DEPENDENT_RETURN_STATUS(prototype) \
@@ -273,17 +300,18 @@ ACPI_GLOBAL(u8, acpi_gbl_system_awake_and_running);
 /*
  * Initialization
  */
-acpi_status __init
-acpi_initialize_tables(struct acpi_table_desc *initial_storage,
-		       u32 initial_table_count, u8 allow_resize);
-
-acpi_status __init acpi_initialize_subsystem(void);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status __init
+			    acpi_initialize_tables(struct acpi_table_desc
+						   *initial_storage,
+						   u32 initial_table_count,
+						   u8 allow_resize))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status __init acpi_initialize_subsystem(void))
 
-acpi_status __init acpi_enable_subsystem(u32 flags);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status __init acpi_enable_subsystem(u32 flags))
 
-acpi_status __init acpi_initialize_objects(u32 flags);
-
-acpi_status __init acpi_terminate(void);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status __init
+			    acpi_initialize_objects(u32 flags))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status __init acpi_terminate(void))
 
 /*
  * Miscellaneous global interfaces
@@ -291,145 +319,170 @@ acpi_status __init acpi_terminate(void);
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_enable(void))
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_disable(void))
 #ifdef ACPI_FUTURE_USAGE
-acpi_status acpi_subsystem_status(void);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status acpi_subsystem_status(void))
 #endif
 
 #ifdef ACPI_FUTURE_USAGE
-acpi_status acpi_get_system_info(struct acpi_buffer *ret_buffer);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_get_system_info(struct acpi_buffer
+						 *ret_buffer))
 #endif
-
-acpi_status acpi_get_statistics(struct acpi_statistics *stats);
-
-const char *acpi_format_exception(acpi_status exception);
-
-acpi_status acpi_purge_cached_objects(void);
-
-acpi_status acpi_install_interface(acpi_string interface_name);
-
-acpi_status acpi_remove_interface(acpi_string interface_name);
-
-acpi_status acpi_update_interfaces(u8 action);
-
-u32
-acpi_check_address_range(acpi_adr_space_type space_id,
-			 acpi_physical_address address,
-			 acpi_size length, u8 warn);
-
-acpi_status
-acpi_decode_pld_buffer(u8 *in_buffer,
-		       acpi_size length, struct acpi_pld_info **return_buffer);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_get_statistics(struct acpi_statistics *stats))
+ACPI_EXTERNAL_RETURN_PTR(const char
+			  *acpi_format_exception(acpi_status exception))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status acpi_purge_cached_objects(void))
+
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_install_interface(acpi_string interface_name))
+
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_remove_interface(acpi_string interface_name))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status acpi_update_interfaces(u8 action))
+
+ACPI_EXTERNAL_RETURN_UINT32(u32
+			    acpi_check_address_range(acpi_adr_space_type
+						     space_id,
+						     acpi_physical_address
+						     address, acpi_size length,
+						     u8 warn))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_decode_pld_buffer(u8 *in_buffer,
+						    acpi_size length,
+						    struct acpi_pld_info
+						    **return_buffer))
 
 /*
  * ACPI table load/unload interfaces
  */
-acpi_status __init
-acpi_install_table(acpi_physical_address address, u8 physical);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status __init
+			    acpi_install_table(acpi_physical_address address,
+					       u8 physical))
 
-acpi_status acpi_load_table(struct acpi_table_header *table);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_load_table(struct acpi_table_header *table))
 
-acpi_status acpi_unload_parent_table(acpi_handle object);
-
-acpi_status __init acpi_load_tables(void);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_unload_parent_table(acpi_handle object))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status __init acpi_load_tables(void))
 
 /*
  * ACPI table manipulation interfaces
  */
-acpi_status __init acpi_reallocate_root_table(void);
-
-acpi_status __init acpi_find_root_pointer(acpi_size *rsdp_address);
-
-acpi_status
-acpi_get_table_header(acpi_string signature,
-		      u32 instance, struct acpi_table_header *out_table_header);
-
-acpi_status
-acpi_get_table(acpi_string signature,
-	       u32 instance, struct acpi_table_header **out_table);
-
-acpi_status
-acpi_get_table_by_index(u32 table_index, struct acpi_table_header **out_table);
-
-acpi_status
-acpi_install_table_handler(acpi_table_handler handler, void *context);
-
-acpi_status acpi_remove_table_handler(acpi_table_handler handler);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status __init acpi_reallocate_root_table(void))
+
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status __init
+			    acpi_find_root_pointer(acpi_size * rsdp_address))
+
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_get_table_header(acpi_string signature,
+						  u32 instance,
+						  struct acpi_table_header
+						  *out_table_header))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_get_table(acpi_string signature, u32 instance,
+					    struct acpi_table_header
+					    **out_table))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_get_table_by_index(u32 table_index,
+						     struct acpi_table_header
+						     **out_table))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_install_table_handler(acpi_table_handler
+							handler, void *context))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_remove_table_handler(acpi_table_handler
+						       handler))
 
 /*
  * Namespace and name interfaces
  */
-acpi_status
-acpi_walk_namespace(acpi_object_type type,
-		    acpi_handle start_object,
-		    u32 max_depth,
-		    acpi_walk_callback descending_callback,
-		    acpi_walk_callback ascending_callback,
-		    void *context, void **return_value);
-
-acpi_status
-acpi_get_devices(const char *HID,
-		 acpi_walk_callback user_function,
-		 void *context, void **return_value);
-
-acpi_status
-acpi_get_name(acpi_handle object,
-	      u32 name_type, struct acpi_buffer *ret_path_ptr);
-
-acpi_status
-acpi_get_handle(acpi_handle parent,
-		acpi_string pathname, acpi_handle * ret_handle);
-
-acpi_status
-acpi_attach_data(acpi_handle object, acpi_object_handler handler, void *data);
-
-acpi_status acpi_detach_data(acpi_handle object, acpi_object_handler handler);
-
-acpi_status
-acpi_get_data(acpi_handle object, acpi_object_handler handler, void **data);
-
-acpi_status
-acpi_debug_trace(char *name, u32 debug_level, u32 debug_layer, u32 flags);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_walk_namespace(acpi_object_type type,
+						acpi_handle start_object,
+						u32 max_depth,
+						acpi_walk_callback
+						descending_callback,
+						acpi_walk_callback
+						ascending_callback,
+						void *context,
+						void **return_value))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_get_devices(const char *HID,
+					      acpi_walk_callback user_function,
+					      void *context,
+					      void **return_value))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_get_name(acpi_handle object, u32 name_type,
+					   struct acpi_buffer *ret_path_ptr))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_get_handle(acpi_handle parent,
+					     acpi_string pathname,
+					     acpi_handle * ret_handle))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_attach_data(acpi_handle object,
+					      acpi_object_handler handler,
+					      void *data))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_detach_data(acpi_handle object,
+					      acpi_object_handler handler))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_get_data(acpi_handle object,
+					   acpi_object_handler handler,
+					   void **data))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_debug_trace(char *name, u32 debug_level,
+					      u32 debug_layer, u32 flags))
 
 /*
  * Object manipulation and enumeration
  */
-acpi_status
-acpi_evaluate_object(acpi_handle object,
-		     acpi_string pathname,
-		     struct acpi_object_list *parameter_objects,
-		     struct acpi_buffer *return_object_buffer);
-
-acpi_status
-acpi_evaluate_object_typed(acpi_handle object,
-			   acpi_string pathname,
-			   struct acpi_object_list *external_params,
-			   struct acpi_buffer *return_buffer,
-			   acpi_object_type return_type);
-
-acpi_status
-acpi_get_object_info(acpi_handle object,
-		     struct acpi_device_info **return_buffer);
-
-acpi_status acpi_install_method(u8 *buffer);
-
-acpi_status
-acpi_get_next_object(acpi_object_type type,
-		     acpi_handle parent,
-		     acpi_handle child, acpi_handle * out_handle);
-
-acpi_status acpi_get_type(acpi_handle object, acpi_object_type * out_type);
-
-acpi_status acpi_get_parent(acpi_handle object, acpi_handle * out_handle);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_evaluate_object(acpi_handle object,
+						 acpi_string pathname,
+						 struct acpi_object_list
+						 *parameter_objects,
+						 struct acpi_buffer
+						 *return_object_buffer))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_evaluate_object_typed(acpi_handle object,
+							acpi_string pathname,
+							struct acpi_object_list
+							*external_params,
+							struct acpi_buffer
+							*return_buffer,
+							acpi_object_type
+							return_type))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_get_object_info(acpi_handle object,
+						  struct acpi_device_info
+						  **return_buffer))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status acpi_install_method(u8 *buffer))
+
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_get_next_object(acpi_object_type type,
+						 acpi_handle parent,
+						 acpi_handle child,
+						 acpi_handle * out_handle))
+
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_get_type(acpi_handle object,
+					  acpi_object_type * out_type))
+
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_get_parent(acpi_handle object,
+					    acpi_handle * out_handle))
 
 /*
  * Handler interfaces
  */
-acpi_status
-acpi_install_initialization_handler(acpi_init_handler handler, u32 function);
-
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_install_initialization_handler
+			    (acpi_init_handler handler, u32 function))
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
-				acpi_install_sci_handler(acpi_sci_handler
-							 address,
-							 void *context))
+				 acpi_install_sci_handler(acpi_sci_handler
+							  address,
+							  void *context))
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
 				 acpi_remove_sci_handler(acpi_sci_handler
 							 address))
@@ -461,30 +514,42 @@ ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
 							 u32 gpe_number,
 							 acpi_gpe_handler
 							 address))
-acpi_status acpi_install_notify_handler(acpi_handle device, u32 handler_type,
-					 acpi_notify_handler handler,
-					 void *context);
-
-acpi_status
-acpi_remove_notify_handler(acpi_handle device,
-			   u32 handler_type, acpi_notify_handler handler);
-
-acpi_status
-acpi_install_address_space_handler(acpi_handle device,
-				   acpi_adr_space_type space_id,
-				   acpi_adr_space_handler handler,
-				   acpi_adr_space_setup setup, void *context);
-
-acpi_status
-acpi_remove_address_space_handler(acpi_handle device,
-				  acpi_adr_space_type space_id,
-				  acpi_adr_space_handler handler);
-
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_install_notify_handler(acpi_handle device,
+							 u32 handler_type,
+							 acpi_notify_handler
+							 handler,
+							 void *context))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_remove_notify_handler(acpi_handle device,
+							u32 handler_type,
+							acpi_notify_handler
+							handler))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_install_address_space_handler(acpi_handle
+								device,
+								acpi_adr_space_type
+								space_id,
+								acpi_adr_space_handler
+								handler,
+								acpi_adr_space_setup
+								setup,
+								void *context))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_remove_address_space_handler(acpi_handle
+							       device,
+							       acpi_adr_space_type
+							       space_id,
+							       acpi_adr_space_handler
+							       handler))
 #ifdef ACPI_FUTURE_USAGE
-acpi_status acpi_install_exception_handler(acpi_exception_handler handler);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_install_exception_handler
+			     (acpi_exception_handler handler))
 #endif
-
-acpi_status acpi_install_interface_handler(acpi_interface_handler handler);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_install_interface_handler
+			     (acpi_interface_handler handler))
 
 /*
  * Global Lock interfaces
@@ -499,10 +564,14 @@ ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
 /*
  * Interfaces to AML mutex objects
  */
-acpi_status
-acpi_acquire_mutex(acpi_handle handle, acpi_string pathname, u16 timeout);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_acquire_mutex(acpi_handle handle,
+					       acpi_string pathname,
+					       u16 timeout))
 
-acpi_status acpi_release_mutex(acpi_handle handle, acpi_string pathname);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_release_mutex(acpi_handle handle,
+					       acpi_string pathname))
 
 /*
  * Fixed Event interfaces
@@ -582,57 +651,69 @@ typedef
 acpi_status(*acpi_walk_resource_callback) (struct acpi_resource * resource,
 					   void *context);
 
-acpi_status
-acpi_get_vendor_resource(acpi_handle device,
-			 char *name,
-			 struct acpi_vendor_uuid *uuid,
-			 struct acpi_buffer *ret_buffer);
-
-acpi_status
-acpi_get_current_resources(acpi_handle device, struct acpi_buffer *ret_buffer);
-
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_get_vendor_resource(acpi_handle device,
+						     char *name,
+						     struct acpi_vendor_uuid
+						     *uuid,
+						     struct acpi_buffer
+						     *ret_buffer))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_get_current_resources(acpi_handle device,
+							struct acpi_buffer
+							*ret_buffer))
 #ifdef ACPI_FUTURE_USAGE
-acpi_status
-acpi_get_possible_resources(acpi_handle device, struct acpi_buffer *ret_buffer);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_get_possible_resources(acpi_handle device,
+							 struct acpi_buffer
+							 *ret_buffer))
 #endif
-
-acpi_status
-acpi_get_event_resources(acpi_handle device_handle,
-			 struct acpi_buffer *ret_buffer);
-
-acpi_status
-acpi_walk_resource_buffer(struct acpi_buffer *buffer,
-			  acpi_walk_resource_callback user_function,
-			  void *context);
-
-acpi_status
-acpi_walk_resources(acpi_handle device,
-		    char *name,
-		    acpi_walk_resource_callback user_function, void *context);
-
-acpi_status
-acpi_set_current_resources(acpi_handle device, struct acpi_buffer *in_buffer);
-
-acpi_status
-acpi_get_irq_routing_table(acpi_handle device, struct acpi_buffer *ret_buffer);
-
-acpi_status
-acpi_resource_to_address64(struct acpi_resource *resource,
-			   struct acpi_resource_address64 *out);
-
-acpi_status
-acpi_buffer_to_resource(u8 *aml_buffer,
-			u16 aml_buffer_length,
-			struct acpi_resource **resource_ptr);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_get_event_resources(acpi_handle device_handle,
+						      struct acpi_buffer
+						      *ret_buffer))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_walk_resource_buffer(struct acpi_buffer
+						       *buffer,
+						       acpi_walk_resource_callback
+						       user_function,
+						       void *context))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_walk_resources(acpi_handle device, char *name,
+						 acpi_walk_resource_callback
+						 user_function, void *context))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_set_current_resources(acpi_handle device,
+							struct acpi_buffer
+							*in_buffer))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_get_irq_routing_table(acpi_handle device,
+							struct acpi_buffer
+							*ret_buffer))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_resource_to_address64(struct acpi_resource
+							*resource,
+							struct
+							acpi_resource_address64
+							*out))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			     acpi_buffer_to_resource(u8 *aml_buffer,
+						     u16 aml_buffer_length,
+						     struct acpi_resource
+						     **resource_ptr))
 
 /*
  * Hardware (ACPI device) interfaces
  */
-acpi_status acpi_reset(void);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status acpi_reset(void))
 
-acpi_status acpi_read(u64 *value, struct acpi_generic_address *reg);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_read(u64 *value,
+				      struct acpi_generic_address *reg))
 
-acpi_status acpi_write(u64 value, struct acpi_generic_address *reg);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_write(u64 value,
+				       struct acpi_generic_address *reg))
 
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
 				acpi_read_bit_register(u32 register_id,
@@ -645,18 +726,20 @@ ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
 /*
  * Sleep/Wake interfaces
  */
-acpi_status
-acpi_get_sleep_type_data(u8 sleep_state, u8 *slp_typ_a, u8 *slp_typ_b);
-
-acpi_status acpi_enter_sleep_state_prep(u8 sleep_state);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_get_sleep_type_data(u8 sleep_state,
+						     u8 *slp_typ_a,
+						     u8 *slp_typ_b))
 
-acpi_status acpi_enter_sleep_state(u8 sleep_state);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_enter_sleep_state_prep(u8 sleep_state))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status acpi_enter_sleep_state(u8 sleep_state))
 
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status acpi_enter_sleep_state_s4bios(void))
 
-acpi_status acpi_leave_sleep_state_prep(u8 sleep_state);
-
-acpi_status acpi_leave_sleep_state(u8 sleep_state);
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status
+			    acpi_leave_sleep_state_prep(u8 sleep_state))
+ACPI_EXTERNAL_RETURN_STATUS(acpi_status acpi_leave_sleep_state(u8 sleep_state))
 
 ACPI_HW_DEPENDENT_RETURN_STATUS(acpi_status
 				acpi_set_firmware_waking_vector(u32
-- 
1.7.10

