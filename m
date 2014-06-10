Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964885AbaFJIjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 04:39:31 -0400
Received: from sauhun.de ([89.238.76.85]:33553 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016AbaFJIj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 04:39:27 -0400
Date: Tue, 10 Jun 2014 10:38:50 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [RESEND2 PATCH v4 2/2] i2c: sunxi: add P2WI (Push/Pull 2 Wire
 Interface) controller support
Message-ID: <20140610083850.GB2620@katana>
References: <1401785392-26602-1-git-send-email-boris.brezillon@free-electrons.com>
 <1401785392-26602-3-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline
In-Reply-To: <1401785392-26602-3-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 10:49:52AM +0200, Boris BREZILLON wrote:
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

Good description. Should be a comment at the top of the driver to spread
the word.

>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/i2c/busses/Kconfig          |  12 ++
>  drivers/i2c/busses/Makefile         |   1 +
>  drivers/i2c/busses/i2c-sun6i-p2wi.c | 349 ++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 362 insertions(+)
>  create mode 100644 drivers/i2c/busses/i2c-sun6i-p2wi.c

=2E..

> +struct p2wi {
> +	struct i2c_adapter adapter;
> +	struct completion complete;
> +	unsigned int irq;

Can be a local variable in probe.

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

Why 0xff? Does the PMIC support that? I2C addresses are 7-bit. You
won't even have a slave device if it has an illegal i2c address, so this
shouldn't happen.

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

No error strings for OOM.

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
> +	 */
> +	childnp =3D of_get_next_available_child(np, NULL);
> +	if (childnp) {
> +		ret =3D of_property_read_u32(childnp, "reg", &slave_addr);
> +		if (ret || slave_addr > 0xff) {

Again: Is 8 bit range important here? Otherwise I'd leave the check to the
core.

> +			dev_err(dev, "invalid slave address on node %s\n",
> +				childnp->full_name);
> +			return -EINVAL;
> +		}
> +
> +		p2wi->slave_addr =3D slave_addr;
> +	}
> +
> +	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	p2wi->regs =3D devm_ioremap_resource(dev, r);
> +	if (IS_ERR(p2wi->regs)) {
> +		ret =3D PTR_ERR(p2wi->regs);
> +		dev_err(dev, "failed to retrieve iomem resource: %d\n", ret);

devm_ioremap_resource prints errors on its own.

> +		return ret;
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

My general suggestion: Don't be too strict on the 80 char limit. IMO this d=
angling
'ret' is not more readable.

> +		goto err_clk_disable;
> +	}

Regards,

   Wolfram

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTlsQaAAoJEBQN5MwUoCm2Q2oQAKKuEC2a6AtbE0vbVD/+VL3b
bDXI2rDmpkM1KZHr5Tj6QDigOAXqfS0XofJAXbnsf5zY82HyJiLy93OmJeTOE3z4
6QHCQ1mCDF17ot0QNbjmSCqB1DhuVixEcFG/UOlg5nqHqPJCGsTVgRM9g8wNZDq5
GqraLpZTSKIMA6WGLszK2519Ji/4nmTJS2uCu35tnX83Gx3BNWQ59ruOjxVdymQT
vtWqs71rF2IZQ8LV0ld0e3dczuKImNcMEBVNfaNHFombvVhxUTQqgIlZ8IrzVTxm
OuhFBU5WCRWVpxV/X9Pi1VeJ8SimeJI2WONRymXOLh9o+pdgnsCF+PwPGBqxl0gw
Q61YiiciaXVPZzzff6H/kVZm3s6mywCEibozCcD7cz9ehbcT/NsVuZ5xwvGFuEk6
j/5LQfDx4pDq0f8fjVmJlVs9xlMJ6CpI4551F1y+zFHlqZEJWsqSzIwq8tz0TQV/
HQFeGj6RBaagNYpq7ByqtQ76cUQL7DQV6eRDVNJAhxtWISb10xnGftRNV1/fFYJX
HMuJ/yyKoJVvjX1Sjz4bBl9RFjh1hzT6Xk5jyRLxW65oRS0oiyV0DsNUIeAV7SC9
W5enRNK/0pO4VxpJsGxbao1VfNTNSRGQS7T2duqDGziuE9o5YMaztMZCehDH4Gir
4czg1d7SMi6cOOWFmY4Q
=yrwP
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
