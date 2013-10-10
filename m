Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3JJIbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:31:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230Ab3JJIbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:31:46 -0400
Date: Thu, 10 Oct 2013 10:31:07 +0200
From: Jakub Jelinek <jakub@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH] gcc4: Add 'asm goto' miscompilation quirk
Message-ID: <20131010083107.GZ30970@tucnak.zalov.cz>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20131009140734.GH3081@twins.programming.kicks-ass.net>
 <20131009143359.GU26785@twins.programming.kicks-ass.net>
 <20131009144656.GV26785@twins.programming.kicks-ass.net>
 <20131009181613.GW30970@tucnak.zalov.cz>
 <20131009190231.GI13848@laptop.programming.kicks-ass.net>
 <20131009190851.GX30970@tucnak.zalov.cz>
 <20131010062238.GB9853@gmail.com>
 <20131010065104.GY30970@tucnak.zalov.cz>
 <20131010080457.GC21875@tucnak.zalov.cz>
 <20131010082430.GA20577@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010082430.GA20577@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 10:24:30AM +0200, Ingo Molnar wrote:
> Something like the patch below? (Totally untested and all that.)
> 
> Notes:
> 
> - If the bug is fixed in 4.8.3 then the version check can be sharpened
>   from 99999 to 40803.

The bug is likely going to be fixed already for 4.8.2 (to be released
next week or so).

> - I'd really prefer this quirk versus having to add the extra barrier to 
>   the label, as it makes the actual usage sites a lot less painful.

Please check how much it bloats the generated code.
Also, for the bitops patch, you probably want an asm_volatile_goto variant.

> --- a/include/linux/compiler-gcc4.h
> +++ b/include/linux/compiler-gcc4.h
> @@ -65,6 +65,19 @@
>  #define __visible __attribute__((externally_visible))
>  #endif
>  
> +/*
> + * GCC 'asm goto' miscompiles certain code sequences:
> + *
> + *   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
> + *
> + * Work it around via quirk suggested by Jakub Jelinek.
> + * Not yet fixed, so use the quirk on all compiler versions:
> + */
> +#if GCC_VERSION <= 99999
> +# define asm_goto(x...) do { asm goto(x); asm (""); } while (0)
> +#else
> +# define asm_goto(x...) do { asm goto(x); } while (0)
> +#endif
>  
>  #ifdef CONFIG_ARCH_USE_BUILTIN_BSWAP
>  #if GCC_VERSION >= 40400

	Jakub
