Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbaEIOuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 10:50:06 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46562 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751084AbaEIOuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 10:50:04 -0400
Message-ID: <536CEB1A.2060206@free-electrons.com>
Date: Fri, 09 May 2014 16:50:02 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Wolfram Sang <wsa@the-dreams.de>, Randy Dunlap <rdunlap@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] i2c: sunxi: add P2WI (Push/Pull 2 Wire Interface)
 controller support
References: <1399485515-11243-1-git-send-email-boris.brezillon@free-electrons.com> <1399485515-11243-3-git-send-email-boris.brezillon@free-electrons.com> <20140509143116.GD7047@lukather>
In-Reply-To: <20140509143116.GD7047@lukather>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/05/2014 16:31, Maxime Ripard wrote:
> Hi Boris,
>
> On Wed, May 07, 2014 at 07:58:35PM +0200, Boris BREZILLON wrote:
>
[...]
> +
> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	p2wi->regs = devm_ioremap_resource(dev, r);
> +	if (IS_ERR(p2wi->regs)) {
> +		dev_err(dev, "failed to retrieve iomem resource\n");
> +		return PTR_ERR(p2wi->regs);
> You seem to be returning the error code in the next error messages. It
> would probably be a good idea to put it there too.

Yes, I'll print the err code in the error message.

>
>> +	}
>> +
>> +	snprintf(p2wi->adapter.name, sizeof(p2wi->adapter.name), pdev->name);
>> +	ret = platform_get_irq(pdev, 0);
>> +	if (ret < 0) {
>> +		dev_err(dev, "failed to retrieve irq: %d\n", ret);
>> +		return ret;
>> +	}
>> +	p2wi->irq = ret;
>> +
>> +	p2wi->clk = devm_clk_get(dev, NULL);
>> +	if (IS_ERR(p2wi->clk)) {
>> +		ret = PTR_ERR(p2wi->clk);
>> +		dev_err(dev, "failed to retrieve clk: %d\n",
>> +			ret);
>> +		return ret;
>> +	}
>> +
>> +	ret = clk_prepare_enable(p2wi->clk);
>> +	if (ret) {
>> +		dev_err(dev, "failed to enable clk: %d\n", ret);
>> +		return ret;
>> +	}
>> +
>> +	parent_clk_freq = clk_get_rate(p2wi->clk);
>> +
>> +	p2wi->rstc = devm_reset_control_get(dev, NULL);
>> +	if (IS_ERR(p2wi->rstc)) {
>> +		ret = PTR_ERR(p2wi->rstc);
>> +		dev_err(dev, "failed to retrieve reset controller: %d\n",
>> +			ret);
>> +		goto err_clk_disable;
>> +	}
>> +
>> +	ret = reset_control_deassert(p2wi->rstc);
>> +	if (ret) {
>> +		dev_err(dev, "failed to deassert reset line: %d\n",
>> +			ret);
>> +		goto err_clk_disable;
>> +	}
>> +
>> +	init_completion(&p2wi->complete);
>> +	p2wi->adapter.dev.parent = dev;
>> +	p2wi->adapter.algo = &p2wi_algo;
>> +	p2wi->adapter.owner = THIS_MODULE;
>> +	p2wi->adapter.dev.of_node = pdev->dev.of_node;
>> +	platform_set_drvdata(pdev, p2wi);
>> +	i2c_set_adapdata(&p2wi->adapter, p2wi);
>> +
>> +	ret = devm_request_irq(dev, p2wi->irq, p2wi_interrupt, 0, pdev->name,
>> +			       p2wi);
>> +	if (ret) {
>> +		dev_err(dev, "can't register interrupt handler irq%d: %d\n",
>> +			p2wi->irq, ret);
>> +		goto err_reset_assert;
>> +	}
>> +
>> +	writel(P2WI_CTRL_SOFT_RST, p2wi->regs + P2WI_CTRL);
>> +
>> +	clk_div = parent_clk_freq / clk_freq;
>> +	if (!clk_div) {
>> +		dev_warn(dev,
>> +			 "clock-frequency is too high, setting it to %lu Hz\n",
>> +			 parent_clk_freq);
>> +		clk_div = 1;
>> +	} else if (clk_div > P2WI_CCR_MAX_CLK_DIV) {
>> +		dev_warn(dev,
>> +			 "clock-frequency is too low, setting it to %lu Hz\n",
>> +			 parent_clk_freq / P2WI_CCR_MAX_CLK_DIV);
>> +		clk_div = P2WI_CCR_MAX_CLK_DIV;
>> +	}
>> +
>> +	writel(P2WI_CCR_SDA_OUT_DELAY(1) | P2WI_CCR_CLK_DIV(clk_div),
>> +	       p2wi->regs + P2WI_CCR);
>> +
>> +	if (p2wi_mode_reg >= 0 && p2wi_mode_val >= 0) {
>> +		writel(P2WI_PMCR_PMU_INIT_SEND |
>> +		       P2WI_PMCR_PMU_MODE_REG(p2wi_mode_reg) |
>> +		       P2WI_PMCR_PMU_INIT_DATA(p2wi_mode_val) |
>> +		       P2WI_PMCR_PMU_DEV_ADDR(p2wi->slave_addr),
>> +		       p2wi->regs + P2WI_PMCR);
>> +
>> +		while (readl(p2wi->regs + P2WI_PMCR) &
>> +		       P2WI_PMCR_PMU_INIT_SEND)
>> +			cpu_relax();
>> +	}
> Did we actually encounter such a case? From what I've seen so far,
> both community's u-boot and Allwinner's bootloader already do this.
>
> As you know, I'm really not fond of putting random values and
> registers offsets into the DT itself. Making the assumption that the
> PMIC is already switched to P2WI by the bootloader seems pretty safe
> to me.

Hans, any opinion ?

If everybody agrees on that point, I'll remove the initialization part
from the probe (and drop the allwinner,reg-xx properties retrieval).

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

