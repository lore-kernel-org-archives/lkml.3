Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbaJaRTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:19:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:35554 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaJaRT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:19:29 -0400
Message-ID: <5453C49A.2000500@infradead.org>
Date: Fri, 31 Oct 2014 10:19:22 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Junjie Mao <eternal.n08@gmail.com>
Subject: Re: [PATCH] x86, boot: add hex output for debugging
References: <20141031162037.GA26233@www.outflux.net>
In-Reply-To: <20141031162037.GA26233@www.outflux.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/14 09:20, Kees Cook wrote:
> This is useful for reporting various addresses or other values while
> debugging early boot.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/x86/boot/compressed/misc.c | 19 +++++++++++++++++++
>  arch/x86/boot/compressed/misc.h |  5 +++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
> index 30dd59a9f0b4..1b105664f720 100644
> --- a/arch/x86/boot/compressed/misc.c
> +++ b/arch/x86/boot/compressed/misc.c
> @@ -220,6 +220,25 @@ void __putstr(const char *s)
>  	outb(0xff & (pos >> 1), vidport+1);
>  }
>  
> +void __puthex(unsigned long value)
> +{
> +	char alpha[2] = "0";
> +	int bits;
> +	unsigned char byte;

what is 'byte' for?  (unused)

> +
> +	__putstr("0x");
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
> diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
> index 24e3e569a13c..6056d339fb17 100644
> --- a/arch/x86/boot/compressed/misc.h
> +++ b/arch/x86/boot/compressed/misc.h
> @@ -34,16 +34,21 @@ extern memptr free_mem_ptr;
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
>  
>  #else
>  
>  static inline void debug_putstr(const char *s)
>  { }
> +static inline void debug_puthex(const char *s)
> +{ }
>  
>  #endif
>  
> 


-- 
~Randy
