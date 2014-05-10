Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084AbaEJJJB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 05:09:01 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50038 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750900AbaEJJI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 05:08:57 -0400
Message-ID: <536DECA6.9070104@free-electrons.com>
Date: Sat, 10 May 2014 11:08:54 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Wolfram Sang <wsa@the-dreams.de>, Randy Dunlap <rdunlap@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] i2c: sunxi: add P2WI (Push/Pull 2 Wire Interface)
 controller support
References: <1399485515-11243-1-git-send-email-boris.brezillon@free-electrons.com> <1399654570-30962-1-git-send-email-boris.brezillon@free-electrons.com> <20140510011659.GH7047@lukather>
In-Reply-To: <20140510011659.GH7047@lukather>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 10/05/2014 03:16, Maxime Ripard wrote:
> On Fri, May 09, 2014 at 06:56:10PM +0200, Boris BREZILLON wrote:
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
>>
>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> ---
>> Changes since v2:
>> - drop the initialization (switch from I2C to P2WI mode) part
>> - print devm_ioremap_resource err code
> You'll also need to update the documentation of the DT bindings.

Crap, I forgot about that.
I'll send a proper v4 updating the documentation and the code.

>
>>  drivers/i2c/busses/Kconfig          |  12 ++
>>  drivers/i2c/busses/Makefile         |   1 +
>>  drivers/i2c/busses/i2c-sun6i-p2wi.c | 352 ++++++++++++++++++++++++++++++++++++
>>  3 files changed, 365 insertions(+)
>>  create mode 100644 drivers/i2c/busses/i2c-sun6i-p2wi.c
>>
>> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
>> index c94db1c..09bce1c 100644
>> --- a/drivers/i2c/busses/Kconfig
>> +++ b/drivers/i2c/busses/Kconfig
>> @@ -771,6 +771,18 @@ config I2C_STU300
>>  	  This driver can also be built as a module. If so, the module
>>  	  will be called i2c-stu300.
>>  
>> +config I2C_SUN6I_P2WI
>> +	tristate "Allwinner sun6i internal P2WI controller"
>> +	depends on ARCH_SUNXI
>> +	help
>> +	  If you say yes to this option, support will be included for the
>> +	  P2WI (Push/Pull 2 Wire Interface) controller embedded in some sunxi
>> +	  SOCs.
>> +	  The P2WI looks like an SMBus controller (which supports only byte
>> +	  accesses), except that it only supports one slave device.
>> +	  This interface is used to connect to specific PMIC devices (like the
>> +	  AXP221).
>> +
>>  config I2C_TEGRA
>>  	tristate "NVIDIA Tegra internal I2C controller"
>>  	depends on ARCH_TEGRA
>> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
>> index 18d18ff..58feeb9 100644
>> --- a/drivers/i2c/busses/Makefile
>> +++ b/drivers/i2c/busses/Makefile
>> @@ -75,6 +75,7 @@ obj-$(CONFIG_I2C_SIMTEC)	+= i2c-simtec.o
>>  obj-$(CONFIG_I2C_SIRF)		+= i2c-sirf.o
>>  obj-$(CONFIG_I2C_ST)		+= i2c-st.o
>>  obj-$(CONFIG_I2C_STU300)	+= i2c-stu300.o
>> +obj-$(CONFIG_I2C_SUN6I_P2WI)	+= i2c-sun6i-p2wi.o
>>  obj-$(CONFIG_I2C_TEGRA)		+= i2c-tegra.o
>>  obj-$(CONFIG_I2C_VERSATILE)	+= i2c-versatile.o
>>  obj-$(CONFIG_I2C_WMT)		+= i2c-wmt.o
>> diff --git a/drivers/i2c/busses/i2c-sun6i-p2wi.c b/drivers/i2c/busses/i2c-sun6i-p2wi.c
>> new file mode 100644
>> index 0000000..7c859ee
>> --- /dev/null
>> +++ b/drivers/i2c/busses/i2c-sun6i-p2wi.c
>> @@ -0,0 +1,352 @@
>> +/*
>> + * P2WI (Push-Pull Two Wire Interface) bus driver.
>> + *
>> + * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
>> + *
>> + * This file is licensed under the terms of the GNU General Public License
>> + * version 2.  This program is licensed "as is" without any warranty of any
>> + * kind, whether express or implied.
>> + */
>> +#include <linux/kernel.h>
>> +#include <linux/slab.h>
>> +#include <linux/module.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/i2c.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/io.h>
>> +#include <linux/of.h>
>> +#include <linux/of_device.h>
>> +#include <linux/of_irq.h>
>> +#include <linux/clk.h>
>> +#include <linux/err.h>
>> +#include <linux/delay.h>
>> +#include <linux/clk.h>
>> +#include <linux/reset.h>
>> +
>> +
>> +/* P2WI registers */
>> +#define P2WI_CTRL		0x0
>> +#define P2WI_CCR		0x4
>> +#define P2WI_INTE		0x8
>> +#define P2WI_INTS		0xc
>> +#define P2WI_DADDR0		0x10
>> +#define P2WI_DADDR1		0x14
>> +#define P2WI_DLEN		0x18
>> +#define P2WI_DATA0		0x1c
>> +#define P2WI_DATA1		0x20
>> +#define P2WI_LCR		0x24
>> +#define P2WI_PMCR		0x28
>> +
>> +/* CTRL fields */
>> +#define P2WI_CTRL_START_TRANS		BIT(7)
>> +#define P2WI_CTRL_ABORT_TRANS		BIT(6)
>> +#define P2WI_CTRL_GLOBAL_INT_ENB	BIT(1)
>> +#define P2WI_CTRL_SOFT_RST		BIT(0)
>> +
>> +/* CLK CTRL fields */
>> +#define P2WI_CCR_SDA_OUT_DELAY(v)	(((v) & 0x7) << 8)
>> +#define P2WI_CCR_MAX_CLK_DIV		0xff
>> +#define P2WI_CCR_CLK_DIV(v)		((v) & P2WI_CCR_MAX_CLK_DIV)
>> +
>> +/* STATUS fields */
>> +#define P2WI_INTS_TRANS_ERR_ID(v)	(((v) >> 8) & 0xff)
>> +#define P2WI_INTS_LOAD_BSY		BIT(2)
>> +#define P2WI_INTS_TRANS_ERR		BIT(1)
>> +#define P2WI_INTS_TRANS_OVER		BIT(0)
>> +
>> +/* DATA LENGTH fields*/
>> +#define P2WI_DLEN_READ			BIT(4)
>> +#define P2WI_DLEN_DATA_LENGTH(v)	((v - 1) & 0x7)
>> +
>> +/* LINE CTRL fields*/
>> +#define P2WI_LCR_SCL_STATE		BIT(5)
>> +#define P2WI_LCR_SDA_STATE		BIT(4)
>> +#define P2WI_LCR_SCL_CTL		BIT(3)
>> +#define P2WI_LCR_SCL_CTL_EN		BIT(2)
>> +#define P2WI_LCR_SDA_CTL		BIT(1)
>> +#define P2WI_LCR_SDA_CTL_EN		BIT(0)
>> +
>> +/* PMU MODE CTRL fields */
>> +#define P2WI_PMCR_PMU_INIT_SEND		BIT(31)
>> +#define P2WI_PMCR_PMU_INIT_DATA(v)	(((v) & 0xff) << 16)
>> +#define P2WI_PMCR_PMU_MODE_REG(v)	(((v) & 0xff) << 8)
>> +#define P2WI_PMCR_PMU_DEV_ADDR(v)	((v) & 0xff)
>> +
>> +#define P2WI_MAX_FREQ			6000000
>> +
>> +struct p2wi {
>> +	struct i2c_adapter adapter;
>> +	struct completion complete;
>> +	unsigned int irq;
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
> If you return whenever you have more than one child here...
>
>> +	p2wi = devm_kzalloc(dev, sizeof(struct p2wi), GFP_KERNEL);
>> +	if (!p2wi) {
>> +		dev_err(dev, "failed to allocate p2wi struct\n");
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
>> +	 *
>> +	 * If the p2wi node contains more than one child, the first one will
>> +	 * be considered as the only slave node.
> ... how does the second part of this comment make any sense? You won't
> even get there in such a case.

Yep, I guess it's a vestige from an older version where I was not
testing the number of child.
I'll remove this part from the comment.

Best Regards,

Boris

>
> Thanks,
> Maxime
>

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

