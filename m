Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab3KKU5z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 15:57:55 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:50277 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab3KKU5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 15:57:47 -0500
Date: Mon, 11 Nov 2013 21:57:43 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org
Subject: Re: [PATCH] x86, kaslr: mix entropy sources together as needed
Message-ID: <20131111205743.GF18886@gmail.com>
References: <20131111204853.GA24459@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111204853.GA24459@www.outflux.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kees Cook <keescook@chromium.org> wrote:

> Depending on availability, mix the RDRAND and RDTSC entropy together with
> XOR. Only when neither is available should the i8254 be used. Update
> the Kconfig documentation to reflect this. Additionally, since bits
> used for entropy is masked elsewhere, drop the needless masking in the
> get_random_long().
> 
> Finally, to improve the starting entropy, do a simple hashing of the
> boot_params structure for some additional level of unpredictability.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/x86/Kconfig                |   14 +++++++----
>  arch/x86/boot/compressed/aslr.c |   52 ++++++++++++++++++++++++++++-----------
>  2 files changed, 46 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index ee3b38363063..119455802d57 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1736,13 +1736,17 @@ config RANDOMIZE_BASE
>  	   deters exploit attempts relying on knowledge of the location
>  	   of kernel internals.
>  
> +	   Entropy is generated using the RDRAND instruction if it is
> +	   supported. If RDTSC is supported, it is used as well. If
> +	   neither RDRAND nor RDTSC are supported, then randomness is
> +	   read from the i8254 timer.
>  
>  	   The kernel will be offset by up to RANDOMIZE_BASE_MAX_OFFSET,
> +	   and aligned according to PHYSICAL_ALIGN. Since the kernel is
> +	   built using 2GiB addressing, and PHYSICAL_ALGIN must be at a
> +	   minimum of 2MiB, only 10 bits of entropy is theoretically
> +	   possible. At best, due to page table layouts, 64-bit can use
> +	   9 bits of entropy and 32-bit uses 8 bits.

Perfect!

> +/* Simple way to create an alternate starting entropy. */
> +static unsigned long get_boot_hash(void)

s/get_random_boot, signifying that we want to get some initial randomness?

Btw., could we also add some build build time source of randomness as 
well? That won't help distro kernels which all share the same build but it 
would be a nice touch for self-built kernels and Gentoo systems.

> +{
> +	int i;
> +	unsigned long hash = 0;
> +	unsigned long *ptr = (unsigned long *)real_mode;
> +
> +	for (i = 0; i < sizeof(*real_mode) / sizeof(hash); i++) {
> +		/* Rotate and XOR */
> +		hash = (hash << ((sizeof(hash) - 1) * 8)) | (hash >> 8);
> +		hash ^= ptr[i];
> +	}
> +
> +	return hash;

Looks mostly good, but I'm too tired to ack this bit now, maybe hpa will 
have a look :-)

> +}
> +
>  static unsigned long get_random_long(void)
>  {
> +	unsigned long random = get_boot_hash();
> +	bool use_i8254 = true;
> +
> +	debug_putstr("KASLR using");
>  
>  	if (has_cpuflag(X86_FEATURE_RDRAND)) {
> +		unsigned long raw;
> +
> +		debug_putstr(" RDRAND");
> +		if (rdrand_long(&raw)) {
> +			random ^= raw;
> +			use_i8254 = false;
> +		}
>  	}
>  
>  	if (has_cpuflag(X86_FEATURE_TSC)) {
>  		uint32_t raw;
>  
> +		debug_putstr(" RDTSC");
>  		rdtscl(raw);
>  
> +		random ^= raw;
> +		use_i8254 = false;

The TSC is 64-bits. The high bits will most likely be 0, but just in case 
there's some dirt up there or BIOS bootup takes more than 4G cycles we 
might as well use the high portion as well!

>  	}
>  
> +	if (use_i8254) {
> +		debug_putstr(" i8254");
> +		random ^= i8254();
> +	}
> +
> +	debug_putstr("...\n");
> +
>  	return random;
>  }

Looks good otherwise.

Thanks,

	Ingo
