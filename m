Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab3COMdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 08:33:11 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:38081 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab3COMdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 08:33:10 -0400
MIME-Version: 1.0
In-Reply-To: <1363349206.5827.10.camel@bilhuang-vm1>
References: <1363151317.3311.9.camel@bilhuang-vm1>
	<51400D9D.9060305@wwwdotorg.org>
	<1363153204.3311.14.camel@bilhuang-vm1>
	<5140C12A.4060900@wwwdotorg.org>
	<1363227311.3311.30.camel@bilhuang-vm1>
	<20130314092132.GE18519@tbergstrom-lnx.Nvidia.com>
	<1363253287.3311.32.camel@bilhuang-vm1>
	<51420EBB.7080503@wwwdotorg.org>
	<1363310454.3311.44.camel@bilhuang-vm1>
	<5142B027.4040403@wwwdotorg.org>
	<20130315093951.GV18519@tbergstrom-lnx.Nvidia.com>
	<CAPDyKFoBJpraMz8i1FmFqG7=Zsv0DTQ0PKVOQJ-+iEsKpb3Hdg@mail.gmail.com>
	<1363349206.5827.10.camel@bilhuang-vm1>
Date: Fri, 15 Mar 2013 13:33:08 +0100
Message-ID: <CAPDyKFpHz6KCNbVe2AsDuzZw-oN7NyRzCA=RatWA+9iMaQ7C+Q@mail.gmail.com>
Subject: Re: [RFC 1/1] clk: Add notifier support in clk_prepare_enable/clk_disable_unprepare
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Bill Huang <bilhuang@nvidia.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 March 2013 13:06, Bill Huang <bilhuang@nvidia.com> wrote:
> On Fri, 2013-03-15 at 18:08 +0800, Ulf Hansson wrote:
>> On 15 March 2013 10:39, Peter De Schrijver <pdeschrijver@nvidia.com> wrote:
>> > On Fri, Mar 15, 2013 at 06:22:47AM +0100, Stephen Warren wrote:
>> >> On 03/14/2013 07:20 PM, Bill Huang wrote:
>> >> > On Fri, 2013-03-15 at 01:54 +0800, Stephen Warren wrote:
>> >> >> On 03/14/2013 03:28 AM, Bill Huang wrote:
>> >> >>> On Thu, 2013-03-14 at 17:21 +0800, Peter De Schrijver wrote:
>> >> >>>> On Thu, Mar 14, 2013 at 03:15:11AM +0100, Bill Huang wrote:
>> >> >>>>
>> >> >>>>> I don't think deferring will work either, considering the usage of DVFS,
>> >> >>>>> device voltage is tightly coupled with frequency, when clock rate is
>> >> >>>>> about to increase, we have to boost voltage first and we can lower the
>> >> >>>>> voltage after the clock rate has decreased. All the above sequence have
>> >> >>>>> to be guaranteed or you might crash, so deferring not only make thing
>> >> >>>>> complicated in controlling the order but also hurt performance.
>> >> >>>>
>> >> >>>> But we could use notifiers in clk_prepare/clk_unprepare to set the voltage no?
>> >> >>>> As clk_prepare/clk_unprepare have to be called before clk_enable or after
>> >> >>>> clk_disable, the voltage can be raised to a safe level, before the clock
>> >> >>>> becomes active.
>> >> >>>
>> >> >>> Thanks Peter, actually I'm just about to propose my v2 RFC which add
>> >> >>> notifier in clk_prepare/clk_unprepare.
>> >> >>
>> >> >> Can't clk_set_rate() be called while the clock is prepared, or even
>> >> >> enabled? I don't see how your proposal would work.
>> >> >
>> >> > I think it works with just a little sacrifice on saving more power but
>> >> > that's related minor. Taking clk_prepare as an indicator on that clock
>> >> > will be enabled later, so we can raise the voltage to a safe level
>> >> > (according to the current rate or maybe default rate when clk_prepare is
>> >> > called, some time late when clk_set_rate() is called we can adjust again
>> >> > according to the requested rate change)
>> >>
>> >> Is clk_set_rate() only legal to call in non-atomic contexts then? The
>> >> header file doesn't say, although I guess since many other functions
>> >> explicitly say they can't, then by omission it can...
>> >
>> > Yes. Only clk_enable() and clk_disable() can be called in an atomic context.
>> >
>> > Cheers,
>> >
>> > Peter.
>> >
>> > _______________________________________________
>> > linaro-dev mailing list
>> > linaro-dev@lists.linaro.org
>> > http://lists.linaro.org/mailman/listinfo/linaro-dev
>>
>> Just wanted to add my reflection on this topic;
>>
>> Some prerequisites; I think am in favor of using the clk API to
>> trigger DVFS changes and then I agree on that clk_prepare|unprepare
>> needs to be possible to track from a DVFS perspective. clk_set_rate is
>> not enough.
>>
>> So if we decide to do the above (using the clk API to trigger DVFS
>> changes), I believe we should discuss two possible solutions;
>> - clk notifiers or..
>> - dvfs clock type.
>>
>> I am trying to make up my mind of what I think is the best solution.
>> Have you considered "dvfs clock type"?
>> I put some comments about this for "[PATCH 2/5] clk: notifier handler
>> for dynamic voltage scaling" recently as well.
>>
>> What could the advantages/disadvantages be between the two options?
>
> I personally prefer clk notifiers since that's easy and all the existing
> device drivers don't need to be modified, a new clock or API might be
> more thoroughly considered (and hence maybe more graceful) but that
> means we need more time to cook and many drivers need to plug into that
> API when it comes out, a lot of test/verification or maybe chaos
> follows, I'm not sure will that be a little overkill.

I guess you did not fully got what I meant with "dvfs clock type". It
will not affect the clock API. But instead the dvfs is handled by
implementing a specific clk hw type. So the same thing is accomplished
as with clk notifiers, no changes should be needed to device drivers.

The difference is only that no notifiers will be needed, and all the
dvfs stuff will be handled in the clk hw instead. It will mean that we
will bundle dvfs stuff into the clock drivers, instead of separating
the code outside the clock drivers. But, on the other hand no
notifiers will be needed.

>
> I'm not against designing a more robust API, I'm just suggesting before
> we have that defined we should at least let clk notifiers work.
>>
>> Kind regards
>> Ulf Hansson
>
>

Kind regards
Ulf Hansson
