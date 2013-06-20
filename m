Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab3FTGzN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 02:55:13 -0400
Received: from ozlabs.org ([203.10.76.45]:45778 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab3FTGzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 02:55:10 -0400
Date: Thu, 20 Jun 2013 15:28:22 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Alexey Kardashevskiy <aik@ozlabs.ru>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Graf <agraf@suse.de>, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>,
        "kvm@vger.kernel.org mailing list" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
Message-ID: <20130620052822.GB3140@voom.redhat.com>
References: <1371422343.21896.143.camel@pasglop>
 <1371438800.22681.38.camel@ul30vt.home>
 <1371441361.21896.152.camel@pasglop>
 <1371522772.22681.140.camel@ul30vt.home>
 <87txkun568.fsf@rustcorp.com.au>
 <1371617970.21896.232.camel@pasglop>
 <E63966E3-336F-4CB8-96EC-24D2C1644E62@suse.de>
 <1371653443.21896.291.camel@pasglop>
 <1371656989.22659.98.camel@ul30vt.home>
 <51C28BEA.8050501@ozlabs.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XF85m9dhOBO43t/C"
Content-Disposition: inline
In-Reply-To: <51C28BEA.8050501@ozlabs.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 20, 2013 at 02:58:18PM +1000, Alexey Kardashevskiy wrote:
> On 06/20/2013 01:49 AM, Alex Williamson wrote:
> > On Thu, 2013-06-20 at 00:50 +1000, Benjamin Herrenschmidt wrote:
> >> On Wed, 2013-06-19 at 11:58 +0200, Alexander Graf wrote:
> >>
> >>>> Alex, any objection ?
> >>>
> >>> Which Alex? :)
> >>
> >> Heh, mostly Williamson in this specific case but your input is still
> >> welcome :-)
> >>
> >>> I think validate works, it keeps iteration logic out of the kernel
> >>> which is a good thing. There still needs to be an interface for
> >>> getting the iommu id in VFIO, but I suppose that one's for the other
> >>> Alex and J=F6rg to comment on.
> >>
> >> I think getting the iommu fd is already covered by separate patches fr=
om
> >> Alexey.
> >>
> >>>>
> >>>> Do we need to make it a get/put interface instead ?
> >>>>
> >>>> 	vfio_validate_and_use_iommu(file, iommu_id);
> >>>>
> >>>> 	vfio_release_iommu(file, iommu_id);
> >>>>
> >>>> To ensure that the resource remains owned by the process until KVM
> >>>> is closed as well ?
> >>>>
> >>>> Or do we want to register with VFIO with a callback so that VFIO can
> >>>> call us if it needs us to give it up ?
> >>>
> >>> Can't we just register a handler on the fd and get notified when it
> >>> closes? Can you kill VFIO access without closing the fd?
> >>
> >> That sounds actually harder :-)
> >>
> >> The question is basically: When we validate that relationship between a
> >> specific VFIO struct file with an iommu, what is the lifetime of that
> >> and how do we handle this lifetime properly.
> >>
> >> There's two ways for that sort of situation: The notification model
> >> where we get notified when the relationship is broken, and the refcount
> >> model where we become a "user" and thus delay the breaking of the
> >> relationship until we have been disposed of as well.
> >>
> >> In this specific case, it's hard to tell what is the right model from =
my
> >> perspective, which is why I would welcome Alex (W.) input.
> >>
> >> In the end, the solution will end up being in the form of APIs exposed
> >> by VFIO for use by KVM (via that symbol lookup mechanism) so Alex (W),
> >> as owner of VFIO at this stage, what do you want those to look
> >> like ? :-)
> >=20
> > My first thought is that we should use the same reference counting as we
> > have for vfio devices (group->container_users).  An interface for that
> > might look like:
> >=20
> > int vfio_group_add_external_user(struct file *filep)
> > {
> > 	struct vfio_group *group =3D filep->private_data;
> >=20
> > 	if (filep->f_op !=3D &vfio_group_fops)
> > 		return -EINVAL;
> >=20
> >=20
> > 	if (!atomic_inc_not_zero(&group->container_users))
> > 		return -EINVAL;
> >=20
> > 	return 0;
> > }
> >=20
> > void vfio_group_del_external_user(struct file *filep)
> > {
> > 	struct vfio_group *group =3D filep->private_data;
> >=20
> > 	BUG_ON(filep->f_op !=3D &vfio_group_fops);
> >=20
> > 	vfio_group_try_dissolve_container(group);
> > }
> >=20
> > int vfio_group_iommu_id_from_file(struct file *filep)
> > {
> > 	struct vfio_group *group =3D filep->private_data;
> >=20
> > 	BUG_ON(filep->f_op !=3D &vfio_group_fops);
> >=20
> > 	return iommu_group_id(group->iommu_group);
> > }
> >=20
> > Would that work?  Thanks,
>=20
>=20
> Just out of curiosity - would not get_file() and fput_atomic() on a group=
's
> file* do the right job instead of vfio_group_add_external_user() and
> vfio_group_del_external_user()?

I was thinking that too.  Grabbing a file reference would certainly be
the usual way of handling this sort of thing.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--XF85m9dhOBO43t/C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iEYEARECAAYFAlHCkvYACgkQaILKxv3ab8blJQCfaU/b+ZMtR3tAs19lTgo5OW2A
QuoAoISckfJ8nSiPr4dKnxCdJPO+CxDh
=Xlqu
-----END PGP SIGNATURE-----

--XF85m9dhOBO43t/C--
