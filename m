Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab3KALRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 07:17:05 -0400
Received: from sauhun.de ([89.238.76.85]:44746 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704Ab3KALRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 07:17:02 -0400
Date: Fri, 1 Nov 2013 12:16:47 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: srinivas.kandagatla@st.com, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        stephen.gallimore@st.com, stuart.menefy@st.com,
        Lee Jones <lee.jones@linaro.org>, gabriel.fernandez@st.com
Subject: Re: [PATCH v5 1/4] i2c: busses: i2c-st: Add ST I2C controller
Message-ID: <20131101111645.GA4260@katana>
References: <1381754813-4679-1-git-send-email-maxime.coquelin@st.com>
 <1381754813-4679-2-git-send-email-maxime.coquelin@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <1381754813-4679-2-git-send-email-maxime.coquelin@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 14, 2013 at 02:46:49PM +0200, Maxime COQUELIN wrote:
> This patch adds support to SSC (Synchronous Serial Controller)
> I2C driver. This IP also supports SPI protocol, but this is not
> the aim of this driver.
>=20
> This IP is embedded in all ST SoCs for Set-top box platorms, and
> supports I2C Standard and Fast modes.
>=20
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
> ---
>  Documentation/devicetree/bindings/i2c/i2c-st.txt |   38 +
>  drivers/i2c/busses/Kconfig                       |   10 +
>  drivers/i2c/busses/Makefile                      |    1 +
>  drivers/i2c/busses/i2c-st.c                      |  867 ++++++++++++++++=
++++++
>  4 files changed, 916 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-st.txt
>  create mode 100644 drivers/i2c/busses/i2c-st.c
>=20
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-st.txt b/Documenta=
tion/devicetree/bindings/i2c/i2c-st.txt
> new file mode 100644
> index 0000000..8b2fd0b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/i2c/i2c-st.txt
> @@ -0,0 +1,38 @@
> +ST SSC binding, for I2C mode operation
> +
> +Required properties :
> +- compatible : Must be "st,comms-i2c"

I personally don't care about naming here. Has there been a solution
now?

> +- reg : Offset and length of the register set for the device
> +- interrupts : the interrupt specifier
> +- clock-names: Must contain "ssc".
> +- clocks: Must contain an entry for each name in clock-names. See the co=
mmon
> +  clock bindings.
> +- A pinctrl state named "default" must be defined, using the bindings in
> +  ../pinctrl/pinctrl-binding.txt
> +
> +Optional properties :
> +- clock-frequency : Desired I2C bus clock frequency in Hz. If not specif=
ied,
> +  the default 100 kHz frequency will be used. As only Normal and Fast mo=
des
> +  are supported, possible values are 100000 and 400000.
> +- i2c-min-scl-pulse-width-us : The minimum valid SCL pulse width that is
> +  allowed through the deglitch circuit. In units of us.
> +- i2c-min-sda-pulse-width-us : The minimum valid SDA pulse width that is
> +  allowed through the deglitch circuit. In units of us.

Okay, so we had lots of dt bindings discussions at kernel summit. Since
we don't have unstable bindings yet, I have been convinced that it is
okay two have one or two vendor specific bindings before introducing a
generic one. That will create a little bit of cruft, but increases
chances that the generic bindings are proper. So, really sorry for going
back and forth, but it was important for the process. Vendor binding is
it now. Period.

=2E..

> +/**
> + * struct st_i2c_deglitch - Anti-glitch filter configuration
> + * @scl_min_width_us: SCL line minimum pulse width in ns
> + * @sda_min_width_us: SDA line minimum pulse width in ns
> + */
> +struct st_i2c_deglitch {
> +	u32	scl_min_width_us;
> +	u32	sda_min_width_us;
> +};

Minor: Why a seperate struct?

> +/**
> + * st_i2c_handle_write() - Handle FIFO enmpty interrupt in case of read
> + * @i2c_dev: Controller's private data
> + */
> +static void st_i2c_handle_read(struct st_i2c_dev *i2c_dev)
> +{
> +	struct st_i2c_client *c =3D &i2c_dev->client;
> +	u32 ien;
> +
> +	/* Trash the address read back */
> +	if (!c->xfered) {
> +		readl(i2c_dev->base + SSC_RBUF);
> +		st_i2c_clr_bits(i2c_dev->base + SSC_I2C, SSC_I2C_TXENB);
> +	} else
> +		st_i2c_read_rx_fifo(i2c_dev);

Braces around else branch.

> +
> +	if (!c->count) {
> +		/* End of xfer, send stop or repstart */
> +		st_i2c_terminate_xfer(i2c_dev);
> +	} else if (c->count =3D=3D 1) {
> +		/* Penultimate byte to xfer, disable ACK gen. */
> +		st_i2c_clr_bits(i2c_dev->base + SSC_I2C, SSC_I2C_ACKG);
> +
> +		/* Last received byte is to be handled by NACK interrupt */
> +		ien =3D SSC_IEN_NACKEN | SSC_IEN_ARBLEN;
> +		writel(ien, i2c_dev->base + SSC_IEN);
> +
> +		st_i2c_rd_fill_tx_fifo(i2c_dev, c->count);
> +	} else
> +		st_i2c_rd_fill_tx_fifo(i2c_dev, c->count - 1);

Braces around else branch.

> +}
> +static int st_i2c_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np =3D pdev->dev.of_node;
> +	struct st_i2c_dev *i2c_dev;
> +	struct resource *res;
> +	u32 clk_rate;
> +	struct i2c_adapter *adap;
> +	int ret;
> +
> +	i2c_dev =3D devm_kzalloc(&pdev->dev, sizeof(*i2c_dev), GFP_KERNEL);
> +	if (!i2c_dev)
> +		return -ENOMEM;
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	i2c_dev->base =3D devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(i2c_dev->base))
> +		return PTR_ERR(i2c_dev->base);
> +
> +	i2c_dev->irq =3D irq_of_parse_and_map(np, 0);
> +	if (!i2c_dev->irq) {
> +		dev_err(&pdev->dev, "IRQ missing or invalid\n");
> +		return -EINVAL;
> +	}
> +
> +	i2c_dev->clk =3D of_clk_get_by_name(np, "ssc");
> +	if (IS_ERR(i2c_dev->clk)) {
> +		dev_err(&pdev->dev, "Unable to request clock\n");
> +		return PTR_ERR(i2c_dev->clk);
> +	}
> +
> +	i2c_dev->mode =3D I2C_MODE_STANDARD;
> +	ret =3D of_property_read_u32(np, "clock-frequency", &clk_rate);
> +	if ((!ret) && (clk_rate =3D=3D 400000))
> +		i2c_dev->mode =3D I2C_MODE_FAST;
> +
> +	i2c_dev->dev =3D &pdev->dev;
> +
> +	ret =3D devm_request_irq(&pdev->dev, i2c_dev->irq, st_i2c_isr, 0,
> +			pdev->name, i2c_dev);

Suggestion: Maybe threaded irq since you do fifo handling in the isr?

> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to request irq %i\n", i2c_dev->irq);
> +		return ret;
> +	}
> +
> +	pinctrl_pm_select_default_state(i2c_dev->dev);
> +	/* In case idle state available, select it */
> +	pinctrl_pm_select_idle_state(i2c_dev->dev);
> +
> +	ret =3D st_i2c_of_get_deglitch(np, i2c_dev);
> +	if (ret)
> +		return ret;
> +
> +	adap =3D &i2c_dev->adap;
> +	i2c_set_adapdata(adap, i2c_dev);
> +	snprintf(adap->name, sizeof(adap->name), "ST I2C(0x%08x)", res->start);

resource_size_t can also be 64 bit.

> +	adap->owner =3D THIS_MODULE;
> +	adap->timeout =3D 2 * HZ;
> +	adap->retries =3D 0;
> +	adap->class =3D I2C_CLASS_HWMON | I2C_CLASS_DDC | I2C_CLASS_SPD;

This question is still open:
Why do you need class based instantiation. It will most likely cost
boot-time and you have devicetree means for doing instantiation.

> +	adap->algo =3D &st_i2c_algo;
> +	adap->dev.parent =3D &pdev->dev;
> +	adap->dev.of_node =3D pdev->dev.of_node;
> +
> +	init_completion(&i2c_dev->complete);
> +
> +	ret =3D i2c_add_adapter(adap);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to add adapter\n");
> +		return ret;
> +	}
> +
> +	platform_set_drvdata(pdev, i2c_dev);
> +
> +	dev_info(i2c_dev->dev, "%s initialized\n", adap->name);
> +
> +	return 0;
> +}
> +

Rest looks good! We are mostly ready to go.

Thanks,

   Wolfram


--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSc42cAAoJEBQN5MwUoCm22i4P/RA1kcBSqMqqCtEkEBw68ssI
U6jHqnV9wOnexgCwo8opjw6iFtSlnSD5VIN9Vjime0Ay5fwVgG14SH4+S7dRGeRY
f4IZaKkQLuu7zvmGv4YEmvnywSU9zYVy8OeTl70VOaf7F8jE4LGJKBS7SUApykhK
Frz5dyzd80CRcgMm9qonyckpxXIH5C02XX/y4Mts8hdRxs+yUkq0xGLWKaIq6KOT
M5rOzV2SE99wAWcJkT1VcE/GfvCAAU5nvEM6/ewSijW0eBMhAVPCZ879+6nqwWcu
0AXls5vzn9UhLYk3XWBPTMUylcgz6achBsKRpOrYV82mEOOtCKLDvzCCYwoH5lxU
9PQ0qpGgVS4jGK1sKO3y4u2VdSDqlvekdYsqIFywPMIzX9s+FG+hTj0tGJKq5MX8
7Pvm0DH6rgCdx5tqv0Qv9Jmx1DSKLdBC6x7ginRUtvyL7HNnfNm6tOMLHcojNXwO
EVkRvFW89DjqFou1XD6KiRTKr1p2QzbZq0yy2FyTygLc7Fic18bfkBOwPxfCxvI0
TzjbXi+o/v4v/5Rd4QAHGKQEOMhUW9WGQawOMlLBByU13ULw0/aK07x7teMjDfvS
s2Pb+ZzdBzqWrvm5QBplDn+MfI7Bmg4LNpssgjSbyBFMJNQWeZRCF6ig+9xyZJYo
2Z+2g/dIrhG33VngSWCm
=lrd5
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
