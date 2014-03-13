Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075AbaCMWy3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 18:54:29 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:40531 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbaCMWsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 18:48:03 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org, catalin.marinas@arm.com,
        matt.fleming@intel.com
Cc: msalter@redhat.com, roy.franz@linaro.org, "H. Peter Anvin" <hpa@zytor.com>,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH v2 02/15] efi: x86: Improve cmdline conversion
Date: Thu, 13 Mar 2014 22:46:55 +0000
Message-Id: <1394750828-16351-3-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1394750828-16351-1-git-send-email-leif.lindholm@linaro.org>
References: <1394750828-16351-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>

Improve the conversion of the UTF-16 EFI command line
to UTF-8 for passing to the kernel.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 arch/x86/boot/compressed/eboot.c       |    3 +-
 drivers/firmware/efi/efi-stub-helper.c |   91 ++++++++++++++++++++++++--------
 2 files changed, 70 insertions(+), 24 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index a7677ba..feca05f 100644
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
index 6811af7..661f425 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -575,52 +575,99 @@ static efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
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
+	int load_options_chars = image->load_options_size / 2; /* UTF-16 */
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
+		while (options_chars < load_options_chars
+		       && *s2 && *s2 != '\n') {
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
+	options_bytes++;  /* NUL termination */
 
-	status = efi_low_alloc(sys_table_arg, options_size, 0, &cmdline_addr);
+	status = efi_low_alloc(sys_table_arg, options_bytes, 0, &cmdline_addr);
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

