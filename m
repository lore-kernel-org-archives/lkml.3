Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab3JJL4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 07:56:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36748 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab3JJL4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 07:56:40 -0400
Date: Thu, 10 Oct 2013 13:56:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jakub Jelinek <jakub@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [PATCH, -v2] compiler/gcc4: Add quirk for 'asm goto'
 miscompilation bug
Message-ID: <20131010115617.GY28601@twins.programming.kicks-ass.net>
References: <20131009181613.GW30970@tucnak.zalov.cz>
 <20131009190231.GI13848@laptop.programming.kicks-ass.net>
 <20131009190851.GX30970@tucnak.zalov.cz>
 <20131010062238.GB9853@gmail.com>
 <20131010065104.GY30970@tucnak.zalov.cz>
 <20131010080457.GC21875@tucnak.zalov.cz>
 <20131010082430.GA20577@gmail.com>
 <20131010083107.GZ30970@tucnak.zalov.cz>
 <20131010084535.GA10620@gmail.com>
 <20131010085506.GA11775@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010085506.GA11775@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 10:55:06AM +0200, Ingo Molnar wrote:
> +/*
> + * GCC 'asm goto' miscompiles certain code sequences:
> + *
> + *   http://gcc.gnu.org/bugzilla/show_bug.cgi?id=58670
> + *
> + * Work it around via quirk suggested by Jakub Jelinek.
> + * Fixed in GCC 4.8.2 and later versions.
> + */
> +#if GCC_VERSION <= 40801

We didn't do version checks for CC_HAVE_ASM_GOTO because of vendor
backports; can't we detect this in the same way?

> +# define __asm_goto(vol, x...) do { asm vol goto(x); asm (""); } while (0)
> +#else
> +# define __asm_goto(vol, x...) do { asm vol goto(x); } while (0)
> +#endif

This places the asm("") in the fallthrough case; but Jakub wrote:

> @@ -8,6 +8,7 @@ foo (int a, int b)
>    asm volatile goto ("bts $1, %0; jc %l[lab]" : : "m" (b) : "memory" : lab);
>    return 0;
>  lab:
> +  asm ("");
>    return 0;
>  }

Which places the asm ("") after the label, these two are not the same.
