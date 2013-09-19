Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3ISQop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 12:44:45 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:61984 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab3ISQon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 12:44:43 -0400
Date: Thu, 19 Sep 2013 09:44:38 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Hyun Kwon <hyunk@xilinx.com>
Subject: Re: [PATCH v2] clk: si570: Add a driver for SI570 oscillators
Message-ID: <20130919164438.GA7461@roeck-us.net>
References: <1379544219-23579-1-git-send-email-soren.brinkmann@xilinx.com>
 <20130919131712.GB24088@roeck-us.net>
 <6401b71c-8c18-4735-8b40-9692cd788336@VA3EHSMHS037.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6401b71c-8c18-4735-8b40-9692cd788336@VA3EHSMHS037.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 09:01:01AM -0700, Sören Brinkmann wrote:
> On Thu, Sep 19, 2013 at 06:17:12AM -0700, Guenter Roeck wrote:
> > On Wed, Sep 18, 2013 at 03:43:38PM -0700, Soren Brinkmann wrote:
> > > Add a driver for SILabs 570, 571, 598, 599 programmable oscillators.
> > > The devices generate low-jitter clock signals and are reprogrammable via
> > > an I2C interface.
> > > 

[...]
> > > +static unsigned long si570_recalc_rate(struct clk_hw *hw,
> > > +		unsigned long parent_rate)
> > > +{
> > > +	int err;
> > > +	u64 rfreq, rate;
> > > +	unsigned int n1, hs_div;
> > > +	struct clk_si570 *data = to_clk_si570(hw);
> > > +
> > > +	err = si570_get_divs(data, &rfreq, &n1, &hs_div);
> > > +	if (err) {
> > > +		dev_err(&data->i2c_client->dev, "unable to recalc rate\n");
> > 
> > [ Not really helpful that you can not return an error here ]
> IIUC, the CCF does not really support error reporting for this function. I
> think a return value of recalc_rate is always interpreted as frequency.
> Hence, I decided to take the last point of certainty and return the last
> known frequency.
> 
Yes, I wasn't complaining about you, but about the clock infrastructure.

[...]

> > > +static int si570_probe(struct i2c_client *client,
> > > +		const struct i2c_device_id *id)
> > > +{
> > > +	struct clk_si570 *data;
> > > +	struct clk_init_data init;
> > > +	struct clk *clk;
> > > +	u32 initial_fout, factory_fout;
> > > +	int err;
> > > +
> > > +	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
> > > +	if (!data)
> > > +		return -ENOMEM;
> > > +
> > > +	init.ops = &si570_clk_ops;
> > > +	init.flags = CLK_IS_ROOT;
> > > +	init.num_parents = 0;
> > > +	data->hw.init = &init;
> > > +	data->max_freq = id->driver_data;
> > > +	data->i2c_client = client;
> > > +
> > > +	if (of_property_read_bool(client->dev.of_node,
> > > +				"temperature-stability-7ppm"))
> > > +		data->div_offset = SI570_DIV_OFFSET_7PPM;
> > > +
> > Just noticed that you dropped platform data support. Doesn't matter much for me
> > right now, but in my previous company we used the chip on an x86 system which
> > does not support devicetree. Would be nice to keep it and derive platform data
> > from devicetree data if provided, like other drivers do it.
> I'll look into this. The issue I have with that is, I can hardly test it
> since we only use this on Zynq which uses DT. So, I'd rather prefer to
> not include it unless somebody volunteers to test it.
> 
Fair enough. I can not test it myself anymore, and my previous employer
now has a strict non-contributions-to-linux policy, so I guess they won't
test it either or at least not publish any test results. Leave it out.

> > The 7ppm option is only relevant for si570/si751 and not supported on
> > si598/si599. You should mention that in the bindings document and check for it.
> Right, I'll add a note in the doc. And ignore it for devices this does
> not apply.
> 
I would bail out, but that is your call.

> > Even better would be if it can be auto-detected; in that case you would not need
> > the property at all. Unfortunately I don't have access to a chip, so I have
> > no idea if that is possible and can not check it myself either.
> I didn't see any way to detect this during runtime. And we don't have
> such a device either.
> 
Check what the registers return when reading. But yes, you would need access to
the various devices to be sure that the detection works. Wonder if SiLabs
provides samples ... this one would be really nice to have, because it would
enable us to drop the extra property.

> > 
> > > +	if (of_property_read_string(client->dev.of_node, "clock-output-names",
> > > +			&init.name))
> > > +		init.name = client->dev.of_node->name;
> > > +
> > > +	err = of_property_read_u32(client->dev.of_node, "factory-fout",
> > > +			&factory_fout);
> > > +	if (err) {
> > > +		dev_err(&client->dev, "'factory-fout' property missing\n");
> > > +		return err;
> > > +	}
> > > +
> > > +	data->regmap = devm_regmap_init_i2c(client, &si570_regmap_config);
> > > +	if (IS_ERR(data->regmap)) {
> > > +		dev_err(&client->dev, "failed to allocate register map\n");
> > > +		return PTR_ERR(data->regmap);
> > > +	}
> > > +
> > > +	i2c_set_clientdata(client, data);
> > > +	err = si570_get_defaults(data, factory_fout);
> > > +	if (err)
> > > +		return err;
> > > +
> > > +	clk = devm_clk_register(&client->dev, &data->hw);
> > > +	if (IS_ERR(clk)) {
> > > +		dev_err(&client->dev, "clock registration failed\n");
> > > +		return PTR_ERR(clk);
> > > +	}
> > > +	err = of_clk_add_provider(client->dev.of_node, of_clk_src_simple_get,
> > > +			clk);
> > > +	if (err) {
> > > +		dev_err(&client->dev, "unable to add clk provider\n");
> > > +		return err;
> > > +	}
> > > +
> > > +	/*
> > > +	 * Read the requested initial fout from either platform data or the
> > > +	 * device tree
> > > +	 */
> > 
> > But you don't do anything with platform data.
> copy&paste error. I'll remove it.
> 
> > 
> > > +	if (!of_property_read_u32(client->dev.of_node, "clock-frequency",
> > > +				&initial_fout)) {
> > > +		err = clk_set_rate(clk, initial_fout);
> > > +		if (err)
> > > +			dev_warn(&client->dev,
> > > +					"unable to set initial output frequency %u: %d\n",
> > > +					initial_fout, err);
> > 
> > No bailout ?
> > 
> > Also it seems that this generates two error messages, once in the code which
> > experiences the error and once here.
> I remove the message here.
> 
> > 
> > Maybe it would be better to just bail out and return the error.
> > After all, something is seriously wrong and the system won't operate
> > as specified.
> I do more think of a spurious error (typo in DT prop giving an f out of
> range,...)  and a driver actually controlling this clock generator later.
> In that case later calls to clk_set_rate() might succeed and everything's
> fine or the driver can handle the error. In case of using this device as
> a fixed clock, bailing out here might make more sense though. I'd prefer
> leaving it like this.
> 
A typo in dt data isn't really a spurious error, and it would be easy to fix.
I would suggest to bail out; this ensures that the devicetree data is correct.

Guenter
