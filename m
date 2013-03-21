Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab3CUDCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 23:02:50 -0400
Received: from ozlabs.org ([203.10.76.45]:43148 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439Ab3CUDCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 23:02:49 -0400
Date: Thu, 21 Mar 2013 12:55:41 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio powerpc: implement IOMMU driver for VFIO
Message-ID: <20130321015541.GA13838@truffula.fritz.box>
References: <1363660844.24132.452.camel@bling.home>
 <1363676892-3891-1-git-send-email-aik@ozlabs.ru>
 <1363812324.24132.544.camel@bling.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <1363812324.24132.544.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 20, 2013 at 02:45:24PM -0600, Alex Williamson wrote:
> On Tue, 2013-03-19 at 18:08 +1100, Alexey Kardashevskiy wrote:
> > VFIO implements platform independent stuff such as
> > a PCI driver, BAR access (via read/write on a file descriptor
> > or direct mapping when possible) and IRQ signaling.
> >=20
> > The platform dependent part includes IOMMU initialization
> > and handling. This patch implements an IOMMU driver for VFIO
> > which does mapping/unmapping pages for the guest IO and
> > provides information about DMA window (required by a POWERPC
> > guest).
> >=20
> > The counterpart in QEMU is required to support this functionality.
> >=20
> > Changelog:
> > * documentation updated
> > * containter enable/disable ioctls added
> > * request_module(spapr_iommu) added
> > * various locks fixed
> >=20
> > Cc: David Gibson <david@gibson.dropbear.id.au>
> > Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> > ---
>=20
>=20
> Looking pretty good.  There's one problem with the detach_group,
> otherwise just some trivial comments below.  What's the status of the
> tce code that this depends on?  Thanks,

[snip]
> > +static void tce_iommu_detach_group(void *iommu_data,
> > +		struct iommu_group *iommu_group)
> > +{
> > +	struct tce_container *container =3D iommu_data;
> > +	struct iommu_table *tbl =3D iommu_group_get_iommudata(iommu_group);
> > +
> > +	BUG_ON(!tbl);
> > +	mutex_lock(&container->lock);
> > +	if (tbl !=3D container->tbl) {
> > +		pr_warn("tce_vfio: detaching group #%u, expected group is #%u\n",
> > +				iommu_group_id(iommu_group),
> > +				iommu_group_id(tbl->it_group));
> > +	} else if (container->enabled) {
> > +		pr_err("tce_vfio: detaching group #%u from enabled container\n",
> > +				iommu_group_id(tbl->it_group));
>=20
> Hmm, something more than a pr_err needs to happen here.  Wouldn't this
> imply a disable and going back to an unprivileged container?

Uh, no.  I think the idea here is that we use the enable/disable
semantic to address some other potential problems.  Specifically,
sidestepping the problems of what happens if you change the
container's capabilities by adding/removing groups while in the middle
of using it.  So the point is that the detach fails when the group is
enabled, rather than implicitly doing anything.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFKaJ0ACgkQaILKxv3ab8YmmwCfXfINKPgCaKliZRfsxchQapWE
YEQAn0D6T2TmfroeXKVRx02ahP8wvECV
=oZ6t
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
