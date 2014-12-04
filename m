Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaLDBTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 20:19:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43020 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbaLDBTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 20:19:14 -0500
Date: Thu, 4 Dec 2014 12:19:03 +1100
From: NeilBrown <neilb@suse.de>
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH - v3?] workqueue: allow rescuer thread to do more work.
Message-ID: <20141204121903.12be2d23@notabene.brown>
In-Reply-To: <20141203223116.GA17014@gmail.com>
References: <20141106165811.GA2338@gmail.com>
	<545C368C.5040704@cn.fujitsu.com>
	<20141110162848.6f2246bb@notabene.brown>
	<20141110085250.GB15948@quack.suse.cz>
	<20141111090402.35fa0700@notabene.brown>
	<20141118152754.60b0c75e@notabene.brown>
	<20141202204304.GR10918@htj.dyndns.org>
	<20141203114011.5d02dc43@notabene.brown>
	<20141203172010.GC5013@htj.dyndns.org>
	<20141203180241.GD5013@htj.dyndns.org>
	<20141203223116.GA17014@gmail.com>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.25; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/7=M9Ocnul7NOx/ddue1p0UC"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/7=M9Ocnul7NOx/ddue1p0UC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 3 Dec 2014 23:31:16 +0100 Dongsu Park <dongsu.park@profitbricks.com>
wrote:

> Hi Tejun,
>=20
> On 03.12.2014 13:02, Tejun Heo wrote:
> > So, something like the following.  Only compile tested.  I'll test it
> > and post proper patches w/ due credits.
>=20
> I have been already satisfied with Neil's patch,
> but your patch looks indeed a lot cleaner, I like it.
> I just compiled and tested it shortly, which seems to work.
> Though there's one nitpick. (see below)
>=20
> > Thanks.
> >=20
> > Index: work/kernel/workqueue.c
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- work.orig/kernel/workqueue.c
> > +++ work/kernel/workqueue.c
> > @@ -1804,8 +1804,8 @@ static void pool_mayday_timeout(unsigned
> >  	struct worker_pool *pool =3D (void *)__pool;
> >  	struct work_struct *work;
> > =20
> > -	spin_lock_irq(&wq_mayday_lock);		/* for wq->maydays */
> > -	spin_lock(&pool->lock);
> > +	spin_lock_irq(&pool->lock);
> > +	spin_lock(&wq_mayday_lock);		/* for wq->maydays */
> > =20
> >  	if (need_to_create_worker(pool)) {
> >  		/*
> > @@ -1818,8 +1818,8 @@ static void pool_mayday_timeout(unsigned
> >  			send_mayday(work);
> >  	}
> > =20
> > -	spin_unlock(&pool->lock);
> > -	spin_unlock_irq(&wq_mayday_lock);
> > +	spin_unlock(&wq_mayday_lock);
> > +	spin_unlock_irq(&pool->lock);
> > =20
> >  	mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INTERVAL);
> >  }
> > @@ -2248,12 +2248,29 @@ repeat:
> >  		 * Slurp in all works issued via this workqueue and
> >  		 * process'em.
> >  		 */
> > -		WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
> > +		WARN_ON_ONCE(!list_empty(scheduled));
> >  		list_for_each_entry_safe(work, n, &pool->worklist, entry)
> >  			if (get_work_pwq(work) =3D=3D pwq)
> >  				move_linked_works(work, scheduled, &n);
> > =20
> > -		process_scheduled_works(rescuer);
> > +		if (!list_empty(scheduled)) {
> > +			process_scheduled_works(rescuer);
> > +
> > +			/*
> > +			 * The above execution of rescued work items could
> > +			 * have created more to rescue through
> > +			 * pwq_activate_first_delayed() or chained
> > +			 * queueing.  Let's put @pwq back on mayday list so
> > +			 * that such back-to-back work items, which may be
> > +			 * being used to relieve memory pressure, don't
> > +			 * incur MAYDAY_INTERVAL delay inbetween.
> > +			 */
> > +			if (need_to_create_worker(pool)) {
> > +				spin_lock(&wq_mayday_lock);
>=20
> Does it need to call get_pwq(pwq), doesn't it?

Yes, I think it does.

Swapping the order of the locks make it so much nicer, doesn't it!!

Thanks,
NeilBrown


>=20
> Thanks,
> Dongsu
>=20
> > +				list_move_tail(&pwq->mayday_node, &wq->maydays);
> > +				spin_unlock(&wq_mayday_lock);
> > +			}
> > +		}
> > =20
> >  		/*
> >  		 * Put the reference grabbed by send_mayday().  @pool won't
> >=20
> > --=20
> > tejun


--Sig_/7=M9Ocnul7NOx/ddue1p0UC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVH+2hznsnt1WYoG5AQIV5g//fNlEa16pQ1K8uz5WY6UGsrP9A6Bx4piX
045zWBM9nW8uY/0l4gCYow5ieOCxT/AaB94ngEAb9KecJp6v9M1rtYZtPo9c/miH
0L8CbLvCrY3q1E9/HZ5O7RZYL2C66BoE8n856Qrl80+101ZZk2Lww22Rv5++eCMn
E8jfh1BMq2kXu1g34Lz+L8fNaHH+CkDmAx8PVe59+CcA4QpaCJF2c0ybIgTGcjmB
PeGvzBCaUHNywaJOo45vtcKcN8Z0lGPkszAWv30vrUZ2nx2rgrc61qkYAFg8/Rh0
0jd0IBuaFG42ZQLoTPNyFhWnh/HPpwzGAGtDqnaoz8H019txW6SGCviH0Fp462JY
irUn38386He0manqog+17FcvAGGJMbMuErmssHtFFROswTStLISowp7Ig1u98vt9
mV0pCBppacl5FQsqWR7MRGiHC9MOMD6DNQjfbgm3FLSMH68GZsWURhqIqSoescwM
nKQGAlgBavbW0ky+0B8n/7LIxA07Jvdqk/pmGFOcJ5z5lcQo8aK3Om1z3kA8G+14
Ol9VhbS2xCKEJshUrfF8JyKDJxHAN38MstSCenmSXlh9VOf3G8KQvgdgh0J5zuyE
dqJeCxNW0vr6COHyXvmseFlR7biYXf8JSexjdWbgH7KBhwiiOJNtal+Z6VNEsn0Y
6pvc0EAfEw0=
=pMpg
-----END PGP SIGNATURE-----

--Sig_/7=M9Ocnul7NOx/ddue1p0UC--
