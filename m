Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab3J1LWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 07:22:54 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:56009 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751635Ab3J1LWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 07:22:52 -0400
Date: Mon, 28 Oct 2013 11:22:46 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
        linux-efi@vger.kernel.org, fwts-devel@lists.ubuntu.com
Subject: Re: [PATCH 12/12] EFI: Runtime services virtual mapping
Message-ID: <20131028112246.GK1982@console-pimps.org>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20131008164551.GB16793@pd.tnic>
 <20131008164831.GD16793@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008164831.GD16793@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Oct, at 06:48:31PM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> We map the EFI regions needed for runtime services contiguously on
> virtual addresses starting from -4G down for a total max space of 64G.
> This way, we provide for stable runtime services addresses across
> kernels so that a kexec'd kernel can still use them.
> 
> This way, they're mapped in a separate pagetable so that we don't
> pollute the kernel namespace (you can see how the whole ioremapping and
> saving and restoring of PGDs is gone now).
> 
> Also, add a chicken bit called "efi=old_map" which can be used as a
> fallback to the old runtime services mapping method in case there's some
> b0rkage with a particular EFI implementation (haha, it is hard to hold
> up the sarcasm here...).
> 
> Add UEFI RT VA space to Documentation/x86/x86_64/mm.txt, while at it.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  Documentation/x86/x86_64/mm.txt      |  7 +++
>  arch/x86/include/asm/efi.h           | 47 ++++++++++++-------
>  arch/x86/include/asm/pgtable_types.h |  3 +-
>  arch/x86/platform/efi/efi.c          | 91 ++++++++++++++++++++++++++----------
>  arch/x86/platform/efi/efi_32.c       |  8 +++-
>  arch/x86/platform/efi/efi_64.c       | 83 ++++++++++++++++++++++++++++++++
>  arch/x86/platform/efi/efi_stub_64.S  | 54 +++++++++++++++++++++
>  include/linux/efi.h                  |  1 +
>  8 files changed, 251 insertions(+), 43 deletions(-)

[...]

> @@ -949,8 +978,17 @@ void __init efi_enter_virtual_mode(void)
>  		count++;
>  	}
>  
> +#ifdef CONFIG_X86_64
> +	efi_scratch.efi_pgt = (pgd_t *)(unsigned long)real_mode_header->trampoline_pgd;
> +
> +	if (!test_bit(EFI_OLD_MEMMAP, &x86_efi_facility))
> +		efi_scratch.use_pgd = true;
> +#endif
> +
>  	BUG_ON(!efi.systab);

Could you use the efi_enabled() function to test for EFI_OLD_MEMMAP
instead of test_bit()?

[...]

> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index fa47d80ab4b5..beff433aa8c0 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -632,6 +632,7 @@ extern int __init efi_setup_pcdp_console(char *);
>  #define EFI_RUNTIME_SERVICES	3	/* Can we use runtime services? */
>  #define EFI_MEMMAP		4	/* Can we use EFI memory map? */
>  #define EFI_64BIT		5	/* Is the firmware 64-bit? */
> +#define EFI_OLD_MEMMAP		6	/* Use old mapping method */

Hmm... I'm wondering whether this should actually be,

#define EFI_ARCH_1		6	/* Architecture-specific option */

and in arch/x86/include/ we could then do,

/*
 * Lots of info about why we need to switch to a new mapping scheme, but
 * also why the old scheme might be desirable....
 */
#define EFI_OLD_MEMMAP		EFI_ARCH_1

This way we won't exhaust the bitspace quite so soon (since ARM/ARM64
can reuse EFI_ARCH_1 if they need it), plus this memory mapping method
is a very architecture-specific thing and so makes sense to hide it in
the bowels of arch/x86. If it turns out that ARM/ARM64 need the exact
same config option we can delete EFI_ARCH_1 and move EFI_OLD_MEMMAP to
include/linux/efi.h just like in your original patch. 

What do you think?

-- 
Matt Fleming, Intel Open Source Technology Center
