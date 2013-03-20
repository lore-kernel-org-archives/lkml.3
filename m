Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab3CTVGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 17:06:17 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:52017 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab3CTVGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 17:06:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130320144752.11073.653@quantum>
References: <1363699712-8124-1-git-send-email-bilhuang@nvidia.com>
	<20130319170140.8663.93388@quantum>
	<1363748149.8815.16.camel@bilhuang-vm1>
	<20130320033142.11073.30097@quantum>
	<1363754384.8815.42.camel@bilhuang-vm1>
	<20130320144752.11073.653@quantum>
Date: Wed, 20 Mar 2013 22:06:14 +0100
Message-ID: <CAPDyKFr+Hqi8Dge3Hn55JXbqEP358F3Eq1OHdYy=2JxucJHtJg@mail.gmail.com>
Subject: Re: [PATCH 1/1] clk: Add notifier support in clk_prepare/clk_unprepare
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Bill Huang <bilhuang@nvidia.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 March 2013 15:47, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Bill Huang (2013-03-19 21:39:44)
>> On Wed, 2013-03-20 at 11:31 +0800, Mike Turquette wrote:
>> > Quoting Bill Huang (2013-03-19 19:55:49)
>> > > On Wed, 2013-03-20 at 01:01 +0800, Mike Turquette wrote:
>> > > > Quoting Bill Huang (2013-03-19 06:28:32)
>> > > > > Add notifier calls in clk_prepare and clk_unprepare so drivers which are
>> > > > > interested in knowing that clk_prepare/unprepare call can act accordingly.
>> > > > >
>> > > > > The existing "clk_set_rate" notifier is not enough for normal DVFS
>> > > > > inplementation since clock might be enabled/disabled at runtime. Adding
>> > > > > these notifiers is useful on DVFS core which take clk_prepare as a hint
>> > > > > on that the notified clock might be enabled later so it can raise voltage
>> > > > > to a safe level before enabling the clock, and take clk_unprepare as a
>> > > > > hint that the clock has been disabled and is safe to lower the voltage.
>> > > > >
>> > > > > The added notifier events are:
>> > > > >
>> > > > > PRE_CLK_PREPARE
>> > > > > POST_CLK_PREPARE
>> > > > > ABORT_CLK_PREPARE
>> > > > > PRE_CLK_UNPREPARE
>> > > > > POST_CLK_UNPREPARE
>> > > > >
>> > > > > Signed-off-by: Bill Huang <bilhuang@nvidia.com>
>> > > >
>> > > > I'm still not sure about this approach.  Based on feedback I got from
>> > > > Linaro Connect I am not convinced that scaling voltage through clk
>> > > > rate-change notifiers is the right way to go.  As I understand it this
>> > > > patch only exists for that single purpose, so if the voltage-notifier
>> > > > idea gets dropped then I will not take this patch in.
>> > > >
>> > > Thanks Mike, actually we won't use your "clk: notifier handler for
>> > > dynamic voltage scaling" patch instead we are trying to port our DVFS
>> > > into Non-CPU DVFS framework "devfreq" which will need to hook those
>> > > notifiers, without the clock notifiers been extended the framework is
>> > > useless for us since we cannot do polling due to the fact that polling
>> > > is not in real time. If it ended up extending the notifiers cannot
>> > > happen then the only choice for us I think would be giving up "devfreq"
>> > > and implement them in Tegra's "clk_hw".
>> >
>> > I'm familiar with the devfreq framework.  Can you explain further how
>> > you plan to use devfreq with the clock notifiers?  What does the call
>> > graph look like?
>> >
>> The call graph will look like this, when any DVFS interested clock rate
>> changes (including enable and disable) happen -> Tegra devfreq clock
>> notifier is called -> call into update_devfreq if needed -> in
>> update_devfreq it will call into .get_target_freq in Tegra
>> "devfreq_governor" -> and then call into .target of tegra
>> devfreq_dev_profile to set voltage and done. More details are as below.
>>
>> We'll create devfreq driver for Tegra VDD_CORE rail, and the safe
>> voltage level of the rail is determined by tens of clocks (2d, 3d,
>> mpe,...), all the frequency ladders of those clocks are defined in DT
>> also the operating points for VDD_CORE is declared in DT where its
>> frequency will be more of a virtual clock or index.
>>
>>         operating-points = <
>>         /* virtual-kHz  uV */
>>         0       950000
>>         1       1000000
>>         2       1050000
>>         3       1100000
>>         4       1150000
>>         5       1200000
>>         6       1250000
>>         7       1300000
>>         8       1350000
>>
>> Register a Tegra governor where the callback .get_target_freq is the
>> function to determine the overall frequency it can go to, and
>> the .target callback in "devfreq_dev_profile" will be the function
>> really do the voltage scaling.
>>
>> Tegra devfreq driver will register clock notifiers on all its interested
>> clock and hence when any of those clock rate changes, disabled, enabled,
>> we'll specifically call update_devfreq in the notifier.
>
> Thank you for the explanation.  Do you plan to use actual devfreq
> governors (like simple-ondemand, or something custom) for changing OPPs,
> or do you just plan to use the clock framework as a trigger for DVFS?
>
> Regards,
> Mike

At a recent discussion regarding a previous version of this patch
"[RFC 1/1] clk: Add notifier support in
clk_prepare_enable/clk_disable_unprepare", we also discussed
whether to use clk notifiers or to use a clk hw to implement DVFS.

Stephen Warren an myself, kind of pointed out that there could be
benefits of not using notifers. I would just like to add that to this
discussion as well.

The idea in principle, could be as an option to Bill's idea, using
devfreq with notifiers, to implement a clk hw which possibly makes use
of the opp libary and do implements the DVFS functionallity that is
needed for each SoC.

Kind regards
Ulf Hansson

>
> _______________________________________________
> linaro-dev mailing list
> linaro-dev@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-dev
