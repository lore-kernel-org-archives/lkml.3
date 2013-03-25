Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab3CYCUU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 22:20:20 -0400
Received: from ozlabs.org ([203.10.76.45]:40413 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155Ab3CYCUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 22:20:19 -0400
Date: Mon, 25 Mar 2013 13:12:57 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio powerpc: implement IOMMU driver for VFIO
Message-ID: <20130325021257.GA5598@truffula.fritz.box>
References: <1363660844.24132.452.camel@bling.home>
 <1363676892-3891-1-git-send-email-aik@ozlabs.ru>
 <1363812324.24132.544.camel@bling.home>
 <20130321015541.GA13838@truffula.fritz.box>
 <1363835784.24132.574.camel@bling.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <1363835784.24132.574.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 20, 2013 at 09:16:24PM -0600, Alex Williamson wrote:
> On Thu, 2013-03-21 at 12:55 +1100, David Gibson wrote:
> > On Wed, Mar 20, 2013 at 02:45:24PM -0600, Alex Williamson wrote:
> > > On Tue, 2013-03-19 at 18:08 +1100, Alexey Kardashevskiy wrote:
> > > > VFIO implements platform independent stuff such as
> > > > a PCI driver, BAR access (via read/write on a file descriptor
> > > > or direct mapping when possible) and IRQ signaling.
> > > >=20
> > > > The platform dependent part includes IOMMU initialization
> > > > and handling. This patch implements an IOMMU driver for VFIO
> > > > which does mapping/unmapping pages for the guest IO and
> > > > provides information about DMA window (required by a POWERPC
> > > > guest).
> > > >=20
> > > > The counterpart in QEMU is required to support this functionality.
> > > >=20
> > > > Changelog:
> > > > * documentation updated
> > > > * containter enable/disable ioctls added
> > > > * request_module(spapr_iommu) added
> > > > * various locks fixed
> > > >=20
> > > > Cc: David Gibson <david@gibson.dropbear.id.au>
> > > > Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> > > > ---
> > >=20
> > >=20
> > > Looking pretty good.  There's one problem with the detach_group,
> > > otherwise just some trivial comments below.  What's the status of the
> > > tce code that this depends on?  Thanks,
> >=20
> > [snip]
> > > > +static void tce_iommu_detach_group(void *iommu_data,
> > > > +		struct iommu_group *iommu_group)
> > > > +{
> > > > +	struct tce_container *container =3D iommu_data;
> > > > +	struct iommu_table *tbl =3D iommu_group_get_iommudata(iommu_group=
);
> > > > +
> > > > +	BUG_ON(!tbl);
> > > > +	mutex_lock(&container->lock);
> > > > +	if (tbl !=3D container->tbl) {
> > > > +		pr_warn("tce_vfio: detaching group #%u, expected group is #%u\n",
> > > > +				iommu_group_id(iommu_group),
> > > > +				iommu_group_id(tbl->it_group));
> > > > +	} else if (container->enabled) {
> > > > +		pr_err("tce_vfio: detaching group #%u from enabled container\n",
> > > > +				iommu_group_id(tbl->it_group));
> > >=20
> > > Hmm, something more than a pr_err needs to happen here.  Wouldn't this
> > > imply a disable and going back to an unprivileged container?
> >=20
> > Uh, no.  I think the idea here is that we use the enable/disable
> > semantic to address some other potential problems.  Specifically,
> > sidestepping the problems of what happens if you change the
> > container's capabilities by adding/removing groups while in the middle
> > of using it.  So the point is that the detach fails when the group is
> > enabled, rather than implicitly doing anything.
>=20
> The function returns void.

Uh, yeah, we should probably fix that.

>  We're not failing the detach, just getting
> into a broken state.  This is only called to unwind attaching groups
> when the iommu is set or if the user explicitly calls
> GROUP_UNSET_CONTAINER.  The former won't have had a chance to call
> enable but the latter would need to be fixed.

Well, in the latter case it's essentialy a silent failure, which isn't
great.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFPsqkACgkQaILKxv3ab8YijACfavY8rYi2QD9/UmV9lBeRhicP
yTQAnj6Pf1aWXfInQwShQB3bGM3D7d3Z
=0h8r
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
