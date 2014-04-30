Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbaD3CGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 22:06:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:48031 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092AbaD3CGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 22:06:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,955,1389772800"; 
   d="scan'208";a="523497225"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Bob Moore <robert.moore@intel.com>
Subject: [PATCH 24/27] ACPICA: Remove extraneous error message for large number of GPEs.
Date: Wed, 30 Apr 2014 10:06:09 +0800
Message-Id: <5cec58046257dde5fe9f1d9161039dc3c98a7c15.1398817612.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1398817612.git.lv.zheng@intel.com>
References: <cover.1398817612.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Fixes a problem where an extraneous error message was emitted during
initialization if there is a GPE block larger than 255 bits. Any
GPE block larger than 120 GPEs could generate the error.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/acpica/tbfadt.c |   51 +++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 18 deletions(-)

diff --git a/drivers/acpi/acpica/tbfadt.c b/drivers/acpi/acpica/tbfadt.c
index a37af16..41519a9 100644
--- a/drivers/acpi/acpica/tbfadt.c
+++ b/drivers/acpi/acpica/tbfadt.c
@@ -52,7 +52,8 @@ ACPI_MODULE_NAME("tbfadt")
 static void
 acpi_tb_init_generic_address(struct acpi_generic_address *generic_address,
 			     u8 space_id,
-			     u8 byte_width, u64 address, char *register_name);
+			     u8 byte_width,
+			     u64 address, char *register_name, u8 flags);
 
 static void acpi_tb_convert_fadt(void);
 
@@ -69,13 +70,14 @@ typedef struct acpi_fadt_info {
 	u16 address32;
 	u16 length;
 	u8 default_length;
-	u8 type;
+	u8 flags;
 
 } acpi_fadt_info;
 
 #define ACPI_FADT_OPTIONAL          0
 #define ACPI_FADT_REQUIRED          1
 #define ACPI_FADT_SEPARATE_LENGTH   2
+#define ACPI_FADT_GPE_REGISTER      4
 
 static struct acpi_fadt_info fadt_info_table[] = {
 	{"Pm1aEventBlock",
@@ -125,14 +127,14 @@ static struct acpi_fadt_info fadt_info_table[] = {
 	 ACPI_FADT_OFFSET(gpe0_block),
 	 ACPI_FADT_OFFSET(gpe0_block_length),
 	 0,
-	 ACPI_FADT_SEPARATE_LENGTH},
+	 ACPI_FADT_SEPARATE_LENGTH | ACPI_FADT_GPE_REGISTER},
 
 	{"Gpe1Block",
 	 ACPI_FADT_OFFSET(xgpe1_block),
 	 ACPI_FADT_OFFSET(gpe1_block),
 	 ACPI_FADT_OFFSET(gpe1_block_length),
 	 0,
-	 ACPI_FADT_SEPARATE_LENGTH}
+	 ACPI_FADT_SEPARATE_LENGTH | ACPI_FADT_GPE_REGISTER}
 };
 
 #define ACPI_FADT_INFO_ENTRIES \
@@ -189,19 +191,29 @@ static struct acpi_fadt_pm_info fadt_pm_info_table[] = {
 static void
 acpi_tb_init_generic_address(struct acpi_generic_address *generic_address,
 			     u8 space_id,
-			     u8 byte_width, u64 address, char *register_name)
+			     u8 byte_width,
+			     u64 address, char *register_name, u8 flags)
 {
 	u8 bit_width;
 
-	/* Bit width field in the GAS is only one byte long, 255 max */
-
+	/*
+	 * Bit width field in the GAS is only one byte long, 255 max.
+	 * Check for bit_width overflow in GAS.
+	 */
 	bit_width = (u8)(byte_width * 8);
-
-	if (byte_width > 31) {	/* (31*8)=248 */
-		ACPI_ERROR((AE_INFO,
-			    "%s - 32-bit FADT register is too long (%u bytes, %u bits) "
-			    "to convert to GAS struct - 255 bits max, truncating",
-			    register_name, byte_width, (byte_width * 8)));
+	if (byte_width > 31) {	/* (31*8)=248, (32*8)=256 */
+		/*
+		 * No error for GPE blocks, because we do not use the bit_width
+		 * for GPEs, the legacy length (byte_width) is used instead to
+		 * allow for a large number of GPEs.
+		 */
+		if (!(flags & ACPI_FADT_GPE_REGISTER)) {
+			ACPI_ERROR((AE_INFO,
+				    "%s - 32-bit FADT register is too long (%u bytes, %u bits) "
+				    "to convert to GAS struct - 255 bits max, truncating",
+				    register_name, byte_width,
+				    (byte_width * 8)));
+		}
 
 		bit_width = 255;
 	}
@@ -450,6 +462,7 @@ static void acpi_tb_convert_fadt(void)
 	struct acpi_generic_address *address64;
 	u32 address32;
 	u8 length;
+	u8 flags;
 	u32 i;
 
 	/*
@@ -515,6 +528,7 @@ static void acpi_tb_convert_fadt(void)
 				       fadt_info_table[i].length);
 
 		name = fadt_info_table[i].name;
+		flags = fadt_info_table[i].flags;
 
 		/*
 		 * Expand the ACPI 1.0 32-bit addresses to the ACPI 2.0 64-bit "X"
@@ -554,7 +568,7 @@ static void acpi_tb_convert_fadt(void)
 									   [i].
 									   length),
 							     (u64)address32,
-							     name);
+							     name, flags);
 			} else if (address64->address != (u64)address32) {
 
 				/* Address mismatch */
@@ -582,7 +596,8 @@ static void acpi_tb_convert_fadt(void)
 								      length),
 								     (u64)
 								     address32,
-								     name);
+								     name,
+								     flags);
 				}
 			}
 		}
@@ -603,7 +618,7 @@ static void acpi_tb_convert_fadt(void)
 					   address64->bit_width));
 		}
 
-		if (fadt_info_table[i].type & ACPI_FADT_REQUIRED) {
+		if (fadt_info_table[i].flags & ACPI_FADT_REQUIRED) {
 			/*
 			 * Field is required (Pm1a_event, Pm1a_control).
 			 * Both the address and length must be non-zero.
@@ -617,7 +632,7 @@ static void acpi_tb_convert_fadt(void)
 								    address),
 						 length));
 			}
-		} else if (fadt_info_table[i].type & ACPI_FADT_SEPARATE_LENGTH) {
+		} else if (fadt_info_table[i].flags & ACPI_FADT_SEPARATE_LENGTH) {
 			/*
 			 * Field is optional (Pm2_control, GPE0, GPE1) AND has its own
 			 * length field. If present, both the address and length must
@@ -726,7 +741,7 @@ static void acpi_tb_setup_fadt_registers(void)
 						     (fadt_pm_info_table[i].
 						      register_num *
 						      pm1_register_byte_width),
-						     "PmRegisters");
+						     "PmRegisters", 0);
 		}
 	}
 }
-- 
1.7.10

