Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab3HFPap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 11:30:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755429Ab3HFPan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 11:30:43 -0400
Message-ID: <520116D1.2010000@redhat.com>
Date: Tue, 06 Aug 2013 17:31:29 +0200
From: Laszlo Ersek <lersek@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130621 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: edk2-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>,
        linux-efi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Matt Fleming <matt@console-pimps.org>
Subject: Re: [edk2] Corrupted EFI region
References: <51FFAB13.4090603@redhat.com> <20130805140306.GD31845@pd.tnic> <51FFB660.4060400@redhat.com> <20130805144010.GE31845@pd.tnic> <51FFC19A.1020204@redhat.com> <20130805161247.GF31845@pd.tnic> <51FFD5B0.9080000@redhat.com> <20130805164731.GG31845@pd.tnic> <52001896.1030509@redhat.com> <20130805220808.GC14067@pd.tnic> <20130806141036.GD14891@pd.tnic>
In-Reply-To: <20130806141036.GD14891@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/13 16:10, Borislav Petkov wrote:
> On Tue, Aug 06, 2013 at 12:08:08AM +0200, Borislav Petkov wrote:
>> Ok, thanks again for finding it, I'll go and try to figure out the whole
>> mess tomorrow.
> 
> Ok, some more observations:
> 
> Decompressing Linux... Parsing ELF... done.
> Booting the kernel.
> [    0.000000] memblock_reserve: [0x0000000009f000-0x00000000100000] reserve_ebda_region+0x56/0x58
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.11.0-rc4+ (boris@nazgul) (gcc version 4.7.3 (Debian 4.7.3-4) ) #4 SMP PREEMPT Tue Aug 6 15:15:07 CEST 2013
> [    0.000000] memblock_reserve: [0x00000002000000-0x000000036c0000] setup_arch+0x47/0xa63
> [    0.000000] Command line: root=/dev/sda1 debug ignore_loglevel log_buf_len=10M earlyprintk=ttyS0,115200 console=ttyS0,115200 console=tty0 memblock=debug
> [    0.000000] efi: efi_memblock_x86_reserve_range: pmap: 0x7e0ad018
> [    0.000000] memblock_reserve: [0x0000007e0ad018-0x0000007e0ad588] efi_memblock_x86_reserve_range+0x70/0x75
> 
> And this is it:
> 
> efi_memblock_x86_reserve_range() reserves the region which overlaps with
> the following region:
> 
> [    0.000000] efi: mem11: type=4, attr=0xf, range=[0x000000007e0ad000-0x000000007e0cc000) (0MB)
> 
> Now, this address 0x7e0ad018 is boot_params.efi_info.efi_memmap which,
> AFAICT, we write to in exit_boot() after calling GetMemoryMap(). IOW,
> this the EFI memory map descriptor which we mark as reserved.
> 
> So, hmm, I'm not sure what we want to do here.

To me this looks like a genuine conflict.

01 efi_main()
02  exit_boot()
03    low_alloc()
04    GetMemoryMap()
05    ExitBootServices()
06
07 start_kernel()
08   setup_arch()
09    efi_memblock_x86_reserve_range()
10    efi_reserve_boot_services()
11  efi_enter_virtual_mode()
12    SetVirtualAddressMap()

GetMemoryMap() does not itself allocate memory of any kind (which could
potentially change the memory map in-flight). It requires an input
buffer, tries to squeeze all map entries into it. If they fit, OK, if
they don't, the caller will know to allocate a bigger buffer
(potentially changing the memory map) and call GetMemoryMap() again.

So, on line 03 we allocate memory for GetMemoryMap(). As you say, this
exact area of 0x570 bytes, holding the memory map, is then marked as
reserved on line 09.

At line 10, when we want to reserve a boot services data region, we find
out that part of it has already been reserved.

I see two problems here. The first problem is what you mention -- the
decision *not* to reserve a region because part of it is already
reserved is hard to comprehend:

> Off the top of my head, I'm thinking this: efi_reserve_boot_services()
> which truncates this region to 0 should actually check that this special
> region is reserved, and *enlarge* it instead of making it of size 0, no?

The second problem is orthogonal and maybe "deeper":

  The memory allocated by low_alloc() on line 03, of type
  EFI_LOADER_DATA, intersects with a region of type
  EFI_BOOT_SERVICES_DATA, according to the GetMemoryMap() call on line
  04.

Something is very wrong here.

Clearly, if the 2nd problem didn't exist, then the 1st one wouldn't either.

Allocating the backing store for the memory map itself (on line 03) as
EFI_LOADER_DATA is a good choice. This kind of memory survives
ExitBootServices(), is not relocated, etc.

But, I cannot understand how the subsequent GetMemoryMap() call can
report an overlapping EFI_BOOT_SERVICES_DATA range. (Actually, the
EFI_BOOT_SERVICES_DATA range *surrounds* the EFI_LOADER_DATA range.)

This problem could be related to the logic in low_alloc(). It figures
out an address and allocates (rounded up) pages exactly at that address,
the firmware doesn't have any leeway to change it. The address to
allocate at is a hard requirement (EFI_ALLOCATE_ADDRESS) rather than a hint.

Normally this logic would cleave out a bit of memory from an
EFI_CONVENTIONAL_MEMORY range, and convert it to type EFI_LOADER_DATA.
Which makes it even less understandable how the subsequent
GetMemoryMap() call can report a surrounding EFI_BOOT_SERVICES_DATA range.

Can you capture the OVMF debug output? Do you see

  ConvertPages: Incompatible memory types

there?

Can you set the following bits too in the debug mask?

#define DEBUG_POOL      0x00000010  // Alloc & Free's
#define DEBUG_PAGE      0x00000020  // Alloc & Free's

Thanks
Laszlo
