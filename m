Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab3HWWkI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 18:40:08 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:55056 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab3HWWkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 18:40:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAFECyb-1a_9AY_qicTRCw5f3haMJ7ucsMc8U3ReMmMjWCJdRFg@mail.gmail.com>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
	<CAFECyb_OMY6eEbkbYTC4sE56Za0rC+KFNFRbGWb2ECEqhiKbTQ@mail.gmail.com>
	<CAFECyb-1a_9AY_qicTRCw5f3haMJ7ucsMc8U3ReMmMjWCJdRFg@mail.gmail.com>
Date: Fri, 23 Aug 2013 15:40:04 -0700
Message-ID: <CAFECyb_sJ8JTs-t5PuuxR7YyVYUYE5CaRX60NS03VsH29OeYjA@mail.gmail.com>
Subject: Re: [PATCH V3 RFC 00/16] EFI stub for ARM
From: Roy Franz <roy.franz@linaro.org>
To: linux-efi@vger.kernel.org, matt.fleming@intel.com
Cc: Leif Lindholm <leif.lindholm@linaro.org>, linux-kernel@vger.kernel.org,
        Dave Martin <dave.martin@arm.com>, Mark Salter <msalter@redhat.com>,
        Roy Franz <roy.franz@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 5:16 PM, Roy Franz <roy.franz@linaro.org> wrote:
> On Tue, Aug 13, 2013 at 10:58 AM, Roy Franz <roy.franz@linaro.org> wrote:
>> On Fri, Aug 9, 2013 at 4:26 PM, Roy Franz <roy.franz@linaro.org> wrote:
>>>
>>> This patch series adds EFI stub support for the ARM architecture.
>>> Some code that was previously only used by x86/x86_64 is now shared
>>> and has been made more general.  The stub for ARM is implemented in
>>> a similar manner to x86 in that it is a shim layer between EFI and
>>> the normal zImage/bzImage boot process, and that an image with the
>>> stub configured is bootable as both a zImage and EFI application.
>>>
>>> This patch now (new for v3) series depends on the
>>> "arm: Add [U]EFI runtime services support" patches by leif.lindholm@linaro.org.
>>> The Kconfig option now depends on the "CONFIG_EFI" option that his series
>>> adds, and this option will ensure a little endian configuration.  Also, the
>>> EFI support is used to handle the EFI memory map the stub passes to the kernel.
>>> There are some minor changes to be coordinated with the EFI runtime services
>>> patch series, so I have put this back to RFC status.  These changes should be
>>> minor and relate to final device tree bindings.
>>>
>>> Changes since v2:
>>> * EFI bugfix "correct call to free_pages" that patch series
>>>   depends on now in mainline
>>> * remove "-fno-stack-protector" from decompressor Makefile.  The current code doesn't
>>>   trigger the stack protection, so the decompressor now compiles with it still
>>>   on.  Note that there has never been any stack protection in the decompressor
>>>   since the stack usage doesn't trigger the heuristic in GCC, so right now
>>>   the "-fno-stack-protector" is a noop.
>>> * Changed EFI command line handling to not have a fixed limit.
>>> * Change FDT memory allocation to retry with a larger allocation if
>>>   first educated guess is inadequate.
>>> * Correctly set 'SizeOfCode' in PE/COFF header.
>>> * Reviewed ".setup" section that is in x86 PE/COFF header.  This is used for x86
>>>   to account for code that is not in the .text section.  We don't need this
>>>   for ARM, as all of our code is in the .text section, or in the PE/COFF header
>>>   itself.
>>> * Moved EFI_STUB_ERROR #define to header file to share between stub C and ASM.
>>> * Variety of cleanups and fixes in head.S.
>>> * Changed update_fdt_and_exit_boot() to just update the device tree, and
>>>   renamed appropriately.  Memory allocations moved out of this function as
>>>   well, which enables the retries if the initial FDT size is too small.
>>>   Note that in order to do the retried allocations, the original FDT and
>>>   command line memory regions are left allocated.  This is OK since the kernel
>>>   has the memory map and will free these allocations along with the initrd
>>>   and new fdt allocations.
>>> * Added prefix to all prints, reduced number of prints, and reviewed all
>>>   messages.
>>> * Change mixed usage of dtb/fdt to all be fdt or "device tree" in efi-stub.c
>>> * remove unnecessary zimage_size variable from relocate_kernel()
>>> * correct return types on EFI functions - should be efi_status_t, not int.
>>>
>>>
>>>
>>> Changes since V1:
>>> * Updated head.S based on feedback from Dave Martin.  ARM/THUMB
>>>   switches now much cleaner.
>>> * Broke up changes to x86 and common code into more patches.
>>>   10 more patches in this series.
>>>
>>> Roy Franz (16):
>>>   Move common EFI stub code from x86 arch code to common location
>>>   Add system pointer argument to shared EFI stub related     functions
>>>     so they no longer use global system table     pointer as they did
>>>     when part of eboot.c.     This code is now shared, so using a
>>>     global variable     as part of the interface is not that nice.
>>>     Also,     by avoiding any global variables in the ARM EFI stub,
>>>     this allows the code to be position independent without
>>>     requiring GOT fixups.
>>>   Rename memory allocation/free functions
>>>   Add minimum address parameter to efi_low_alloc()
>>>   rename __get_map() to efi_get_memory_map(), add parameter     to
>>>     optionally return mmap key. The mmap key is required     to exit
>>>     EFI boot services, and allows efi_get_memory_map()     to be used
>>>     for getting final memory map.
>>>   Enforce minimum alignment of 1 page on allocations.     The
>>>     efi_high_alloc() and efi_low_alloc() functions     use the
>>>     EFI_ALLOCATE_ADDRESS option to the EFI     function
>>>     allocate_pages(), which requires a minimum     of page alignment,
>>>     and rejects all other requests.
>>>   Allow efi_free() to be called with size of 0, and do nothing in that
>>>     case.
>>>   Generalize handle_ramdisks() and rename to handle_cmdline_files().
>>>   Renames in handle_cmdline_files() to complete generalization.
>>>   Move EFI_READ_CHUNK_SIZE define to shared location.
>>>   Add proper definitions for some EFI function pointers.
>>>   Fix types in EFI calls to match EFI function definitions.
>>>   resolve warnings found on ARM compile
>>>   Add strstr to compressed string.c for ARM.
>>>   Add EFI stub for ARM
>>>   Add config EFI_STUB for ARM to Kconfig
>>>
>>>  arch/arm/Kconfig                       |   11 +
>>>  arch/arm/boot/compressed/Makefile      |   15 +-
>>>  arch/arm/boot/compressed/efi-header.S  |  111 +++++++
>>>  arch/arm/boot/compressed/efi-stub.c    |  448 ++++++++++++++++++++++++++++
>>>  arch/arm/boot/compressed/efi-stub.h    |    5 +
>>>  arch/arm/boot/compressed/head.S        |   90 +++++-
>>>  arch/arm/boot/compressed/string.c      |   21 ++
>>>  arch/x86/boot/compressed/eboot.c       |  490 ++-----------------------------
>>>  arch/x86/boot/compressed/eboot.h       |    9 -
>>>  drivers/firmware/efi/efi-stub-helper.c |  505 ++++++++++++++++++++++++++++++++
>>>  include/linux/efi.h                    |   51 +++-
>>>  11 files changed, 1263 insertions(+), 493 deletions(-)
>>>  create mode 100644 arch/arm/boot/compressed/efi-header.S
>>>  create mode 100644 arch/arm/boot/compressed/efi-stub.c
>>>  create mode 100644 arch/arm/boot/compressed/efi-stub.h
>>>  create mode 100644 drivers/firmware/efi/efi-stub-helper.c
>>>
>>> --
>>> 1.7.10.4
>>>
>>
>> Hi Matt,
>>
>>    Do you have any more feedback on the X86 and common code (patches
>> 1-13) that needs to be addressed?  Mark Salter has a working ARM64 EFI
>> stub implemented based on these patches, so the common code has now
>> been tested with another architecture, and he has acked these patches.
>> If the current patches are OK, can this be queued for 3.12? (and into
>> linux-next, if appropriate)
>> The ARM portion may take a little longer based on the EFI runtime
>> services patch dependencies, but getting the common code merged would
>> allow the ARM64 EFI stub work to go forward independently.
>>
>> I can resend patches 1-13 as a new series of x86/common only changes
>> if you would like.
>>
>> Thanks,
>> Roy
>
> Hi Matt,
>
>    Any thoughts on taking the x86/common parts for 3.12?
>
> Thanks,
> Roy

Hi Matt,

   Do you have a tree I can monitor to see if you have taken this?
Would you like me to split out the x86/common only changes into a
separate series from the ARM changes?

Thanks,
Roy
