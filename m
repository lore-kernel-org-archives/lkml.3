Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829AbaDCC3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 22:29:12 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:32849 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932735AbaDCC3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 22:29:09 -0400
MIME-Version: 1.0
In-Reply-To: <533C525C.3070909@codeaurora.org>
References: <1396436557-29136-1-git-send-email-leiwen@marvell.com>
	<533C525C.3070909@codeaurora.org>
Date: Thu, 3 Apr 2014 10:29:08 +0800
Message-ID: <CALZhoSSgt+xJ27cxadmaqHdDAqnLKiZ7Su3nLAyUDk1txqgrug@mail.gmail.com>
Subject: Re: [PATCH] clocksource: register persistent clock for arm arch_timer
From: Lei Wen <adrian.wenl@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Lei Wen <leiwen@marvell.com>, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Apr 3, 2014 at 2:09 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 04/02/14 04:02, Lei Wen wrote:
>> Since arm's arch_timer's counter would keep accumulated even in the
>> low power mode, including suspend state, it is very suitable to be
>> the persistent clock instead of RTC.
>>
>> While read_persistent_clock calling place shall be rare, like only
>> suspend/resume place? So we shall don't care for its performance
>> very much, so use direclty divided by frequency should be accepted
>> for this reason. Actually archtimer's counter read performance already
>> be very good, since it is directly access from core's bus, not from
>> soc, so this is another reason why we choose use divide here.
>>
>> Final reason for why we don't use multi+shift way is for we may not
>> call read_persistent_clock for long time, like system long time
>> not enter into suspend, so that the accumulated cycle difference value
>> may larger than we used for calculate the multi+shift, thus precise
>> would be highly affected in such corner case.
>>
>> Signed-off-by: Lei Wen <leiwen@marvell.com>
>> ---
>>
>> I am not sure whether it is good to add something like
>> generic_persistent_clock_read in the new added kernel/time/sched_clock.c?
>> Since from arch timer's perspective, all it need to do is to pick
>> the suspend period from the place where sched_clock being stopped/restarted.
>>
>> Any idea for make the persistent clock reading as one generic function,
>> like current sched_clock do?
>
> Why do we need this? Don't we put the CLOCK_SOURCE_SUSPEND_NONSTOP flag
> on the arm_arch_timer clocksource to handle this? The only reason I can
> think of would be that you're calling read_persistent_clock() from
> somewhere else besides the timekeeping core. If that's why, please use
> the time functionality like ktime_get_boottime() or
> get_monotonic_boottime().

You are right for the CLOCK_SOURCE_SUSPEND_NONSTOP flag.
I haven't noticed that latest kernel already has such patch for arch_timer,
so provide additional such implementation shall no need then.

Another question may not related with this patch:
After 3.10, seem sched_clock also would get suspend by default during
suspend, and thus printk message's timestamp would get freezed
during the suspend, and later resume print message appears suspend
never happen, for the sched_clock already deduce the suspend period.

It makes the kernel log hard to align with other cores' generated message.
For other cores, I mean like communication processor.
So it make the debug process painful...
Any idea to solve it? Replace the local_clock to ktime_get_boottime in printk.c?

Thanks,
Lei
