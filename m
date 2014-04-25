Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaDYH7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 03:59:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43329 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750916AbaDYH7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 03:59:39 -0400
Message-ID: <535A15C2.5080909@free-electrons.com>
Date: Fri, 25 Apr 2014 09:58:58 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>
CC: Wolfram Sang <wsa@the-dreams.de>, Randy Dunlap <rdunlap@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] i2c: sunxi: add P2WI (Push/Pull 2 Wire Interface)
 controller support
References: <1398340516-29547-1-git-send-email-boris.brezillon@free-electrons.com> <1398340516-29547-3-git-send-email-boris.brezillon@free-electrons.com> <20140424132912.GA24905@lukather> <535A13AE.4090103@free-electrons.com>
In-Reply-To: <535A13AE.4090103@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 25/04/2014 09:50, Boris BREZILLON wrote:
> Hi Maxime,
>
> On 24/04/2014 15:29, Maxime Ripard wrote:
>> On Thu, Apr 24, 2014 at 01:55:16PM +0200, Boris BREZILLON wrote:
>>> The P2WI looks like an SMBus controller which only supports byte data
>>> transfers. But, it differs from standard SMBus protocol on several
>>> aspects:
>>> - it supports only one slave device, and thus drop the address field
>>> - it adds a parity bit every 8bits of data
>>> - only one read access is required to read a byte (instead of a read
>>>   followed by a write access in standard SMBus protocol)
>>> - there's no Ack bit after each byte transfer
>>>
>>> This means this bus cannot be used to interface with standard SMBus
>>> devices (the only known device to support this interface is the AXP221
>>> PMIC).
>>>
>>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>>> ---
>>>  drivers/i2c/busses/Kconfig          |  12 ++
>>>  drivers/i2c/busses/Makefile         |   1 +
>>>  drivers/i2c/busses/i2c-sunxi-p2wi.c | 317 ++++++++++++++++++++++++++++++++++++
>>>  3 files changed, 330 insertions(+)
>>>  create mode 100644 drivers/i2c/busses/i2c-sunxi-p2wi.c
>>>
>>> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
>>> index c94db1c..37e53d6 100644
>>> --- a/drivers/i2c/busses/Kconfig
>>> +++ b/drivers/i2c/busses/Kconfig
>>> @@ -771,6 +771,18 @@ config I2C_STU300
>>>  	  This driver can also be built as a module. If so, the module
>>>  	  will be called i2c-stu300.
>>>  
>>> +config I2C_SUNXI_P2WI
>>> +	tristate "Allwinner sunxi internal P2WI controller"
>> Since the A31 is the only SoC that uses it, maybe you can drop the
>> sunxi and use either sun6i or A31 here?
> It makes sense, I'll change the config option into I2C_SUNXI_P2WI and
> the source file name into i2c-sun6i-p2wi.c.

I meant I2C_SUN6I_P2WI ;-).

>
>>> +	depends on ARCH_SUNXI
>>> +	help
>>> +	  If you say yes to this option, support will be included for the
>>> +	  P2WI (Push/Pull 2 Wire Interface) controller embedded in some sunxi
>>> +	  SOCs.
>>> +	  The P2WI looks like an SMBus controller (which supports only byte
>>> +	  accesses), except that it only supports one slave device.
>>> +	  This interface is used to connect to specific PMIC devices (like the
>>> +	  AXP221).
>>> +
>>>  config I2C_TEGRA
>>>  	tristate "NVIDIA Tegra internal I2C controller"
>>>  	depends on ARCH_TEGRA
>>> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
>>> index 18d18ff..c63d2ec 100644
>>> --- a/drivers/i2c/busses/Makefile
>>> +++ b/drivers/i2c/busses/Makefile
>>> @@ -75,6 +75,7 @@ obj-$(CONFIG_I2C_SIMTEC)	+= i2c-simtec.o
>>>  obj-$(CONFIG_I2C_SIRF)		+= i2c-sirf.o
>>>  obj-$(CONFIG_I2C_ST)		+= i2c-st.o
>>>  obj-$(CONFIG_I2C_STU300)	+= i2c-stu300.o
>>> +obj-$(CONFIG_I2C_SUNXI_P2WI)	+= i2c-sunxi-p2wi.o
>>>  obj-$(CONFIG_I2C_TEGRA)		+= i2c-tegra.o
>>>  obj-$(CONFIG_I2C_VERSATILE)	+= i2c-versatile.o
>>>  obj-$(CONFIG_I2C_WMT)		+= i2c-wmt.o
>>> diff --git a/drivers/i2c/busses/i2c-sunxi-p2wi.c b/drivers/i2c/busses/i2c-sunxi-p2wi.c
>>> new file mode 100644
>>> index 0000000..e3fdd76
>>> --- /dev/null
>>> +++ b/drivers/i2c/busses/i2c-sunxi-p2wi.c
>>> @@ -0,0 +1,317 @@
>>> +/*
>>> + * P2WI (Push-Pull Two Wire Interface) bus driver.
>>> + *
>>> + * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
>>> + *
>>> + * This file is licensed under the terms of the GNU General Public License
>>> + * version 2.  This program is licensed "as is" without any warranty of any
>>> + * kind, whether express or implied.
>>> + */
>>> +#include <linux/kernel.h>
>>> +#include <linux/slab.h>
>>> +#include <linux/module.h>
>>> +#include <linux/spinlock.h>
>>> +#include <linux/i2c.h>
>>> +#include <linux/interrupt.h>
>>> +#include <linux/platform_device.h>
>>> +#include <linux/io.h>
>>> +#include <linux/of.h>
>>> +#include <linux/of_device.h>
>>> +#include <linux/of_irq.h>
>>> +#include <linux/clk.h>
>>> +#include <linux/err.h>
>>> +#include <linux/delay.h>
>>> +#include <linux/clk.h>
>>> +#include <linux/reset.h>
>>> +
>>> +
>>> +/* P2WI registers */
>>> +#define P2WI_CTRL		0x0
>>> +#define P2WI_CCR		0x4
>>> +#define P2WI_INTE		0x8
>>> +#define P2WI_INTS		0xc
>>> +#define P2WI_DADDR0		0x10
>>> +#define P2WI_DADDR1		0x14
>>> +#define P2WI_DLEN		0x18
>>> +#define P2WI_DATA0		0x1c
>>> +#define P2WI_DATA1		0x20
>>> +#define P2WI_LCR		0x24
>>> +#define P2WI_PMCR		0x28
>>> +
>>> +/* CTRL fields */
>>> +#define P2WI_START_TRANS	(1 << 7)
>>> +#define P2WI_ABORT_TRANS	(1 << 6)
>>> +#define P2WI_GLOBAL_INT_ENB	(1 << 1)
>>> +#define P2WI_SOFT_RST		(1 << 0)
>> BIT() ?
> Sure, I'll make use of the BIT macro wherever possible.
>
>>> +/* CLK CTRL fields */
>>> +#define P2WI_SDA_OUT_DELAY(v)	(((v) & 0x7) << 8)
>>> +#define P2WI_CLK_DIV(v)		((v) & 0xff)
>>> +
>>> +/* STATUS fields */
>>> +#define P2WI_TRANS_ERR_ID(v)	(((v) >> 8) & 0xff)
>>> +#define P2WI_LOAD_BSY		(1 << 2)
>>> +#define P2WI_TRANS_ERR		(1 << 1)
>>> +#define P2WI_TRANS_OVER		(1 << 0)
>>> +
>>> +/* DATA LENGTH fields*/
>>> +#define P2WI_READ		(1 << 4)
>>> +#define P2WI_DATA_LENGTH(v)	((v - 1) & 0x7)
>>> +
>>> +/* LINE CTRL fields*/
>>> +#define P2WI_SCL_STATE		(1 << 5)
>>> +#define P2WI_SDA_STATE		(1 << 4)
>>> +#define P2WI_SCL_CTL		(1 << 3)
>>> +#define P2WI_SCL_CTL_EN		(1 << 2)
>>> +#define P2WI_SDA_CTL		(1 << 1)
>>> +#define P2WI_SDA_CTL_EN		(1 << 0)
>>> +
>>> +/* PMU MODE CTRL fields */
>>> +#define P2WI_PMU_INIT_SEND	(1 << 31)
>>> +#define P2WI_PMU_INIT_DATA(v)	(((v) & 0xff) << 16)
>>> +#define P2WI_PMU_MODE_REG(v)	(((v) & 0xff) << 8)
>>> +#define P2WI_PMU_DEV_ADDR(v)	((v) & 0xff)
>> I'd very much prefer if your bits were prefixed by the register
>> name. That way, you directly know in which register that bit belong,
>> without having to scroll across the whole driver.
> Okay.
>
>>> +
>>> +struct p2wi {
>>> +	struct i2c_adapter adapter;
>>> +	struct completion complete;
>>> +	unsigned int irq;
>>> +	unsigned int status;
>>> +	void __iomem *regs;
>>> +	struct clk *clk;
>>> +	struct reset_control *rstc;
>>> +};
>>> +
>>> +static irqreturn_t p2wi_interrupt(int irq, void *dev_id)
>>> +{
>>> +	struct p2wi *p2wi = dev_id;
>>> +	unsigned long status;
>>> +
>>> +	status = readl(p2wi->regs + P2WI_INTS);
>>> +	p2wi->status = status;
>>> +
>>> +	/* Clear interrupts */
>>> +	status &= (P2WI_LOAD_BSY | P2WI_TRANS_ERR | P2WI_TRANS_OVER);
>>> +	writel(status, p2wi->regs + P2WI_INTS);
>>> +
>>> +	complete(&p2wi->complete);
>>> +
>>> +	return IRQ_HANDLED;
>>> +}
>>> +
>>> +static u32 p2wi_functionality(struct i2c_adapter *adap)
>>> +{
>>> +	return I2C_FUNC_SMBUS_BYTE_DATA;
>>> +}
>>> +
>>> +static int p2wi_smbus_xfer(struct i2c_adapter *adap, u16 addr,
>>> +			   unsigned short flags, char read_write,
>>> +			   u8 command, int size, union i2c_smbus_data *data)
>>> +{
>>> +	struct p2wi *p2wi = i2c_get_adapdata(adap);
>>> +	unsigned long dlen = P2WI_DATA_LENGTH(1);
>>> +
>>> +	/*
>>> +	 * TODO: check address consistency.
>>> +	 * The P2WI bus only support one slave. As a result it does not use
>>> +	 * the I2C address except when you're switching the slave device from
>>> +	 * I2C to P2WI mode.
>>> +	 * We should at least verify that the addr argument is consistent with
>>> +	 * the slave device address.
>>> +	 */
>>> +
>>> +	if (addr > 0xff) {
>>> +		dev_err(&adap->dev, "invalid P2WI address\n");
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	/*
>>> +	 * TODO: handle switch to P2WI mode.
>>> +	 * At the moment, we're considering the slave device as already
>>> +	 * switchedto P2WI (which means the bootloader has to switch the slave
>>                    ^ you need a space here
>>
>>> +	 * device from I2C to P2WI mode).
>>> +	 * We need at least 3 informations to launch the switch process:
>>> +	 * - the slave device address (addr argument)
>>> +	 * - the mode register
>>> +	 * - the P2WI mode value (to write in the mode register)
>>> +	 */
>>> +
>>> +	if (!data)
>>> +		return -EINVAL;
>>> +
>>> +	writel(command, p2wi->regs + P2WI_DADDR0);
>>> +
>>> +	if (read_write == I2C_SMBUS_READ)
>>> +		dlen |= P2WI_READ;
>>> +	else
>>> +		writel(data->byte, p2wi->regs + P2WI_DATA0);
>>> +
>>> +	writel(dlen, p2wi->regs + P2WI_DLEN);
>>> +
>>> +	if (readl(p2wi->regs + P2WI_CTRL) & P2WI_START_TRANS) {
>>> +		dev_err(&adap->dev, "P2WI bus busy\n");
>>> +		return -EBUSY;
>>> +	}
>>> +
>>> +	reinit_completion(&p2wi->complete);
>>> +
>>> +	writel(P2WI_LOAD_BSY | P2WI_TRANS_ERR | P2WI_TRANS_OVER,
>>> +	       p2wi->regs + P2WI_INTE);
>>> +
>>> +	writel(P2WI_START_TRANS | P2WI_GLOBAL_INT_ENB, p2wi->regs + P2WI_CTRL);
>>> +
>>> +	wait_for_completion(&p2wi->complete);
>>> +
>>> +	if (p2wi->status & P2WI_LOAD_BSY) {
>>> +		dev_err(&adap->dev, "P2WI bus busy\n");
>>> +		return -EBUSY;
>>> +	}
>>> +
>>> +
>> You can drop the extra line here.
>>
>>> +	if (p2wi->status & P2WI_TRANS_ERR) {
>>> +		dev_err(&adap->dev, "P2WI bus xfer error\n");
>>> +		return -ENXIO;
>>> +	}
>>> +
>>> +	if (read_write == I2C_SMBUS_READ)
>>> +		data->byte = readl(p2wi->regs + P2WI_DATA0);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static const struct i2c_algorithm p2wi_algo = {
>>> +	.smbus_xfer = p2wi_smbus_xfer,
>>> +	.functionality = p2wi_functionality,
>>> +};
>>> +
>>> +static const struct of_device_id p2wi_of_match_table[] = {
>>> +	{ .compatible = "allwinner,sun6i-a31-p2wi" },
>>> +	{}
>>> +};
>>> +MODULE_DEVICE_TABLE(of, p2wi_of_match_table);
>>> +
>>> +static int p2wi_probe(struct platform_device *pdev)
>>> +{
>>> +	struct device *dev = &pdev->dev;
>>> +	struct resource *r;
>>> +	struct p2wi *p2wi;
>>> +	int ret;
>>> +
>>> +	p2wi = devm_kzalloc(dev, sizeof(struct p2wi), GFP_KERNEL);
>>> +	if (!p2wi) {
>>> +		dev_err(dev, "failed to allocate p2wi struct\n");
>>> +		return -ENOMEM;
>>> +	}
>>> +
>>> +	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>> +	p2wi->regs = devm_request_and_ioremap(dev, r);
>>> +	if (IS_ERR(p2wi->regs)) {
>>> +		ret = PTR_ERR(p2wi->regs);
>>> +		dev_err(dev, "failed to retrieve iomem resource: %d\n",
>>> +			ret);
>>> +		return ret;
>>> +	}
>> I don't see how it can work, since, when it fails,
>> devm_request_and_ioremap returns NULL. You probably meant
>> devm_ioremap_resource.
> Oops, just forgot devm_request_and_ioremap is returning NULL when it fails.
> I'll fix it.
>
> Thanks.
>
> Best Regards,
>
> Boris
>> Thanks!
>> Maxime
>>

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

