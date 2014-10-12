Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaJLMza (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 08:55:30 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:33436 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaJLMz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 08:55:26 -0400
Date: Sun, 12 Oct 2014 14:55:15 +0200
From: Mathias Krause <minipli@googlemail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86-ml <x86@kernel.org>, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCHv2 1/3] x86, ptdump: Add section for EFI runtime services
Message-ID: <20141012125515.GA32045@jig.fritz.box>
References: <1411313216-2641-1-git-send-email-minipli@googlemail.com>
 <1411313216-2641-2-git-send-email-minipli@googlemail.com>
 <20141003134707.GJ14343@console-pimps.org>
 <20141007150132.GA7307@nazgul.tnic>
 <20141007170748.GA25767@jig.fritz.box>
 <20141008151730.GB16892@pd.tnic>
 <CA+rthh_Q0HQfLX6P3kcuOUwggjSnhYGCc5YJNOn0UCCRPZbaxA@mail.gmail.com>
 <20141008222619.GG16892@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008222619.GG16892@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 12:26:19AM +0200, Borislav Petkov wrote:
> On Wed, Oct 08, 2014 at 11:58:20PM +0200, Mathias Krause wrote:
> > Well, that is only partly correct. The call chain in efi_map_regions()
> > [ -> efi_map_region() -> __map_region() -> kernel_map_pages_in_pgd()
> > -> ..."magic"... ] does not only map the EFI regions in
> > trampoline_pgd, but also in kernel page table, i.e. init_level4_pgt.
> 
> No, this is completely correct. If it isn't, then it needs to be. We
> can't have EFI mappings in the kernel page table for a reason.

What would be the reason for not having the EFI mappings in kernel page
table? Don't get me wrong, I don't want those either, but are there
other reasons beside you(?) and me not liking rwx mappings of firmware
code and data in the kernel address space?

> EFI mappings only land in trampoline_pgd, not in the kernel page table,
> .i.e *not* in init_level4_pgt. Look at what the first argument of every
> invocation of kernel_map_pages_in_pgd() is.

I can see the first argument of kernel_map_pages_in_pgd() but that
doesn't mean the EFI mappings wont be added to the kernel page table as
well. In fact, they are -- as I've shown you multiple times already and
figured the reason why, meanwhile. The reason lies in how trampoline_pgd
gets set up in arch/x86/realmode/init.c:

  trampoline_pgd = (u64 *) __va(real_mode_header->trampoline_pgd);
  trampoline_pgd[0] = init_level4_pgt[pgd_index(__PAGE_OFFSET)].pgd;
  trampoline_pgd[511] = init_level4_pgt[511].pgd;

This means, trampoline_pgd[0] is effectively just an alias for
init_level4_pgt[pgd_index(__PAGE_OFFSET)], trampoline_pgd[511] one for
init_level4_pgt[511].

So, when adding the EFI physical mappings to trampoline_pgd[0], we're
actually messing with init_level4_pgt[pgd_index(__PAGE_OFFSET)]. When
adding the virtual mappings, we're messing with init_level4_pgt[511]. So
we *are*, in fact, adding the EFI mappings to the kernel page table.

There's a lengthy comment in arch/x86/platform/efi/efi.c that mentions
the duplication of pgd entries -- and therefore whole hierarchies --
between trampoline_pgd and init_level4_pgt. And, ironically, that
comment is yours from earlier this year. Looks like you forgot about
that in the meantime ;)

> 
> > That can easily be shown by looking at the kernel_page_tables debugfs
> > file on a running system. You'll notice large RWX portions covering
> > the "phys" mappings in the "Low Kernel Mapping" area and the "virt"
> > mappings in the "EFI Runtime Services" area. Now reboot with "noefi"
> > and see those be gone.
> 
> You need to show me - I don't see them here, in my guest.

I thought I did so in my previous emails when showing you the content of
my /sys/kernel/debug/kernel_page_tables file. I even highlighted the EFI
mappings in your dumps -- wrongly labeled as "ESPfix Area". But see
below...

> 
> > Well, beside the debugfs file is always using init_level4_pgt, reality
> > shows the EFI mappings are visible there, too. So why omit them?
> 
> Again, you need to show me - I don't see any EFI mappings in my setup
> here when cat-ting /sys/kernel/debug/kernel_page_tables
> 

Three prerequisites:

1/ Have you applied the patch marking the EFI mappings as "EFI Runtime
   Services"? If not, they will be hidden behind the "ESPfix Area".
2/ Is the guest you've run your tests on EFI enabled? If not, you wont
   see any EFI mappings.
3/ Did you put "noefi" in your kernel command line? If so, no mappings
   either.

After checking the above, the "EFI Runtime Services" area should contain
a few rwx EFI mappings.

> > Well, maybe I got it all wrong and there should be no EFI mappings in
> > the kernel page table at all? If so, how about fixing
> > kernel_map_pages_in_pgd() to not do so? It's you're code after all...
> > ;)
> 
> Well, if you can show me where kernel_map_pages_in_pgd() is called with
> init_level4_pgt as a first argument, I'd gladly fix it.

It's not. But that's not the point. It's the sharing of pgd hierarchies
of trampoline_pgd with init_level4_pgt I've explained above that makes
mappings in the former apply to the latter as well.

> 
> The 3 calls to it in 3.17 are all in efi_64.c and everytime it is
> real_mode_header->trampoline_pgd that gets handed down:
> 
> arch/x86/platform/efi/efi_64.c:161:     if (kernel_map_pages_in_pgd(pgd, pa_memmap, pa_memmap, num_pages, _PAGE_NX)) {
> arch/x86/platform/efi/efi_64.c:187:     if (kernel_map_pages_in_pgd(pgd, text >> PAGE_SHIFT, text, npages, 0)) {
> arch/x86/platform/efi/efi_64.c:210:     if (kernel_map_pages_in_pgd(pgd, md->phys_addr, va, md->num_pages, pf))
> 
> So show me please what exactly you're seeing.

I see the EFI mappings in the kernel address space, i.e. through
init_level4_pgt. As those are rwx, they can easily be greped for.

Compare this (EFI enabled qemu system)..:

bbox:~# grep -e '---\|RW.*x' /sys/kernel/debug/kernel_page_tables
---[ User Space ]---
---[ Kernel Space ]---
---[ Low Kernel Mapping ]---
0xffff880000800000-0xffff880001000000           8M     RW         PSE GLB x  pmd
0xffff880001800000-0xffff880001a00000           2M     RW         PSE GLB x  pmd
0xffff880001a00000-0xffff880001a74000         464K     RW             GLB x  pte
0xffff88001c000000-0xffff88001c020000         128K     RW             GLB x  pte
0xffff88001e061000-0xffff88001e25e000        2036K     RW             GLB x  pte
0xffff88001e25e000-0xffff88001e27d000         124K     RW                 x  pte
0xffff88001e27d000-0xffff88001e280000          12K     RW             GLB x  pte
0xffff88001e280000-0xffff88001e3cf000        1340K     RW                 x  pte
0xffff88001e3cf000-0xffff88001e400000         196K     RW             GLB x  pte
0xffff88001e400000-0xffff88001e600000           2M     RW         PSE GLB x  pmd
0xffff88001e600000-0xffff88001e7e1000        1924K     RW             GLB x  pte
0xffff88001e7e1000-0xffff88001e7ea000          36K     RW                 x  pte
0xffff88001e7ea000-0xffff88001e905000        1132K     RW             GLB x  pte
0xffff88001e905000-0xffff88001e906000           4K     RW                 x  pte
0xffff88001e906000-0xffff88001e907000           4K     RW             GLB x  pte
0xffff88001e907000-0xffff88001e908000           4K     RW                 x  pte
0xffff88001e908000-0xffff88001e928000         128K     RW             GLB x  pte
0xffff88001e928000-0xffff88001e929000           4K     RW                 x  pte
0xffff88001e929000-0xffff88001ea00000         860K     RW             GLB x  pte
0xffff88001ea00000-0xffff88001f800000          14M     RW         PSE GLB x  pmd
0xffff88001f800000-0xffff88001fa11000        2116K     RW             GLB x  pte
0xffff88001fa11000-0xffff88001fa65000         336K     RW                 x  pte
0xffff88001fa75000-0xffff88001fc00000        1580K     RW             GLB x  pte
0xffff88001fc00000-0xffff88001fe00000           2M     RW         PSE GLB x  pmd
0xffff88001fe00000-0xffff88001ffd0000        1856K     RW             GLB x  pte
0xffff88001ffd0000-0xffff880020000000         192K     RW                 x  pte
---[ vmalloc() Area ]---
---[ Vmemmap ]---
---[ ESPfix Area ]---
---[ EFI Runtime Services ]---
0xfffffffef93d0000-0xfffffffef9400000         192K     RW                 x  pte
0xfffffffef9475000-0xfffffffef9600000        1580K     RW                 x  pte
0xfffffffef9600000-0xfffffffef9800000           2M     RW         PSE     x  pmd
0xfffffffef9800000-0xfffffffef99d0000        1856K     RW                 x  pte
0xfffffffef9a41000-0xfffffffef9a65000         144K     RW                 x  pte
0xfffffffef9c11000-0xfffffffef9c41000         192K     RW                 x  pte
0xfffffffef9c91000-0xfffffffef9e11000        1536K     RW                 x  pte
0xfffffffef9f29000-0xfffffffefa000000         860K     RW                 x  pte
0xfffffffefa000000-0xfffffffefae00000          14M     RW         PSE     x  pmd
0xfffffffefae00000-0xfffffffefae91000         580K     RW                 x  pte
0xfffffffefaf28000-0xfffffffefaf29000           4K     RW                 x  pte
0xfffffffefb108000-0xfffffffefb128000         128K     RW                 x  pte
0xfffffffefb307000-0xfffffffefb308000           4K     RW                 x  pte
0xfffffffefb506000-0xfffffffefb507000           4K     RW                 x  pte
0xfffffffefb705000-0xfffffffefb706000           4K     RW                 x  pte
0xfffffffefb807000-0xfffffffefb905000        1016K     RW                 x  pte
0xfffffffefba05000-0xfffffffefba07000           8K     RW                 x  pte
0xfffffffefbbea000-0xfffffffefbc05000         108K     RW                 x  pte
0xfffffffefbde1000-0xfffffffefbdea000          36K     RW                 x  pte
0xfffffffefbfcf000-0xfffffffefc000000         196K     RW                 x  pte
0xfffffffefc000000-0xfffffffefc200000           2M     RW         PSE     x  pmd
0xfffffffefc200000-0xfffffffefc3e1000        1924K     RW                 x  pte
0xfffffffefc526000-0xfffffffefc5cf000         676K     RW                 x  pte
0xfffffffefc680000-0xfffffffefc726000         664K     RW                 x  pte
0xfffffffefc87d000-0xfffffffefc880000          12K     RW                 x  pte
0xfffffffefca5e000-0xfffffffefca7d000         124K     RW                 x  pte
0xfffffffefcc37000-0xfffffffefcc5e000         156K     RW                 x  pte
0xfffffffefce34000-0xfffffffefce37000          12K     RW                 x  pte
0xfffffffefd02e000-0xfffffffefd034000          24K     RW                 x  pte
0xfffffffefd22c000-0xfffffffefd22e000           8K     RW                 x  pte
0xfffffffefd42a000-0xfffffffefd42c000           8K     RW                 x  pte
0xfffffffefd628000-0xfffffffefd62a000           8K     RW                 x  pte
0xfffffffefd815000-0xfffffffefd828000          76K     RW                 x  pte
0xfffffffefda12000-0xfffffffefda15000          12K     RW                 x  pte
0xfffffffefdc0e000-0xfffffffefdc12000          16K     RW                 x  pte
0xfffffffefde0d000-0xfffffffefde0e000           4K     RW                 x  pte
0xfffffffefdfe9000-0xfffffffefe00d000         144K     RW                 x  pte
0xfffffffefe1e7000-0xfffffffefe1e9000           8K     RW                 x  pte
0xfffffffefe3e0000-0xfffffffefe3e7000          28K     RW                 x  pte
0xfffffffefe5df000-0xfffffffefe5e0000           4K     RW                 x  pte
0xfffffffefe7ce000-0xfffffffefe7df000          68K     RW                 x  pte
0xfffffffefe9cd000-0xfffffffefe9ce000           4K     RW                 x  pte
0xfffffffefebb8000-0xfffffffefebcd000          84K     RW                 x  pte
0xfffffffefedb6000-0xfffffffefedb8000           8K     RW                 x  pte
0xfffffffefefb0000-0xfffffffefefb6000          24K     RW                 x  pte
0xfffffffeff1a6000-0xfffffffeff1b0000          40K     RW                 x  pte
0xfffffffeff2de000-0xfffffffeff3a6000         800K     RW                 x  pte
0xfffffffeff461000-0xfffffffeff4de000         500K     RW                 x  pte
0xfffffffeff600000-0xfffffffeff620000         128K     RW                 x  pte
0xfffffffeff800000-0xffffffff00000000           8M     RW         PSE     x  pmd
---[ High Kernel Mapping ]---
0xffffffff81a74000-0xffffffff81c00000        1584K     RW             GLB x  pte
---[ Modules ]---
---[ End Modules ]---

..with that (same system booted with "noefi"):

bbox:~# grep -e '---\|RW.*x' /sys/kernel/debug/kernel_page_tables
---[ User Space ]---
---[ Kernel Space ]---
---[ Low Kernel Mapping ]---
---[ vmalloc() Area ]---
---[ Vmemmap ]---
---[ ESPfix Area ]---
---[ EFI Runtime Services ]---
---[ High Kernel Mapping ]---
0xffffffff81a74000-0xffffffff81c00000        1584K     RW             GLB x  pte
---[ Modules ]---
---[ End Modules ]---

The first grep shows the physical EFI mappings in the "Low Kernel
Mapping" area and the virtual ones in the "EFI Runtime Services" area.
The second grep has none as the EFI runtime services are disabled in
this case -- no EFI memory regions will be (re)mapped.

The writable mapping in the "High Kernel Mapping" for both dumps is
probably the heap as it starts right after __brk_limit -- so not EFI
related, probably just another bug ;)


Regards,
Mathias

> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
