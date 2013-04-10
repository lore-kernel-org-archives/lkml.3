Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936863Ab3DJJAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:00:35 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47837 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936816Ab3DJI7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 04:59:49 -0400
From: Richard Weinberger <richard@nod.at>
To: matt.fleming@intel.com
Cc: cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, matthew.garrett@nebula.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/2] x86,efi: Implement no_storage_paranoia parameter
Date: Wed, 10 Apr 2013 10:59:35 +0200
Message-Id: <1365584375-9372-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1365584375-9372-1-git-send-email-richard@nod.at>
References: <1365584375-9372-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using this parameter one can disable the storage_size/2 check if
he is really sure that the UEFI does sane gc and fulfills the spec.

This parameter is useful if a devices uses more than 50% of the
storage by default.
The Intel DQSW67 desktop board is such an sucker for exmaple.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/x86/platform/efi/efi.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 3f96a48..1b0efb6 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -41,6 +41,7 @@
 #include <linux/io.h>
 #include <linux/reboot.h>
 #include <linux/bcd.h>
+#include <linux/module.h>
 
 #include <asm/setup.h>
 #include <asm/efi.h>
@@ -71,6 +72,13 @@ static efi_system_table_t efi_systab __initdata;
 
 unsigned long x86_efi_facility;
 
+static bool efivars_no_storage_paranoia;
+module_param_named(no_storage_paranoia, efivars_no_storage_paranoia, bool, 0644);
+MODULE_PARM_DESC(no_storage_paranoia, "Use this parameter only if you are very"
+		 " sure that your EFI implemenation does sane garbage"
+		 " collection and fulfills the UEFI spec."
+		 " Otherwise your board may brick."
+		 " See: http://mjg59.dreamwidth.org/#entry-22855");
 /*
  * Returns 1 if 'facility' is enabled, 0 otherwise.
  */
@@ -1023,7 +1031,10 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 			    " is returning MaxVariableSize=0\n");
 
 	if (!storage_size || size > remaining_size ||
-	    (max_size && size > max_size) ||
+	    (max_size && size > max_size))
+		return EFI_OUT_OF_RESOURCES;
+
+	if (!efivars_no_storage_paranoia &&
 	    (remaining_size - size) < (storage_size / 2))
 		return EFI_OUT_OF_RESOURCES;
 
-- 
1.8.1.4

