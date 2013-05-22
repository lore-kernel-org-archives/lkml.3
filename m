Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab3EVI1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:27:44 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:16831
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750931Ab3EVI1i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:27:38 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 16
X-BigFish: VS16(zz98dIc89bh1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6h1082kzzz2dh2a8h668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh1354h137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh133w1155h)
Message-ID: <519C820B.2080800@freescale.com>
Date: Wed, 22 May 2013 16:30:03 +0800
From: Huang Shijie <b32955@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: <grant.likely@linaro.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <rob.herring@calxeda.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/6] drivers: bus: add a new driver for WEIM
References: <1369039742-10893-1-git-send-email-b32955@freescale.com> <1369039742-10893-2-git-send-email-b32955@freescale.com> <20130520131827.GB32299@pengutronix.de>
In-Reply-To: <20130520131827.GB32299@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年05月20日 21:18, Sascha Hauer 写道:
> On Mon, May 20, 2013 at 04:48:57PM +0800, Huang Shijie wrote:
>> 			weim-cs-index.
>> +
>> +Example for an i.MX6q-sabreauto board:
>> +	weim: weim@021b8000 {
>> +		compatible = "fsl,imx6q-weim";
>> +		reg =<0x021b8000 0x4000>;
>> +		interrupts =<0 14 0x04>;
>> +		clocks =<&clks 196>;
>> +		#address-cells =<2>;
> Why is address cells 2 in this example?
Must be set to 2 to allow memory address translation.
>> +		#size-cells =<1>;
>> +		ranges =<0 0 0x08000000 0x08000000>;
>> +
>> +		nor@0,0 {
>> +			compatible = "cfi-flash";
>> +			reg =<0 0 0x02000000>;
>> +			#address-cells =<1>;
>> +			#size-cells =<1>;
>> +			bank-width =<2>;
>> +
>> +			weim-cs-index =<0>;
>> +			weim-cs-timing =<0x00620081 0x00000001 0x1C022000
>> +					0x0000C000 0x1404a38e 0x00000000>;
>> +			partition@0 {
>> +				label = "U-Boot";
>> +				reg =<0x0 0x40000>;
>> +			};
>> +
>> +			partition@40000 {
>> +				label = "U-Boot-ENV";
>> +				reg =<0x40000 0x10000>;
>> +				read-only;
>> +			};
>> +
>> +			partition@50000 {
>> +				label = "Kernel";
>> +				reg =<0x50000 0x3b0000>;
>> +			};
> The partitions are unnecessary to understand the example. Please drop them.
okay.
>> +#define CS_TIMING_LEN 6
>> +#define CS_REG_RANGE  0x18
>> +/* Parse and set the timing for this device. */
>> +static int weim_timing(struct platform_device *pdev, struct device_node *np)
>> +{
>> +	struct imx_weim *weim = platform_get_drvdata(pdev);
>> +	u32 value[CS_TIMING_LEN];
>> +	u32 cs_idx;
>> +	int ret;
>> +	int i;
>> +
>> +	ret = of_property_read_u32(np, "weim-cs-index",&cs_idx);
>> +	if (ret)
>> +		goto weim_parse_err;
> It would be nice to check for cs_idx being valid.
>
>> +
>> +	ret = of_property_read_u32_array(np, "weim-cs-timing",
>> +					value, CS_TIMING_LEN);
>> +	if (ret)
>> +		goto weim_parse_err;
>> +
>> +	/* set the timing for WEIM */
>> +	for (i = 0; i<  CS_TIMING_LEN; i++)
>> +		writel(value[i], weim->base + cs_idx * CS_REG_RANGE + i * 4);
>> +	return 0;
>> +
>> +weim_parse_err:
>> +	return ret;
>> +}
>> +
>> +static int weim_parse_dt(struct platform_device *pdev)
>> +{
>> +	struct device_node *child;
>> +	int ret;
>> +
>> +	/* We only support the Parallel NOR now. We may add more in future. */
>> +	child = of_find_node_by_name(NULL, "nor");
>> +	if (child) {
>> +		ret = weim_timing(pdev, child);
>> +		if (ret)
>> +			goto parse_fail;
>> +
>> +		if (!of_platform_device_create(child, NULL,&pdev->dev)) {
>> +			ret = -EINVAL;
>> +			goto parse_fail;
>> +		}
>> +	}
> What you want to do here is:
>
> - iterate over your child nodes
> - call weim_timing() for each of them
> - call of_platform_device_create for each child (or even
>    of_platform_populate() with the parent node)
>
yes.
>> +	return 0;
>> +
>> +parse_fail:
>> +	return ret;
>> +}
>> +
>> +static int weim_probe(struct platform_device *pdev)
>> +{
>> +	struct imx_weim *weim;
>> +	struct resource *res;
>> +	int ret = -EINVAL;
>> +
>> +	weim = devm_kzalloc(&pdev->dev, sizeof(*weim), GFP_KERNEL);
>> +	if (!weim) {
>> +		ret = -ENOMEM;
>> +		goto weim_err;
>> +	}
>> +	platform_set_drvdata(pdev, weim);
>> +
>> +	/* get the resource */
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	if (!res) {
>> +		ret = -ENOENT;
>> +		goto weim_err;
>> +	}
> No need to do error checking here. devm_ioremap_resource() will do this
> for you and also print an error message.
>
>> +
>> +	weim->base = devm_ioremap_resource(&pdev->dev, res);
>> +	if (IS_ERR(weim->base)) {
>> +		ret = PTR_ERR(weim->base);
>> +		goto weim_err;
>> +	}
>> +
>> +	/* get the clock */
>> +	weim->clk = devm_clk_get(&pdev->dev, NULL);
>> +	if (IS_ERR(weim->clk))
>> +		goto weim_err;
>> +
>> +	clk_prepare_enable(weim->clk);
> what is this clock used for? Is it necessary for the register access or
> is it necessary for the chipselects on the WEIM to work?
>
>
yes. We need this clock.

in actually, this clock is just a clock gate for several clocks, 
including clock for register access, and
other necessary clocks.

thanks
Huang Shijie
.






