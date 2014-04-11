Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbaDKHUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 03:20:51 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:36386 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbaDKHUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 03:20:49 -0400
Date: Fri, 11 Apr 2014 09:20:44 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Koen Kooi <koen@dominion.thruhere.net>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: "54b52d87268034859191d671505bb1cfce6bd74d - x86/efi: Build our
 own EFI services pointer table" breaks boot on thinkpad t440s
Message-ID: <20140411072044.GA15418@gmail.com>
References: <AF4406ED-6B0B-4E15-A329-04162E0ADC8A@dominion.thruhere.net>
 <20140410121146.GA17021@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410121146.GA17021@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Fleming <matt@console-pimps.org> wrote:

> On Thu, 10 Apr, at 12:43:43PM, Koen Kooi wrote:
> > Hi,
> > 
> > After updating from 3.14-rc7 to a recent git the kernel fails to boot on my thinkpad t440s and displays:
> > 
> > 	Failed to get file info size
> > 	Failed to alloc highmem for files
> > 
> > After a morning of running git bisect and rebooting, the bad commit seems to be:
> > 
> > 	54b52d87268034859191d671505bb1cfce6bd74d - x86/efi: Build our own EFI services pointer table
> 
> Thanks for the report. Can you try this patch against Linus' tree?
> 
> 
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index 1e6146137f8e..280165524ee4 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -112,7 +112,7 @@ __file_size64(void *__fh, efi_char16_t *filename_16,
>  	efi_file_info_t *info;
>  	efi_status_t status;
>  	efi_guid_t info_guid = EFI_FILE_INFO_ID;
> -	u32 info_sz;
> +	u64 info_sz;

Might be prudent to do the same in __file_size32(), instead of 
truncating silently, especially is that function too has a u64 output 
AFAICS.

Also, while reviewing the file I noticed that there's "u32 fb_base", 
which is recovered like:

                status = __gop_query64(gop64, &info, &size, &fb_base);

but ->frame_buffer_base is u64. Is it always guaranteed u32?

Thanks,

	Ingo
