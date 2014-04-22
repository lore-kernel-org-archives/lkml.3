Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbaDVGc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:32:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:58499 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbaDVGcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:32:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,901,1389772800"; 
   d="scan'208";a="525174714"
From: Lan Tianyu <tianyu.lan@intel.com>
To: wsa@the-dreams.de, rjw@rjwysocki.net, mika.westerberg@linux.intel.com,
        awilliam@redhat.com, lenb@kernel.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, tianyu.lan@intel.com,
        Lv Zheng <lv.zheng@intel.com>
Subject: [Resend Patch 1/9] ACPICA: Executer: Fix buffer allocation issue for generic_serial_bus region field accesses.
Date: Tue, 22 Apr 2014 14:24:07 +0800
Message-Id: <1398147855-9868-2-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
References: <1397654682-7094-1-git-send-email-tianyu.lan@intel.com>
 <1398147855-9868-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lv Zheng <lv.zheng@intel.com>

The size of the buffer allocated for generic_serial_bus region access
is not correct.  This patch introduces acpi_ex_get_serial_access_length()
to be invoked to obtain correct data buffer length.  Reported by
Lan Tianyu, Fixed by Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/acpica/exfield.c | 104 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 97 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/acpica/exfield.c b/drivers/acpi/acpica/exfield.c
index 68d9744..12878e1 100644
--- a/drivers/acpi/acpica/exfield.c
+++ b/drivers/acpi/acpica/exfield.c
@@ -45,10 +45,71 @@
 #include "accommon.h"
 #include "acdispat.h"
 #include "acinterp.h"
+#include "amlcode.h"
 
 #define _COMPONENT          ACPI_EXECUTER
 ACPI_MODULE_NAME("exfield")
 
+/* Local prototypes */
+static u32
+acpi_ex_get_serial_access_length(u32 accessor_type, u32 access_length);
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_get_serial_access_bytes
+ *
+ * PARAMETERS:  accessor_type   - The type of the protocol indicated by region
+ *                                field access attributes
+ *              access_length   - The access length of the region field
+ *
+ * RETURN:      Decoded access length
+ *
+ * DESCRIPTION: This routine returns the length of the generic_serial_bus
+ *              protocol bytes
+ *
+ ******************************************************************************/
+
+static u32
+acpi_ex_get_serial_access_length(u32 accessor_type, u32 access_length)
+{
+	u32 length;
+
+	switch (accessor_type) {
+	case AML_FIELD_ATTRIB_QUICK:
+
+		length = 0;
+		break;
+
+	case AML_FIELD_ATTRIB_SEND_RCV:
+	case AML_FIELD_ATTRIB_BYTE:
+
+		length = 1;
+		break;
+
+	case AML_FIELD_ATTRIB_WORD:
+	case AML_FIELD_ATTRIB_WORD_CALL:
+
+		length = 2;
+		break;
+
+	case AML_FIELD_ATTRIB_MULTIBYTE:
+	case AML_FIELD_ATTRIB_RAW_BYTES:
+	case AML_FIELD_ATTRIB_RAW_PROCESS:
+
+		length = access_length;
+		break;
+
+	case AML_FIELD_ATTRIB_BLOCK:
+	case AML_FIELD_ATTRIB_BLOCK_CALL:
+	default:
+
+		length = ACPI_GSBUS_BUFFER_SIZE;
+		break;
+	}
+
+	return (length);
+}
+
 /*******************************************************************************
  *
  * FUNCTION:    acpi_ex_read_data_from_field
@@ -63,8 +124,9 @@ ACPI_MODULE_NAME("exfield")
  *              Buffer, depending on the size of the field.
  *
  ******************************************************************************/
+
 acpi_status
-acpi_ex_read_data_from_field(struct acpi_walk_state *walk_state,
+acpi_ex_read_data_from_field(struct acpi_walk_state * walk_state,
 			     union acpi_operand_object *obj_desc,
 			     union acpi_operand_object **ret_buffer_desc)
 {
@@ -73,6 +135,7 @@ acpi_ex_read_data_from_field(struct acpi_walk_state *walk_state,
 	acpi_size length;
 	void *buffer;
 	u32 function;
+	u16 accessor_type;
 
 	ACPI_FUNCTION_TRACE_PTR(ex_read_data_from_field, obj_desc);
 
@@ -116,9 +179,22 @@ acpi_ex_read_data_from_field(struct acpi_walk_state *walk_state,
 			    ACPI_READ | (obj_desc->field.attribute << 16);
 		} else if (obj_desc->field.region_obj->region.space_id ==
 			   ACPI_ADR_SPACE_GSBUS) {
-			length = ACPI_GSBUS_BUFFER_SIZE;
-			function =
-			    ACPI_READ | (obj_desc->field.attribute << 16);
+			accessor_type = obj_desc->field.attribute;
+			length = acpi_ex_get_serial_access_length(accessor_type,
+								  obj_desc->
+								  field.
+								  access_length);
+
+			/*
+			 * Add additional 2 bytes for modeled generic_serial_bus data buffer:
+			 * typedef struct {
+			 *     BYTEStatus; // Byte 0 of the data buffer
+			 *     BYTELength; // Byte 1 of the data buffer
+			 *     BYTE[x-1]Data; // Bytes 2-x of the arbitrary length data buffer,
+			 * }
+			 */
+			length += 2;
+			function = ACPI_READ | (accessor_type << 16);
 		} else {	/* IPMI */
 
 			length = ACPI_IPMI_BUFFER_SIZE;
@@ -231,6 +307,7 @@ acpi_ex_write_data_to_field(union acpi_operand_object *source_desc,
 	void *buffer;
 	union acpi_operand_object *buffer_desc;
 	u32 function;
+	u16 accessor_type;
 
 	ACPI_FUNCTION_TRACE_PTR(ex_write_data_to_field, obj_desc);
 
@@ -284,9 +361,22 @@ acpi_ex_write_data_to_field(union acpi_operand_object *source_desc,
 			    ACPI_WRITE | (obj_desc->field.attribute << 16);
 		} else if (obj_desc->field.region_obj->region.space_id ==
 			   ACPI_ADR_SPACE_GSBUS) {
-			length = ACPI_GSBUS_BUFFER_SIZE;
-			function =
-			    ACPI_WRITE | (obj_desc->field.attribute << 16);
+			accessor_type = obj_desc->field.attribute;
+			length = acpi_ex_get_serial_access_length(accessor_type,
+								  obj_desc->
+								  field.
+								  access_length);
+
+			/*
+			 * Add additional 2 bytes for modeled generic_serial_bus data buffer:
+			 * typedef struct {
+			 *     BYTEStatus; // Byte 0 of the data buffer
+			 *     BYTELength; // Byte 1 of the data buffer
+			 *     BYTE[x-1]Data; // Bytes 2-x of the arbitrary length data buffer,
+			 * }
+			 */
+			length += 2;
+			function = ACPI_WRITE | (accessor_type << 16);
 		} else {	/* IPMI */
 
 			length = ACPI_IPMI_BUFFER_SIZE;
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

