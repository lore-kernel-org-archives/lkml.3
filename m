Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab3DMSo5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 14:44:57 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:60367 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3DMSo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 14:44:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130413144934.GA11556@redhat.com>
References: <tip-d9a3c9823a2e6a543eb7807fb3d15d8233817ec5@git.kernel.org>
	<20130326140147.GB2029@redhat.com>
	<1365687946.8824.3.camel@laptop>
	<CA+55aFway4C89fTewKvED4RvFLaNdM-BVtkJ2YChsvracLKiyA@mail.gmail.com>
	<1365753356.17140.18.camel@laptop>
	<20130413144934.GA11556@redhat.com>
Date: Sat, 13 Apr 2013 11:44:54 -0700
X-Google-Sender-Auth: p4g4SzpkGeXr8ymLaAK0xwp88fQ
Message-ID: <CA+55aFwMeAe6Mb9EPeT4Ke0W36z-XUK3BZvbOt+dMzdbJ3F1Ew@mail.gmail.com>
Subject: Re: [tip:sched/core] sched: Lower chances of cputime scaling overflow
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
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

On Sat, Apr 13, 2013 at 7:49 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>
> It works fine - gives relative error less than 0.1% for very big
> numbers.

So I was assuming that the values were all roughly in the same range.

When that is not true (say, very big rtime and very big total, very
small stime), it's possible that we end up first normalizing
rtime-vs-stime, and then dropping precision due to big 'total'. And
that might cause excessive precision loss (and I think "0.1%" is
excessive, even if it's probably perfectly fine).

I suspect I should have done the "drop precision due to 'total' being
out of range *first*. And then only balance rtime/stime after we've
scaled down total. That might avoid any unnecessary precision loss,
because bringing 'total' into the 32-bit range will continually shrink
the much larger (unbalanced) number, rather than shrink something that
was already balanced.

But I doubt it ever matters in practice.

The *big* loss (well, relatively - the worst case I've seen with your
test program is with 'err' being 0.021%) comes because if we have to
drop precision, and both rtime and stime are big, we have to scale
down 'total' by one bit every time. And we scale down the bigger of
rtime/stime too,  but we basically have twice as many bits to shave
off rtime/stime, since there are two values (even if we pick the
biggest one, eventually we'll start alternating because shaving bits
will make the other one bigger).

So we may end up scaling 'total' down to much less than 32 bits, and
that's how you get the "big" errors in the 0.02% range.

The good news is that
 (a) this requires that rtime/stime really both are big numbers
 (b) this only happens with really really big numbers (ie ver much
your "10 years of 4096 threads" at 1000 Hz kind of numbers)
 (c) even then the error isn't catastrophic.

So I think my algorithm could be improved a bit (to do the total
scaling *before* doing the scaling of rtime-vs-stime), but I think
it's quite usable.

                 Linus

PS. This is the "Make sure 'total' fits in 32 bits first" version. Not
really tested, but it's just changing the order of operations a bit.

    /* We know one of the values has a bit set in the high 32 bits */
    for (;;) {
        /* Make sure "rtime" is the bigger of stime/rtime */
        if (stime > rtime) {
            u64 tmp = rtime; rtime = stime; stime = tmp;
        }

        /* Make sure 'total' fits in 32 bits */
        if (total >> 32)
                goto drop_precision;

        /* Does rtime (and thus stime) fit in 32 bits? */
        if (!(rtime >> 32))
                break;

        /* Can we just balance rtime/stime rather than dropping bits? */
        if (stime >> 31)
            goto drop_precision;

        /* We can grow stime and shrink rtime and try to make them both fit */
        stime <<= 1;
        rtime >>= 1;
        continue;

drop_precision:
        /* We drop from rtime, it has more bits than stime */
        rtime >>= 1;
        total >>= 1;
    }
