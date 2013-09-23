Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3IWIPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 04:15:04 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:32986 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab3IWIPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 04:15:00 -0400
Date: Mon, 23 Sep 2013 10:13:38 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Herring <robherring2@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-mips@linux-mips.org,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>, sparclinux@vger.kernel.org,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 04/10] irqdomain: Return errors from
 irq_create_of_mapping()
Message-ID: <20130923081337.GB11881@ulmo>
References: <1379510692-32435-1-git-send-email-treding@nvidia.com>
 <1379510692-32435-5-git-send-email-treding@nvidia.com>
 <CAL_JsqLQeAQD460f8Lk9eDE2dCzLusC1mXZ-_uaKVFLfhJNryg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline
In-Reply-To: <CAL_JsqLQeAQD460f8Lk9eDE2dCzLusC1mXZ-_uaKVFLfhJNryg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 22, 2013 at 04:14:43PM -0500, Rob Herring wrote:
> On Wed, Sep 18, 2013 at 8:24 AM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > Instead of returning 0 for all errors, allow the precise error code to
> > be propagated. This will be used in subsequent patches to allow further
> > propagation of error codes.
> >
> > The interrupt number corresponding to the new mapping is returned in an
> > output parameter so that the return value is reserved to signal success
> > (=3D=3D 0) or failure (< 0).
> >
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
>=20
> One comment below, otherwise:
>=20
> Acked-by: Rob Herring <rob.herring@calxeda.com>
>=20
> > diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci=
-common.c
> > index 905a24b..ae71b14 100644
> > --- a/arch/powerpc/kernel/pci-common.c
> > +++ b/arch/powerpc/kernel/pci-common.c
> > @@ -230,6 +230,7 @@ static int pci_read_irq_line(struct pci_dev *pci_de=
v)
> >  {
> >         struct of_irq oirq;
> >         unsigned int virq;
> > +       int ret;
> >
> >         pr_debug("PCI: Try to map irq for %s...\n", pci_name(pci_dev));
> >
> > @@ -266,8 +267,10 @@ static int pci_read_irq_line(struct pci_dev *pci_d=
ev)
> >                          oirq.size, oirq.specifier[0], oirq.specifier[1=
],
> >                          of_node_full_name(oirq.controller));
> >
> > -               virq =3D irq_create_of_mapping(oirq.controller, oirq.sp=
ecifier,
> > -                                            oirq.size);
> > +               ret =3D irq_create_of_mapping(oirq.controller, oirq.spe=
cifier,
> > +                                           oirq.size, &virq);
> > +               if (ret)
> > +                       virq =3D NO_IRQ;
> >         }
> >         if(virq =3D=3D NO_IRQ) {
> >                 pr_debug(" Failed to map !\n");
>=20
> Can you get rid of NO_IRQ usage here instead of adding to it.

I was trying to stay consistent with the remainder of the code. PowerPC
is a pretty heavy user of NO_IRQ. Of all 348 references, more than half
(182) are in arch/powerpc, so I'd rather like to get a go-ahead from
Benjamin on this.

That said, perhaps we should just go all the way and get rid of NO_IRQ
for good. Things could get somewhat messy, though. There are a couple of
these spread through the code:

	#ifndef NO_IRQ
	#define NO_IRQ (-1)
	#endif

And this isn't very encouraging either:

	$ git grep 'irq.*=3D.*-1' | wc -l
	638

Thierry

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSP/gxAAoJEN0jrNd/PrOhiNUP/jOZBHSu3iWeYBqVkPQQP52r
BDEGdRc+LKm5aBO9XwhxGDTRX3igBcFXfYlkvwmllnhJaPU8J6HCxWWffm8qwCZ2
voRIWxXH7q76QKAE/i7RZwJoASgg1KpLUS0Yv/MVchyOhMMbM2y4GG6IxBRMhA+2
j37HKuSPPnTNvWdD0vCHv064VD44fBLeIog+a4Y5Ha3FHTkd09s6No364wr+/Hko
ILMl+Erg38QqDm9Tr5qW37tMqzJ+I0ik6ye+C12iL2Zpiqo9LS8445M2URts18L6
uPw4xkwCLPA0qcMl/aqpwAlpn48TXLZEmbxZRxBgdJnF7uapdLUeLr4XphpWT4f/
JqWXZqVepBFu24h1NpPFJ2Mi6muhGyhXDYJ+y43OWtfi5dK6olgx3/Nk7b6URxo1
cTlfAemyOrho1a32N4L3rjfR79Ub2qnLcrEVRZ9a72t2qFhBjpV5D8WoO4mQaXtd
27VEKFPFWDL7VIuiUH2mp8hwk7AIWx5h9Ahkdrsxg5KREHsX+vAnkNfEu6IID2nK
nyEmBH0Nn4exzchhiNd3ONQhU5MIuqtudsAv14EchBpUP+8nWNkGAokV9JHfziW/
hBO/rq8r6DE6kzrY66mVR3b5734wHY9TidAN9suWcZkHvsFbZJdyr3NWiZxqatoh
Yb0ygk/unpG2YJa3evJI
=BnFo
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
