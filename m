Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124Ab3GSJX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 05:23:29 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:57043 "EHLO
	sivan.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab3GSJX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 05:23:27 -0400
Date: Fri, 19 Jul 2013 12:23:19 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: John Stultz <john.stultz@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        Christopher Covington <cov@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 04/17] sched_clock: Add support for >32 bit sched_clock
Message-ID: <20130719092319.GA4681@tarshish>
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org>
 <1374189690-10810-5-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374189690-10810-5-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Jul 18, 2013 at 04:21:17PM -0700, Stephen Boyd wrote:
> The ARM architected system counter has at least 56 usable bits.
> Add support for counters with more than 32 bits to the generic
> sched_clock implementation so we can increase the time between
> wakeups due to dealing with wrap-around on these devices while
> benefiting from the irqtime accounting and suspend/resume
> handling that the generic sched_clock code already has. On my
> system using 56 bits over 32 bits changes the wraparound time
> from a few minutes to an hour. For faster running counters (GHz
> range) this is even more important because we may not be able to
> execute the timer in time to deal with the wraparound if only 32
> bits are used.
> 
> We choose a maxsec value of 3600 seconds because we assume no
> system will go idle for more than an hour. In the future we may
> need to increase this value.
> 
> Note: All users should switch over to the 64-bit read function so
> we can remove setup_sched_clock() in favor of sched_clock_register().
> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---

[..]

> @@ -110,14 +123,13 @@ void __init setup_sched_clock(u32 (*read)(void), int
>   bits, unsigned long rate)
>  	if (cd.rate > rate)
>  		return;
>  
> -	BUG_ON(bits > 32);
>  	WARN_ON(!irqs_disabled());
>  	read_sched_clock = read;
> -	sched_clock_mask = (1 << bits) - 1;
> +	sched_clock_mask = CLOCKSOURCE_MASK(bits);

Note that this conflicts with my integer overflow fix 
(http://article.gmane.org/gmane.linux.ports.arm.kernel/252498) that I hope 
will get merged before 3.11 is out.

baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
