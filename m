Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbaGAGcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 02:32:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60550 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751269AbaGAGcT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 02:32:19 -0400
Date: Tue, 1 Jul 2014 08:32:14 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: =?UTF-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5p?= =?UTF-8?B?Zw==?= 
	<u.kleine-koenig@pengutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Michal Simek <michal.simek@xilinx.com>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] clk: Introduce 'clk_find_nearest_rate()'
Message-ID: <20140701083214.5b31295e@bbrezillon>
In-Reply-To: <475a8ee0-11aa-4fad-94dc-9e5360f298d2@BL2FFO11FD028.protection.gbl>
References: <1404147396-8041-1-git-send-email-soren.brinkmann@xilinx.com>
	<1404147396-8041-2-git-send-email-soren.brinkmann@xilinx.com>
	<20140630212707.1eb44db6@bbrezillon>
	<475a8ee0-11aa-4fad-94dc-9e5360f298d2@BL2FFO11FD028.protection.gbl>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sören,

On Mon, 30 Jun 2014 17:12:23 -0700
Sören Brinkmann <soren.brinkmann@xilinx.com> wrote:

> Hi Boris,
> 
> On Mon, 2014-06-30 at 09:27PM +0200, Boris BREZILLON wrote:
> > Hello Soren,
> > 
> > On Mon, 30 Jun 2014 09:56:33 -0700
> > Soren Brinkmann <soren.brinkmann@xilinx.com> wrote:
> > 
> > > Introduce a new API function to find the rate a clock can provide
> > > which is closest to a given rate.
> > > 
> > > clk_round_rate() leaves it to the clock driver how rounding is
> > > done. Commonly implementations round down due to use-cases that
> > > have a certain frequency maximum that must not be exceeded.
> > 
> > I had the same concern (how could a driver decide whether it should
> > round up, down or to the closest value), but had a slightly
> > different approach in mind.
> > 
> > AFAIU, you're assuming the clock is always a power of two (which is
> > true most of the time, but some clock implementation might differ,
> > i.e. a PLL accept any kind of multiplier not necessarily a power of
> > 2).
> 
> No, the idea is to always work. There should not be any such
> limitation. Where do you see that?

My bad, I should have read the code more carefully.
BTW, it could help readers if you add some comments to explain how you
are finding the nearest rate.

My main concern with this approach is that you can spend some time
iterating to find the nearest rate where a clk driver would find it
quite quickly (because it knows exactly how the clk works and what are
the possible clk muxing and clk modifiers options).

> 
> > 
> > How about improving the clk_ops interface instead by adding a new
> > method
> > 
> > 	long (*round_rate_with_constraint)(struct clk_hw *hw,
> > 					   unsigned long
> > requested_rate, unsigned long *parent_rate,
> > 					   enum clk_round_type
> > type);
> > 
> > with
> > 
> > enum clk_round_type {
> > 	CLK_ROUND_DOWN,
> > 	CLK_ROUND_UP,
> > 	CLK_ROUND_CLOSEST,
> > };
> 
> I thought about that, but the find_nearest() did already exist more or
> less and in the end it is not much of a difference, IMHO. If it turns
> out that the others are needed as well and somebody implements it,
> they could be added as another convenience function like I did,
> and/or it could be wrapped in the function you propose here.
>
> > 
> > or just adding these 3 methods:
> > 
> > 	long (*round_rate_up)(struct clk_hw *hw,
> > 			      unsigned long requested_rate,
> > 			      unsigned long *parent_rate);
> > 
> > 	long (*round_rate_down)(struct clk_hw *hw,
> > 				unsigned long requested_rate,
> > 				unsigned long *parent_rate);
> > 
> > 	long (*round_rate_closest)(struct clk_hw *hw,
> > 				   unsigned long requested_rate,
> > 				   unsigned long *parent_rate);
> 
> That would be quite a change for clock drivers. So far, there are not
> many restrictions on round_rate. I think there has already been a
> discussion in this direction that went nowhere.
> https://lkml.org/lkml/2010/7/14/260
> 

Not if we keep these (or this, depending on the solution you chose)
functions optional, and return -ENOTSUP, if they're not implemented.

> > 
> > and let the round_rate method implement the default behaviour.
> 
> There is no real default. Rounding is not specified for the current
> API.

What I meant by default behavior is the behavior already implemented by
the clock driver (either round up, down or closest).
This way you do not introduce regressions with existing users, and can
use new methods in new use cases.

> 
> > 
> > This way you could add 3 functions to the API:
> > 
> > clk_round_closest (or clk_find_nearest_rate as you called it),
> > clk_round_up and clk_round_down, and let the clk driver
> > implementation return the appropriate rate.
> 
> I'd say the current patch set does kind of align with that, doesn't
> it? We can add the find_nearest_rate() (there was a discussion on the
> name, ane we decided against round_closest in favor of the current
> proposal) now and the other functions could be added later if people
> find them to be useful. And if they all get added we can think about
> consolidating them if it made sense.

Yes sure.

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
