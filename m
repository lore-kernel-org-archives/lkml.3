Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab3IRKow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 06:44:52 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61895 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab3IRKos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 06:44:48 -0400
Date: Wed, 18 Sep 2013 12:43:36 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: "Strashko, Grygorii" <grygorii.strashko@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 7/9] of/platform: Resolve interrupt references at probe
 time
Message-ID: <20130918104335.GA8256@ulmo>
References: <1379320326-13241-1-git-send-email-treding@nvidia.com>
 <1379320326-13241-8-git-send-email-treding@nvidia.com>
 <902E09E6452B0E43903E4F2D568737AB363BD3@DNCE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
In-Reply-To: <902E09E6452B0E43903E4F2D568737AB363BD3@DNCE04.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 17, 2013 at 01:04:06PM +0000, Strashko, Grygorii wrote:
> Hi Thierry,
>=20
> On 09/16/2013 11:32 AM, Thierry Reding wrote:> Interrupt references are c=
urrently resolved very early (when a device is
> > created). This has the disadvantage that it will fail in cases where the
> > interrupt parent hasn't been probed and no IRQ domain for it has been
> > registered yet. To work around that various drivers use explicit
> > initcall ordering to force interrupt parents to be probed before devices
> > that need them are created. That's error prone and doesn't always work.
> > If a platform device uses an interrupt line connected to a different
> > platform device (such as a GPIO controller), both will be created in the
> > same batch, and the GPIO controller won't have been probed by its driver
> > when the depending platform device is created. Interrupt resolution will
> > fail in that case.
> >=20
> > Another common workaround is for drivers to explicitly resolve interrupt
> > references at probe time. This is suboptimal, however, because it will
> > require every driver to duplicate the code.
> >=20
> > This patch adds support for late interrupt resolution to the platform
> > driver core, by resolving the references right before a device driver's
> > .probe() function will be called. This not only delays the resolution
> > until a much later time (giving interrupt parents a better chance of
> > being probed in the meantime), but it also allows the platform driver
> > core to queue the device for deferred probing if the interrupt parent
> > hasn't registered its IRQ domain yet.
> >=20
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > ---
> >   drivers/base/platform.c     |  4 ++++
> >   drivers/of/platform.c       | 43 ++++++++++++++++++++++++++++++++++++=
+------
> >   include/linux/of_platform.h |  7 +++++++
> >   3 files changed, 48 insertions(+), 6 deletions(-)
> >=20
> > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > index 4f8bef3..8dcf835 100644
> > --- a/drivers/base/platform.c
> > +++ b/drivers/base/platform.c
> > @@ -481,6 +481,10 @@ static int platform_drv_probe(struct device *_dev)
>=20
> Should it be the part of really_probe()? Isn't it?

really_probe() takes a struct device and is in fact called by all types
of devices. This code, however, is highly platform_device specific, so I
don't think we can do it in really_probe().

Unfortunately every device type has its own way of storing interrupts.
Platform devices store them as resources, I2C clients store them as a
separate field in struct i2c_client, etc.

> > +int of_platform_probe(struct platform_device *pdev)
> > +{
> > +	struct device_node *np =3D pdev->dev.of_node;
> > +	int num_irq, ret =3D 0;
> > +
> > +	if (!pdev->dev.of_node)
> > +		return 0;
> > +
> > +	num_irq =3D of_irq_count(pdev->dev.of_node);
> > +	if (num_irq > 0) {
> > +		struct resource *res =3D pdev->resource;
> > +		int num_reg =3D pdev->num_resources;
> > +		int num =3D num_reg + num_irq;
> > +
> > +		res =3D krealloc(res, num * sizeof(*res), GFP_KERNEL);
> > +		if (!res)
> > +			return -ENOMEM;
> > +
> > +		pdev->num_resources =3D num;
> > +		pdev->resource =3D res;
> > +		res +=3D num_reg;
>=20
> What will happen if Driver probe is failed or deferred?
> Seems resource table size will grow each time the Driver probe is
> deferred or failed.

That's a very good point. I think what we can do is check whether the
total number of resources that the device has (pdev->num_resources)
corresponds to num_reg + num_irq and skip in that case. That and...

> > +		ret =3D of_irq_to_resource_table(np, res, num_irq);
> > +		if (ret < 0)
> > +			return ret;

=2E.. updating pdev->num_resources after this point should cover all
cases. Do you see any other potential problems?

Thierry

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSOYPXAAoJEN0jrNd/PrOhm8sP/1+E0NleY5/Ys4U7+yA5qzXg
DO7FbP9HEW6PXSif+yezB1lVV/aQ+ot9Ftqy470yi05pe/Spg/7ZKMnWGPAQoNWO
/P7KkE//ckcPaGKr+DWNa4k8MN4BrmLP2enbLZI5XV5Xjz8CBIFe1q5e0Uz6wwGu
tEgU0pNZnpcX5yTYwa8a/Pk7MkoeDH8xn6wjUzUgQW41x0Nz3+u4NKncewT4ykBO
N8etJ98CnzsPv9bS6CZUvq4JTvvKGn7sXnWPc+EfZvWCBuQRjZJEHILAMWBDeLia
e1vv6oBUz6himHcWFMI5xh9BtshB6240wTPDQgIkcTDNnbQz3b//VYUaT/M0ArBm
8FX9UadaY/b8altwFq/JcfkM+YSDEcKXSwdeNs1oEVVUo7UeCjFBRPf8mqc42vx7
Eaqt+gNfvGjPCNuXAT24rNkcz4++YX9Wn4ZqKRM5kdE/Y9Kc3uspHrn3FkVJtecg
qGePbOpWndysAwXlzMVYHvdqFoLD9Slpwk9T/5ZlWK1knTMjU0T4HknJdXelAp60
3JUeL73iS5JvCLUklXo9iiBSe1qEdnNit+6JjvY1BX8XLaXMrloMjRDRhb8fK+cb
bNYKCYojY4UeAEjCFiTT2oDTtLoP28tgJodK01v0gzXR/MQ4hKGiasV9kTOM7cuI
YoypuRCIojTA8q8ZNJQW
=Plej
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
