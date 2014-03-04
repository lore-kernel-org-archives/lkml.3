Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbaCDHXF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 02:23:05 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:49247 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756286AbaCDHXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 02:23:03 -0500
Date: Tue, 4 Mar 2014 08:20:20 +0100
From: Henrik Austad <henrik@austad.us>
To: Mike Galbraith <bitbucket@online.de>
Cc: John Stultz <johnstul@us.ibm.com>, Salman Qazi <sqazi@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] clocksource: avoid unnecessary overflow in
 cyclecounter_cyc2ns()
Message-ID: <20140304072020.GA18178@austad.us>
References: <1393910409.6415.9.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393910409.6415.9.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 06:20:09AM +0100, Mike Galbraith wrote:
> Greetings,
> 
> While rummaging around looking for HTH a gaggle of weird a$$ machines
> can manage to timewarp back and forth by exactly 208 days, I stumbled
> across $subject which looks like it may want to borrow Salman's fix.
> 
> clocksource: avoid unnecessary overflow in cyclecounter_cyc2ns()
> 
> As per 4cecf6d401a "sched, x86: Avoid unnecessary overflow in sched_clock",
> cycles * mult >> shift is overflow prone. so give it the same treatment.
> 
> Cc: Salman Qazi <sqazi@google.com>
> Cc: John Stultz <johnstul@us.ibm.com>
> Signed-off-by: Mike Galbraith <bitbucket@online.de>
> ---
>  include/linux/clocksource.h |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> --- a/include/linux/clocksource.h
> +++ b/include/linux/clocksource.h
> @@ -77,13 +77,18 @@ struct timecounter {
>   *
>   * XXX - This could use some mult_lxl_ll() asm optimization. Same code
>   * as in cyc2ns, but with unsigned result.
> + *
> + * Because it is the same as x86 __cycles_2_ns, give it the same treatment as
> + * commit 4cecf6d401a "sched, x86: Avoid unnecessary overflow in sched_clock"
> + * to avoid a potential cycles * mult overflow.

Do we normally reference a particular commit in a comment? Why not just 
grab the same comment and add a "this is grabbed from arch/x86/... ?

>   */
>  static inline u64 cyclecounter_cyc2ns(const struct cyclecounter *cc,
>  				      cycle_t cycles)
>  {
> -	u64 ret = (u64)cycles;
> -	ret = (ret * cc->mult) >> cc->shift;
> -	return ret;
> +	u64 quot = (u64)cycles >> cc->shift;
> +	u64 rem = (u64)cycles & ((1ULL << cc->shift) - 1);
> +
> +	return  quot * cc->mult + ((rem * cc->mult) >> cc->shift);
>  }

Makes sense to me, for whatever that's worth :)

Also, tile could probably do with a similar approach for ns2cycles (not 
that I have observed any problems, but in the sense of being consistent and 
all). I'll send a patch in a separate email as not to clutter this thread 
too much :)

-- 
Henrik Austad
