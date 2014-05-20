Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbaETQDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:03:52 -0400
Received: from mail-bn1lp0145.outbound.protection.outlook.com ([207.46.163.145]:40716
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752085AbaETQDt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:03:49 -0400
Date: Tue, 20 May 2014 09:01:38 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
CC: Mike Turquette <mturquette@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 2/5] clk: Introduce 'clk_round_rate_nearest()'
References: <1400106655-22465-1-git-send-email-soren.brinkmann@xilinx.com>
 <1400106655-22465-3-git-send-email-soren.brinkmann@xilinx.com>
 <20140515073816.GI16662@pengutronix.de>
 <91822600-39d0-4e71-b0f5-9eda35b76ec0@BN1AFFO11FD016.protection.gbl>
 <20140519161949.GG16662@pengutronix.de>
 <db8633e5-01a9-4d3a-80e8-74e23a456d52@BN1BFFO11FD051.protection.gbl>
 <20140520073358.GJ16662@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140520073358.GJ16662@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <4bb5f44a-60bb-4e34-8f88-f91b8419be8d@BL2FFO11FD050.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(377424004)(24454002)(51704005)(199002)(189002)(47776003)(79102001)(33646001)(77982001)(76482001)(64706001)(92726001)(92566001)(85852003)(86362001)(31696002)(21056001)(50986999)(76176999)(74316001)(83506001)(15975445006)(54356999)(99396002)(83072002)(85202002)(50466002)(85182001)(53416003)(102836001)(20776003)(87936001)(44976005)(19580395003)(74502001)(19580405001)(83322001)(31966008)(23676002)(74662001)(46102001)(80022001)(4396001)(81542001)(70736001)(81342001)(23106003)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB063;H:xsj-gw1;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Forefront-PRVS: 02176E2458
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Tue, 2014-05-20 at 09:33AM +0200, Uwe Kleine-König wrote:
> Hi Sören,
> 
> On Mon, May 19, 2014 at 09:41:32AM -0700, Sören Brinkmann wrote:
> > On Mon, 2014-05-19 at 06:19PM +0200, Uwe Kleine-König wrote:
> > > Hi Sören,
> > > 
> > > On Sun, May 18, 2014 at 05:51:05PM -0700, Sören Brinkmann wrote:
> > > > ------------------8<-----------------8<---------------------8<-------------8<---
> > > > From: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > > > Date: Tue, 2 Apr 2013 10:08:13 -0700
> > > > Subject: [PATCH] clk: Introduce 'clk_round_rate_nearest()'
> > > > 
> > > > Introduce a new API function to round a rate to the closest possible
> > > > rate the HW clock can generate.
> > > > In contrast to 'clk_round_rate()' which works similar, but always returns
> > > > a frequency <= its input rate.
> > > > 
> > > > Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > > > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > > > ---
> > > >  drivers/clk/clk.c   | 43 +++++++++++++++++++++++++++++++++++++++++--
> > > >  include/linux/clk.h | 14 ++++++++++++--
> > > >  2 files changed, 53 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> > > > index dff0373f53c1..faf24d0569df 100644
> > > > --- a/drivers/clk/clk.c
> > > > +++ b/drivers/clk/clk.c
> > > > @@ -1011,8 +1011,9 @@ unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
> > > >   * @rate: the rate which is to be rounded
> > > >   *
> > > >   * Takes in a rate as input and rounds it to a rate that the clk can actually
> > > > - * use which is then returned.  If clk doesn't support round_rate operation
> > > > - * then the parent rate is returned.
> > > > + * use and does not exceed the requested frequency, which is then returned.
> > > > + * If clk doesn't support round_rate operation then the parent rate
> > > > + * is returned.
> > > >   */
> > > >  long clk_round_rate(struct clk *clk, unsigned long rate)
> > > >  {
> > > > @@ -1027,6 +1028,44 @@ long clk_round_rate(struct clk *clk, unsigned long rate)
> > > >  EXPORT_SYMBOL_GPL(clk_round_rate);
> > > >  
> > > >  /**
> > > > + * clk_round_rate_nearest - round the given rate for a clk
> > > > + * @clk: the clk for which we are rounding a rate
> > > > + * @rate: the rate which is to be rounded
> > > > + *
> > > > + * Takes in a rate as input and rounds it to the closest rate that the clk
> > > > + * can actually use which is then returned. If clk doesn't support
> > > > + * round_rate operation then the parent rate is returned.
> > > > + */
> > > > +long clk_round_rate_nearest(struct clk *clk, unsigned long rate)
> > > Why does this function doesn't return an unsigned long when it never
> > > returns a negative value? Ditto for clk_round_rate?
> > 
> > I matched the definition of clk_round_rate(). But you're probably right,
> > it may be the right thing to change clk_round_rate to return an
> > unsigned, but with that being exposed API it would be a risky change.
> Russell, what do you think?
> 
> > > > +{
> > > > +	unsigned long lower, upper, cur, lower_last, upper_last;
> > > > +
> > > > +	lower = clk_round_rate(clk, rate);
> > > > +	if (lower >= rate)
> > > > +		return lower;
> > > Is the >-case worth a warning?
> > 
> > No, it's correct behavior. If you request a rate that is way lower than what the
> > clock can generate, returning something larger is perfectly valid, IMHO.
> > Which reveals one problem in this whole discussion. The API does not
> > require clk_round_rate() to round down. It is actually an implementation
> > choice that had been made for clk-divider.
> I'm sure it's more than an implementation choice for clk-divider. But I
> don't find any respective documentation (but I didn't try hard).

A similar discussion - without final conclusion:
https://lkml.org/lkml/2010/7/14/260

> 
> 
> > > > +
> > > > +	upper = clk_round_rate(clk, rate + rate - lower);
> > > This was parenthesized in my original patch on purpose. If rate is big
> > > 
> > > 	rate + rate - lower
> > > 
> > > might overflow when
> > > 
> > > 	rate + (rate - lower)
> > > 
> > > doesn't. Thinking again, there is no real problem, because this is
> > > unsigned arithmetic. To be save we still need to check if rate + (rate -
> > > lower) overflows.
> > 
> > Good point. I'll add the parentheses.
> > 
> > > 
> > > > +	if (upper == lower)
> > > if (upper <= rate) is the better check here. (= would be a bug.)
> > 
> > I don't understand. Passing rate + x to round rate can never return
> > something below 'lower'. Only something in the range [lower,lower+x].
> > So, if upper == lower we found our closest frequency and return it.
> > Otherwise we have to iterate over [lower+1,upper]. Or what did I miss?
> Assuming a correct implementation of clk_round_rate there is no
> difference. Checking for <= rate is just a bit more robust for broken
> implementations.
> 
> > > > +		return upper;
> > > > +
> > > > +	lower = rate + 1;
> > > ok, so your loop invariant is that the best freq is in [lower; upper].
> > 
> > right.
> > 
> > > 
> > > > +	do {
> > > > +		upper_last = upper;
> > > > +		lower_last = lower;
> > > > +
> > > > +		cur = clk_round_rate(clk, lower + ((upper - lower) >> 1));
> > > > +		if (cur < lower)
> > > > +			lower += (upper - lower) >> 1;
> > > You already know that lower + ((upper - lower) >> 1) is too small, so
> > > you can better do
> > > 
> > > 	lower += ((upper - lower) >> 1) + 1;
> > 
> > right. I'll add the '+1'
> > 
> > > 
> > > > +		else
> > > > +			upper = cur;
> > > > +
> > > > +	} while (lower_last != lower && upper_last != upper);
> > > > +
> > > > +	return upper;
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(clk_round_rate_nearest);
> > > I think the function still has potential for optimisation, what about:
> > 
> > At first glance, I don't see many differences except for the comments
> > you made above. I'll have a closer look though.
> I would expect my variant to result in more effective code as it has
> simpler expressions.
> 
> > > unsigned long clk_round_rate_nearest(struct clk *clk, unsigned long rate)
> > > {
> > > 	unsigned long lower, upper, rounded;
> > > 
> > > 	rounded = clk_round_rate(clk, rate);
> > > 
> > > 	if (rounded >= rate)
> > > 		return rounded;
> > > 
> > > 	/*
> > > 	 * rounded is the best approximation for rate that is not
> > > 	 * bigger than rate. If there is a better one, it must be in the
> > > 	 * interval (rate; rate + (rate - rounded)).
> > > 	 * Note that the upper limit isn't better than rate itself, so
> > > 	 * that one doesn't need to be considered.
> > > 	 */
> > > 	 
> > > 	upper = rate + (rate - rounded) - 1;
> > > 	if (upper < rate)
> > > 		upper = ULONG_MAX; 
> > 
> > Aren't we done here? Your search for an upper boundary resulted in
> > 'lower'. Hence there is no valid frequency closer to 'rate' than 'lower'. Why do
> > you extend to ULONG_MAX?
> Consider a clock that can do (assuming ULONG_MAX = 4294967295):
> 
> 	12000, 4294967285
> 
> and you call
> 
> 	clk_round_rate_nearest(clk, 4294967283)
> 
> Then we have:
> 
> 	rounded = clk_round_rate(clk, 4294967283) = 12000.
> 	upper = 4294955269
> 
> because the addition overflowed upper is smaller than rate. Still we
> want to find rate=4294967285, right?

Ah, now I see the problem. Thanks. Due to the return type being long, I
kinda assumed that we operate far away from an overflow and should be
pretty much safe. Taking an overflow into account complicates things a
bit. I give this another look.

 	Sören

