Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303Ab3FVMF7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 08:05:59 -0400
Received: from ozlabs.org ([203.10.76.45]:36658 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756024Ab3FVMF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 08:05:58 -0400
Date: Sat, 22 Jun 2013 22:03:04 +1000
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
Message-ID: <20130622120304.GB25265@voom.fritz.box>
References: <87txkun568.fsf@rustcorp.com.au>
 <1371617970.21896.232.camel@pasglop>
 <E63966E3-336F-4CB8-96EC-24D2C1644E62@suse.de>
 <1371653443.21896.291.camel@pasglop>
 <1371656989.22659.98.camel@ul30vt.home>
 <51C28BEA.8050501@ozlabs.ru>
 <20130620052822.GB3140@voom.redhat.com>
 <1371714449.3944.14.camel@pasglop>
 <51C2C1CC.9000003@ozlabs.ru>
 <1371740113.32709.22.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LyciRD1jyfeSSjG0"
Content-Disposition: inline
In-Reply-To: <1371740113.32709.22.camel@ul30vt.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LyciRD1jyfeSSjG0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 20, 2013 at 08:55:13AM -0600, Alex Williamson wrote:
> On Thu, 2013-06-20 at 18:48 +1000, Alexey Kardashevskiy wrote:
> > On 06/20/2013 05:47 PM, Benjamin Herrenschmidt wrote:
> > > On Thu, 2013-06-20 at 15:28 +1000, David Gibson wrote:
> > >>> Just out of curiosity - would not get_file() and fput_atomic() on a
> > >> group's
> > >>> file* do the right job instead of vfio_group_add_external_user() and
> > >>> vfio_group_del_external_user()?
> > >>
> > >> I was thinking that too.  Grabbing a file reference would certainly =
be
> > >> the usual way of handling this sort of thing.
> > >=20
> > > But that wouldn't prevent the group ownership to be returned to
> > > the kernel or another user would it ?
> >=20
> >=20
> > Holding the file pointer does not let the group->container_users counte=
r go
> > to zero
>=20
> How so?  Holding the file pointer means the file won't go away, which
> means the group release function won't be called.  That means the group
> won't go away, but that doesn't mean it's attached to an IOMMU.  A user
> could call UNSET_CONTAINER.

Uhh... *thinks*.  Ah, I see.

I think the interface should not take the group fd, but the container
fd.  Holding a reference to *that* would keep the necessary things
around.  But more to the point, it's the right thing semantically:

The container is essentially the handle on a host iommu address space,
and so that's what should be bound by the KVM call to a particular
guest iommu address space.  e.g. it would make no sense to bind two
different groups to different guest iommu address spaces, if they were
in the same container - the guest thinks they are different spaces,
but if they're in the same container they must be the same space.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--LyciRD1jyfeSSjG0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iEYEARECAAYFAlHFkngACgkQaILKxv3ab8Y3+wCfQb5uscPEtj1cWB5jyIrMtx8E
oU8AnRKwvUpowC3jDzVnLa/1IjqF9OWM
=s2Y0
-----END PGP SIGNATURE-----

--LyciRD1jyfeSSjG0--
