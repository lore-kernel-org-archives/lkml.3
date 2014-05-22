Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbaEVPFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:05:11 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56634 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaEVPFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:05:09 -0400
Date: Thu, 22 May 2014 17:04:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] mm: filemap: Avoid unnecessary barriers and waitqueue
 lookups in unlock_page fastpath v7
Message-ID: <20140522150451.GX30445@twins.programming.kicks-ass.net>
References: <20140515142414.16c47315a03160c58ceb9066@linux-foundation.org>
 <20140521121501.GT23991@suse.de>
 <20140521142622.049d0b3af5fc94912d5a1472@linux-foundation.org>
 <20140521213354.GL2485@laptop.programming.kicks-ass.net>
 <20140521145000.f130f8779f7641d0d8afcace@linux-foundation.org>
 <20140522000715.GA23991@suse.de>
 <20140522072001.GP30445@twins.programming.kicks-ass.net>
 <20140522104051.GE23991@suse.de>
 <20140522105638.GT30445@twins.programming.kicks-ass.net>
 <20140522144045.GH23991@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xFx/BiQzdL2KVl5R"
Content-Disposition: inline
In-Reply-To: <20140522144045.GH23991@suse.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xFx/BiQzdL2KVl5R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2014 at 03:40:45PM +0100, Mel Gorman wrote:

> > +static bool __wake_up_common(wait_queue_head_t *q, unsigned int mode,
> >  			int nr_exclusive, int wake_flags, void *key)
> >  {
> >  	wait_queue_t *curr, *next;
> > +	bool woke =3D false;
> > =20
> >  	list_for_each_entry_safe(curr, next, &q->task_list, task_list) {
> >  		unsigned flags =3D curr->flags;
> > =20
> > +		if (curr->func(curr, mode, wake_flags, key)) {
> > +			woke =3D true;
> > +			if ((flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
> > +				break;
> > +		}
> >  	}
> > +
> > +	return woke;
>=20
> Ok, thinking about this more I'm less sure.
>=20
> There are cases where the curr->func returns false even though there is a
> task that needs to run -- task was already running or preparing to run. We
> potentially end up clearing PG_waiters while there are still tasks on the
> waitqueue. As __finish_wait checks if the waitqueue is empty and the last
> waiter clears the bit I think there is nothing to gain by trying to do the
> same job in __wake_up_page_bit.

Hmm, I think you're right, we need the test result from
wake_bit_function(), unpolluted by the ttwu return value.

--xFx/BiQzdL2KVl5R
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTfhITAAoJEHZH4aRLwOS6QPwP/ianyeg1Og22VWtGmB2JDMj+
vwmHYM3laSDcijQJKgJkC1/l1maYSgzVy8RIZbT2I1rf3x+OVFp2Fp2sZQCFpmqN
qiDKCoWFbCuuU+Vh1tJ2SBqRwoLyLWFqj19s8E5FiJQsjeq73mlZrAAyVahRXcFJ
IqQLYbEdzumnw2097epuKlXHo8L7CD6k+Wzi/e7+7hh0LaE6BZbSmOchlwVYxuvU
xZYroF0tiCtgFATF3PNq/aQGkLgwgArnwmki6mqhL3dParUSqHNaLlMgWPetV4/7
HOiW9hB/puSDc9IXdyp69Auc94d8okxq9/EsIBKTiccli+8Vv47QPM22VM1IK4eo
0e4pDiYlIbWtyquWeAcwVd17ECDV1wWWU1i0F3ca0RZiVrXBjMeyit0fsjr/wR12
hMhsU78RnPS733+keqam/BEDOQqLEsVvxZqzNnnmcj9+kUrTh0wfyRmnpmqldphJ
G2d352v5BegpcLI/QEX9c0S5RcvJ5P9bFEKm2Vk2Gnf39pnR2JorMUrihe5HVhDQ
J9oH9HdREgFzaaOLIWbbkhs9bAFx0lk+A+F7ZBgQyhE5OOvMlU21KFuX6v6MR9ut
hvdUM3rvUVUpNwGoDbDJ63bSbRlqYYhicJuDFxnzMxVe5wovtC/LTyv5+OMI2Iyz
oa4gkpM6QX2ViZ0h8D9k
=WQp5
-----END PGP SIGNATURE-----

--xFx/BiQzdL2KVl5R--
