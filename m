Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab3FRJkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:40:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54064 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab3FRJkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:40:39 -0400
Date: Tue, 18 Jun 2013 12:38:29 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <grant.likely@linaro.org>, <tony@atomide.com>, <balbi@ti.com>,
        <arnd@arndb.de>, <swarren@nvidia.com>, <sylvester.nawrocki@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <b-cousson@ti.com>,
        <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>,
        <mchehab@redhat.com>, <cesarb@cesarb.net>, <davem@davemloft.net>,
        <rnayak@ti.com>, <shawn.guo@linaro.org>, <santosh.shilimkar@ti.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <nsekhar@ti.com>
Subject: Re: [PATCH v7 1/9] drivers: phy: add generic PHY framework
Message-ID: <20130618093829.GP5461@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371113039-5784-1-git-send-email-kishon@ti.com>
 <1371113039-5784-2-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wqJr86X7F8PBspU2"
Content-Disposition: inline
In-Reply-To: <1371113039-5784-2-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--wqJr86X7F8PBspU2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Jun 13, 2013 at 02:13:51PM +0530, Kishon Vijay Abraham I wrote:
> +struct phy_provider *of_phy_provider_register(struct device *dev,
> +	struct module *owner, struct phy * (*of_xlate)(struct device *dev,
> +	struct of_phandle_args *args))

I would rename this to __of_phy_provider_register() and in a header
have:

#define of_phy_provider_register(dev, xlate)	\
	__of_phy_provider_register((dev), THIS_MODULE, (xlate))

then your users don't need to remember always passing THIS_MODULE
argument.

> +struct phy_provider *devm_of_phy_provider_register(struct device *dev,
> +	struct module *owner, struct phy * (*of_xlate)(struct device *dev,
> +	struct of_phandle_args *args))

likewise.

> +/**
> + * phy_release() - release the phy
> + * @dev: the dev member within phy
> + *
> + * When the last reference to the device is removed, it is called
> + * from the embedded kobject as release method.
> + */
> +static void phy_release(struct device *dev)
> +{
> +	struct phy *phy;
> +
> +	phy =3D container_of(dev, struct phy, dev);

I would have a:

#define to_phy(dev)	(container_of((dev), struct phy dev))

somewhere in a header, just for the sake of brevity :-p

> +	dev_dbg(dev, "releasing '%s'\n", dev_name(dev));

make it dev_vdbg() instead.

> diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
> new file mode 100644
> index 0000000..df0c98a
> --- /dev/null
> +++ b/include/linux/phy/phy.h

[ ... ]

> +static inline int phy_init(struct phy *phy)
> +{
> +	int ret =3D -ENOTSUPP;
> +
> +	if (!pm_runtime_enabled(&phy->dev))
> +		goto no_pm_runtime;
> +
> +	ret =3D pm_runtime_get_sync(&phy->dev);
> +	if (ret < 0) {
> +		dev_err(&phy->dev, "get sync failed: %d\n", ret);
> +		return ret;
> +	}
> +
> +no_pm_runtime:

you can avoid this goto if you code as below, note that I'm also solving
a possible unbalanced PM runtime call which would prevent actual
*runtime* suspend of the PHY:

	ret =3D phy_pm_runtime_get_sync(phy);
	if (ret < 0 && ret !=3D -ENOTSUPP)
		return ret;

	if (phy->ops->init) {
		ret =3D phy->ops->init(phy);
		if (ret < 0) {
			dev_err(&phy->dev, "failed to initialize --> %d\n", ret);
			goto out;
		}
	}

out:
	/*
	 * In order to avoid unbalanced PM runtime calls, let's make
	 * sure to disable what we might have enabled when entering this
	 * function.
	 */
	 phy_pm_runtime_put(phy);

	return ret;


> +}
> +
> +static inline int phy_exit(struct phy *phy)
> +{
> +	int ret =3D -ENOTSUPP;
> +
> +	if (phy->ops->exit)
> +		ret =3D phy->ops->exit(phy);
> +
> +	if (!pm_runtime_enabled(&phy->dev))
> +		goto no_pm_runtime;
> +
> +	ret =3D pm_runtime_put_sync(&phy->dev);

move your pm runtime wrappers before these calls and you can use them.

--=20
balbi

--wqJr86X7F8PBspU2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwCqUAAoJEIaOsuA1yqREG/8QAJGtquAmX8ey2RsLbbJWO4ar
/muCouC9v4znOIMY5LyjOx4ZAdonZUiPYU2CZvzk6Jkvy4aO6kAPPSS+S6NDMue5
tZJLR4VEL2iohLhvyKTkC7XP/aadVujAAwRPdO4DFlJfRRrma7kP6vCeG3BpqzzP
ut12fhG2obF47P+M1+yc3Nm+PA8FrG1rfCzo4QaM6JdJKjNkEZrtuxdsWldEl4Wz
Fv11PS7G9AFRyHUa0LOFWT/Xwp11VoBChJ1nLvRUVjxsrWGAiM6MkaqVrUN8zvzs
acI7ck/AwP7Nz+e72mfOAXJ0cDdizm+NRX2ArSyKHFvXQzp5hDkQOKMw+JhpNoYJ
qtC/ieeHeJzrry0g5LyIBC8BL3Q1zp/5/o6Xy7JuJigCngc24Hck/Ea/Zinlpomb
lZezcc5WETNPbJfCJM88nYrKq5UK1Xy13F4DTOLG1Pn6a0o+V5PSGBgi4vaneSd5
XLwqszL1YwchFcohVAKB1rl+jBmyYgahfqVqF/5h22bwBXkrXhoD3jQGvLPmjO2b
CKdPz/HQ85kXkSC//CcS9sIjvuesTbYdeLr3re9rhrRf1Emu0hQMJTrynQnt8wBR
UOvaacmDPnS7yLsjT/DHDu4gWTJrAWZ53/o4X6rywoJvi4CMhD4sn7KfPu8EKxuj
ia3gBBh2GC+w3GwpD+km
=QBWP
-----END PGP SIGNATURE-----

--wqJr86X7F8PBspU2--
