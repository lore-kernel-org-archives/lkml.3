Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab3KAMuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 08:50:14 -0400
Received: from sauhun.de ([89.238.76.85]:42640 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab3KAMuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 08:50:11 -0400
Date: Fri, 1 Nov 2013 13:49:58 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Christian Daudt <bcm@fixthebug.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RESEND PATCH 1/4] i2c: i2c-bcm-kona: Introduce Broadcom I2C
 Driver
Message-ID: <20131101124958.GB6734@katana>
References: <1381960909-1735-1-git-send-email-tim.kryger@linaro.org>
 <1381960909-1735-2-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
Content-Disposition: inline
In-Reply-To: <1381960909-1735-2-git-send-email-tim.kryger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2013 at 03:01:46PM -0700, Tim Kryger wrote:
> Introduce support for Broadcom Serial Controller (BSC) I2C bus found
> in the Kona family of Mobile SoCs.  FIFO hardware is utilized but only
> standard mode (100kHz), fast mode (400kHz), and fast mode plus (1MHz)
> bus speeds are supported.
>=20
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> Reviewed-by: Matt Porter <matt.porter@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>

Looks mostly good, some remarks:

> +struct bcm_kona_i2c_dev {
> +	/* Pointer to linux device struct */
> +	struct device *device;
> +
> +	/* Virtual address where registers are mapped */
> +	void __iomem *base;
> +
> +	/* Interrupt */
> +	int irq;
> +
> +	/* Standard Speed configuration */
> +	const struct bus_speed_cfg *std_cfg;
> +
> +	/* Linux I2C adapter struct */
> +	struct i2c_adapter adapter;
> +
> +	/* Lock for the I2C device */
> +	struct mutex i2c_bcm_lock;
> +
> +	/* Completion to signal an operation finished */
> +	struct completion done;
> +
> +	/* Handle for external clock */
> +	struct clk *external_clk;
> +};

IMO most of the comments could go. Kind of stating the obvious :)


> +/* Read any amount of data using the RX FIFO from the i2c bus */
> +static int bcm_kona_i2c_read_fifo(struct bcm_kona_i2c_dev *dev,
> +				  struct i2c_msg *msg)
> +{
> +	unsigned int bytes_to_read =3D MAX_RX_FIFO_SIZE;
> +	unsigned int last_byte_nak =3D 0;
> +	unsigned int bytes_read =3D 0;
> +	unsigned int rc;

Should be signed.

> +/* Write any amount of data using TX FIFO to the i2c bus */
> +static int bcm_kona_i2c_write_fifo(struct bcm_kona_i2c_dev *dev,
> +				   struct i2c_msg *msg)
> +{
> +	unsigned int bytes_to_write =3D MAX_TX_FIFO_SIZE;
> +	unsigned int bytes_written =3D 0;
> +	unsigned int rc;

Ditto signed.

> +/* Master transfer function */
> +static int bcm_kona_i2c_xfer(struct i2c_adapter *adapter,
> +			     struct i2c_msg msgs[], int num)
> +{
> +	struct bcm_kona_i2c_dev *dev =3D i2c_get_adapdata(adapter);
> +	struct i2c_msg *pmsg;
> +	int rc =3D 0;
> +	int i;
> +
> +	mutex_lock(&dev->i2c_bcm_lock);

Huh? Why do you need that? The core has locks per bus.

> +static int bcm_kona_i2c_assign_bus_speed(struct bcm_kona_i2c_dev *dev)
> +{
> +	unsigned int bus_speed;
> +	int ret =3D of_property_read_u32(dev->device->of_node, "clock-frequency=
",
> +				       &bus_speed);
> +	if (ret < 0) {
> +		dev_err(dev->device, "missing clock-frequency property\n");
> +		return -ENODEV;
> +	}
> +
> +	switch (bus_speed) {
> +	case 100000:
> +		dev->std_cfg =3D &std_cfg_table[BCM_SPD_100K];
> +		break;
> +	case 400000:
> +		dev->std_cfg =3D &std_cfg_table[BCM_SPD_400K];
> +		break;
> +	case 1000000:
> +		dev->std_cfg =3D &std_cfg_table[BCM_SPD_1MHZ];
> +		break;
> +	default:
> +		pr_err("%d hz bus speed not supported\n", bus_speed);
> +		return -EINVAL;
> +	};

Unneeded semicolon.

> +
> +	return 0;
> +}
> +
> +static int bcm_kona_i2c_probe(struct platform_device *pdev)
> +{
> +	int rc =3D 0;
> +	struct bcm_kona_i2c_dev *dev;
> +	struct i2c_adapter *adap;
> +	struct resource *iomem;
> +
> +	/* Allocate memory for private data structure */
> +	dev =3D devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
> +	if (!dev) {
> +		rc =3D -ENOMEM;
> +		goto probe_return;

I'd prefer simply return -Esomething. The printout at probe_return is
also available via driver core.

=2E..

> +	/* Add the i2c adapter */
> +	adap =3D &dev->adapter;
> +	i2c_set_adapdata(adap, dev);
> +	adap->owner =3D THIS_MODULE;
> +	adap->class =3D UINT_MAX;	/* can be used by any I2C device */

Why do you need class based instantiation. It will most likely cost
boot-time and you have devicetree means for doing instantiation.


> +	strlcpy(adap->name, "Broadcom I2C adapter", sizeof(adap->name));
> +	adap->algo =3D &bcm_algo;
> +	adap->dev.parent =3D &pdev->dev;
> +	adap->nr =3D pdev->id;
> +	adap->dev.of_node =3D pdev->dev.of_node;
> +
> +	rc =3D i2c_add_numbered_adapter(adap);

Maybe you want simply i2c_add_adapter here since the core has no
built-in support for of aliases?

> +
> +MODULE_AUTHOR("Broadcom");

Some email address please.

> +MODULE_DESCRIPTION("Broadcom Kona I2C Driver");
> +MODULE_LICENSE("GPL v2");

Thanks,

   Wolfram


--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSc6N2AAoJEBQN5MwUoCm26E8QAI7v0DqFQE6yAmx4inFPLc+1
nss8vrY8gVBQMs7Mc1T/YJzXhvsfdhAnsdPE7e10vInx6Wg0QPOGg6I2F1D2tjsy
FoOLGEOes/LWX5/LgDxTHDWPls2r2NRvfdXM0TTswWu0ZikyfbYOHJMysewzmXDl
0eZ5qF1etD9jCicTn5DoDi6Z+gr+rITmj8/PF+t4+DkV/UDw5XNKErUbh5lg+Qsa
+gxWpYgWAhPMilQ2VgBEUrPrPsS4RineOO5OAnljQCN/VDLY710NPeBDU0KhWuM3
im+iRtheDiVPR/qDJIsC1QbOrSIxTJUxgFHMhR4zrv3usq4NnBfIdzPPmLKHHBbD
kaCmWSzVXWzpcMWSkFOX4DX/1vhIVyaK0T6xkf34h/j7UEg7ROrI6Anwt1s9S6UW
j8hPqvOpol2/8ecuFTrwbRcf/ADpCpAX/tEMcIxdFm1hxVGERs+iUTZ+H8wnbws3
W20hz+DOP7nbC1Z3XsUVwGh3NvQWGu3OkgytHV8ErWaigOdSKRMhj/ezkc97AY7D
fS1SjxmknJC5RGMw7nvjr6rfrei6owAhEIAExhdvA+/Lve6T1MWPs8lTsZ8vAE1V
ThtJQconrwiV/ADqc15NcFqFjlGikPLLU8ugKehax+wQQDkkN60FcI6K13tsSdTd
mWT+GqDimx06fFDbPLYJ
=s74l
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--
