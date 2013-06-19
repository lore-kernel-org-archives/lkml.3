Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab3FSPTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:19:11 -0400
Received: from sauhun.de ([89.238.76.85]:54157 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756960Ab3FSPTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:19:07 -0400
Date: Wed, 19 Jun 2013 17:20:59 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Christian Ruppert <christian.ruppert@abilis.com>
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
Message-ID: <20130619152058.GA2951@katana>
References: <20130514110745.GA10906@intel.com>
 <1368536642-7158-1-git-send-email-christian.ruppert@abilis.com>
 <20130610152954.GE2987@katana>
 <20130612144743.GB8102@ab42.lan>
 <20130619094540.GA2950@katana>
 <20130619135855.GB16483@ab42.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <20130619135855.GB16483@ab42.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christian,

> > So, I looked around and found:
> > http://www.maximintegrated.com/app-notes/index.mvp/id/3268
> >=20
> > which after thinking further about it gives me the following
> > conclusions:
> >=20
> > - sda-hold-time is a property/requirement of a device not following
> >   the I2C spec. It is not a property of the master!
>=20
> Actually, in a protocol like I2C, every device on the bus must respect
> timing constraints like hold time etc. These parameters apply at the
> same time to the master and to all slaves.

Yes. What I meant is: the flaw of one a specific device on the bus
imposes the timing on the whole bus.

>=20
> > - It should not be encoded in the devicetree, since the flaw is implicit
> >   to the device, so only the driver needs to know about it. I wonder
> >   about something like this in the i2c slave driver:
> >=20
> > 	ret =3D i2c_request_sda_hold_time(client);
> >=20
> >   The core then can collect the requests and forward them to the host
> >   driver. This driver then can set up the hardware or return -EOPNOTSUPP
> >   and we can even warn the user that there might be problems ahead.
>=20
> This might be a solution but given that many I2C drivers are written as
> an afterthought by device manufacturers and are released under more or
> less open terms of licensing into the wild I doubt this would work very
> well in practise.

Hrmgl, the design looks much better to me, though. Once a driver is
identified to need this, the core is able to report this requirement to
a user who might even be unaware of the issue. The dt property has a bit
of "try this if things don't work, you may be lucky" taste to it. Need
to think about it. If PCB design also has an influence, then my idea
won't work, though.

> > - I wonder if we really need to have a parameter time-in-ns? The
> >   specs cleary say 300ns, so I'd think this is the value we should
> >   always use. This is from a theorhetical pov though, maybe your
> >   practical experience is different. What values do you need?
>=20
> In reality, the I2C specification is more subtle than that: The "data
> hold time" is specified as 0ns with a footnote [3] stating that devices
> "must internally provide a hold time of at least 300ns for the SDA
> signal...".
>=20
> Revision 5 contains a relatively understandable explanation about how to
> interpret this but earlier versions are less helpful. I think this
> confusion is at the root of many timing issues encountered with I2C (and
> the reason why Synopsys made this configurable). In fact, especially
> earlier specs are _all but_ clear in this point and we cannot assume
> that all peripherals were designed after Revision 5 was released in
> October 2012.

OK, agreed. Still surprised that I never encountered such a device,
probably I was just lucky.

>=20
> > > In the case of the Designware block, the parameter both changes SDA a=
nd
> > > START hold times, however, and you'll find lots of data sheets for
> > > hardware with START hold time requirements on the net, e.g.
> > > http://ww1.microchip.com/downloads/en/DeviceDoc/21805B.pdf
> >=20
> > What I couldn't find is a reference manual for a designware IP that
> > supports sda hold time? I found some spear SoC which do not have that
> > register, so that should surely be reflected in the patchset, too.
>=20
> If you have access to DesignWare documentation, check out the
> "DesignWare DW_apb_i2c Databook" Version 1.17a from March 2012.

I don't have, and I do have a hard time finding information about it
otherwise :(

> Unluckily, I clearly don't have the right to share this document with
> you. Do you know the version of the blocks in the spear SoC which do not
> support this register?

ST Spear300 and 600 have 0x3130352a in the version reg according to the
refman.

> > > The empirical solution in the function i2c_dw_scl_hcnt does not seem =
to
> > > work in all cases: Our lab guys confirmed that we have several PCB
> > > designs which do not work without adjusting the sda-hold-time paramet=
er
> > > to an appropriate value. The value seems to be different for different
> > > PCBs.
> >=20
> > I'd hope that 300ns is a safe value for all PCBs?
>=20
> Not according to our PCB guys. The highest value I have found in a quick
> check of our device trees is 650ns with others being just slightly above
> 300ns.

Thanks for sharing your results \o/ This helps me a lot. Can you find
out/guess if this value is solely dependend on a slave or is it also
dependend on PCB layout?

Thanks,

   Wolfram


--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwcxaAAoJEBQN5MwUoCm2DqIP/i/vrvj5slD/kitSZypJZFDa
VzLHi964145JwqWLGHWoNHxGVkMBjOmPDXcz4VH7CWEhsS/zz9L7Bn/2vXTdVmqd
SSqV5k6qFnV1XQUZ6V8XhT/KNDSXBPg/yQLWvaM+PP69JBF1Ow2rSOFKR3h5GXmJ
nKs1LOh45uwr1IOSD8SsxQTA7eHoZ0ZoYBfE3KkPJqwsEpRpzcJ0kDzpQ0Ea5BQK
PCa1zJdQopSDB39XLhVoiISETEeBRIGnjVwlyH2rpgm0onBPt43DNCXCmk9AAg7i
xWpXL7kSus9OWQRyEZc3rnSx+KkKV2vUPzJO/nNN9z7BiHI3ETcP6jHMHXuVh80k
EzGQOd50xtIG8GXFWJh/c2fZEGX+QNR7f1B4mWam5l95EW6k9dglh+YTBB0i4fOv
c4JHMI8BS0Dy3Jp626ZPcYUUcq6fI7DBWvCr7ZaDl3R88KZn1d9D0NSBI1F1hjub
dhWrR3TAYtyoocQOnanRNQT0wGpi0dWu373VfULkmZPXiYl3jA0SZphAX/DzEdUR
ESTHhozlR19DhUiPSbp0JAwCHwnFKK8sPvDT4VNlo2L0tnZaQrJaIh/nbJKbGPYG
qjRx/WqrjwrC94YTSvOrU0bNqxqo+TiKiHzywqQbBn28oS6UbeC1BzVtQn4kwzMm
xmbMFnS4Iwrl30gaViBB
=p/CI
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
