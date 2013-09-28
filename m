Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab3I1RdF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 13:33:05 -0400
Received: from mail-qe0-f51.google.com ([209.85.128.51]:51298 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab3I1Rcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 13:32:41 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk
Cc: msalter@redhat.com, hpa@zytor.com, Roy Franz <roy.franz@linaro.org>
Subject: [PATCH] Improve EFI stub command line conversion
Date: Sat, 28 Sep 2013 10:32:57 -0700
Message-Id: <1380389577-27039-2-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1380389577-27039-1-git-send-email-roy.franz@linaro.org>
References: <1380389577-27039-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Improve the conversion of the UTF-16 EFI command line
to UTF-8 for passing to the kernel.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 arch/arm/boot/compressed/efi-stub.c    |    2 +-
 arch/x86/boot/compressed/eboot.c       |    3 +-
 drivers/firmware/efi/efi-stub-helper.c |   93 ++++++++++++++++++++++++--------
 3 files changed, 72 insertions(+), 26 deletions(-)

diff --git a/arch/arm/boot/compressed/efi-stub.c b/arch/arm/boot/compressed/efi-stub.c
index a77cc4f..f720284 100644
--- a/arch/arm/boot/compressed/efi-stub.c
+++ b/arch/arm/boot/compressed/efi-stub.c
@@ -109,7 +109,7 @@ int efi_entry(void *handle, efi_system_table_t *sys_table,
 	 * so this memory just needs to not conflict with boot protocol
 	 * requirements.
 	 */
-	cmdline_ptr = efi_convert_cmdline_to_ascii(sys_table, image,
+	cmdline_ptr = efi_convert_cmdline(sys_table, image,
 						   &cmdline_size);
 	if (!cmdline_ptr) {
 		efi_printk(sys_table, PRINTK_PREFIX"ERROR: Unable to allocate memory for command line.\n");
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index beb07a4..a5628cd 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -488,8 +488,7 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 	hdr->type_of_loader = 0x21;
 
 	/* Convert unicode cmdline to ascii */
-	cmdline_ptr = efi_convert_cmdline_to_ascii(sys_table, image,
-						   &options_size);
+	cmdline_ptr = efi_convert_cmdline(sys_table, image, &options_size);
 	if (!cmdline_ptr)
 		goto fail;
 	hdr->cmd_line_ptr = (unsigned long)cmdline_ptr;
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index d3448a9..6602001 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -578,63 +578,110 @@ static efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
 }
 
 /*
- * Convert the unicode UEFI command line to ASCII to pass to kernel.
+ * Get the number of UTF-8 bytes corresponding to an UTF-16 character.
+ * This overestimates for surrogates, but that is okay.
+ */
+static int efi_utf8_bytes(u16 c)
+{
+	return 1 + (c >= 0x80) + (c >= 0x800);
+}
+
+/*
+ * Convert an UTF-16 string, not necessarily null terminated, to UTF-8.
+ */
+static u8 *efi_utf16_to_utf8(u8 *dst, const u16 *src, int n)
+{
+	unsigned int c;
+
+	while (n--) {
+		c = *src++;
+		if (n && c >= 0xd800 && c <= 0xdbff &&
+		    *src >= 0xdc00 && *src <= 0xdfff) {
+			c = 0x10000 + ((c & 0x3ff) << 10) + (*src & 0x3ff);
+			src++;
+			n--;
+		}
+		if (c >= 0xd800 && c <= 0xdfff)
+			c = 0xfffd; /* Unmatched surrogate */
+		if (c < 0x80) {
+			*dst++ = c;
+			continue;
+		}
+		if (c < 0x800) {
+			*dst++ = 0xc0 + (c >> 6);
+			goto t1;
+		}
+		if (c < 0x10000) {
+			*dst++ = 0xe0 + (c >> 12);
+			goto t2;
+		}
+		*dst++ = 0xf0 + (c >> 18);
+		*dst++ = 0x80 + ((c >> 12) & 0x3f);
+t2:
+		*dst++ = 0x80 + ((c >> 6) & 0x3f);
+t1:
+		*dst++ = 0x80 + (c & 0x3f);
+	}
+
+	return dst;
+}
+
+/*
+ * Do proper conversion from UTF-16 to UTF-8
  * Size of memory allocated return in *cmd_line_len.
  * Returns NULL on error.
  */
-static char *efi_convert_cmdline_to_ascii(efi_system_table_t *sys_table_arg,
-				      efi_loaded_image_t *image,
-				      int *cmd_line_len)
+static char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
+				 efi_loaded_image_t *image,
+				 int *cmd_line_len)
 {
-	u16 *s2;
+	const u16 *s2;
 	u8 *s1 = NULL;
 	unsigned long cmdline_addr = 0;
-	int load_options_size = image->load_options_size / 2; /* ASCII */
-	void *options = image->load_options;
-	int options_size = 0;
+	int load_options_chars = image->load_options_size / 2; /* UTF-16 chars */
+	const u16 *options = image->load_options;
+	int options_bytes = 0;	/* UTF-8 bytes */
+	int options_chars = 0;	/* UTF-16 chars */
 	efi_status_t status;
-	int i;
 	u16 zero = 0;
 
 	if (options) {
 		s2 = options;
-		while (*s2 && *s2 != '\n' && options_size < load_options_size) {
-			s2++;
-			options_size++;
+		while (*s2 && *s2 != '\n' && options_chars < load_options_chars) {
+			options_bytes += efi_utf8_bytes(*s2++);
+			options_chars++;
 		}
 	}
 
-	if (options_size == 0) {
-		/* No command line options, so return empty string*/
-		options_size = 1;
+	if (!options_chars) {
+		/* No command line options, so return empty string */
 		options = &zero;
 	}
 
-	options_size++;  /* NUL termination */
+	options_bytes++;	/* NUL termination */
+
 #ifdef CONFIG_ARM
 	/*
 	 * For ARM, allocate at a high address to avoid reserved
 	 * regions at low addresses that we don't know the specfics of
 	 * at the time we are processing the command line.
 	 */
-	status = efi_high_alloc(sys_table_arg, options_size, 0,
+	status = efi_high_alloc(sys_table_arg, options_bytes, 0,
 			    &cmdline_addr, 0xfffff000);
 #else
-	status = efi_low_alloc(sys_table_arg, options_size, 0,
+	status = efi_low_alloc(sys_table_arg, options_bytes, 0,
 			    &cmdline_addr);
 #endif
 	if (status != EFI_SUCCESS)
 		return NULL;
 
 	s1 = (u8 *)cmdline_addr;
-	s2 = (u16 *)options;
-
-	for (i = 0; i < options_size - 1; i++)
-		*s1++ = *s2++;
+	s2 = (const u16 *)options;
 
+	s1 = efi_utf16_to_utf8(s1, s2, options_chars);
 	*s1 = '\0';
 
-	*cmd_line_len = options_size;
+	*cmd_line_len = options_bytes;
 	return (char *)cmdline_addr;
 }
 
-- 
1.7.10.4

