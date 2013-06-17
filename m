Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab3FQTv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 15:51:59 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52281 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab3FQTv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 15:51:58 -0400
Message-ID: <51BF68DC.5030804@codeaurora.org>
Date: Mon, 17 Jun 2013 12:51:56 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: sched_clock: Load cycle count after epoch stabilizes
References: <1371082214-1119-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1371082214-1119-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John,

I just saw your pull request for making this code generic. I believe
this patch fixes a bug that nobody has seen in practice so it's probably
fine to delay this until 3.11.

Also, I've just noticed that "ARM: sched_clock: Return suspended count
earlier" that I sent in that series is going to break the arm
architected timer path because they're circumventing all this epoch_ns
code. It would be better if you could replace that patch with this patch
because this optimizes it in the same way and also fixes a bug at the
same time.

Thanks,
Stephen

On 06/12/13 17:10, Stephen Boyd wrote:
> There is a small race between when the cycle count is read from
> the hardware and when the epoch stabilizes. Consider this
> scenario:
>
>  CPU0                           CPU1
>  ----                           ----
>  cyc = read_sched_clock()
>  cyc_to_sched_clock()
>                                  update_sched_clock()
>                                   ...
>                                   cd.epoch_cyc = cyc;
>   epoch_cyc = cd.epoch_cyc;
>   ...
>   epoch_ns + cyc_to_ns((cyc - epoch_cyc)
>
> The cyc on cpu0 was read before the epoch changed. But we
> calculate the nanoseconds based on the new epoch by subtracting
> the new epoch from the old cycle count. Since epoch is most likely
> larger than the old cycle count we calculate a large number that
> will be converted to nanoseconds and added to epoch_ns, causing
> time to jump forward too much.
>
> Fix this problem by reading the hardware after the epoch has
> stabilized.
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>
> Found this while reading through the code. I haven't actually
> seen it in practice but I think it's real.
>
>  arch/arm/kernel/sched_clock.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm/kernel/sched_clock.c b/arch/arm/kernel/sched_clock.c
> index e8edcaa..a57cc5d 100644
> --- a/arch/arm/kernel/sched_clock.c
> +++ b/arch/arm/kernel/sched_clock.c
> @@ -51,10 +51,11 @@ static inline u64 notrace cyc_to_ns(u64 cyc, u32 mult, u32 shift)
>  	return (cyc * mult) >> shift;
>  }
>  
> -static unsigned long long notrace cyc_to_sched_clock(u32 cyc, u32 mask)
> +static unsigned long long notrace sched_clock_32(void)
>  {
>  	u64 epoch_ns;
>  	u32 epoch_cyc;
> +	u32 cyc;
>  
>  	if (cd.suspended)
>  		return cd.epoch_ns;
> @@ -73,7 +74,9 @@ static unsigned long long notrace cyc_to_sched_clock(u32 cyc, u32 mask)
>  		smp_rmb();
>  	} while (epoch_cyc != cd.epoch_cyc_copy);
>  
> -	return epoch_ns + cyc_to_ns((cyc - epoch_cyc) & mask, cd.mult, cd.shift);
> +	cyc = read_sched_clock();
> +	cyc = (cyc - epoch_cyc) & sched_clock_mask;
> +	return epoch_ns + cyc_to_ns(cyc, cd.mult, cd.shift);
>  }
>  
>  /*
> @@ -165,12 +168,6 @@ void __init setup_sched_clock(u32 (*read)(void), int bits, unsigned long rate)
>  	pr_debug("Registered %pF as sched_clock source\n", read);
>  }
>  
> -static unsigned long long notrace sched_clock_32(void)
> -{
> -	u32 cyc = read_sched_clock();
> -	return cyc_to_sched_clock(cyc, sched_clock_mask);
> -}
> -
>  unsigned long long __read_mostly (*sched_clock_func)(void) = sched_clock_32;
>  
>  unsigned long long notrace sched_clock(void)


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

