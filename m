Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3ITSrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 14:47:13 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:39247
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752867Ab3ITSrL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 14:47:11 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dIc89bh1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275ch1de098h17326ah1de097h186068h84d07h5eeeK8275bhz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh906i1155h192ch)
Date: Fri, 20 Sep 2013 11:46:24 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Joe Perches <joe@perches.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Hyun Kwon <hyunk@xilinx.com>
Subject: Re: [PATCH v4] clk: si570: Add a driver for SI570 oscillators
References: <1379698757-25232-1-git-send-email-soren.brinkmann@xilinx.com>
 <20130920181529.GA31173@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130920181529.GA31173@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <5dc20100-e481-47f8-b9db-9d0fa9475245@VA3EHSMHS026.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 11:15:29AM -0700, Guenter Roeck wrote:
> On Fri, Sep 20, 2013 at 10:39:17AM -0700, Soren Brinkmann wrote:
> > Add a driver for SILabs 570, 571, 598, 599 programmable oscillators.
> > The devices generate low-jitter clock signals and are reprogrammable via
> > an I2C interface.
> > 
> > Cc: Guenter Roeck <linux@roeck-us.net>
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> > v4:
> >  - actually check and handle error on clk_set_rate() call
> > 
> > v3:
> >  - add delay in the path for small frequency changes, which can take up
> >    to 100us according to the data sheet
> >  - use real range for usleep_range() argument
> >  - use dev_err() over dev_warn() in set_rate()
> >  - add list of applicable devices for 7ppm DT prop
> >  - remove comments regarding platform data
> >  - ignore 7ppm DT prop for incompatible devices
> >  - replace raw numbers with #defines
> >  - convert DT prop 'temperature-stability' from boolean to u32
> >  - make 'temperature-stability' DT prop required (actually not fully
> >    true, for 59x it is ignored and the driver does not require its
> >    presence)
> > 
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
> > ---
> >  .../devicetree/bindings/clock/silabs,si570.txt     |  39 ++
> >  drivers/clk/Kconfig                                |  10 +
> >  drivers/clk/Makefile                               |   1 +
> >  drivers/clk/clk-si570.c                            | 536 +++++++++++++++++++++
> >  4 files changed, 586 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/clock/silabs,si570.txt
> >  create mode 100644 drivers/clk/clk-si570.c
> > 
> > diff --git a/Documentation/devicetree/bindings/clock/silabs,si570.txt b/Documentation/devicetree/bindings/clock/silabs,si570.txt
> > new file mode 100644
> > index 0000000..26aab5c
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/clock/silabs,si570.txt
> > @@ -0,0 +1,39 @@
> > +Binding for Silicon Labs 570, 571, 598 and 599 programmable
> > +I2C clock generators.
> > +
> > +Reference
> > +This binding uses the common clock binding[1]. Details about the devices can be
> > +found in the data sheets[2][3].
> > +
> > +[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
> > +[2] Si570/571 Data Sheet
> > +    http://www.silabs.com/Support%20Documents/TechnicalDocs/si570.pdf
> > +[3] Si598/599 Data Sheet
> > +    http://www.silabs.com/Support%20Documents/TechnicalDocs/si598-99.pdf
> > +
> > +Required properties:
> > + - compatible: Shall be one of "silabs,si570", "silabs,si571",
> > +			       "silabs,si598", "silabs,si599"
> > + - reg: I2C device address.
> > + - #clock-cells: From common clock bindings: Shall be 0.
> > + - factory-fout: Factory set default frequency. This frequency is part specific.
> > +		 The correct frequency for the part used has to be provided in
> > +		 order to generate the correct output frequencies. For more
> > +		 details, please refer to the data sheet.
> > + - temperature-stability: Temperature stability of the device. Should be one of:
> > +			  7, 20, 50 or 100.
> > +
> It might make sense to specify that this is in microseconds.
ppm, but yes giving the unit is a good idea.

> 
> > +Optional properties:
> > + - clock-output-names: From common clock bindings. Recommended to be "si570".
> > + - clock-frequency: Output frequency to generate. This defines the output
> > +		    frequency set during boot. It can be reprogrammed during
> > +		    runtime through the common clock framework.
> > +
> > +Example:
> > +	si570: clock-generator@5d {
> > +		#clock-cells = <0>;
> > +		compatible = "silabs,si570";
> > +		temperatur-stability = <50>;
> 
> temperature
damn typos.

> 
> > +		reg = <0x5d>;
> > +		factory-fout = <156250000>;
> > +	};
[...]
> > diff --git a/drivers/clk/clk-si570.c b/drivers/clk/clk-si570.c
> > new file mode 100644
> > index 0000000..13c2091
> > --- /dev/null
> > +++ b/drivers/clk/clk-si570.c
[...]
> > +static int si570_probe(struct i2c_client *client,
> > +		const struct i2c_device_id *id)
> > +{
> > +	struct clk_si570 *data;
> > +	struct clk_init_data init;
> > +	struct clk *clk;
> > +	u32 initial_fout, factory_fout, stability;
> > +	int err;
> > +	enum clk_si570_variant variant = id->driver_data;
> > +
> > +	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
> > +	if (!data)
> > +		return -ENOMEM;
> > +
> > +	init.ops = &si570_clk_ops;
> > +	init.flags = CLK_IS_ROOT;
> > +	init.num_parents = 0;
> > +	data->hw.init = &init;
> > +	data->i2c_client = client;
> > +
> > +	if (variant == si57x) {
> > +		err = of_property_read_u32(client->dev.of_node,
> > +				"temperature-stability", &stability);
> > +		if (err) {
> > +			dev_err(&client->dev,
> > +				  "'temperature-stability' property missing\n");
> > +			return err;
> > +		}
> > +		/* adjust register offsets for 7ppm devices */
> > +		if (stability == 7)
> > +			data->div_offset = SI570_DIV_OFFSET_7PPM;
> > +
> > +		data->max_freq = SI570_MAX_FREQ;
> > +	} else {
> > +		data->max_freq = SI598_MAX_FREQ;
> > +	}
> > +
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
> > +	/* Read the requested initial output frequency from device tree */
> > +	if (!of_property_read_u32(client->dev.of_node, "clock-frequency",
> > +				&initial_fout)) {
> > +		err = clk_set_rate(clk, initial_fout);
> > +		if (err) {
> > +			of_clk_del_provider(client->dev.of_node);
> > +			clk_unregister(data->hw.clk);
> 
> Is that needed ? I would have thought it isn't because you use a devm_ function
> to register it.
> 
> Not that I understand the clk code, but getting clk from the registration
> function and unregistering hw.clk (without seting it) sems a bit odd.
> Is it well defined that you have to unregister hw.clk ?
I have to double check. I thought the managed interface is only saving
you a call to clk_put() but I may be wrong.

	Sören


