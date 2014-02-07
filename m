Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaBGSVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 13:21:15 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:45809 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaBGSVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 13:21:13 -0500
Message-ID: <52F52416.4030601@linaro.org>
Date: Fri, 07 Feb 2014 10:21:10 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Miroslav Lichvar <mlichvar@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH] [RFC] timekeeping: Rework frequency adjustments to work
 better w/ nohz
References: <1389067023-13541-1-git-send-email-john.stultz@linaro.org> <20140207114559.GA30949@localhost>
In-Reply-To: <20140207114559.GA30949@localhost>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 03:45 AM, Miroslav Lichvar wrote:
> On Mon, Jan 06, 2014 at 07:57:03PM -0800, John Stultz wrote:
>> Got a few cycles to take another look at this, and tried to address
>> Miroslav's latest comments. Please let me know if you have further
>> thoughts!
> I've had finally some time to look at this, sorry for the delay.
>
>> I also dropped the tk->ntp_error adjustments, as I've never quite
>> been able to recall how that was correct, and it doesn't seem to 
>> have any affect in the simulator. Will have to proceed carefully
>> with testing here.
> I see some effect of the ntp_error correction in the simulator, but it
> seems rather disruptive than helpful. Perhaps the correction was meant
> to account the fact that for the ntp_error accumulation ntp_tick
> should change at the time when mult is changed instead of start of the
> tick. I tried to find that correction and came up with this:
Yes, so I actually re-added the logic a few days after sending that
patch out.

I realized the issue is that for the accumulation point, we're adjusting
the time forward or backwards, so with the new freq the non-accumulated
offset lines up with the current time. Thus the ntp_error is the error
at that accumulation point, which also needs to be adjusted
appropriately (apologies its much easier to see when drawn).

> (ntp_tick1 - ntp_tick2) * offset / interval + offset
>
> That doesn't look usable. But I don't think it's really necessary to
> have any correction for that and I'm for dropping that line from the
> code as your patch does.

I'll have to try to look over your suggestion here another day. I
unfortunately have a head cold at the moment, so any complicated math is
a bit treacherous. :)


> Anyway, it seems there is a different problem in the code. I modified
> the simulator to see how the code works when the clocksource frequency
> is not divisible by HZ. With TSC_FREQ set to 3579545 (acpi_pm freq)
> ntp_error doesn't settle down and the clock has a large frequency
> error.
>
> On top of your patch, this fixes the problem for me:
>
> --- a/kernel/time/timekeeping.c  
> +++ b/kernel/time/timekeeping.c
> @@ -1065,7 +1065,7 @@ static __always_inline void timekeeping_freqadjust(struct timekeeper *tk,  
>   
>         /* Calculate current error per tick */
>         tick_error = ntp_tick_length() >> tk->ntp_error_shift;
> -       tick_error -= tk->xtime_interval;
> +       tick_error -= tk->xtime_interval + tk->xtime_remainder;
>
>         /* Don't worry about correcting it if its small */
>         if (likely(abs(tick_error) < 2*interval))
>
> My patch has this problem too. The original code seems to be affected
> to some extent, it's able to converge to the correct frequency, but
> there is some residual ntp error. Adding xtime_remainder to
> timekeeping_bigadjust() fixes that.
>
> I've some comments on the performance of the proposed code, I'll send
> them in a separate mail later.

Ok.. I'll look into this as well.  Thanks so much for your review and fixes!

thanks!
-john

