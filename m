Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab3LBLC4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 06:02:56 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47296 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753512Ab3LBLCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 06:02:50 -0500
Date: Mon, 2 Dec 2013 11:02:44 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        "r65073@freescale.com" <r65073@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "t.figa@samsung.com" <t.figa@samsung.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Alison Wang <b18965@freescale.com>,
        Jingchang Lu <b35083@freescale.com>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: Re: [PATCHv6 1/4] pwm: Add Freescale FTM PWM driver support
Message-ID: <20131202110243.GD12952@e106331-lin.cambridge.arm.com>
References: <1384220218-12716-1-git-send-email-Li.Xiubo@freescale.com>
 <1384220218-12716-2-git-send-email-Li.Xiubo@freescale.com>
 <20131128212510.GC14689@mithrandir>
 <20131128223719.GG14689@mithrandir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131128223719.GG14689@mithrandir>
Thread-Topic: [PATCHv6 1/4] pwm: Add Freescale FTM PWM driver support
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Nov 28, 2013 at 10:37:19PM +0000, Thierry Reding wrote:
> On Thu, Nov 28, 2013 at 10:25:11PM +0100, Thierry Reding wrote:
> > On Tue, Nov 12, 2013 at 09:36:55AM +0800, Xiubo Li wrote:
> [...]
> > > +static int fsl_pwm_parse_clk_ps(struct fsl_pwm_chip *fpc)
> > > +{
> > > +	int ret;
> > > +	struct of_phandle_args clkspec;
> > > +	struct device_node *np = fpc->chip.dev->of_node;
> > > +
> > > +	fpc->sys_clk = devm_clk_get(fpc->chip.dev, "ftm0");
> > > +	if (IS_ERR(fpc->sys_clk)) {
> > > +		ret = PTR_ERR(fpc->sys_clk);
> > > +		dev_err(fpc->chip.dev,
> > > +				"failed to get \"ftm0\" clock %d\n", ret);
> > > +		return ret;
> > > +	}
> > > +
> > > +	fpc->counter_clk = devm_clk_get(fpc->chip.dev, "ftm0_counter");
> > > +	if (IS_ERR(fpc->counter_clk)) {
> > > +		ret = PTR_ERR(fpc->counter_clk);
> > > +		dev_err(fpc->chip.dev,
> > > +				"failed to get \"ftm0_counter\" clock %d\n",
> > > +				ret);
> > > +		return ret;
> > > +	}
> > > +
> > > +	ret = of_parse_phandle_with_args(np, "clocks", "#clock-cells", 1,
> > > +					&clkspec);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	fpc->counter_clk_select = clkspec.args[0];
> > 
> > This isn't at all pretty. But given that once you have access to a
> > struct clk there's no way to identify it, I don't know of a better
> > alternative.
> 
> Hi Mike,
> 
> I've seen this crop up a number of times now, to varying degrees of
> gravity. In this particular case, the driver needs to know the type of a
> clock because it needs to program this hardware differently depending on
> which clock feeds the counter. Since there is no way to obtain any kind
> of identifying information from a struct clk, drivers need to rely on
> hacks like this and manually reach into the device tree to obtain that
> information.

Which property of the clock is the consumer concerned with in this case?

>From a quick look at the driver it looks like there are actually a
number of different input lines to the device that share the clock-name
"ftm0_counter", though they are actually separate and each has a
different divider. Have I got that right?

If that's the case, having a unique clock-names value for each of those
lines would be the solution I'd expect. Then you just have to list the
one(s) that are wired up, and the driver can figure out the appropriate
line to use either by requesting by name until it finds a match or
inspecting the clock-names property.

Is there some other property of the parent that we care about here?

> 
> I'm aware of similar cases which have been solved by using a mux clock
> that takes a set of parents and the .set_parent() operation is then used
> to program registers appropriately. However in all those cases, the mux
> clock (and the parents) have all been part of a single driver, so I am
> not sure if the same would be applicable here.
> 
> Do you have any other suggestions on how this could possibly be solved?

This also feels like the case I describe above. What am I missing? :)

Thanks,
Mark.
