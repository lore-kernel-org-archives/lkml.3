Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699AbaLJPAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:00:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54162 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757663AbaLJPAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:00:07 -0500
Message-ID: <1418223593.3258.10.camel@pengutronix.de>
Subject: Re: [PATCH v3] clk: Add PWM clock driver
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Janusz =?UTF-8?Q?U=C5=BCycki?= <j.uzycki@elproma.com.pl>
Cc: Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org
Date: Wed, 10 Dec 2014 15:59:53 +0100
In-Reply-To: <54872810.7000700@elproma.com.pl>
References: <1418138392-17081-1-git-send-email-p.zabel@pengutronix.de>
	 <54872810.7000700@elproma.com.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Janusz,

thank you for the comments.

Am Dienstag, den 09.12.2014, 17:49 +0100 schrieb Janusz Użycki:
[...]
> > +int clk_pwm_probe(struct platform_device *pdev)
> > +{
> > +	struct device_node *node = pdev->dev.of_node;
> > +	struct clk_init_data init;
> > +	struct clk_pwm *clk_pwm;
> > +	struct pwm_device *pwm;
> > +	const char *clk_name;
> > +	struct clk *clk;
> > +	int ret;
> > +
> > +	clk_pwm = devm_kzalloc(&pdev->dev, sizeof(*clk_pwm), GFP_KERNEL);
> > +	if (!clk_pwm)
> > +		return -ENOMEM;
> > +
> > +	pwm = devm_pwm_get(&pdev->dev, NULL);
> 
> NULL or clk_name ?

There's only one pwm input to the pwm-clock, so I see no need to use a
con_id here and require the pwm-names device tree property to be set.

> > +	if (IS_ERR(pwm))
> > +		return PTR_ERR(pwm);
> > +
> > +	if (!pwm || !pwm->period) {
> > +		dev_err(&pdev->dev, "invalid pwm period\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (of_property_read_u32(node, "clock-frequency", &clk_pwm->fixed_rate))
> > +		clk_pwm->fixed_rate = 1000000000 / pwm->period;
> 
> You can use NSEC_PER_SEC instead of the hardcoded value.

Thanks, I'll fix that.

> > +
> > +	if (pwm->period != 1000000000 / clk_pwm->fixed_rate &&
> > +	    pwm->period != DIV_ROUND_UP(1000000000, clk_pwm->fixed_rate)) {
> > +		dev_err(&pdev->dev,
> > +			"clock-frequency does not match pwm period\n");
> > +		return -EINVAL;
> > +	}
> 
> This can't prevent against buggy pwm driver (bad frequency)
> because there is not function to read the period back, ie.
> .pwm_config callback does not modify duty_ns and period_ns to real 
> values indeed.

Of course, this is only to make sure that the clock-frequency and pwm
duty cycle are roughly the same.

> There is the way to set directly
>          pwm->period = NSEC_PER_SEC / clk_pwm>fixed_rate;
> instead of third argument (period_ns) of pwms. Although the argument is 
> required
> (#pwm-cells >= 2 and *_xlate_* functions) it could be set to 0 in pwms.
> Such calculation should be right for most PWMs if they are clocked not 
> faster
> than eg. 40MHz. Above div-round issue can appear but it also appears due 
> to ns resolution.
> I can't point if this is the best solution for the future.
> 
> > +
> > +	ret = pwm_config(pwm, (pwm->period + 1) >> 1, pwm->period);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	clk_name = node->name;
> > +	of_property_read_string(node, "clock-output-names", &clk_name);
> > +
> > +	init.name = clk_name;
> > +	init.ops = &clk_pwm_ops;
> > +	init.flags = CLK_IS_ROOT;
> 
> and what about CLK_IS_BASIC?

Yes, I'll add that.

> > +	init.num_parents = 0;
> 
> Is it proof against suspend/resume race of pwm driver vs pwm-clock's 
> customer?
> Otherwise chain of clocks can be broken.

Are there pwm drivers that disable pwm output in their suspend callback?
I don't think system wide suspend/resume ordering can protect against
that at all, since the two devices may be on completely different buses.
In that case it'd probably be best to use runtime pm to keep the pwm
activated until clk_disable/pwm_disable is called by the consumer.

[...]
> > +static struct platform_driver clk_pwm_driver = {
> > +	.probe = clk_pwm_probe,
> 
> missing
>                  .remove = clk_pwm_remove,
> 
> > +	.driver = {
> > +		.name = "pwm-clock",
> > +		.owner = THIS_MODULE,
> 
> .owner could be removed (not a problem now)

Will add and remove those, respectively.

> > +		.of_match_table = of_match_ptr(clk_pwm_dt_ids),
> > +	},
> 
> Why doesn't mcp251x trigger probe of pwm-clock driver?
> The fixed-clock uses CLK_OF_DECLARE which defines .data
> of of_device_id instead of .probe. Unfortunately I'm not so much 
> familiar with DT.
> Any idea?

Did you add "simple-bus" to the clocks node compatible? The pwm-clock
device tree node needs to be placed somewhere where of_platform_populate
will consider it.

regards
Philipp

