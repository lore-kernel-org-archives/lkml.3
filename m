Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964830Ab3GERre (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 13:47:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43992 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3GERrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 13:47:32 -0400
Date: Fri, 5 Jul 2013 18:47:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Taras Kondratiuk <taras@ti.com>
Message-ID: <20130705174727.GF27646@sirena.org.uk>
References: <1371849949-12649-1-git-send-email-nm@ti.com>
 <1371849949-12649-2-git-send-email-nm@ti.com>
 <20130704154105.GD27646@sirena.org.uk>
 <20130705135507.GA17439@kahuna>
 <20130705140828.GA27646@sirena.org.uk>
 <51D6DD3A.1030002@ti.com>
 <20130705165235.GC27646@sirena.org.uk>
 <51D70356.30707@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xouLQHoKk2OCQ4/P"
Content-Disposition: inline
In-Reply-To: <51D70356.30707@ti.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH V2 1/8] regulator: Introduce OMAP regulator to
 control PMIC over VC/VP
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xouLQHoKk2OCQ4/P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 05, 2013 at 12:33:10PM -0500, Nishanth Menon wrote:

> Taking an example of twl-regulator and omap_pmic, are you suggesting
> omap_pmic to be a user twl-regulator using
> include/linux/regulator/consumer.h? or are you suggesting that
> omap_pmic should not be a regulator at all?

No, I'm suggesting that omap_pmic find the TWL driver data at runtime
(eg, using the device tree to locate the relevant regulator) and get the
information out of the regulator driver that way.  It can then tell the
hardware about the data that way without having to explictly add every
single regulator both standalone and to the OMAP driver.

> >There's no information about how to use this register in your
> >bindings...  but anyway, can't be too hard to add this if it's actually
> >used.

> Yes it is, and also happens to be how OMAPs achieve maximum power
> savings - when low power modes are achieved in OMAP(automatic
> hardware assisted commands are send to the specific command
> registers in PMIC and viceversa on wakeup) - but this also happens
> to be very specific to OMAP way of handling things. I can refer to
> the Reference Manual as to how it actually works, but that'd be an
> overkill, I will try to expand on the bindings a little more, I
> guess.

OK, so this is a register defined by the OMAP architecture?  I think
it's reasonable to add something to allow this to be obtained to the
core, using a DT property seems yucky since every board usingt this is
going to have to cut'n'paste the value.  Some sort of custom parameter
readback thing perhaps, it doesn't have to be too generic.

> >Anything that implements a custom set_voltage() won't work with your
> >data structure either...

> It would not work with OMAP either ;). But that said, drivers do

Yes, that's kind of my point - as with the code Paul was implementing it
doesn't matter if you can't support every single regualtor since the
hardware design constrains what the regulator can do.  The regualtor
framework already has helpers which factor out the code for anything
which has the limiations the OMAP hardware has (or where it doesn't we
could add them) so there shouldn't be any need for a driver to provide
custom callbacks.

> freely implement custom set_voltage/get_voltage primarily because
> there are ranges in supported voltages that are non-linear and try
> to be generic to work on non-OMAP platforms as well. However, within
> the supported range, only the linear ranges are used with OMAP.

OK, that's a bit more interesting but I expect such regulators will
actually work with the linear ranges helpers I added the other day
(Marvell had a PMIC using them and I realised that the same pattern can
be applied to a bunch of other devices).  Do you think that'd cover the
cases you're aware of?

Another option is for the drivers to provide the data and use the
helpers for their linear ranges as part of a more complex
implementation.

> >>OMAP VC hardware has no idea about how long to wait before giving up
> >>on an ongoing i2c transaction. This may depend on PMIC and what it
> >>does before acking on i2c.

> >So pick a high number (it's only for error cases...)?

> from hardware perspective yeah, if it does not lockup (based on
> erratas on specific devices ;) ). it also controls in part, the
> latency of response to Voltage processor from Voltage controller
> also needed for computing SmartReflex latencies (as it should
> consider worst case conditions)

OK, that's a bit more fun but I think the kernel wants that information
in general anyway since a software cpufreq driver or something might
want to make the same latency decisions.  This is what set_voltage_time()=
=20
is for in part.  But to a first approximation is there really much
variation in the numbers?

--xouLQHoKk2OCQ4/P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR1warAAoJELSic+t+oim9qCMP/3HZVlp8VlMPm0ettL2ZhQlz
LsNW41U6Osp1aZ01DAyv84F7PgV7U7MunKUhxxTkgYq79yxOPoDYq+EdaM62SOCL
aR/AYZRZVxEqNWrGO8Z6FIWLYqcbuJpxJdL6ESc4G9fAGxM6sy1rhFXESyHjf6Dh
plLk4HQF++pMNG6nlEIa4G+m/DwT+1jWesTWvkPvn8N+LihIaLil/XXwOXRbWWCg
IF5XtKChEs/Kq9yWvX9lqEwnF2vngs0BnjQjsLmub5JbTOsS7wOJLu9ZmhGFcYqU
QxTSE6mwP5eIrQ3aalL3+UVuPHoiZZs8oG2W75xclv71ufK3fjBikFpn2CPpQ3rP
mwDz0P1yYIyiQEjlR+1/SM+Xc+rLUi/CEFLUiCDzxwsJjxl1EXIH1RFr5zV0nBN+
No5VyVKGdvfKW1n57UpsGN0Q9HMw49MwyFstrbK6vuDqRjPUKXTC8UNrn4AMKrpA
Rylr2ZRH7JdYeISOGV57C6OrE4yeq81zu34AUnX/ii3n3uimt6YJt/xO6roE8eMI
+bhLeyRu6PjEe9zaxsvWTg2Z5p85P01DdgJqMQmZIHVRKMLL3JnLbdrlKozSl/tR
36T+2puIbkg5TXPySaiPu+kgx0zLzgBxxh+dSbo+73qK+oKzez7AcGhTuh/VR0by
GCeYVHptparqvu1gaO0l
=+Lxh
-----END PGP SIGNATURE-----

--xouLQHoKk2OCQ4/P--
