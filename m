Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab3HFDfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 23:35:51 -0400
Received: from mail-vb0-f44.google.com ([209.85.212.44]:57183 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab3HFDfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 23:35:48 -0400
MIME-Version: 1.0
In-Reply-To: <20130805141149.GB2755@localhost.localdomain>
References: <1375478948-22562-1-git-send-email-roy.franz@linaro.org>
	<1375478948-22562-7-git-send-email-roy.franz@linaro.org>
	<20130805141149.GB2755@localhost.localdomain>
Date: Mon, 5 Aug 2013 20:35:47 -0700
Message-ID: <CAFECyb-7GO5O5+tCdyt5fMWCa3dBqUgbXNDzDfEjwGjT=DLSbQ@mail.gmail.com>
Subject: Re: [PATCH 6/7] Add EFI stub for ARM
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

>> diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
>> index 75189f1..4c70b9e 100644
>> --- a/arch/arm/boot/compressed/head.S
>> +++ b/arch/arm/boot/compressed/head.S
>> @@ -122,19 +122,106 @@
>>               .arm                            @ Always enter in ARM state
>>  start:
>>               .type   start,#function
>> -             .rept   7
>> +#ifdef CONFIG_EFI_STUB
>> +             @ Magic MSDOS signature for PE/COFF + ADD opcode
>> +             .word   0x62805a4d
>
> What about BE32?
>
> In that case, the instruction is a coprocessor load, that loads from a
> random address to a coprocessor that almost certainly doesn't exist.
> This will probably fault.
>
> Since BE32 is only for older platforms (<v6) and this is not easily
> solvable, it might be sensible to make the EFI stub support depend on
> !CPU_ENDIAN_BE32.
>
>> +#else
>> +             mov     r0, r0
>> +#endif
>> +             .rept   5
>
> You reduced the .rept count by 2, but only inserted one extra word,
> perhaps because of the extra, but buggy, insertion below.
>
>>               mov     r0, r0
>>               .endr
>>     ARM(              mov     r0, r0          )
>>     ARM(              b       1f              )
>>   THUMB(              adr     r12, BSYM(1f)   )
>>   THUMB(              bx      r12             )
>
> Can't you just replace 1f with zimage_continue directly in the above
> lines, instead of the subsequent extra branch:
>
>> + THUMB(              .thumb                  )
>> +1:
>> +             b       zimage_continue
>
> This also avoids having two labels both called '1'.
>
> I believe the magic word is expected to be in a predictable offset,
> but the size of the preceding branch is unpredictable in Thumb
> (you could use b.w, or possibly remove the branch altogether, as
> explained above).
>
>>               .word   0x016f2818              @ Magic numbers to help the loader
>>               .word   start                   @ absolute load/run zImage address
>>               .word   _edata                  @ zImage end address
>> +
>> +#ifdef CONFIG_EFI_STUB
>> +             @ Portions of the MSDOS file header must be at offset
>> +             @ 0x3c from the start of the file.  All PE/COFF headers
>> +             @ are kept contiguous for simplicity.
>> +#include "efi-header.S"
>> +
>> +efi_stub_entry:
>> +             .text
>> +             @ The EFI stub entry point is not at a fixed address, however
>> +             @ this address must be set in the PE/COFF header.
>> +             @ EFI entry point is in A32 mode, switch to T32 if configured.
>> +             .arm
>> +   ARM(              mov     r0, r0          )
>> +   ARM(              b       1f              )
>
> Those above two instructions are effectively just no-op padding.  Do you
> need them at all?
>
>> + THUMB(              adr     r12, BSYM(1f)   )
>> + THUMB(              bx      r12             )
>>   THUMB(              .thumb                  )
>>  1:
>> +             @ Save lr on stack for possible return to EFI firmware.
>> +             @ Don't care about fp, but need 64 bit alignment....
>> +             stmfd   sp!, {fp, lr}
>> +
>> +             @ Save args to EFI app across got fixup call
>> +             stmfd   sp!, {r0, r1}
>> +             ldmfd   sp!, {r0, r1}
>> +
>> +             @ allocate space on stack for return of new entry point of
>> +             @ zImage, as EFI stub may copy the kernel.  Pass address
>> +             @ of space in r2 - EFI stub will fill in the pointer.
>> +
>> +             sub     sp, #8                  @ we only need 4 bytes,
>> +                                             @ but keep stack 8 byte aligned.
>> +             mov     r2, sp
>> +             @ Pass our actual runtime start address in pointer data
>> +             adr     r11, LC0                @ address of LC0 at run time
>> +             ldr     r12, [r11, #0]          @ address of LC0 at link time
>> +
>> +             sub     r3, r11, r12            @ calculate the delta offset
>> +             str     r3, [r2, #0]
>> +             bl      efi_entry
>> +
>> +             @ get new zImage entry address from stack, put into r3
>> +             ldr     r3, [sp, #0]
>> +             add     sp, #8  @ restore stack
>> +
>> +             @ Check for error return from EFI stub (0xFFFFFFFF)
>> +             ldr     r1, =0xffffffff
>> +             cmp     r0, r1
>> +             beq     efi_load_fail
>> +
>> +
>> +             @ Save return values of efi_entry
>> +             stmfd   sp!, {r0, r3}
>> +             bl      cache_clean_flush
>> +             bl      cache_off
>> +             ldmfd   sp!, {r0, r3}
>> +
>> +             @ put DTB address in r2, it was returned by EFI entry
>> +             mov     r2, r0
>> +             ldr     r1, =0xffffffff         @ DTB machine type
>> +             mov     r0, #0  @ r0 is 0
>> +
>> +             @ Branch to (possibly) relocated zImage entry that is in r3
>> +             bx      r3
>> +
>> +efi_load_fail:
>> +     @ We need to exit THUMB mode here, to return to EFI firmware.
>
> If you lose these 4 lines:
>
>> + THUMB(              adr     r12, BSYM(1f)   )
>> + THUMB(              bx      r12             )
>> +1:
>> +             .arm
>
> ...
>
>> +             @ Return EFI_LOAD_ERROR to EFI firmware on error.
>> +             ldr     r0, =0x80000001
>
> and replace these
>
>> +             ldmfd   sp!, {fp, lr}
>> +             mov     pc, lr
>
> with:
>
>                 ldmfd   sp!, {fp, pc}
>
> then the Thumb-ness on return will be determined by whatever is loaded
> into pc.
>
> There's no special need to switch back to ARM before the final return,
> provided that "mov pc,<Rm>" is not used (that will never switch from
> Thumb to ARM).
>
>
> Cheers
> ---Dave
>
>> + THUMB(              .thumb                  )
>
> Then you can also remove the above line.
>
>> +#endif
>> +
>> +zimage_continue:
>>               mrs     r9, cpsr
>>  #ifdef CONFIG_ARM_VIRT_EXT
>>               bl      __hyp_stub_install      @ get into SVC mode, reversibly
>> @@ -167,7 +254,6 @@ not_angel:
>>                * by the linker here, but it should preserve r7, r8, and r9.
>>                */
>>
>> -             .text
>>
>>  #ifdef CONFIG_AUTO_ZRELADDR
>>               @ determine final kernel image address
>> --

Hi Dave,

  Thanks for your suggestions - they do make the code cleaner.  I
think I have addressed all your suggestions in the patch below.  In
addition, I noticed that I had moved the start of the .text section to
within the  #ifdef CONFIG_EFI_STUB, so I have fixed that.  Also, the
previous return to the EFI stub was broken in the THUMB case - it was
staying in thumb mode - this is now fixed with a cleaner return as you
suggested.  Updated patch for head.S below.  I'll send out an updated
patch series in a few days after I get more feedback.

Thanks,
Roy

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index 75189f1..491e752 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -120,21 +120,100 @@
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
+ @ zimage_continue will be in ARM or thumb mode as configured
+ THUMB( adrl r12, BSYM(zimage_continue))
+ ARM( adrl r12, zimage_continue)
+ bx r12
+ THUMB( .thumb )

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
+ THUMB( .arm )
+ THUMB( adr r12, BSYM(1f) )
+ THUMB( bx r12 )
  THUMB( .thumb )
 1:
+ @ Save lr on stack for possible return to EFI firmware.
+ @ Don't care about fp, but need 64 bit alignment....
+ stmfd sp!, {fp, lr}
+
+ @ Save args to EFI app across got fixup call
+ stmfd sp!, {r0, r1}
+ ldmfd sp!, {r0, r1}
+
+ @ allocate space on stack for return of new entry point of
+ @ zImage, as EFI stub may copy the kernel.  Pass address
+ @ of space in r2 - EFI stub will fill in the pointer.
+
+ sub sp, #8 @ we only need 4 bytes,
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
+ add sp, #8  @ restore stack
+
+ @ Check for error return from EFI stub (0xFFFFFFFF)
+ ldr r1, =0xffffffff
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
+ @ put DTB address in r2, it was returned by EFI entry
+ mov r2, r0
+ ldr r1, =0xffffffff @ DTB machine type
+ mov r0, #0  @ r0 is 0
+
+ @ Branch to (possibly) relocated zImage entry that is in r3
+ bx r3
+
+efi_load_fail:
+ @ Return EFI_LOAD_ERROR to EFI firmware on error.
+ @ Switch back to ARM mode for EFI is done based on
+ @ return address on stack
+ ldr r0, =0x80000001
+ ldmfd sp!, {fp, pc}
+#endif
+
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
