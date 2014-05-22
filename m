Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaEVXrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 19:47:21 -0400
Received: from mail-bn1lp0139.outbound.protection.outlook.com ([207.46.163.139]:2795
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751243AbaEVXrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 19:47:19 -0400
Date: Thu, 22 May 2014 16:44:53 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>
CC: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>, <linux-pm@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Michal Simek <michal.simek@xilinx.com>, <cpufreq@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 2/5] clk: Introduce 'clk_round_rate_nearest()'
References: <537B957B.5010001@codeaurora.org>
 <668683e3-856e-4f30-9b11-8f3e91e12d1d@BL2FFO11FD038.protection.gbl>
 <20140521073457.GD31687@pengutronix.de>
 <e9090453-ce40-4662-a3ea-fbdaffdb2aa4@BN1AFFO11FD046.protection.gbl>
 <20140521182308.GN31687@pengutronix.de> <20140521203300.9521.67546@quantum>
 <ac335a38-b0f4-4d95-b111-56c05e1a6234@BN1BFFO11FD045.protection.gbl>
 <20140522182040.GB20155@pengutronix.de>
 <6612b069-1228-488f-81f7-ea8839f6c468@BN1BFFO11FD029.protection.gbl>
 <20140522210328.9521.34889@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140522210328.9521.34889@quantum>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <a86642cb-855f-455f-b07c-a52bc6aa426f@BN1BFFO11FD050.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(24454002)(51704005)(377424004)(479174003)(199002)(189002)(164054003)(15975445006)(86362001)(87936001)(76482001)(92566001)(85202002)(92726001)(83506001)(85182001)(19580395003)(80022001)(31696002)(44976005)(83322001)(102836001)(99396002)(64706001)(20776003)(50986999)(54356999)(76176999)(33646001)(47776003)(74662001)(53416003)(74502001)(31966008)(79102001)(81342001)(81542001)(85852003)(83072002)(77982001)(50466002)(70736001)(21056001)(23676002)(4396001)(74316001)(46102001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB011;H:xsj-gw1;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Forefront-PRVS: 021975AE46
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-22 at 02:03PM -0700, Mike Turquette wrote:
> Quoting Sören Brinkmann (2014-05-22 13:32:09)
> > On Thu, 2014-05-22 at 08:20PM +0200, Uwe Kleine-König wrote:
> > > Hello Sören,
> > > 
> > > On Thu, May 22, 2014 at 11:03:00AM -0700, Sören Brinkmann wrote:
> > > > On Wed, 2014-05-21 at 01:33PM -0700, Mike Turquette wrote:
> > > > > Quoting Uwe Kleine-König (2014-05-21 11:23:08)
> > > > > > Hello Sören,
> > > > > > 
> > > > > > On Wed, May 21, 2014 at 08:58:10AM -0700, Sören Brinkmann wrote:
> > > > > > > On Wed, 2014-05-21 at 09:34AM +0200, Uwe Kleine-König wrote:
> > > > > > > > On Tue, May 20, 2014 at 02:48:20PM -0700, Sören Brinkmann wrote:
> > > > > > > > > On Tue, 2014-05-20 at 10:48AM -0700, Stephen Boyd wrote:
> > > > > > > > > > On 05/20/14 09:01, Sören Brinkmann wrote:
> > > > > > > > > > >
> > > > > > > > > > >>>>> +{
> > > > > > > > > > >>>>> + unsigned long lower, upper, cur, lower_last, upper_last;
> > > > > > > > > > >>>>> +
> > > > > > > > > > >>>>> + lower = clk_round_rate(clk, rate);
> > > > > > > > > > >>>>> + if (lower >= rate)
> > > > > > > > > > >>>>> +         return lower;
> > > > > > > > > > >>>> Is the >-case worth a warning?
> > > > > > > > > > >>> No, it's correct behavior. If you request a rate that is way lower than what the
> > > > > > > > > > >>> clock can generate, returning something larger is perfectly valid, IMHO.
> > > > > > > > > > >>> Which reveals one problem in this whole discussion. The API does not
> > > > > > > > > > >>> require clk_round_rate() to round down. It is actually an implementation
> > > > > > > > > > >>> choice that had been made for clk-divider.
> > > > > > > > > > >> I'm sure it's more than an implementation choice for clk-divider. But I
> > > > > > > > > > >> don't find any respective documentation (but I didn't try hard).
> > > > > > > > > > > A similar discussion - without final conclusion:
> > > > > > > > > > > https://lkml.org/lkml/2010/7/14/260
> > > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > 
> > > > > > > > > > Please call this new API something like clk_find_nearest_rate() or
> > > > > > > > > > something. clk_round_rate() is supposed to return the rate that will be
> > > > > > > > > > set if you call clk_set_rate() with the same arguments. It's up to the
> > > > > > > > > > implementation to decide if that means rounding the rate up or down or
> > > > > > > > > > to the nearest value.
> > > > > > > > > 
> > > > > > > > > Sounds good to me. Are there any cases of clocks that round up? I think
> > > > > > > > > that case would not be handled correctly. But I also don't see a use
> > > > > > > > > case for such an implementation.
> > > > > > > > I don't really care which semantic (i.e. round up, round down or round
> > > > > > > > closest) is picked, but I'd vote that all should pick up the same. I
> > > > > > > > think the least surprising definition is to choose rounding down and add
> > > > > > > > the function that is under discussion here to get a nearest match.
> > > > > > > > 
> > > > > > > > So I suggest:
> > > > > > > > 
> > > > > > > >     - if round_rate is given a rate that is smaller than the
> > > > > > > >       smallest available rate, return 0
> > > > > > > >     - add WARN_ONCE to round_rate and set_rate if they return with a
> > > > > > > >       rate bigger than requested
> > > > > > > 
> > > > > > > Why do you think 0 is always valid? I think for a clock that can
> > > > > > > generate 40, 70, 120, clk_round_rate(20) should return 40.
> > > > > > I didn't say it's a valid value. It just makes the it possible to check
> > > > > > for clk_round_rate(clk, rate) <= rate.
> > > > > > 
> > > > > > I grepped a bit around and found da850_round_armrate which implements a
> > > > > > round_rate callback returning the best match.
> > > > > > omap1_clk_round_rate_ckctl_arm can return a value < 0.
> > > > > > s3c2412_roundrate_usbsrc can return values that are bigger than
> > > > > > requested. (I wonder if that is a bug though.)
> > > > > > 
> > > > > > > >     - change the return values to unsigned long
> > > > > > > 
> > > > > > > Yep, I agree, this should happen.
> > > > > > And we're using 0 as error value? e.g. for the case where
> > > > > > omap1_clk_round_rate_ckctl_arm returns -EIO now?
> > > > > 
> > > > > No. clk_round_rate returns long for a reason, which is that we can
> > > > > provide an error code to the caller. From include/linux/clk.h:
> > > > > 
> > > > > /**
> > > > >  * clk_round_rate - adjust a rate to the exact rate a clock can provide
> > > > >  * @clk: clock source
> > > > >  * @rate: desired clock rate in Hz
> > > > >  *
> > > > >  * Returns rounded clock rate in Hz, or negative errno.
> > > > >  */
> > > > > 
> > > > > This has the unfortunate side effect that the max value we can return
> > > > > safely is 2147483647 (~2GHz). So another issue here is converting clock
> > > > > rates to 64-bit values.
> > > > 
> > > > So, let's assume
> > > >  - a clock does either of these
> > > >    - round down
> > > >    - round nearest
> > > >    - round up (is there any such case? I don't see a use-case for this)
> > > >  - or return an error
> > > > 
> > > > I think my latest try handles such cases, with the limitation of
> > > > for a clock that rounds up, the up-rounded value is found instead of the
> > > > nearest.
> > > > 
> > > > 
> > > > static long clk_find_nearest_rate(struct clk *clk, unsigned long rate)
> > > > {
> > > >     long ret;
> > > >     unsigned long lower, upper;
> > > > 
> > > >     clk_prepare_lock();
> > > > 
> > > >     lower = __clk_round_rate(clk, rate);
> > > this is CCF specific while I don't see a need for it. (But yes, a
> > > lock-less clk_find_nearest_rate is of course racy.)
> > Do we have to support non-CCF implementations? Isn't switching to the
> > CCF encouraged?
> 
> No we don't. If you check out the ifdeffery in include/linux/clk.h
> you'll see more function declarations for CONFIG_COMMON_CLK then for
> !CONFIG_COMMON_CLK, so we're not breaking any ground here.
> 
> > 
> > > 
> > > >     if (lower >= rate || (long)lower < 0) {
> > > If you made lower and upper a signed long, you could drop the casting
> > > here. BTW, why does __clk_round_rate return an unsigned long??
> > > There seem to be several more type mismatches in that area.
> > > Maybe we should add a waring if rate is > LONG_MAX?
> > > 
> > > (And ISTR that the C standard doesn't specify what the result of
> > > (long)lower is given that lower is of type unsigned long and holding a
> > > value > LONG_MAX.)
> > Looks like you're right. This probably needs some polishing to get types
> > sorted out.
> > Mike/Russel: As Uwe pointed out, shouldn't __clk_round_rate return a
> > long as well?

Sorry, Russell, of course.

> 
> Yeah. The strange thing is that .round_rate and .determine_rate both
> return long. I think I was asleep at the wheel on this one.
> 
> I count about a dozen call sites that need to be fixed up for this
> change to happen. As we approach 3.15-rc6 I'm a bit nervous about
> introducing this change. How do you feel about dropping this change in
> first thing after 3.16-rc1 and layering in your new clk_find_*_rate
> stuff on top of it?
> 
> I'll take a stab at fixing up __clk_round_rate early next week.

Yeah, at some point this 'fix cpufreq stats'-series grew a little out of
control. Targeting the 3.16 cycle sounds reasonable. Then we could probably
also look at moving from (unsigned) long to some 64-bit type as well ;)

	Thanks,
	Sören

