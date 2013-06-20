Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965157Ab3FTIpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:45:11 -0400
Received: from mail.abilis.ch ([195.70.19.74]:18816 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964990Ab3FTIpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:45:06 -0400
Date: Thu, 20 Jun 2013 10:44:08 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH REBASE] i2c-designware: make SDA hold time configurable
Message-ID: <20130620084407.GA942@ab42.lan>
References: <20130514110745.GA10906@intel.com>
 <1368536642-7158-1-git-send-email-christian.ruppert@abilis.com>
 <20130610152954.GE2987@katana>
 <20130612144743.GB8102@ab42.lan>
 <20130619094540.GA2950@katana>
 <20130619135855.GB16483@ab42.lan>
 <20130619152058.GA2951@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <20130619152058.GA2951@katana>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Wolfram,

On Wed, Jun 19, 2013 at 05:20:59PM +0200, Wolfram Sang wrote:
> [...]
> >=20
> > > - It should not be encoded in the devicetree, since the flaw is impli=
cit
> > >   to the device, so only the driver needs to know about it. I wonder
> > >   about something like this in the i2c slave driver:
> > >=20
> > > 	ret =3D i2c_request_sda_hold_time(client);
> > >=20
> > >   The core then can collect the requests and forward them to the host
> > >   driver. This driver then can set up the hardware or return -EOPNOTS=
UPP
> > >   and we can even warn the user that there might be problems ahead.
> >=20
> > This might be a solution but given that many I2C drivers are written as
> > an afterthought by device manufacturers and are released under more or
> > less open terms of licensing into the wild I doubt this would work very
> > well in practise.
>=20
> Hrmgl, the design looks much better to me, though. Once a driver is
> identified to need this, the core is able to report this requirement to
> a user who might even be unaware of the issue. The dt property has a bit
> of "try this if things don't work, you may be lucky" taste to it. Need
> to think about it. If PCB design also has an influence, then my idea
> won't work, though.

I agree with that in theory. We would need to define more constraints in
this case, however: Both min and max setup and hold times would be
required for data and start/stop conditions. We have seen cases in which
the hold time we configured was too big for some devices on the bus
which in turn seemed to get confused between data and start/stop
conditions. I don't remember the exact values causing this issue but it
was definitely less than the max of 650ns I have grepped out yesterday.

Addressing this issue properly would mean implementing some simple form
of STA. Not sure if an operating system kernel is the right place for
this, though (and pretty sure that individual device drivers aren't).
These questions are probably better addressed at the PCB design stage.

> [...]
> >=20
> > > > In the case of the Designware block, the parameter both changes SDA=
 and
> > > > START hold times, however, and you'll find lots of data sheets for
> > > > hardware with START hold time requirements on the net, e.g.
> > > > http://ww1.microchip.com/downloads/en/DeviceDoc/21805B.pdf
> > >=20
> > > What I couldn't find is a reference manual for a designware IP that
> > > supports sda hold time? I found some spear SoC which do not have that
> > > register, so that should surely be reflected in the patchset, too.
> >=20
> > If you have access to DesignWare documentation, check out the
> > "DesignWare DW_apb_i2c Databook" Version 1.17a from March 2012.
>=20
> I don't have, and I do have a hard time finding information about it
> otherwise :(
>=20
> > Unluckily, I clearly don't have the right to share this document with
> > you. Do you know the version of the blocks in the spear SoC which do not
> > support this register?
>=20
> ST Spear300 and 600 have 0x3130352a in the version reg according to the
> refman.

Hrmmm... Going through the release notes it looks like this feature was
added with module version 1.11a, released in 2010 (the initial version
of the IP was released in 2003).

> > > > The empirical solution in the function i2c_dw_scl_hcnt does not see=
m to
> > > > work in all cases: Our lab guys confirmed that we have several PCB
> > > > designs which do not work without adjusting the sda-hold-time param=
eter
> > > > to an appropriate value. The value seems to be different for differ=
ent
> > > > PCBs.
> > >=20
> > > I'd hope that 300ns is a safe value for all PCBs?
> >=20
> > Not according to our PCB guys. The highest value I have found in a quick
> > check of our device trees is 650ns with others being just slightly above
> > 300ns.
>=20
> Thanks for sharing your results \o/ This helps me a lot. Can you find
> out/guess if this value is solely dependend on a slave or is it also
> dependend on PCB layout?

In the simplest form of STA, timings are generally considered a function
of three factors:
  . Drive strength
  . Bus load (Fan out)
  . Internal timings of all devices on the bus (setup/hold times etc.)

This applies to ASIC internal timing. My PCB experience is quite limited
and I'm not sure if this can be applied as such. That said, the I2C
specification does define all three of these factors and I deduce they
all have their importance. We know that the specified internal device
timings are sometimes buggy, I don't know about the other two.

Greetings,
  Christian

--=20
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pr=E9-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlHCwNcACgkQbI8SbDT4m4/6bgCdGWcLS9Pzf3hfm+s5ef09jhTY
yD0An00M4RV1KPy4Jav4XRBryR3b1rQR
=oQiA
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
