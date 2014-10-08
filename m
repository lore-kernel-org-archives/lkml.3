Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbaJHW0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:26:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34203 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754453AbaJHW01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:26:27 -0400
Date: Thu, 9 Oct 2014 00:26:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mathias Krause <minipli@googlemail.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        x86-ml <x86@kernel.org>, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCHv2 1/3] x86, ptdump: Add section for EFI runtime services
Message-ID: <20141008222619.GG16892@pd.tnic>
References: <1411313216-2641-1-git-send-email-minipli@googlemail.com>
 <1411313216-2641-2-git-send-email-minipli@googlemail.com>
 <20141003134707.GJ14343@console-pimps.org>
 <20141007150132.GA7307@nazgul.tnic>
 <20141007170748.GA25767@jig.fritz.box>
 <20141008151730.GB16892@pd.tnic>
 <CA+rthh_Q0HQfLX6P3kcuOUwggjSnhYGCc5YJNOn0UCCRPZbaxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+rthh_Q0HQfLX6P3kcuOUwggjSnhYGCc5YJNOn0UCCRPZbaxA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 11:58:20PM +0200, Mathias Krause wrote:
> Well, that is only partly correct. The call chain in efi_map_regions()
> [ -> efi_map_region() -> __map_region() -> kernel_map_pages_in_pgd()
> -> ..."magic"... ] does not only map the EFI regions in
> trampoline_pgd, but also in kernel page table, i.e. init_level4_pgt.

No, this is completely correct. If it isn't, then it needs to be. We
can't have EFI mappings in the kernel page table for a reason.

EFI mappings only land in trampoline_pgd, not in the kernel page table,
.i.e *not* in init_level4_pgt. Look at what the first argument of every
invocation of kernel_map_pages_in_pgd() is.

> That can easily be shown by looking at the kernel_page_tables debugfs
> file on a running system. You'll notice large RWX portions covering
> the "phys" mappings in the "Low Kernel Mapping" area and the "virt"
> mappings in the "EFI Runtime Services" area. Now reboot with "noefi"
> and see those be gone.

You need to show me - I don't see them here, in my guest.

> Well, beside the debugfs file is always using init_level4_pgt, reality
> shows the EFI mappings are visible there, too. So why omit them?

Again, you need to show me - I don't see any EFI mappings in my setup
here when cat-ting /sys/kernel/debug/kernel_page_tables

> Well, maybe I got it all wrong and there should be no EFI mappings in
> the kernel page table at all? If so, how about fixing
> kernel_map_pages_in_pgd() to not do so? It's you're code after all...
> ;)

Well, if you can show me where kernel_map_pages_in_pgd() is called with
init_level4_pgt as a first argument, I'd gladly fix it.

The 3 calls to it in 3.17 are all in efi_64.c and everytime it is
real_mode_header->trampoline_pgd that gets handed down:

arch/x86/platform/efi/efi_64.c:161:     if (kernel_map_pages_in_pgd(pgd, pa_memmap, pa_memmap, num_pages, _PAGE_NX)) {
arch/x86/platform/efi/efi_64.c:187:     if (kernel_map_pages_in_pgd(pgd, text >> PAGE_SHIFT, text, npages, 0)) {
arch/x86/platform/efi/efi_64.c:210:     if (kernel_map_pages_in_pgd(pgd, md->phys_addr, va, md->num_pages, pf))

So show me please what exactly you're seeing.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
