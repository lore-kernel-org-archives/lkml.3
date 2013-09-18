Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab3IRR3J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:29:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab3IRR3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:29:07 -0400
From: Bart Kuivenhoven <bemk@redhat.com>
To: matt.fleming@intel.com
Cc: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jcm@redhat.com, msalter@redhat.com, Bart Kuivenhoven <bemk@redhat.com>
Subject: [PATCH] x86 efi: bugfix interrupt disabling sequence
Date: Wed, 18 Sep 2013 19:28:53 +0200
Message-Id: <1379525333-4373-1-git-send-email-bemk@redhat.com>
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

This patch fixes this by clearing the interrupt bit before the lidt
instruction.

Signed-off-by: Bart Kuivenhoven <bemk@redhat.com>
---
 arch/x86/boot/compressed/eboot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index b7388a4..100b812 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1267,11 +1267,11 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 	desc->base2 = 0x00;
 #endif /* CONFIG_X86_64 */
 
+	asm volatile("cli");
+
 	asm volatile ("lidt %0" : : "m" (*idt));
 	asm volatile ("lgdt %0" : : "m" (*gdt));
 
-	asm volatile("cli");
-
 	return boot_params;
 fail:
 	return NULL;
-- 
1.8.4

