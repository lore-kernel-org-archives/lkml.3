Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaA3JJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 04:09:11 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:58322 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaA3JJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 04:09:07 -0500
Date: Thu, 30 Jan 2014 10:09:02 +0100
From: Ingo Molnar <mingo@kernel.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        keescook@chromium.org, tglx@linutronix.de, hpa@linux.intel.com,
        David.Woodhouse@intel.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/build] x86, boot: Fix word-size assumptions in
 has_eflag () inline asm
Message-ID: <20140130090902.GA2749@gmail.com>
References: <1390996897.20153.123.camel@i7.infradead.org>
 <tip-9b3614ccfa5492f57f743f3856253f285b10a702@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-9b3614ccfa5492f57f743f3856253f285b10a702@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for David Woodhouse <tipbot@zytor.com> wrote:

> Commit-ID:  9b3614ccfa5492f57f743f3856253f285b10a702
> Gitweb:     http://git.kernel.org/tip/9b3614ccfa5492f57f743f3856253f285b10a702
> Author:     David Woodhouse <dwmw2@infradead.org>
> AuthorDate: Wed, 29 Jan 2014 12:01:37 +0000
> Committer:  H. Peter Anvin <hpa@linux.intel.com>
> CommitDate: Wed, 29 Jan 2014 09:09:40 -0800
> 
> x86, boot: Fix word-size assumptions in has_eflag() inline asm
> 
> Commit dd78b97367bd575918204cc89107c1479d3fc1a7 ("x86, boot: Move CPU
> flags out of cpucheck") introduced ambiguous inline asm in the
> has_eflag() function. We want the instruction to be 'pushfl', but we
> just say 'pushf' and hope the compiler does what we wanted.
> 
> When building with 'clang -m16', it won't, because clang doesn't use
> the horrid '.code16gcc' hack that even 'gcc -m16' uses internally.
> 
> Say what we mean and don't make the compiler make assumptions.
> 
> [ hpa: we use plain "pushf" in the equivalent code elsewhere which may
>   be compiled as either 32- or 64-bit code.  In those cases we want
>   the assembler to pick the appropriate size for us.  However, this is
>   *16-bit* code and we still need these to be 32-bit operations. ]
> 
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> Link: http://lkml.kernel.org/r/1390996897.20153.123.camel@i7.infradead.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/x86/boot/cpuflags.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/boot/cpuflags.c b/arch/x86/boot/cpuflags.c
> index a9fcb7c..168dd25 100644
> --- a/arch/x86/boot/cpuflags.c
> +++ b/arch/x86/boot/cpuflags.c
> @@ -32,16 +32,16 @@ int has_eflag(unsigned long mask)
>  {
>  	unsigned long f0, f1;
>  
> -	asm volatile("pushf	\n\t"
> -		     "pushf	\n\t"
> +	asm volatile("pushfl	\n\t"
> +		     "pushfl	\n\t"
>  		     "pop %0	\n\t"
>  		     "mov %0,%1	\n\t"
>  		     "xor %2,%1	\n\t"
>  		     "push %1	\n\t"
> -		     "popf	\n\t"
> -		     "pushf	\n\t"
> +		     "popfl	\n\t"
> +		     "pushfl	\n\t"
>  		     "pop %1	\n\t"
> -		     "popf"
> +		     "popfl"
>  		     : "=&r" (f0), "=&r" (f1)
>  		     : "ri" (mask));

This broke the build though:

arch/x86/boot/compressed/../cpuflags.c: Assembler messages:
arch/x86/boot/compressed/../cpuflags.c:35: Error: invalid instruction suffix for `pushf'

Thanks,

	Ingo
