Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbaEMVmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 17:42:19 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:43673 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbaEMVmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 17:42:15 -0400
Message-ID: <537291B2.4070700@imgtec.com>
Date: Tue, 13 May 2014 22:42:10 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexander Bersenev <bay@hackerdom.ru>, <linux-sunxi@googlegroups.com>,
        <david@hardeman.nu>, <devicetree@vger.kernel.org>,
        <galak@codeaurora.org>, <grant.likely@linaro.org>,
        <ijc+devicetree@hellion.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <m.chehab@samsung.com>, <mark.rutland@arm.com>,
        <maxime.ripard@free-electrons.com>, <pawel.moll@arm.com>,
        <rdunlap@infradead.org>, <robh+dt@kernel.org>, <sean@mess.org>,
        <srinivas.kandagatla@st.com>, <wingrime@linux-sunxi.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH v6 2/3] ARM: sunxi: Add driver for sunxi IR controller
References: <1400006342-2968-1-git-send-email-bay@hackerdom.ru> <1400006342-2968-3-git-send-email-bay@hackerdom.ru>
In-Reply-To: <1400006342-2968-3-git-send-email-bay@hackerdom.ru>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

Just a few probe error handling suggestions...

On 13/05/14 19:39, Alexander Bersenev wrote:
> +static int sunxi_ir_probe(struct platform_device *pdev)
> +{
> +	int ret = 0;
> +	unsigned long tmp = 0;
> +
> +	struct device *dev = &pdev->dev;
> +	struct device_node *dn = dev->of_node;
> +	struct resource *res;
> +	struct sunxi_ir *ir;
> +
> +	ir = devm_kzalloc(dev, sizeof(struct sunxi_ir), GFP_KERNEL);
> +	if (!ir)
> +		return -ENOMEM;
> +
> +	/* Clock */
> +	ir->apb_clk = devm_clk_get(dev, "apb");
> +	if (IS_ERR(ir->apb_clk)) {
> +		dev_err(dev, "failed to get a apb clock.\n");
> +		return -EINVAL;

Does it make sense to return PTR_ERR(ir->apb_clk) here?

> +	}
> +	ir->clk = devm_clk_get(dev, "ir");
> +	if (IS_ERR(ir->clk)) {
> +		dev_err(dev, "failed to get a ir clock.\n");
> +		return -EINVAL;

and here

> +	}
> +
> +	ret = clk_set_rate(ir->clk, SUNXI_IR_BASE_CLK);
> +	if (ret) {
> +		dev_err(dev, "set ir base clock failed!\n");
> +		return -EINVAL;

return ret?

> +	}
> +
> +	if (clk_prepare_enable(ir->apb_clk)) {
> +		dev_err(dev, "try to enable apb_ir_clk failed\n");
> +		return -EINVAL;
> +	}
> +
> +	if (clk_prepare_enable(ir->clk)) {
> +		dev_err(dev, "try to enable ir_clk failed\n");
> +		ret = -EINVAL;
> +		goto exit_clkdisable_apb_clk;
> +	}
> +
> +	/* IO */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +
> +	ir->base = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(ir->base)) {
> +		dev_err(dev, "failed to map registers\n");
> +		ret = -ENOMEM;

PTR_ERR again?

> +		goto exit_clkdisable_clk;
> +	}
> +
> +	/* IRQ */
> +	ir->irq = platform_get_irq(pdev, 0);
> +	if (ir->irq < 0) {
> +		dev_err(dev, "no irq resource\n");
> +		ret = -EINVAL;

ret = ir->irq?

> +		goto exit_clkdisable_clk;
> +	}
> +
> +	ret = devm_request_irq(dev, ir->irq, sunxi_ir_irq, 0, SUNXI_IR_DEV, ir);
> +	if (ret) {
> +		dev_err(dev, "failed request irq\n");
> +		ret = -EINVAL;

necessary?

> +		goto exit_clkdisable_clk;
> +	}
> +
> +	ir->rc = rc_allocate_device();
> +
> +	if (!ir->rc) {
> +		dev_err(dev, "failed to allocate device\n");
> +		ret = -ENOMEM;
> +		goto exit_clkdisable_clk;
> +	}
> +
> +	ir->rc->priv = ir;
> +	ir->rc->input_name = SUNXI_IR_DEV;
> +	ir->rc->input_phys = "sunxi-ir/input0";
> +	ir->rc->input_id.bustype = BUS_HOST;
> +	ir->rc->input_id.vendor = 0x0001;
> +	ir->rc->input_id.product = 0x0001;
> +	ir->rc->input_id.version = 0x0100;
> +	ir->map_name = of_get_property(dn, "linux,rc-map-name", NULL);
> +	ir->rc->map_name = ir->map_name ?: RC_MAP_EMPTY;
> +	ir->rc->dev.parent = dev;
> +	ir->rc->driver_type = RC_DRIVER_IR_RAW;
> +	rc_set_allowed_protocols(ir->rc, RC_BIT_ALL);
> +	ir->rc->rx_resolution = SUNXI_IR_SAMPLE;
> +	ir->rc->timeout = MS_TO_NS(SUNXI_IR_TIMEOUT);
> +	ir->rc->driver_name = SUNXI_IR_DEV;
> +
> +	ret = rc_register_device(ir->rc);
> +	if (ret) {
> +		dev_err(dev, "failed to register rc device\n");
> +		ret = -EINVAL;

same again

> +		goto exit_free_dev;
> +	}
> +

Cheers
James
