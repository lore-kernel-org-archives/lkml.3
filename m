Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbbATNGy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:06:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449AbbATNGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:06:52 -0500
Date: Tue, 20 Jan 2015 21:04:57 +0800
From: Baoquan He <bhe@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Jan Beulich <JBeulich@suse.com>, Junjie Mao <eternal.n08@gmail.com>,
        Andi Kleen <ak@linux.intel.com>, "Thomas D." <whissi@whissi.de>
Subject: Re: [PATCH] x86, boot: skip relocs when load address unchanged
Message-ID: <20150120130457.GG2461@dhcp-16-105.nay.redhat.com>
References: <20150116005146.GA4212@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150116005146.GA4212@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/15 at 04:51pm, Kees Cook wrote:
> On 64-bit, relocation is not required unless the load address gets
> changed. Without this, relocations do unexpected things when the kernel
> is above 4G.

This patch works for me. And good to see it's being merged. About the
patch log, I would say relocations do unexpected things when the kernel
is above 1G since randomization is done from 16M to 1G, namely
CONFIG_RANDOMIZE_BASE_MAX_OFFSET. So above 1G kernel text mapping will
step into kernel module mapping region.

BTW, I am working on separate randomization of kernel physical and virtual
address , will post it. But it won't conflict with this because I don't
think it can be accepted in a short time. Before that this patch truly
fix the kexec/kdump bug when kaslr is compiled in.

Thanks
Baoquan

> 
> Reported-by: Baoquan He <bhe@redhat.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: stable@vger.kernel.org
> ---
> This is a reimplementation of Baoquan's "kaslr: check if kernel location is
> changed", which performs the check without needing to change the function
> declaration. This should have exactly the same effect, but I dropped Vivek's
> Ack and Thomas's Test, since it's technically a different patch.
> ---
>  arch/x86/boot/compressed/misc.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
> index dcc1c536cc21..a950864a64da 100644
> --- a/arch/x86/boot/compressed/misc.c
> +++ b/arch/x86/boot/compressed/misc.c
> @@ -373,6 +373,8 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
>  				  unsigned long output_len,
>  				  unsigned long run_size)
>  {
> +	unsigned char *output_orig = output;
> +
>  	real_mode = rmode;
>  
>  	sanitize_boot_params(real_mode);
> @@ -421,7 +423,12 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
>  	debug_putstr("\nDecompressing Linux... ");
>  	decompress(input_data, input_len, NULL, NULL, output, NULL, error);
>  	parse_elf(output);
> -	handle_relocations(output, output_len);
> +	/*
> +	 * 32-bit always performs relocations. 64-bit relocations are only
> +	 * needed if kASLR has chosen a different load address.
> +	 */
> +	if (!IS_ENABLED(CONFIG_X86_64) || output != output_orig)
> +		handle_relocations(output, output_len);
>  	debug_putstr("done.\nBooting the kernel.\n");
>  	return output;
>  }
> -- 
> 1.9.1
> 
> 
> -- 
> Kees Cook
> Chrome OS Security
