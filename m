Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbaHYNh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:37:27 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:61308 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbaHYNhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:37:25 -0400
Date: Mon, 25 Aug 2014 15:37:16 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Jon Loeliger <jdl@jdl.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Alexander Holler <holler@ahsoftware.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver
 initialization order based on the DT)
Message-ID: <20140825133714.GH4163@ulmo.nvidia.com>
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
 <20140514141914.446F7C4153D@trevor.secretlab.ca>
 <20140821140211.GD19293@ulmo.nvidia.com>
 <53F64624.5000403@ahsoftware.de>
 <20140822131919.GX21734@leverpostej>
 <20140825093931.GB2399@ulmo>
 <E1XLu15-0002DP-6o@jdl.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yia77v5a8fyVHJSl"
Content-Disposition: inline
In-Reply-To: <E1XLu15-0002DP-6o@jdl.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Yia77v5a8fyVHJSl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 25, 2014 at 08:08:59AM -0500, Jon Loeliger wrote:
> >=20
>=20
> > Anyway, instead of going back and forth between "deferred probe is good"
> > and "deferred probe is bad", how about we do something useful now and
> > concentrate on how to make use of the information we have in DT with the
> > goal to reduce the number of cases where deferred probing is required?
>=20
> Good idea.
>=20
> The proposal on the table is to allow the probe code
> to make a topological sort of the devices based on
> dependency information either implied, explicitly stated
> or both.  That is likely a fundamentally correct approach.
>=20
> I believe some of the issues that need to be resolved are:
>=20
>     1) What constitutes a dependency?
>     2) How is that dependency expressed?
>     3) How do we add missing dependencies?
>     4) Backward compatability problems.
>=20
> There are other questions, of course.  Is it a topsort
> per bus?  Are there required "early devices"?  Should
> the inter-node dependencies be expressed at each node,
> or in a separate hierarchy within the DTS?  Others.

I think Grant already objected to the idea of explicitly adding
dependency information into the device tree sources. Rather, if I
understand correctly, we should be using the information readily
available (phandle references) as much as possible before resorting to
additional properties.

So far we've been operating under the assumption that a dependency is
modeled as a phandle reference and that the dependent would contain the
phandle reference to the dependency. That's for example how clocks and
regulators (to name only a few) work. A simplified example would look
like this:

	clock: clock@... {
		...
		#clock-cells =3D <1>;
		...
	};

	pmic: pmic@... {
		regulators {
			vdd_foo: ldo0 {
				...
			};

			vdd_bar: ldo1 {
				...
			};
	};

	device@... {
		vdd-supply =3D <&vdd_foo>;
		clocks =3D <&clock 0>;
	};

	device@... {
		vdd-supply =3D <&vdd_bar>;
		clocks =3D <&clock 1>;
	};

There are somewhat standardized bindings for the above and especially
for bindings of the type that clocks implement this is trivial. We can
simply iterate over each (phandle, specifier) tuple and check that the
corresponding clock provider can be resolved (which typically means that
it's been registered with the common clock framework).

For regulators (and regulator-like bindings) the problem is somewhat
more difficult because they property names are not standardized. One way
to solve this would be to look for property names with a -supply suffix,
but that could obviously lead to false positives. One alternative that I
think could eliminate this would be to explicitly list dependencies in
drivers. This would allow core code to step through such a list and
resolve the (phandle, specifier) tuples.

Clocks are usually not a problem with deferred probing since they often
are registered early anyway. Regulators on the other hand seem to be a
fairly common trigger, though, so they seem like a good candidate to
focus on.

Thierry

--Yia77v5a8fyVHJSl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT+zwKAAoJEN0jrNd/PrOhEHAP/2LOTwqOB67r0CMRmD+VbVPm
lNYbCbmt26pO7Ffzp7g5YpjlOLxCgr1CJJZY/mNDjuTp1L7sl7UfqCvFLf923ylE
Hid2X/vOC5r4yJZj6FoBnoVf2AbSM6q3pEhVtV71/C5H9DU2ineOOVvusAg6l2xg
dyFFm6hXzVP29aMo/drnoKD25cxN4vbBDcBUu7PF/Hac7sxda9fQGfT3LgFaP854
XyMrOCKdvvSWlH5t3TbC4fWGO8+PUHylvGtzzNeUKe+MqPWDWloZjjSqvQqOdpIY
QRYhPfJFC1iYJ6E/rnnh83t81MbOqeWBsm18lT9NybFahaKNLtwakloUBT8kliF2
0RXzJxItoSWw/5pH6luLUTmJBjfmdG+E66NCjJPDraqAFY3sV9nNCn6SA7gHEjRT
LjZeSG78i5XT7IAK0oZQ2OvALZ9hQBTx/gY5FMM5GlaTEA91ET2QD8FaBVNy+47J
6V9dZKtuSUNOeq+Sm4Ev9ErTiImb8L7UQQTEzxs0ha2VytjW/QE97aiZor0FxOuQ
7J1ybO/kufp9WHN5xoHBmmqJ02udM6YDn+eSGuz2bFik9/QZ82om++kzENIEpCeP
PZ/T/AiR+/BH5FNGx2ACimimbHX7skh4xbAFU6a25zxuV8HGfiYaY8lW22h7kqGb
RPboH/5+MSZgFBbby3Zx
=gFqf
-----END PGP SIGNATURE-----

--Yia77v5a8fyVHJSl--
