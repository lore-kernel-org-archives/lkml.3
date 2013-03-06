Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222Ab3CFOJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:09:44 -0500
Received: from www.linutronix.de ([62.245.132.108]:43405 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758071Ab3CFOJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:09:43 -0500
Date: Wed, 6 Mar 2013 15:09:26 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Feng Tang <feng.tang@intel.com>
cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
Subject: Re: [PATCH v3 4/5] clocksource: Enable clocksource_cyc2ns() to cover
 big cycles
In-Reply-To: <1362554271-22382-5-git-send-email-feng.tang@intel.com>
Message-ID: <alpine.LFD.2.02.1303061451340.22263@ionos>
References: <1362554271-22382-1-git-send-email-feng.tang@intel.com> <1362554271-22382-5-git-send-email-feng.tang@intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Mar 2013, Feng Tang wrote:

> Current clocksource_cyc2ns() has a implicit limit that the (cycles * mult)
> can not exceed 64 bits limit. Jason Gunthorpe proposed a way to
> handle this big cycles case, and this patch put the handling into
> clocksource_cyc2ns() so that it could be used unconditionally.

Could be used if it wouldn't break the world and some more.

> Suggested-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>  include/linux/clocksource.h |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/clocksource.h b/include/linux/clocksource.h
> index aa7032c..1ecc872 100644
> --- a/include/linux/clocksource.h
> +++ b/include/linux/clocksource.h
> @@ -274,7 +274,16 @@ static inline u32 clocksource_hz2mult(u32 hz, u32 shift_constant)
>   */
>  static inline s64 clocksource_cyc2ns(cycle_t cycles, u32 mult, u32 shift)
>  {
> -	return ((u64) cycles * mult) >> shift;
> +	u64 max = ULLONG_MAX / mult;

This breaks everything which does not have a 64/32bit divide
instruction. And you can't replace it with do_div() as that would
impose massive overhead on those architectures in the fast path.

The max value can be precalculated and stored in the timekeeper
struct. We really do not want expensive calculations in the fast path.

> +	s64 nsec = 0;
> +
> +	/* The (mult * cycles) may overflow 64 bits, so add a max check */
> +	if (cycles > max) {
> +		nsec = ((max * mult) >> shift) * (cycles / max);

This breaks everything which does not have a 64/64bit divide instruction.
 
> +		cycles %= max;

Ditto.

As this is the slow path on resume you can use the 64bit functions
declared in math64.h. And you want to put the slow path out of line.

There is a world outside of x86!

Thanks,

	tglx
