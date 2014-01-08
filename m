Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbaAHUBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:01:25 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:40975 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbaAHUBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:01:21 -0500
Date: Wed, 8 Jan 2014 20:59:10 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Paul Walmsley <paul@pwsan.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>, linux-omap@vger.kernel.org
Subject: Re: [PATCH] driver-core: platform: Resolve DT interrupt references
 late
Message-ID: <20140108195909.GB1298@ulmo.nvidia.com>
References: <20140108011957.GK5074@atomide.com>
 <6734073.GzLvMSsKrR@wuerfel>
 <20140108155855.GA22984@ulmo.nvidia.com>
 <201401081725.17876.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Content-Disposition: inline
In-Reply-To: <201401081725.17876.arnd@arndb.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 08, 2014 at 05:25:17PM +0100, Arnd Bergmann wrote:
> On Wednesday 08 January 2014, Thierry Reding wrote:
> > On Wed, Jan 08, 2014 at 04:11:08PM +0100, Arnd Bergmann wrote:
> > > On Wednesday 08 January 2014 15:55:27 Thierry Reding wrote:
> > > > It stands to reason that if they push back on the IOMMU variant of =
what
> > > > is essentially the same thing, they will push back on the IRQ varia=
nt as
> > > > well. One alternative I proposed was to, just as you suggested earl=
ier,
> > > > move the code into platform_drv_probe() or rather a function called=
 from
> > > > it. That proposal never got any replies, though.
> > > >=20
> > > > 	https://lkml.org/lkml/2013/12/14/39
> > >=20
> > > I guess putting it into the platform_drv_probe function seems reasona=
ble,
> > > I would be more scared of the implications of a notifier based method.
> >=20
> > I fully agree. Of course if we decide against moving things into the
> > core and in favour of a more generic API that drivers should use, then
> > this issue goes away silently at least for resources that the driver
> > needs to use explicitly (memory-mapped regions, interrupts, ...).
> >=20
> > The issue remains for IOMMU which is meant to be used transparently
> > through the DMA API. Perhaps a good compromise would be to have some
> > sort of generic helper that can be called to initialize IOMMU support
> > for a particular device and support probe deferral on error. Something
> > like this perhaps:
> >=20
> > 	int iommu_attach(struct device *dev);
> > 	int iommu_detach(struct device *dev);
> >=20
> > I still don't like very much how that needs to be done in each driver
> > explicitly, but if we can't do it in the core, then the only other clean
> > way to handle it would be to treat it like any other sort of resource
> > and handle it explicitly. Perhaps handing out some sort of cookie would
> > be preferable to just an error code?
>=20
> The more I think about the iommu case, the more I am convinced that it
> does belong into the core, in whatever form we can find. As far as I
> can tell from the little reliable information I have on the topic, I
> would assume that we can keep it in the DT probing code, as there won't
> be a need for multiple arbitrary IOMMUs with ACPI or with board files.

I think part of the problem is that we don't have any DT probing code
yet. of_platform_probe() would have been that code. Perhaps if you weigh
in Grant and Greg will reconsider.

> > > > One downside of that approach is that, while it maps well to platfo=
rm
> > > > devices or generic devices that have some sort of firmware interface
> > > > such as OF or ACPI, I don't see how it can be made to work with an =
I2C
> > > > client that's registered from board setup code for example. Well, I
> > > > suppose that problem could be solved by throwing another lookup tab=
le at
> > > > it, just like we do for clocks, regulators, PWMs and GPIOs.
> > >=20
> > > Wouldn't you still be able to attach resources in the traditional
> > > way for those, but use the same new interface to get at them?
> >=20
> > I wouldn't know how. For instance platform devices store the IRQ number
> > within a struct resource of type IORESOURCE_IRQ, whereas I2C clients
> > store them in the struct i2c_client's .irq field.
>=20
> Good point, I forgot about the special case for i2c_client->irq.
> I looked now and noticed that very few i2c devices actually use this
> field, but larger number uses platform_data, which has a similar
> problem.

Yeah. It's kind of messy. The more I think about it, the more I begin to
like the lookup table option. One big advantage of that is that we could
actually unify much of the lookup code, much like we do for other types
of resources. It's a pattern that has worked fairly well in a number of
cases, so it seems natural to use it for interrupts as well.

An even more extreme option would be to go all the way and introduce
struct irq, along the same lines of the new struct gpiod. That would
allow nice things such as storing trigger types and such within the IRQ
handle and propagate them automatically.

> > So without actually introspecting the struct device (possibly using the
> > .bus field for example) and upcasting you won't know how to get at the
> > resources. One possibility to remedy that would be to try and unify the
> > resources within struct device. But that doesn't feel right.
> >=20
> > One other thing I had considered at one point was to extend the bus_type
> > structure and give it a way to obtain resources in a bus-specific way,
> > but that feel even more wrong.
> >=20
> > Perhaps I'm missing something obvious, though, and this is actually much
> > more trivial to solve.
>=20
> No trivial solution that I can see. I think we can deal with the case
> where platform code uses platform_device->resources, and everything else
> comes down to having multiple code branches in the driver, as we already
> have to deal with platform_data and DT properties describing stuff that
> doesn't fit in the resources.

That would be another argument in favour of the lookup table. It would
provide a unified mechanism to define static interrupts if no firmware
interface is available *independent* of the device type. You could have
something like:

	static const struct irq_lookup board_irq_lookup[] =3D {
		IRQ_LOOKUP("gpio", 0, "0-0040", NULL), /* I2C client via GPIO expander */
		IRQ_LOOKUP("intc", 0, "ehci.1", NULL), /* platform device via INTC */
	};

Along with:

	struct irq *irq_get(struct device *dev, const char *con_id);

To look it up via DT, ACPI, lookup table. That obviously means a more or
less complete change in how interrupts are handled in the kernel, and it
may not be worth it in the end.

Thierry

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIbBAEBAgAGBQJSza4NAAoJEN0jrNd/PrOhiogP91jOGNAXVWpeEwhFGfbtviTp
cEhpaKusXDrq01QaC/2qJj38njB4JxWy/DKA23jmLB/8ai2iIJfPbrIDqfxYnPzV
dnBJ5RtnydZ8vHQb26pHZ9TCQdGBoP5M6GS0kgXEtEo58DehGIuApibVjSc/Hjea
MWb1mW0OEkq6de6nS1EPm+AwPbHucfiGcX7pOl2hNGreiS21HyhbsU9MATsKNcVd
qPp/f6a3kkJZzng4XPW21mou0Ti/pTDzmUkj6jwTgvXqlVmsXE9jWkFilkhrw4ko
/L7BVkJSHunAy20UrgwtWJ3HNl282Ym0HgpYT3y0v2f08WCQOIPYRI8krSHUWxoE
VulhPcKbf9a0AiAGFDhQb4Exxf1teqF/eYXjKDNZeu+ldLVhR7Xh0xXYxiA39dNi
HS+82wAMcNbbmy3kv90lLEXaIjB/kRq2uUnCZxFTaURwKASkVodEpY9LWzcUWW0+
6rb6Y5Lzh8lB3CuoWmk+leJfLbt8lf1IirBBzMNT7xRXK6ruIUFYyZzwRRhczqGd
fGH0k9MmYylT1rY3qgx9h73rlTovjf7miPVce8e1/7/Fn3uT8VSwI9UAYVQL0Y99
V7mnbnrw1468fN+jUpD/mvEtRQRNbmDhOvQ0UmlUdX2ba2W466ybhh8o1U/PPltB
tVGd+K7WLkDcATYoZJw=
=e9o3
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--
