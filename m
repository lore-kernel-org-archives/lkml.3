Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750989AbaG1RTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:19:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:60038 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaG1RTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:19:22 -0400
Date: Mon, 28 Jul 2014 19:19:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: bsegall@google.com
Cc: Yuyang Du <yuyang.du@intel.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, pjt@google.com,
        arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com
Subject: Re: [PATCH 2/2 v4] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140728171909.GW19379@twins.programming.kicks-ass.net>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <1405639567-21445-3-git-send-email-yuyang.du@intel.com>
 <20140728135122.GT6758@twins.programming.kicks-ass.net>
 <xm26lhrdv2s4.fsf@sword-of-the-dawn.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6jqOEDnk/BOVe7Zw"
Content-Disposition: inline
In-Reply-To: <xm26lhrdv2s4.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6jqOEDnk/BOVe7Zw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2014 at 09:58:19AM -0700, bsegall@google.com wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
>=20
> >> @@ -4551,18 +4382,34 @@ migrate_task_rq_fair(struct task_struct *p, in=
t next_cpu)
> >>  {
> >>  	struct sched_entity *se =3D &p->se;
> >>  	struct cfs_rq *cfs_rq =3D cfs_rq_of(se);
> >> +	u64 last_update_time;
> >> =20
> >>  	/*
> >> +	 * Task on old CPU catches up with its old cfs_rq, and subtract itse=
lf from
> >> +	 * the cfs_rq (task must be off the queue now).
> >>  	 */
> >> +#ifndef CONFIG_64BIT
> >> +	u64 last_update_time_copy;
> >> +
> >> +	do {
> >> +		last_update_time_copy =3D cfs_rq->load_last_update_time_copy;
> >> +		smp_rmb();
> >> +		last_update_time =3D cfs_rq->avg.last_update_time;
> >> +	} while (last_update_time !=3D last_update_time_copy);
> >> +#else
> >> +	last_update_time =3D cfs_rq->avg.last_update_time;
> >> +#endif
> >> +	__update_load_avg(last_update_time, &se->avg, 0);
> >> +	atomic_long_add(se->avg.load_avg, &cfs_rq->removed_load_avg);
> >> +
> >> +	/*
> >> +	 * We are supposed to update the task to "current" time, then its up=
 to date
> >> +	 * and ready to go to new CPU/cfs_rq. But we have difficulty in gett=
ing
> >> +	 * what current time is, so simply throw away the out-of-date time. =
This
> >> +	 * will result in the wakee task is less decayed, but giving the wak=
ee more
> >> +	 * load sounds not bad.
> >> +	 */
> >> +	se->avg.last_update_time =3D 0;
> >> =20
> >>  	/* We have migrated, no longer consider this task hot */
> >>  	se->exec_start =3D 0;
> >
> >
> > And here we try and make good on that assumption. The thing I worry
> > about is what happens if the machine is entirely idle...
> >
> > What guarantees an semi up-to-date cfs_rq->avg.last_update_time.
>=20
> update_blocked_averages I think should do just as good a job as the old
> code, which isn't perfect but is about as good as you can get worst case.

Right, that's called from rebalance_domains() which should more or less
update this value on tick boundaries or thereabouts for most 'active'
cpus.

But if the entire machine is idle, the first wakeup (if its a x-cpu one)
might see a very stale timestamp.

If we can fix that, that would be good I suppose, but I'm not
immediately seeing something pretty there, but you're right, it'd not be
worse than the current situation.

--6jqOEDnk/BOVe7Zw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT1oYNAAoJEHZH4aRLwOS6ZYIP/19HJwxrtU+wEyJ9utde0/GT
d//XvG6EXfQbG8OZE64GgWiT+Svc3KOu51v910PmR7tyz196fsHUkG6eEtdZ7gxz
Uwp8DJCvShWduOK2ttCuucmhLmee2F31XJwMvnE6kLZZy3bNTaYUfjx6zJGjEVvk
snrnJdaDSuYBuzmsk9imk1avQNr8lJO9c5QTKl6cBn2LC1+XInSbSatw+GRgJR7A
kVbh8bUknABQ9u6Hod3ncJXVCo0RqnOBzq1cQnS8qlnad6YJ0C9xcIABtNU73jHH
jD+BaRpaTxLpztpfB1ukSY/U1EXc8uWE/COuyNqQ//igmLffEbjKD9+mYjPKSPKf
U6NrdehO8jZao68NhaEawJW7k5zzrC7QGKcOIarc9f/1fWXn5L/+0YhlwvCD8Mek
G+bwhKQCyoD1hME+7zVA58koJkj8jaeLlvR2pxFT2R38xvzGVDXUv800qQWmmsa9
YMxL1uG8tVTL+ZyIDadE3B+6GX7F2QwV0p0IvTbAzfoGxnGQ8o9FwKshmqw1XdJJ
+hxXp0pceLZbogQiXThJtMeGgJzr00KetXMFQKVT7h+GTk5fiD7471dnRNXWB6MR
HNspdq2jSK6N2Tyi8uSJMYMbquPlT3MxwKLPq7s2qSXR2peKeK3MMIoSw9Az+JCq
y1Ri6FjlMnzachnJSrYy
=qdv6
-----END PGP SIGNATURE-----

--6jqOEDnk/BOVe7Zw--
