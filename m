Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab3KDKhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 05:37:47 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:50987 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718Ab3KDKhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 05:37:46 -0500
Date: Mon, 4 Nov 2013 10:37:39 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Dave Young <dyoung@redhat.com>
Cc: matt.fleming@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] efi earlyprintk fix
Message-ID: <20131104103739.GD21688@console-pimps.org>
References: <20131103121647.GA4770@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131103121647.GA4770@dhcp-16-126.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 03 Nov, at 08:16:47PM, Dave Young wrote:
> 
> there's below one line shift problem:
> 
>                      ACPI=0xdabfe000  ACPI 2.0=0xdabfe014  SMBIOS=0xdaa9e000
> [    0.000000] efi:  
> 
> In fact check efi_y and the lfb_height should be compared at the begin of the
> loop of early_efi_write
 
Hmm... this is interesting. I can't produce this on any of my machines.
Where did you see this? What hardware?

> Signed-off-by: Dave Young <dyoung@redhat.com>
> ---
>  arch/x86/platform/efi/early_printk.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.orig/arch/x86/platform/efi/early_printk.c
> +++ linux-2.6/arch/x86/platform/efi/early_printk.c
> @@ -106,6 +106,15 @@ early_efi_write(struct console *con, con
>  		if (count > linemax)
>  			count = linemax;
>  
> +		if (efi_y + font->height >= si->lfb_height) {
> +			u32 i;
> +
> +			efi_y -= font->height;
> +			early_efi_scroll_up();
> +
> +			for (i = 0; i < font->height; i++)
> +				early_efi_clear_scanline(efi_y + i);
> +		}
>  		for (h = 0; h < font->height; h++) {
>  			unsigned int n, x;
>  
> @@ -142,15 +151,6 @@ early_efi_write(struct console *con, con
>  			efi_y += font->height;
>  		}
>  
> -		if (efi_y + font->height >= si->lfb_height) {
> -			u32 i;
> -
> -			efi_y -= font->height;
> -			early_efi_scroll_up();
> -
> -			for (i = 0; i < font->height; i++)
> -				early_efi_clear_scanline(efi_y + i);
> -		}
>  	}
>  }

Notice how we figure out the initial value of efi_y...

static __init int early_efi_setup(struct console *con, char *options)
{
	struct screen_info *si;
	u16 xres, yres;
	u32 i;

	si = &boot_params.screen_info;
	xres = si->lfb_width;
	yres = si->lfb_height;

	....

	efi_y = rounddown(yres, font->height) - font->height;

Every time we enter early_efi_write(), we should have enough space to
write one line, so I'm not at all sure what's going wrong with your
display.

-- 
Matt Fleming, Intel Open Source Technology Center
