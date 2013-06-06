Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab3FFKJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:09:35 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:39958 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932594Ab3FFKJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:09:30 -0400
From: Frank Mehnert <frank.mehnert@oracle.com>
Organization: Oracle Corporation
To: Mel Gorman <mgorman@suse.de>
Subject: Re: Handling NUMA page migration
Date: Thu, 6 Jun 2013 12:09:09 +0200
User-Agent: KMail/1.13.7 (Linux/3.9.4; KDE/4.8.4; x86_64; ; )
Cc: Robin Holt <holt@sgi.com>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
References: <201306040922.10235.frank.mehnert@oracle.com> <201306051235.35678.frank.mehnert@oracle.com> <20130605123400.GA1936@suse.de>
In-Reply-To: <20130605123400.GA1936@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1493750.8EIKnciplG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201306061209.13916.frank.mehnert@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1493750.8EIKnciplG
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Wednesday 05 June 2013 14:34:00 Mel Gorman wrote:
> On Wed, Jun 05, 2013 at 12:35:35PM +0200, Frank Mehnert wrote:
> > On Wednesday 05 June 2013 12:10:19 Mel Gorman wrote:
> > > On Tue, Jun 04, 2013 at 06:58:07AM -0500, Robin Holt wrote:
> > > > > B) 1. allocate memory with alloc_pages()
> > > > >=20
> > > > >    2. SetPageReserved()
> > > > >    3. vm_mmap() to allocate a userspace mapping
> > > > >    4. vm_insert_page()
> > > > >    5. vm_flags |=3D (VM_DONTEXPAND | VM_DONTDUMP)
> > > > >   =20
> > > > >       (resulting flags are VM_MIXEDMAP | VM_DONTDUMP |
> > > > >       VM_DONTEXPAND | 0xff)
> > > > >=20
> > > > > At least the memory allocated like B) is affected by automatic NU=
MA
> > > > > page migration. I'm not sure about A).
> > > > >=20
> > > > > 1. How can I prevent automatic NUMA page migration on this memory?
> > > > > 2. Can NUMA page migration also be handled on such kind of memory
> > > > > without
> > > > >=20
> > > > >    preventing migration?
> > >=20
> > > Page migration does not expect a PageReserved && PageLRU page. The on=
ly
> > > reserved check that is made by migration is for the zero page and that
> > > happens in the syscall path for move_pages() which is not used by
> > > either compaction or automatic balancing.
> > >=20
> > > At some point you must have a driver that is setting PageReserved on
> > > anonymous pages that is later encountered by automatic numa balancing
> > > during a NUMA hinting fault.  I expect this is an out-of-tree driver =
or
> > > a custom kernel of some sort. Memory should be pinned by elevating the
> > > reference count of the page, not setting PageReserved.
> >=20
> > Yes, this is ring 0 code from VirtualBox. The VBox ring 0 driver does t=
he
> > steps which are shown above. Setting PageReserved is not only for pinni=
ng
> > but also for fork() protection.
>=20
> Offhand I don't see what setting PageReserved on an LRU page has to do
> with fork() protection. If the VMA should not be copied by fork then use
> MADV_DONTFORK.

I'm not sure either. That code has grown over years and was even working
on Linux 2.4.

> > I've tried to do get_page() as well but
> > it did not help preventing the migration during NUMA balancing.
>=20
> I think you mean elevating the page count did not prevent the unmapping.
> The elevated count should have prevented the actual migration but would
> not prevent the unmapping.

Right, that's what I meant and your explanations make sense to me.

> > As I wrote, the code for allocating + mapping the memory assumes that
> > the memory is finally pinned and will be never unmapped. That assumption
> > might be wrong or wrong under certain/rare conditions. I would like to
> > know these conditions and how we can prevent them from happening or how
> > we can handle them correctly.
>=20
> Memory compaction for THP allocations will break that assumption as
> compaction ignores VM_LOCKED. I strongly suspect that if you did something
> like move a process into a cpuset bound to another node that it would
> also break. If a process like numad is running then it would probably
> break virtualbox as well as it triggers migration from userspace. It is
> a fragile assumption to make.
>=20
> > > It's not particularly clear how you avoid hitting the same bug due to
> > > THP and memory compaction to be honest but maybe your setup hits a
> > > steady state that simply never hit the problem or it happens rarely
> > > and it was not identified.
> >=20
> > I'm currently using the stock Ubuntu 13.04 generic kernel (3.8.0-23),
>=20
> and an out-of-tree driver which is what is hitting the problem.

Right.

> A few of your options in order of estimated time to completion are;
>=20
> 1. Disable numa balancing within your driver or fail to start if it's
>    running
> 2. Create a patch that adds a new NUMA_PTE_SCAN_IGNORE value for
>    mm->first_nid (see includ/linux.mm_types.h). In sched/core/fair.c,
>    add a check that first_nid =3D=3D NUMA_PTE_SCAN_IGNORE should be ignor=
ed.
>    Document that only virtualbox needs this and set it within your
>    driver. This will not fix the compaction cases or numad using cpusets
>    to migrate your processes though
> 3. When the driver affects a region, set mm->numa_next_reset and
>    mm->numa_next_scan to large values to prevent the pages being unmapped.
>    This would be very fragile, could break again in the future and is ugly
> 4. Add a check in change_pte_range() for the !prot_numa case to check
>    PageReserved. This will prevent automatic numa balancing unmapping the
>    page. Document that only virtualbox requires this.
> 5. Add a check in change_pte_range() for an elevated page count.
>    Document that there is no point unmapping a page for a NUMA hinting
>    fault that will only fail migration later anyway which is true albeit =
of
>    marginal benefit. Then, in the vbox driver, elevate the page count, do
>    away with the PageReserved trick, use MADV_DONTFORK to prevent copying
>    at fork time.

Thank you for these suggestions! For now I tried your suggestion 4) although
I think you meant the prot_numa case, not the !prot_numa case, correct?

It also turned out that we even must not do ptep_modify_prot_start() for su=
ch
ranges, therefore I added the PageReserved() check like this:

=2D-- mm/mprotect.c       2013-06-05 18:24:41.564777871 +0200
+++ mm/mprotect.c       2013-06-05 17:16:47.689923398 +0200
@@ -54,14 +54,22 @@
                        pte_t ptent;
                        bool updated =3D false;

+                       struct page *page;
+
+                       page =3D vm_normal_page(vma, addr, oldpte);
+                       if (page && PageReserved(page))
+                               continue;
+
                        ptent =3D ptep_modify_prot_start(mm, addr, pte);
                        if (!prot_numa) {
                                ptent =3D pte_modify(ptent, newprot);
                                updated =3D true;
                        } else {
+#if 0
                                struct page *page;
                                page =3D vm_normal_page(vma, addr, oldpte);
+#endif
                                if (page) {
                                        int this_nid =3D page_to_nid(page);
                                        if (last_nid =3D=3D -1)

With this change I cannot reproduce any problems anymore.

Adding such a change to the kernel would help us a lot. OTOH I wonder why it
is not possible to prevent these unmaps with other means, for instance for
VM arease with VM_IO set. Wouldn't that make sense?

What I didn't mention explicitely in my previous postings: I assume that all
these problems come also from using R3 addresses from R0 code. That might be
evil but VirtualBox does currently map the complete guest address space into
the address space of the corresponding host process for simplicity reasons.
Mapping into R0 isn't possible, at least not on 32-bit hosts. But I would
like to know if R0 mappings (vmap()) would be affected by any kind of page
migration.

Thanks,

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

--nextPart1493750.8EIKnciplG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iEUEABECAAYFAlGwX8kACgkQ6z8pigLf3EcsUQCeNqpDxKpvfr+iZppwwHQJj6wM
77AAmITbmxXdzDuDVweZEBcKGN8j3nU=
=kJvp
-----END PGP SIGNATURE-----

--nextPart1493750.8EIKnciplG--
