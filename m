Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbaJAMG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 08:06:58 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:47578 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaJAMGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 08:06:47 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 2/2] efi: Delete the in_nmi() conditional runtime locking
Date: Wed,  1 Oct 2014 13:06:40 +0100
Message-Id: <1412165200-32141-3-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412165200-32141-1-git-send-email-matt@console-pimps.org>
References: <1412165200-32141-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

commit 5dc3826d9f08 ("efi: Implement mandatory locking for UEFI Runtime
Services") implemented some conditional locking when accessing variable
runtime services that Ingo described as "pretty disgusting".

The intention with the !efi_in_nmi() checks was to avoid live-locks when
trying to write pstore crash data into an EFI variable. Such lockless
accesses are allowed according to the UEFI specification when we're in a
"non-recoverable" state, but whether or not things are implemented
correctly in actual firmware implementations remains an unanswered
question, and so it would seem sensible to avoid doing any kind of
unsynchronized variable accesses.

Furthermore, the efi_in_nmi() tests are inadequate because they don't
account for the case where we call EFI variable services from panic or
oops callbacks and aren't executing in NMI context. In other words,
live-locking is still possible.

Let's just remove the conditional locking altogether. Now we've got the
->set_variable_nonblocking() EFI variable operation we can abort if the
runtime lock is already held. Aborting is by far the safest option.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/include/asm/efi.h              |  2 --
 drivers/firmware/efi/runtime-wrappers.c | 17 ++++-------------
 2 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index abba1fe1db5e..408ad6d3222e 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -86,8 +86,6 @@ extern void __iomem *__init efi_ioremap(unsigned long addr, unsigned long size,
 
 #endif /* CONFIG_X86_32 */
 
-#define efi_in_nmi()	in_nmi()
-
 extern struct efi_scratch efi_scratch;
 extern void __init efi_set_executable(efi_memory_desc_t *md, bool executable);
 extern int __init efi_memblock_x86_reserve_range(void);
diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 4349206198b2..228bbf910461 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -86,9 +86,6 @@ static DEFINE_SPINLOCK(efi_runtime_lock);
  * for QueryVariableInfo() and SetVariable(), as these can be reached in NMI
  * context through efi_pstore_write().
  */
-#ifndef efi_in_nmi
-#define efi_in_nmi()	(0)
-#endif
 
 /*
  * As per commit ef68c8f87ed1 ("x86: Serialize EFI time accesses on rtc_lock"),
@@ -189,14 +186,11 @@ static efi_status_t virt_efi_set_variable(efi_char16_t *name,
 {
 	unsigned long flags;
 	efi_status_t status;
-	bool __in_nmi = efi_in_nmi();
 
-	if (!__in_nmi)
-		spin_lock_irqsave(&efi_runtime_lock, flags);
+	spin_lock_irqsave(&efi_runtime_lock, flags);
 	status = efi_call_virt(set_variable, name, vendor, attr, data_size,
 			       data);
-	if (!__in_nmi)
-		spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	spin_unlock_irqrestore(&efi_runtime_lock, flags);
 	return status;
 }
 
@@ -225,17 +219,14 @@ static efi_status_t virt_efi_query_variable_info(u32 attr,
 {
 	unsigned long flags;
 	efi_status_t status;
-	bool __in_nmi = efi_in_nmi();
 
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	if (!__in_nmi)
-		spin_lock_irqsave(&efi_runtime_lock, flags);
+	spin_lock_irqsave(&efi_runtime_lock, flags);
 	status = efi_call_virt(query_variable_info, attr, storage_space,
 			       remaining_space, max_variable_size);
-	if (!__in_nmi)
-		spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	spin_unlock_irqrestore(&efi_runtime_lock, flags);
 	return status;
 }
 
-- 
1.9.3

