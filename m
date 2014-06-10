Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbaFJIya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 04:54:30 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53487 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750874AbaFJIyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 04:54:25 -0400
Message-ID: <5396C7BD.3040008@free-electrons.com>
Date: Tue, 10 Jun 2014 10:54:21 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [RESEND2 PATCH v4 2/2] i2c: sunxi: add P2WI (Push/Pull 2 Wire
 Interface) controller support
References: <1401785392-26602-1-git-send-email-boris.brezillon@free-electrons.com> <1401785392-26602-3-git-send-email-boris.brezillon@free-electrons.com> <20140610083850.GB2620@katana>
In-Reply-To: <20140610083850.GB2620@katana>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wolfram,

On 10/06/2014 10:38, Wolfram Sang wrote:
> On Tue, Jun 03, 2014 at 10:49:52AM +0200, Boris BREZILLON wrote:
>> The P2WI looks like an SMBus controller which only supports byte data
>> transfers. But, it differs from standard SMBus protocol on several
>> aspects:
>> - it supports only one slave device, and thus drop the address field
>> - it adds a parity bit every 8bits of data
>> - only one read access is required to read a byte (instead of a read
>>   followed by a write access in standard SMBus protocol)
>> - there's no Ack bit after each byte transfer
>>
>> This means this bus cannot be used to interface with standard SMBus
>> devices (the only known device to support this interface is the AXP221
>> PMIC).
> Good description. Should be a comment at the top of the driver to spread
> the word.

Sure, I'll copy this description in the driver.

>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>> ---
>>  drivers/i2c/busses/Kconfig          |  12 ++
>>  drivers/i2c/busses/Makefile         |   1 +
>>  drivers/i2c/busses/i2c-sun6i-p2wi.c | 349 ++++++++++++++++++++++++++++++++++++
>>  3 files changed, 362 insertions(+)
>>  create mode 100644 drivers/i2c/busses/i2c-sun6i-p2wi.c
> ...
>
>> +struct p2wi {
>> +	struct i2c_adapter adapter;
>> +	struct completion complete;
>> +	unsigned int irq;
> Can be a local variable in probe.

Yes, I'll remove it from this structure.

>
>> +	unsigned int status;
>> +	void __iomem *regs;
>> +	struct clk *clk;
>> +	struct reset_control *rstc;
>> +	int slave_addr;
>> +};
>> +
>> +static irqreturn_t p2wi_interrupt(int irq, void *dev_id)
>> +{
>> +	struct p2wi *p2wi = dev_id;
>> +	unsigned long status;
>> +
>> +	status = readl(p2wi->regs + P2WI_INTS);
>> +	p2wi->status = status;
>> +
>> +	/* Clear interrupts */
>> +	status &= (P2WI_INTS_LOAD_BSY | P2WI_INTS_TRANS_ERR |
>> +		   P2WI_INTS_TRANS_OVER);
>> +	writel(status, p2wi->regs + P2WI_INTS);
>> +
>> +	complete(&p2wi->complete);
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static u32 p2wi_functionality(struct i2c_adapter *adap)
>> +{
>> +	return I2C_FUNC_SMBUS_BYTE_DATA;
>> +}
>> +
>> +static int p2wi_smbus_xfer(struct i2c_adapter *adap, u16 addr,
>> +			   unsigned short flags, char read_write,
>> +			   u8 command, int size, union i2c_smbus_data *data)
>> +{
>> +	struct p2wi *p2wi = i2c_get_adapdata(adap);
>> +	unsigned long dlen = P2WI_DLEN_DATA_LENGTH(1);
>> +
>> +	if (addr > 0xff ||
> Why 0xff? Does the PMIC support that? I2C addresses are 7-bit. You
> won't even have a slave device if it has an illegal i2c address, so this
> shouldn't happen.

The P2WI protocol supports 8bits addresses, hence I added this 0xff check.
Anyway, the PMIC I use (AXP221) is assigned the 0x68 address, and I
don't think there are a lot of P2WI compatible devices in the wild, so
we can just assume 7bits addresses are fine and rely on the core code
checks.

>
>> +	    (p2wi->slave_addr >= 0 && addr != p2wi->slave_addr)) {
>> +		dev_err(&adap->dev, "invalid P2WI address\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (!data)
>> +		return -EINVAL;
>> +
>> +	writel(command, p2wi->regs + P2WI_DADDR0);
>> +
>> +	if (read_write == I2C_SMBUS_READ)
>> +		dlen |= P2WI_DLEN_READ;
>> +	else
>> +		writel(data->byte, p2wi->regs + P2WI_DATA0);
>> +
>> +	writel(dlen, p2wi->regs + P2WI_DLEN);
>> +
>> +	if (readl(p2wi->regs + P2WI_CTRL) & P2WI_CTRL_START_TRANS) {
>> +		dev_err(&adap->dev, "P2WI bus busy\n");
>> +		return -EBUSY;
>> +	}
>> +
>> +	reinit_completion(&p2wi->complete);
>> +
>> +	writel(P2WI_INTS_LOAD_BSY | P2WI_INTS_TRANS_ERR | P2WI_INTS_TRANS_OVER,
>> +	       p2wi->regs + P2WI_INTE);
>> +
>> +	writel(P2WI_CTRL_START_TRANS | P2WI_CTRL_GLOBAL_INT_ENB,
>> +	       p2wi->regs + P2WI_CTRL);
>> +
>> +	wait_for_completion(&p2wi->complete);
>> +
>> +	if (p2wi->status & P2WI_INTS_LOAD_BSY) {
>> +		dev_err(&adap->dev, "P2WI bus busy\n");
>> +		return -EBUSY;
>> +	}
>> +
>> +	if (p2wi->status & P2WI_INTS_TRANS_ERR) {
>> +		dev_err(&adap->dev, "P2WI bus xfer error\n");
>> +		return -ENXIO;
>> +	}
>> +
>> +	if (read_write == I2C_SMBUS_READ)
>> +		data->byte = readl(p2wi->regs + P2WI_DATA0);
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct i2c_algorithm p2wi_algo = {
>> +	.smbus_xfer = p2wi_smbus_xfer,
>> +	.functionality = p2wi_functionality,
>> +};
>> +
>> +static const struct of_device_id p2wi_of_match_table[] = {
>> +	{ .compatible = "allwinner,sun6i-a31-p2wi" },
>> +	{}
>> +};
>> +MODULE_DEVICE_TABLE(of, p2wi_of_match_table);
>> +
>> +static int p2wi_probe(struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	struct device_node *np = dev->of_node;
>> +	struct device_node *childnp;
>> +	unsigned long parent_clk_freq;
>> +	u32 clk_freq = 100000;
>> +	struct resource *r;
>> +	struct p2wi *p2wi;
>> +	u32 slave_addr;
>> +	int clk_div;
>> +	int ret;
>> +
>> +	of_property_read_u32(np, "clock-frequency", &clk_freq);
>> +	if (clk_freq > P2WI_MAX_FREQ) {
>> +		dev_err(dev,
>> +			"required clock-frequency (%u Hz) is too high (max = 6MHz)",
>> +			clk_freq);
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (of_get_child_count(np) > 1) {
>> +		dev_err(dev, "P2WI only supports one slave device\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	p2wi = devm_kzalloc(dev, sizeof(struct p2wi), GFP_KERNEL);
>> +	if (!p2wi) {
>> +		dev_err(dev, "failed to allocate p2wi struct\n");
> No error strings for OOM.

I'll drop this line.

>
>> +		return -ENOMEM;
>> +	}
>> +
>> +	p2wi->slave_addr = -1;
>> +
>> +	/*
>> +	 * Authorize a p2wi node without any children to be able to use an
>> +	 * i2c-dev from userpace.
>> +	 * In this case the slave_addr is set to -1 and won't be checked when
>> +	 * launching a P2WI transfer.
>> +	 */
>> +	childnp = of_get_next_available_child(np, NULL);
>> +	if (childnp) {
>> +		ret = of_property_read_u32(childnp, "reg", &slave_addr);
>> +		if (ret || slave_addr > 0xff) {
> Again: Is 8 bit range important here? Otherwise I'd leave the check to the
> core.
>
>> +			dev_err(dev, "invalid slave address on node %s\n",
>> +				childnp->full_name);
>> +			return -EINVAL;
>> +		}
>> +
>> +		p2wi->slave_addr = slave_addr;
>> +	}
>> +
>> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +	p2wi->regs = devm_ioremap_resource(dev, r);
>> +	if (IS_ERR(p2wi->regs)) {
>> +		ret = PTR_ERR(p2wi->regs);
>> +		dev_err(dev, "failed to retrieve iomem resource: %d\n", ret);
> devm_ioremap_resource prints errors on its own.

Ditto

>
>> +		return ret;
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
> My general suggestion: Don't be too strict on the 80 char limit. IMO this dangling
> 'ret' is not more readable.

Okay, I'll fix that.


Thanks for your review.

Best Regards,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

