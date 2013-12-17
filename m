Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab3LQMKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 07:10:33 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:48736 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751090Ab3LQMKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 07:10:31 -0500
Date: Tue, 17 Dec 2013 12:10:24 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Toshi Kani <toshi.kani@hp.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 3/3] efi: Make efi virtual runtime map passing more robust
Message-ID: <20131217121024.GB3145@console-pimps.org>
References: <1387236997-26975-1-git-send-email-bp@alien8.de>
 <1387236997-26975-4-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1387236997-26975-4-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Dec, at 12:36:37AM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Currently, running SetVirtualAddressMap() and passing the physical
> address of the virtual map array was working only by a lucky coincidence
> because the memory was present in the EFI page table too. Until Toshi
> went and booted this on a big HP box - the krealloc() manner of resizing
> the memmap we're doing did allocate from such physical addresses which
> were not mapped anymore and boom:
> 
> http://lkml.kernel.org/r/1386806463.1791.295.camel@misato.fc.hp.com
> 
> One way to take care of that issue is to reimplement the krealloc thing
> but with pages. We start with contiguous pages of order 1, i.e. 2 pages,
> and when we deplete that memory (shouldn't happen all that often but you
> know firmware) we realloc the next power-of-two pages.
> 
> Having the pages, it is much more handy and easy to map them into the
> EFI page table with the already existing mapping code which we're using
> for building the virtual mappings.
> 
> And, it doesn't matter all that much how much pages we've used as we're
> freeing them right after they've fulfilled their purpose at the end of
> the function anyway.
> 
> Reported-by: Toshi Kani <toshi.kani@hp.com>
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/platform/efi/efi.c | 57 ++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 48 insertions(+), 9 deletions(-)

[...]

> @@ -794,12 +814,13 @@ void __init old_map_region(efi_memory_desc_t *md)
>   */
>  void __init efi_enter_virtual_mode(void)
>  {
> +	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
> +	unsigned long size, new_memmap_left = 0;
>  	efi_memory_desc_t *md, *prev_md = NULL;
> +	int count = 0, new_memmap_shift = 0;
>  	void *p, *new_memmap = NULL;
> -	unsigned long size;
>  	efi_status_t status;
>  	u64 end, systab;
> -	int count = 0;
>  
>  	efi.systab = NULL;

You sunk my i386 battleship,

/home/build/git/efi/arch/x86/platform/efi/efi.c:824:24: error: ‘struct real_mode_header’ has no member named ‘trampoline_pgd’
make[4]: *** [arch/x86/platform/efi/efi.o] Error 1
make[3]: *** [arch/x86/platform/efi] Error 2

-- 
Matt Fleming, Intel Open Source Technology Center
