Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaFYFWB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:22:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:56386 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaFYFWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:22:00 -0400
Date: Wed, 25 Jun 2014 07:21:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, chegu_vinod@hp.com, mgorman@suse.de,
        mingo@kernel.org
Subject: Re: [PATCH 9/7] sched,numa: remove task_h_load from task_numa_compare
Message-ID: <20140625052144.GH3588@twins.programming.kicks-ass.net>
References: <1403538095-31256-1-git-send-email-riel@redhat.com>
 <20140624151454.2a05082e@annuminas.surriel.com>
 <20140625050735.GB28774@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oox5VnwalALFvA7"
Content-Disposition: inline
In-Reply-To: <20140625050735.GB28774@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oox5VnwalALFvA7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 25, 2014 at 07:07:35AM +0200, Peter Zijlstra wrote:
> Shall I merge this into patch 3?

Which gets me the below; which is has a wrong changelog.

task_h_load() already computes the load as seen from the root group.
effective_load() just does a better (and more expensive) job of
computing the task movement implications of a move.

So the total effect of this patch shouldn't be very big; regular load
balancing also only uses task_h_load(), see move_tasks().

Now, we don't run with preemption disabled, don't run as often, etc..,
so maybe we can indeed use the more expensive variant just fine, but
does it really matter?

---
Subject: sched,numa: use effective_load to balance NUMA loads
=46rom: Rik van Riel <riel@redhat.com>
Date: Mon, 23 Jun 2014 11:46:14 -0400

When CONFIG_FAIR_GROUP_SCHED is enabled, the load that a task places
on a CPU is determined by the group the task is in. This is conveniently
calculated for us by effective_load(), which task_numa_compare should
use.

The active groups on the source and destination CPU can be different,
so the calculation needs to be done separately for each CPU.

Cc: mgorman@suse.de
Cc: mingo@kernel.org
Cc: chegu_vinod@hp.com
Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1403538378-31571-3-git-send-email-riel@redha=
t.com
---
 kernel/sched/fair.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1151,6 +1151,7 @@ static void task_numa_compare(struct tas
 	struct rq *src_rq =3D cpu_rq(env->src_cpu);
 	struct rq *dst_rq =3D cpu_rq(env->dst_cpu);
 	struct task_struct *cur;
+	struct task_group *tg;
 	long src_load, dst_load;
 	long load;
 	long imp =3D (groupimp > 0) ? groupimp : taskimp;
@@ -1225,14 +1226,21 @@ static void task_numa_compare(struct tas
 	 * In the overloaded case, try and keep the load balanced.
 	 */
 balance:
-	load =3D task_h_load(env->p);
-	dst_load =3D env->dst_stats.load + load;
-	src_load =3D env->src_stats.load - load;
+	src_load =3D env->src_stats.load;
+	dst_load =3D env->dst_stats.load;
+
+	/* Calculate the effect of moving env->p from src to dst. */
+	load =3D env->p->se.load.weight;
+	tg =3D task_group(env->p);
+	src_load +=3D effective_load(tg, env->src_cpu, -load, -load);
+	dst_load +=3D effective_load(tg, env->dst_cpu, load, load);
=20
 	if (cur) {
-		load =3D task_h_load(cur);
-		dst_load -=3D load;
-		src_load +=3D load;
+		/* Cur moves in the opposite direction. */
+		load =3D cur->se.load.weight;
+		tg =3D task_group(cur);
+		src_load +=3D effective_load(tg, env->src_cpu, load, load);
+		dst_load +=3D effective_load(tg, env->dst_cpu, -load, -load);
 	}
=20
 	if (load_too_imbalanced(src_load, dst_load, env))



--2oox5VnwalALFvA7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTqlxoAAoJEHZH4aRLwOS66poQAIARItuby0Gr+uneoh+L1twP
Em1PiWh4cLE3/++2eJn0cjolZGg9FSzmvkFafX37p4wPOBcSwFTBtI+3PxBEW0xg
/joo9HL5mZwmBZelzgKWCrmictbi6/Y/Z7hhYQEGidkE/I21t7txFdw7Mk/6faA2
wUoDjeMCwfrzxJ3A7ZUkzUuCCffSzQL0chgdc2xY24xjcD5lKyik6ME6BBuXfZNz
ECQVeupXZoXDdrdBfLOsp6vacTzqjJRkVIx3RwlrpO3pfltOJTpTkf7iv1q6L5CN
fpSU7nEE09SSalMHKrzJNxAaJYl5+HfG7lLwhyRVAR8EDVgnVidk9x7GM1+FE6c+
iSRtkiLfDKf6yzWkWODwzZrAVwGaVbbTJeokdHSqwbF9dg4qD+p7waTvXW6qEHaj
9Zn0B0S2uCm/qO31VRmcZ/dvAPI/vje2U0k8GUCqEv2NESYCMC9FttVPSuA7mXZs
HUBPIoprkSPeEbtIW+v2gjFoeWItsMHPwfD/V0nqCHhXEJF74+VyyDGorlLB3Tdh
uYswNADHYc6yKjh1xVrSQyMd7j0sMNKDXpEJf20yr6EaapMP8PfUNoKriFLYCR2V
2cQVq51/ga30RneceWE5Lf/Ys6UO5sbX9WngSrCTPYX2XhJDmOWJzliHOhy+knFQ
pzlAhzbvOzhfz8X33NYA
=+DrB
-----END PGP SIGNATURE-----

--2oox5VnwalALFvA7--
