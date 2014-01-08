Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbaAHU0X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 15:26:23 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:40354 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347AbaAHU0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 15:26:18 -0500
Date: Wed, 8 Jan 2014 21:24:08 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Paul Walmsley <paul@pwsan.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>, linux-omap@vger.kernel.org
Subject: Re: [PATCH] driver-core: platform: Resolve DT interrupt references
 late
Message-ID: <20140108202407.GA28442@ulmo.nvidia.com>
References: <20140108011957.GK5074@atomide.com>
 <201401081725.17876.arnd@arndb.de>
 <20140108195909.GB1298@ulmo.nvidia.com>
 <14122609.M29raBct1E@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <14122609.M29raBct1E@wuerfel>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 08, 2014 at 09:09:17PM +0100, Arnd Bergmann wrote:
> On Wednesday 08 January 2014 20:59:10 Thierry Reding wrote:
> > On Wed, Jan 08, 2014 at 05:25:17PM +0100, Arnd Bergmann wrote:
> > > On Wednesday 08 January 2014, Thierry Reding wrote:
> > > > On Wed, Jan 08, 2014 at 04:11:08PM +0100, Arnd Bergmann wrote:
> > > The more I think about the iommu case, the more I am convinced that it
> > > does belong into the core, in whatever form we can find. As far as I
> > > can tell from the little reliable information I have on the topic, I
> > > would assume that we can keep it in the DT probing code, as there won=
't
> > > be a need for multiple arbitrary IOMMUs with ACPI or with board files.
> >=20
> > I think part of the problem is that we don't have any DT probing code
> > yet. of_platform_probe() would have been that code. Perhaps if you weigh
> > in Grant and Greg will reconsider.
>=20
> For all I know, we don't even have a binding proposal, but I may
> have missed that.

Yeah, last time I checked there was no concensus on that. I'll try to
dig up the thread and get it going again, adding you on Cc if you don't
mind (and in case you weren't Cc'ed in the first place anyway).

> > > Good point, I forgot about the special case for i2c_client->irq.
> > > I looked now and noticed that very few i2c devices actually use this
> > > field, but larger number uses platform_data, which has a similar
> > > problem.
> >=20
> > Yeah. It's kind of messy. The more I think about it, the more I begin to
> > like the lookup table option. One big advantage of that is that we could
> > actually unify much of the lookup code, much like we do for other types
> > of resources. It's a pattern that has worked fairly well in a number of
> > cases, so it seems natural to use it for interrupts as well.
> >=20
> > An even more extreme option would be to go all the way and introduce
> > struct irq, along the same lines of the new struct gpiod. That would
> > allow nice things such as storing trigger types and such within the IRQ
> > handle and propagate them automatically.
>=20
> We already have struct irq_desc, and I believe everybody who works
> with interrupts supports migrating from irq number interfaces to
> irq descriptors as soon as we can find someone willing to do that
> work.

I didn't know that. I had always assumed irq_desc was only for internal
use by the IRQ code. Perhaps I'll look into that at some point.

> > > No trivial solution that I can see. I think we can deal with the case
> > > where platform code uses platform_device->resources, and everything e=
lse
> > > comes down to having multiple code branches in the driver, as we alre=
ady
> > > have to deal with platform_data and DT properties describing stuff th=
at
> > > doesn't fit in the resources.
> >=20
> > That would be another argument in favour of the lookup table. It would
> > provide a unified mechanism to define static interrupts if no firmware
> > interface is available *independent* of the device type. You could have
> > something like:
> >=20
> > 	static const struct irq_lookup board_irq_lookup[] =3D {
> > 		IRQ_LOOKUP("gpio", 0, "0-0040", NULL), /* I2C client via GPIO expande=
r */
> > 		IRQ_LOOKUP("intc", 0, "ehci.1", NULL), /* platform device via INTC */
> > 	};
> >=20
> > Along with:
> >=20
> > 	struct irq *irq_get(struct device *dev, const char *con_id);
> >=20
> > To look it up via DT, ACPI, lookup table. That obviously means a more or
> > less complete change in how interrupts are handled in the kernel, and it
> > may not be worth it in the end.
>=20
> It would certainly need a long migration period, and a plan for how to
> get there without breaking things in the meantime. Rather than a lookup
> table like the kind we have for clocks, I'd prefer a general way to
> attach named properties to devices. My feeling is that building upon
> devres would be a good plan, since it already provides a way to attach
> arbitrary data to a device.

The problem with devres, or any other solution for that matter, is that
for the cases where we'd need something like this (that is, statically
allocated devices in board setup code) we don't have a fully initialized
struct device. We need at least device_initialize() to have been called
before devres can be used. Therefore we still need some sort of lookup
table that can be used to seed devres objects. Also devres will go away
completely when a driver is unloaded, so it'll have to be repopulated
everytime.

I don't think that would buy us much over a simple table lookup.

Thierry

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzbPnAAoJEN0jrNd/PrOh3b4QALU4r4BhA6tJ1jr7ztooxWZR
RecJzowmKIl8G/gDBTAxHizplnTkoVQNn9atI8gchrTubTwpgb+Ws6Gxxtkm5QX6
EXWRp+Y0E7QLp3zWut8OEyMt8Sj3IiLnNTVG2O8HSvLHjoKGK50yk5TC0Amqb2Ks
ql3LP60XwLrA/sS4Cb7R5O3amclM+8LU8MXzI4UX5jIkpgXInPpcdI5KRsolffS7
AGE12qM194ko/RWWS7/kyVmbgAqHa3a16ZuzQdpVjkJ/E7cGrS3m7GNQVJm7CJoH
5Vi22CwaGLggDVAi2TLzd8gj2n6DDynAyrhjLCAIiZuGS1z9UkXnngJie2D5yaGm
h/oqWogWM4A2vFsySvCs92dXK4i36wlrQJCU/1IvYY/re7AuBvZeUZtHLFlCqw7W
21WoZG4XLfhSgA+QvLrQrrQ57WzA8OVsDhBYf8hDWIzT+lEa3fDy+RVj4B3Kdq8e
PPWgF28dktdrQgVsu45mR3npnOyFPjzCjlSy4JFAyGJRpGs150gBBxWbivUrXljL
ZID4ELgjA32Al+zCW73Byns6VyGRyJuAiaTX+FD2j3a8fTlvhZFLKR7rE6qRznNT
hS9TrN4H7jr0oTxVa3vs1ajVYjnyorp2g7W+jqvPbnPNtC3iHDuis7dCh5IDmBDO
pKJ7+P+So7XKwiWkhI3b
=cRC1
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
