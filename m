Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab3JaQkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:40:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44115 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab3JaQkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:40:31 -0400
Message-ID: <1383237623.7651.49.camel@fourier>
Subject: Re: [PATCH 3.8 79/81] fs: buffer: move allocation failure loop into
 the allocator
From: Kamal Mostafa <kamal@canonical.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 31 Oct 2013 09:40:23 -0700
In-Reply-To: <20131031140116.GC14054@cmpxchg.org>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
	 <1383069882-11437-80-git-send-email-kamal@canonical.com>
	 <20131031140116.GC14054@cmpxchg.org>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-fktFku7GHNz9POMf+jcd"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fktFku7GHNz9POMf+jcd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-10-31 at 10:01 -0400, Johannes Weiner wrote:
> This fix was tagged as a reminder for a bigger series, please don't
> apply for now.

Thanks Johannes -- I've dropped this one from the 3.8-stable queue.

 -Kamal


> On Tue, Oct 29, 2013 at 11:04:40AM -0700, Kamal Mostafa wrote:
> > 3.8.13.12 -stable review patch.  If anyone has any objections, please l=
et me know.
> >=20
> > ------------------
> >=20
> > From: Johannes Weiner <hannes@cmpxchg.org>
> >=20
> > commit 84235de394d9775bfaa7fa9762a59d91fef0c1fc upstream.
> >=20
> > Buffer allocation has a very crude indefinite loop around waking the
> > flusher threads and performing global NOFS direct reclaim because it ca=
n
> > not handle allocation failures.
> >=20
> > The most immediate problem with this is that the allocation may fail du=
e
> > to a memory cgroup limit, where flushers + direct reclaim might not mak=
e
> > any progress towards resolving the situation at all.  Because unlike th=
e
> > global case, a memory cgroup may not have any cache at all, only
> > anonymous pages but no swap.  This situation will lead to a reclaim
> > livelock with insane IO from waking the flushers and thrashing unrelate=
d
> > filesystem cache in a tight loop.
> >=20
> > Use __GFP_NOFAIL allocations for buffers for now.  This makes sure that
> > any looping happens in the page allocator, which knows how to
> > orchestrate kswapd, direct reclaim, and the flushers sensibly.  It also
> > allows memory cgroups to detect allocations that can't handle failure
> > and will allow them to ultimately bypass the limit if reclaim can not
> > make progress.
> >=20
> > Reported-by: azurIt <azurit@pobox.sk>
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Michal Hocko <mhocko@suse.cz>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> > ---
> >  fs/buffer.c     | 14 ++++++++++++--
> >  mm/memcontrol.c |  2 ++
> >  2 files changed, 14 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/fs/buffer.c b/fs/buffer.c
> > index 7a75c3e..be83882 100644
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -965,9 +965,19 @@ grow_dev_page(struct block_device *bdev, sector_t =
block,
> >  	struct buffer_head *bh;
> >  	sector_t end_block;
> >  	int ret =3D 0;		/* Will call free_more_memory() */
> > +	gfp_t gfp_mask;
> > =20
> > -	page =3D find_or_create_page(inode->i_mapping, index,
> > -		(mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS)|__GFP_MOVABLE);
> > +	gfp_mask =3D mapping_gfp_mask(inode->i_mapping) & ~__GFP_FS;
> > +	gfp_mask |=3D __GFP_MOVABLE;
> > +	/*
> > +	 * XXX: __getblk_slow() can not really deal with failure and
> > +	 * will endlessly loop on improvised global reclaim.  Prefer
> > +	 * looping in the allocator rather than here, at least that
> > +	 * code knows what it's doing.
> > +	 */
> > +	gfp_mask |=3D __GFP_NOFAIL;
> > +
> > +	page =3D find_or_create_page(inode->i_mapping, index, gfp_mask);
> >  	if (!page)
> >  		return ret;
> > =20
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 6b7ff19..b150e66f 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2614,6 +2614,8 @@ done:
> >  	return 0;
> >  nomem:
> >  	*ptr =3D NULL;
> > +	if (gfp_mask & __GFP_NOFAIL)
> > +		return 0;
> >  	return -ENOMEM;
> >  bypass:
> >  	*ptr =3D root_mem_cgroup;
> > --=20
> > 1.8.1.2
> >=20
>=20


--=-fktFku7GHNz9POMf+jcd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCAAGBQJScof3AAoJEHqwmdxYrXhZN6wP/RGuvTFmQaDa80ZmRVmAmclU
QykGUKU+5JHFJaPN+H7A1d5DZg713YmksCcYH/DZP0g3D0Ahd2BGMFCgQS1zOMW3
Pl5ffQ96PX7N907pxZETIcyOQUQVifsm9L+JSePYvTiHB1dBUUp534gGGZBX0mNL
sHIelUE1S13BPx7fyTJ99xzGD6u2cQyVoCbqrYjO7WwleCi5iwN5TNkIZC2hjim+
skdCs5vGk5QgAVWQNWnbZDjiE/SBg2sj5eaSQRGthsv2OW+K6JvfsC3e0ymlOQz3
wvy59Hc5W3+ZuFi/cg1VOLGyFaE7QQlVOUfx59MOF1SdZnrvx9XKwCWs8m7mMymN
7PyuEgRUn0o4sbpBjOe9pE3Mgu60ZlggJg6Yoi8VHxs1R6fEsXE1sgE7IAXc3lsG
mD1wVVeIl9+b1TJX0DESEAkOuqCgPsbE47pLqelVmqvXu0PGVWu1Zta1dP+G4SOk
OcBQZ9+bNiC2yipSBfJPk/a90KoQ9QBdW8BnHN6J7DQZaStWbULgksF5HBGZ8eCs
+XffTO4cskqlLamHKUKNs43pdbuDFYcZd2g1tSj7K8/lWUn/H1gDRgviRKquXSPk
x83YJWpJ3F8nDjukDm9dGwd3QTX27XI3I4cwsHqf/776nd7vU39Puyzbbpx5ZvrN
xMFYuacOhPlfetyPXWmQ
=vmvu
-----END PGP SIGNATURE-----

--=-fktFku7GHNz9POMf+jcd--

