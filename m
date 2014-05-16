Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbaEPNqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:46:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:39460 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbaEPNqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:46:42 -0400
Date: Fri, 16 May 2014 15:46:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, mgorman@suse.de, chegu_vinod@hp.com,
        mingo@kernel.org
Subject: Re: [PATCH] sched,numa: update migrate_improves/degrades_locality
Message-ID: <20140516134637.GT11096@twins.programming.kicks-ass.net>
References: <20140515130306.61aae7db@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nc+Vvx0JXuqp7Zy0"
Content-Disposition: inline
In-Reply-To: <20140515130306.61aae7db@cuia.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nc+Vvx0JXuqp7Zy0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 01:03:06PM -0400, Rik van Riel wrote:
> Update the migrate_improves/degrades_locality functions with
> knowledge of pseudo-interleaving.
>=20
> Do not consider moving tasks around within the set of group's active
> nodes as improving or degrading locality. Instead, leave the load
> balancer free to balance the load between a numa_group's active nodes.
>=20
> Also, switch from the group/task_weight functions to the group/task_fault
> functions. The "weight" functions involve a division, but both calls use
> the same divisor, so there's no point in doing that from these functions.
>=20
> On a 4 node (x10 core) system, performance of SPECjbb2005 seems
> unaffected, though the number of migrations with 2 8-warehouse wide
> instances seems to have almost halved, due to the scheduler running
> each instance on a single node.
>=20
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>  kernel/sched/fair.c | 42 +++++++++++++++++++++++++++++-------------
>  1 file changed, 29 insertions(+), 13 deletions(-)
>=20
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 6504015..4f01e2f1 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4971,6 +4971,7 @@ task_hot(struct task_struct *p, u64 now, struct sch=
ed_domain *sd)
>  /* Returns true if the destination node has incurred more faults */
>  static bool migrate_improves_locality(struct task_struct *p, struct lb_e=
nv *env)
>  {
> +	struct numa_group *numa_group =3D ACCESS_ONCE(p->numa_group);

That wants to be rcu_dereference() to match the rcu_assign_pointer() we
use to set it.

Same in that wake_numa patch

>  	int src_nid, dst_nid;
> =20
>  	if (!sched_feat(NUMA_FAVOUR_HIGHER) || !p->numa_faults_memory ||

--Nc+Vvx0JXuqp7Zy0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdha9AAoJEHZH4aRLwOS6RCgP/At/KhqnJAOuZIvAyuynXo0k
8/ECUOYqOkiuYh0+SSAP4kjALRfam8Hr9l9OMFxD1AbK2p8NSAuZ8IBrwh3gHEI5
OKy2qSSbWqXixpptDCaCwaQlM+FmuieJInVGHmAE8dCAI5uZ8vaXg0yANC+fdGSO
SKuFas3tepA6r3lnHINaugRtCNFiByCh3sQ6qgsb5lr2KaKqtAWRJgGnQLO6s8vq
PKdn1Lz6b/RxdHuMt66ozkkaO/swb9+ZyH60NgX8SpRU3H+OHPYvgSiHOtRs4ybv
K2jPS+aeoXR8IZ2D021rzyO5VfjW2OnUOesjU2UA1oPQ2uk0pwNd9Bq5BbCG4cjC
ABiCsHaWauRxtm0UxOdx1XJw7vwch8qmhwRpMATKzDV96OQ8azgHG4G+fIsHJlXp
VkxOfo2EsS2teABgvXONTliGytRQ2Wd/oQxUjz4yr8RJD7duZIfTgz5xt42ZllNR
7s1ayz/Q0wxprgJsAbIlLU8/8FTe2SlqdE6TJwuwGFgpyRO+90mORr1swrSgN/3W
emU/Wn74V/XH42tKoJSYZNge6Kdm4wFSMWqtZ3KU9bv6brx+xxqZVWIhMs+/2Fpj
vR72yweo4qXGBkt89ZdYWKuQORaLUJQHG6yuFv6ir9dW6LwXLdpgpixBF90dvsdc
j8pZC8SgNy6d1EfxXpZM
=n2XL
-----END PGP SIGNATURE-----

--Nc+Vvx0JXuqp7Zy0--
