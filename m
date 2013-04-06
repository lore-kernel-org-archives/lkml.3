Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423328Ab3DFQaE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 12:30:04 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33922
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423282Ab3DFQaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 12:30:01 -0400
Message-ID: <1365265737.2609.138.camel@laptop>
Subject: Re: [PATCH] sched_clock: Prevent 64bit inatomicity on 32bit systems
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        "Wulsch, Siegfried" <Siegfried.Wulsch@rovema.de>
In-Reply-To: <alpine.LFD.2.02.1304051544160.21884@ionos>
References: <alpine.LFD.2.02.1304051544160.21884@ionos>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 06 Apr 2013 18:28:57 +0200
Mime-Version: 1.0
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-04-06 at 10:10 +0200, Thomas Gleixner wrote:
> Index: linux-stable/kernel/sched/clock.c
> ===================================================================
> --- linux.orig/kernel/sched/clock.c
> +++ linux/kernel/sched/clock.c
> @@ -176,10 +176,36 @@ static u64 sched_clock_remote(struct sch
>         u64 this_clock, remote_clock;
>         u64 *ptr, old_val, val;
>  
> +#if BITS_PER_LONG != 64
> +again:
> +       /*
> +        * Careful here: The local and the remote clock values need to
> +        * be read out atomic as we need to compare the values and
> +        * then update either the local or the remote side. So the
> +        * cmpxchg64 below only protects one readout.
> +        *
> +        * We must reread via sched_clock_local() in the retry case on
> +        * 32bit as an NMI could use sched_clock_local() via the
> +        * tracer and hit between the readout of
> +        * the low32bit and the high 32bit portion.
> +        */
> +       this_clock = sched_clock_local(my_scd);
> +       /*
> +        * We must enforce atomic readout on 32bit, otherwise the
> +        * update on the remote cpu can hit inbetween the readout of
> +        * the low32bit and the high 32bit portion.
> +        */
> +       remote_clock = cmpxchg64(&scd->clock, 0, 0);
> +#else
> +       /*
> +        * On 64bit the read of [my]scd->clock is atomic versus the
> +        * update, so we can avoid the above 32bit dance.
> +        */
>         sched_clock_local(my_scd);
>  again:
>         this_clock = my_scd->clock;
>         remote_clock = scd->clock;
> +#endif

Yeah, I like your version better.. just before reading your email I
realized I could use the return value of sched_clock_local() to avoid a
cmpxchg64() :-)

That said, with this there's a subtle behavioural change between 32 and
64 bits with your patch; see how 32bit has sched_clock_local() inside
the retry loop whereas 64 bit does not.

Not sure we should worry about that though.

Thanks!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

