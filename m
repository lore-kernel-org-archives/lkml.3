Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547AbbAEUVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 15:21:37 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45480 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbbAEUVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 15:21:36 -0500
Date: Mon, 5 Jan 2015 14:20:32 -0600
From: Felipe Balbi <balbi@ti.com>
To: Dave Gerlach <d-gerlach@ti.com>, Tony Lindgren <tony@atomide.com>
CC: <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Benoit Cousson <bcousson@baylibre.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Suman Anna <s-anna@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 3/3] remoteproc: wkup_m3: Add wkup_m3 remote proc driver
Message-ID: <20150105202032.GQ19336@saruman>
Reply-To: <balbi@ti.com>
References: <1420228319-41085-1-git-send-email-d-gerlach@ti.com>
 <1420228319-41085-4-git-send-email-d-gerlach@ti.com>
 <20150102200424.GD4920@saruman>
 <54AAEFA6.3080603@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UJEqbsikIZBgizPR"
Content-Disposition: inline
In-Reply-To: <54AAEFA6.3080603@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UJEqbsikIZBgizPR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jan 05, 2015 at 02:10:14PM -0600, Dave Gerlach wrote:
> >> Add a remoteproc driver to load the firmware for and boot the wkup_m3
> >> present on am33xx. The wkup_m3 is an integrated Cortex M3 that allows
> >> the SoC to enter the lowest possible power state by taking control from
> >> the MPU after it has gone into its own low power state and shutting off
> >> any additional peripherals.
> >>
> >> The driver expects a resource table to be present in the wkup_m3
> >> firmware to define the required memory resources needed by the wkup_m3,
> >> at least the data memory so that the firmware can be copied to the pro=
per
> >> place for execution.
> >>
> >> Signed-off-by: Dave Gerlach <d-gerlach@ti.com>
> >> ---
> >>  drivers/remoteproc/Kconfig         |  12 +++
> >>  drivers/remoteproc/Makefile        |   1 +
> >>  drivers/remoteproc/wkup_m3_rproc.c | 175 ++++++++++++++++++++++++++++=
+++++++++
> >>  3 files changed, 188 insertions(+)
> >>  create mode 100644 drivers/remoteproc/wkup_m3_rproc.c
> >>
> >> diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
> >> index 5e343ba..7fbdb53 100644
> >> --- a/drivers/remoteproc/Kconfig
> >> +++ b/drivers/remoteproc/Kconfig
> >> @@ -41,6 +41,18 @@ config STE_MODEM_RPROC
> >>  	  This can be either built-in or a loadable module.
> >>  	  If unsure say N.
> >> =20
> >> +config WKUP_M3_RPROC
> >> +	bool "AM33xx wkup-m3 remoteproc support"
> >=20
> > it would be nicer if this could be a loadable module.
>=20
> Do we really want that though? This is required for core PM functionality=
 like
> CPUIdle and Suspend/resume, I feel that it should always be built in for =
am335x.
> I had been taking this approach with all of the PM dependencies.

right, will we have CPUIdle or suspend/resume during boot ?

> >> +static const struct of_device_id wkup_m3_rproc_of_match[] =3D {
> >> +	{
> >> +		.compatible =3D "ti,am3353-wkup-m3",
> >> +		.data =3D (void *)"am335x-pm-firmware.elf",
> >=20
> > do you know of anybody else who might want to different firmware image
> > name ? Otherwise why pass it as driver_data ?
>=20
> I suppose we could pass the name in the devicetree. I do not know of any =
other
> users of other firmware but it's probably better to keep things flexible.

or, since this is handled internally to the driver, we can refactor this
name passing later, when we actually need a different firmware depending
on different devices. No ?

> >> +static int wkup_m3_rproc_probe(struct platform_device *pdev)
> >> +{
> >> +	struct device *dev =3D &pdev->dev;
> >> +	const char *fw_name;
> >> +	struct wkup_m3_platform_data *pdata =3D dev->platform_data;
> >> +	struct wkup_m3_rproc *m3_rproc;
> >> +	const struct of_device_id *match;
> >> +	struct rproc *rproc;
> >> +	int ret;
> >> +
> >> +	if (!(pdata && pdata->deassert_reset && pdata->assert_reset &&
> >> +	      pdata->reset_name)) {
> >> +		dev_err(dev, "Platform data missing!\n");
> >> +		return -ENODEV;
> >> +	}
> >=20
> > if pdata is missing, couldn't you assume the thing has been reset and
> > try to load anyway ?
>=20
> Probably not, we MUST reset after loading the firmware as that is what bo=
ots the
> wkup_m3.

alright, perhaps add a comment ?

> >> +	match =3D of_match_device(wkup_m3_rproc_of_match, &pdev->dev);
> >> +	if (!match)
> >> +		return -ENODEV;
> >> +	fw_name =3D (char *)match->data;
> >> +
> >> +	pm_runtime_enable(&pdev->dev);
> >> +
> >> +	ret =3D pm_runtime_get_sync(&pdev->dev);
> >> +	if (IS_ERR_VALUE(ret)) {
> >> +		dev_err(&pdev->dev, "pm_runtime_get_sync() failed\n");
> >> +		return ret;
> >=20
> > this is wrong for two reasons:
> >=20
> > a) you need to pm_runtime_disable();
> > b) even if pm_runtime_get*() fails, you _must_ call
> > 	pm_runtime_put_sync();
>=20
> Ok I will fix this and the following pm_runtime issues. Didn't realize yo=
u still
> had to call put_sync after a failed get_sync.

alright.

> >> +static int wkup_m3_rpm_suspend(struct device *dev)
> >> +{
> >> +	return -EBUSY;
> >> +}
> >=20
> > looks like this is just coping with omap_device bogosity, no ?
> >
>=20
> Yes, without this omap_device shuts down ther wkup_m3 during suspend, whi=
ch of
> course prevents the wkup_m3 from finishing suspend process or waking SoC =
back
> up. Haven't found a better solution for the problem than this.

Tony, any better for this ? Do we keep this small hack or find a better
way ?

> >> +static int wkup_m3_rpm_resume(struct device *dev)
> >> +{
> >> +	return 0;
> >> +}
> >> +
> >> +static const struct dev_pm_ops wkup_m3_rproc_pm_ops =3D {
> >> +	SET_RUNTIME_PM_OPS(wkup_m3_rpm_suspend, wkup_m3_rpm_resume, NULL)
> >> +};
> >> +
> >> +static struct platform_driver wkup_m3_rproc_driver =3D {
> >> +	.probe =3D wkup_m3_rproc_probe,
> >> +	.remove =3D wkup_m3_rproc_remove,
> >> +	.driver =3D {
> >> +		.name =3D "wkup_m3",
> >> +		.of_match_table =3D wkup_m3_rproc_of_match,
> >> +		.pm =3D &wkup_m3_rproc_pm_ops,
> >> +	},
> >> +};
> >> +
> >> +module_platform_driver(wkup_m3_rproc_driver);
> >> +
> >> +MODULE_LICENSE("GPL v2");
> >> +MODULE_DESCRIPTION("wkup m3 remote processor control driver");
> >=20
> > do you want to add MODULE_AUTHOR() ?
> >=20
>=20
> Yes. Thanks for the comments.

np.

--=20
balbi

--UJEqbsikIZBgizPR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUqvIQAAoJEIaOsuA1yqREpY0P/i6Te1Wv0+u5z407YkpGUmrt
GSy3darB8fAx27yowOPGmbpUVNOrCQjL9h/LpNP0oHiBqhfa3I2C7ZQcxiTyuIwj
of5DrQO9ewKpd3wduAvYVJjiGi60t5YZObEdZeOEdxiDi3HEyksTZFytnOZpnikB
iLPo7GyQFECHtA0c/iVen4zsyUHN83Sm6Q+XHJgVEYvCJ4gyDC50p3sy4tEOn6zS
IbDsWxYlCqDA6OZJb3ASgV/HCHSuWpoCuHnlF4FHkXMVNCnAIgxtO8yezSaJSFM7
x212hacrjatus0gVWpSZ1/svQ9s1qCANJiQrZWUuIlrDz7ZRwqedvF/1ROeAQnpB
uhAAb0nJ5houn0CzAu1wylc5cBjahWRWe2aBJ3JjIdv1VqI0+Oxm2SE0PiAKa9sg
SW74vyAxUXziSF0r1oclD0dMMYCImSpzO9zPeys1jdmde7qSUUt03pxcv7dbw9z7
gNQmkcEuKLilTnLHpOaiFqu6Ry/ZzQUV58pt2D04+tUE807ZSRKlhvsa+n2hiB0I
cRfmYeoMHev7r8Re7js8qNFJHuCKPy7dP6Pjr6K8WIjpQXfI/ptBpsQFdCf2aEL0
fzec2oW7joZLfrHd6Cuv9u7kycMtZjf6qV/fBhfSpSK/UQTxVzUzhWiGTUMSgJYU
XJeBYHPzo/WlHEtF85M5
=4PwU
-----END PGP SIGNATURE-----

--UJEqbsikIZBgizPR--
