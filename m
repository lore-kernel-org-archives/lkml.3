Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965596Ab3DPXBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 19:01:05 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965565Ab3DPXBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 19:01:04 -0400
From: Richard Weinberger <richard@nod.at>
To: matt.fleming@intel.com
Cc: cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, matthew.garrett@nebula.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] x86,efi: Implement efi_no_storage_paranoia parameter
Date: Wed, 17 Apr 2013 01:00:53 +0200
Message-Id: <1366153253-28572-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using this parameter one can disable the storage_size/2 check if
he is really sure that the UEFI does sane gc and fulfills the spec.

This parameter is useful if a devices uses more than 50% of the
storage by default.
The Intel DQSW67 desktop board is such a sucker for exmaple.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 Documentation/kernel-parameters.txt |  6 ++++++
 arch/x86/platform/efi/efi.c         | 15 ++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4609e81..d1cc3a9 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -788,6 +788,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	edd=		[EDD]
 			Format: {"off" | "on" | "skip[mbr]"}
 
+	efi_no_storage_paranoia [EFI; X86]
+			Using this parameter you can use more than 50% of
+			your efi variable storage. Use this parameter only if
+			you are really sure that your UEFI does sane gc and
+			fulfills the spec otherwise your board may brick.
+
 	eisa_irq_edge=	[PARISC,HW]
 			See header of drivers/parisc/eisa.c.
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 4959e3f..07524e1 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -113,6 +113,16 @@ static int __init setup_add_efi_memmap(char *arg)
 }
 early_param("add_efi_memmap", setup_add_efi_memmap);
 
+static bool efi_no_storage_paranoia;
+EXPORT_SYMBOL_GPL(efi_no_storage_paranoia);
+
+static int __init setup_storage_paranoia(char *arg)
+{
+	efi_no_storage_paranoia = true;
+	return 0;
+}
+early_param("efi_no_storage_paranoia", setup_storage_paranoia);
+
 
 static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 {
@@ -1137,7 +1147,10 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 	 */
 
 	if (!storage_size || size > remaining_size ||
-	    (max_size && size > max_size) ||
+	    (max_size && size > max_size))
+		return EFI_OUT_OF_RESOURCES;
+
+	if (!efi_no_storage_paranoia &&
 	    ((active_size + size + VAR_METADATA_SIZE > storage_size / 2) &&
 	     (remaining_size - size < storage_size / 2)))
 		return EFI_OUT_OF_RESOURCES;
-- 
1.8.1.4

