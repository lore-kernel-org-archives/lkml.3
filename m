Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaEIOfN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 10:35:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46445 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754237AbaEIOfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 10:35:09 -0400
Date: Fri, 9 May 2014 09:31:16 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Randy Dunlap <rdunlap@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] i2c: sunxi: add P2WI (Push/Pull 2 Wire Interface)
 controller support
Message-ID: <20140509143116.GD7047@lukather>
References: <1399485515-11243-1-git-send-email-boris.brezillon@free-electrons.com>
 <1399485515-11243-3-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CPaaJmjEtnx7DmsZ"
Content-Disposition: inline
In-Reply-To: <1399485515-11243-3-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CPaaJmjEtnx7DmsZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Boris,

On Wed, May 07, 2014 at 07:58:35PM +0200, Boris BREZILLON wrote:
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
>  drivers/i2c/busses/i2c-sun6i-p2wi.c | 375 ++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 388 insertions(+)
>  create mode 100644 drivers/i2c/busses/i2c-sun6i-p2wi.c
>=20
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index c94db1c..09bce1c 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -771,6 +771,18 @@ config I2C_STU300
>  	  This driver can also be built as a module. If so, the module
>  	  will be called i2c-stu300.
> =20
> +config I2C_SUN6I_P2WI
> +	tristate "Allwinner sun6i internal P2WI controller"
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
> index 18d18ff..58feeb9 100644
> --- a/drivers/i2c/busses/Makefile
> +++ b/drivers/i2c/busses/Makefile
> @@ -75,6 +75,7 @@ obj-$(CONFIG_I2C_SIMTEC)	+=3D i2c-simtec.o
>  obj-$(CONFIG_I2C_SIRF)		+=3D i2c-sirf.o
>  obj-$(CONFIG_I2C_ST)		+=3D i2c-st.o
>  obj-$(CONFIG_I2C_STU300)	+=3D i2c-stu300.o
> +obj-$(CONFIG_I2C_SUN6I_P2WI)	+=3D i2c-sun6i-p2wi.o
>  obj-$(CONFIG_I2C_TEGRA)		+=3D i2c-tegra.o
>  obj-$(CONFIG_I2C_VERSATILE)	+=3D i2c-versatile.o
>  obj-$(CONFIG_I2C_WMT)		+=3D i2c-wmt.o
> diff --git a/drivers/i2c/busses/i2c-sun6i-p2wi.c b/drivers/i2c/busses/i2c=
-sun6i-p2wi.c
> new file mode 100644
> index 0000000..91c9b12
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-sun6i-p2wi.c
> @@ -0,0 +1,375 @@
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
> +#define P2WI_CTRL_START_TRANS		BIT(7)
> +#define P2WI_CTRL_ABORT_TRANS		BIT(6)
> +#define P2WI_CTRL_GLOBAL_INT_ENB	BIT(1)
> +#define P2WI_CTRL_SOFT_RST		BIT(0)
> +
> +/* CLK CTRL fields */
> +#define P2WI_CCR_SDA_OUT_DELAY(v)	(((v) & 0x7) << 8)
> +#define P2WI_CCR_MAX_CLK_DIV		0xff
> +#define P2WI_CCR_CLK_DIV(v)		((v) & P2WI_CCR_MAX_CLK_DIV)
> +
> +/* STATUS fields */
> +#define P2WI_INTS_TRANS_ERR_ID(v)	(((v) >> 8) & 0xff)
> +#define P2WI_INTS_LOAD_BSY		BIT(2)
> +#define P2WI_INTS_TRANS_ERR		BIT(1)
> +#define P2WI_INTS_TRANS_OVER		BIT(0)
> +
> +/* DATA LENGTH fields*/
> +#define P2WI_DLEN_READ			BIT(4)
> +#define P2WI_DLEN_DATA_LENGTH(v)	((v - 1) & 0x7)
> +
> +/* LINE CTRL fields*/
> +#define P2WI_LCR_SCL_STATE		BIT(5)
> +#define P2WI_LCR_SDA_STATE		BIT(4)
> +#define P2WI_LCR_SCL_CTL		BIT(3)
> +#define P2WI_LCR_SCL_CTL_EN		BIT(2)
> +#define P2WI_LCR_SDA_CTL		BIT(1)
> +#define P2WI_LCR_SDA_CTL_EN		BIT(0)
> +
> +/* PMU MODE CTRL fields */
> +#define P2WI_PMCR_PMU_INIT_SEND		BIT(31)
> +#define P2WI_PMCR_PMU_INIT_DATA(v)	(((v) & 0xff) << 16)
> +#define P2WI_PMCR_PMU_MODE_REG(v)	(((v) & 0xff) << 8)
> +#define P2WI_PMCR_PMU_DEV_ADDR(v)	((v) & 0xff)
> +
> +#define P2WI_MAX_FREQ			6000000
> +
> +struct p2wi {
> +	struct i2c_adapter adapter;
> +	struct completion complete;
> +	unsigned int irq;
> +	unsigned int status;
> +	void __iomem *regs;
> +	struct clk *clk;
> +	struct reset_control *rstc;
> +	int slave_addr;
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
> +	status &=3D (P2WI_INTS_LOAD_BSY | P2WI_INTS_TRANS_ERR |
> +		   P2WI_INTS_TRANS_OVER);
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
> +	unsigned long dlen =3D P2WI_DLEN_DATA_LENGTH(1);
> +
> +	if (addr > 0xff ||
> +	    (p2wi->slave_addr >=3D 0 && addr !=3D p2wi->slave_addr)) {
> +		dev_err(&adap->dev, "invalid P2WI address\n");
> +		return -EINVAL;
> +	}
> +
> +	if (!data)
> +		return -EINVAL;
> +
> +	writel(command, p2wi->regs + P2WI_DADDR0);
> +
> +	if (read_write =3D=3D I2C_SMBUS_READ)
> +		dlen |=3D P2WI_DLEN_READ;
> +	else
> +		writel(data->byte, p2wi->regs + P2WI_DATA0);
> +
> +	writel(dlen, p2wi->regs + P2WI_DLEN);
> +
> +	if (readl(p2wi->regs + P2WI_CTRL) & P2WI_CTRL_START_TRANS) {
> +		dev_err(&adap->dev, "P2WI bus busy\n");
> +		return -EBUSY;
> +	}
> +
> +	reinit_completion(&p2wi->complete);
> +
> +	writel(P2WI_INTS_LOAD_BSY | P2WI_INTS_TRANS_ERR | P2WI_INTS_TRANS_OVER,
> +	       p2wi->regs + P2WI_INTE);
> +
> +	writel(P2WI_CTRL_START_TRANS | P2WI_CTRL_GLOBAL_INT_ENB,
> +	       p2wi->regs + P2WI_CTRL);
> +
> +	wait_for_completion(&p2wi->complete);
> +
> +	if (p2wi->status & P2WI_INTS_LOAD_BSY) {
> +		dev_err(&adap->dev, "P2WI bus busy\n");
> +		return -EBUSY;
> +	}
> +
> +	if (p2wi->status & P2WI_INTS_TRANS_ERR) {
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
> +	struct device_node *np =3D dev->of_node;
> +	struct device_node *childnp;
> +	unsigned long parent_clk_freq;
> +	int p2wi_mode_reg =3D -EINVAL;
> +	int p2wi_mode_val =3D -EINVAL;
> +	u32 clk_freq =3D 100000;
> +	struct resource *r;
> +	struct p2wi *p2wi;
> +	u32 slave_addr;
> +	int clk_div;
> +	int ret;
> +
> +	of_property_read_u32(np, "clock-frequency", &clk_freq);
> +	if (clk_freq > P2WI_MAX_FREQ) {
> +		dev_err(dev,
> +			"required clock-frequency (%u Hz) is too high (max =3D 6MHz)",
> +			clk_freq);
> +		return -EINVAL;
> +	}
> +
> +	if (of_get_child_count(np) > 1) {
> +		dev_err(dev, "P2WI only supports one slave device\n");
> +		return -EINVAL;
> +	}
> +
> +	p2wi =3D devm_kzalloc(dev, sizeof(struct p2wi), GFP_KERNEL);
> +	if (!p2wi) {
> +		dev_err(dev, "failed to allocate p2wi struct\n");
> +		return -ENOMEM;
> +	}
> +
> +	p2wi->slave_addr =3D -1;
> +
> +	/*
> +	 * Authorize a p2wi node without any children to be able to use an
> +	 * i2c-dev from userpace.
> +	 * In this case the slave_addr is set to -1 and won't be checked when
> +	 * launching a P2WI transfer.
> +	 *
> +	 * If the p2wi node contains more than one child, the first one will
> +	 * be considered as the only slave node.

If the p2wi node has more than one child, you've already bailed out :)

> +	 */
> +	childnp =3D of_get_next_available_child(np, NULL);
> +	if (childnp) {
> +		u32 tmp;
> +
> +		ret =3D of_property_read_u32(childnp, "reg", &slave_addr);
> +		if (ret || slave_addr > 0xff) {
> +			dev_err(dev, "invalid slave address on node %s\n",
> +				childnp->full_name);
> +			return -EINVAL;
> +		}
> +
> +		p2wi->slave_addr =3D slave_addr;
> +
> +		if (!of_property_read_u32(childnp, "allwinner,p2wi-mode-reg",
> +					  &tmp) && tmp < 0xff)
> +			p2wi_mode_reg =3D tmp;
> +
> +		if (!of_property_read_u32(childnp, "allwinner,p2wi-mode-val",
> +					  &tmp) && tmp < 0xff)
> +			p2wi_mode_val =3D tmp;
> +	}
> +
> +	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	p2wi->regs =3D devm_ioremap_resource(dev, r);
> +	if (IS_ERR(p2wi->regs)) {
> +		dev_err(dev, "failed to retrieve iomem resource\n");
> +		return PTR_ERR(p2wi->regs);

You seem to be returning the error code in the next error messages. It
would probably be a good idea to put it there too.

> +	}
> +
> +	snprintf(p2wi->adapter.name, sizeof(p2wi->adapter.name), pdev->name);
> +	ret =3D platform_get_irq(pdev, 0);
> +	if (ret < 0) {
> +		dev_err(dev, "failed to retrieve irq: %d\n", ret);
> +		return ret;
> +	}
> +	p2wi->irq =3D ret;
> +
> +	p2wi->clk =3D devm_clk_get(dev, NULL);
> +	if (IS_ERR(p2wi->clk)) {
> +		ret =3D PTR_ERR(p2wi->clk);
> +		dev_err(dev, "failed to retrieve clk: %d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	ret =3D clk_prepare_enable(p2wi->clk);
> +	if (ret) {
> +		dev_err(dev, "failed to enable clk: %d\n", ret);
> +		return ret;
> +	}
> +
> +	parent_clk_freq =3D clk_get_rate(p2wi->clk);
> +
> +	p2wi->rstc =3D devm_reset_control_get(dev, NULL);
> +	if (IS_ERR(p2wi->rstc)) {
> +		ret =3D PTR_ERR(p2wi->rstc);
> +		dev_err(dev, "failed to retrieve reset controller: %d\n",
> +			ret);
> +		goto err_clk_disable;
> +	}
> +
> +	ret =3D reset_control_deassert(p2wi->rstc);
> +	if (ret) {
> +		dev_err(dev, "failed to deassert reset line: %d\n",
> +			ret);
> +		goto err_clk_disable;
> +	}
> +
> +	init_completion(&p2wi->complete);
> +	p2wi->adapter.dev.parent =3D dev;
> +	p2wi->adapter.algo =3D &p2wi_algo;
> +	p2wi->adapter.owner =3D THIS_MODULE;
> +	p2wi->adapter.dev.of_node =3D pdev->dev.of_node;
> +	platform_set_drvdata(pdev, p2wi);
> +	i2c_set_adapdata(&p2wi->adapter, p2wi);
> +
> +	ret =3D devm_request_irq(dev, p2wi->irq, p2wi_interrupt, 0, pdev->name,
> +			       p2wi);
> +	if (ret) {
> +		dev_err(dev, "can't register interrupt handler irq%d: %d\n",
> +			p2wi->irq, ret);
> +		goto err_reset_assert;
> +	}
> +
> +	writel(P2WI_CTRL_SOFT_RST, p2wi->regs + P2WI_CTRL);
> +
> +	clk_div =3D parent_clk_freq / clk_freq;
> +	if (!clk_div) {
> +		dev_warn(dev,
> +			 "clock-frequency is too high, setting it to %lu Hz\n",
> +			 parent_clk_freq);
> +		clk_div =3D 1;
> +	} else if (clk_div > P2WI_CCR_MAX_CLK_DIV) {
> +		dev_warn(dev,
> +			 "clock-frequency is too low, setting it to %lu Hz\n",
> +			 parent_clk_freq / P2WI_CCR_MAX_CLK_DIV);
> +		clk_div =3D P2WI_CCR_MAX_CLK_DIV;
> +	}
> +
> +	writel(P2WI_CCR_SDA_OUT_DELAY(1) | P2WI_CCR_CLK_DIV(clk_div),
> +	       p2wi->regs + P2WI_CCR);
> +
> +	if (p2wi_mode_reg >=3D 0 && p2wi_mode_val >=3D 0) {
> +		writel(P2WI_PMCR_PMU_INIT_SEND |
> +		       P2WI_PMCR_PMU_MODE_REG(p2wi_mode_reg) |
> +		       P2WI_PMCR_PMU_INIT_DATA(p2wi_mode_val) |
> +		       P2WI_PMCR_PMU_DEV_ADDR(p2wi->slave_addr),
> +		       p2wi->regs + P2WI_PMCR);
> +
> +		while (readl(p2wi->regs + P2WI_PMCR) &
> +		       P2WI_PMCR_PMU_INIT_SEND)
> +			cpu_relax();
> +	}

Did we actually encounter such a case? From what I've seen so far,
both community's u-boot and Allwinner's bootloader already do this.

As you know, I'm really not fond of putting random values and
registers offsets into the DT itself. Making the assumption that the
PMIC is already switched to P2WI by the bootloader seems pretty safe
to me.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--CPaaJmjEtnx7DmsZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTbOa0AAoJEBx+YmzsjxAgaVcQALBMx6uvD6XqRA6C1yNR77lz
aNj33ifo3j/sPKd/entxiq9xPFbjlteQe3ee4BaKxiiSpC9DFbjmXCjdTsxKC/aL
QpsA30tWNJHtnJBKodjssaHCSTbd7yIv6+sIfDQ6IyTzyPR0d0avvy9dptwXuPAj
qetNUMGY8VyDrANzUEBOkvcH1Qaoui3OGySgW5/gqQZJLGiso48vsqPsXFpTAive
llf63RYq6cPK+HrLVs93a0clZjnCgj4DxJdb8PEpgjxlticcs++ckgiEcMWvvG23
fcAi9opDwBtg7isZtX618kMU7Lhu0wxgHKFIXoAHlaLhQ3Q9ZxpxRpFb17T1iQbl
zFQu73MURj3q/W05UyoXUMYQU6fYS6PPsCVvlmjUUIBh3L/pr4xp8JxdiuArESuD
mitPAreWQ5n5t83qTzriAoFh5yAJmrwe4f0z1zd/Ifv0Bbkb5l+/zszbhArrMSgl
YlW746UIqqo0C94fskPRhnjmeR2j6ohYMYKPdSuc6BSxUMPAfwsmVotBwGdCtC8s
eSjtSnF/SIBtPDx+rjvnAPhc0DkFqkfBPf12DpuFuBJC1GJ/9f7j4htvCojCM3PT
CuhF5zmvmuQdpwhfgeHow9BZMyYBzL0CHq87JVKI39tvhs9bJVpSfM4KE4v4rFXu
XbGFBqAZs6pd4UdDyrqn
=WG+V
-----END PGP SIGNATURE-----

--CPaaJmjEtnx7DmsZ--
