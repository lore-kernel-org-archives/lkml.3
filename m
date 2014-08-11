Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbaHKNeP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:34:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58303 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaHKNeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:34:14 -0400
Date: Mon, 11 Aug 2014 15:33:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Ingo Molnar <mingo@kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [sched] 143e1e28cb4: +17.9% aim7.jobs-per-min, -9.7%
 hackbench.throughput
Message-ID: <20140811133352.GC9918@twins.programming.kicks-ass.net>
References: <20140810044127.GB11810@localhost>
 <20140810075915.GR9918@twins.programming.kicks-ass.net>
 <20140810105413.GA29451@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ylo1C32i66pBmIvY"
Content-Disposition: inline
In-Reply-To: <20140810105413.GA29451@localhost>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ylo1C32i66pBmIvY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 10, 2014 at 06:54:13PM +0800, Fengguang Wu wrote:
> This view may be easier to read, by grouping the metrics by test case.
>=20
> test case: brickland1/aim7/6000-page_test

OK, I have a similar system to the brickland thing (slightly different
configuration, but should be close enough).

Now; do you have a description of each test-case someplace? In
particular, it might be good to have a small annotation to show which
direction is better.

>=20
>     128529 =B1 1%     +17.9%     151594 =B1 0%  TOTAL aim7.jobs-per-min

jobs per minute, + is better, so no worries there.

>     582269 =B114%     -55.6%     258617 =B116%  TOTAL softirqs.SCHED
>     993654 =B1 2%     -19.9%     795962 =B1 3%  TOTAL softirqs.RCU
>   15865125 =B1 1%     -15.0%   13485882 =B1 1%  TOTAL softirqs.TIMER

>   59366697 =B1 3%     -46.1%   32017187 =B1 7%  TOTAL cpuidle.C1-IVT.time
>      54543 =B111%     -37.2%      34252 =B116%  TOTAL cpuidle.C1-IVT.usage
>      19542 =B1 9%     -38.3%      12057 =B1 4%  TOTAL cpuidle.C1E-IVT.usa=
ge
>   49527464 =B1 6%     -32.4%   33488833 =B1 4%  TOTAL cpuidle.C1E-IVT.time
>      76064 =B1 3%     -32.2%      51572 =B1 6%  TOTAL cpuidle.C6-IVT.usage

Less idle time; might be good, if the work is cpubound, might be bad if
not; hard to say.

>       2.82 =B1 3%     +21.9%       3.43 =B1 4%  TOTAL turbostat.%pc2
>       4.40 =B1 2%     +22.0%       5.37 =B1 4%  TOTAL turbostat.%c6
>      15.75 =B1 1%      -3.4%      15.21 =B1 0%  TOTAL turbostat.RAM_W

>    3150464 =B1 2%     -24.2%    2387551 =B1 3%  TOTAL time.voluntary_cont=
ext_switches

Typically less ctxsw is better..

>        281 =B1 1%     -15.1%        238 =B1 0%  TOTAL time.elapsed_time
>      29294 =B1 1%     -14.3%      25093 =B1 0%  TOTAL time.system_time

Less time spend (on presumably the same work) is better

>    4529818 =B1 1%      -8.8%    4129398 =B1 1%  TOTAL time.involuntary_co=
ntext_switches

Less preemptions, also generally better

>      10655 =B1 0%      +1.4%      10802 =B1 0%  TOTAL time.percent_of_cpu=
_this_job_got

Seem an improvement; not sure.

Many more stats.. but from the above it looks like its an overall 'win';
or am I reading the thing wrong?


Now I think I see why this is; we've reduced load balancing frequency
significantly on this machine due to:


-#define SD_SIBLING_INIT (struct sched_domain) {                           =
     \
-       .min_interval           =3D 1,                                    \
-       .max_interval           =3D 2,                                    \


-#define SD_MC_INIT (struct sched_domain) {                             \
-       .min_interval           =3D 1,                                    \
-       .max_interval           =3D 4,                                    \


-#define SD_CPU_INIT (struct sched_domain) {                            \
-       .min_interval           =3D 1,                                    \
-       .max_interval           =3D 4,                                    \


        *sd =3D (struct sched_domain){
                .min_interval           =3D sd_weight,
                .max_interval           =3D 2*sd_weight,

Which both increased the min and max value significantly for all domains
involved.

That said; I think we might want to do something like the below; I can
imagine decreasing load balancing too much will negatively impact other
workloads.

Maybe slightly modified to make sure the first domain has a min_interval
of 1.

---
 kernel/sched/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1211575a2208..67ed5d854da1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6049,8 +6049,8 @@ sd_init(struct sched_domain_topology_level *tl, int c=
pu)
 		sd_flags &=3D ~TOPOLOGY_SD_FLAGS;
=20
 	*sd =3D (struct sched_domain){
-		.min_interval		=3D sd_weight,
-		.max_interval		=3D 2*sd_weight,
+		.min_interval		=3D max(1, sd_weight/2),
+		.max_interval		=3D sd_weight,
 		.busy_factor		=3D 32,
 		.imbalance_pct		=3D 125,
=20
@@ -6076,7 +6076,7 @@ sd_init(struct sched_domain_topology_level *tl, int c=
pu)
 					,
=20
 		.last_balance		=3D jiffies,
-		.balance_interval	=3D sd_weight,
+		.balance_interval	=3D max(1, sd_weight/2),
 		.smt_gain		=3D 0,
 		.max_newidle_lb_cost	=3D 0,
 		.next_decay_max_lb_cost	=3D jiffies,

--Ylo1C32i66pBmIvY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6MZAAAoJEHZH4aRLwOS6vDAP/AqObpBj5irErmMOjoUTF4/e
MYtVIfgkUfRlm8NVqaqM/iGLEWBTBsRODKeqbMtjLdOAzre5yM6tP9f1ECEZAF6w
I1Qwt6Kx/GoSitfvB8udB1cA38bqbTeAH23tq4EmP/GQkGgKTRhPAmfJwaPkikkR
Y2gEF9ko3Vqv38M7EJYgLAlzSdJwdP8ozc+xFydnFGSFj7QV4uiSKjAnea7ck5XY
V9YqFWwGixhbKcvDEtOZrfRqR4xm5+jctLDQiMRagERA6kRArS2yXVjAaRw31wfl
iDtAmWOyTUI2NcURfLuEPQdDwYcKSI3oWCZB3Ej/xDUaFokXKqgbyRUDITuCt+sS
jh+ngsCczEWK43DM4ltNuevsWN5wiNeXC1T3j2ymkwoe7x8NKvQBqnXDzYcn7NeW
npl9HAzQ5WX7H1RJ2GULlaBtXsiVuOFl6MsRL9mvxC1tkomcQ3YHv50HPpqtw8kv
FqUkc7DuXj2exGSvxcOo37IKmLZ1mtudHyxB5bBqJkwR/6wCxI0hxA8nXqFpV4Hh
BypWGK7fZMW837XCNaYE1j+tT+6ibfYIGaVTpyHCAUoptYV2vw/HiXTPnDD4/eWz
jyZWsRmO0AnSIrFmxecf/eH3lhQ7ruPGUXQNskweA4d1JOjwUspCuDIgHjd9Evk9
PKWvY36KoFs18XOpof16
=CE3N
-----END PGP SIGNATURE-----

--Ylo1C32i66pBmIvY--
