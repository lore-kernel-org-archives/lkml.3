Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab3ISQCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 12:02:24 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:25770
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752780Ab3ISQCW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 12:02:22 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275ch1de098h1de097h84d07h8275bhz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh906i1155h192ch)
Date: Thu, 19 Sep 2013 09:01:01 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Hyun Kwon <hyunk@xilinx.com>
Subject: Re: [PATCH v2] clk: si570: Add a driver for SI570 oscillators
References: <1379544219-23579-1-git-send-email-soren.brinkmann@xilinx.com>
 <20130919131712.GB24088@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130919131712.GB24088@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <6401b71c-8c18-4735-8b40-9692cd788336@VA3EHSMHS037.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 06:17:12AM -0700, Guenter Roeck wrote:
> On Wed, Sep 18, 2013 at 03:43:38PM -0700, Soren Brinkmann wrote:
> > Add a driver for SILabs 570, 571, 598, 599 programmable oscillators.
> > The devices generate low-jitter clock signals and are reprogrammable via
> > an I2C interface.
> > 
> > Cc: Guenter Roeck <linux@roeck-us.net>
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> > v2:
> >  - document clock-output-names in bindings documentation
> >  - don't use wildcards in compatibility string
> >  - change Kconfig entry to "... 570 and compatible devices"
> >  - change some indentation flaws
> >  - use 10000 as MIN and MAX value in usleep_range
> >  - fail probe() if 'factory-fout' is not provided in DT
> >    - default factory fout #defines removed
> >  - use i2c driver_data instead of OF data
> >    - remove some related structs and data
> >  - rename DT property 'initial-fout' => 'clock-frequency' (like si5351
> >    driver)
> >  - add some more details regarding the 'factory-fout' DT property
> > 
> >  .../devicetree/bindings/clock/silabs,si570.txt     |  38 ++
> >  drivers/clk/Kconfig                                |  10 +
> >  drivers/clk/Makefile                               |   1 +
> >  drivers/clk/clk-si570.c                            | 517 +++++++++++++++++++++
> >  4 files changed, 566 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/clock/silabs,si570.txt
> >  create mode 100644 drivers/clk/clk-si570.c
> > 
[...]
> > diff --git a/drivers/clk/clk-si570.c b/drivers/clk/clk-si570.c
> > new file mode 100644
> > index 0000000..c20dfce
> > --- /dev/null
> > +++ b/drivers/clk/clk-si570.c
[...]
> > +static unsigned long si570_recalc_rate(struct clk_hw *hw,
> > +		unsigned long parent_rate)
> > +{
> > +	int err;
> > +	u64 rfreq, rate;
> > +	unsigned int n1, hs_div;
> > +	struct clk_si570 *data = to_clk_si570(hw);
> > +
> > +	err = si570_get_divs(data, &rfreq, &n1, &hs_div);
> > +	if (err) {
> > +		dev_err(&data->i2c_client->dev, "unable to recalc rate\n");
> 
> [ Not really helpful that you can not return an error here ]
IIUC, the CCF does not really support error reporting for this function. I
think a return value of recalc_rate is always interpreted as frequency.
Hence, I decided to take the last point of certainty and return the last
known frequency.

> 
> > +		return data->frequency;
> > +	}
> > +
> > +	rfreq = div_u64(rfreq, hs_div * n1);
> > +	rate = (data->fxtal * rfreq) >> 28;
> > +
> > +	return rate;
> > +}
[...]
> > +static int si570_set_rate(struct clk_hw *hw, unsigned long rate,
> > +		unsigned long parent_rate)
> > +{
> > +	struct clk_si570 *data = to_clk_si570(hw);
> > +	struct i2c_client *client = data->i2c_client;
> > +	int err;
> > +
> > +	if (rate < SI570_MIN_FREQ || rate > data->max_freq) {
> > +		dev_warn(&client->dev,
> > +			"requested frequency %lu Hz is out of range\n", rate);
> 
> Shouldn't this be dev_err ?
You're probably right. I'll change this.

> 
> > +		return -EINVAL;
> > +	}
[...]
> > +static int si570_probe(struct i2c_client *client,
> > +		const struct i2c_device_id *id)
> > +{
> > +	struct clk_si570 *data;
> > +	struct clk_init_data init;
> > +	struct clk *clk;
> > +	u32 initial_fout, factory_fout;
> > +	int err;
> > +
> > +	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
> > +	if (!data)
> > +		return -ENOMEM;
> > +
> > +	init.ops = &si570_clk_ops;
> > +	init.flags = CLK_IS_ROOT;
> > +	init.num_parents = 0;
> > +	data->hw.init = &init;
> > +	data->max_freq = id->driver_data;
> > +	data->i2c_client = client;
> > +
> > +	if (of_property_read_bool(client->dev.of_node,
> > +				"temperature-stability-7ppm"))
> > +		data->div_offset = SI570_DIV_OFFSET_7PPM;
> > +
> Just noticed that you dropped platform data support. Doesn't matter much for me
> right now, but in my previous company we used the chip on an x86 system which
> does not support devicetree. Would be nice to keep it and derive platform data
> from devicetree data if provided, like other drivers do it.
I'll look into this. The issue I have with that is, I can hardly test it
since we only use this on Zynq which uses DT. So, I'd rather prefer to
not include it unless somebody volunteers to test it.

> The 7ppm option is only relevant for si570/si751 and not supported on
> si598/si599. You should mention that in the bindings document and check for it.
Right, I'll add a note in the doc. And ignore it for devices this does
not apply.

> Even better would be if it can be auto-detected; in that case you would not need
> the property at all. Unfortunately I don't have access to a chip, so I have
> no idea if that is possible and can not check it myself either.
I didn't see any way to detect this during runtime. And we don't have
such a device either.

> 
> > +	if (of_property_read_string(client->dev.of_node, "clock-output-names",
> > +			&init.name))
> > +		init.name = client->dev.of_node->name;
> > +
> > +	err = of_property_read_u32(client->dev.of_node, "factory-fout",
> > +			&factory_fout);
> > +	if (err) {
> > +		dev_err(&client->dev, "'factory-fout' property missing\n");
> > +		return err;
> > +	}
> > +
> > +	data->regmap = devm_regmap_init_i2c(client, &si570_regmap_config);
> > +	if (IS_ERR(data->regmap)) {
> > +		dev_err(&client->dev, "failed to allocate register map\n");
> > +		return PTR_ERR(data->regmap);
> > +	}
> > +
> > +	i2c_set_clientdata(client, data);
> > +	err = si570_get_defaults(data, factory_fout);
> > +	if (err)
> > +		return err;
> > +
> > +	clk = devm_clk_register(&client->dev, &data->hw);
> > +	if (IS_ERR(clk)) {
> > +		dev_err(&client->dev, "clock registration failed\n");
> > +		return PTR_ERR(clk);
> > +	}
> > +	err = of_clk_add_provider(client->dev.of_node, of_clk_src_simple_get,
> > +			clk);
> > +	if (err) {
> > +		dev_err(&client->dev, "unable to add clk provider\n");
> > +		return err;
> > +	}
> > +
> > +	/*
> > +	 * Read the requested initial fout from either platform data or the
> > +	 * device tree
> > +	 */
> 
> But you don't do anything with platform data.
copy&paste error. I'll remove it.

> 
> > +	if (!of_property_read_u32(client->dev.of_node, "clock-frequency",
> > +				&initial_fout)) {
> > +		err = clk_set_rate(clk, initial_fout);
> > +		if (err)
> > +			dev_warn(&client->dev,
> > +					"unable to set initial output frequency %u: %d\n",
> > +					initial_fout, err);
> 
> No bailout ?
> 
> Also it seems that this generates two error messages, once in the code which
> experiences the error and once here.
I remove the message here.

> 
> Maybe it would be better to just bail out and return the error.
> After all, something is seriously wrong and the system won't operate
> as specified.
I do more think of a spurious error (typo in DT prop giving an f out of
range,...)  and a driver actually controlling this clock generator later.
In that case later calls to clk_set_rate() might succeed and everything's
fine or the driver can handle the error. In case of using this device as
a fixed clock, bailing out here might make more sense though. I'd prefer
leaving it like this.


	Thanks,
	Sören


