Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940Ab3KRV2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 16:28:14 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:44297 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab3KRV2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 16:28:10 -0500
Message-ID: <528A8667.7000304@linaro.org>
Date: Mon, 18 Nov 2013 13:28:07 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>
CC: linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH RFC] timekeeping: Fix clock stability with nohz
References: <1384440640-9482-1-git-send-email-mlichvar@redhat.com> <20131116070304.GB4355@netboy>
In-Reply-To: <20131116070304.GB4355@netboy>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2013 11:03 PM, Richard Cochran wrote:
> On Thu, Nov 14, 2013 at 03:50:40PM +0100, Miroslav Lichvar wrote:
>
>>  include/linux/timekeeper_internal.h |   4 +
>>  kernel/time/timekeeping.c           | 209 +++++-------------------------------
>>  2 files changed, 31 insertions(+), 182 deletions(-)
> This looks like an impressive simplification...

Indeed!

>
>> -	 * So the following can be confusing.
> Yep.
>
> So I really have no idea how the deleted code worked (or didn't work
> for nohz), but I can confirm that nohz time keeping is broken under
> light system load. Running a high load (like recompiling the kernel on
> all cores for CONFIG_HZ_PERIODIC=y ;) hides the issue, but that is
> obviously not the right solution.
Thanks for confirming the issue, and yes, forcing periodic hz isn't the
right solution.

That said there is a bit of a tension between very long nohz periods and
very accurate ntp syncing. Its a bit like sleeping at the wheel: you can
either get your rest, or stay on the road. :)  

It may be that we need to feed some of the ntp error state into the
tick-scheduling logic, so we don't try to sleep very long when we know
we're on a curvy bend.

Also, just for clarity's sake, when you're seeing things "broken",
curious how/what you are measuring?

Also is this brokenness something that has been around for awhile for
you or more recently cropped up?  I'm wondering as nohz idle has been
around for quite a few years and I've not seen too many complaints. So
I'm wondering if I'm looking in the right places, or if something has
regressed recently, or if its just that accuracy expectations have gone up?


> Out of my ignorance, two questions spring to mind.
>
> 1. Considering the simplicity of Miroslav's patch, what was the
>    benefit of the much more complicated code in the first place?

The much more complicated code was designed by Roman quite awhile back
(2006-ish). He was extremely bright, but produced very opaque code. It
made it very difficult to review, but once you sat down for awhile and
worked out the math, it ended up being correct and very efficient.

His concern was mostly about making the timer interrupt very fast on
very slow hardware (m68k was the architecture he co-maintained at the
time). So the code is very optimized for steady state, where the
adjustment value is 1,0, or -1. And we avoid doing any expensive math
operations (no multiplies, no divides), even in the non-steady state path.

Now it was designed before nohz was common (and back when nohz for a
full second was considered a aggresive length), so I could very well
believe that it has been stretched past its limit.  So I think your
point above about understanding exactly how it doesn't work for nohz is key.

Now, there is some parts of his look-ahead logic that I never quite
understood the rational for (see the top part of timekeeping_bigadjust).
At the time it was designed, I preferred a more PID-like approach, but
it was more computationally expensive and I couldn't measure any benefit
to my approach over his, so that part stuck around.


> 2. Does this patch work in the CONFIG_HZ_PERIODIC case just as well as
>    the deleted code?

As I mentioned in my other email, I'm a little concerned about some of
the accounting that is removed. At a blackbox level, its not handling
all the same values, so I suspect there's some issues here, but they may
not be very significant or difficult to fix.

So while I'm very cautious to throwing out the complex code which has
worked relatively well for quite awhile, I am very interested in coming
up with a solution that is easier to understand and validate as correct.

thanks
-john
