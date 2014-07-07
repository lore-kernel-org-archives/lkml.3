Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaGGKq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 06:46:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48206 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbaGGKqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 06:46:55 -0400
Date: Mon, 7 Jul 2014 12:46:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com,
        arjan.van.de.ven@intel.com, len.brown@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, pjt@google.com, fengguang.wu@intel.com,
        Ben Segall <bsegall@google.com>
Subject: Re: [PATCH 2/2] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140707104646.GK6758@twins.programming.kicks-ass.net>
References: <1404268256-3019-1-git-send-email-yuyang.du@intel.com>
 <1404268256-3019-2-git-send-email-yuyang.du@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9euHrAHeQETrsHXL"
Content-Disposition: inline
In-Reply-To: <1404268256-3019-2-git-send-email-yuyang.du@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9euHrAHeQETrsHXL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 02, 2014 at 10:30:56AM +0800, Yuyang Du wrote:
> The idea of per entity runnable load average (aggregated to cfs_rq and ta=
sk_group load)
> was proposed by Paul Turner, and it is still followed by this rewrite. Bu=
t this rewrite
> is made due to the following ends:
>=20
> (1). cfs_rq's load average (namely runnable_load_avg and blocked_load_avg=
) is updated
> incrementally by one entity at one time, which means the cfs_rq load aver=
age is only
> partially updated or asynchronous accross its entities (the entity in que=
stion is up
> to date and contributes to the cfs_rq, but all other entities are effecti=
vely lagging
> behind).
>=20
> (2). cfs_rq load average is different between top rq->cfs_rq and task_gro=
up's per CPU
> cfs_rqs in whether or not blocked_load_average contributes to the load.

ISTR there was a reason for it; can't remember though, maybe pjt/ben can
remember.

> (3). How task_group's load is tracked is very confusing and complex.
>=20
> Therefore, this rewrite tackles these by:
>=20
> (1). Combine runnable and blocked load averages for cfs_rq. And track cfs=
_rq's load average
> as a whole (contributed by all runnabled and blocked entities on this cfs=
_rq).
>=20
> (2). Only track task load average. Do not track task_group's per CPU enti=
ty average, but
> track that entity's own cfs_rq's aggregated average.
>=20
> This rewrite resutls in significantly reduced codes and expected consiste=
ncy and clarity.
> Also, if draw the lines of previous cfs_rq runnable_load_avg and blocked_=
load_avg and the
> new rewritten load_avg, then compare those lines, you can see the new loa=
d_avg is much
> more continuous (no abrupt jumping ups and downs) and decayed/updated mor=
e quickly and
> synchronously.

OK, maybe seeing what you're doing. I worry about a fwe things though:

> +static inline void synchronize_tg_load_avg(struct cfs_rq *cfs_rq, u32 ol=
d)
>  {
> +       s32 delta =3D cfs_rq->avg.load_avg - old;
> =20
> +       if (delta)
> +               atomic_long_add(delta, &cfs_rq->tg->load_avg);
>  }

That tg->load_avg cacheline is already red hot glowing, and you've just
increased the amount of updates to it.. That's not going to be pleasant.


> +static inline void enqueue_entity_load_avg(struct sched_entity *se)
>  {
> +	struct sched_avg *sa =3D &se->avg;
> +	struct cfs_rq *cfs_rq =3D cfs_rq_of(se);
> +	u64 now =3D cfs_rq_clock_task(cfs_rq);
> +	u32 old_load_avg =3D cfs_rq->avg.load_avg;
> +	int migrated =3D 0;
> =20
> +	if (entity_is_task(se)) {
> +		if (sa->last_update_time =3D=3D 0) {
> +			sa->last_update_time =3D now;
> +			migrated =3D 1;
>  		}
> +		else
> +			__update_load_avg(now, sa, se->on_rq * se->load.weight);
>  	}
> =20
> +	__update_load_avg(now, &cfs_rq->avg, cfs_rq->load.weight);
> =20
> +	if (migrated)
> +		cfs_rq->avg.load_avg +=3D sa->load_avg;
> =20
> +	synchronize_tg_load_avg(cfs_rq, old_load_avg);
>  }

So here you add the task to the cfs_rq avg when its got migrate in,
however:

> @@ -4552,17 +4326,9 @@ migrate_task_rq_fair(struct task_struct *p, int ne=
xt_cpu)
>  	struct sched_entity *se =3D &p->se;
>  	struct cfs_rq *cfs_rq =3D cfs_rq_of(se);
> =20
> +	/* Update task on old CPU, then ready to go (entity must be off the que=
ue) */
> +	__update_load_avg(cfs_rq_clock_task(cfs_rq), &se->avg, 0);
> +	se->avg.last_update_time =3D 0;
> =20
>  	/* We have migrated, no longer consider this task hot */
>  	se->exec_start =3D 0;

there you don't remove it first..


--9euHrAHeQETrsHXL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTunqVAAoJEHZH4aRLwOS6U+sP/3Ny+BD7zwwKCg7b+YXNKLuj
nvPvUa4TBn3Uq1WDiWreNfOYLc4q1dxIVhKCHY0BYZ8ARSjBaTWyG+pzpWNJ1hgb
EcPwoidzH+7jD9pWsFAYQHacDKn2IJuDH354lWuSHNjsdc/Pr2Lm9yNCQW6I8kct
k34yXZhOAWe5DgM5hOBFKf32kq9GZ8q/2FUG74uqVoCn4nt5G0TCGPgK/GAJxDAi
UZxnWHGYt6/lt3iJE+UQc5naqOu2WL72jOw+5Q41qedpUtrDrMq3Loc92OEbAA3h
MFnH3Z8djbwskfIZWtpCepvZV1RE64OtvudcfQJa+HdWTH8pou9fLpue4vmWWvqx
Zlq59QZy7gU9Oz2HV1hK8dkbTGHoURW8XZ0yzuhI2i+KpkrBHcEDJBpsekNGGAlD
499ol1beFPCUXV8FgrQS7+rQN+rIRKQi210O2RwcZz2cgI/dUbvbGyJircMfxG/W
KFov/4EIxOlsQ20F4Ee7j9FpwrmihFILjwc7nD3FV1cR1VRsDZtearleB4wzem/4
FX81fxKzF+bnhr+kzW+S9rppe2EEyuIAkLuX1Ou4QVWQj66qj78Qwf5kI4FUIKiK
9o86PrciQMyc6UVRE3PWq9O0mDW2bqZz2CSp+cz7CUwqeimMzOJljedzg+T+tEF+
d6NxEm4ZvarX3/2zQwJX
=jaHh
-----END PGP SIGNATURE-----

--9euHrAHeQETrsHXL--
