Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab3KDOas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 09:30:48 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:58268 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753518Ab3KDOaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 09:30:46 -0500
Message-ID: <5277AF07.7060100@st.com>
Date: Mon, 4 Nov 2013 15:28:23 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
Cc: <srinivas.kandagatla@st.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-i2c@vger.kernel.org>,
        <stephen.gallimore@st.com>, <stuart.menefy@st.com>,
        Lee Jones <lee.jones@linaro.org>, <gabriel.fernandez@st.com>
Subject: Re: [PATCH v5 1/4] i2c: busses: i2c-st: Add ST I2C controller
References: <1381754813-4679-1-git-send-email-maxime.coquelin@st.com> <1381754813-4679-2-git-send-email-maxime.coquelin@st.com> <20131101111645.GA4260@katana>
In-Reply-To: <20131101111645.GA4260@katana>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.19.60]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On 11/01/2013 12:16 PM, Wolfram Sang wrote:
> Hi,
>
...
>> diff --git a/Documentation/devicetree/bindings/i2c/i2c-st.txt b/Documentation/devicetree/bindings/i2c/i2c-st.txt
>> new file mode 100644
>> index 0000000..8b2fd0b
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/i2c/i2c-st.txt
>> @@ -0,0 +1,38 @@
>> +ST SSC binding, for I2C mode operation
>> +
>> +Required properties :
>> +- compatible : Must be "st,comms-i2c"
>
> I personally don't care about naming here. Has there been a solution
> now?

Srini proposes to add 2 compatible strings, as the IP is compatible with 
two SSC IPs:
"st,comms-ssc-i2c"
"st,comms-ssc4-i2c"

>> +
>> +Optional properties :
>> +- clock-frequency : Desired I2C bus clock frequency in Hz. If not specified,
>> +  the default 100 kHz frequency will be used. As only Normal and Fast modes
>> +  are supported, possible values are 100000 and 400000.
>> +- i2c-min-scl-pulse-width-us : The minimum valid SCL pulse width that is
>> +  allowed through the deglitch circuit. In units of us.
>> +- i2c-min-sda-pulse-width-us : The minimum valid SDA pulse width that is
>> +  allowed through the deglitch circuit. In units of us.
>
> Okay, so we had lots of dt bindings discussions at kernel summit. Since
> we don't have unstable bindings yet, I have been convinced that it is
> okay two have one or two vendor specific bindings before introducing a
> generic one. That will create a little bit of cruft, but increases
> chances that the generic bindings are proper. So, really sorry for going
> back and forth, but it was important for the process. Vendor binding is
> it now. Period.
>
> ...
No problem wolfram! Thanks for clarifying this thing.

>
>> +/**
>> + * struct st_i2c_deglitch - Anti-glitch filter configuration
>> + * @scl_min_width_us: SCL line minimum pulse width in ns
>> + * @sda_min_width_us: SDA line minimum pulse width in ns
>> + */
>> +struct st_i2c_deglitch {
>> +	u32	scl_min_width_us;
>> +	u32	sda_min_width_us;
>> +};
>
> Minor: Why a seperate struct?
This not needed, I will move its fields into st_i2c_dev struct.

>
>> +/**
>> + * st_i2c_handle_write() - Handle FIFO enmpty interrupt in case of read
>> + * @i2c_dev: Controller's private data
>> + */
>> +static void st_i2c_handle_read(struct st_i2c_dev *i2c_dev)
>> +{
>> +	struct st_i2c_client *c = &i2c_dev->client;
>> +	u32 ien;
>> +
>> +	/* Trash the address read back */
>> +	if (!c->xfered) {
>> +		readl(i2c_dev->base + SSC_RBUF);
>> +		st_i2c_clr_bits(i2c_dev->base + SSC_I2C, SSC_I2C_TXENB);
>> +	} else
>> +		st_i2c_read_rx_fifo(i2c_dev);
>
> Braces around else branch.
Okay
>
>> +
>> +	if (!c->count) {
>> +		/* End of xfer, send stop or repstart */
>> +		st_i2c_terminate_xfer(i2c_dev);
>> +	} else if (c->count == 1) {
>> +		/* Penultimate byte to xfer, disable ACK gen. */
>> +		st_i2c_clr_bits(i2c_dev->base + SSC_I2C, SSC_I2C_ACKG);
>> +
>> +		/* Last received byte is to be handled by NACK interrupt */
>> +		ien = SSC_IEN_NACKEN | SSC_IEN_ARBLEN;
>> +		writel(ien, i2c_dev->base + SSC_IEN);
>> +
>> +		st_i2c_rd_fill_tx_fifo(i2c_dev, c->count);
>> +	} else
>> +		st_i2c_rd_fill_tx_fifo(i2c_dev, c->count - 1);
>
> Braces around else branch.
Ditto
>
>> +}
>> +static int st_i2c_probe(struct platform_device *pdev)
>> +{
>> +	struct device_node *np = pdev->dev.of_node;
>> +	struct st_i2c_dev *i2c_dev;
>> +	struct resource *res;
>> +	u32 clk_rate;
>> +	struct i2c_adapter *adap;
>> +	int ret;
>> +
>> +	i2c_dev = devm_kzalloc(&pdev->dev, sizeof(*i2c_dev), GFP_KERNEL);
>> +	if (!i2c_dev)
>> +		return -ENOMEM;
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	i2c_dev->base = devm_ioremap_resource(&pdev->dev, res);
>> +	if (IS_ERR(i2c_dev->base))
>> +		return PTR_ERR(i2c_dev->base);
>> +
>> +	i2c_dev->irq = irq_of_parse_and_map(np, 0);
>> +	if (!i2c_dev->irq) {
>> +		dev_err(&pdev->dev, "IRQ missing or invalid\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	i2c_dev->clk = of_clk_get_by_name(np, "ssc");
>> +	if (IS_ERR(i2c_dev->clk)) {
>> +		dev_err(&pdev->dev, "Unable to request clock\n");
>> +		return PTR_ERR(i2c_dev->clk);
>> +	}
>> +
>> +	i2c_dev->mode = I2C_MODE_STANDARD;
>> +	ret = of_property_read_u32(np, "clock-frequency", &clk_rate);
>> +	if ((!ret) && (clk_rate == 400000))
>> +		i2c_dev->mode = I2C_MODE_FAST;
>> +
>> +	i2c_dev->dev = &pdev->dev;
>> +
>> +	ret = devm_request_irq(&pdev->dev, i2c_dev->irq, st_i2c_isr, 0,
>> +			pdev->name, i2c_dev);
>
> Suggestion: Maybe threaded irq since you do fifo handling in the isr?
That's a good point, I will switch to threaded irq.

>
>> +	if (ret) {
>> +		dev_err(&pdev->dev, "Failed to request irq %i\n", i2c_dev->irq);
>> +		return ret;
>> +	}
>> +
>> +	pinctrl_pm_select_default_state(i2c_dev->dev);
>> +	/* In case idle state available, select it */
>> +	pinctrl_pm_select_idle_state(i2c_dev->dev);
>> +
>> +	ret = st_i2c_of_get_deglitch(np, i2c_dev);
>> +	if (ret)
>> +		return ret;
>> +
>> +	adap = &i2c_dev->adap;
>> +	i2c_set_adapdata(adap, i2c_dev);
>> +	snprintf(adap->name, sizeof(adap->name), "ST I2C(0x%08x)", res->start);
>
> resource_size_t can also be 64 bit.
Okay, I will change to 0x%x
>
>> +	adap->owner = THIS_MODULE;
>> +	adap->timeout = 2 * HZ;
>> +	adap->retries = 0;
>> +	adap->class = I2C_CLASS_HWMON | I2C_CLASS_DDC | I2C_CLASS_SPD;
>
> This question is still open:
> Why do you need class based instantiation. It will most likely cost
> boot-time and you have devicetree means for doing instantiation.
Sorry, I missed to take your remark into account last time...
This is indeed useless and adds a cost at boot time, it will be removed 
in next series.

>
>> +	adap->algo = &st_i2c_algo;
>> +	adap->dev.parent = &pdev->dev;
>> +	adap->dev.of_node = pdev->dev.of_node;
>> +
>> +	init_completion(&i2c_dev->complete);
>> +
>> +	ret = i2c_add_adapter(adap);
>> +	if (ret) {
>> +		dev_err(&pdev->dev, "Failed to add adapter\n");
>> +		return ret;
>> +	}
>> +
>> +	platform_set_drvdata(pdev, i2c_dev);
>> +
>> +	dev_info(i2c_dev->dev, "%s initialized\n", adap->name);
>> +
>> +	return 0;
>> +}
>> +
>
> Rest looks good! We are mostly ready to go.
Perfect! :)
I will try to send a new series this week.

Thanks,
Maxime
>
> Thanks,
>
>     Wolfram
>
