Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab3G2WnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 18:43:16 -0400
Received: from ozlabs.org ([203.10.76.45]:36514 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090Ab3G2WnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 18:43:15 -0400
Date: Tue, 30 Jul 2013 08:37:08 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH v3 6/9] mm, hugetlb: do not use a page in page cache for
 cow optimization
Message-ID: <20130729223708.GG29970@voom.fritz.box>
References: <1375075701-5998-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375075701-5998-7-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0z5c7mBtSy1wdr4F"
Content-Disposition: inline
In-Reply-To: <1375075701-5998-7-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0z5c7mBtSy1wdr4F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2013 at 02:28:18PM +0900, Joonsoo Kim wrote:
> Currently, we use a page with mapped count 1 in page cache for cow
> optimization. If we find this condition, we don't allocate a new
> page and copy contents. Instead, we map this page directly.
> This may introduce a problem that writting to private mapping overwrite
> hugetlb file directly. You can find this situation with following code.
>=20
>         size =3D 20 * MB;
>         flag =3D MAP_SHARED;
>         p =3D mmap(NULL, size, PROT_READ|PROT_WRITE, flag, fd, 0);
>         if (p =3D=3D MAP_FAILED) {
>                 fprintf(stderr, "mmap() failed: %s\n", strerror(errno));
>                 return -1;
>         }
>         p[0] =3D 's';
>         fprintf(stdout, "BEFORE STEAL PRIVATE WRITE: %c\n", p[0]);
>         munmap(p, size);
>=20
>         flag =3D MAP_PRIVATE;
>         p =3D mmap(NULL, size, PROT_READ|PROT_WRITE, flag, fd, 0);
>         if (p =3D=3D MAP_FAILED) {
>                 fprintf(stderr, "mmap() failed: %s\n", strerror(errno));
>         }
>         p[0] =3D 'c';
>         munmap(p, size);
>=20
>         flag =3D MAP_SHARED;
>         p =3D mmap(NULL, size, PROT_READ|PROT_WRITE, flag, fd, 0);
>         if (p =3D=3D MAP_FAILED) {
>                 fprintf(stderr, "mmap() failed: %s\n", strerror(errno));
>                 return -1;
>         }
>         fprintf(stdout, "AFTER STEAL PRIVATE WRITE: %c\n", p[0]);
>         munmap(p, size);
>=20
> We can see that "AFTER STEAL PRIVATE WRITE: c", not "AFTER STEAL
> PRIVATE WRITE: s". If we turn off this optimization to a page
> in page cache, the problem is disappeared.

Please add this testcase to libhugetlbfs as well.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--0z5c7mBtSy1wdr4F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iEYEARECAAYFAlH27pQACgkQaILKxv3ab8Y1zQCeMhkqmAnW5YhDMt3vvNevhCEy
q1kAoIYN9xQpksF2BiXooGEd2dubypLC
=qB8Y
-----END PGP SIGNATURE-----

--0z5c7mBtSy1wdr4F--
