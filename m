Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbaEOO2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:28:14 -0400
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:54584
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752793AbaEOO2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:28:10 -0400
Date: Thu, 15 May 2014 07:10:50 -0700
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
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140515073816.GI16662@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <ad94b743-b3f7-4fb7-b26f-03127ca38d2b@BY2FFO11FD049.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(51704005)(189002)(199002)(377424004)(164054003)(24454002)(92726001)(76176999)(50466002)(33646001)(85852003)(99396002)(46102001)(74316001)(86362001)(53416003)(23676002)(92566001)(83322001)(87936001)(47776003)(83072002)(31696002)(81542001)(44976005)(19580405001)(20776003)(19580395003)(76482001)(83506001)(80022001)(50986999)(85182001)(85202002)(79102001)(15975445006)(81342001)(74502001)(74662001)(31966008)(77982001)(54356999)(4396001)(70736001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB056;H:xsj-gw1;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Forefront-PRVS: 0212BDE3BE
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Thu, 2014-05-15 at 09:38AM +0200, Uwe Kleine-König wrote:
> Hello,
> 
> it's great you pick that up.
> 
> On Wed, May 14, 2014 at 03:30:52PM -0700, Soren Brinkmann wrote:
> > Introduce a new API function to round a rate to the closest possible
> > rate the HW clock can generate.
> > In contrast to 'clk_round_rate()' which works similar, but always returns
> > a frequency <= its input rate.
> > 
> > The code comes from Uwe and was copied from this LKML thread:
> > https://lkml.org/lkml/2013/3/21/115
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> > 
> >  drivers/clk/clk.c   | 26 ++++++++++++++++++++++++--
> >  include/linux/clk.h | 14 ++++++++++++--
> >  2 files changed, 36 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> > index dff0373f53c1..b715f5a9826c 100644
> > --- a/drivers/clk/clk.c
> > +++ b/drivers/clk/clk.c
> > @@ -1011,8 +1011,9 @@ unsigned long __clk_round_rate(struct clk *clk, unsigned long rate)
> >   * @rate: the rate which is to be rounded
> >   *
> >   * Takes in a rate as input and rounds it to a rate that the clk can actually
> > - * use which is then returned.  If clk doesn't support round_rate operation
> > - * then the parent rate is returned.
> > + * use and does not exceed the requested frequency, which is then returned.
> > + * If clk doesn't support round_rate operation then the parent rate
> > + * is returned.
> >   */
> >  long clk_round_rate(struct clk *clk, unsigned long rate)
> >  {
> > @@ -1027,6 +1028,27 @@ long clk_round_rate(struct clk *clk, unsigned long rate)
> >  EXPORT_SYMBOL_GPL(clk_round_rate);
> >  
> >  /**
> > + * clk_round_rate_nearest - round the given rate for a clk
> > + * @clk: the clk for which we are rounding a rate
> > + * @rate: the rate which is to be rounded
> > + *
> > + * Takes in a rate as input and rounds it to the closest rate that the clk
> > + * can actually use which is then returned. If clk doesn't support
> > + * round_rate operation then the parent rate is returned.
> > + */
> > +long clk_round_rate_nearest(struct clk *clk, unsigned long rate)
> > +{
> > +	long lower_limit = clk_round_rate(clk, rate);
> > +	long upper_limit = clk_round_rate(clk, rate + (rate - lower_limit));
> > +
> > +	if (rate - lower_limit < upper_limit - rate)
> > +		return lower_limit;
> > +	else
> > +		return upper_limit;
> I wanted to suggest to add some comment to describe why the calculation
> works here. While trying to proove it, I noticed that this
> implementation is buggy.
> Consider a clock that can provide the following frequencies: 38000,
> 38401, 38600.
> 
> 	clk_round_rate_nearest(clk, 38400)
> 	  lower_limit = clk_round_rate(clk, 38400) -> 38000
> 	  upper_limit = clk_round_rate(clk, 38800) -> 38600
> 
> 	  return 38600
> 
> but 38401 would have been the better/correct answer. I think you cannot
> implement clk_round_rate_nearest without iteration if you don't want to
> add specific logic to the clock providers.

You're right. Apparently we haven't had such a case. Anyway, this needs
to be implemented differently.

	Thanks,
	Sören

