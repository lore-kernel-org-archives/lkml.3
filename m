Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbaFIMyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 08:54:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbaFIMyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 08:54:32 -0400
Date: Mon, 9 Jun 2014 08:54:27 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH] x86/boot: EFI_MIXED should not prohibit loading above 4G
Message-ID: <20140609125427.GA16256@redhat.com>
References: <1402140380-15377-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402140380-15377-1-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 07, 2014 at 12:26:20PM +0100, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> commit 7d453eee36ae ("x86/efi: Wire up CONFIG_EFI_MIXED") introduced a
> regression for the functionality to load kernels above 4G. The relevant
> (incorrect) reasoning behind this change can be seen in the commit
> message,
> 
>   "The xloadflags field in the bzImage header is also updated to reflect
>   that the kernel supports both entry points by setting both of
>   XLF_EFI_HANDOVER_32 and XLF_EFI_HANDOVER_64 when CONFIG_EFI_MIXED=y.
>   XLF_CAN_BE_LOADED_ABOVE_4G is disabled so that the kernel text is
>   guaranteed to be addressable with 32-bits."
> 
> This is obviously bogus since 32-bit EFI loaders will never place the
> kernel above the 4G mark. So this restriction is entirely unnecessary.

Hi Matt,

So with new kexec syscall I have written 64bit bzImage loader. For now
I would like to detect this situation and disable loading and once
32bit loader gets implemented it can take care of loading bzImage below
4G.

So how do I find out if EFI is 32bit.

Thanks
Vivek

> 
> But things are worse than that - since we want to encourage people to
> always compile with CONFIG_EFI_MIXED=y so that their kernels work out of
> the box for both 32-bit and 64-bit firmware, commit 7d453eee36ae
> effectively disables XLF_CAN_BE_LOADED_ABOVE_4G completely.
> 
> Remove the overzealous and superfluous restriction and restore the
> XLF_CAN_BE_LOADED_ABOVE_4G functionality.
> 
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Dave Young <dyoung@redhat.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
> 
> Peter, I realise that we're right on the edge of the v3.15 release here,
> so this probably needs marking for stable (it only affects v3.15).
> 
>  arch/x86/boot/header.S | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
> index 0ca9a5c362bc..84c223479e3c 100644
> --- a/arch/x86/boot/header.S
> +++ b/arch/x86/boot/header.S
> @@ -375,8 +375,7 @@ xloadflags:
>  # define XLF0 0
>  #endif
>  
> -#if defined(CONFIG_RELOCATABLE) && defined(CONFIG_X86_64) && \
> -	!defined(CONFIG_EFI_MIXED)
> +#if defined(CONFIG_RELOCATABLE) && defined(CONFIG_X86_64)
>     /* kernel/boot_param/ramdisk could be loaded above 4g */
>  # define XLF1 XLF_CAN_BE_LOADED_ABOVE_4G
>  #else
> -- 
> 1.9.0
