Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193Ab3HNCIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 22:08:01 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:35909 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759061Ab3HNCH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 22:07:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAFECyb_bZYE5tCss8u4RkO=pdpMApo=KV0L0ORMfOnYHuiNf6w@mail.gmail.com>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
	<1376090777-20090-16-git-send-email-roy.franz@linaro.org>
	<20130813141947.GF2823@localhost.localdomain>
	<CAFECyb_bZYE5tCss8u4RkO=pdpMApo=KV0L0ORMfOnYHuiNf6w@mail.gmail.com>
Date: Tue, 13 Aug 2013 19:07:57 -0700
Message-ID: <CAFECyb888rcAAx38ZWK12ZH=bfs1xMp1oT0Cpghj2mwabmcH0w@mail.gmail.com>
Subject: Re: [PATCH 15/16] Add EFI stub for ARM
From: Roy Franz <roy.franz@linaro.org>
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        matt.fleming@intel.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Mark Salter <msalter@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 6:44 PM, Roy Franz <roy.franz@linaro.org> wrote:
>
> Thanks Dave - comments inline, and I have an updated head.S diff at the end.
>
> Roy
>
>
> On Tue, Aug 13, 2013 at 7:19 AM, Dave Martin <Dave.Martin@arm.com> wrote:
>>
>> On Fri, Aug 09, 2013 at 04:26:16PM -0700, Roy Franz wrote:
>> > This patch adds EFI stub support for the ARM Linux kernel.  The EFI stub
>> > operations similarly to the x86 stub: it is a shim between the EFI
>> > firmware
>> > and the normal zImage entry point, and sets up the environment that the
>> > zImage is expecting.  This includes loading the initrd (optionaly) and
>> > device tree from the system partition based on the kernel command line.
>> > The stub updates the device tree as necessary, including adding reserved
>> > memory regions and adding entries for EFI runtime services. The PE/COFF
>> > "MZ" header at offset 0 results in the first instruction being an add
>> > that corrupts r5, which is not used by the zImage interface.
>>
>> Thanks for the update -- a few more comments, nothing major.
>>
>> > Signed-off-by: Roy Franz <roy.franz@linaro.org>
>> > ---
>> >  arch/arm/boot/compressed/Makefile     |   15 +-
>> >  arch/arm/boot/compressed/efi-header.S |  111 ++++++++
>
> ...
>>
>>
>> > +             goto fdt_set_fail;
>> > +
>> > +     return EFI_SUCCESS;
>>
>> This looks better.
>>
>> > +
>> > +fdt_set_fail:
>> > +     if (status == -FDT_ERR_NOSPACE)
>> > +             return EFI_BUFFER_TOO_SMALL;
>> > +
>> > +     return EFI_LOAD_ERROR;
>> > +}
>> > +
>> > +
>> > +
>>
>> Maybe add a comment to indicate that this returns the address of the
>> relocated fdt, or EFI_LOAD_ERROR.
>>
>> By default "int" feels more likely to return a status code.
>>
>> It is not common to return pointers using the "int" type: it may be
>> preferable to use unsigned long of void * instead.  This won't
>> change the functionality.
>>
>> Casts to (int) which could overflow the signed range can cause GCC
>> to generate bizarre code in some situations, because C doesn't
>> have to guarantee wrapping when casting to signed types.  Since we
>> just pass that value through without doing any arithmetic I think we're
>> unlikely to hit that here, but it's best avoided anyhow.
>
>
> The function now returns only status, not the FDT address, so I have changed
> it to an int.
> When I changed the function to no longer do the memory allocation for the
> new FDT this changed,
> but I missed changing the return type to int.
>
>
>>
>>
>> > +int efi_entry(void *handle, efi_system_table_t *sys_table,
>> > +           unsigned long *zimage_addr)
>> > +{
>> > +     efi_loaded_image_t *image;
>> > +     int status;
>> > +     unsigned long nr_pages;
>> > +     const struct fdt_region *region;
>> > +
>> > +     void *fdt;
>> > +     int err;
>> > +     int node;
>> > +     unsigned long zimage_size = 0;
>> > +     unsigned long dram_base;
>> > +     /* addr/point and size pairs for memory management*/
>> > +     u64 initrd_addr;
>> > +     u64 initrd_size = 0;
>> > +     u64 fdt_addr;
>> > +     u64 fdt_size = 0;
>> > +     u64 kernel_reserve_addr;
>> > +     u64 kernel_reserve_size = 0;
>> > +     char *cmdline_ptr;
>> > +     unsigned long cmdline_size = 0;
>> > +
>> > +     unsigned long map_size, desc_size;
>> > +     unsigned long mmap_key;
>> > +     efi_memory_desc_t *memory_map;
>> > +
>> > +     unsigned long new_fdt_size;
>> > +     unsigned long new_fdt_addr;
>> > +
>> > +     efi_guid_t proto = LOADED_IMAGE_PROTOCOL_GUID;
>> > +
>> > +     /* Check if we were booted by the EFI firmware */
>> > +     if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
>> > +             goto fail;
>> > +
>> > +     efi_printk(sys_table, PRINTK_PREFIX"Booting Linux using EFI
>> > stub.\n");
>> > +
>> > +
>> > +     /* get the command line from EFI, using the LOADED_IMAGE protocol
>> > */
>> > +     status = efi_call_phys3(sys_table->boottime->handle_protocol,
>> > +                             handle, &proto, (void *)&image);
>> > +     if (status != EFI_SUCCESS) {
>> > +             efi_printk(sys_table, PRINTK_PREFIX"ERROR: Failed to get
>> > handle for LOADED_IMAGE_PROTOCOL\n");
>> > +             goto fail;
>> > +     }
>> > +
>> > +     /* We are going to copy this into device tree, so we don't care
>> > where in
>> > +      * memory it is.
>> > +      */
>> > +     cmdline_ptr = convert_cmdline_to_ascii(sys_table, image,
>> > +                                            &cmdline_size, 0xFFFFFFFF);
>> > +     if (!cmdline_ptr) {
>> > +             efi_printk(sys_table, PRINTK_PREFIX"ERROR: converting
>> > command line to ascii failed.\n");
>>
>> The real reason for this failure is failure to allocate memory: there's
>> no other way it can fail.
>>
>> So, the error message could be "Unable to allocate memory for command
>> line"
>
>
> done.
>>
>>
>> > +             goto fail;
>> > +     }
>> > +
>> > +     /* We first load the device tree, as we need to get the base
>> > address of
>> > +      * DRAM from the device tree.  The zImage, device tree, and initrd
>> > +      * have address restrictions that are relative to the base of
>> > DRAM.
>> > +      */
>> > +     status = handle_cmdline_files(sys_table, image, cmdline_ptr,
>> > "dtb=",
>> > +                                   0xffffffff, &fdt_addr, &fdt_size);
>> > +     if (status != EFI_SUCCESS) {
>> > +             efi_printk(sys_table, PRINTK_PREFIX"ERROR: Unable to load
>> > device tree blob.\n");
>> > +             goto fail_free_cmdline;
>> > +     }
>> > +
>> > +     err = fdt_check_header((void *)(unsigned long)fdt_addr);
>> > +     if (err != 0) {
>> > +             efi_printk(sys_table, PRINTK_PREFIX"ERROR: device tree
>> > header not valid\n");
>> > +             goto fail_free_fdt;
>> > +     }
>> > +     if (fdt_totalsize((void *)(unsigned long)fdt_addr) > fdt_size) {
>> > +             efi_printk(sys_table, PRINTK_PREFIX"ERROR: Incomplete
>> > device tree.\n");
>> > +             goto fail_free_fdt;
>> > +
>> > +     }
>> > +
>> > +
>> > +     /* Look up the base of DRAM from the device tree.*/
>> > +     fdt = (void *)(u32)fdt_addr;
>> > +     node = fdt_subnode_offset(fdt, 0, "memory");
>> > +     region = fdt_getprop(fdt, node, "reg", NULL);
>> > +     if (region) {
>> > +             dram_base = fdt64_to_cpu(region->base);
>> > +     } else {
>> > +             efi_printk(sys_table, PRINTK_PREFIX"ERROR: no 'memory'
>> > node in device tree.\n");
>> > +             goto fail_free_fdt;
>> > +     }
>> > +
>> > +     /* Reserve memory for the uncompressed kernel image. */
>> > +     kernel_reserve_addr = dram_base;
>> > +     kernel_reserve_size = MAX_UNCOMP_KERNEL_SIZE;
>> > +     nr_pages = round_up(kernel_reserve_size, EFI_PAGE_SIZE) /
>> > EFI_PAGE_SIZE;
>> > +     status = efi_call_phys4(sys_table->boottime->allocate_pages,
>> > +                             EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
>> > +                             nr_pages, &kernel_reserve_addr);
>> > +     if (status != EFI_SUCCESS) {
>> > +             efi_printk(sys_table, PRINTK_PREFIX"ERROR: unable to
>> > allocate memory for uncompressed kernel.\n");
>> > +             goto fail_free_fdt;
>> > +     }
>> > +
>> > +     /* Relocate the zImage, if required. */
>> > +     zimage_size = image->image_size;
>> > +     status = relocate_kernel(sys_table, zimage_addr, zimage_size,
>> > +                              dram_base + MIN_ZIMAGE_OFFSET,
>> > +                              dram_base + ZIMAGE_OFFSET_LIMIT);
>> > +     if (status != EFI_SUCCESS) {
>> > +             efi_printk(sys_table, PRINTK_PREFIX"ERROR: Failed to
>> > relocate kernel\n");
>> > +             goto fail_free_kernel_reserve;
>> > +     }
>> > +
>> > +     status = handle_cmdline_files(sys_table, image, cmdline_ptr,
>> > "initrd=",
>> > +                                   dram_base + ZIMAGE_OFFSET_LIMIT,
>> > +                                   &initrd_addr, &initrd_size);
>> > +     if (status != EFI_SUCCESS) {
>> > +             efi_printk(sys_table, PRINTK_PREFIX"ERROR: Unable to load
>> > initrd\n");
>> > +             goto fail_free_zimage;
>> > +     }
>> > +
>> > +     /* Estimate size of new FDT, and allocate memory for it. We
>> > +      * will allocate a bigger buffer if this ends up being too
>> > +      * small, so a rough guess is OK here.*/
>> > +     new_fdt_size = fdt_size + cmdline_size + 0x200;
>> > +
>> > +fdt_alloc_retry:
>>
>> Minor stylistic thing, but looping using goto is not too readable.
>>
>> The following while loop might be a bit clearer, but I leave it
>> up to you.
>>
>> while (1) {
>>
>> > +     status = efi_high_alloc(sys_table, new_fdt_size, 0, &new_fdt_addr,
>> > +                         dram_base + ZIMAGE_OFFSET_LIMIT);
>> > +     if (status != EFI_SUCCESS) {
>> > +             efi_printk(sys_table, PRINTK_PREFIX"ERROR: Unable to
>> > allocate memory for new device tree.\n");
>> > +             goto fail_free_initrd;
>> > +     }
>> > +
>> > +     /* Now that we have done our final memory allocation (and free)
>> > +      * we can get the memory map key needed
>> > +      * forexit_boot_services.*/
>> > +     status = efi_get_memory_map(sys_table, &memory_map, &map_size,
>> > +                                 &desc_size, &mmap_key);
>> > +     if (status != EFI_SUCCESS)
>> > +             goto fail_free_new_fdt;
>> > +
>> > +     status = update_fdt(sys_table,
>> > +                         fdt, (void *)new_fdt_addr, new_fdt_size,
>> > +                         cmdline_ptr,
>> > +                         initrd_addr, initrd_size,
>> > +                         memory_map, map_size, desc_size);
>>
>> if (status == EFI_SUCCESS)
>>         break;
>>
>> instead of
>>
>> > +
>> > +     if (status != EFI_SUCCESS) {
>>
>> then
>>
>>         if (status != EFI_BUFFER_TOO_SMALL)
>> > +             efi_printk(sys_table, PRINTK_PREFIX"ERROR: Unable to
>> > constuct new device tree.\n");
>> > +             goto fail_free_initrd;
>>
>> instead of
>>
>> > +             if (status == EFI_BUFFER_TOO_SMALL) {
>>
>> then
>>
>> > +                     /* We need to allocate more space for the new
>> > +                      * device tree, so free existing buffer that is
>> > +                      * too small.  Also free memory map, as we will
>> > need
>> > +                      * to get new one that reflects the free/alloc we
>> > do
>> > +                      * on the device tree buffer. */
>> > +                     efi_free(sys_table, new_fdt_size, new_fdt_addr);
>> > +                     efi_call_phys1(sys_table->boottime->free_pool,
>> > +                                    memory_map);
>> > +                     new_fdt_size += new_fdt_size/4;
>>
>> And then just loop
>>         }
>>
>> instead of the rest:
>>
> I have replaced the allocation retry with a while loop as suggested.
>
>> > +                     goto fdt_alloc_retry;
>> > +             }
>> > +             efi_printk(sys_table, PRINTK_PREFIX"ERROR: Unable to
>> > constuct new device tree.\n");
>> > +             goto fail_free_initrd;
>> > +     }
>> > +
>> > +     /* Now we are ready to exit_boot_services.*/
>> > +     status = efi_call_phys2(sys_table->boottime->exit_boot_services,
>> > +                             handle, mmap_key);
>> > +
>> > +     if (status != EFI_SUCCESS) {
>> > +             efi_printk(sys_table, PRINTK_PREFIX"ERROR: exit boot
>> > services failed.\n");
>> > +             goto fail_free_mmap;
>> > +     }
>> > +
>> > +
>> > +     /* Now we need to return the FDT address to the calling
>> > +      * assembly to this can be used as part of normal boot.
>> > +      */
>> > +     return new_fdt_addr;
>> > +
>> > +fail_free_mmap:
>> > +     efi_call_phys1(sys_table->boottime->free_pool, memory_map);
>> > +
>> > +fail_free_new_fdt:
>> > +     efi_free(sys_table, new_fdt_size, new_fdt_addr);
>> > +
>> > +fail_free_initrd:
>> > +     efi_free(sys_table, initrd_size, initrd_addr);
>> > +
>> > +fail_free_zimage:
>> > +     efi_free(sys_table, zimage_size, *zimage_addr);
>> > +
>> > +fail_free_kernel_reserve:
>> > +     efi_free(sys_table, kernel_reserve_addr, kernel_reserve_size);
>> > +
>> > +fail_free_fdt:
>> > +     efi_free(sys_table, fdt_size, fdt_addr);
>> > +
>> > +fail_free_cmdline:
>> > +     efi_free(sys_table, cmdline_size, (u32)cmdline_ptr);
>> > +
>> > +fail:
>> > +     return EFI_STUB_ERROR;
>> > +}
>> > diff --git a/arch/arm/boot/compressed/efi-stub.h
>> > b/arch/arm/boot/compressed/efi-stub.h
>> > new file mode 100644
>> > index 0000000..0fe9376
>> > --- /dev/null
>> > +++ b/arch/arm/boot/compressed/efi-stub.h
>> > @@ -0,0 +1,5 @@
>> > +#ifndef _ARM_EFI_STUB_H
>> > +#define _ARM_EFI_STUB_H
>> > +/* Error code returned to ASM code instead of valid FDT address. */
>> > +#define EFI_STUB_ERROR               (~0)
>> > +#endif
>> > diff --git a/arch/arm/boot/compressed/head.S
>> > b/arch/arm/boot/compressed/head.S
>> > index 75189f1..5401a3a 100644
>> > --- a/arch/arm/boot/compressed/head.S
>> > +++ b/arch/arm/boot/compressed/head.S
>> > @@ -10,6 +10,7 @@
>> >   */
>> >  #include <linux/linkage.h>
>> >  #include <asm/assembler.h>
>> > +#include "efi-stub.h"
>> >
>> >       .arch   armv7-a
>> >  /*
>> > @@ -120,21 +121,99 @@
>> >   */
>> >               .align
>> >               .arm                            @ Always enter in ARM
>> > state
>> > +             .text
>> >  start:
>> >               .type   start,#function
>> > -             .rept   7
>> > +#ifdef CONFIG_EFI_STUB
>> > +             @ Magic MSDOS signature for PE/COFF + ADD opcode
>> > +             .word   0x62805a4d
>> > +#else
>> > +             mov     r0, r0
>> > +#endif
>> > +             .rept   5
>> >               mov     r0, r0
>> >               .endr
>> > -   ARM(              mov     r0, r0          )
>> > -   ARM(              b       1f              )
>> > - THUMB(              adr     r12, BSYM(1f)   )
>> > - THUMB(              bx      r12             )
>> > +
>> > +             adrl    r12, BSYM(zimage_continue)
>> > + ARM(                mov     pc, r12 )
>> > + THUMB(              bx      r12     )
>> > +             @ zimage_continue will be in ARM or thumb mode as
>> > configured
>> >
>> >               .word   0x016f2818              @ Magic numbers to help
>> > the loader
>> >               .word   start                   @ absolute load/run zImage
>> > address
>> >               .word   _edata                  @ zImage end address
>> > +
>> > +#ifdef CONFIG_EFI_STUB
>> > +             @ Portions of the MSDOS file header must be at offset
>> > +             @ 0x3c from the start of the file.  All PE/COFF headers
>> > +             @ are kept contiguous for simplicity.
>> > +#include "efi-header.S"
>> > +
>> > +efi_stub_entry:
>> > +             @ The EFI stub entry point is not at a fixed address,
>> > however
>> > +             @ this address must be set in the PE/COFF header.
>> > +             @ EFI entry point is in A32 mode, switch to T32 if
>> > configured.
>> > + THUMB(              adr     r12, BSYM(1f)   )
>> > + THUMB(              bx      r12             )
>> >   THUMB(              .thumb                  )
>> >  1:
>> > +             @ Save lr on stack for possible return to EFI firmware.
>> > +             @ Don't care about fp, but need 64 bit alignment....
>> > +             stmfd   sp!, {fp, lr}
>> > +
>> > +             @ allocate space on stack for return of new entry point of
>> > +             @ zImage, as EFI stub may copy the kernel.  Pass address
>> > +             @ of space in r2 - EFI stub will fill in the pointer.
>> > +
>> > +             sub     sp, sp, #8              @ we only need 4 bytes,
>> > +                                             @ but keep stack 8 byte
>> > aligned.
>> > +             mov     r2, sp
>>
>> You can save an instruction here: skip these two instructions, and see
>> below just before the call to efi_entry [1]
>>
>> > +             @ Pass our actual runtime start address in pointer data
>> > +             adr     r11, LC0                @ address of LC0 at run
>> > time
>> > +             ldr     r12, [r11, #0]          @ address of LC0 at link
>> > time
>>
>> Can we just move this delta calculation after efi_entry?
>>
>> You don't need to specifiy an explicit offset if it's zero, btw:
>>
>>         ldr     r12, [r11]
>>
>> works just as well.  Same for the other instances.
>
>
> So after looking at this it was pretty messed up.  The LC0 business was to
> compute the
> linktime/runtime offset, which I had used to lookup the uncompressed kernel
> size.
> That ended up not being useful, but this code stayed around.  I've reworked
> this
> section of code to remove that cruft and incorporate your suggestions.
>
> I've put an updated diff of just head.S at the end of the email.
>
>>
>> > +
>> > +             sub     r3, r11, r12            @ calculate the delta
>> > offset
>> > +             str     r3, [r2, #0]
>>
>> I think r2 is still equal to sp, so
>>
>>         str     r3, [sp]
>>
>> should be OK.
>>
>> [1]Or, combine this with the modification of sp:
>>
>>         str     r3, [sp, #-8]!
>>         mov     r2, sp
>>
>> > +             bl      efi_entry
>> > +
>> > +             @ get new zImage entry address from stack, put into r3
>> > +             ldr     r3, [sp, #0]
>> > +             add     sp, sp, #8              @ restore stack
>>
>>         ldr     r3, [sp], #8
>>
>> > +
>> > +             @ Check for error return from EFI stub
>> > +             mov     r1, #EFI_STUB_ERROR
>> > +             cmp     r0, r1
>>
>>         cmp r0, #EFI_STUB_ERROR
>>
>> probably works.  The assembler will turn this into a cmn as necessary.
>>
>> > +             beq     efi_load_fail
>> > +
>> > +
>> > +             @ Save return values of efi_entry
>> > +             stmfd   sp!, {r0, r3}
>> > +             bl      cache_clean_flush
>> > +             bl      cache_off
>> > +             ldmfd   sp!, {r0, r3}
>> > +
>> > +             @ Set parameters for booting zImage according to boot
>> > protocol
>> > +             @ put FDT address in r2, it was returned by efi_entry()
>> > +             @ r1 is FDT machine type, and r0 needs to be 0
>> > +             mov     r2, r0
>> > +             mov     r1, #0xFFFFFFFF
>> > +             mov     r0, #0
>> > +
>> > +             @ Branch to (possibly) relocated zImage that is in r3
>> > +             @ Make sure we are in A32 mode, as zImage requires
>> > + THUMB(              bx      r3              )
>> > + ARM(                mov     pc, r3          )
>> > +
>> > +efi_load_fail:
>> > +             @ Return EFI_LOAD_ERROR to EFI firmware on error.
>> > +             @ Switch back to ARM mode for EFI is done based on
>> > +             @ return address on stack
>> > +             ldr     r0, =0x80000001
>> > +             ldmfd   sp!, {fp, pc}
>> > +#endif
>> > +
>> > + THUMB(              .thumb                  )
>> > +zimage_continue:
>> >               mrs     r9, cpsr
>> >  #ifdef CONFIG_ARM_VIRT_EXT
>> >               bl      __hyp_stub_install      @ get into SVC mode,
>> > reversibly
>> > @@ -167,7 +246,6 @@ not_angel:
>> >                * by the linker here, but it should preserve r7, r8, and
>> > r9.
>> >                */
>> >
>> > -             .text
>> >
>> >  #ifdef CONFIG_AUTO_ZRELADDR
>> >               @ determine final kernel image address
>> > --
>> > 1.7.10.4
>> >
>> >
>> > _______________________________________________
>> > linux-arm-kernel mailing list
>> > linux-arm-kernel@lists.infradead.org
>> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
>
> diff --git a/arch/arm/boot/compressed/head.S
> b/arch/arm/boot/compressed/head.S
> index 75189f1..820a238 100644
> --- a/arch/arm/boot/compressed/head.S
> +++ b/arch/arm/boot/compressed/head.S
> @@ -10,6 +10,7 @@
>   */
>  #include <linux/linkage.h>
>  #include <asm/assembler.h>
> +#include "efi-stub.h"
>
>   .arch armv7-a
>  /*
> @@ -120,21 +121,92 @@
>   */
>   .align
>   .arm @ Always enter in ARM state
> + .text
>  start:
>   .type start,#function
> - .rept 7
> +#ifdef CONFIG_EFI_STUB
> + @ Magic MSDOS signature for PE/COFF + ADD opcode
> + @ the EFI stub only supports little endian, as the EFI functions
> + @ it invokes are little endian.
> + .word 0x62805a4d
> +#else
> + mov r0, r0
> +#endif
> + .rept 5
>   mov r0, r0
>   .endr
> -   ARM( mov r0, r0 )
> -   ARM( b 1f )
> - THUMB( adr r12, BSYM(1f) )
> - THUMB( bx r12 )
> +
> + adrl r12, BSYM(zimage_continue)
> + ARM( mov     pc, r12 )
> + THUMB( bx r12     )
> + @ zimage_continue will be in ARM or thumb mode as configured
>
>   .word 0x016f2818 @ Magic numbers to help the loader
>   .word start @ absolute load/run zImage address
>   .word _edata @ zImage end address
> +
> +#ifdef CONFIG_EFI_STUB
> + @ Portions of the MSDOS file header must be at offset
> + @ 0x3c from the start of the file.  All PE/COFF headers
> + @ are kept contiguous for simplicity.
> +#include "efi-header.S"
> +
> +efi_stub_entry:
> + @ The EFI stub entry point is not at a fixed address, however
> + @ this address must be set in the PE/COFF header.
> + @ EFI entry point is in A32 mode, switch to T32 if configured.
> + THUMB( adr r12, BSYM(1f) )
> + THUMB( bx r12 )
>   THUMB( .thumb )
>  1:
> + @ Save lr on stack for possible return to EFI firmware.
> + @ Don't care about fp, but need 64 bit alignment....
> + stmfd sp!, {fp, lr}
> +
> + @ allocate space on stack for passing current zImage address
> + @ and for the EFI stub to return of new entry point of
> + @ zImage, as EFI stub may copy the kernel.  Pointer address
> + @ is passed in r2.  r0 and r1 are passed through from the
> + @ EFI firmware to efi_entry
> + adr r3, start
> + str r3, [sp, #8]!

above line should be:
str r3, [sp, #-8]!

that - sign is really hard to see in gmail :)

> + mov r2, sp @ pass pointer in r2
> + bl efi_entry
> + ldr r3, [sp], #8 @ get new zImage address from stack
> +
> + @ Check for error return from EFI stub.  r0 has FDT address
> + @ or EFI_STUB_ERROR error code.
> + cmp r0, #EFI_STUB_ERROR
> + beq efi_load_fail
> +
> + @ Save return values of efi_entry
> + stmfd sp!, {r0, r3}
> + bl cache_clean_flush
> + bl cache_off
> + ldmfd   sp!, {r0, r3}
> +
> + @ Set parameters for booting zImage according to boot protocol
> + @ put FDT address in r2, it was returned by efi_entry()
> + @ r1 is FDT machine type, and r0 needs to be 0
> + mov r2, r0
> + mov r1, #0xFFFFFFFF
> + mov r0, #0
> +
> + @ Branch to (possibly) relocated zImage that is in r3
> + @ Make sure we are in A32 mode, as zImage requires
> + THUMB( bx r3 )
> + ARM( mov pc, r3 )
> +
> +efi_load_fail:
> + @ Return EFI_LOAD_ERROR to EFI firmware on error.
> + @ Switch back to ARM mode for EFI is done based on
> + @ return address on stack in case we are in THUMB mode
> + ldr r0, =0x80000001
> + ldmfd sp!, {fp, pc} @ put lr from stack into pc
> +#endif
> +
> + THUMB( .thumb )
> +zimage_continue:
>   mrs r9, cpsr
>  #ifdef CONFIG_ARM_VIRT_EXT
>   bl __hyp_stub_install @ get into SVC mode, reversibly
> @@ -167,7 +239,6 @@ not_angel:
>   * by the linker here, but it should preserve r7, r8, and r9.
>   */
>
> - .text
>
>  #ifdef CONFIG_AUTO_ZRELADDR
>   @ determine final kernel image address
>
