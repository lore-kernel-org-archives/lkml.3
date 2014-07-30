Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbaG3EVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 00:21:47 -0400
Received: from mga14.intel.com ([192.55.52.115]:60056 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928AbaG3EVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 00:21:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,762,1400050800"; 
   d="scan'208";a="569242870"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 08/17] ACPICA: acpihelp: Add UUID support, restructure some existing files.
Date: Wed, 30 Jul 2014 12:21:13 +0800
Message-Id: <4f912b7507879d2b67e306487d256d3d298eeb71.1406689494.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1406689493.git.lv.zheng@intel.com>
References: <cover.1406689493.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

This adds a -u option to acpi_help to display all known ACPI UUIDs.
Some existing files in the core code have been restructured.
Three new files.

[zetalog: changing drivers/acpi/acpica/Makefile accordingly]

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/Makefile   |    8 +++-
 drivers/acpi/acpica/aclocal.h  |    5 ++
 drivers/acpi/acpica/acutils.h  |    9 ++++
 drivers/acpi/acpica/utdecode.c |   27 -----------
 drivers/acpi/acpica/uthex.c    |  100 ++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/acpica/utuuid.c   |   96 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 217 insertions(+), 28 deletions(-)
 create mode 100644 drivers/acpi/acpica/uthex.c
 create mode 100644 drivers/acpi/acpica/utuuid.c

diff --git a/drivers/acpi/acpica/Makefile b/drivers/acpi/acpica/Makefile
index 4be4cc94..c1a9635 100644
--- a/drivers/acpi/acpica/Makefile
+++ b/drivers/acpi/acpica/Makefile
@@ -157,6 +157,7 @@ acpi-y +=		\
 	uterror.o	\
 	uteval.o	\
 	utglobal.o	\
+	uthex.o		\
 	utids.o		\
 	utinit.o	\
 	utlock.o	\
@@ -175,5 +176,10 @@ acpi-y +=		\
 	utxferror.o	\
 	utxfmutex.o
 
-acpi-$(ACPI_FUTURE_USAGE) += utfileio.o utprint.o uttrack.o utcache.o
+acpi-$(ACPI_FUTURE_USAGE) +=	\
+	utcache.o		\
+	utfileio.o		\
+	utprint.o		\
+	uttrack.o		\
+	utuuid.o
 
diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index 4c9fd7c..1f9aba5 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -1155,4 +1155,9 @@ struct ah_device_id {
 	char *description;
 };
 
+struct ah_uuid {
+	char *description;
+	char *string;
+};
+
 #endif				/* __ACLOCAL_H__ */
diff --git a/drivers/acpi/acpica/acutils.h b/drivers/acpi/acpica/acutils.h
index ed614f4..486d342 100644
--- a/drivers/acpi/acpica/acutils.h
+++ b/drivers/acpi/acpica/acutils.h
@@ -194,6 +194,8 @@ char *acpi_ut_get_event_name(u32 event_id);
 
 char acpi_ut_hex_to_ascii_char(u64 integer, u32 position);
 
+u8 acpi_ut_ascii_char_to_hex(int hex_char);
+
 u8 acpi_ut_valid_object_type(acpi_object_type type);
 
 /*
@@ -759,6 +761,8 @@ const struct ah_predefined_name *acpi_ah_match_predefined_name(char *nameseg);
 
 const struct ah_device_id *acpi_ah_match_hardware_id(char *hid);
 
+const char *acpi_ah_match_uuid(u8 *data);
+
 /*
  * utprint - printf/vprintf output functions
  */
@@ -778,4 +782,9 @@ int acpi_ut_file_vprintf(ACPI_FILE file, const char *format, va_list args);
 int acpi_ut_file_printf(ACPI_FILE file, const char *format, ...);
 #endif
 
+/*
+ * utuuid -- UUID support functions
+ */
+void acpi_ut_convert_string_to_uuid(char *in_string, u8 *uuid_buffer);
+
 #endif				/* _ACUTILS_H */
diff --git a/drivers/acpi/acpica/utdecode.c b/drivers/acpi/acpica/utdecode.c
index 90ec37c..98f5418 100644
--- a/drivers/acpi/acpica/utdecode.c
+++ b/drivers/acpi/acpica/utdecode.c
@@ -88,33 +88,6 @@ const u8 acpi_gbl_ns_properties[ACPI_NUM_NS_TYPES] = {
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_ut_hex_to_ascii_char
- *
- * PARAMETERS:  integer             - Contains the hex digit
- *              position            - bit position of the digit within the
- *                                    integer (multiple of 4)
- *
- * RETURN:      The converted Ascii character
- *
- * DESCRIPTION: Convert a hex digit to an Ascii character
- *
- ******************************************************************************/
-
-/* Hex to ASCII conversion table */
-
-static const char acpi_gbl_hex_to_ascii[] = {
-	'0', '1', '2', '3', '4', '5', '6', '7',
-	'8', '9', 'A', 'B', 'C', 'D', 'E', 'F'
-};
-
-char acpi_ut_hex_to_ascii_char(u64 integer, u32 position)
-{
-
-	return (acpi_gbl_hex_to_ascii[(integer >> position) & 0xF]);
-}
-
-/*******************************************************************************
- *
  * FUNCTION:    acpi_ut_get_region_name
  *
  * PARAMETERS:  Space ID            - ID for the region
diff --git a/drivers/acpi/acpica/uthex.c b/drivers/acpi/acpica/uthex.c
new file mode 100644
index 0000000..9afa944
--- /dev/null
+++ b/drivers/acpi/acpica/uthex.c
@@ -0,0 +1,100 @@
+/******************************************************************************
+ *
+ * Module Name: uthex -- Hex/ASCII support functions
+ *
+ *****************************************************************************/
+
+/*
+ * Copyright (C) 2000 - 2014, Intel Corp.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ */
+
+#include <acpi/acpi.h>
+#include "accommon.h"
+
+#define _COMPONENT          ACPI_COMPILER
+ACPI_MODULE_NAME("uthex")
+
+/* Hex to ASCII conversion table */
+static char acpi_gbl_hex_to_ascii[] = {
+	'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D',
+	    'E', 'F'
+};
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_ut_hex_to_ascii_char
+ *
+ * PARAMETERS:  integer             - Contains the hex digit
+ *              position            - bit position of the digit within the
+ *                                    integer (multiple of 4)
+ *
+ * RETURN:      The converted Ascii character
+ *
+ * DESCRIPTION: Convert a hex digit to an Ascii character
+ *
+ ******************************************************************************/
+
+char acpi_ut_hex_to_ascii_char(u64 integer, u32 position)
+{
+
+	return (acpi_gbl_hex_to_ascii[(integer >> position) & 0xF]);
+}
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_ut_hex_char_to_value
+ *
+ * PARAMETERS:  ascii_char            - Hex character in Ascii
+ *
+ * RETURN:      The binary value of the ascii/hex character
+ *
+ * DESCRIPTION: Perform ascii-to-hex translation
+ *
+ ******************************************************************************/
+
+u8 acpi_ut_ascii_char_to_hex(int hex_char)
+{
+
+	if (hex_char <= 0x39) {
+		return ((u8)(hex_char - 0x30));
+	}
+
+	if (hex_char <= 0x46) {
+		return ((u8)(hex_char - 0x37));
+	}
+
+	return ((u8)(hex_char - 0x57));
+}
diff --git a/drivers/acpi/acpica/utuuid.c b/drivers/acpi/acpica/utuuid.c
new file mode 100644
index 0000000..4dc3313
--- /dev/null
+++ b/drivers/acpi/acpica/utuuid.c
@@ -0,0 +1,96 @@
+/******************************************************************************
+ *
+ * Module Name: utuuid -- UUID support functions
+ *
+ *****************************************************************************/
+
+/*
+ * Copyright (C) 2000 - 2014, Intel Corp.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ */
+
+#include <acpi/acpi.h>
+#include "accommon.h"
+
+#define _COMPONENT          ACPI_COMPILER
+ACPI_MODULE_NAME("utuuid")
+
+/*
+ * UUID support functions.
+ *
+ * This table is used to convert an input UUID ascii string to a 16 byte
+ * buffer and the reverse. The table maps a UUID buffer index 0-15 to
+ * the index within the 36-byte UUID string where the associated 2-byte
+ * hex value can be found.
+ *
+ * 36-byte UUID strings are of the form:
+ *     aabbccdd-eeff-gghh-iijj-kkllmmnnoopp
+ * Where aa-pp are one byte hex numbers, made up of two hex digits
+ *
+ * Note: This table is basically the inverse of the string-to-offset table
+ * found in the ACPI spec in the description of the to_UUID macro.
+ */
+const u8 acpi_gbl_map_to_uuid_offset[UUID_BUFFER_LENGTH] = {
+	6, 4, 2, 0, 11, 9, 16, 14, 19, 21, 24, 26, 28, 30, 32, 34
+};
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_ut_convert_string_to_uuid
+ *
+ * PARAMETERS:  in_string           - 36-byte formatted UUID string
+ *              uuid_buffer         - Where the 16-byte UUID buffer is returned
+ *
+ * RETURN:      None. Output data is returned in the uuid_buffer
+ *
+ * DESCRIPTION: Convert a 36-byte formatted UUID string to 16-byte UUID buffer
+ *
+ ******************************************************************************/
+
+void acpi_ut_convert_string_to_uuid(char *in_string, u8 *uuid_buffer)
+{
+	u32 i;
+
+	for (i = 0; i < UUID_BUFFER_LENGTH; i++) {
+		uuid_buffer[i] =
+		    (acpi_ut_ascii_char_to_hex
+		     (in_string[acpi_gbl_map_to_uuid_offset[i]]) << 4);
+
+		uuid_buffer[i] |=
+		    acpi_ut_ascii_char_to_hex(in_string
+					      [acpi_gbl_map_to_uuid_offset[i] +
+					       1]);
+	}
+}
-- 
1.7.10

