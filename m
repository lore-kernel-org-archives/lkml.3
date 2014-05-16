Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbaEPXhh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 19:37:37 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:44862 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800AbaEPXhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 19:37:36 -0400
Message-ID: <5376A13C.6020005@linaro.org>
Date: Fri, 16 May 2014 16:37:32 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Miroslav Lichvar <mlichvar@redhat.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH 0/3] timekeeping: Improved NOHZ frequency steering
References: <1398380677-8684-1-git-send-email-john.stultz@linaro.org> <20140425140421.GA7933@localhost> <535ACE2D.9000408@linaro.org> <20140430140123.GB30862@localhost>
In-Reply-To: <20140430140123.GB30862@localhost>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 07:01 AM, Miroslav Lichvar wrote:
> On Fri, Apr 25, 2014 at 02:05:49PM -0700, John Stultz wrote:
>> On 04/25/2014 07:04 AM, Miroslav Lichvar wrote:
>>> It seems it still doesn't always switch mult only between the two
>>> closest values, which explains the slightly worse dev and max values.
>> Huh. I don't think I saw that in my testing. I'll look into it again.
> I can see it with tk_test -o 100000, for instance. It's switching
> between 8389446, 8389447 and 8389448.

Ok, I think I sorted this part out. Thanks for the heads up here!


>
>> I suspect the extra error comes from the occasional underflow handling
>> (which you avoid w/ the second_overflow_skip stuff which would help but
>> feels a little clunky to me - but I'm still thinking it over).
> It seems to be something else as I can see it even when I remove
> "advance_ticks(3, 4, 1);" from tk_test.c so clock updates are aligned
> exactly with ticks and no underflow can happen (i.e. offset in
> timekeeping_apply_adjustment() is zero).
>
> I agree the skip_second_overflow flag in my patch is ugly, but it's
> necesssary as the code would otherwise take too long to correct the
> underflowed part in ntp error.
>
> Anyway, I did more testing and I think I found a more serious problem.
> It seems the loop doesn't handle well tick lengths which happen to be
> close to the middle between multipliers. For example:
>
> $ ./tk_test -n 10000 -o 100077
> samples: 1-10000 reg: 1-10000 slope: 1.00 dev: 1241.7 max: 3532.3 freq: 100.07717
>
> When I add the following line to the kernel code to see the value of
> mult and ntp_error after clock update:
>
> +++ b/kernel/time/timekeeping.c
> @@ -1386,6 +1386,7 @@ void update_wall_time(void)
>         /* correct the clock when NTP error is too big */
>         timekeeping_adjust(tk, offset);
>
> +       printk("%d %lld\n", tk->mult, tk->ntp_error >> (tk->ntp_error_shift + tk->shift));
>
> I get this:
>
> 8389447 -101
> 8389449 6
> 8389447 -321
> 8389448 -198
> 8389447 -249
> ...
> 8389447 -6344
> 8389448 -6158
> 8389447 -6223
> 8389448 -6211
> 8389447 -6265
> 8389448 -6029
>
> It looks like the correction is not able to handle the random
> cumulation of differences in the lengths between odd and even update
> intervals. The overall frequency is accurate, but ntp error is in
> microseconds here.

Yea, in the freqadjust logic, we chose to do nothing if it was inbetween
0 to (interval/2). The problem being that interval/2 is too small
target, and if we get too close a single unit adjustment may bounce us
on either side of that range. Changed the comparision to being the
0-interval (inclusive) which should assure the approximation will land
in that range.

New patchset to follow shortly!

thanks
-john
