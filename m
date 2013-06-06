Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab3FFAjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 20:39:01 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:47468 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab3FFAi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 20:38:59 -0400
Message-ID: <51AFDA20.8070501@linaro.org>
Date: Wed, 05 Jun 2013 17:38:56 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, arm@kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCHv3 1/3] sched_clock: Add support for >32 bit sched_clock
References: <1370476485-468-1-git-send-email-sboyd@codeaurora.org> <1370476485-468-2-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1370476485-468-2-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 04:54 PM, Stephen Boyd wrote:
> The ARM architected system counter has at least 56 useable bits.
> Add support for counters with more than 32 bits to the generic
> sched_clock implementation so we can avoid the complexity of
> dealing with wrap-around on these devices while benefiting from
> the irqtime accounting and suspend/resume handling that the
> generic sched_clock code already has.
>
> All users should switch over to the 64bit read function so we can
> deprecate setup_sched_clock() in favor of sched_clock_setup().

Minor nits below.

>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>
> I've noticed that we probably need to update the mult/shift
> calculation similar to how clocksources are done. Should we
> just copy/paste the maxsec calculation code here or do something
> smarter?

So, the clocksource calculation has an extra variable it has to balance, 
which is the granularity of ntp adjustments being made (since with 
higher shift values, we can make relatively smaller changes by +1 or -1 
from mult).

sched_clock doesn't have to deal with frequency adjustments, so the 
shift value just needs to be high enough to be able to accurately 
express the desired counter frequency.  Too high and you risk 
multiplication overflows if there are large gaps between updates, too 
low though and you run into possible accuracy issues (though I hope 
there isn't much that's using sched_clock for long-term timing where 
slight accuracy issues would be problematic).

So I think its ok if the sched_clock code uses its own logic for 
calculating the mult/shift pair, since the constraints are different 
then what we expect from timekeeping.


>
>   include/linux/sched_clock.h |  1 +
>   kernel/time/sched_clock.c   | 41 +++++++++++++++++++++++++++--------------
>   2 files changed, 28 insertions(+), 14 deletions(-)
>
> diff --git a/include/linux/sched_clock.h b/include/linux/sched_clock.h
> index fa7922c..81baaef 100644
> --- a/include/linux/sched_clock.h
> +++ b/include/linux/sched_clock.h
> @@ -15,6 +15,7 @@ static inline void sched_clock_postinit(void) { }
>   #endif
>   
>   extern void setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate);
> +extern void sched_clock_setup(u64 (*read)(void), int bits, unsigned long rate);

Eww. This sort of word-swizzled function names makes patch reviewing a pain.

I know you're trying to deprecate the old function and provide a smooth 
transition, but would you also consider including follow-on 
patch/patches with this set that converts the existing setup_sched_clock 
usage (at least just the ones in drivers/clocksource?) so it doesn't 
stick around forever?

And if not, at least add a clear comment here, and maybe some build 
warnings to the old function so the driver owners know to make the 
conversion happen quickly.



>   extern unsigned long long (*sched_clock_func)(void);
>   
> diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
> index aad1ae6..3478b6d 100644
> --- a/kernel/time/sched_clock.c
> +++ b/kernel/time/sched_clock.c
> @@ -14,11 +14,12 @@
>   #include <linux/syscore_ops.h>
>   #include <linux/timer.h>
>   #include <linux/sched_clock.h>
> +#include <linux/bitops.h>
>   
>   struct clock_data {
>   	u64 epoch_ns;
> -	u32 epoch_cyc;
> -	u32 epoch_cyc_copy;
> +	u64 epoch_cyc;
> +	u64 epoch_cyc_copy;
>   	unsigned long rate;
>   	u32 mult;
>   	u32 shift;
> @@ -35,24 +36,31 @@ static struct clock_data cd = {
>   	.mult	= NSEC_PER_SEC / HZ,
>   };
>   
> -static u32 __read_mostly sched_clock_mask = 0xffffffff;
> +static u64 __read_mostly sched_clock_mask;
>   
> -static u32 notrace jiffy_sched_clock_read(void)
> +static u64 notrace jiffy_sched_clock_read(void)
>   {
> -	return (u32)(jiffies - INITIAL_JIFFIES);
> +	return (u64)(jiffies - INITIAL_JIFFIES);
>   }

Also, you might add a comment noting you register jiffies w/ 
BITS_PER_LONG, to clarify don't have to use jiffies_64 here on 32bit 
systems (despite the u64 cast)?


thanks
-john

