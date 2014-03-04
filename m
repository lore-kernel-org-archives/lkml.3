Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbaCDQCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:02:22 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40409 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971AbaCDQCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:02:21 -0500
From: Borislav Petkov <bp@alien8.de>
To: Russ Anderson <rja@sgi.com>, Alex Thorlton <athorlton@sgi.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH] efi: Quirk out SGI UV
Date: Tue,  4 Mar 2014 17:02:17 +0100
Message-Id: <1393948937-21840-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Getting this thing to work with the new mapping scheme would need more
work.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/efi.h  |  1 +
 arch/x86/kernel/setup.c     | 10 ++--------
 arch/x86/platform/efi/efi.c | 20 ++++++++++++++++++++
 3 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index e985d6bf7d3a..86d1fd4bf24c 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -135,6 +135,7 @@ extern void __init old_map_region(efi_memory_desc_t *md);
 extern void __init runtime_code_page_mkexec(void);
 extern void __init efi_runtime_mkexec(void);
 extern void __init efi_dump_pagetable(void);
+extern void __init efi_apply_memmap_quirks(void);
 
 struct efi_setup_data {
 	u64 fw_vendor;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 830ae2d95450..09c76d265550 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1238,14 +1238,8 @@ void __init setup_arch(char **cmdline_p)
 	register_refined_jiffies(CLOCK_TICK_RATE);
 
 #ifdef CONFIG_EFI
-	/* Once setup is done above, unmap the EFI memory map on
-	 * mismatched firmware/kernel archtectures since there is no
-	 * support for runtime services.
-	 */
-	if (efi_enabled(EFI_BOOT) && !efi_is_native()) {
-		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
-		efi_unmap_memmap();
-	}
+	if (efi_enabled(EFI_BOOT))
+		efi_apply_memmap_quirks();
 #endif
 }
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 482986c3afc5..518aa8540a6d 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -52,6 +52,7 @@
 #include <asm/tlbflush.h>
 #include <asm/x86_init.h>
 #include <asm/rtc.h>
+#include <asm/uv/uv.h>
 
 #define EFI_DEBUG
 
@@ -1298,3 +1299,22 @@ static int __init parse_efi_cmdline(char *str)
 	return 0;
 }
 early_param("efi", parse_efi_cmdline);
+
+void __init efi_apply_memmap_quirks(void)
+{
+	/*
+	 * Once setup is done earlier, unmap the EFI memory map on mismatched
+	 * firmware/kernel architectures since there is no support for runtime
+	 * services.
+	 */
+	if (!efi_is_native()) {
+		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
+		efi_unmap_memmap();
+	}
+
+	/*
+	 * UV doesn't support the new EFI pagetable mapping yet.
+	 */
+	if (is_uv_system())
+		set_bit(EFI_OLD_MEMMAP, &efi.flags);
+}
-- 
1.9.0

