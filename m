Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab3HEVZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 17:25:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440Ab3HEVZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 17:25:04 -0400
Message-ID: <52001896.1030509@redhat.com>
Date: Mon, 05 Aug 2013 23:26:46 +0200
From: Laszlo Ersek <lersek@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130621 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: edk2-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>,
        linux-efi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [edk2] Corrupted EFI region
References: <20130801164927.GA7445@pd.tnic> <51FF8C14.2070405@redhat.com> <20130805130258.GB31845@pd.tnic> <51FFAB13.4090603@redhat.com> <20130805140306.GD31845@pd.tnic> <51FFB660.4060400@redhat.com> <20130805144010.GE31845@pd.tnic> <51FFC19A.1020204@redhat.com> <20130805161247.GF31845@pd.tnic> <51FFD5B0.9080000@redhat.com> <20130805164731.GG31845@pd.tnic>
In-Reply-To: <20130805164731.GG31845@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/13 18:47, Borislav Petkov wrote:

> Here's the whole dmesg up until efi_enter_virtual_map. When we have entered
> efi_enter_virtual_mode, the region has changed from
> 
> [    0.000000] efi: mem11: type=4, attr=0xf, range=[0x000000007e0ad000-0x000000007e0cc000) (0MB)
> 
> to
> 
> [    0.023004] efi: mem11: type=4, attr=0xf, range=[0x000000007e0ad000-0x000000007e0ad000) (0MB)
> 
> 
> And yes, I still need to audit whether the kernel actually does that
> change. I'm still looking...

The following is a long shot, but I have no better idea for now.

Normally the following relevant sequence of calls are made to UEFI services:
(a) GetMemoryMap() --> returns memory map and map key,
(b) ExitBootServices() <-- takes map key
(c) SetVirtualAddressMap() <-- takes memory map (completed with virtual
addresses)

((a)+(b) can be repeated if (b) fails, and Linux seems to retry once.)

Now see Linux commit


<http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=916f676f>

by Matthew. If I understand correctly, it introduces the function
efi_reserve_boot_services(). Normally, immediately after a successful
(b) -- ExitBootServices() -- one should be allowed to free boot services
code and data. However (c) itself -- SetVirtualAddressMap() -- seems to
depend on boot services code and data in some firmware implementations
(probably violating the spec). Therefore this commit keeps boot services
code and data around long enough for SetVirtualAddressMap(), and
releases them after.

I *think* efi_reserve_boot_services() runs between (b) and (c), that is,
after the initial EFI memmap dump, and before efi_enter_virtual_mode()
does its thing (ie. before your debug memmap dump is executed there):

efi_main() [arch/x86/boot/compressed/eboot.c]
  exit_boot()
    --> covers (a) and (b)

start_kernel() [init/main.c]
  setup_arch() [arch/x86/kernel/setup.c]
    efi_memblock_x86_reserve_range() [arch/x86/platform/efi/efi.c]
    efi_reserve_boot_services() [arch/x86/platform/efi/efi.c]
  efi_enter_virtual_mode() [arch/x86/platform/efi/efi.c]
    --> covers (c)

That is, efi_reserve_boot_services() is called in a place where it can
potentially alter the EFI memmap between the two dumps.

(I only display efi_memblock_x86_reserve_range() in the callstack above
for completeness; I'll refer back to it lower down.)

Now look at Linux commit


<http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=7d68dc3f>

This commit changes efi_reserve_boot_services() -- it restricts the
function to reserve the boot services code & data only under some
circumstances. If those don't hold, then:

  md->num_pages = 0;

Which I think is exactly the source of the region being truncated to
zero size.

("memmap.phys_map" is set to the EFI memory map in
efi_memblock_x86_reserve_range(), see the above partial callstack, and
"memmap.map" is pointed at "memmap.phys_map" in efi_memmap_init().
efi_reserve_boot_services() iterates over "memmap.map", so we can say it
modifies the EFI memory map.)

Granted, memblock_dbg() is called too if num_pages is reset, and the
message it prints is not included in your dmesg. However I think that
could be explained by memblock_debug==0 [include/linux/memblock.h].

What happens if you pass "memblock=debug" on the kernel command line
(see early_memblock() in "mm/memblock.c")?

(I just tried it in my Fedora 19 guest, and it in fact produced the message

[    0.000000] efi: Could not reserve boot range [0x0000800000-0x0000ffffff]

)


BTW, regarding Michael's answer, I think this is just one of several
ways in which Linux manipulates the EFI memmap between (b) and (c). For
example it seems to merge ranges in the map.

Thanks,
Laszlo
