Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbaAJQcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 11:32:16 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:60148 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757896AbaAJQac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 11:30:32 -0500
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, grant.likely@linaro.org, dave.martin@arm.com,
        msalter@redhat.com, patches@linaro.org,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH V6 3/8] Add helper function to get and convert EFI command line
Date: Fri, 10 Jan 2014 08:30:12 -0800
Message-Id: <1389371417-379-4-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389371417-379-1-git-send-email-roy.franz@linaro.org>
References: <1389371417-379-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an EFI stub helper function to retrieve the EFI command line using
the LOADED_IMAGE_PROTOCOL, and convert it to ASCII.  This function will
be shared by the various EFI stub implementations.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 drivers/firmware/efi/efi-stub-helper.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index eb5d2eb..f657456 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -637,3 +637,33 @@ static char *efi_convert_cmdline_to_ascii(efi_system_table_t *sys_table_arg,
 	*cmd_line_len = options_size;
 	return (char *)cmdline_addr;
 }
+
+/*
+ * get the command line from EFI, using the LOADED_IMAGE
+ * protocol, and convert to ASCII.
+ *
+ */
+static void efi_get_cmdline(efi_system_table_t *sys_table,
+			      efi_loaded_image_t **image,
+			      void *handle, char **cmdline_ptr)
+{
+	efi_guid_t proto = LOADED_IMAGE_PROTOCOL_GUID;
+	efi_status_t status;
+	int cmdline_size;
+
+	status = efi_call_phys3(sys_table->boottime->handle_protocol,
+				handle, &proto, (void *)image);
+	if (status != EFI_SUCCESS) {
+		pr_efi_err(sys_table, "Failed to get handle for LOADED_IMAGE_PROTOCOL\n");
+		*cmdline_ptr = NULL;
+		return;
+	}
+
+	/*
+	 * We are going to copy this into device tree, so we don't care where
+	 * in memory it is.
+	 */
+	*cmdline_ptr = efi_convert_cmdline_to_ascii(sys_table, *image,
+						    &cmdline_size);
+
+}
-- 
1.7.10.4

