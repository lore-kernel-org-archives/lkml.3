Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbaDXNaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 09:30:11 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38325 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754348AbaDXNaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 09:30:04 -0400
Date: Thu, 24 Apr 2014 15:29:12 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Randy Dunlap <rdunlap@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] i2c: sunxi: add P2WI (Push/Pull 2 Wire Interface)
 controller support
Message-ID: <20140424132912.GA24905@lukather>
References: <1398340516-29547-1-git-send-email-boris.brezillon@free-electrons.com>
 <1398340516-29547-3-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5cXpu7evJfjLw2dJ"
Content-Disposition: inline
In-Reply-To: <1398340516-29547-3-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5cXpu7evJfjLw2dJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2014 at 01:55:16PM +0200, Boris BREZILLON wrote:
> The P2WI looks like an SMBus controller which only supports byte data
> transfers. But, it differs from standard SMBus protocol on several
> aspects:
> - it supports only one slave device, and thus drop the address field
> - it adds a parity bit every 8bits of data
> - only one read access is required to read a byte (instead of a read
>   followed by a write access in standard SMBus protocol)
> - there's no Ack bit after each byte transfer
>=20
> This means this bus cannot be used to interface with standard SMBus
> devices (the only known device to support this interface is the AXP221
> PMIC).
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  drivers/i2c/busses/Kconfig          |  12 ++
>  drivers/i2c/busses/Makefile         |   1 +
>  drivers/i2c/busses/i2c-sunxi-p2wi.c | 317 ++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 330 insertions(+)
>  create mode 100644 drivers/i2c/busses/i2c-sunxi-p2wi.c
>=20
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index c94db1c..37e53d6 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -771,6 +771,18 @@ config I2C_STU300
>  	  This driver can also be built as a module. If so, the module
>  	  will be called i2c-stu300.
> =20
> +config I2C_SUNXI_P2WI
> +	tristate "Allwinner sunxi internal P2WI controller"

Since the A31 is the only SoC that uses it, maybe you can drop the
sunxi and use either sun6i or A31 here?

> +	depends on ARCH_SUNXI
> +	help
> +	  If you say yes to this option, support will be included for the
> +	  P2WI (Push/Pull 2 Wire Interface) controller embedded in some sunxi
> +	  SOCs.
> +	  The P2WI looks like an SMBus controller (which supports only byte
> +	  accesses), except that it only supports one slave device.
> +	  This interface is used to connect to specific PMIC devices (like the
> +	  AXP221).
> +
>  config I2C_TEGRA
>  	tristate "NVIDIA Tegra internal I2C controller"
>  	depends on ARCH_TEGRA
> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> index 18d18ff..c63d2ec 100644
> --- a/drivers/i2c/busses/Makefile
> +++ b/drivers/i2c/busses/Makefile
> @@ -75,6 +75,7 @@ obj-$(CONFIG_I2C_SIMTEC)	+=3D i2c-simtec.o
>  obj-$(CONFIG_I2C_SIRF)		+=3D i2c-sirf.o
>  obj-$(CONFIG_I2C_ST)		+=3D i2c-st.o
>  obj-$(CONFIG_I2C_STU300)	+=3D i2c-stu300.o
> +obj-$(CONFIG_I2C_SUNXI_P2WI)	+=3D i2c-sunxi-p2wi.o
>  obj-$(CONFIG_I2C_TEGRA)		+=3D i2c-tegra.o
>  obj-$(CONFIG_I2C_VERSATILE)	+=3D i2c-versatile.o
>  obj-$(CONFIG_I2C_WMT)		+=3D i2c-wmt.o
> diff --git a/drivers/i2c/busses/i2c-sunxi-p2wi.c b/drivers/i2c/busses/i2c=
-sunxi-p2wi.c
> new file mode 100644
> index 0000000..e3fdd76
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-sunxi-p2wi.c
> @@ -0,0 +1,317 @@
> +/*
> + * P2WI (Push-Pull Two Wire Interface) bus driver.
> + *
> + * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
> + *
> + * This file is licensed under the terms of the GNU General Public Licen=
se
> + * version 2.  This program is licensed "as is" without any warranty of =
any
> + * kind, whether express or implied.
> + */
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/spinlock.h>
> +#include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/io.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/of_irq.h>
> +#include <linux/clk.h>
> +#include <linux/err.h>
> +#include <linux/delay.h>
> +#include <linux/clk.h>
> +#include <linux/reset.h>
> +
> +
> +/* P2WI registers */
> +#define P2WI_CTRL		0x0
> +#define P2WI_CCR		0x4
> +#define P2WI_INTE		0x8
> +#define P2WI_INTS		0xc
> +#define P2WI_DADDR0		0x10
> +#define P2WI_DADDR1		0x14
> +#define P2WI_DLEN		0x18
> +#define P2WI_DATA0		0x1c
> +#define P2WI_DATA1		0x20
> +#define P2WI_LCR		0x24
> +#define P2WI_PMCR		0x28
> +
> +/* CTRL fields */
> +#define P2WI_START_TRANS	(1 << 7)
> +#define P2WI_ABORT_TRANS	(1 << 6)
> +#define P2WI_GLOBAL_INT_ENB	(1 << 1)
> +#define P2WI_SOFT_RST		(1 << 0)

BIT() ?

> +/* CLK CTRL fields */
> +#define P2WI_SDA_OUT_DELAY(v)	(((v) & 0x7) << 8)
> +#define P2WI_CLK_DIV(v)		((v) & 0xff)
> +
> +/* STATUS fields */
> +#define P2WI_TRANS_ERR_ID(v)	(((v) >> 8) & 0xff)
> +#define P2WI_LOAD_BSY		(1 << 2)
> +#define P2WI_TRANS_ERR		(1 << 1)
> +#define P2WI_TRANS_OVER		(1 << 0)
> +
> +/* DATA LENGTH fields*/
> +#define P2WI_READ		(1 << 4)
> +#define P2WI_DATA_LENGTH(v)	((v - 1) & 0x7)
> +
> +/* LINE CTRL fields*/
> +#define P2WI_SCL_STATE		(1 << 5)
> +#define P2WI_SDA_STATE		(1 << 4)
> +#define P2WI_SCL_CTL		(1 << 3)
> +#define P2WI_SCL_CTL_EN		(1 << 2)
> +#define P2WI_SDA_CTL		(1 << 1)
> +#define P2WI_SDA_CTL_EN		(1 << 0)
> +
> +/* PMU MODE CTRL fields */
> +#define P2WI_PMU_INIT_SEND	(1 << 31)
> +#define P2WI_PMU_INIT_DATA(v)	(((v) & 0xff) << 16)
> +#define P2WI_PMU_MODE_REG(v)	(((v) & 0xff) << 8)
> +#define P2WI_PMU_DEV_ADDR(v)	((v) & 0xff)

I'd very much prefer if your bits were prefixed by the register
name. That way, you directly know in which register that bit belong,
without having to scroll across the whole driver.

> +
> +struct p2wi {
> +	struct i2c_adapter adapter;
> +	struct completion complete;
> +	unsigned int irq;
> +	unsigned int status;
> +	void __iomem *regs;
> +	struct clk *clk;
> +	struct reset_control *rstc;
> +};
> +
> +static irqreturn_t p2wi_interrupt(int irq, void *dev_id)
> +{
> +	struct p2wi *p2wi =3D dev_id;
> +	unsigned long status;
> +
> +	status =3D readl(p2wi->regs + P2WI_INTS);
> +	p2wi->status =3D status;
> +
> +	/* Clear interrupts */
> +	status &=3D (P2WI_LOAD_BSY | P2WI_TRANS_ERR | P2WI_TRANS_OVER);
> +	writel(status, p2wi->regs + P2WI_INTS);
> +
> +	complete(&p2wi->complete);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static u32 p2wi_functionality(struct i2c_adapter *adap)
> +{
> +	return I2C_FUNC_SMBUS_BYTE_DATA;
> +}
> +
> +static int p2wi_smbus_xfer(struct i2c_adapter *adap, u16 addr,
> +			   unsigned short flags, char read_write,
> +			   u8 command, int size, union i2c_smbus_data *data)
> +{
> +	struct p2wi *p2wi =3D i2c_get_adapdata(adap);
> +	unsigned long dlen =3D P2WI_DATA_LENGTH(1);
> +
> +	/*
> +	 * TODO: check address consistency.
> +	 * The P2WI bus only support one slave. As a result it does not use
> +	 * the I2C address except when you're switching the slave device from
> +	 * I2C to P2WI mode.
> +	 * We should at least verify that the addr argument is consistent with
> +	 * the slave device address.
> +	 */
> +
> +	if (addr > 0xff) {
> +		dev_err(&adap->dev, "invalid P2WI address\n");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * TODO: handle switch to P2WI mode.
> +	 * At the moment, we're considering the slave device as already
> +	 * switchedto P2WI (which means the bootloader has to switch the slave

                   ^ you need a space here

> +	 * device from I2C to P2WI mode).
> +	 * We need at least 3 informations to launch the switch process:
> +	 * - the slave device address (addr argument)
> +	 * - the mode register
> +	 * - the P2WI mode value (to write in the mode register)
> +	 */
> +
> +	if (!data)
> +		return -EINVAL;
> +
> +	writel(command, p2wi->regs + P2WI_DADDR0);
> +
> +	if (read_write =3D=3D I2C_SMBUS_READ)
> +		dlen |=3D P2WI_READ;
> +	else
> +		writel(data->byte, p2wi->regs + P2WI_DATA0);
> +
> +	writel(dlen, p2wi->regs + P2WI_DLEN);
> +
> +	if (readl(p2wi->regs + P2WI_CTRL) & P2WI_START_TRANS) {
> +		dev_err(&adap->dev, "P2WI bus busy\n");
> +		return -EBUSY;
> +	}
> +
> +	reinit_completion(&p2wi->complete);
> +
> +	writel(P2WI_LOAD_BSY | P2WI_TRANS_ERR | P2WI_TRANS_OVER,
> +	       p2wi->regs + P2WI_INTE);
> +
> +	writel(P2WI_START_TRANS | P2WI_GLOBAL_INT_ENB, p2wi->regs + P2WI_CTRL);
> +
> +	wait_for_completion(&p2wi->complete);
> +
> +	if (p2wi->status & P2WI_LOAD_BSY) {
> +		dev_err(&adap->dev, "P2WI bus busy\n");
> +		return -EBUSY;
> +	}
> +
> +

You can drop the extra line here.

> +	if (p2wi->status & P2WI_TRANS_ERR) {
> +		dev_err(&adap->dev, "P2WI bus xfer error\n");
> +		return -ENXIO;
> +	}
> +
> +	if (read_write =3D=3D I2C_SMBUS_READ)
> +		data->byte =3D readl(p2wi->regs + P2WI_DATA0);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_algorithm p2wi_algo =3D {
> +	.smbus_xfer =3D p2wi_smbus_xfer,
> +	.functionality =3D p2wi_functionality,
> +};
> +
> +static const struct of_device_id p2wi_of_match_table[] =3D {
> +	{ .compatible =3D "allwinner,sun6i-a31-p2wi" },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, p2wi_of_match_table);
> +
> +static int p2wi_probe(struct platform_device *pdev)
> +{
> +	struct device *dev =3D &pdev->dev;
> +	struct resource *r;
> +	struct p2wi *p2wi;
> +	int ret;
> +
> +	p2wi =3D devm_kzalloc(dev, sizeof(struct p2wi), GFP_KERNEL);
> +	if (!p2wi) {
> +		dev_err(dev, "failed to allocate p2wi struct\n");
> +		return -ENOMEM;
> +	}
> +
> +	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	p2wi->regs =3D devm_request_and_ioremap(dev, r);
> +	if (IS_ERR(p2wi->regs)) {
> +		ret =3D PTR_ERR(p2wi->regs);
> +		dev_err(dev, "failed to retrieve iomem resource: %d\n",
> +			ret);
> +		return ret;
> +	}

I don't see how it can work, since, when it fails,
devm_request_and_ioremap returns NULL. You probably meant
devm_ioremap_resource.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--5cXpu7evJfjLw2dJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTWRGnAAoJEBx+YmzsjxAgkY4P/jW51RMQJ3lS9zCZOTFkWC2o
WH6SFHxMY+dbXrihh5Cber9p3agHf+BYsbJgrabPxV0+oOx2HUsctxQ+Tm8EHGVt
j38vFqr6Z2cV8velqkIpr7MqMr3a6VNTz4aBDFQ9FanbpkTPwBt0YVG10kBEN8ni
xQ/VDnFYMs03MGYstpJJZCuBP2TDDR/oHITQvzH10WI62AsyrWbhsJ98OrhVfeDN
XKEsZeT4Rag2CzE6HbfFGTjWKFb5VP7BiCjifsCZJ1SymMwCW3PmNGsKpzytmcGn
SeaIqxMpGkjhr7yfR6c/8rrSUOnijEP28bP+QHj94n1sbITe2FWfjPcne/WH7UUl
Ind+3RDvLdwnwfYYhx+xR9IOjK6FDslCZBz8PnK8vTFhEMeYOvOTXLLu60xVrup+
LrmKRUAQe5aYYow0tBYSb3ivsmkOvvHp1cteKY2wFmKOzfwkbi3znLa0XWwce10L
j+hGGw35T0/yQGbMWMXIMHwPC+EShYdR095b8tm0XkU1DNxoF8ksPxcYMlq95Ygy
dXYELBZTW74ZBXizCMi3MjHOqr+fMEfFiHZR96p49NaQB5CNP16Eyth0nVxrPqEX
wwW+n7SzG5C26RVbgB6mmrw3ItDIa0TU/Da/2oLUj1Alu6ko/BNZrRAyvN7PAAol
9swwaLs7LefGhreZdAd1
=WjbA
-----END PGP SIGNATURE-----

--5cXpu7evJfjLw2dJ--
