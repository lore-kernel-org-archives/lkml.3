Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355Ab3K1PrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 10:47:12 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43669 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759337Ab3K1PrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 10:47:10 -0500
Date: Thu, 28 Nov 2013 16:46:23 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <rob.herring@calxeda.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] of/platform: Fix no irq domain found errors when
 populating interrupts
Message-ID: <20131128154622.GB23201@ulmo.nvidia.com>
References: <20131123004334.GJ10023@atomide.com>
 <20131124213651.59750C402C3@trevor.secretlab.ca>
 <20131125092549.GD22043@ulmo.nvidia.com>
 <20131125094954.GF22043@ulmo.nvidia.com>
 <20131127155629.DB612C404EC@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZfOjI3PrQbgiZnxM"
Content-Disposition: inline
In-Reply-To: <20131127155629.DB612C404EC@trevor.secretlab.ca>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZfOjI3PrQbgiZnxM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2013 at 03:56:29PM +0000, Grant Likely wrote:
> On Mon, 25 Nov 2013 10:49:55 +0100, Thierry Reding <thierry.reding@gmail.=
com> wrote:
> > On Mon, Nov 25, 2013 at 10:25:50AM +0100, Thierry Reding wrote:
> > > On Sun, Nov 24, 2013 at 09:36:51PM +0000, Grant Likely wrote:
> > > > On Fri, 22 Nov 2013 16:43:35 -0800, Tony Lindgren <tony@atomide.com=
> wrote:
> > > > > Currently we get the following kind of errors if we try to use
> > > > > interrupt phandles to irqchips that have not yet initialized:
> > > > >=20
> > > > > irq: no irq domain found for /ocp/pinmux@48002030 !
> > > > > WARNING: CPU: 0 PID: 1 at drivers/of/platform.c:171 of_device_all=
oc+0x144/0x184()
> > > > > Modules linked in:
> > > > > CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-00038-g42a9708 #=
1012
> > > > > (show_stack+0x14/0x1c)
> > > > > (dump_stack+0x6c/0xa0)
> > > > > (warn_slowpath_common+0x64/0x84)
> > > > > (warn_slowpath_null+0x1c/0x24)
> > > > > (of_device_alloc+0x144/0x184)
> > > > > (of_platform_device_create_pdata+0x44/0x9c)
> > > > > (of_platform_bus_create+0xd0/0x170)
> > > > > (of_platform_bus_create+0x12c/0x170)
> > > > > (of_platform_populate+0x60/0x98)
> > > > > ...
> > > > >=20
> > > > > This is because we're wrongly trying to populate resources that a=
re not
> > > > > yet available. It's perfectly valid to create irqchips dynamicall=
y,
> > > > > so let's fix up the issue by populating the interrupt resources b=
ased
> > > > > on a notifier call instead.
> > > > >=20
> > > > > Signed-off-by: Tony Lindgren <tony@atomide.com>
> > > > >=20
> > > > > ---
> > > > >=20
> > > > > Rob & Grant, care to merge this for the -rc if this looks OK to y=
ou?
> > > > >=20
> > > > > These happen for example when using interrupts-extended for omap
> > > > > wake-up interrupts where the irq domain is created by pinctrl-sin=
gle.c
> > > > > at module_init time.
> > > > >=20
> > > > > --- a/drivers/of/platform.c
> > > > > +++ b/drivers/of/platform.c
> > > > > @@ -130,6 +130,56 @@ void of_device_make_bus_id(struct device *de=
v)
> > > > >  	dev_set_name(dev, "%s.%d", node->name, magic - 1);
> > > > >  }
> > > > > =20
> > > > > +/*
> > > > > + * The device interrupts are not necessarily available for all
> > > > > + * irqdomains initially so we need to populate them using a
> > > > > + * notifier.
> > > > > + */
> > > > > +static int of_device_resource_notify(struct notifier_block *nb,
> > > > > +				     unsigned long event, void *dev)
> > > > > +{
> > > > > +	struct platform_device *pdev =3D to_platform_device(dev);
> > > > > +	struct device_node *np =3D pdev->dev.of_node;
> > > > > +	struct resource *res =3D pdev->resource;
> > > > > +	struct resource *irqr =3D NULL;
> > > > > +	int num_irq, i, found =3D 0;
> > > > > +
> > > > > +	if (event !=3D BUS_NOTIFY_BIND_DRIVER)
> > > > > +		return 0;
> > > > > +
> > > > > +	if (!np)
> > > > > +		goto out;
> > > > > +
> > > > > +	num_irq =3D of_irq_count(np);
> > > > > +	if (!num_irq)
> > > > > +		goto out;
> > > > > +
> > > > > +	for (i =3D 0; i < pdev->num_resources; i++, res++) {
> > > > > +		if (res->flags !=3D IORESOURCE_IRQ ||
> > > > > +		    res->start !=3D -EPROBE_DEFER ||
> > > > > +		    res->end !=3D -EPROBE_DEFER)
> > > > > +			continue;
> > > > > +
> > > > > +		if (!irqr)
> > > > > +			irqr =3D res;
> > > > > +		found++;
> > > > > +	}
> > > > > +
> > > > > +	if (!found)
> > > > > +		goto out;
> > > > > +
> > > > > +	if (found !=3D num_irq) {
> > > > > +		dev_WARN(dev, "error populating irq resources: %i !=3D %i\n",
> > > > > +			 found, num_irq);
> > > > > +		goto out;
> > > > > +	}
> > > > > +
> > > > > +	WARN_ON(of_irq_to_resource_table(np, irqr, num_irq) !=3D num_ir=
q);
> > > > > +
> > > > > +out:
> > > > > +	return NOTIFY_DONE;
> > > > > +}
> > > > > +
> > > > >  /**
> > > > >   * of_device_alloc - Allocate and initialize an of_device
> > > > >   * @np: device node to assign to device
> > > > > @@ -168,7 +218,13 @@ struct platform_device *of_device_alloc(stru=
ct device_node *np,
> > > > >  			rc =3D of_address_to_resource(np, i, res);
> > > > >  			WARN_ON(rc);
> > > > >  		}
> > > > > -		WARN_ON(of_irq_to_resource_table(np, res, num_irq) !=3D num_ir=
q);
> > > > > +
> > > > > +		/* See of_device_resource_notify for populating interrupts */
> > > > > +		for (i =3D 0; i < num_irq; i++, res++) {
> > > > > +			res->flags =3D IORESOURCE_IRQ;
> > > > > +			res->start =3D -EPROBE_DEFER;
> > > > > +			res->end =3D -EPROBE_DEFER;
> > > > > +		}
> > > >=20
> > > > I actually like the idea of completely allocating the resource stru=
cture
> > > > but leaving some entries empty. However, I agree with rmk that putt=
ing
> > > > garbage into a resource structure is a bad idea. What about changin=
g the
> > > > value of flags to 0 or some other value to be obviously an empty
> > > > property and give the follow up parsing some context about which on=
es it
> > > > needs to attempt to recalculate?
> > >=20
> > > When I worked on this a while back I came to the same conclusion. It's
> > > nice to allocate all the resources at once, because the number of them
> > > doesn't change, only their actually values.
> >=20
> > I should maybe add: one issue that was raised during review of my
> > initial patch series was that we'll also need to cope with situations
> > like the following:
> >=20
> > 	1) device's interrupt parent is probed (assigned IRQ base X)
> > 	2) device is probed (interrupt parent there, therefore gets
> > 	   assigned IRQ (X + z)
> > 	3) device in removed
> > 	4) device's interrupt parent is removed
> > 	5) device is probed (deferred because interrupt parent isn't
> > 	   there)
> > 	6) device's interrupt parent is probed (assigned IRQ base Y)
> > 	7) device is probed, gets assigned IRQ (Y + z)
> >=20
> > So not only do we have to track which resources are interrupt resources,
> > but we also need to have them reassigned everytime the device is probed,
> > therefore interrupt mappings need to be properly disposed and the values
> > invalidated when probing is deferred or the device removed.
>=20
> Yes, that is a problem, but the only way to handle that is to always
> recalcuate all resource references at probe time. I don't feel good
> about handling that in the core. I'd rather move drivers away from
> referencing the resources table directly and instead use an API. Then
> the resources table could be missing entirely.

Are you suggesting something like this?

---

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 3a94b799f166..c894d1af3a5e 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -13,6 +13,7 @@
 #include <linux/string.h>
 #include <linux/platform_device.h>
 #include <linux/of_device.h>
+#include <linux/of_irq.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/dma-mapping.h>
@@ -87,7 +88,12 @@ int platform_get_irq(struct platform_device *dev, unsign=
ed int num)
                return -ENXIO;
        return dev->archdata.irqs[num];
 #else
-       struct resource *r =3D platform_get_resource(dev, IORESOURCE_IRQ, n=
um);
+       struct resource *r;
+
+       if (IS_ENABLED(CONFIG_OF) && dev->dev.of_node)
+               return irq_of_parse_and_map(dev->dev.of_node, num);
+
+       r =3D platform_get_resource(dev, IORESOURCE_IRQ, num);
=20
        return r ? r->start : -ENXIO;
 #endif

--ZfOjI3PrQbgiZnxM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSl2VNAAoJEN0jrNd/PrOhtsMP/1hLunW4zVrf++L/G3lBVd6B
LDkQVcg2pkewEWM4TOJ7RNtRz0zfAITsJLH471K4vczL+R/c0zTSq3XLrpD56QbQ
u0LJocrQ2H33n1hes5qNzKlglxykIyPffyhifBEe54dygR/Bun8IcsbN+4PRomIy
t1GWGh728xeSeD2236AJhbbGIQh4e+nvl9AfZZbrGnE44D/R1Z79KzAbVq6S+gCE
GLVB9wNW3018Xazi4E4CfuPXMWW9SSdmYkYK1Y849Vv4pYVjlaG+oJf9uPl9tuQK
oJr7iZurt8cgdXOtdOmvEA4xZMQUHpsPpTX+lGnsAWBT8xhYe+DkXGTuspWygtBX
HhBZGlcu8aFFrV/+pHtAyifQHKMoP/OsGmuhlG7QbzY1l8GWCBLM6OMk7/Etju1J
BpXa1dyUpO33KAwWPahPDSlHG56x5bOZ+9hQzupWHQheLSh3tiNm8dNx/9TacwQF
yIFtdMksOILNCH0S7L9JDEVvaCdVHYbC/u+E9WghmIirIvm/Ej0l1slucanp62tI
tnpa/5EOTCtxuRPHKx7hNWDqDfskgWBTYxtcBtOZDK0hBExJAn+iiXEhj91YQkVJ
0LtcYLOUGFmpXNEQFhvVsO4kAKu2ukZXbyheuP//sCqkAM0D4oDOGFcS20BlXJYR
2Vvs2IagIKMQ6uYXlqIe
=Rjb3
-----END PGP SIGNATURE-----

--ZfOjI3PrQbgiZnxM--
