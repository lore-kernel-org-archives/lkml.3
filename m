Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaEVVDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:03:44 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34403 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbaEVVDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:03:39 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: =?utf-8?q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        =?utf-8?q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <6612b069-1228-488f-81f7-ea8839f6c468@BN1BFFO11FD029.protection.gbl>
Cc: "Russell King" <linux@arm.linux.org.uk>,
        "Stephen Boyd" <sboyd@codeaurora.org>, linux-pm@vger.kernel.org,
        "Viresh Kumar" <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Michal Simek" <michal.simek@xilinx.com>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20140520073358.GJ16662@pengutronix.de> <537B957B.5010001@codeaurora.org>
 <668683e3-856e-4f30-9b11-8f3e91e12d1d@BL2FFO11FD038.protection.gbl>
 <20140521073457.GD31687@pengutronix.de>
 <e9090453-ce40-4662-a3ea-fbdaffdb2aa4@BN1AFFO11FD046.protection.gbl>
 <20140521182308.GN31687@pengutronix.de> <20140521203300.9521.67546@quantum>
 <ac335a38-b0f4-4d95-b111-56c05e1a6234@BN1BFFO11FD045.protection.gbl>
 <20140522182040.GB20155@pengutronix.de>
 <6612b069-1228-488f-81f7-ea8839f6c468@BN1BFFO11FD029.protection.gbl>
Message-ID: <20140522210328.9521.34889@quantum>
User-Agent: alot/0.3.5
Subject: Re: [RFC PATCH 2/5] clk: Introduce 'clk_round_rate_nearest()'
Date: Thu, 22 May 2014 14:03:28 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sören Brinkmann (2014-05-22 13:32:09)
> On Thu, 2014-05-22 at 08:20PM +0200, Uwe Kleine-König wrote:
> > Hello Sören,
> > 
> > On Thu, May 22, 2014 at 11:03:00AM -0700, Sören Brinkmann wrote:
> > > On Wed, 2014-05-21 at 01:33PM -0700, Mike Turquette wrote:
> > > > Quoting Uwe Kleine-König (2014-05-21 11:23:08)
> > > > > Hello Sören,
> > > > > 
> > > > > On Wed, May 21, 2014 at 08:58:10AM -0700, Sören Brinkmann wrote:
> > > > > > On Wed, 2014-05-21 at 09:34AM +0200, Uwe Kleine-König wrote:
> > > > > > > On Tue, May 20, 2014 at 02:48:20PM -0700, Sören Brinkmann wrote:
> > > > > > > > On Tue, 2014-05-20 at 10:48AM -0700, Stephen Boyd wrote:
> > > > > > > > > On 05/20/14 09:01, Sören Brinkmann wrote:
> > > > > > > > > >
> > > > > > > > > >>>>> +{
> > > > > > > > > >>>>> + unsigned long lower, upper, cur, lower_last, upper_last;
> > > > > > > > > >>>>> +
> > > > > > > > > >>>>> + lower = clk_round_rate(clk, rate);
> > > > > > > > > >>>>> + if (lower >= rate)
> > > > > > > > > >>>>> +         return lower;
> > > > > > > > > >>>> Is the >-case worth a warning?
> > > > > > > > > >>> No, it's correct behavior. If you request a rate that is way lower than what the
> > > > > > > > > >>> clock can generate, returning something larger is perfectly valid, IMHO.
> > > > > > > > > >>> Which reveals one problem in this whole discussion. The API does not
> > > > > > > > > >>> require clk_round_rate() to round down. It is actually an implementation
> > > > > > > > > >>> choice that had been made for clk-divider.
> > > > > > > > > >> I'm sure it's more than an implementation choice for clk-divider. But I
> > > > > > > > > >> don't find any respective documentation (but I didn't try hard).
> > > > > > > > > > A similar discussion - without final conclusion:
> > > > > > > > > > https://lkml.org/lkml/2010/7/14/260
> > > > > > > > > >
> > > > > > > > > >
> > > > > > > > > 
> > > > > > > > > Please call this new API something like clk_find_nearest_rate() or
> > > > > > > > > something. clk_round_rate() is supposed to return the rate that will be
> > > > > > > > > set if you call clk_set_rate() with the same arguments. It's up to the
> > > > > > > > > implementation to decide if that means rounding the rate up or down or
> > > > > > > > > to the nearest value.
> > > > > > > > 
> > > > > > > > Sounds good to me. Are there any cases of clocks that round up? I think
> > > > > > > > that case would not be handled correctly. But I also don't see a use
> > > > > > > > case for such an implementation.
> > > > > > > I don't really care which semantic (i.e. round up, round down or round
> > > > > > > closest) is picked, but I'd vote that all should pick up the same. I
> > > > > > > think the least surprising definition is to choose rounding down and add
> > > > > > > the function that is under discussion here to get a nearest match.
> > > > > > > 
> > > > > > > So I suggest:
> > > > > > > 
> > > > > > >     - if round_rate is given a rate that is smaller than the
> > > > > > >       smallest available rate, return 0
> > > > > > >     - add WARN_ONCE to round_rate and set_rate if they return with a
> > > > > > >       rate bigger than requested
> > > > > > 
> > > > > > Why do you think 0 is always valid? I think for a clock that can
> > > > > > generate 40, 70, 120, clk_round_rate(20) should return 40.
> > > > > I didn't say it's a valid value. It just makes the it possible to check
> > > > > for clk_round_rate(clk, rate) <= rate.
> > > > > 
> > > > > I grepped a bit around and found da850_round_armrate which implements a
> > > > > round_rate callback returning the best match.
> > > > > omap1_clk_round_rate_ckctl_arm can return a value < 0.
> > > > > s3c2412_roundrate_usbsrc can return values that are bigger than
> > > > > requested. (I wonder if that is a bug though.)
> > > > > 
> > > > > > >     - change the return values to unsigned long
> > > > > > 
> > > > > > Yep, I agree, this should happen.
> > > > > And we're using 0 as error value? e.g. for the case where
> > > > > omap1_clk_round_rate_ckctl_arm returns -EIO now?
> > > > 
> > > > No. clk_round_rate returns long for a reason, which is that we can
> > > > provide an error code to the caller. From include/linux/clk.h:
> > > > 
> > > > /**
> > > >  * clk_round_rate - adjust a rate to the exact rate a clock can provide
> > > >  * @clk: clock source
> > > >  * @rate: desired clock rate in Hz
> > > >  *
> > > >  * Returns rounded clock rate in Hz, or negative errno.
> > > >  */
> > > > 
> > > > This has the unfortunate side effect that the max value we can return
> > > > safely is 2147483647 (~2GHz). So another issue here is converting clock
> > > > rates to 64-bit values.
> > > 
> > > So, let's assume
> > >  - a clock does either of these
> > >    - round down
> > >    - round nearest
> > >    - round up (is there any such case? I don't see a use-case for this)
> > >  - or return an error
> > > 
> > > I think my latest try handles such cases, with the limitation of
> > > for a clock that rounds up, the up-rounded value is found instead of the
> > > nearest.
> > > 
> > > 
> > > static long clk_find_nearest_rate(struct clk *clk, unsigned long rate)
> > > {
> > >     long ret;
> > >     unsigned long lower, upper;
> > > 
> > >     clk_prepare_lock();
> > > 
> > >     lower = __clk_round_rate(clk, rate);
> > this is CCF specific while I don't see a need for it. (But yes, a
> > lock-less clk_find_nearest_rate is of course racy.)
> Do we have to support non-CCF implementations? Isn't switching to the
> CCF encouraged?

No we don't. If you check out the ifdeffery in include/linux/clk.h
you'll see more function declarations for CONFIG_COMMON_CLK then for
!CONFIG_COMMON_CLK, so we're not breaking any ground here.

> 
> > 
> > >     if (lower >= rate || (long)lower < 0) {
> > If you made lower and upper a signed long, you could drop the casting
> > here. BTW, why does __clk_round_rate return an unsigned long??
> > There seem to be several more type mismatches in that area.
> > Maybe we should add a waring if rate is > LONG_MAX?
> > 
> > (And ISTR that the C standard doesn't specify what the result of
> > (long)lower is given that lower is of type unsigned long and holding a
> > value > LONG_MAX.)
> Looks like you're right. This probably needs some polishing to get types
> sorted out.
> Mike/Russel: As Uwe pointed out, shouldn't __clk_round_rate return a
> long as well?

Yeah. The strange thing is that .round_rate and .determine_rate both
return long. I think I was asleep at the wheel on this one.

I count about a dozen call sites that need to be fixed up for this
change to happen. As we approach 3.15-rc6 I'm a bit nervous about
introducing this change. How do you feel about dropping this change in
first thing after 3.16-rc1 and layering in your new clk_find_*_rate
stuff on top of it?

I'll take a stab at fixing up __clk_round_rate early next week.

Regards,
Mike

> 
>         Sören
> 
