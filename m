Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546Ab3BSHi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 02:38:58 -0500
Received: from ozlabs.org ([203.10.76.45]:55831 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757021Ab3BSHi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 02:38:57 -0500
Date: Tue, 19 Feb 2013 18:38:53 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Joerg Roedel <joerg.roedel@amd.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu: making IOMMU sysfs nodes API public
Message-ID: <20130219073853.GS21067@truffula.fritz.box>
References: <1360628713.3248.8.camel@bling.home>
 <1360642004-7419-1-git-send-email-aik@ozlabs.ru>
 <1360645643.3248.91.camel@bling.home>
 <511A54DC.9030908@ozlabs.ru>
 <1360689304.3248.154.camel@bling.home>
 <5121C709.80007@ozlabs.ru>
 <1361251440.2801.142.camel@bling.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p11K2BJEgMZL61bg"
Content-Disposition: inline
In-Reply-To: <1361251440.2801.142.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p11K2BJEgMZL61bg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 18, 2013 at 10:24:00PM -0700, Alex Williamson wrote:
> On Mon, 2013-02-18 at 17:15 +1100, Alexey Kardashevskiy wrote:
> > On 13/02/13 04:15, Alex Williamson wrote:
> > > On Wed, 2013-02-13 at 01:42 +1100, Alexey Kardashevskiy wrote:
> > >> On 12/02/13 16:07, Alex Williamson wrote:
> > >>> On Tue, 2013-02-12 at 15:06 +1100, Alexey Kardashevskiy wrote:
> > >>>> Having this patch in a tree, adding new nodes in sysfs
> > >>>> for IOMMU groups is going to be easier.
> > >>>>
> > >>>> The first candidate for this change is a "dma-window-size"
> > >>>> property which tells a size of a DMA window of the specific
> > >>>> IOMMU group which can be used later for locked pages accounting.
> > >>>
> > >>> I'm still churning on this one; I'm nervous this would basically cr=
eat
> > >>> a /proc free-for-all under /sys/kernel/iommu_group/$GROUP/ where any
> > >>> iommu driver can add random attributes.  That can get ugly for
> > >>> userspace.
> > >>
> > >> Is not it exactly what sysfs is for (unlike /proc)? :)
> > >
> > > Um, I hope it's a little more thought out than /proc.
> > >
> > >>> On the other hand, for the application of userspace knowing how much
> > >>> memory to lock for vfio use of a group, it's an appealing location =
to
> > >>> get that information.  Something like libvirt would already be poki=
ng
> > >>> around here to figure out which devices to bind.  Page limits need =
to be
> > >>> setup prior to use through vfio, so sysfs is more convenient than
> > >>> through vfio ioctls.
> > >>
> > >> True. DMA window properties do not change since boot so sysfs is the=
 right
> > >> place to expose them.
> > >>
> > >>> But then is dma-window-size just a vfio requirement leaking over in=
to
> > >>> iommu groups?  Can we allow iommu driver based attributes without g=
iving
> > >>> up control of the namespace?  Thanks,
> > >>
> > >> Who are you asking these questions? :)
> > >
> > > Anyone, including you.  Rather than dropping misc files in sysfs to
> > > describe things about the group, I think the better solution in your
> > > case might be a link from the group to an existing sysfs directory
> > > describing the PE.  I believe your PE is rooted in a PCI bridge, so t=
hat
> > > presumably already has a representation in sysfs.  Can the aperture s=
ize
> > > be determined from something in sysfs for that bridge already?  I'm j=
ust
> > > not ready to create a grab bag of sysfs entries for a group yet.
> > > Thanks,
> >=20
> >=20
> > At the moment there is no information neither in sysfs nor=20
> > /proc/device-tree about the dma-window. And adding a sysfs entry per PE=
=20
> > (powerpc partitionable end-point which is often a PHB but not always) j=
ust=20
> > for VFIO is quite heavy.
>=20
> How do you learn the window size and PE extents in the host kernel?
>=20
> > We could add a ppc64 subfolder under /sys/kernel/iommu/xxx/ and put the=
=20
> > "dma-window" property there. And replace it with a symlink when and if =
we=20
> > add something for PE later. Would work?

Fwiw, I'd suggest a subfolder named for the type of IOMMU, rather than
"ppc64".

> To be clear, you're suggesting /sys/kernel/iommu_groups/$GROUP/xxx/,
> right?  A subfolder really only limits the scope of the mess, so it's
> not much improvement.  What does the interface look like to make those
> subfolders?
>=20
> The problem we're trying to solve is this call flow:
>=20
> containerfd =3D open("/dev/vfio/vfio");
> ioctl(containerfd, VFIO_GET_API_VERSION);
> ioctl(containerfd, VFIO_CHECK_EXTENSION, ...);
> groupfd =3D open("/dev/vfio/$GROUP");
> ioctl(groupfd, VFIO_GROUP_GET_STATUS);
> ioctl(groupfd, VFIO_GROUP_SET_CONTAINER, &containerfd);
>=20
> You wanted to lock all the memory for the DMA window here, before we can
> call VFIO_IOMMU_GET_INFO, but does it need to happen there?  We still
> have a MAP_DMA hook.  We could do it all on the first mapping.

MAP_DMA isn't quite enough, since the guest can also directly cause
mappings using hypercalls directly implemented in KVM.  I think it
would be feasible to lock on the first mapping (either via MAP_DMA, or
H_PUT_TCE) though it would be a bit ugly and require that the first
H_PUT_TCE always bounce out to virtual mode (Alexey, correct me if I'm
wrong here).  IIRC there is also a call to bind the vfio container to
a (qemu assigned) LIOBN, before the guest can use H_PUT_TCE directly,
so that might be another place we could do the lock.

>  It also
> has a flags field that could augment the behavior to trigger page
> locking.

I don't see how the flags help us - we can't have userspace choose to
skip the locked memory accounting.  Or are you suggesting a flag to
open the container in some sort of dummy mode where only GET_INFO is
possible, then re-open with the full locking?

>  Adding the window size to sysfs seems more readily convenient,
> but is it so hard for userspace to open the files and call a couple
> ioctls to get far enough to call IOMMU_GET_INFO?  I'm unconvinced the
> clutter in sysfs more than just a quick fix.  Thanks,

And finally, as Alexey points out, isn't the point here so we know how
much rlimit to give qemu?  Using ioctls we'd need a special tool just
to check the dma window sizes, which seems a bit hideous.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--p11K2BJEgMZL61bg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlEjLA0ACgkQaILKxv3ab8ar/ACdG9jw3qxiR8yko5E43CZgzoBf
zGgAn13P5cI8apl8nXUsAxdFMhMNUHnN
=BTFN
-----END PGP SIGNATURE-----

--p11K2BJEgMZL61bg--
