Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbaHLGNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 02:13:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbaHLGNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 02:13:08 -0400
From: Dave Young <dyoung@redhat.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        hpa@zytor.com, Alessandro Zummo <a.zummo@towertech.it>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Mark Salter <msalter@redhat.com>, Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org, rtc-linux@googlegroups.com
Subject: [PATCH 2/5] efi: add kernel param efi=noruntime
Date: Tue, 12 Aug 2014 14:10:19 +0800
Message-Id: <1407823822-23829-2-git-send-email-dyoung@redhat.com>
In-Reply-To: <1407823822-23829-1-git-send-email-dyoung@redhat.com>
References: <1407823822-23829-1-git-send-email-dyoung@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

noefi kernel param means actually disabling efi runtime, Per suggestion from
Leif Lindholm efi=noruntime should be better. But since noefi is already used
in X86 thus just adding another param efi=noruntime for same purpose.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 Documentation/kernel-parameters.txt |  4 +++-
 arch/x86/platform/efi/efi.c         | 12 ------------
 drivers/firmware/efi/efi.c          | 22 ++++++++++++++++++++++
 3 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a8eb6af..09d8c54 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -992,11 +992,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Format: {"off" | "on" | "skip[mbr]"}
 
 	efi=		[EFI]
-			Format: { "old_map" }
+			Format: { "old_map" | "noruntime" }
 			old_map [X86-64]: switch to the old ioremap-based EFI
 			runtime services mapping. 32-bit still uses this one by
 			default.
 
+			noruntime : disable EFI runtime services support
+
 	efi_no_storage_paranoia [EFI; X86]
 			Using this parameter you can use more than 50% of
 			your efi variable storage. Use this parameter only if
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index dd7aaa1..eae91be 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -929,15 +929,3 @@ u64 efi_mem_attributes(unsigned long phys_addr)
 	}
 	return 0;
 }
-
-static int __init parse_efi_cmdline(char *str)
-{
-	if (*str == '=')
-		str++;
-
-	if (!strncmp(str, "old_map", 7))
-		set_bit(EFI_OLD_MEMMAP, &efi.flags);
-
-	return 0;
-}
-early_param("efi", parse_efi_cmdline);
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index c8f01a7..f3ec3f2 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -24,6 +24,7 @@
 #include <linux/of_fdt.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
+#include <asm/efi.h>
 
 struct efi __read_mostly efi = {
 	.mps        = EFI_INVALID_TABLE_ADDR,
@@ -54,6 +55,27 @@ bool efi_runtime_disabled(void)
 	return disable_runtime;
 }
 
+static int __init parse_efi_cmdline(char *str)
+{
+	if (*str == '=')
+		str++;
+
+#ifdef CONFIG_X86
+	if (!strncmp(str, "old_map", 7)) {
+		set_bit(EFI_OLD_MEMMAP, &efi.flags);
+		goto out;
+	}
+#endif
+	if (!strncmp(str, "noruntime", 9)) {
+		disable_runtime = true;
+		goto out;
+	}
+
+out:
+	return 0;
+}
+early_param("efi", parse_efi_cmdline);
+
 static struct kobject *efi_kobj;
 static struct kobject *efivars_kobj;
 
-- 
1.8.3.1

