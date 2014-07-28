Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaG1Ljy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 07:39:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:58500 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbaG1Ljv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 07:39:51 -0400
Date: Mon, 28 Jul 2014 13:39:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, pjt@google.com,
        bsegall@google.com, arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com
Subject: Re: [PATCH 2/2 v4] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140728113939.GR6758@twins.programming.kicks-ass.net>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <1405639567-21445-3-git-send-email-yuyang.du@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5ZcJx+9xjQukQz+j"
Content-Disposition: inline
In-Reply-To: <1405639567-21445-3-git-send-email-yuyang.du@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5ZcJx+9xjQukQz+j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2014 at 07:26:06AM +0800, Yuyang Du wrote:

> -static inline void __update_tg_runnable_avg(struct sched_avg *sa,
> -						  struct cfs_rq *cfs_rq)
> -{
> -	struct task_group *tg =3D cfs_rq->tg;
> -	long contrib;
> -
> -	/* The fraction of a cpu used by this cfs_rq */
> -	contrib =3D div_u64((u64)sa->runnable_avg_sum << NICE_0_SHIFT,
> -			  sa->runnable_avg_period + 1);
> -	contrib -=3D cfs_rq->tg_runnable_contrib;
> -
> -	if (abs(contrib) > cfs_rq->tg_runnable_contrib / 64) {
> -		atomic_add(contrib, &tg->runnable_avg);
> -		cfs_rq->tg_runnable_contrib +=3D contrib;
> -	}
> -}


> -static inline void __update_group_entity_contrib(struct sched_entity *se)
> +static inline void update_tg_load_avg(struct cfs_rq *cfs_rq)
>  {
> +	long delta =3D cfs_rq->avg.load_avg - cfs_rq->tg_load_avg_contrib;
> =20
> +	if (delta) {
> +		atomic_long_add(delta, &cfs_rq->tg->load_avg);
> +		cfs_rq->tg_load_avg_contrib =3D cfs_rq->avg.load_avg;
>  	}
>  }

We talked about this before, you made that an unconditional atomic op on
an already hot line.

You need some words on why this isn't a problem. Either in a comment or
in the Changelog. You cannot leave such changes undocumented.

> +#define subtract_until_zero(minuend, subtrahend)	\
> +	(subtrahend < minuend ? minuend - subtrahend : 0)

WTH is a minuend or subtrahend? Are you a wordsmith in your spare time
and like to make up your own words?

Also, isn't writing: x =3D max(0, x-y), far more readable to begin with?

> +/*
> + * Group cfs_rq's load_avg is used for task_h_load and update_cfs_share
> + * calc.
> + */
> +static inline int update_cfs_rq_load_avg(u64 now, struct cfs_rq *cfs_rq)
>  {
> +	int decayed;
> =20
> +	if (atomic_long_read(&cfs_rq->removed_load_avg)) {
> +		long r =3D atomic_long_xchg(&cfs_rq->removed_load_avg, 0);
> +		cfs_rq->avg.load_avg =3D subtract_until_zero(cfs_rq->avg.load_avg, r);
> +		r *=3D LOAD_AVG_MAX;
> +		cfs_rq->avg.load_sum =3D subtract_until_zero(cfs_rq->avg.load_sum, r);
>  	}
> =20
> +	decayed =3D __update_load_avg(now, &cfs_rq->avg, cfs_rq->load.weight);
> =20
> +#ifndef CONFIG_64BIT
> +	if (cfs_rq->avg.last_update_time !=3D cfs_rq->load_last_update_time_cop=
y) {
> +		smp_wmb();
> +		cfs_rq->load_last_update_time_copy =3D cfs_rq->avg.last_update_time;
> +	}
> +#endif
> =20
> +	return decayed;
> +}

Its a bit unfortunate that we update the copy in another function than
the original, but I think I see why you did that. But is it at all
likely that we do not need to update? That is, does that compare make
any sense?



--5ZcJx+9xjQukQz+j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT1jZ7AAoJEHZH4aRLwOS6Bz4P+wfdn3iXIsd0uEXjwcoUAhB2
O+9jj0RYLPnwUaCJD3wEO4KxQIeNoAiqlxmgaQ58CRKuJFWplT1N+Zf5BnS83VTG
aQ5+1b4vT9qej/EpTEZAEPvGxjzueSnZlB2CkK73H4zK4ylkvBdGXt+QGCOvYToF
/+FKeXJjlbn9+RptHYoxma7KI1kovyhYXcx8xIbRbnjD+igNEFDgJHD3PX6D0pwr
pWr31Aa0Wtb1xLogXEmyKub/bzlu1vX/nB0dDxSYn1V1/UVeF73KRC93FgASiZMi
Bjcb0WkIoGp3UXl5wcuzJBs4s7DeF/UKQvvaoHfIoTfze1vfZ3jKnQch7/+qlabs
eJp95OLXv8F931XqLLpz9BPS2OwzOU4yaNYG0ULmSdo6DEsAJaZvTHh8mdasjdaK
AP6EcztPnnFREqyoewrQbGnY2y0cgArw5XD6B0gERM58LhgGtIzo13+WB1NFF+0+
uKE270QVipHEKXuciVMoi70gs4OzARlSOqBK+IX5ub1UvpUfkTzSXm8/ertUd5/T
mljoVYkxmVjj6Zme9seWnc/a5ZKhhKmIVp6v2iAI8oVxzmjDpMaMBWb/JfnLnq0S
UT1Kz4DJISkv+9vMbQ8BEe/8uq+qU6F5Fi3vCmX+cb+Zl6xOP/Nf4hFo5H79MJbG
qEe9vlryjpwasE1GPAJi
=0Epk
-----END PGP SIGNATURE-----

--5ZcJx+9xjQukQz+j--
