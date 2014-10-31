Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbaJaUdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:33:11 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:35752 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaJaUdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:33:10 -0400
Date: Fri, 31 Oct 2014 13:33:04 -0700
From: josh@joshtriplett.org
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Junjie Mao <eternal.n08@gmail.com>
Subject: Re: [PATCH] x86, boot: add hex output for debugging
Message-ID: <20141031203304.GA32697@cloud>
References: <20141031162037.GA26233@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031162037.GA26233@www.outflux.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 09:20:37AM -0700, Kees Cook wrote:
> This is useful for reporting various addresses or other values while
> debugging early boot.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

You haven't provided any user of this function.  I don't think this
should get merged without a caller (nor should an artificial caller be
added).  What's your use case for adding this?

Also, while I realize __putstr already has this problem, ideally all the
printing functions in this file should go in some separate source file
that gets omitted when !CONFIG_PRINTK (or possibly
!CONFIG_EARLY_PRINTK).

- Josh Triplett

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
> -- 
> 1.9.1
> 
> 
> -- 
> Kees Cook
> Chrome OS Security
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
