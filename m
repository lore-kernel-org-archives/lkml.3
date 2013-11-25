Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab3KYJuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:50:39 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:33030 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3KYJug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:50:36 -0500
Date: Mon, 25 Nov 2013 10:49:55 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <rob.herring@calxeda.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] of/platform: Fix no irq domain found errors when
 populating interrupts
Message-ID: <20131125094954.GF22043@ulmo.nvidia.com>
References: <20131123004334.GJ10023@atomide.com>
 <20131124213651.59750C402C3@trevor.secretlab.ca>
 <20131125092549.GD22043@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bqc0IY4JZZt50bUr"
Content-Disposition: inline
In-Reply-To: <20131125092549.GD22043@ulmo.nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bqc0IY4JZZt50bUr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2013 at 10:25:50AM +0100, Thierry Reding wrote:
> On Sun, Nov 24, 2013 at 09:36:51PM +0000, Grant Likely wrote:
> > On Fri, 22 Nov 2013 16:43:35 -0800, Tony Lindgren <tony@atomide.com> wr=
ote:
> > > Currently we get the following kind of errors if we try to use
> > > interrupt phandles to irqchips that have not yet initialized:
> > >=20
> > > irq: no irq domain found for /ocp/pinmux@48002030 !
> > > WARNING: CPU: 0 PID: 1 at drivers/of/platform.c:171 of_device_alloc+0=
x144/0x184()
> > > Modules linked in:
> > > CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-00038-g42a9708 #1012
> > > (show_stack+0x14/0x1c)
> > > (dump_stack+0x6c/0xa0)
> > > (warn_slowpath_common+0x64/0x84)
> > > (warn_slowpath_null+0x1c/0x24)
> > > (of_device_alloc+0x144/0x184)
> > > (of_platform_device_create_pdata+0x44/0x9c)
> > > (of_platform_bus_create+0xd0/0x170)
> > > (of_platform_bus_create+0x12c/0x170)
> > > (of_platform_populate+0x60/0x98)
> > > ...
> > >=20
> > > This is because we're wrongly trying to populate resources that are n=
ot
> > > yet available. It's perfectly valid to create irqchips dynamically,
> > > so let's fix up the issue by populating the interrupt resources based
> > > on a notifier call instead.
> > >=20
> > > Signed-off-by: Tony Lindgren <tony@atomide.com>
> > >=20
> > > ---
> > >=20
> > > Rob & Grant, care to merge this for the -rc if this looks OK to you?
> > >=20
> > > These happen for example when using interrupts-extended for omap
> > > wake-up interrupts where the irq domain is created by pinctrl-single.c
> > > at module_init time.
> > >=20
> > > --- a/drivers/of/platform.c
> > > +++ b/drivers/of/platform.c
> > > @@ -130,6 +130,56 @@ void of_device_make_bus_id(struct device *dev)
> > >  	dev_set_name(dev, "%s.%d", node->name, magic - 1);
> > >  }
> > > =20
> > > +/*
> > > + * The device interrupts are not necessarily available for all
> > > + * irqdomains initially so we need to populate them using a
> > > + * notifier.
> > > + */
> > > +static int of_device_resource_notify(struct notifier_block *nb,
> > > +				     unsigned long event, void *dev)
> > > +{
> > > +	struct platform_device *pdev =3D to_platform_device(dev);
> > > +	struct device_node *np =3D pdev->dev.of_node;
> > > +	struct resource *res =3D pdev->resource;
> > > +	struct resource *irqr =3D NULL;
> > > +	int num_irq, i, found =3D 0;
> > > +
> > > +	if (event !=3D BUS_NOTIFY_BIND_DRIVER)
> > > +		return 0;
> > > +
> > > +	if (!np)
> > > +		goto out;
> > > +
> > > +	num_irq =3D of_irq_count(np);
> > > +	if (!num_irq)
> > > +		goto out;
> > > +
> > > +	for (i =3D 0; i < pdev->num_resources; i++, res++) {
> > > +		if (res->flags !=3D IORESOURCE_IRQ ||
> > > +		    res->start !=3D -EPROBE_DEFER ||
> > > +		    res->end !=3D -EPROBE_DEFER)
> > > +			continue;
> > > +
> > > +		if (!irqr)
> > > +			irqr =3D res;
> > > +		found++;
> > > +	}
> > > +
> > > +	if (!found)
> > > +		goto out;
> > > +
> > > +	if (found !=3D num_irq) {
> > > +		dev_WARN(dev, "error populating irq resources: %i !=3D %i\n",
> > > +			 found, num_irq);
> > > +		goto out;
> > > +	}
> > > +
> > > +	WARN_ON(of_irq_to_resource_table(np, irqr, num_irq) !=3D num_irq);
> > > +
> > > +out:
> > > +	return NOTIFY_DONE;
> > > +}
> > > +
> > >  /**
> > >   * of_device_alloc - Allocate and initialize an of_device
> > >   * @np: device node to assign to device
> > > @@ -168,7 +218,13 @@ struct platform_device *of_device_alloc(struct d=
evice_node *np,
> > >  			rc =3D of_address_to_resource(np, i, res);
> > >  			WARN_ON(rc);
> > >  		}
> > > -		WARN_ON(of_irq_to_resource_table(np, res, num_irq) !=3D num_irq);
> > > +
> > > +		/* See of_device_resource_notify for populating interrupts */
> > > +		for (i =3D 0; i < num_irq; i++, res++) {
> > > +			res->flags =3D IORESOURCE_IRQ;
> > > +			res->start =3D -EPROBE_DEFER;
> > > +			res->end =3D -EPROBE_DEFER;
> > > +		}
> >=20
> > I actually like the idea of completely allocating the resource structure
> > but leaving some entries empty. However, I agree with rmk that putting
> > garbage into a resource structure is a bad idea. What about changing the
> > value of flags to 0 or some other value to be obviously an empty
> > property and give the follow up parsing some context about which ones it
> > needs to attempt to recalculate?
>=20
> When I worked on this a while back I came to the same conclusion. It's
> nice to allocate all the resources at once, because the number of them
> doesn't change, only their actually values.

I should maybe add: one issue that was raised during review of my
initial patch series was that we'll also need to cope with situations
like the following:

	1) device's interrupt parent is probed (assigned IRQ base X)
	2) device is probed (interrupt parent there, therefore gets
	   assigned IRQ (X + z)
	3) device in removed
	4) device's interrupt parent is removed
	5) device is probed (deferred because interrupt parent isn't
	   there)
	6) device's interrupt parent is probed (assigned IRQ base Y)
	7) device is probed, gets assigned IRQ (Y + z)

So not only do we have to track which resources are interrupt resources,
but we also need to have them reassigned everytime the device is probed,
therefore interrupt mappings need to be properly disposed and the values
invalidated when probing is deferred or the device removed.

Having a dynamic list of properties all of a sudden doesn't sound like
such a bad idea after all. It makes handling this kind of situation
rather trivial, especially per-type lists. Those lists will be empty at
first and populated during the first probe. When probing fails or when a
device is unloaded, we dispose the mappings and empty the lists, so that
subsequent probes will start from scratch. It certainly sounds like a
bit of a waste of CPU cycles, but on the other hand it makes the code
much simpler.

Thierry

--Bqc0IY4JZZt50bUr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSkx1CAAoJEN0jrNd/PrOhtLcQAI4DcrclXlJl30l/xwGE344t
DrjhGACqKGbS5ewLkhD6YyznjEmdlCmo0gxLQvMWZPW5P207BKw4ZCz81JG3Su/8
9x+mjyWHUcWYP/XxWrub3FF9qUrpWN9MWM5WgQlwtRW/lRX/g0WZ0cM1V2bgFCxS
ljtk0iym7BABR8bTvYsewUIF5DmPwe3MXu6IXYujQpJxPtgWoe3jFBE09EjwK/N7
uXHNnZIOB4zBHynO7KdcpVEo/vG3GEyitxPOiFLqvf4xYFUOJC4RITirXSRPJ+3R
vLqFSU/6HLKFrhisZ/yCsnq46Kyh1E4KRDQNuppUluL+ijANwfvRsZkzmrFwIsJT
/CB4byOyrbIqNbOU75liUAna7hN8aHbFlplIgb7ET3f9FHwMsmzdwHc5YNtAIyCF
kC2/D/QW5S9bLf3vwxi2rjM5nMt/1Kn+N63k/vt812y/AWSYfZstFincnGfdcxFh
G3jCx21kivbaJXawlbON3K3/dcDWViUuuIRkPtu0GZaprL1AyZkqSBlUodVySRXG
ViANs+cBVoZIXDI8qHBFKk4H/VTCeO8qf+k3AXcE+9SdToDuw3KZIo8HWhBILluy
Os57v2Nts/NZulbD+LF6czw1i7rfCoLn3xjl7aTpuVhwwX5dNUWn2kItrwzX5aYV
kT4wYSPDvKom4IeQcLi0
=Cdl/
-----END PGP SIGNATURE-----

--Bqc0IY4JZZt50bUr--
