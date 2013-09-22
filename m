Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab3IVWsP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 18:48:15 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:46326 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab3IVWpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 18:45:33 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com
Cc: leif.lindholm@linaro.org, grant.likely@linaro.org, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 09/18] Move unicode to ASCII conversion to shared function.
Date: Sun, 22 Sep 2013 15:45:33 -0700
Message-Id: <1379889942-3135-10-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
References: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the open-coded conversion to a shared function for
use by all architectures.  Change the allocation to prefer
a high address for ARM, as this is required to avoid conflicts
with reserved regions in low memory.  We don't know the specifics
of these regions until after we process the command line and
device tree.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 arch/x86/boot/compressed/eboot.c       |   43 ++++-------------------
 drivers/firmware/efi/efi-stub-helper.c |   58 ++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+), 37 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 2e997b6..5e708c0 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -435,11 +435,10 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 	struct efi_info *efi;
 	efi_loaded_image_t *image;
 	void *options;
-	u32 load_options_size;
 	efi_guid_t proto = LOADED_IMAGE_PROTOCOL_GUID;
 	int options_size = 0;
 	efi_status_t status;
-	unsigned long cmdline;
+	char *cmdline_ptr;
 	u16 *s2;
 	u8 *s1;
 	int i;
@@ -487,41 +486,11 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 	hdr->type_of_loader = 0x21;
 
 	/* Convert unicode cmdline to ascii */
-	options = image->load_options;
-	load_options_size = image->load_options_size / 2; /* ASCII */
-	cmdline = 0;
-	s2 = (u16 *)options;
-
-	if (s2) {
-		while (*s2 && *s2 != '\n' && options_size < load_options_size) {
-			s2++;
-			options_size++;
-		}
-
-		if (options_size) {
-			if (options_size > hdr->cmdline_size)
-				options_size = hdr->cmdline_size;
-
-			options_size++;	/* NUL termination */
-
-			status = efi_low_alloc(sys_table, options_size, 1,
-					   &cmdline);
-			if (status != EFI_SUCCESS) {
-				efi_printk(sys_table, "Failed to alloc mem for cmdline\n");
-				goto fail;
-			}
-
-			s1 = (u8 *)(unsigned long)cmdline;
-			s2 = (u16 *)options;
-
-			for (i = 0; i < options_size - 1; i++)
-				*s1++ = *s2++;
-
-			*s1 = '\0';
-		}
-	}
-
-	hdr->cmd_line_ptr = cmdline;
+	cmdline_ptr = efi_convert_cmdline_to_ascii(sys_table, image,
+						   &options_size);
+	if (!cmdline_ptr)
+		goto fail;
+	hdr->cmd_line_ptr = (unsigned long)cmdline_ptr;
 
 	hdr->ramdisk_image = 0;
 	hdr->ramdisk_size = 0;
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 9a92129..335d17d 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -548,3 +548,61 @@ static efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
 
 	return status;
 }
+/* Convert the unicode UEFI command line to ASCII to pass to kernel.
+ * Size of memory allocated return in *cmd_line_len.
+ * Returns NULL on error.
+ */
+static char *efi_convert_cmdline_to_ascii(efi_system_table_t *sys_table_arg,
+				      efi_loaded_image_t *image,
+				      int *cmd_line_len)
+{
+	u16 *s2;
+	u8 *s1 = NULL;
+	unsigned long cmdline_addr = 0;
+	int load_options_size = image->load_options_size / 2; /* ASCII */
+	void *options = image->load_options;
+	int options_size = 0;
+	efi_status_t status;
+	int i;
+	u16 zero = 0;
+
+	if (options) {
+		s2 = options;
+		while (*s2 && *s2 != '\n' && options_size < load_options_size) {
+			s2++;
+			options_size++;
+		}
+	}
+
+	if (options_size == 0) {
+		/* No command line options, so return empty string*/
+		options_size = 1;
+		options = &zero;
+	}
+
+	options_size++;  /* NUL termination */
+#ifdef CONFIG_ARM
+	/* For ARM, allocate at a high address to avoid reserved
+	 * regions at low addresses that we don't know the specfics of
+	 * at the time we are processing the command line.
+	 */
+	status = efi_high_alloc(sys_table_arg, options_size, 0,
+			    &cmdline_addr, 0xfffff000);
+#else
+	status = efi_low_alloc(sys_table_arg, options_size, 0,
+			    &cmdline_addr);
+#endif
+	if (status != EFI_SUCCESS)
+		return NULL;
+
+	s1 = (u8 *)cmdline_addr;
+	s2 = (u16 *)options;
+
+	for (i = 0; i < options_size - 1; i++)
+		*s1++ = *s2++;
+
+	*s1 = '\0';
+
+	*cmd_line_len = options_size;
+	return (char *)cmdline_addr;
+}
-- 
1.7.10.4

