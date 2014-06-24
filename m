Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbaFXOig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:38:36 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55232 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbaFXOif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:38:35 -0400
Date: Tue, 24 Jun 2014 16:38:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, chegu_vinod@hp.com, mgorman@suse.de,
        mingo@kernel.org
Subject: Re: [PATCH 8/7] sched,numa: do not let a move increase the imbalance
Message-ID: <20140624143820.GA28774@twins.programming.kicks-ass.net>
References: <1403538095-31256-1-git-send-email-riel@redhat.com>
 <20140623183011.28555a7c@annuminas.surriel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
In-Reply-To: <20140623183011.28555a7c@annuminas.surriel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 23, 2014 at 06:30:11PM -0400, Rik van Riel wrote:
> The HP DL980 system has a different NUMA topology from the 8 node
> system I am testing on, and showed some bad behaviour I have not
> managed to reproduce. This patch makes sure workloads converge.
>=20
> When both a task swap and a task move are possible, do not let the
> task move cause an increase in the load imbalance. Forcing task swaps
> can help untangle workloads that have gotten stuck fighting over the
> same nodes, like this run of "perf bench numa -m -0 -p 1000 -p 16 -t 15":
>=20
> Per-node process memory usage (in MBs)
> 38035 (process 0      2      0      0      1   1000      0      0      0 =
 1003
> 38036 (process 1      2      0      0      1      0   1000      0      0 =
 1003
> 38037 (process 2    230    772      0      1      0      0      0      0 =
 1003
> 38038 (process 3      1      0      0   1003      0      0      0      0 =
 1004
> 38039 (process 4      2      0      0      1      0      0    994      6 =
 1003
> 38040 (process 5      2      0      0      1    994      0      0      6 =
 1003
> 38041 (process 6      2      0   1000      1      0      0      0      0 =
 1003
> 38042 (process 7   1003      0      0      1      0      0      0      0 =
 1004
> 38043 (process 8      2      0      0      1      0   1000      0      0 =
 1003
> 38044 (process 9      2      0      0      1      0      0      0   1000 =
 1003
> 38045 (process 1   1002      0      0      1      0      0      0      0 =
 1003
> 38046 (process 1      3      0    954      1      0      0      0     46 =
 1004
> 38047 (process 1      2   1000      0      1      0      0      0      0 =
 1003
> 38048 (process 1      2      0      0      1      0      0   1000      0 =
 1003
> 38049 (process 1      2      0      0   1001      0      0      0      0 =
 1003
> 38050 (process 1      2    934      0     67      0      0      0      0 =
 1003
>=20
> Allowing task moves to increase the imbalance even slightly causes
> tasks to move towards node 1, and not towards node 7, which prevents
> the workload from converging once the above scenario has been reached.
>=20
> Reported-and-tested-by: Vinod Chegu <chegu_vinod@hp.com>
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
>  kernel/sched/fair.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 4723234..e98d290 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1314,6 +1314,12 @@ static void task_numa_compare(struct task_numa_env=
 *env,
> =20
>  	if (moveimp > imp && moveimp > env->best_imp) {
>  		/*
> +		 * A task swap is possible, do not let a task move
> +		 * increase the imbalance.
> +		 */
> +		int imbalance_pct =3D env->imbalance_pct;
> +		env->imbalance_pct =3D 100;
> +		/*

I would feel so much better if we could say _why_ this is so.


--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTqY1WAAoJEHZH4aRLwOS62MEP/iOK/fQzCh8jTi3yVWfWh79B
DeSRbubXGZ2vKN/thuHcCRazzbQEgHO/oPWKGysRCRG6jHGtvdSB+sgnQ2g7MQWW
aIcdos84CuJLAhVuEMFpwSlFil42rxbRgn3SDRjDakJ8FWZAbke80DYd/FqFc1mo
oraG4nVfgZgQDqDj3nbeFZRrNMOXm9C5LfNqSBNamHhtCYtEoLQfqO0WQV577NKi
RpmzZL5Z50nQsTcfDa9G/CzPZxGsA/oJEMv/uzvp8wuYFVort+VlwN5JPrB1B2It
sQb1uVcz4+dQOdmwQcLdHCS10bDfqc3q9cb/zJbrtnHQXLDQL8C+EI2eC16qz1RC
G9IosvaP7tnnM696mLrZaxBKKSECLIMmhR5NTA++2xeIOdsnYHpMhRem2ri+7WuC
y0JBnle6YlZngy9VAxuAApYZ4s8kZXjya+sMoDV2E65rJ5ymVWoYb6mt2QRPoUCA
dOob9Xyl7tiI5MyMIOaiXx4XzcQtqnAjlGlydYAy6wI4yHuZ2yJg28nt2qpc2HTq
C+nL/7cwkFoUGhq3gJWYHa09LSrjMFPA1BVCaYpfKhTd4Z7SZ420bsiFX9E4UYfM
GdqLONQYwvxe4sHc8eGV9ym1xpEK8Blx+1EKyNaolmX/Rv1tSYRzDM7YfjHKEDOJ
9xSvgcm399g4FdtNyRzS
=wAs8
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
