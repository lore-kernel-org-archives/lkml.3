Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072AbbA0Vhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:37:50 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:60239 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826AbbA0Vhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:37:48 -0500
Date: Tue, 27 Jan 2015 21:37:40 +0000
From: Matt Fleming <matt@codeblueprint.co.uk>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Borislav Petkov <bp@suse.de>, Matt Fleming <matt.fleming@intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG() at boot in __phys_addr with DEBUG_VIRTUAL
Message-ID: <20150127213740.GA4115@codeblueprint.co.uk>
References: <5462999A.7090706@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5462999A.7090706@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Digging up an old thread...)

On Tue, 11 Nov, at 03:19:54PM, Dave Hansen wrote:
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
 
This appears to be caused by the large page split accounting from
__split_large_page(),


	if (pfn_range_is_mapped(PFN_DOWN(__pa(address)),                       
				PFN_DOWN(__pa(address)) + 1))                  
		split_page_count(level); 


The __pa() uses were introduced in commit 8eb5779f6b9c ("x86, mm: use
pfn_range_is_mapped() with CPA"), previously 'address' wasn't passed
directly to __pa().

This does seem to be isolated code. Nothing else in the
kernel_map_pages_in_pgd() path assumes that 'address' is contained in
the direct kernel mapping (though other functions in pageattr.c do).

This should probably be treated as a regression, of sorts.

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
> >         if (kernel_map_pages_in_pgd(pgd, md->phys_addr, va, md->num_pages, pf))
> >         if (kernel_map_pages_in_pgd(pgd, pa_memmap, pa_memmap, num_pages, _PAGE_NX)) {
> 
> kernel_map_pages_in_pgd() also sticks that value in to 'struct
> cpa_data'->pfn.  But, then the "PFN" seems to get used like a physical
> address.  For instance:
> 
>                 set_pmd(pmd, __pmd(cpa->pfn | _PAGE_PSE | ...
> 
> How could this possibly work?

I suspect it's mostly luck. For example, I've noticed that
try_preserve_large_page() will in fact modify cpa->pfn to a real page
frame number even if we've stashed a physical address there.

I'll go audit all the uses of ->pfn.

After fixing up the issue you raised Dave, I'm now hitting the below in
the EFI thunking code. More legitimate bugs.

 [    0.107662] ------------[ cut here ]------------
 [    0.108000] kernel BUG at /home/matt/src/kernels/efi/arch/x86/mm/physaddr.c:26!
...
 [    0.108000] Call Trace:
 [    0.108000]  [<ffffffff8104af8d>] efi_thunk_set_variable+0x3d/0x100
 [    0.108000]  [<ffffffff8104a808>] efi_delete_dummy_variable+0x68/0x70
 [    0.108000]  [<ffffffff81d07b12>] efi_enter_virtual_mode+0x382/0x391
 [    0.108000]  [<ffffffff81cf0ee5>] start_kernel+0x35d/0x3ec
 [    0.108000]  [<ffffffff81cf0978>] ? set_init_arg+0x55/0x55
 [    0.108000]  [<ffffffff81cf0581>] x86_64_start_reservations+0x2a/0x2c
 [    0.108000]  [<ffffffff81cf067a>] x86_64_start_kernel+0xf7/0xfb

Lemme go investigate.

-- 
Matt Fleming, Intel Open Source Technology Center
