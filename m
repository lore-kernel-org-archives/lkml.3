Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbaBERLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:11:31 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48399 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103AbaBERFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:05:18 -0500
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org
Cc: patches@linaro.org, Roy Franz <roy.franz@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH 06/22] Add helper functions used by arm/arm64
Date: Wed,  5 Feb 2014 17:03:57 +0000
Message-Id: <1391619853-10601-7-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
References: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roy Franz <roy.franz@linaro.org>

Add the get_dram_base() function and efi_call_physN() macros
that are shared by arm/arm64.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 drivers/firmware/efi/efi-stub-helper.c |   63 +++++++++++++++++++++++++-------
 1 file changed, 50 insertions(+), 13 deletions(-)

diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index eb5d2eb..8477a72 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -11,6 +11,27 @@
  */
 #define EFI_READ_CHUNK_SIZE	(1024 * 1024)
 
+/* error code which can't be mistaken for valid address */
+#define EFI_ERROR	(~0UL)
+
+# if !defined(CONFIG_X86)
+/*
+ * EFI function call wrappers. These are not required for arm/arm64, but
+ * wrappers are required for X86 to convert between ABIs. These wrappers are
+ * provided to allow code sharing between X86 and other architectures. Since
+ * these wrappers directly invoke the EFI function pointer, the function
+ * pointer type must be properly defined, which is not the case for X86. One
+ * advantage of this is it allows for type checking of arguments, which is not
+ * possible with the X86 wrappers.
+ */
+#define efi_call_phys0(f)			f()
+#define efi_call_phys1(f, a1)			f(a1)
+#define efi_call_phys2(f, a1, a2)		f(a1, a2)
+#define efi_call_phys3(f, a1, a2, a3)		f(a1, a2, a3)
+#define efi_call_phys4(f, a1, a2, a3, a4)	f(a1, a2, a3, a4)
+#define efi_call_phys5(f, a1, a2, a3, a4, a5)	f(a1, a2, a3, a4, a5)
+#endif
+
 struct file_info {
 	efi_file_handle_t *handle;
 	u64 size;
@@ -92,6 +113,32 @@ fail:
 	return status;
 }
 
+
+static unsigned long __init get_dram_base(efi_system_table_t *sys_table)
+{
+	efi_status_t status;
+	unsigned long map_size;
+	unsigned long membase  = EFI_ERROR;
+	struct efi_memory_map map;
+	efi_memory_desc_t *md;
+
+	status = efi_get_memory_map(sys_table, (efi_memory_desc_t **)&map.map,
+				    &map_size, &map.desc_size, NULL, NULL);
+	if (status != EFI_SUCCESS)
+		return membase;
+
+	map.map_end = map.map + map_size;
+
+	for_each_efi_memory_desc(&map, md)
+		if (md->attribute & EFI_MEMORY_WB)
+			if (membase > md->phys_addr)
+				membase = md->phys_addr;
+
+	efi_call_phys1(sys_table->boottime->free_pool, map.map);
+
+	return membase;
+}
+
 /*
  * Allocate at the highest possible address that is not above 'max'.
  */
@@ -610,19 +657,9 @@ static char *efi_convert_cmdline_to_ascii(efi_system_table_t *sys_table_arg,
 		options = &zero;
 	}
 
-	options_size++;  /* NUL termination */
-#ifdef CONFIG_ARM
-	/*
-	 * For ARM, allocate at a high address to avoid reserved
-	 * regions at low addresses that we don't know the specfics of
-	 * at the time we are processing the command line.
-	 */
-	status = efi_high_alloc(sys_table_arg, options_size, 0,
-			    &cmdline_addr, 0xfffff000);
-#else
-	status = efi_low_alloc(sys_table_arg, options_size, 0,
-			    &cmdline_addr);
-#endif
+	options_size++;  /* NULL termination */
+
+	status = efi_low_alloc(sys_table_arg, options_bytes, 0, &cmdline_addr);
 	if (status != EFI_SUCCESS)
 		return NULL;
 
-- 
1.7.10.4

