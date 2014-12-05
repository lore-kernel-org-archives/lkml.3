Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933646AbaLEEqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 23:46:13 -0500
Received: from ozlabs.org ([103.22.144.67]:54729 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933316AbaLEEqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 23:46:12 -0500
Date: Fri, 5 Dec 2014 15:46:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-ID: <20141205154606.5a09c45f@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/7u5_eWGP6DNwZJHSimTOD.C"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7u5_eWGP6DNwZJHSimTOD.C
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/radeon/radeon_cs.c between commit 86b276385c6a
("drm/radeon: sync all BOs involved in a CS v2") from Linus' tree and
commit 975700d2cc84 ("drm/radeon: split semaphore and sync object
handling v2") from the drm tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/radeon/radeon_cs.c
index 6f377de099f9,75f22e5e999f..000000000000
--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@@ -251,19 -251,22 +251,20 @@@ static int radeon_cs_get_ring(struct ra
 =20
  static int radeon_cs_sync_rings(struct radeon_cs_parser *p)
  {
 -	int i, r =3D 0;
 +	struct radeon_cs_reloc *reloc;
 +	int r;
 =20
 -	for (i =3D 0; i < p->nrelocs; i++) {
 +	list_for_each_entry(reloc, &p->validated, tv.head) {
  		struct reservation_object *resv;
 =20
 -		if (!p->relocs[i].robj)
 -			continue;
 -
 -		resv =3D p->relocs[i].robj->tbo.resv;
 +		resv =3D reloc->robj->tbo.resv;
- 		r =3D radeon_semaphore_sync_resv(p->rdev, p->ib.semaphore, resv,
- 					       reloc->tv.shared);
+ 		r =3D radeon_sync_resv(p->rdev, &p->ib.sync, resv,
 -				     p->relocs[i].tv.shared);
++				     reloc->tv.shared);
+=20
  		if (r)
 -			break;
 +			return r;
  	}
 -	return r;
 +	return 0;
  }
 =20
  /* XXX: note that this is called from the legacy UMS CS ioctl as well */

--Sig_/7u5_eWGP6DNwZJHSimTOD.C
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUgTiSAAoJEMDTa8Ir7ZwV3nkP/il5KIRGyjiHy+wJDIQ1VL+D
VTOkk0Ec5ItqcZ8KjcaqsiKFGVIKtnbbO5EX8wOIxeZMwUeQ2nqYrXpx0Fq0ywa4
NF2xQN3fzeFcCXkIBQ/RCEhP6nazUtOHvq2JnZ5S6+EEzqurCYYkVNH0WGCyoapX
RD63h0uu8QIYBptb46MWtRSm2a7MeQQ6kdloZA3/b5rlfQDQCqjpdCojGaRjBIF2
VbqG6unKoZaENgqa7ZzkzLuUxOqxgNhN2GzX9T13X9SFiLzaBFW4cJRzWXmVGfyW
KwKouj6DXm6/4tB0iPnlqLrhMOAKTPAUqGlESiCZ5Rj/D2Lwlg9D0ZgYzuW3bc0q
54rMvY+EoUSPBzTHAwzzKvf6AnfC9x98OTD8zZlWdwXkxZ3qVVsonLjnU2ESXpET
FO+sKi5iNYVi+sStd2QQTVc0pmZczw6wVvbNxwVFjanxxioyHSb3ITQBfi08kfIW
urAjOiEDdLh9wbLUBx9DrblMCDoQnq8GVA3hJG6vwRYoxu/QaHUpbDJoq314LdGC
v54fUtcnyozNfByYV6eMYv50GQ7H6KL5e1EMxUofPjQc5EPLQvsWhqtXwMvHXMT6
H+yZ8gOKh/I1WoQspEhkTOXuR6KAPe3+RMnI/Hh9EsE57QAwro0S28LC8A3p3jDN
a9xoIh8bMsdEH95fPqHD
=YHNE
-----END PGP SIGNATURE-----

--Sig_/7u5_eWGP6DNwZJHSimTOD.C--
