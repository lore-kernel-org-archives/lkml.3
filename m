Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbaENP3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:29:51 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36140 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbaENP3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:29:50 -0400
Date: Wed, 14 May 2014 17:29:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, mgorman@suse.de
Subject: Re: [PATCH] sched,numa: move processes with load difference
Message-ID: <20140514152943.GO30445@twins.programming.kicks-ass.net>
References: <20140513195550.315a92bf@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1NucUmLGa7VWJfBD"
Content-Disposition: inline
In-Reply-To: <20140513195550.315a92bf@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1NucUmLGa7VWJfBD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2014 at 07:55:50PM -0400, Rik van Riel wrote:
> Currently the numa balancing code refuses to move a task from a
> heavily loaded node to a much less heavily loaded node, if the
> difference in load between them is large enough.
>=20
> If the source load is larger than the destination load after the
> swap, moving the task is fine. Chances are the load balancer would
> move tasks in the same direction, anyway.

So the intent of that code was that the swap (remember, both tasks don't
need to have the same weight) wouldn't push us over the imbalance
threshold.

Now we want to test that threshold both ways, dst being small and src
being large, and vice versa.

However, if we've already crossed that imbalance, crossing it isn't the
right test.

In that case I think we want to limit the swap such that the imbalance
improves (ie. gets smaller).

Something like the below perhaps (entirely untested).

Or am I missing something?

---
 kernel/sched/fair.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 28ccf502c63c..87f88568ecb3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1107,7 +1107,9 @@ static void task_numa_compare(struct task_numa_env *e=
nv,
 	struct rq *src_rq =3D cpu_rq(env->src_cpu);
 	struct rq *dst_rq =3D cpu_rq(env->dst_cpu);
 	struct task_struct *cur;
+	long orig_dst_load, orig_src_load;
 	long dst_load, src_load;
+	long imb, orig_imb;
 	long load;
 	long imp =3D (groupimp > 0) ? groupimp : taskimp;
=20
@@ -1181,8 +1183,8 @@ static void task_numa_compare(struct task_numa_env *e=
nv,
 	 * In the overloaded case, try and keep the load balanced.
 	 */
 balance:
-	dst_load =3D env->dst_stats.load;
-	src_load =3D env->src_stats.load;
+	orig_dst_load =3D dst_load =3D env->dst_stats.load;
+	orig_src_load =3D src_load =3D env->src_stats.load;
=20
 	/* XXX missing power terms */
 	load =3D task_h_load(env->p);
@@ -1195,12 +1197,33 @@ static void task_numa_compare(struct task_numa_env =
*env,
 		src_load +=3D load;
 	}
=20
-	/* make src_load the smaller */
+	/*=20
+	 * We want to compute the 'slope' of the imbalance between src and dst
+	 * since we're not interested in what direction the slope is.
+	 *
+	 * So make src_load the smaller.
+	 */
 	if (dst_load < src_load)
 		swap(dst_load, src_load);
=20
-	if (src_load * env->imbalance_pct < dst_load * 100)
-		goto unlock;
+	/*
+	 * Test if the slope is over or under the imb_pct
+	 */
+	imb =3D dst_load * 100 - src_load * env->imbalance_pct;
+	if (imb >=3D 0) {
+		/*
+		 * If the slope is over the imb_pct, check the original state;
+		 * if we started out already being imbalanced, see if this swap
+		 * improves the situation by reducing the slope, even though
+		 * its still over the threshold.
+		 */
+		if (orig_dst_load < orig_src_load)
+			swap(orig_dst_load, orig_src_load);
+
+		orig_imb =3D orig_dst_load * 100 - orig_src_load * env->imbalance_pct;
+		if (imb > orig_imb)
+			goto unlock;
+	}
=20
 assign:
 	task_numa_assign(env, cur, imp);

--1NucUmLGa7VWJfBD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTc4vnAAoJEHZH4aRLwOS65C8P/2kA34kUywxrU3E9A8IZaO/R
WFBb8VO9zsw9euvdUIIbLTC4DX+g/G9kTLFs9H8Vktxpk1OzdeKFj46aQ1uEjYDt
LIcbgzPfReTheSvhSAIWQtIqm2pTmtMp/qSqQsQ87y70EWDIIlaJMXjIumtAo0sc
Fy5hXOjS9lp6jcymSyc4CBUK07wAaXSh5mDUOFzuyOf3DVv/yjHIR6CULIp7wuF6
QxukVV8PIDxEcfGmdqZL4buXvtHaX+9EI0Rtkie92WxjZyoExAxTAkdaBidbLltt
0+7My4xUCCxVC6zHvHJ7TknSKjM3bxrcbYOFUDZXwrlGuNE781fC5O6BpfjCeuPv
UD3FNIBOyF2nk8+ZXmz70qv5HPydr4HdIR00DPhu0Vfp/vnHrd50QEayNCoeYaFC
usJ/e7a2oOh/QdTtSK0RzLpU0AqSxcapR+vjVfWUS1/F4GzmlIrJMZ86FiGjRu1y
ISowgZVsnX95Dk5l5Lgu4uEIPZS4YFA1u0+ndqPfcu9diCQNRY9198GqmkDniOJn
eo2vqphyY5YFJ2ZJzwbRKHw13RM8thbCtAW43q0x+7CxgCJEAm9EPli2rXZSQ9Rd
0NVkkQdHNC4I+EE2ro2ixiQY6+PBp5tuGU0lDJhs/7jD8OO2RZvaoZhZ/8e5NEDj
y9s7ytHOVNMDHcoqCSil
=JB+d
-----END PGP SIGNATURE-----

--1NucUmLGa7VWJfBD--
