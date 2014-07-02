Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964775AbaGBPyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:54:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57875 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128AbaGBPyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:54:36 -0400
Date: Wed, 2 Jul 2014 10:54:02 -0500
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Rob Herring <robherring2@gmail.com>, <jackp@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Kumar Gala <galak@codeaurora.org>,
        Andy Gross <agross@codeaurora.org>
Subject: Re: [Patch v7 3/3] usb: dwc3: qcom: Add device tree binding
Message-ID: <20140702155402.GE5541@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404144233-17222-1-git-send-email-agross@codeaurora.org>
 <CAL_JsqLjjDV50x5LCDeySvV0u4U1om-3KDkFHMd5WouC=eV8kw@mail.gmail.com>
 <1404290605.3622.6.camel@iivanov-dev>
 <4545008.qD8N1qWmNz@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dFWYt1i2NyOo1oI9"
Content-Disposition: inline
In-Reply-To: <4545008.qD8N1qWmNz@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--dFWYt1i2NyOo1oI9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jul 02, 2014 at 02:48:17PM +0200, Arnd Bergmann wrote:
> On Wednesday 02 July 2014 11:43:25 Ivan T. Ivanov wrote:
> > > > <snip>
> > > >
> > > >> > +
> > > >> > +                       ranges;
> > > >> > +
> > > >> > +                       status =3D "disabled";
> > > >> > +
> > > >> > +                       dwc3@11000000 {
> > > >> > +                               compatible =3D "snps,dwc3";
> > > >>
> > > >> This sub-node is just wrong. Why can't you have a single node with=
 '
> > > >> "qcom,dwc3", "snps,dwc3" ' for the compatible property? All you are
> > > >> adding here is clocks. Does the Synopsys block have no clocks?
> > > >>
> > > >> I guess this is copied from other broken dwc3 bindings... That doe=
sn't
> > > >> mean you have to copy it.
> > > >
> > > > The dwc3 core does not deal with clocks.  That is why everyone has =
a wrapper.

everyone has a wrapper for several others reasons. PM from the point of
view of the Synopsys IP is *completely* different from PM from the point
of view the $current_soc. The wrapper helps abstract that. Currently,
there's little PM implemented in the driver, but when we get to
implementing the nice features Synopsys has given us (hibernation, for
instance) it will start to be aparent why the driver was split like
that.

> > > > That, in addition to pm, has to be handled from the wrapper.  That'=
s my take
> > > > anyway.  I am sure Felipe can speak more to this.
> > >=20
> > > That is a Linux driver issue which is irrelevant to the binding.
> >=20
> > DWC3 IP core from Synopsys is the same across SoC's (OMAP, Exynos..),
> > vendors are adding glue IP to provide necessary clocks and voltages.=20
> > I think that the DT bindings properly reflect this fact.
>=20
> Not really. The proper way to do this is to have a single node that
> lists multiple compatible strings from the most specific (per SoC variant)
> to most generic (the underlying IP core) and have all properties in it.
>=20
> We have seen many cases before where it later turned out that whatever
> feature people thought was SoC specific actually was common to all
> of them and that we later want to change the code to handle it in a
> common way, and to reflect it in the common binding. The clocks that
> Rob mentioned are one example of that.
>=20
> If you have a binding that separates one IP block into two device nodes,
> you cannot later adapt the common driver to be more generic and handle
> all sorts of SoCs. See the usb-ehci.txt for an example: it started out
> really simple but the generic driver has been extended multiple times
> to the point where it handles a lot of SoCs by default.

The fact is that you _DO_ have *TWO* IP blocks. The synopsys DWC3 is one
IP and the wrapper is another IP which adapts the synopsys IP to the
SoC's integration context.

=46rom the SoC point of view, the device only needs one (or maybe two)
clocks, an IRQ line, etc... The wrapper then, sometimes, enables that
particular memory region, enables IRQs and generates several other
clocks which are needed for proper operation of the IP.

Having this sort of "bridge" or "glue" driver also helps *HUGELY* in
different PM methodologies different SoCs use. I certainly don't want
any clock API calls in my dwc3 driver when I'm running on top of a PCI
bus on an intel platform. Likewise, I don't want any pci_enable_device()
calls in my dwc3 driver when I'm running on OMAP/Exynos/Qcom/etc.

Now, you guys just decided to give crap to the authors for no aparent
reason. If you really want to describe the HW then every single clock
node and every single voltage rail would have to be described but that
would just create a whole bunch of fixed clocks and fixed regulators
which have no way of being controlled whatsoever and just waste memory
due to several other instances of such drivers being needed.

It's pointless to continue discussing if we should have one clock node
or two clock nodes. If the wrapper doesn't need an interface clock, it
just doesn't need an interface clock and it's not up to us to start
*GUESSING* that it maybe has both clock inputs tied to the same clock
node if that's not what's written in the documentation. Sure, Qcom folks
could ask their HW designers, but what would that give us in practice ?
Nothing, not a single damn benefit.

So can we just move on from this pointless discussion now ?

cheers

--=20
balbi

--dFWYt1i2NyOo1oI9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTtCsaAAoJEIaOsuA1yqREPJoQAIkUyYixrFN+auEJqCSHP46S
YMvfLqDEKvEjTJN3kbZ1i9h2Og0HKH94KvAF765hWJAlRNn/YSmiLeNUCjhkGV58
M+rnViZ11J8ODmZf/O6Axd4zw4n5QGTVU13tKR2wKPmxQfcuA+kFcmx9qmjb6QSJ
Rd3vIZAxzp+rsDVzH0fEUvfMGBr3qNDvJpLIevDFkBsItoXBHKGlKwbyKiKuqfJS
wIlt2pgaiL6nRpHO50KTiOflI4l+8kBgzUGxRa9Ylhw0vLTNamx+D0hNC5NFZHEa
3X/nd3ulaDcPINgsNnP1aSflapKee5UUmZdXePWDVnf8Yhdk3SI9gizh15pdnciE
hgfNwqWwgyCOM/S+P/sN2oxRTtwXDbj+iAaj2cwdbmWXhwRdA+6EWQqnS6JedpSu
4Zyn6MUFrOMgvTl+f4chD8LhVrz6kifsL4IP3Dh9CPTSZ6O2EGLyAa+0JMAkASC0
GuXiICpD5I2+lmXYuQ+WYRltziVb1Mu13AoyY8CR8a7UE2mBSt6IDOIWEcZuXwxj
mqtPbtyBOTobf7qATJSLvyHmp6OCOmHqzGpG9BL6obSeCrPvMvqfQrDmgLSq5Gsi
dcuH3E8hFHBDVPJDvIVUR2yJPCUX/d5NH/wpQQOzXz7vg+AMKoGfwCtO0jNYFyxR
Fcre746D6hs7xlBfVimN
=8az4
-----END PGP SIGNATURE-----

--dFWYt1i2NyOo1oI9--
