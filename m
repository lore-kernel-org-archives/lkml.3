Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbaKJKB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:01:26 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:49760 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbaKJKBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:01:25 -0500
Date: Mon, 10 Nov 2014 11:01:17 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        Tony Jones <tonyj@suse.de>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH, RFC] x86: also CFI-annotate certain inline asm()s
Message-ID: <20141110100117.GA15841@gmail.com>
References: <5458A9600200007800044AE5@mail.emea.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5458A9600200007800044AE5@mail.emea.novell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@suse.com> wrote:

> @@ -11,6 +14,7 @@
>  static inline unsigned long native_save_fl(void)
>  {
>  	unsigned long flags;
> +	CFI_DECL;
>  
>  	/*
>  	 * "=rm" is safe here, because "pop" adjusts the stack before
> @@ -18,9 +22,10 @@ static inline unsigned long native_save_
>  	 * documented behavior of the "pop" instruction.
>  	 */
>  	asm volatile("# __raw_save_flags\n\t"
> -		     "pushf ; pop %0"
> +		     "pushf" CFI_ADJUST_CFA_OFFSET(1) "\n\t"
> +		     "pop %0" CFI_ADJUST_CFA_OFFSET(-1)
>  		     : "=rm" (flags)
> -		     : /* no input */
> +		     : CFI_INPUTS()
>  		     : "memory");
>  
>  	return flags;
> @@ -28,10 +33,13 @@ static inline unsigned long native_save_
>  
>  static inline void native_restore_fl(unsigned long flags)
>  {
> -	asm volatile("push %0 ; popf"
> +	CFI_DECL;
> +
> +	asm volatile("push %[flags]" CFI_ADJUST_CFA_OFFSET(1) "\n\t"
> +		     "popf" CFI_ADJUST_CFA_OFFSET(-1)
>  		     : /* no output */
> -		     :"g" (flags)
> -		     :"memory", "cc");
> +		     : CFI_INPUTS([flags] "g" (flags))
> +		     : "memory", "cc");
>  }

In principle I'm not against generating better debug info for our 
assembly code, but I think it should be more readable - for 
example I would not hide 'cfi_var' in the CFI_DECL above but I'd 
make it something like:

	CFI_DECL(cfi_var);

	...
		CFI_ADJUST_CFA_OFFSET(cfi_var, ...);

etc. - even if this is slightly more verbose than what you wrote.

There's few things worse than hidden state connections between 
various primitives - even if this is build only.

I'd also suggest splitting up the patch into 'add new primitives' 
and 'use them to improve stuff' parts.

(Assuming nobody objects strongly.)

Thanks,

	Ingo
