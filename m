Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751236Ab3FDSRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 14:17:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47354 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab3FDSRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 14:17:20 -0400
From: Frank Mehnert <frank.mehnert@oracle.com>
Organization: Oracle Corporation
To: Michal Hocko <mhocko@suse.cz>
Subject: Re: Handling NUMA page migration
Date: Tue, 4 Jun 2013 20:17:02 +0200
User-Agent: KMail/1.13.7 (Linux/3.9.4; KDE/4.8.4; x86_64; ; )
Cc: Robin Holt <holt@sgi.com>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
References: <201306040922.10235.frank.mehnert@oracle.com> <201306041414.52237.frank.mehnert@oracle.com> <20130604140230.GB31247@dhcp22.suse.cz>
In-Reply-To: <20130604140230.GB31247@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2372363.5TWfxzM5T7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201306042017.08828.frank.mehnert@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2372363.5TWfxzM5T7
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tuesday 04 June 2013 16:02:30 Michal Hocko wrote:
> On Tue 04-06-13 14:14:45, Frank Mehnert wrote:
> > On Tuesday 04 June 2013 13:58:07 Robin Holt wrote:
> > > This is probably more appropriate to be directed at the linux-mm
> > > mailing list.
> > >=20
> > > On Tue, Jun 04, 2013 at 09:22:10AM +0200, Frank Mehnert wrote:
> > > > Hi,
> > > >=20
> > > > our memory management on Linux hosts conflicts with NUMA page
> > > > migration. I assume this problem existed for a longer time but Linux
> > > > 3.8 introduced automatic NUMA page balancing which makes the problem
> > > > visible on multi-node hosts leading to kernel oopses.
> > > >=20
> > > > NUMA page migration means that the physical address of a page
> > > > changes. This is fatal if the application assumes that this never
> > > > happens for that page as it was supposed to be pinned.
> > > >=20
> > > > We have two kind of pinned memory:
> > > >=20
> > > > A) 1. allocate memory in userland with mmap()
> > > >=20
> > > >    2. madvise(MADV_DONTFORK)
> > > >    3. pin with get_user_pages().
> > > >    4. flush dcache_page()
> > > >    5. vm_flags |=3D (VM_DONTCOPY | VM_LOCKED)
> > > >   =20
> > > >       (resulting flags are VM_MIXEDMAP | VM_DONTDUMP | VM_DONTEXPAND
> > > >       |
> > > >      =20
> > > >        VM_DONTCOPY | VM_LOCKED | 0xff)
> > >=20
> > > I don't think this type of allocation should be affected.  The
> > > get_user_pages() call should elevate the pages reference count which
> > > should prevent migration from completing.  I would, however, wait for
> > > a more definitive answer.
> >=20
> > Thanks Robin! Actually case B) is more important for us so I'm waiting
> > for more feedback :)
>=20
> The manual node migration code seems to be OK in case B as well because
> Reserved are skipped (check check_pte_range called from down the
> do_migrate_pages path).
>=20
> Maybe auto-numa code is missing this check assuming that it cannot
> encounter reserved pages.
>=20
> migrate_misplaced_page relies on numamigrate_isolate_page which relies
> on isolate_lru_page and that one expects a LRU page. Is your Reserved
> page on the LRU list? That would be a bit unexpected.

I will check this.

In the meantime I verified that my testcase does not fail if I pass
'numa_balancing=3Dfalse' to the kernel, so it's definitely a NUMA balancing
problem.

I also did 'get_page()' on all pages of method B but the testcase so this
didn't help.

=46rank
=2D-=20
Dr.-Ing. Frank Mehnert | Software Development Director, VirtualBox
ORACLE Deutschland B.V. & Co. KG | Werkstr. 24 | 71384 Weinstadt, Germany

Hauptverwaltung: Riesstr. 25, D-80992 M=FCnchen
Registergericht: Amtsgericht M=FCnchen, HRA 95603
Gesch=E4ftsf=FChrer: J=FCrgen Kunz

Komplement=E4rin: ORACLE Deutschland Verwaltung B.V.
Hertogswetering 163/167, 3543 AS Utrecht, Niederlande
Handelsregister der Handelskammer Midden-Niederlande, Nr. 30143697
Gesch=E4ftsf=FChrer: Alexander van der Ven, Astrid Kepper, Val Maher

--nextPart2372363.5TWfxzM5T7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iEYEABECAAYFAlGuLyQACgkQ6z8pigLf3EezIwCeIx54xpvKr7NjL/adHLhVX5kh
eN0AnjwV8VC60qPWxCPN2jUmTd+OY8aV
=9gHt
-----END PGP SIGNATURE-----

--nextPart2372363.5TWfxzM5T7--
