Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab3F0LGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 07:06:19 -0400
Received: from ozlabs.org ([203.10.76.45]:50117 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab3F0LGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 07:06:16 -0400
Date: Thu, 27 Jun 2013 21:01:46 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Graf <agraf@suse.de>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>,
        "kvm@vger.kernel.org mailing list" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
Message-ID: <20130627110146.GE10614@voom.fritz.box>
References: <1371656989.22659.98.camel@ul30vt.home>
 <51C28BEA.8050501@ozlabs.ru>
 <20130620052822.GB3140@voom.redhat.com>
 <1371714449.3944.14.camel@pasglop>
 <51C2C1CC.9000003@ozlabs.ru>
 <1371740113.32709.22.camel@ul30vt.home>
 <20130622120304.GB25265@voom.fritz.box>
 <1371911286.30572.155.camel@ul30vt.home>
 <20130624035249.GD25265@voom.fritz.box>
 <1372048884.30572.168.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T6xhMxlHU34Bk0ad"
Content-Disposition: inline
In-Reply-To: <1372048884.30572.168.camel@ul30vt.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T6xhMxlHU34Bk0ad
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 23, 2013 at 10:41:24PM -0600, Alex Williamson wrote:
> On Mon, 2013-06-24 at 13:52 +1000, David Gibson wrote:
> > On Sat, Jun 22, 2013 at 08:28:06AM -0600, Alex Williamson wrote:
> > > On Sat, 2013-06-22 at 22:03 +1000, David Gibson wrote:
> > > > On Thu, Jun 20, 2013 at 08:55:13AM -0600, Alex Williamson wrote:
> > > > > On Thu, 2013-06-20 at 18:48 +1000, Alexey Kardashevskiy wrote:
> > > > > > On 06/20/2013 05:47 PM, Benjamin Herrenschmidt wrote:
> > > > > > > On Thu, 2013-06-20 at 15:28 +1000, David Gibson wrote:
> > > > > > >>> Just out of curiosity - would not get_file() and fput_atomi=
c() on a
> > > > > > >> group's
> > > > > > >>> file* do the right job instead of vfio_group_add_external_u=
ser() and
> > > > > > >>> vfio_group_del_external_user()?
> > > > > > >>
> > > > > > >> I was thinking that too.  Grabbing a file reference would ce=
rtainly be
> > > > > > >> the usual way of handling this sort of thing.
> > > > > > >=20
> > > > > > > But that wouldn't prevent the group ownership to be returned =
to
> > > > > > > the kernel or another user would it ?
> > > > > >=20
> > > > > >=20
> > > > > > Holding the file pointer does not let the group->container_user=
s counter go
> > > > > > to zero
> > > > >=20
> > > > > How so?  Holding the file pointer means the file won't go away, w=
hich
> > > > > means the group release function won't be called.  That means the=
 group
> > > > > won't go away, but that doesn't mean it's attached to an IOMMU.  =
A user
> > > > > could call UNSET_CONTAINER.
> > > >=20
> > > > Uhh... *thinks*.  Ah, I see.
> > > >=20
> > > > I think the interface should not take the group fd, but the contain=
er
> > > > fd.  Holding a reference to *that* would keep the necessary things
> > > > around.  But more to the point, it's the right thing semantically:
> > > >=20
> > > > The container is essentially the handle on a host iommu address spa=
ce,
> > > > and so that's what should be bound by the KVM call to a particular
> > > > guest iommu address space.  e.g. it would make no sense to bind two
> > > > different groups to different guest iommu address spaces, if they w=
ere
> > > > in the same container - the guest thinks they are different spaces,
> > > > but if they're in the same container they must be the same space.
> > >=20
> > > While the container is the gateway to the iommu, what empowers the
> > > container to maintain an iommu is the group.  What happens to a
> > > container when all the groups are disconnected or closed?  Groups are
> > > the unit that indicates hardware access, not containers.  Thanks,
> >=20
> > Uh... huh?  I'm really not sure what you're getting at.
> >=20
> > The operation we're doing for KVM here is binding a guest iommu
> > address space to a particular host iommu address space.  Why would we
> > not want to use the obvious handle on the host iommu address space,
> > which is the container fd?
>=20
> AIUI, the request isn't for an interface through which to do iommu
> mappings.  The request is for an interface to show that the user has
> sufficient privileges to do mappings.  Groups are what gives the user
> that ability.  The iommu is also possibly associated with multiple iommu
> groups and I believe what is being asked for here is a way to hold and
> lock a single iommu group with iommu protection.
>=20
> >From a practical point of view, the iommu interface is de-privileged
> once the groups are disconnected or closed.  Holding a reference count
> on the iommu fd won't prevent that.  That means we'd have to use a
> notifier to have KVM stop the side-channel iommu access.  Meanwhile
> holding the file descriptor for the group and adding an interface that
> bumps use counter allows KVM to lock itself in, just as if it had a
> device opened itself.  Thanks,

Ah, good point.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--T6xhMxlHU34Bk0ad
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iEYEARECAAYFAlHMG5oACgkQaILKxv3ab8ZSqACcD66HPsniLrrU9XXsnqLXmgfa
mZMAmwetSo2Gvo+AWtmCR21c6u3yd7LC
=EYwi
-----END PGP SIGNATURE-----

--T6xhMxlHU34Bk0ad--
