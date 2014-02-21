Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbaBUWy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 17:54:29 -0500
Received: from www.linutronix.de ([62.245.132.108]:44466 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbaBUWy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 17:54:27 -0500
Date: Fri, 21 Feb 2014 23:54:35 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, Prarit Bhargava <prarit@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH] [RFC] time: Improve negative offset handling in
 timekeeping_inject_offset
In-Reply-To: <1393019430-13200-1-git-send-email-john.stultz@linaro.org>
Message-ID: <alpine.DEB.2.02.1402212255590.21251@ionos.tec.linutronix.de>
References: <1393019430-13200-1-git-send-email-john.stultz@linaro.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014, John Stultz wrote:
> I fully agree with this, but since the existing interface
> only accepts #7 style negative timespecs, we have to continue
> to support that style for this interface.
> 
> Another possible view is that the rule that the tv_nsec
> value always be [0,1e9). And that while maybe non-intuitive,
> the #7 style representations are valid and the existing
> interface is correct, thus no further change is needed.

We have the requirement all over the place in the kernel to use
normalized timespecs in the #7 form where: 0 <= tv_nsec < 1e9

To be honest, it's not the prettiest thing, but timespec is not pretty
to begin with.

And there is a good reason to be strict about that.

Assume the following code:

    t.tv_nsec += interval_ns;
    fn(&t);

If you do not validate that, then there is no chance to yell at the
abuser early.

If you have the 0 <= tv_nsec < 1e9 enforcement, then you catch that
issue way before the add actually makes the tv_nsec value negative and
causes some undechifferable wreckage. 

Sure you might argue that the requirement is:

     -1e9 < tv_nsec < 1e9

but then you need to allow all combinations of signs of tv_sec/tv_nsec
just for compatibility reasons.

Sure our normalize function can cope with that, but where is the
point?

We already enforce the 0 <= tv_nsec < 1e9 on all timespec interfaces
(kernel interal and syscalls), which in turn forces people to use
timespec_add/sub_ns or timespec_normalize.

Why can't the adjtimex folks not handle that? They already have to
handle the kernel readouts which are in the normalized form. So what's
the problem to feed their computational value through
normalize/sub/add whatever before handing it to the kernel.

That's a pure academic problem, just because people think that 

       -5, -321654987

is so much more readable than

       -6,  678345013

Now if we allow that we also need to allow

        5, -987654321

versus

	4,   12345679

It's all unreadable in one way or the other. 

I really prefer that people use proper helper functions to
add/sub/normalize timespecs into a single representation instead of
having to look at a gazillion of permutations of the same unparseable
crap.

Aside of that, if we allow that for adjtimex, then how do we argue the
restriction on all other timespec related interfaces?

Thanks,

	tglx
