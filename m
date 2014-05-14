Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaENHyC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 03:54:02 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60910 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbaENHx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 03:53:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140513204924.5943.24086@quantum>
References: <1399982253-21079-1-git-send-email-gabriel.fernandez@linaro.org>
	<1399982253-21079-2-git-send-email-gabriel.fernandez@linaro.org>
	<20140513122054.GA2419@e106331-lin.cambridge.arm.com>
	<5372363B.4080608@gmail.com>
	<20140513204924.5943.24086@quantum>
Date: Wed, 14 May 2014 09:53:58 +0200
Message-ID: <CAG374jAgMbLvw8Qm2Eg6R9vVXL7gTv4Pqy7oE0hxw2zTPFHOOw@mail.gmail.com>
Subject: Re: [PATCH 1/2] clk: of: helper for determining flags properties
From: Gabriel Fernandez <gabriel.fernandez@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@stlinux.com" <kernel@stlinux.com>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 13 May 2014 22:49, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Sebastian Hesselbarth (2014-05-13 08:11:55)
>> On 05/13/2014 02:20 PM, Mark Rutland wrote:
>> > On Tue, May 13, 2014 at 12:57:32PM +0100, Gabriel FERNANDEZ wrote:
>> >> The patch provides a helper to get flags properties of
>> >> a clock node.
>> >>
>> >> Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
>> >> ---
>> >>   drivers/clk/clk.c            | 11 +++++++++++
>> >>   include/linux/clk-provider.h |  6 ++++++
>> >>   2 files changed, 17 insertions(+)
>> >>
>> >> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>> >> index 4d56220..cae8985 100644
>> >> --- a/drivers/clk/clk.c
>> >> +++ b/drivers/clk/clk.c
>> >> @@ -2528,6 +2528,17 @@ const char *of_clk_get_parent_name(struct device_node *np, int index)
>> >>   }
>> >>   EXPORT_SYMBOL_GPL(of_clk_get_parent_name);
>> >>
>> >> +unsigned long of_clk_get_flags(struct device_node *np)
>> >> +{
>> >> +    unsigned long flags = 0;
>> >> +
>> >> +    if (of_property_read_bool(np, "set-rate-parent"))
>> >> +            flags |= CLK_SET_RATE_PARENT;
>> >
>> > NAK.
>> >
>> > This is _not_ a hardware property. This flag describes internals of the
>> > Linux clock framework, and is thus not suitable for DT.
>>
>> Mark,
>>
>> while I agree above property is not a hardware property, it is at least
>> some kind of use-case property. If not by DT, we will have to allow some
>> way to describe master-slave relationships between clocks in a driver
>> independent way.
>
> I agree with Mark.
>
> Generally this stuff belongs in a clock driver. Of course there are the
> integration issues you pointed out. More on that below.
>
> As an aside, CLK_SET_RATE_PARENT is a headache, since propagation of the
> operation up to the parent clock really should be the default behavior
> for .set_rate (and in fact this is the case for the new-ish
> .determine_rate op). Some history on those decisions can be found at [1]
> and [2].
>


My issue is exactly the same as Marc, it's for solve some case with
PCM and HDMI clocks.

>>
>> > You've also failed to document the property.
>> >
>> > What are you trying to achieve here, and why do you think this is the
>> > best way of achieving that?
>>
>> I cannot tell from the commit msgs, but consider clk-si5351 which is a
>> driver for an external programmable clock with N PLLs and M outputs. Now
>> connect a video clock consumer and an audio clock consumer to two
>> different outputs and those to one PLL (as you want audio clock derived
>> from video clock, typical HDMI scenario).
>>
>> Now, there should be a way to tell the generic driver which outputs are
>> allowed to change the PLLs rate and which don't. Otherwise, the clock
>> chip would be pretty useless as e.g. your audio clock consumer will
>> overwrite the rate the video clock consumer has chosen.
>
> This is really a job for the "coordinated clock rate changes" that are
> currently in development. These specify clock sub-tree snapshots of
> parent and rate configurations that are predefined. These combinations
> can be specified in DT. That helps a lot with clock configurations that
> change per board, or for cases where many combinations of parents and
> dividers can yield the same output rate, but only a subset of those were
> validated by the silicon validation team or had proper timing closure so
> we don't want to rely on the "walk up the tree" algorithm.
>
> Regards,
> Mike

Ok i think this work will be the best solutions for my issue.

Where i can find some threads about that ?

Thanks a lot.

Best Regards.

Gabriel.
