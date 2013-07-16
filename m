Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab3GPIZF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 04:25:05 -0400
Received: from ozlabs.org ([203.10.76.45]:40293 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707Ab3GPIY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 04:24:59 -0400
Date: Tue, 16 Jul 2013 18:20:48 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Rik van Riel <riel@redhat.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Michal Hocko <mhocko@suse.cz>,
        "AneeshKumarK.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hillf Danton <dhillf@gmail.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/hugetlb: per-vma instantiation mutexes
Message-ID: <20130716082048.GB8925@voom.fritz.box>
References: <1373671681.2448.10.camel@buesod1.americas.hpqcorp.net>
 <alpine.LNX.2.00.1307121729590.3899@eggly.anvils>
 <1373858204.13826.9.camel@buesod1.americas.hpqcorp.net>
 <20130715072432.GA28053@voom.fritz.box>
 <51E4A719.4020703@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1LKvkjL3sHcu1TtY"
Content-Disposition: inline
In-Reply-To: <51E4A719.4020703@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 15, 2013 at 09:51:21PM -0400, Rik van Riel wrote:
> On 07/15/2013 03:24 AM, David Gibson wrote:
> >On Sun, Jul 14, 2013 at 08:16:44PM -0700, Davidlohr Bueso wrote:
>=20
> >>>Reading the existing comment, this change looks very suspicious to me.
> >>>A per-vma mutex is just not going to provide the necessary exclusion, =
is
> >>>it?  (But I recall next to nothing about these regions and
> >>>reservations.)
> >
> >A per-VMA lock is definitely wrong.  I think it handles one form of
> >the race, between threads sharing a VM on a MAP_PRIVATE mapping.
> >However another form of the race can and does occur between different
> >MAP_SHARED VMAs in the same or different processes.  I think there may
> >be edge cases involving mremap() and MAP_PRIVATE that will also be
> >missed by a per-VMA lock.
> >
> >Note that the libhugetlbfs testsuite contains tests for both PRIVATE
> >and SHARED variants of the race.
>=20
> Can we get away with simply using a mutex in the file?
> Say vma->vm_file->mapping->i_mmap_mutex?

So I don't know the VM well enough to know if this could conflict with
other usages of i_mmap_mutex.  But unfortunately, whether or not its
otherwise correct that approach won't address the scalability issue at
hand here.

In the case where the race matters, we're always dealing with the same
file.  Otherwise, we'd end up with a genuine, rather than spurious,
out-of-memory error, regardless of how the race turned out.

So in the case with the performance bottleneck we're considering, the
i_mmap_mutex approach degenerates to serialization on a single mutex,
just as before.

In order to improve scalability, we need to consider which page within
the file we're instantiating which is what the hash function in my
patch does.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--1LKvkjL3sHcu1TtY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iEYEARECAAYFAlHlAmAACgkQaILKxv3ab8Z9pACgjq+XccmjkrIm3FKutgSw4yuL
RnAAn1R6al/xWrmcGmZlNk89z6SDvelQ
=Zbsg
-----END PGP SIGNATURE-----

--1LKvkjL3sHcu1TtY--
