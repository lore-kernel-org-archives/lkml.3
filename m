Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab3IWJps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:45:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197Ab3IWJpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:45:46 -0400
From: Bart Kuivenhoven <bemk@redhat.com>
To: matt.fleming@intel.com
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jcm@redhat.com, msalter@redhat.com, Bart Kuivenhoven <bemk@redhat.com>
Subject: [PATCH] x86 efi: bugfix interrupt disabling sequence
Date: Mon, 23 Sep 2013 11:45:28 +0200
Message-Id: <1379929528-7534-1-git-send-email-bemk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem in efi_main was that the idt was cleared before the
interrupts were disabled.

The UEFI spec states that interrupts aren't used so this shouldn't be
too much of a problem. Peripherals however don't necessarily know about
this and thus might cause interrupts to happen anyway. Even if
ExitBootServices() has been called.

This means there is a risk of an interrupt being triggered while the IDT
register is nullified and the interrupt bit hasn't been cleared,
allowing for a triple fault.

This patch disables the interrupt flag, while leaving the existing IDT
in place. The CPU won't care about the IDT at all as long as the
interrupt bit is off, so it's safe to leave it in place as nothing will
ever happen to it.

Signed-off-by: Bart Kuivenhoven <bemk@redhat.com>
---
 arch/x86/boot/compressed/eboot.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index b7388a4..689b1ba 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1188,17 +1188,6 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 		goto fail;
 	}
 
-	status = efi_call_phys3(sys_table->boottime->allocate_pool,
-				EFI_LOADER_DATA, sizeof(*idt),
-				(void **)&idt);
-	if (status != EFI_SUCCESS) {
-		efi_printk("Failed to alloc mem for idt structure\n");
-		goto fail;
-	}
-
-	idt->size = 0;
-	idt->address = 0;
-
 	/*
 	 * If the kernel isn't already loaded at the preferred load
 	 * address, relocate it.
@@ -1267,10 +1256,8 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 	desc->base2 = 0x00;
 #endif /* CONFIG_X86_64 */
 
-	asm volatile ("lidt %0" : : "m" (*idt));
-	asm volatile ("lgdt %0" : : "m" (*gdt));
-
 	asm volatile("cli");
+	asm volatile ("lgdt %0" : : "m" (*gdt));
 
 	return boot_params;
 fail:
-- 
1.8.4

