Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab3EYCpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 22:45:45 -0400
Received: from ozlabs.org ([203.10.76.45]:49783 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755520Ab3EYCpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 22:45:43 -0400
Date: Sat, 25 May 2013 12:45:24 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Scott Wood <scottwood@freescale.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Alexander Graf <agraf@suse.de>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
Message-ID: <20130525024524.GA6112@boomeroo.fritz.box>
References: <1369105607-20957-4-git-send-email-aik@ozlabs.ru>
 <1369256817.1374.29@scott-Lenovo-G560>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <1369256817.1374.29@scott-Lenovo-G560>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 22, 2013 at 04:06:57PM -0500, Scott Wood wrote:
> On 05/20/2013 10:06:46 PM, Alexey Kardashevskiy wrote:
> >diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> >index 8465c2a..da6bf61 100644
> >--- a/arch/powerpc/kvm/powerpc.c
> >@@ -396,6 +396,7 @@ int kvm_dev_ioctl_check_extension(long ext)
> >+++ b/arch/powerpc/kvm/powerpc.c
> > 		break;
> > #endif
> > 	case KVM_CAP_SPAPR_MULTITCE:
> >+	case KVM_CAP_SPAPR_TCE_IOMMU:
> > 		r =3D 1;
> > 		break;
> > 	default:
>=20
> Don't advertise SPAPR capabilities if it's not book3s -- and
> probably there's some additional limitation that would be
> appropriate.

So, in the case of MULTITCE, that's not quite right.  PR KVM can
emulate a PAPR system on a BookE machine, and there's no reason not to
allow TCE acceleration as well.  We can't make it dependent on PAPR
mode being selected, because that's enabled per-vcpu, whereas these
capabilities are queried on the VM before the vcpus are created.

CAP_SPAPR_TCE_IOMMU should be dependent on the presence of suitable
host side hardware (i.e. a PAPR style IOMMU), though.

>=20
> >@@ -1025,6 +1026,17 @@ long kvm_arch_vm_ioctl(struct file *filp,
> > 		r =3D kvm_vm_ioctl_create_spapr_tce(kvm, &create_tce);
> > 		goto out;
> > 	}
> >+	case KVM_CREATE_SPAPR_TCE_IOMMU: {
> >+		struct kvm_create_spapr_tce_iommu create_tce_iommu;
> >+		struct kvm *kvm =3D filp->private_data;
> >+
> >+		r =3D -EFAULT;
> >+		if (copy_from_user(&create_tce_iommu, argp,
> >+				sizeof(create_tce_iommu)))
> >+			goto out;
> >+		r =3D kvm_vm_ioctl_create_spapr_tce_iommu(kvm,
> >&create_tce_iommu);
> >+		goto out;
> >+	}
> > #endif /* CONFIG_PPC_BOOK3S_64 */
> >
> > #ifdef CONFIG_KVM_BOOK3S_64_HV
> >diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> >index 5a2afda..450c82a 100644
> >--- a/include/uapi/linux/kvm.h
> >+++ b/include/uapi/linux/kvm.h
> >@@ -667,6 +667,7 @@ struct kvm_ppc_smmu_info {
> > #define KVM_CAP_PPC_RTAS 91
> > #define KVM_CAP_IRQ_XICS 92
> > #define KVM_CAP_SPAPR_MULTITCE (0x110000 + 89)
> >+#define KVM_CAP_SPAPR_TCE_IOMMU (0x110000 + 90)
>=20
> Hmm...

Ah, yeah, that needs to be fixed.  Those were interim numbers so that
we didn't have to keep changing our internal trees as new upstream
ioctls got added to the list.  We need to get a proper number for the
merge, though.

> >@@ -939,6 +940,9 @@ struct kvm_s390_ucas_mapping {
> > #define KVM_GET_DEVICE_ATTR	  _IOW(KVMIO,  0xe2, struct
> >kvm_device_attr)
> > #define KVM_HAS_DEVICE_ATTR	  _IOW(KVMIO,  0xe3, struct
> >kvm_device_attr)
> >
> >+/* ioctl for SPAPR TCE IOMMU */
> >+#define KVM_CREATE_SPAPR_TCE_IOMMU _IOW(KVMIO,  0xe4, struct
> >kvm_create_spapr_tce_iommu)
>=20
> Shouldn't this go under the vm ioctl section?
>=20
> -Scott
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlGgJcQACgkQaILKxv3ab8ZmRACgiZkN+YrEJznPIdTXJnteWkWJ
W5oAoI27k+GoJWKOu/aUyGPn2xr8Ofrm
=UO/s
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
