Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab3DLH4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 03:56:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47327 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab3DLH4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 03:56:11 -0400
Message-ID: <1365753356.17140.18.camel@laptop>
Subject: Re: [tip:sched/core] sched: Lower chances of cputime scaling
 overflow
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Date: Fri, 12 Apr 2013 09:55:56 +0200
In-Reply-To: <CA+55aFway4C89fTewKvED4RvFLaNdM-BVtkJ2YChsvracLKiyA@mail.gmail.com>
References: <tip-d9a3c9823a2e6a543eb7807fb3d15d8233817ec5@git.kernel.org>
	 <20130326140147.GB2029@redhat.com> <1365687946.8824.3.camel@laptop>
	 <CA+55aFway4C89fTewKvED4RvFLaNdM-BVtkJ2YChsvracLKiyA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-11 at 08:38 -0700, Linus Torvalds wrote:
> So *now*, once we are in the uncommon case, let's start counting bits.
> Like this:
> 
>     /* We know one of the values has a bit set in the high 32 bits */
>     for (;;) {
>         /* Make sure "stime" is the bigger of stime/rtime */
>         if (rtime > stime) {
>             u64 tmp = stime; stime = rtime; rtime = tmp;
>         }
> 
>         /* Do we need to balance stime/rtime bits? */
>         if (stime >> 32) {
>             if (rtime >> 31)
>                 goto drop_precision;
> 
>             /* We can grow rtime and shrink stime and try to make them
> both fit */
>             rtime <<= 1;
>             stime >>= 1;
>             continue;
>         }
> 
>         /* stime/rtime fits in 32 bits, how about total? */
>         if (!(total >> 32))
>             break;
> 
> drop_precision:
>         /* We drop from stime, it has more bits than rtime */
>         stime >>= 1;
>         total >>= 1;
>     }
> 
> The above is totally untested, but each step is pretty damn simple and
> fairly cheap. Sure, it's a loop, but it's bounded to 32 (cheap)
> iterations, and the normal case is that it's not done at all, or done
> only a few times.

Right it gets gradually heavier the bigger the numbers get; which is
more and more unlikely.

> And the advantage is that the end result is always that simple
> 32x32/32 case that we started out with as the common case.
> 
> I dunno. Maybe I'm overlooking something, and the above is horrible,
> but the above seems reasonably efficient if not optimal, and
> *understandable*.

I suppose that entirely matters on what one is used to ;-) I had to
stare rather hard at it for a little while.

But yes, you take it one step further and are willing to ditch rtime
bits too and I suppose that's fine.

Should work,.. Stanislaw could you stick this into your userspace
thingy and verify the numbers are sane enough? 


