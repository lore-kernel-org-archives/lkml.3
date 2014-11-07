Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaKGWwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 17:52:41 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:56520 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbaKGWwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 17:52:39 -0500
MIME-Version: 1.0
In-Reply-To: <20141107185844.GR4042@n2100.arm.linux.org.uk>
References: <1415386312-23741-1-git-send-email-dianders@chromium.org>
	<20141107185844.GR4042@n2100.arm.linux.org.uk>
Date: Fri, 7 Nov 2014 14:52:38 -0800
X-Google-Sender-Auth: ohtJGYRLyL01oAxAUyDRLEigmag
Message-ID: <CAD=FV=WhWqMB=-ErD-59-z=y7OCZx4r7REkr3DpyYR=76SEJ6A@mail.gmail.com>
Subject: Re: [PATCH] clk: Propagate prepare and enable when reparenting orphans
From: Doug Anderson <dianders@chromium.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>, Heiko Stuebner <heiko@sntech.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

On Fri, Nov 7, 2014 at 10:58 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Nov 07, 2014 at 10:51:52AM -0800, Doug Anderson wrote:
>> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>> index 4896ae9..a3d3d58 100644
>> --- a/drivers/clk/clk.c
>> +++ b/drivers/clk/clk.c
>> @@ -1650,6 +1650,17 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
>>       clk_reparent(clk, new_parent);
>>       __clk_recalc_accuracies(clk);
>>       __clk_recalc_rates(clk, POST_RATE_CHANGE);
>> +
>> +     if (clk->prepare_count) {
>> +             unsigned long flags;
>> +
>> +             __clk_prepare(new_parent);
>> +
>> +             flags = clk_enable_lock();
>> +             if (clk->enable_count)
>> +                     __clk_enable(new_parent);
>> +             clk_enable_unlock(flags);
>> +     }
>
> I really don't understand why this isn't already done - I said this was
> necessary a /long/ time ago.
>
> However, the above isn't sufficient.  Think about the old parent - this
> should be disabled and unprepared if it was prepared and enabled by the
> child.

You may be referring of a different bug than I am addressing.  I can
think about the old parent, but it always a tear to my eyes since
these clocks are orphans and had no old parents (unless you count the
matron at the orphanage, but I doubt she was either prepared or
enabled).  ;)

Ah, but I see!  There are other users of this function that are not
part of "clk.c".  Doh!  Since this was a "__" function with no
documentation I assumed it was "static", but I see that it is not.  I
see two callers that are not part of the orphan code.

I'll happily move this code down so it's only called by the orphan
code and not touch the two callers of __clk_reparent(), assuming that
they don't need to deal with this scenario.


NOTE: As far as I can tell, the standard exposed API call is
clk_set_parent().  From reading comments that does move the prepared /
enabled state, but I haven't confirmed that functionality.

-Doug
