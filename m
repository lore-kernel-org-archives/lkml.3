Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967046Ab3HIAxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 20:53:19 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:35558 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966976Ab3HIAxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 20:53:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAFECyb-aAHk0RzBGPmGOhRkm8=chwyAM=DdwE=6Z4VLR9sqFRA@mail.gmail.com>
References: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
	<1375847113-24884-17-git-send-email-roy.franz@linaro.org>
	<20130807180548.GA12592@localhost.localdomain>
	<CAFECyb-aAHk0RzBGPmGOhRkm8=chwyAM=DdwE=6Z4VLR9sqFRA@mail.gmail.com>
Date: Thu, 8 Aug 2013 17:53:16 -0700
Message-ID: <CAFECyb9Qh1TzGcjK2AMkKWZTsvTh2MgF1yeDzxYpLE7skMLg7g@mail.gmail.com>
Subject: Re: [PATCH 16/17] Add EFI stub for ARM
From: Roy Franz <roy.franz@linaro.org>
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        matt.fleming@intel.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Leif Lindholm <leif.lindholm@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave - here is an updated patch for head.S, I'm still working on the
rest.  I will make the EFI stub depend on !CPU_ENDIAN_BE32 to make the
stub LE only for now.  I think I have addressed the rest of your
comments in head.S in the patch below.  I will send a complete new
series once I have the other changes, mostly in efi-stub.c, complete.

Thanks,
Roy



diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 75189f1..5401a3a 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -10,6 +10,7 @@
  */
 #include <linux/linkage.h>
 #include <asm/assembler.h>
+#include "efi-stub.h"

  .arch armv7-a
 /*
@@ -120,21 +121,99 @@
  */
  .align
  .arm @ Always enter in ARM state
+ .text
 start:
  .type start,#function
- .rept 7
+#ifdef CONFIG_EFI_STUB
+ @ Magic MSDOS signature for PE/COFF + ADD opcode
+ .word 0x62805a4d
+#else
+ mov r0, r0
+#endif
+ .rept 5
  mov r0, r0
  .endr
-   ARM( mov r0, r0 )
-   ARM( b 1f )
- THUMB( adr r12, BSYM(1f) )
- THUMB( bx r12 )
+
+ adrl r12, BSYM(zimage_continue)
+ ARM( mov     pc, r12 )
+ THUMB( bx r12     )
+ @ zimage_continue will be in ARM or thumb mode as configured

  .word 0x016f2818 @ Magic numbers to help the loader
  .word start @ absolute load/run zImage address
  .word _edata @ zImage end address
+
+#ifdef CONFIG_EFI_STUB
+ @ Portions of the MSDOS file header must be at offset
+ @ 0x3c from the start of the file.  All PE/COFF headers
+ @ are kept contiguous for simplicity.
+#include "efi-header.S"
+
+efi_stub_entry:
+ @ The EFI stub entry point is not at a fixed address, however
+ @ this address must be set in the PE/COFF header.
+ @ EFI entry point is in A32 mode, switch to T32 if configured.
+ THUMB( adr r12, BSYM(1f) )
+ THUMB( bx r12 )
  THUMB( .thumb )
 1:
+ @ Save lr on stack for possible return to EFI firmware.
+ @ Don't care about fp, but need 64 bit alignment....
+ stmfd sp!, {fp, lr}
+
+ @ allocate space on stack for return of new entry point of
+ @ zImage, as EFI stub may copy the kernel.  Pass address
+ @ of space in r2 - EFI stub will fill in the pointer.
+
+ sub sp, sp, #8 @ we only need 4 bytes,
+ @ but keep stack 8 byte aligned.
+ mov r2, sp
+ @ Pass our actual runtime start address in pointer data
+ adr r11, LC0 @ address of LC0 at run time
+ ldr r12, [r11, #0] @ address of LC0 at link time
+
+ sub r3, r11, r12 @ calculate the delta offset
+ str r3, [r2, #0]
+ bl efi_entry
+
+ @ get new zImage entry address from stack, put into r3
+ ldr r3, [sp, #0]
+ add sp, sp, #8   @ restore stack
+
+ @ Check for error return from EFI stub
+ mov r1, #EFI_STUB_ERROR
+ cmp r0, r1
+ beq efi_load_fail
+
+
+ @ Save return values of efi_entry
+ stmfd sp!, {r0, r3}
+ bl cache_clean_flush
+ bl cache_off
+ ldmfd   sp!, {r0, r3}
+
+ @ Set parameters for booting zImage according to boot protocol
+ @ put FDT address in r2, it was returned by efi_entry()
+ @ r1 is FDT machine type, and r0 needs to be 0
+ mov r2, r0
+ mov r1, #0xFFFFFFFF
+ mov r0, #0
+
+ @ Branch to (possibly) relocated zImage that is in r3
+ @ Make sure we are in A32 mode, as zImage requires
+ THUMB( bx r3 )
+ ARM( mov pc, r3 )
+
+efi_load_fail:
+ @ Return EFI_LOAD_ERROR to EFI firmware on error.
+ @ Switch back to ARM mode for EFI is done based on
+ @ return address on stack
+ ldr r0, =0x80000001
+ ldmfd sp!, {fp, pc}
+#endif
+
+ THUMB( .thumb )
+zimage_continue:
  mrs r9, cpsr
 #ifdef CONFIG_ARM_VIRT_EXT
  bl __hyp_stub_install @ get into SVC mode, reversibly
@@ -167,7 +246,6 @@ not_angel:
  * by the linker here, but it should preserve r7, r8, and r9.
  */

- .text

 #ifdef CONFIG_AUTO_ZRELADDR
  @ determine final kernel image address
