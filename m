Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933814AbaFJBV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 21:21:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45515 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754398AbaFJBVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 21:21:55 -0400
Message-ID: <1402363302.23860.103.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.4 47/88] mm: add kmap_to_page()
From: Ben Hutchings <ben@decadent.org.uk>
To: Hugh Dickins <hughd@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Will Deacon <will.deacon@arm.com>
Date: Tue, 10 Jun 2014 02:21:42 +0100
In-Reply-To: <alpine.LSU.2.11.1406091806230.8481@eggly.anvils>
References: <20140610002424.500996570@linuxfoundation.org>
	 <20140610002426.089246636@linuxfoundation.org>
	 <alpine.LSU.2.11.1406091806230.8481@eggly.anvils>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-KdHLf5crfrlO87en+YCP"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KdHLf5crfrlO87en+YCP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-06-09 at 18:15 -0700, Hugh Dickins wrote:
> On Mon, 9 Jun 2014, Greg Kroah-Hartman wrote:
>=20
> > 3.4-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Ben Hutchings <ben@decadent.org.uk>
> >=20
> > commit fcb8996728fb59eddf84678df7cb213b2c9a2e26 upstream.
> >=20
> > This is extracted from Mel Gorman's commit 5a178119b0fb ('mm: add
> > support for direct_IO to highmem pages') upstream.
> >=20
> > Required to backport commit b9cdc88df8e6 ('virtio: 9p: correctly pass
> > physical address to userspace for high pages').
> >=20
> > Cc: Mel Gorman <mgorman@suse.de>
> > Cc: Rik van Riel <riel@redhat.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > Cc: Yijing Wang <wangyijing@huawei.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >=20
> > ---
> >  include/linux/highmem.h |    7 +++++++
> >  mm/highmem.c            |   12 ++++++++++++
> >  2 files changed, 19 insertions(+)
> >=20
> > --- a/include/linux/highmem.h
> > +++ b/include/linux/highmem.h
> > @@ -39,10 +39,17 @@ extern unsigned long totalhigh_pages;
> > =20
> >  void kmap_flush_unused(void);
> > =20
> > +struct page *kmap_to_page(void *addr);
> > +
> >  #else /* CONFIG_HIGHMEM */
> > =20
> >  static inline unsigned int nr_free_highpages(void) { return 0; }
> > =20
> > +static inline struct page *kmap_to_page(void *addr)
> > +{
> > +	return virt_to_page(addr);
> > +}
> > +
> >  #define totalhigh_pages 0UL
> > =20
> >  #ifndef ARCH_HAS_KMAP
> > --- a/mm/highmem.c
> > +++ b/mm/highmem.c
> > @@ -94,6 +94,18 @@ static DECLARE_WAIT_QUEUE_HEAD(pkmap_map
> >  		do { spin_unlock(&kmap_lock); (void)(flags); } while (0)
> >  #endif
> > =20
> > +struct page *kmap_to_page(void *vaddr)
> > +{
> > +	unsigned long addr =3D (unsigned long)vaddr;
> > +
> > +	if (addr >=3D PKMAP_ADDR(0) && addr <=3D PKMAP_ADDR(LAST_PKMAP)) {
> > +		int i =3D (addr - PKMAP_ADDR(0)) >> PAGE_SHIFT;
> > +		return pte_page(pkmap_page_table[i]);
> > +	}
> > +
> > +	return virt_to_page(addr);
> > +}
> > +
> >  static void flush_all_zero_pkmaps(void)
> >  {
> >  	int i;
>=20
> I think this needs the following on top:
>=20
> commit 498c2280212327858e521e9d21345d4cc2637f54
> Author: Will Deacon <will.deacon@arm.com>
> Date:   Fri Nov 16 14:15:00 2012 -0800
>=20
>     mm: highmem: don't treat PKMAP_ADDR(LAST_PKMAP) as a highmem address
[...]

Thanks Hugh, I've queued this up for 3.2 (where I previously added
kmap_to_page()).

Ben.

--=20
Ben Hutchings

--=-KdHLf5crfrlO87en+YCP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUAU5ZdrOe/yOyVhhEJAQqdqg/7B7ThZ1iHzT8dS9rktG7BQiUrt04dovtJ
5RTSf6aOWPsB2tHAFaFW0cJg8YHvM2e+/DX3UTbQ/MyUrCaxGMYXH1wB4s5VXGWB
NtPOg0pX1fvg8A8qk0gxu4k4dUBJS7xe9APSX2jn/0DKYWRV4Ogf7ZoBP3a72v7+
yB6RiWBSrllsd8hzlPEE97HFL6gPnisVgCtZ7CyumakSNib/QtMjLwnKLh4IeJy7
EPiCJzV3MME8n38xQMS/ygod877JaJ6/P5cqnGaCs68HkOBFEjrNt6nnXWaRYPIA
3v2VTzrkOL4EOvo98p/MlZfl/SGnJPPwgBMu5KqgClAv1Huj6k5ud+XSteaXtv9n
LYizumgLaIx2eFQrXo7HbV095DVeuD5Wzk9BlMzIN+ecWAqCi8TdL7mIHHFZPOU1
BS/npYqOeYIk5O30lkhvqpEprCpIM5JKO9PF8lwAuE1RxswFuihDe40Xg67Y2XW+
hDETNfb4caoyVn469JPwRb+gmUpHimsO5O9xNa/kvD6icZOLuKTnltq/5rJoshm9
v+GOMWlQeENttFAejDKAJLgqH4hIUKf1t9oZJsQIAJqLGBa4U5h+ZzdFWZyqtsvT
WueKMVx3prhBS9n9fkLkGxB5LJ3zDgQtGyv4311u0Vyda0i8ytodqz10u1sGw83+
NgKPqgDFQ+4=
=JdIC
-----END PGP SIGNATURE-----

--=-KdHLf5crfrlO87en+YCP--
