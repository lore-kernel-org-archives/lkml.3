Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbaKKXr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 18:47:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54771 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbaKKXr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 18:47:58 -0500
Date: Wed, 12 Nov 2014 00:47:52 +0100
From: Borislav Petkov <bp@suse.de>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG() at boot in __phys_addr with DEBUG_VIRTUAL
Message-ID: <20141111234752.GC32130@pd.tnic>
References: <5462999A.7090706@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5462999A.7090706@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 03:19:54PM -0800, Dave Hansen wrote:
> I'm seeing a BUG() at boot in __phys_addr when it has DEBUG_VIRTUAL enabled:
> 
> >> [    1.193264] ------------[ cut here ]------------
> >> [    1.198502] kernel BUG at /home/davehans/linux.git/arch/x86/mm/physaddr.c:36!
> > ...
> >> [    1.368810] Call Trace:
> >> [    1.371590]  [<ffffffff8105824c>] __change_page_attr_set_clr+0x42c/0xff0
> >> [    1.379197]  [<ffffffff81059e42>] kernel_map_pages_in_pgd+0x72/0x110
> >> [    1.386410]  [<ffffffff81fe2be2>] __map_region+0x45/0x63
> >> [    1.392437]  [<ffffffff81fe2e13>] efi_map_region+0x32/0xce
> >> [    1.398663]  [<ffffffff81fe2936>] efi_enter_virtual_mode+0x18c/0x3a4
> >> [    1.405876]  [<ffffffff81fcb0b6>] start_kernel+0x421/0x4a1
> >> [    1.412101]  [<ffffffff81fcaa85>] ? set_init_arg+0x55/0x55
> >> [    1.418327]  [<ffffffff81fca120>] ? early_idt_handlers+0x120/0x120
> >> [    1.425342]  [<ffffffff81fca5f2>] x86_64_start_reservations+0x2a/0x2c
> >> [    1.432652]  [<ffffffff81fca746>] x86_64_start_kernel+0x152/0x161
> >> [    1.439565] Code: 0f 94 c2 31 c0 e8 a6 47 83 00 48 c7 c7 41 49 cc 81 31 c0 e8 98 47 83 00 31 d2 be 01 00 00 00 48 c7 c7 a0 49 f2 81 e8 ab 4a 0e 00 <0f> 0b 0f 0b 4c 89 e2 48 c7 c6 b3 e5 a0 81 48 c7 c7 5c 7a ca 81 
> >> [    1.461866] RIP  [<ffffffff8105c055>] __phys_addr+0x185/0x260
> >> [    1.468400]  RSP <ffffffff81e03cf8>
> >> [    1.472396] ---[ end trace b59b0f17341a4bc4 ]---
> >> [    1.477663] Kernel panic - not syncing: Attempted to kill the idle task!
> >> [    1.485270] ---[ end Kernel panic - not syncing: Attempted to kill the idle task!
> 
> But I've noticed something odd.  kernel_map_pages_in_pgd() takes a pfn:
> 
> extern int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long
> 			address, unsigned numpages, unsigned long
> 			page_flags);
> 
> But the code in arch/x86/platform/efi/efi_64.c seems a bit confused
> about that.  Two users pass a physical address while a third passes in a
> pfn:
> 
> >         if (kernel_map_pages_in_pgd(pgd, text >> PAGE_SHIFT, text, npages, 0)) {

Does it work if you drop the ">> PAGE_SHIFT" ?

> >         if (kernel_map_pages_in_pgd(pgd, md->phys_addr, va, md->num_pages, pf))
> >         if (kernel_map_pages_in_pgd(pgd, pa_memmap, pa_memmap, num_pages, _PAGE_NX)) {
> 
> kernel_map_pages_in_pgd() also sticks that value in to 'struct
> cpa_data'->pfn.  But, then the "PFN" seems to get used like a physical
> address.  For instance:

Yeah, I called it pfn because struct cpa_data has a pfn member and at
the time I wanted to reuse it for the physical address.

I guess I should change that by adding a ->paddr instead of misusing
pfn.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
