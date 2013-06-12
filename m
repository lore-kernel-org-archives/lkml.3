Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744Ab3FLSHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 14:07:54 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:62395 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380Ab3FLSHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 14:07:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=WvDFQhXMV7PiaMoDN41vcLC3nRL2B8_v=B6h1mCq0Saw@mail.gmail.com>
References: <1369056507-32521-1-git-send-email-james.hogan@imgtec.com>
 <1369056507-32521-6-git-send-email-james.hogan@imgtec.com>
 <519AFBB6.90700@codeaurora.org> <CAD=FV=VFqTzqLc3+UOHD21NiTqtu84DzwYD1Qag-RxiD0qcFDA@mail.gmail.com>
 <20130612174500.26381.95767@quantum> <CAD=FV=WvDFQhXMV7PiaMoDN41vcLC3nRL2B8_v=B6h1mCq0Saw@mail.gmail.com>
From: Mike Turquette <mturquette@linaro.org>
Date: Wed, 12 Jun 2013 11:07:31 -0700
Message-ID: <CAPtuhTijr4r2USdc+6h2305SUs=Lo1b-6qOov9pV8DnKRBttPA@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] clk: clk-mux: implement remuxing on set_rate
To: Doug Anderson <dianders@chromium.org>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        James Hogan <james.hogan@imgtec.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 12, 2013 at 10:55 AM, Doug Anderson <dianders@chromium.org> wrote:
> Mike,
>
> On Wed, Jun 12, 2013 at 10:45 AM, Mike Turquette <mturquette@linaro.org> wrote:
>
>>> * It seems like we can't make muxing decisions on the SoC level.
>>> * Your automatic muxing patches don't hurt me and could be useful for
>>> _some_ of the muxing options, just not the top PLL ones.
>>
>> For the time being you won't be affected by this until you start using
>> .determine_rate.  Even then we have the flag which disables this
>> behavior.
>
> Yup, exactly!  :)  So I have no objections to the auto remuxing, it
> just doesn't solve all of my problems.
>
>
>>> ...but the only place that leaves me for my muxing needs is the device
>>> tree.  ...and as Mike pointed out on IRC the device tree should
>>> describe hardware, not policy.  Ick.
>>
>> This sounds like another vote for configtree ;-)
>
> Yes.  It sounds like for now we're just going to carry some patches to
> setup our clocks, but a configtree seems like it would solve this type
> of problem.
>
> One question to raise: if we're going to need to come up with a
> solution for defining parents for things like PLLs, does it decrease
> the need for the auto-remuxing patches?  AKA: if we use some type of
> mechanism like configtree to specify muxing, would that be enough?  I
> don't know the answer, but just thought I'd raise the question...

It's a good question. I can think of some cases where auto-muxing
would still be helpful. There are drivers out there that don't need to
know the details of the clock tree hierarchy and automagic muxing will
help remove those details from some of the drivers.

However I think that boot-time configuration of muxes that don't
switch (configtree), combined with custom mux clock code that
implements recommendations from HW engineers and the data sheet will
probably be more common than lots and lots of generic re-muxing. I
think that implementing those recommendations on which parent to use
is the problem Saravana was trying to solve with the priority list of
parents

How to encode that information in DT is a bit of a problem.  I guess
one approach could be to create a mux table in DT and instead of
ordering items in that list based on bitfield index (which feel
natural to most programmers), instead let the order imply priority.
This is a tricky hack since we're *technically* only describing the
hardware with the mux table, but the priority encoding is silently
encoded.  E.g:

        clock: clock@4a008100 {
                #clock-cells = <0>;
                compatible = "mux-clock";
                clocks = <&clock_foo>, <&clock_bar>, <&clock_baz>;
                reg = <0x4a008100 0x4>;
                mask = <0x3>;
                shift = <0>;
                table = <&clock_baz 0x2>, <&clock_foo 0x0>, <&clock_bar 0x1>;
        };

Thoughts?

Regards,
Mike

>
> -Doug
