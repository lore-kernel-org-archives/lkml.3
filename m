Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbbAUPWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:22:38 -0500
Received: from mail.kernel.org ([198.145.29.136]:45169 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbbAUPW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:22:27 -0500
Date: Wed, 21 Jan 2015 16:22:17 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Pavel Machek <pavel@ucw.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCHv2 00/19] power_supply: Allow safe usage of power
 supply
Message-ID: <20150121152216.GD13715@earth.universe>
References: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8nsIa27JVQLqB7/C"
Content-Disposition: inline
In-Reply-To: <1420472882-10463-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8nsIa27JVQLqB7/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Krzysztof,

On Mon, Jan 05, 2015 at 04:47:43PM +0100, Krzysztof Kozlowski wrote:
> This is RFC, please don't apply yet but let me know if this approach
> is OK.

I just reviewed the patchset. It looks fine to me.

> TLDR
> =3D=3D=3D=3D
> Patchset tries to fix following race scenario:
>=20
> Thread 1: charger manager, CONSUMER
> Thread 2: power supply driver, PROVIDER
>=20
> THREAD 1 (charger manager)         THREAD 2 (power supply driver)
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D         =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> psy =3D power_supply_get_by_name()
>                                    Driver unbind, .remove
>                                      power_supply_unregister()
>                                      Device fully removed
> psy->get_property()
>=20
> To properly fix the race the patchset:
> 1. Adds power_supply_get_property()-like API for safe access by consumer.
> 2. Moves ownership of power_supply structure from driver (provider) to
>    power supply core.
> 3. Adds power_supply_put() which will reclaim memory.

Looks fine to me, thanks for doing this :)

> Description
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=20
> This is a little different than my previous approaches [1][2] for fixing
> usage of power supply by some consumer, if driver implementing it is
> unbound.
>=20
> The patchset is quite big and touches power supply API so a lot of
> changes in drivers are needed. These changes *are not finished yet*.
> I've done them only for:
>  - bq24190_charger.c
>  - charger-manager.c
>  - max14577_charger.c
>  - max17040_battery.c
>  - max17042_battery.c
>  - sbs-battery.c
>  - tps65090-charger.c
> So allyesconfig won't build.
>
> If this approach is OK, I'll prepare full patchset changing all the
> drivers.

Please do :)

> My previous approach [1][2] limited the race but did not close it.
> Still the consumer of power supply by calling power_supply_get_propert(ps=
y...)
> may reference invalid memory because the producer freed it.
>=20
> Actually, because struct power_supply is exposed to consumers, the
> core should be the owner of it. This is accomplished in patch 11/19
> ("power_supply: Change ownership from driver to core").
>=20
> What the patchset does in steps
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> 1. Some preparation steps are necessary - patch 1 and 2. The driver
>    implementing power supply won't be able to fill structure before
>    calling power_supply_register(). So 'power_supply_config'
>    is introduced in patch 2 ("power_supply: Move run-time configuration
>    to separate structure"). Unfortunately this touches all drivers.

$ grep -l power_supply_register **/*.c | grep -v mod.c | grep -v drivers/po=
wer
drivers/acpi/ac.c
drivers/acpi/battery.c
drivers/acpi/sbs.c
drivers/hid/hid-input.c
drivers/hid/hid-sony.c
drivers/hid/hid-wiimote-modules.c
drivers/hid/wacom_sys.c
drivers/platform/x86/compal-laptop.c
drivers/staging/nvec/nvec_power.c

Please make sure to CC the respective maintainers for the patchset
(e.g. current patch 14 and 15 should have CC'd x86 maintainers), so
that they can Acknowledge the patchset.

> 2. Safe API wrappers (and usage counter) are added (power_supply_*()).
> 3. Patch 11: ownership of 'struct power_supply' is moved from driver
>    to the core.
> 4. power_supply_put() is added which reclaims resources.

Looks fine to me.

> The patchset is rebased on next-20141226. It should be pulled at once.
> Bisectability is preserved.

Fine with me, but I need acks from all involved maintainers. So for the
patchset:

Reviewed-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--8nsIa27JVQLqB7/C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUv8QlAAoJENju1/PIO/qa7/cQAKL4AwZTQPD1sNk+v+xDrjK4
giJzRnjte1Bsa7AdXWLpXG71JlnE0LQ60RYl7avSUPNku46mMc4DdngQ1w8vcIiE
2/JhPhgv82nqt9nwQdgUC0lcpS7tJMbjoJg8JlwL2Z1pZJ8HEKDoTwVGH3YLNdS/
iRv3m9eEEwwzle47tY9gFIZ5QWkHk7q4oNnqS2AVzSi5WrVDZny0voV9ZyQSBtg8
Vs93aSeQFV05gmZ+f2ngmiACbGYI/zqKhLFKf5QnaHvoW4me77Wl4Esbont0v1CL
MBqhQyigb4g+c/ITiHkpeDk48w1roKcFy72c57Cr6BDV+WtMKpcQQgBaFdLOMYtI
VgjMkkfEgYI6rSUuwp8XBXyWctw5oPz5qQai1wrUCGhQI2cCMM7N1KJyUVX2IkgM
7UhAYqG3B2ZoGso9n9UPKmNX4CICY7PsstYfnK2NPDgX+fnT4xZR5K7TZcYQQ0++
EYgndueCOgkauTxGFn5zUG3y3eENeTW9KA74a92AXqb/LY4pQ4VaD2KtbxT8Q8sl
J7j1Y9t+DvDSGX4Jd/T5OT6oqic6/XiIjKdjDa/l3RZ5yDCZR1+71Id5hkRmnmgZ
FCau1Ribghyn01e+VqondCc1dFGKFdRwGkwGfC2THDCiETL/ZaEJISbF0kBHHuTa
1dYIesxaekwazsjW5OSQ
=VBKQ
-----END PGP SIGNATURE-----

--8nsIa27JVQLqB7/C--
