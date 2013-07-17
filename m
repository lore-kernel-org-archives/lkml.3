Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab3GQWxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:53:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56381 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757852Ab3GQWxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:53:05 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Olof Johansson <olof@lixom.net>,
        Matt Fleming <matt.fleming@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 138/145] x86, efi: remove duplicate code in setup_arch() by using, efi_is_native()
Date: Wed, 17 Jul 2013 15:47:50 -0700
Message-Id: <1374101277-7915-139-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

commit 6b59e366e074d3962e04f01efb8acc10a33c0e1e upstream.

The check, "IS_ENABLED(CONFIG_X86_64) != efi_enabled(EFI_64BIT)",
in setup_arch() can be replaced by efi_is_enabled(). This change
remove duplicate code and improve readability.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Olof Johansson <olof@lixom.net>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
[ kamal: backport to 3.8 as prereq for "Modify UEFI anti-bricking code" ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/include/asm/efi.h  | 9 ++++++++-
 arch/x86/kernel/setup.c     | 3 +--
 arch/x86/platform/efi/efi.c | 5 -----
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 28677c5..60c89f3 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -102,7 +102,14 @@ extern void efi_call_phys_epilog(void);
 extern void efi_unmap_memmap(void);
 extern void efi_memory_uc(u64 addr, unsigned long size);
 
-#ifndef CONFIG_EFI
+#ifdef CONFIG_EFI
+
+static inline bool efi_is_native(void)
+{
+	return IS_ENABLED(CONFIG_X86_64) == efi_enabled(EFI_64BIT);
+}
+
+#else
 /*
  * IF EFI is not configured, have the EFI calls return -ENOSYS.
  */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 8b24289..1abb796 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1135,8 +1135,7 @@ void __init setup_arch(char **cmdline_p)
 	 * mismatched firmware/kernel archtectures since there is no
 	 * support for runtime services.
 	 */
-	if (efi_enabled(EFI_BOOT) &&
-	    IS_ENABLED(CONFIG_X86_64) != efi_enabled(EFI_64BIT)) {
+	if (efi_enabled(EFI_BOOT) && !efi_is_native()) {
 		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
 		efi_unmap_memmap();
 	}
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index ce51ed0..27ff3b0 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -69,11 +69,6 @@ struct efi_memory_map memmap;
 static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
-static inline bool efi_is_native(void)
-{
-	return IS_ENABLED(CONFIG_X86_64) == efi_enabled(EFI_64BIT);
-}
-
 unsigned long x86_efi_facility;
 
 /*
-- 
1.8.1.2

