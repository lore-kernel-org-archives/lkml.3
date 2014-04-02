Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941AbaDBSJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 14:09:38 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57492 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932890AbaDBSJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 14:09:34 -0400
Message-ID: <533C525C.3070909@codeaurora.org>
Date: Wed, 02 Apr 2014 11:09:32 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Lei Wen <leiwen@marvell.com>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: register persistent clock for arm arch_timer
References: <1396436557-29136-1-git-send-email-leiwen@marvell.com>
In-Reply-To: <1396436557-29136-1-git-send-email-leiwen@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/14 04:02, Lei Wen wrote:
> Since arm's arch_timer's counter would keep accumulated even in the
> low power mode, including suspend state, it is very suitable to be
> the persistent clock instead of RTC.
>
> While read_persistent_clock calling place shall be rare, like only
> suspend/resume place? So we shall don't care for its performance
> very much, so use direclty divided by frequency should be accepted
> for this reason. Actually archtimer's counter read performance already
> be very good, since it is directly access from core's bus, not from
> soc, so this is another reason why we choose use divide here.
>
> Final reason for why we don't use multi+shift way is for we may not
> call read_persistent_clock for long time, like system long time
> not enter into suspend, so that the accumulated cycle difference value
> may larger than we used for calculate the multi+shift, thus precise
> would be highly affected in such corner case.
>
> Signed-off-by: Lei Wen <leiwen@marvell.com>
> ---
>
> I am not sure whether it is good to add something like
> generic_persistent_clock_read in the new added kernel/time/sched_clock.c?
> Since from arch timer's perspective, all it need to do is to pick
> the suspend period from the place where sched_clock being stopped/restarted.
>
> Any idea for make the persistent clock reading as one generic function,
> like current sched_clock do?

Why do we need this? Don't we put the CLOCK_SOURCE_SUSPEND_NONSTOP flag
on the arm_arch_timer clocksource to handle this? The only reason I can
think of would be that you're calling read_persistent_clock() from
somewhere else besides the timekeeping core. If that's why, please use
the time functionality like ktime_get_boottime() or
get_monotonic_boottime().

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

