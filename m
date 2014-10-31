Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbaJaVeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 17:34:46 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:40973 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758927AbaJaVeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 17:34:44 -0400
Message-ID: <54540071.30408@amacapital.net>
Date: Fri, 31 Oct 2014 14:34:41 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Josh Triplett <josh@joshtriplett.org>,
        Junjie Mao <eternal.n08@gmail.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v2] x86, boot: add hex output for debugging
References: <20141031205819.GA13262@www.outflux.net>
In-Reply-To: <20141031205819.GA13262@www.outflux.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2014 01:58 PM, Kees Cook wrote:
> This is useful for reporting various addresses or other values while
> debugging early boot. For example, when CONFIG_X86_VERBOSE_BOOTUP is set,
> this is now visible at boot time:
> 
> 	early console in setup code
> 	early console in decompress_kernel
> 	input_data: 0x0000000001e1526e
> 	input_len: 0x0000000000732236
> 	output: 0x0000000001000000
> 	output_len: 0x0000000001535640
> 	run_size: 0x00000000021fb000
> 	KASLR using RDTSC...
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> Since this displays run_size, this patch depends on Junjie Mao's patch
> "x86, kaslr: Prevent .bss from overlaping initrd"
> 

This reminds me: I have a patch to add an early-boot IDT that can report
#GP and #PF in this code if CONFIG_X86_VERBOSE_BOOTUP is set.  I can
dust it off if anyone thinks it'll be useful, even though I won't end up
needed it for the thing I wrote it for.

--Andy

> ---
>  arch/x86/boot/compressed/misc.c | 24 ++++++++++++++++++++++++
>  arch/x86/boot/compressed/misc.h | 11 +++++++++++
>  2 files changed, 35 insertions(+)
> 
> diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
> index 30dd59a9f0b4..2aefc8a63655 100644
> --- a/arch/x86/boot/compressed/misc.c
> +++ b/arch/x86/boot/compressed/misc.c
> @@ -220,6 +220,23 @@ void __putstr(const char *s)
>  	outb(0xff & (pos >> 1), vidport+1);
>  }
>  
> +void __puthex(unsigned long value)
> +{
> +	char alpha[2] = "0";
> +	int bits;
> +
> +	for (bits = sizeof(value) * 8 - 4; bits >= 0; bits -= 4) {
> +		unsigned long digit = (value >> bits) & 0xf;
> +
> +		if (digit < 0xA)
> +			alpha[0] = '0' + digit;
> +		else
> +			alpha[0] = 'a' + (digit - 0xA);
> +
> +		__putstr(alpha);
> +	}
> +}
> +
>  static void error(char *x)
>  {
>  	error_putstr("\n\n");
> @@ -382,6 +399,13 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
>  	free_mem_ptr     = heap;	/* Heap */
>  	free_mem_end_ptr = heap + BOOT_HEAP_SIZE;
>  
> +	/* Report initial kernel position details. */
> +	debug_putaddr(input_data);
> +	debug_putaddr(input_len);
> +	debug_putaddr(output);
> +	debug_putaddr(output_len);
> +	debug_putaddr(run_size);
> +
>  	/*
>  	 * The memory hole needed for the kernel is the larger of either
>  	 * the entire decompressed kernel plus relocation table, or the
> diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
> index 24e3e569a13c..70472ae98a73 100644
> --- a/arch/x86/boot/compressed/misc.h
> +++ b/arch/x86/boot/compressed/misc.h
> @@ -34,16 +34,27 @@ extern memptr free_mem_ptr;
>  extern memptr free_mem_end_ptr;
>  extern struct boot_params *real_mode;		/* Pointer to real-mode data */
>  void __putstr(const char *s);
> +void __puthex(unsigned long value);
>  #define error_putstr(__x)  __putstr(__x)
> +#define error_puthex(__x)  __puthex(__x)
>  
>  #ifdef CONFIG_X86_VERBOSE_BOOTUP
>  
>  #define debug_putstr(__x)  __putstr(__x)
> +#define debug_puthex(__x)  __puthex(__x)
> +#define debug_putaddr(__x) { \
> +		debug_putstr(#__x ": 0x"); \
> +		debug_puthex((unsigned long)(__x)); \
> +		debug_putstr("\n"); \
> +	}
>  
>  #else
>  
>  static inline void debug_putstr(const char *s)
>  { }
> +static inline void debug_puthex(const char *s)
> +{ }
> +#define debug_putaddr(x) /* */
>  
>  #endif
>  
> 

