Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423Ab3GHQhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:37:46 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:40583 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab3GHQho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:37:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130708132034.17639.4396.stgit@ladj378.jer.intel.com>
References: <20130708132034.17639.4396.stgit@ladj378.jer.intel.com>
Date: Mon, 8 Jul 2013 09:37:43 -0700
X-Google-Sender-Auth: Z-dNk3YzowsyTNRyWFZszetRvgk
Message-ID: <CA+55aFxgrOtsv7vCtic97ehpvqyezCzDcyqHVD+821BiTuiRtw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: rename low latency sockets functions to
 busy poll
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrew Mortons <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Eliezer Tamir <eliezer@tamir.org.il>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 8, 2013 at 6:20 AM, Eliezer Tamir
<eliezer.tamir@linux.intel.com> wrote:
>
> -               /* only if on, have sockets with POLL_LL and not out of time */
> -               if (ll_flag && can_ll && can_poll_ll(ll_start, ll_time))
> +               /* only if found POLL_BUSY_LOOP sockets && not out of time */
> +               if (!need_resched() && can_busy_loop &&
> +                   busy_loop_range(busy_start, busy_end))
>                         continue;

Better, but still horribly ugly. I also suspect the need_resched()
test should be done after testing can_busy_loop, just in case the
compiler can avoid having to load things off the current pointer.

I also think that we should clear busy_flag if we don't continue, no?

I also don't understand why the code keeps both busy_start and
busy_end around. It all looks completely pointless. Why have two
variables, and why make the comparisons more complicated, and the code
look more complex than it actually is?

So the code *should* just do

        if (need_busy_loop) {
                if (!need_resched() && !busy_loop_timeout(start_time))
                        continue;
        }
        busy_flag = 0;

or something like that. Then, calculate busy_end there, since it's
just an addition. Keeping two 64-bit variables around not only makes
the code more complex, it generates worse code.

I also suspect there's a lot of other micro-optimizations that could
be done: while keeping *two* 64-bit timeouts is just completely insane
on a 32-bit architecture, keeping even just one is debatable. I
suspect the timeouts should be just "unsigned long", so that 32-bit
architectures don't bother with unnecessary 64-bit clocks. 32-bit
clocks are several seconds even if you count nanoseconds, and you
actually only do microseconds anyway (so instead of shifting the
microseconds left by ten like you do, shift the nanoseconds of
sched_clock right by ten, and now you only need 32-bit values).

select() and poll() performance is actually fairly critical, so trying
to avoid bad code generation here is likely worth it.

                      Linus
