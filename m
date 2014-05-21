Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbaEUHfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 03:35:12 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34601 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaEUHfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 03:35:10 -0400
Date: Wed, 21 May 2014 09:34:57 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-pm@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Michal Simek <michal.simek@xilinx.com>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 2/5] clk: Introduce 'clk_round_rate_nearest()'
Message-ID: <20140521073457.GD31687@pengutronix.de>
References: <1400106655-22465-1-git-send-email-soren.brinkmann@xilinx.com>
 <1400106655-22465-3-git-send-email-soren.brinkmann@xilinx.com>
 <20140515073816.GI16662@pengutronix.de>
 <91822600-39d0-4e71-b0f5-9eda35b76ec0@BN1AFFO11FD016.protection.gbl>
 <20140519161949.GG16662@pengutronix.de>
 <db8633e5-01a9-4d3a-80e8-74e23a456d52@BN1BFFO11FD051.protection.gbl>
 <20140520073358.GJ16662@pengutronix.de>
 <4bb5f44a-60bb-4e34-8f88-f91b8419be8d@BL2FFO11FD050.protection.gbl>
 <537B957B.5010001@codeaurora.org>
 <668683e3-856e-4f30-9b11-8f3e91e12d1d@BL2FFO11FD038.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <668683e3-856e-4f30-9b11-8f3e91e12d1d@BL2FFO11FD038.protection.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 20, 2014 at 02:48:20PM -0700, Sören Brinkmann wrote:
> On Tue, 2014-05-20 at 10:48AM -0700, Stephen Boyd wrote:
> > On 05/20/14 09:01, Sören Brinkmann wrote:
> > >
> > >>>>> +{
> > >>>>> +	unsigned long lower, upper, cur, lower_last, upper_last;
> > >>>>> +
> > >>>>> +	lower = clk_round_rate(clk, rate);
> > >>>>> +	if (lower >= rate)
> > >>>>> +		return lower;
> > >>>> Is the >-case worth a warning?
> > >>> No, it's correct behavior. If you request a rate that is way lower than what the
> > >>> clock can generate, returning something larger is perfectly valid, IMHO.
> > >>> Which reveals one problem in this whole discussion. The API does not
> > >>> require clk_round_rate() to round down. It is actually an implementation
> > >>> choice that had been made for clk-divider.
> > >> I'm sure it's more than an implementation choice for clk-divider. But I
> > >> don't find any respective documentation (but I didn't try hard).
> > > A similar discussion - without final conclusion:
> > > https://lkml.org/lkml/2010/7/14/260
> > >
> > >
> > 
> > Please call this new API something like clk_find_nearest_rate() or
> > something. clk_round_rate() is supposed to return the rate that will be
> > set if you call clk_set_rate() with the same arguments. It's up to the
> > implementation to decide if that means rounding the rate up or down or
> > to the nearest value.
> 
> Sounds good to me. Are there any cases of clocks that round up? I think
> that case would not be handled correctly. But I also don't see a use
> case for such an implementation.
I don't really care which semantic (i.e. round up, round down or round
closest) is picked, but I'd vote that all should pick up the same. I
think the least surprising definition is to choose rounding down and add
the function that is under discussion here to get a nearest match.

So I suggest:

	- if round_rate is given a rate that is smaller than the
	  smallest available rate, return 0
	- add WARN_ONCE to round_rate and set_rate if they return with a
	  rate bigger than requested
	- change the return values to unsigned long

Do we also need a round_up implementation?

Mike? Russell? Any thoughts from your side?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
