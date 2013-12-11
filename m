Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab3LKPNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 10:13:17 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:47019 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab3LKPNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 10:13:15 -0500
Date: Wed, 11 Dec 2013 16:12:00 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <rob.herring@calxeda.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] of/platform: Fix no irq domain found errors when
 populating interrupts
Message-ID: <20131211151159.GA31617@ulmo.nvidia.com>
References: <20131123004334.GJ10023@atomide.com>
 <20131124213651.59750C402C3@trevor.secretlab.ca>
 <20131125092549.GD22043@ulmo.nvidia.com>
 <20131125094954.GF22043@ulmo.nvidia.com>
 <20131127155629.DB612C404EC@trevor.secretlab.ca>
 <20131128154622.GB23201@ulmo.nvidia.com>
 <20131211134553.2E967C4061A@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <20131211134553.2E967C4061A@trevor.secretlab.ca>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 11, 2013 at 01:45:53PM +0000, Grant Likely wrote:
> On Thu, 28 Nov 2013 16:46:23 +0100, Thierry Reding <thierry.reding@gmail.=
com> wrote:
> > On Wed, Nov 27, 2013 at 03:56:29PM +0000, Grant Likely wrote:
> > > On Mon, 25 Nov 2013 10:49:55 +0100, Thierry Reding <thierry.reding@gm=
ail.com> wrote:
> > > >=20
> > > > I should maybe add: one issue that was raised during review of my
> > > > initial patch series was that we'll also need to cope with situatio=
ns
> > > > like the following:
> > > >=20
> > > > 	1) device's interrupt parent is probed (assigned IRQ base X)
> > > > 	2) device is probed (interrupt parent there, therefore gets
> > > > 	   assigned IRQ (X + z)
> > > > 	3) device in removed
> > > > 	4) device's interrupt parent is removed
> > > > 	5) device is probed (deferred because interrupt parent isn't
> > > > 	   there)
> > > > 	6) device's interrupt parent is probed (assigned IRQ base Y)
> > > > 	7) device is probed, gets assigned IRQ (Y + z)
> > > >=20
> > > > So not only do we have to track which resources are interrupt resou=
rces,
> > > > but we also need to have them reassigned everytime the device is pr=
obed,
> > > > therefore interrupt mappings need to be properly disposed and the v=
alues
> > > > invalidated when probing is deferred or the device removed.
> > >=20
> > > Yes, that is a problem, but the only way to handle that is to always
> > > recalcuate all resource references at probe time. I don't feel good
> > > about handling that in the core. I'd rather move drivers away from
> > > referencing the resources table directly and instead use an API. Then
> > > the resources table could be missing entirely.
> >=20
> > Are you suggesting something like this?
> >=20
> > ---
> >=20
> > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > index 3a94b799f166..c894d1af3a5e 100644
> > --- a/drivers/base/platform.c
> > +++ b/drivers/base/platform.c
> > @@ -13,6 +13,7 @@
> >  #include <linux/string.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/of_device.h>
> > +#include <linux/of_irq.h>
> >  #include <linux/module.h>
> >  #include <linux/init.h>
> >  #include <linux/dma-mapping.h>
> > @@ -87,7 +88,12 @@ int platform_get_irq(struct platform_device *dev, un=
signed int num)
> >                 return -ENXIO;
> >         return dev->archdata.irqs[num];
> >  #else
> > -       struct resource *r =3D platform_get_resource(dev, IORESOURCE_IR=
Q, num);
> > +       struct resource *r;
> > +
> > +       if (IS_ENABLED(CONFIG_OF) && dev->dev.of_node)
> > +               return irq_of_parse_and_map(dev->dev.of_node, num);
> > +
> > +       r =3D platform_get_resource(dev, IORESOURCE_IRQ, num);
>=20
> Yes. Or even more generically we could have a device_get_irq() function:
>=20
> int device_get_irq(struct device *dev, unsigned int num)
> {
> 	if (IS_ENABLED(CONFIG_OF) && dev->of_node)
> 		return irq_of_parse_and_map(dev->of_node, num);
> 	/* An ACPI hook could go here */
> 	return 0
> }
>=20
> It would be callable by any device driver, and platform_get_irq() could
> call it too.

So how about we make the platform_get_irq() modification for starters,
so that the OMAP issues can be resolved and then turn our attention to
coming up with a more generic approach. If indeed we end up with what
you're proposing we can easily switch platform_get_irq() to use it.

One of the things I'm not so sure about is how to handle other types of
resources, since they'll be somewhat more specific to the type of
device. That's true also for devices other than platform devices. Let's
look at I2C devices for instance. The way to get at the IRQ number is
via the i2c_client->irq member.

device_get_irq() breaks down at that point because unless you want to
add special cases for all sorts of devices you have no way of getting at
the data if it hasn't been instantiated from DT (or ACPI). Actually, all
devices instantiated from platform data will suffer from this if I'm not
mistaken.

If you're saying that the device_get_irq() API should only cover cases
where some sort of firmware interface exists such as DT or ACPI, then I
suppose it could be made to work and drivers could rely on the subsystem
specific locations as fallback. I guess for I2C drivers you'd have to do
something like this:

	err =3D device_get_irq(&client->dev, 0);
	if (err >=3D 0)
		client->irq =3D err;

And then continue to use client->irq as usual. That obviously has the
side-effect of having to do this for every single driver, whereas the
original patches were meant to solve this in the core.

Given enough time we could probably migrate everyone to the new
interfaces, but it certainly is a lot of churn. Perhaps another
alternative would be to unify this some more by making each subsystem
provide special hooks that device_get_irq() and friends can call for
fallback when none of the "firmware" functions were successful.

Thierry

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSqIC/AAoJEN0jrNd/PrOhwIkP/j18c4vcmJanow3zGDfXGe+x
v2O1jbHeG+P5bqklFtpkaW3LzDa3DIeDQITGK0F5SVTgneIHP8J9SDcc27IrLBX3
2+xWJmvYDbMFo6PBv5604iI6svYIfU0mjaWtLqxzANpJPl+7DrfrKlWvma1ke2/b
0ZyV23ZtjdUyTHW2kCqz0k39KXMf70vmBDYKNJ4+nVu0O2rnjpWWjBCfsXBJXpgs
FIBSWPNHpxu/dG1oNlkMw2WHYz/j9E3zv0hsOlyGqTuxU9i9nvAuFWueLUyQNre0
ANMnxqFbgZtO8XQc+RGetJs+PM/9tj6FMmEOlOga8rUd5z6lFZFSkmWcoOLnQmZL
5vm50c1v8PeZJbS9aRSFT0GdMS/EQyGH5MNAB6ktmMCqz57HJnuKqK3tnqXioziu
iRwIyeMrU8tW5/DS6iJurA2Z7N5UMfb9Yu5tEYmMquvFu1DByMYAqNQq4wUiLVgQ
jkr7VfhrzMLmTEH/gdlqm84HIAKpiRwsEyy9w4NH8HDoLx0MCWBKTi/fgoem4cZ7
N9nhHnx9I9PliWGIkNqGA1ILDoMHuGHNXNRpEfeCd1KnOS7Tj0h6CKRShaEqD8QA
WR0AWzzXMOA9X89agGpphxmC+XZBWr9r9CeuEMUOnm7U4ph0cCXQ3Q9ULklA4HWW
4mKi5kvSXWa8mouKMOP1
=DkNz
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
