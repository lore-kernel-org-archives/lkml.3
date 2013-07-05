Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3GEWXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 18:23:46 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:52704 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3GEWXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:23:44 -0400
Date: Sat, 6 Jul 2013 00:23:42 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, oliver@schinagl.nl,
        linux-mtd@lists.infradead.org
Subject: Re: MTD EEPROM support and driver integration
Message-ID: <20130705222342.GP2959@lukather>
References: <20130705201118.GM2959@lukather>
 <201307052302.40588.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lRF4gxo9Z9M++D0O"
Content-Disposition: inline
In-Reply-To: <201307052302.40588.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lRF4gxo9Z9M++D0O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Fri, Jul 05, 2013 at 11:02:40PM +0200, Arnd Bergmann wrote:
> On Friday 05 July 2013, Maxime Ripard wrote:
> > Hi everyone,
> >=20
> > In the last weeks, we've drivers coming up both about mostly some very
> > simple drivers that expose to the userspace a few bytes of memory-mapped
> > IO. Both will probably live under drivers/misc/eeprom, where there's
> > support already for other kind of what could be assimilated as eeproms
> > (AT24, AT25, etc.).
> >=20
> > Now, besides the code duplication every driver has to make to register
> > the sysfs attributes, it wouldn't cause much of a problem.
> >=20
> > Except that these EEPROMs could store values useful for other drivers in
> > Linux. For example:
> >   - imx28 OCOTP (the latest of the two EEPROM drivers recently submitte=
d)
> >     use it most of the time to store its MAC addresses
> >   - Allwinner SoCs SID (the other latest driver submitted) use it
> >     sometime to store a MAC address, and also the SoC ID, which could be
> >     useful to implement a SoC bus driver.
> >   - Some Allwinner boards (and presumably others) use an AT24 to store
> >     the MAC address in it.
> >=20
> > For now, everyone comes up with a different solution:
> >   - imx28 has a hook in mach-mxs to patch the device tree at runtime and
> >     add the values retrieved from the OCOTP to it.
> >   - AT24 seem to have some function exported (at24_macc_(read|write)) so
> >     that other part of the kernel can use them to retrieve values from
> >     such an EEPROM.
> >   - Allwinner SoCs have, well, basically nothing for now, which is why I
> >     send this email.
> >=20
> > The current way of working has several flaws imho:
> >   - The code is heavily duplicated: the sysfs registering is common to
> >     every driver, and at the end of the day, every driver should only
> >     give a read/write callback, and that's it.
> >   - The "consumer" drivers should not have to worry at all about the
> >     EEPROM type it should retrieve the needed value from, let alone
> >     dealing with the number of instances of such an EEPROM.
> >=20
> > To solve this issues, I think I have some solution. Would merging this
> > drivers into MTD make some sense? It seems like there is already some
> > EEPROM drivers into drivers/mtd (such as an AT25 one, which also have a
> > drivers under drivers/misc/eeprom), so I guess it does, but I'd like to
> > have your opinion on this.
>=20
> I always felt that we should eventually move the eeprom drivers out of
> drivers/misc into their own subsystem. Moving them under drivers/mtd
> also seems reasonable.
>=20
> Having a common API sounds like a good idea, and we should probably
> spend some time comparing the options.

Great :)

> > If so, would some kind of MTD in-kernel API to retrieve values from MTD
> > devices would be acceptable to you? I mostly have DT in mind, so I'm
> > thinking of having DT bindings to that API such as
> >=20
> >   mac-storage =3D <&phandle 0xoffset 0xsize>
> >=20
> > to describe which device to get a value from, and where in that device.
> >=20
> > That would allow consumer drivers to only have to call a function like
> > of_mtd_get_value and let the MTD subsystem do the hard work.
> >=20
> > What's your feeling on this?
>=20
> My first thought is that it should be more generic than that and not
> have the mac address hardcoded as the purpose. We could possibly use
> regmap as the in-kernel interface, and come up with a more generic
> way of referring to registers in another device node.

Hmm, I maybe wasn't as clear as I wanted. Here mac-storage was just an
example. It should indeed be completely generic, and a device could have
several "storage source" defined, each driver knowing what property it
would need, pretty much like what's done currently for the regulators
for example.

We will have such a use case anyway for the Allwinner stuff, since the
fuses can be used for several thing, including storing the SoC ID,
serial numbers, and so on.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--lRF4gxo9Z9M++D0O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR10duAAoJEBx+YmzsjxAgCbYP+wepCFM3Ad6Q2kHQ3oK4o7rJ
8QujTHpUqPqnKVw4AYms7cK4igszyivohWHHL42lobf8QM/xlajIqt8O2rlnrIqS
xaksEMfjbidtfIF5gB8KN8v5h9KBL5RLCXimVvfBPPxz853Y5CbqwQ55LIFY6xQ5
NG99Knotv2T7Sv2V+nDdGugQpnHXsyrDyLEMWQvho2+o9B4p/4l+U92KNBz6nl1z
Md5PlylVWiYlupIC0RutyKMGWpJ6SrlKiEdhLaBHAZrqClA7bxzfAy2PP3ofLx9E
rjQTh6t6O5RwaPPTcYQoClSKwyaEjB7Rlz2yIz0ICapppw3aXaJh0ZAxAhN+tgze
fwUQqqYLGq4x0l5jd64rQtgR887L3eZVd2vifVVthPt9GaYMAZ4Trb+Zf2GARkzh
Wc9KE/19YPDaZ7uU3YZQ/e9+6YR/yxkVvWzDI54M6hONd8lRDpTneKgVNJ1va7HA
LmbJyFiVK8fova5mavSClDKVFssAyd+km/6acLVb9oi1iRjAdmyibrdhI0hj4zky
vRrQSNDmIlbRpCb17CTVu/0vqlRQZ1t6EQ9DG9ElEYFjHwU2Kc+HpXLQhaixlmQb
k3imL5gD5Q5J+o23CJwOhVTwjKYzoFpka4XcvL7tFwxq4TWDj2neGM/FGFDcB6IN
z27wJ9Qm3LulphHHcXkG
=szgG
-----END PGP SIGNATURE-----

--lRF4gxo9Z9M++D0O--
