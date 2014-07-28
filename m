Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832AbaG1Nvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:51:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:59132 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbaG1Nvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:51:35 -0400
Date: Mon, 28 Jul 2014 15:51:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, pjt@google.com,
        bsegall@google.com, arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com
Subject: Re: [PATCH 2/2 v4] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140728135122.GT6758@twins.programming.kicks-ass.net>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <1405639567-21445-3-git-send-email-yuyang.du@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJpN0D5W9Nffl1c7"
Content-Disposition: inline
In-Reply-To: <1405639567-21445-3-git-send-email-yuyang.du@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eJpN0D5W9Nffl1c7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



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

So on every cfs_rq update we first process the 'pending' removals, then
decay and then store the current timestamp.

> +static inline void enqueue_entity_load_avg(struct sched_entity *se)
>  {
> +	struct sched_avg *sa =3D &se->avg;
> +	struct cfs_rq *cfs_rq =3D cfs_rq_of(se);
> +	u64 now =3D cfs_rq_clock_task(cfs_rq);
> +	int migrated =3D 0, decayed;
> =20
> +	if (sa->last_update_time =3D=3D 0) {
> +		sa->last_update_time =3D now;
> =20
> +		if (entity_is_task(se))
> +			migrated =3D 1;
>  	}
> +	else
> +		__update_load_avg(now, sa, se->on_rq * se->load.weight);
> =20
> +	decayed =3D update_cfs_rq_load_avg(now, cfs_rq);
> =20
> +	if (migrated) {
> +		cfs_rq->avg.load_avg +=3D sa->load_avg;
> +		cfs_rq->avg.load_sum +=3D sa->load_sum;
>  	}
> =20
> +	if (decayed || migrated)
> +		update_tg_load_avg(cfs_rq);
>  }

On enqueue we add ourselves to the cfs_rq.. and assume the entity is
'current' wrt updates since we did that when we just pulled it from the
old rq.

> @@ -4551,18 +4382,34 @@ migrate_task_rq_fair(struct task_struct *p, int n=
ext_cpu)
>  {
>  	struct sched_entity *se =3D &p->se;
>  	struct cfs_rq *cfs_rq =3D cfs_rq_of(se);
> +	u64 last_update_time;
> =20
>  	/*
> +	 * Task on old CPU catches up with its old cfs_rq, and subtract itself =
=66rom
> +	 * the cfs_rq (task must be off the queue now).
>  	 */
> +#ifndef CONFIG_64BIT
> +	u64 last_update_time_copy;
> +
> +	do {
> +		last_update_time_copy =3D cfs_rq->load_last_update_time_copy;
> +		smp_rmb();
> +		last_update_time =3D cfs_rq->avg.last_update_time;
> +	} while (last_update_time !=3D last_update_time_copy);
> +#else
> +	last_update_time =3D cfs_rq->avg.last_update_time;
> +#endif
> +	__update_load_avg(last_update_time, &se->avg, 0);
> +	atomic_long_add(se->avg.load_avg, &cfs_rq->removed_load_avg);
> +
> +	/*
> +	 * We are supposed to update the task to "current" time, then its up to=
 date
> +	 * and ready to go to new CPU/cfs_rq. But we have difficulty in getting
> +	 * what current time is, so simply throw away the out-of-date time. This
> +	 * will result in the wakee task is less decayed, but giving the wakee =
more
> +	 * load sounds not bad.
> +	 */
> +	se->avg.last_update_time =3D 0;
> =20
>  	/* We have migrated, no longer consider this task hot */
>  	se->exec_start =3D 0;


And here we try and make good on that assumption. The thing I worry
about is what happens if the machine is entirely idle...

What guarantees an semi up-to-date cfs_rq->avg.last_update_time.

--eJpN0D5W9Nffl1c7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT1lVaAAoJEHZH4aRLwOS6QDoP/jGqZpOE3PoRpZeMFPdeA5f+
TexXXB7kEegtUXIDW08fjGdML9MQyQxl4hv+sDx2o7Oo32sh2aRoiMIIj11/ouq8
mQLgPzezjUe0SFoqiVoISIAQwboZTOAu64BLwKqfNGbzQip14XT7UsI440IjRLdo
qHPJ04o1LNjimWePsbA17zZuTJSGwuaNgBYP1Dft8CysvCFFEH7ZyXir7ugaJLlU
48e9M67JdSEGMgEFtfJ4x5AX6A4/aRRUTKUnvSheDVhtE8hw89ibeFf6+i4JpAh5
N01GNoZgJ9WhCi/zQ+SF7DE5JV9Y39CHfZ8H8wDrHvxJsRX1gHKIBHLyT0XDvxxK
lOxBtf94kX+n13dk9PGCNHvQpPozW4U9aKAG4JHG3vGTDzwgBcE2bB4L2is9jBrB
h42EvZcW63UjId7wt0PsP+cMPOZ7VBgo5r5/gfuoLepsLOVomB827eZEjIwfVeDn
DDYTOTTL5TK1G1c04TG9l9EVzcmqmDR8k4bvMaUif9VwUUvBJzH/SFXJHbo7XNr+
zNiSPzxVtcDIwcj+WHF951oT2rGbtlzGc1lWfCzJ+5YDB4eY+AyemIkbRmveosCF
kU26PgsJYSp54Z5VJD638V47ksKFvcXHsnHLEmXogkry0T51WwRytj4vvGL8Qrl3
KSjqA/5sEmKyLyqOjO1G
=EGiV
-----END PGP SIGNATURE-----

--eJpN0D5W9Nffl1c7--
