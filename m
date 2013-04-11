Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936593Ab3DKPik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:38:40 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51161 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932840Ab3DKPii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:38:38 -0400
MIME-Version: 1.0
In-Reply-To: <1365687946.8824.3.camel@laptop>
References: <tip-d9a3c9823a2e6a543eb7807fb3d15d8233817ec5@git.kernel.org>
	<20130326140147.GB2029@redhat.com>
	<1365687946.8824.3.camel@laptop>
Date: Thu, 11 Apr 2013 08:38:37 -0700
X-Google-Sender-Auth: sM9P0dk_WjGnspm5BHTkNYJObsw
Message-ID: <CA+55aFway4C89fTewKvED4RvFLaNdM-BVtkJ2YChsvracLKiyA@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: Lower chances of cputime scaling overflow
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 6:45 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2013-03-26 at 15:01 +0100, Stanislaw Gruszka wrote:
>> Thoughts?
>
> Would something like the below work?

Ugh, this is hard to think about, it's also fairly inefficient.

>  static cputime_t scale_stime(u64 stime, u64 rtime, u64 total)
>  {
> -       u64 rem, res, scaled;
> +       int stime_fls = fls64(stime);
> +       int total_fls = fls64(total);
> +       int rtime_fls = fls64(rtime);

Doing "fls64()" unconditionally is quite expensive on some
architectures, and if I am not mistaken, the *common* case (by far) is
that all these values fit in 32 bits, no?

So let's re-think the whole thing entirely. First, let's throw away
the uncommon case, and we'll come back to it later:

    if (unlikely((stime | total | rtime) >> 32)
         return uncommon_case(stime, total, rtime);

and now we know we have the simple case where everything is in 32
bits, and we can just do the trivial

    /* Make sure gcc understands that this is a 32x32->64 multiply,
followed by a 64/32->64 divide */
    return div_u64((u64) (u32) stime * (u64) (u32) rtime, (u32)total);

which is the *cheapest* possible case of scale_stime(), with the
simplified multiply and divide. Agreed? This is cheap even on 32-bit.
Well, relatively.

Do we agree that this is (a) the common case that we need to worry
about from performance and (b) simple, understandable and efficient?

Now, let's look at the uncommon case, and I lied, I'm not going to
actually do it as a "uncommon_case()" function, I'm going to do this
as a "let us simplify the uncommon case until it *looks* like the
common case". IOW, in this uncommon thing, the aim is simply to just
reduce stime/rtime/total to the point where they are 32 bits. Ok? And
let's keep it simple again.

So *now*, once we are in the uncommon case, let's start counting bits.
Like this:

    /* We know one of the values has a bit set in the high 32 bits */
    for (;;) {
        /* Make sure "stime" is the bigger of stime/rtime */
        if (rtime > stime) {
            u64 tmp = stime; stime = rtime; rtime = tmp;
        }

        /* Do we need to balance stime/rtime bits? */
        if (stime >> 32) {
            if (rtime >> 31)
                goto drop_precision;

            /* We can grow rtime and shrink stime and try to make them
both fit */
            rtime <<= 1;
            stime >>= 1;
            continue;
        }

        /* stime/rtime fits in 32 bits, how about total? */
        if (!(total >> 32))
            break;

drop_precision:
        /* We drop from stime, it has more bits than rtime */
        stime >>= 1;
        total >>= 1;
    }

The above is totally untested, but each step is pretty damn simple and
fairly cheap. Sure, it's a loop, but it's bounded to 32 (cheap)
iterations, and the normal case is that it's not done at all, or done
only a few times.

And the advantage is that the end result is always that simple
32x32/32 case that we started out with as the common case.

I dunno. Maybe I'm overlooking something, and the above is horrible,
but the above seems reasonably efficient if not optimal, and
*understandable*.

                    Linus
