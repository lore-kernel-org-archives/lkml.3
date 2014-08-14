Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbaHNJSH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 05:18:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbaHNJSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 05:18:04 -0400
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
        linux-efi@vger.kernel.org, Daniel Kiper <daniel.kiper@oracle.com>,
        Russ Anderson <rja@sgi.com>
Subject: [PATCH 3/7] efi: add kernel param efi=noruntime
Date: Thu, 14 Aug 2014 17:15:28 +0800
Message-Id: <1408007731-15081-3-git-send-email-dyoung@redhat.com>
In-Reply-To: <1408007731-15081-1-git-send-email-dyoung@redhat.com>
References: <1408007731-15081-1-git-send-email-dyoung@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

noefi kernel param means actually disabling efi runtime, Per suggestion from
Leif Lindholm efi=noruntime should be better. But since noefi is already used
in X86 thus just adding another param efi=noruntime for same purpose.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 Documentation/kernel-parameters.txt | 3 ++-
 arch/x86/platform/efi/efi.c         | 4 ++--
 drivers/firmware/efi/efi.c          | 9 +++++++++
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 31c50c1..7afbf6a 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -981,13 +981,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Format: {"off" | "on" | "skip[mbr]"}
 
 	efi=		[EFI]
-			Format: { "old_map", "nochunk" }
+			Format: { "old_map", "nochunk", "noruntime" }
 			old_map [X86-64]: switch to the old ioremap-based EFI
 			runtime services mapping. 32-bit still uses this one by
 			default.
 			nochunk: disable reading files in "chunks" in the EFI
 			boot stub, as chunking can cause problems with some
 			firmware implementations.
+			noruntime : disable EFI runtime services support
 
 	efi_no_storage_paranoia [EFI; X86]
 			Using this parameter you can use more than 50% of
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index c73a7df5..00f4cc5 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -930,11 +930,11 @@ u64 efi_mem_attributes(unsigned long phys_addr)
 	return 0;
 }
 
-static int __init parse_efi_cmdline(char *str)
+static int __init arch_parse_efi_cmdline(char *str)
 {
 	if (parse_option_str(str, "old_map"))
 		set_bit(EFI_OLD_MEMMAP, &efi.flags);
 
 	return 0;
 }
-early_param("efi", parse_efi_cmdline);
+early_param("efi", arch_parse_efi_cmdline);
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 1f396eb..49eb18b 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -54,6 +54,15 @@ bool efi_runtime_disabled(void)
 	return disable_runtime;
 }
 
+static int __init parse_efi_cmdline(char *str)
+{
+	if (parse_option_str(str, "noruntime"))
+		disable_runtime = true;
+
+	return 0;
+}
+early_param("efi", parse_efi_cmdline);
+
 static struct kobject *efi_kobj;
 static struct kobject *efivars_kobj;
 
-- 
1.8.3.1

