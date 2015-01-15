Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbbAOLVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:21:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60997 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbbAOLVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:21:44 -0500
Date: Thu, 15 Jan 2015 11:21:39 +0000
From: Mark Brown <broonie@kernel.org>
To: James Ban <james.ban.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20150115112139.GS3043@sirena.org.uk>
References: <201501150135.t0F1Z6UD032294@krsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="6pbY/KU4ayLo+qis"
Content-Disposition: inline
In-Reply-To: <201501150135.t0F1Z6UD032294@krsrvapps-01.diasemi.com>
X-Cookie: To program is to be.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V1] regulator: da9211: fix unmatched of_node and add gpio
 control
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6pbY/KU4ayLo+qis
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 15, 2015 at 10:29:08AM +0900, James Ban wrote:
> This is a patch for fixing unmatched of_node and adding gpio control.

That sounds like two separate changes to me...

>  Optional properties:
> +- bucka-uses-gpio: BUCKA can be controlled by gpio.
> +- bucka-enable-platform-gpio: platform gpio for control of BUCKA.
> +- bucka-enable-init-state: initial state of gpio for BUCKA

Even for a single GPIO specifiers are usually called -gpios.  It also
seems redundant to have the -uses property, if there is a GPIO specifier
for the enable then we can just assume it's supposed to be used without
the extra property.

> +		bucka-uses-gpio;
> +		bucka-enable-platform-gpio = <&gpio 27 0>;
> +		bucka-enable-init-state = <0>;
> +
> +		buckb-uses-gpio;
> +		buckb-enable-platform-gpio = <&gpio 17 0>;
> +		buckb-enable-init-state = <0>;
> +
>  		regulators {
>  			BUCKA {
>  				regulator-name = "VBUCKA";

Would it not be more natural to have the properties in the node for the
regulator (the recently added of_parse_cb will help with that)?

> +	if (of_get_property(dev->of_node, "bucka-uses-gpio", NULL)) {
> +		gpio = of_get_named_gpio(dev->of_node,
> +					"bucka-enable-platform-gpio", 0);
> +		if (!gpio_is_valid(gpio)) {
> +			dev_err(dev, "invalid gpio: %d\n", gpio);
> +			return ERR_PTR(-EINVAL);
> +		}

This will be broken for deferred probe, it's better to pass through any
errors.

--6pbY/KU4ayLo+qis
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUt6LCAAoJECTWi3JdVIfQ8qEH/iZnLi+rmB5Jy0I9DCpHp/cO
BCwnqeYYt3Ro/XkA+muT70pQiz9v1iPJPMm71JDR7ysUDl5uESkRu78DObk7Spyi
SN7QfIf2vy4mgoP6EjxN8dpP6IVzgD4M6CMIkqm5L4Ntkgq/P83QlQQ21KLa/nfN
YmZRm5J7N0e2+UoVkhU7lJBD+EqrEewnxdNPpwF9qgGSpME8ahdHpShyQ0O5RdSu
CJZNRBbs9i6AHBEGBkPF/lALSro2RM5/cIoOCGCbl+yLZ2OVtNFVUlNP4DehBWh0
keB60EJJBCEaHn+GliSY9Cr74f0xHDlOqmWfByzER59pSO/ruSgek3YKUb9+Rq0=
=yUUK
-----END PGP SIGNATURE-----

--6pbY/KU4ayLo+qis--
