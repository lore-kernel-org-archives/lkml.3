Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142Ab3CMN71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 09:59:27 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:37287 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358Ab3CMN7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 09:59:25 -0400
MIME-Version: 1.0
In-Reply-To: <20130304072519.6210.97088@quantum>
References: <1362026969-11457-1-git-send-email-mturquette@linaro.org>
	<1362026969-11457-3-git-send-email-mturquette@linaro.org>
	<1362130891.19498.12.camel@bilhuang-vm1>
	<20130301182234.6210.63879@quantum>
	<20130301204832.6210.40653@quantum>
	<1362192954.2407.26.camel@bilhuang-vm1>
	<20130302082216.GA4581@richard-laptop>
	<20130303105424.6210.1196@quantum>
	<20130303132749.GA5887@richard-laptop>
	<20130304072519.6210.97088@quantum>
Date: Wed, 13 Mar 2013 14:59:22 +0100
Message-ID: <CAPDyKFqa926fr--eUh+qMqrGAoUokFmPdTi-bsH=XXSC4U1_JA@mail.gmail.com>
Subject: Re: [PATCH 2/5] clk: notifier handler for dynamic voltage scaling
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Richard Zhao <linuxzsc@gmail.com>, Bill Huang <bilhuang@nvidia.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 March 2013 08:25, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Richard Zhao (2013-03-03 05:27:52)
>> Hi Mike,
>>
>> On Sun, Mar 03, 2013 at 02:54:24AM -0800, Mike Turquette wrote:
>> > Quoting Richard Zhao (2013-03-02 00:22:19)
>> > > On Fri, Mar 01, 2013 at 06:55:54PM -0800, Bill Huang wrote:
>> > > > On Sat, 2013-03-02 at 04:48 +0800, Mike Turquette wrote:
>> > > > > Quoting Mike Turquette (2013-03-01 10:22:34)
>> > > > > > Quoting Bill Huang (2013-03-01 01:41:31)
>> > > > > > > On Thu, 2013-02-28 at 12:49 +0800, Mike Turquette wrote:
>> > > > > > > > Dynamic voltage and frequency scaling (dvfs) is a common power saving
>> > > > > > > > technique in many of today's modern processors.  This patch introduces a
>> > > > > > > > common clk rate-change notifier handler which scales voltage
>> > > > > > > > appropriately whenever clk_set_rate is called on an affected clock.
>> > > > > > >
>> > > > > > > I really think clk_enable and clk_disable should also be triggering
>> > > > > > > notifier call and DVFS should act accordingly since there are cases
>> > > > > > > drivers won't set clock rate but instead disable its clock directly, do
>> > > > > > > you agree?
>> > > > > > > >
>> > > > > >
>> > > > > > Hi Bill,
>> > > > > >
>> > > > > > I'll think about this.  Perhaps a better solution would be to adapt
>> > > > > > these drivers to runtime PM.  Then a call to runtime_pm_put() would
>> > > > > > result in a call to clk_disable(...) and regulator_set_voltage(...).
>> > > > > >
>> > > > > > There is no performance-based equivalent to runtime PM, which is one
>> > > > > > reason why clk_set_rate is a likely entry point into dvfs.  But for
>> > > > > > operations that have nice api's like runtime PM it would be better to
>> > > > > > use those interfaces and not overload the clk.h api unnecessarily.
>> > > > > >
>> > > > >
>> > > > > Bill,
>> > > > >
>> > > > > I wasn't thinking at all when I wrote this.  Trying to rush to the
>> > > > > airport I guess...
>> > > > >
>> > > > > clk_enable() and clk_disable() must not sleep and all operations are
>> > > > > done under a spinlock.  So this rules out most use of notifiers.  It is
>> > > > > expected for some drivers to very aggressively enable/disable clocks in
>> > > > > interrupt handlers so scaling voltage as a function of clk_{en|dis}able
>> > > > > calls is also likely out of the question.
>> > > >
>> > > > Yeah for those existing drivers to call enable/disable clocks in
>> > > > interrupt have ruled out this, I didn't think through when I was asking.
>> > > > >
>> > > > > Some platforms have chosen to implement voltage scaling in their
>> > > > > .prepare callbacks.  I personally do not like this and still prefer
>> > > > > drivers be adapted to runtime pm and let those callbacks handle voltage
>> > > > > scaling along with clock handling.
>> > > Voltage scaling in clock notifiers seems similar. Clock and regulater
>> > > embedded code into each other will cause things complicated.
>> >
>> > Hi Richard,
>> >
>> > Sorry, I do not follow the above statement.  Can you clarify what you
>> > mean?
>> As we have agreement that a operating point may have multiple clocks
>> and regulators, this patch is impossible to support multi clocks. And
>> it might mislead dvfs implementer to use clock notifier. It may be good
>> to have unified api like dvfs_set_opp(opp), or drivers can handle clocks
>> and regulators theirselves which is more flexible. What do you think?
>>
>
> Yes, there is a long-standing question whether clk_set_rate is
> sufficient to cover dvfs needs or if a new api is required.  There are
> many possible solutions.
>
> One solution is to use clk_set_rate and use the rate-change notifiers to
> call clk_set_rate on the other required clocks.  This is graceful from
> the perspective of the driver since the driver author only has to think
> about directly managing the clock(s) for that device and the rest is
> managed automagically.  It is more complicated for the platform
> integrator that must make sure the automagical stuff is set up
> correctly.  This might be considered a more "distributed" approach.

>From my point of view, I see some concern with this solution. Mainly
because of a lot of complexity with regards to DVFS will be pushed
down to be handled by each an every driver. Probably it will be okay
for SoC specific drivers but likely not for cross SoC drivers, if you
see what I mean.

>
> Another solution would be a new api which calls clk_set_rate
> individually on the affected clocks (e.g. a functional clk, an async
> bridge child clock, and some other related non-child clock).  This is
> less complicated for the platform integrator and represents a more
> "centralized" approach.  It is less graceful for the device driver
> author who must learn a new api and decide whether to call the new api
> or to call clk_set_rate.

This could be somewhat more preferred than the first solution. Likely
less code in each driver but still "DVFS intelligence" need to exist
there.

>
> A hybrid solution might be to set a flag on a clock (e.g.
> CLK_SET_RATE_DVFS) which tells the clk framework that this clock is
> special and clk_set_rate should call dvfs_set_opp(), where
> dvfs_set_opp() is never exposed to drivers directly.
>

I like the direction of were this idea is going. In principle that
will mean that you actually can do DVFS handling from
clk_prepare|unprepare as well, which I think is a wanted feature as
well.
Moreover, drivers do in general not need to bother about DVFS which in
the end should be a good, right?

For reference, from a ux500 SoC perspective, we have internal code -
not upstreamed yet, which implements a specific "OPP clock" type. No
changes has been done to the common clk framework for this. The "OPP
clock" clk hw, utilizes the OPP library to find out what opp to chose
for a certain frequency and then request a change if needed. To make
this solution really fly we do require the clk API to be re-entrant
since that is needed to be able to update the OPP. Moreover, it would
be possible to make use of the clk_prepare|unprepare callbacks for
this clk hw to also handle OPP changes.

> None of the above solutions are related to your point about scaling
> voltage from clk_set_rate.  Voltage may still be scaled from the clock
> rate-change notifier despite the method chose to scale groups of clocks.
>
> Regards,
> Mike
>
>> Thanks
>> Richard
>
> _______________________________________________
> linaro-dev mailing list
> linaro-dev@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-dev

Kind regards
Ulf Hansson
