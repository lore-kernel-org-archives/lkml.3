Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab3KYJ0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:26:37 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:53236 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab3KYJ0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:26:31 -0500
Date: Mon, 25 Nov 2013 10:25:50 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <rob.herring@calxeda.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] of/platform: Fix no irq domain found errors when
 populating interrupts
Message-ID: <20131125092549.GD22043@ulmo.nvidia.com>
References: <20131123004334.GJ10023@atomide.com>
 <20131124213651.59750C402C3@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PHCdUe6m4AxPMzOu"
Content-Disposition: inline
In-Reply-To: <20131124213651.59750C402C3@trevor.secretlab.ca>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PHCdUe6m4AxPMzOu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 24, 2013 at 09:36:51PM +0000, Grant Likely wrote:
> On Fri, 22 Nov 2013 16:43:35 -0800, Tony Lindgren <tony@atomide.com> wrot=
e:
> > Currently we get the following kind of errors if we try to use
> > interrupt phandles to irqchips that have not yet initialized:
> >=20
> > irq: no irq domain found for /ocp/pinmux@48002030 !
> > WARNING: CPU: 0 PID: 1 at drivers/of/platform.c:171 of_device_alloc+0x1=
44/0x184()
> > Modules linked in:
> > CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-00038-g42a9708 #1012
> > (show_stack+0x14/0x1c)
> > (dump_stack+0x6c/0xa0)
> > (warn_slowpath_common+0x64/0x84)
> > (warn_slowpath_null+0x1c/0x24)
> > (of_device_alloc+0x144/0x184)
> > (of_platform_device_create_pdata+0x44/0x9c)
> > (of_platform_bus_create+0xd0/0x170)
> > (of_platform_bus_create+0x12c/0x170)
> > (of_platform_populate+0x60/0x98)
> > ...
> >=20
> > This is because we're wrongly trying to populate resources that are not
> > yet available. It's perfectly valid to create irqchips dynamically,
> > so let's fix up the issue by populating the interrupt resources based
> > on a notifier call instead.
> >=20
> > Signed-off-by: Tony Lindgren <tony@atomide.com>
> >=20
> > ---
> >=20
> > Rob & Grant, care to merge this for the -rc if this looks OK to you?
> >=20
> > These happen for example when using interrupts-extended for omap
> > wake-up interrupts where the irq domain is created by pinctrl-single.c
> > at module_init time.
> >=20
> > --- a/drivers/of/platform.c
> > +++ b/drivers/of/platform.c
> > @@ -130,6 +130,56 @@ void of_device_make_bus_id(struct device *dev)
> >  	dev_set_name(dev, "%s.%d", node->name, magic - 1);
> >  }
> > =20
> > +/*
> > + * The device interrupts are not necessarily available for all
> > + * irqdomains initially so we need to populate them using a
> > + * notifier.
> > + */
> > +static int of_device_resource_notify(struct notifier_block *nb,
> > +				     unsigned long event, void *dev)
> > +{
> > +	struct platform_device *pdev =3D to_platform_device(dev);
> > +	struct device_node *np =3D pdev->dev.of_node;
> > +	struct resource *res =3D pdev->resource;
> > +	struct resource *irqr =3D NULL;
> > +	int num_irq, i, found =3D 0;
> > +
> > +	if (event !=3D BUS_NOTIFY_BIND_DRIVER)
> > +		return 0;
> > +
> > +	if (!np)
> > +		goto out;
> > +
> > +	num_irq =3D of_irq_count(np);
> > +	if (!num_irq)
> > +		goto out;
> > +
> > +	for (i =3D 0; i < pdev->num_resources; i++, res++) {
> > +		if (res->flags !=3D IORESOURCE_IRQ ||
> > +		    res->start !=3D -EPROBE_DEFER ||
> > +		    res->end !=3D -EPROBE_DEFER)
> > +			continue;
> > +
> > +		if (!irqr)
> > +			irqr =3D res;
> > +		found++;
> > +	}
> > +
> > +	if (!found)
> > +		goto out;
> > +
> > +	if (found !=3D num_irq) {
> > +		dev_WARN(dev, "error populating irq resources: %i !=3D %i\n",
> > +			 found, num_irq);
> > +		goto out;
> > +	}
> > +
> > +	WARN_ON(of_irq_to_resource_table(np, irqr, num_irq) !=3D num_irq);
> > +
> > +out:
> > +	return NOTIFY_DONE;
> > +}
> > +
> >  /**
> >   * of_device_alloc - Allocate and initialize an of_device
> >   * @np: device node to assign to device
> > @@ -168,7 +218,13 @@ struct platform_device *of_device_alloc(struct dev=
ice_node *np,
> >  			rc =3D of_address_to_resource(np, i, res);
> >  			WARN_ON(rc);
> >  		}
> > -		WARN_ON(of_irq_to_resource_table(np, res, num_irq) !=3D num_irq);
> > +
> > +		/* See of_device_resource_notify for populating interrupts */
> > +		for (i =3D 0; i < num_irq; i++, res++) {
> > +			res->flags =3D IORESOURCE_IRQ;
> > +			res->start =3D -EPROBE_DEFER;
> > +			res->end =3D -EPROBE_DEFER;
> > +		}
>=20
> I actually like the idea of completely allocating the resource structure
> but leaving some entries empty. However, I agree with rmk that putting
> garbage into a resource structure is a bad idea. What about changing the
> value of flags to 0 or some other value to be obviously an empty
> property and give the follow up parsing some context about which ones it
> needs to attempt to recalculate?

When I worked on this a while back I came to the same conclusion. It's
nice to allocate all the resources at once, because the number of them
doesn't change, only their actually values.

However it seems to me like there's no way with the way platform_device
is currently defined to pass along enough context to allow it to obtain
the correct set of resources that need to be populated.

We can't really set flags to 0 because then we loose all information
about the type of resource, which is the only thing that could remotely
be used to track interrupt-type resources and recalculate only those. I
was looking at perhaps modifying the platform_device struct to use a
different means of storing the resources that would make this easier.
One possibility would be to add per-type arrays or lists of resources.
That way we could simply remove the complete list of interrupts and redo
them each time probing is deferred.

However it looks like a whole lot of code currently relies on knowing
the internals of struct platform_device, so that will likely turn into a
nightmare patchset. coccinelle could possibly be very helpful here,
though.

Perhaps a backwards-compatible way would be to add some fields that keep
track of where in the single array of struct resource:s the interrupts
start and then overwrite the values, while at the same time not having
to reallocate memory all the time. It's slightly hackish and I fear if
we don't clean up after that we'll run the risk of cluttering up the
structure eventually.

I'm wondering if long term (well, really long-term) it might be better
to move away from platform_device completely, given how various people
have said that they don't like them and rather have them not exist at
all. I haven't quite seen anyone explicitly stating why or what an
alternative would look like, but perhaps someone can educate me.

> However, I still don't like the notifier approach of actually triggering
> the fixup. We need something better.

I don't either. Notifiers are really not suitable for this in my
opinion. We've had this discussion before in the context of Hiroshi's
IOMMU patches, and they don't allow errors to be propagated easily. They
also are a very decentralized way to do things and therefore better
suited to do things that are really driver-specific. For something that
every device requires (such as interrupt reference resolution), a change
to the core seems like a more desirable approach to me.

Thierry

--PHCdUe6m4AxPMzOu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSkxedAAoJEN0jrNd/PrOh+a8P/2J3+MWOKAJC7lYjEgaM9ppI
lodi8VwR7NRNeyeIpRhnG2UHkwJwhypwPg1l6ck8Q7qwAMjQ+QPWDvpEfKtPmDVG
xhre7NA0tk8Fxq0lW4VxBrL/2XrcrrKk0xjoWHxGO9oHM7qa0W2iJQH1tMn8zbxU
FM4P+c25SpuWjf6N85YwP4joQXlAG7joPUoWqNOJXV9xyuSWvGWi77Z+9tFCXHhX
SVvEx7QRfawhfceMD0XHx2BmOv8pK+I9Dgm1AlEwOTCqRIXvMm97bAzRVfKpz1RA
/4o2sltwlAq0MQLyRLAqmqmf3TpkIgWRVjEYtFLpRrtFKVrQ6ZyAPuZE90LPkLAc
muA5Jj1bAR2WPZd2ThOVPZtTXKp9UP5bSt91jeWFt9N03g/UNl8O1LLZu8t7PLBE
6ORDXvI2W25ME8LABWuHcJVPdmCWaIVnrDVEkPVsH+4mfgZNDlPPw/lr8OJAKsUW
QcauOtaKZfBWk0t+KqmOFxYm8692qgRGgDYeiZpwCZMBqmcFrBr7LhkETDuvlITm
LirDpZ4OBLSMhiGd4lw7ghPyy8WE9RjjB81T1Q3zLSZgq8I25ubOKAlQZjn6LWyr
vYZD0Nqv7W3HurPj5yDa5+ZOevhI1SvPTaALalivDRVQmOpxSs2rDPU+R300Xx82
h3o3Oy/fxHt9JbJV8VNP
=9B6+
-----END PGP SIGNATURE-----

--PHCdUe6m4AxPMzOu--
