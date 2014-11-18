Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaKRGLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 01:11:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45125 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815AbaKRGLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 01:11:13 -0500
Date: Tue, 18 Nov 2014 17:11:04 +1100
From: NeilBrown <neilb@suse.de>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>,
        Dongsu Park <dongsu.park@profitbricks.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH - v3?] workqueue: allow rescuer thread to do more work.
Message-ID: <20141118171104.631f4c1f@notabene.brown>
In-Reply-To: <546AE0BC.5020606@cn.fujitsu.com>
References: <20141029172608.39119c80@notabene.brown>
	<20141029143210.GA25226@htj.dyndns.org>
	<20141030101932.2241daa7@notabene.brown>
	<20141104142240.GD14459@htj.dyndns.org>
	<20141106165811.GA2338@gmail.com>
	<545C368C.5040704@cn.fujitsu.com>
	<20141110162848.6f2246bb@notabene.brown>
	<20141110085250.GB15948@quack.suse.cz>
	<20141111090402.35fa0700@notabene.brown>
	<20141118152754.60b0c75e@notabene.brown>
	<546AE0BC.5020606@cn.fujitsu.com>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.24; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/iELrG1J2OJ7rTPd9o3UZ2da"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/iELrG1J2OJ7rTPd9o3UZ2da
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Nov 2014 14:01:32 +0800 Lai Jiangshan <laijs@cn.fujitsu.com> wro=
te:

> On 11/18/2014 12:27 PM, NeilBrown wrote:
> >=20
> > When there is serious memory pressure, all workers in a pool could be
> > blocked, and a new thread cannot be created because it requires memory
> > allocation.
> >=20
> > In this situation a WQ_MEM_RECLAIM workqueue will wake up the
> > rescuer thread to do some work.
> >=20
> > The rescuer will only handle requests that are already on ->worklist.
> > If max_requests is 1, that means it will handle a single request.
> >=20
> > The rescuer will be woken again in 100ms to handle another max_requests
> > requests.
> >=20
> > I've seen a machine (running a 3.0 based "enterprise" kernel) with
> > thousands of requests queued for xfslogd, which has a max_requests of
> > 1, and is needed for retiring all 'xfs' write requests.  When one of
> > the worker pools gets into this state, it progresses extremely slowly
> > and possibly never recovers (only waited an hour or two).
> >=20
> > With this patch we leave a pool_workqueue on mayday list
> > until it is clearly no longer in need of assistance.  This allows
> > all requests to be handled in a timely fashion.
> >=20
> > The code is a bit awkward due to the need to hold both wq_mayday_lock
> > and pool->lock at the same time, and due to the lock ordering imposed
> > on them.  In particular we move work items from the ->worklist to the
> > rescuer list while holding both locks because we need pool->lock
> > to do the move, and need wq_mayday_lock to manipulate the mayday list
> > after we have found out if there was anything to do.
> >=20
> > 'need_to_create_worker()' is called *before* moving work items off
> > pool->worklist as an empty worklist will make it return false, but
> > after the move_linked_works() calls and before the
> > process_scheduled_works() call, an empty worklist does not indicate
> > that there is no work to do.
> >=20
> > We keep each pool_workqueue on the mayday list until
> > need_to_create_worker() is false, and no work for this workqueue is
> > found in the pool.
> >=20
> > As the main rescuer loop now iterates an arbitrary number of time,
> > cond_resched() was inserted to avoid imposing excessive latencies.
> >=20
> > I have tested this in combination with a (hackish) patch which forces
> > all work items to be handled by the rescuer thread.  In that context
> > it significantly improves performance.  A similar patch for a 3.0
> > kernel significantly improved performance on a heavy work load.
> >=20
> > Thanks to Jan Kara for some design ideas, and to Dongsu Park for
> > some comments and testing.
> >=20
> > Cc: Dongsu Park <dongsu.park@profitbricks.com>
> > Cc: Jan Kara <jack@suse.cz>
> > Signed-off-by: NeilBrown <neilb@suse.de>
> >=20
> > diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> > index caedde34ee7f..4baa7b8b7e0f 100644
> > --- a/kernel/workqueue.c
> > +++ b/kernel/workqueue.c
> > @@ -2253,26 +2253,36 @@ repeat:
> >  					struct pool_workqueue, mayday_node);
> >  		struct worker_pool *pool =3D pwq->pool;
> >  		struct work_struct *work, *n;
> > +		int still_needed;
> > =20
> >  		__set_current_state(TASK_RUNNING);
> > -		list_del_init(&pwq->mayday_node);
> > -
> > -		spin_unlock_irq(&wq_mayday_lock);
> > -
> > -		worker_attach_to_pool(rescuer, pool);
> > -
> > -		spin_lock_irq(&pool->lock);
> > -		rescuer->pool =3D pool;
> > -
> > +		spin_lock(&pool->lock);
> >  		/*
> >  		 * Slurp in all works issued via this workqueue and
> >  		 * process'em.
> >  		 */
> >  		WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
>=20
> > +		still_needed =3D need_to_create_worker(pool);
>=20
> This line of code will cause the rescuer busy-loop even no work-item pend=
ing
> on the workqueue.

Thanks for the review...

>=20
> >  		list_for_each_entry_safe(work, n, &pool->worklist, entry)
> >  			if (get_work_pwq(work) =3D=3D pwq)
> >  				move_linked_works(work, scheduled, &n);
> > =20
> > +		if (!list_empty(scheduled))
> > +			still_needed =3D 1;

This should have been

   if (list_empty(scheduled))
        still_needed =3D 0;

which would address your concern.  My original code effectively did that, b=
ut
when I restructured it a little to make it more readable, I broke it :-(

I'll repost tomorrow if there are no further comments.

Thanks.

NeilBrown



> > +		if (still_needed) {
> > +			list_move_tail(&pwq->mayday_node, &wq->maydays);
> > +			get_pwq(pwq);
> > +		} else
> > +			/* We can let go of this one now */
> > +			list_del_init(&pwq->mayday_node);
> > +
> > +		spin_unlock(&pool->lock);
> > +		spin_unlock_irq(&wq_mayday_lock);
> > +
> > +		worker_attach_to_pool(rescuer, pool);
> > +
> > +		spin_lock_irq(&pool->lock);
> > +		rescuer->pool =3D pool;
> >  		process_scheduled_works(rescuer);
> > =20
> >  		/*
> > @@ -2293,7 +2303,7 @@ repeat:
> >  		spin_unlock_irq(&pool->lock);
> > =20
> >  		worker_detach_from_pool(rescuer, pool);
> > -
> > +		cond_resched();
> >  		spin_lock_irq(&wq_mayday_lock);
> >  	}
> > =20


--Sig_/iELrG1J2OJ7rTPd9o3UZ2da
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVGri+Dnsnt1WYoG5AQKr/BAAphIF5oGUI+8NMBNV1q9zQS0KE6kT5Kjj
B9x7NHEUDJO5B4OKJU3arzh62mp2hiPgLFCgxPI3G/oh46KWBFZv4Xn1RKxR29Z6
JRRARM8wZN5F31fNBnafs84fZCu/9Z3DanhpuLqLHuJQVmAdEwXLspxdz28RIyK+
JRThmQp9mSBDHjSpYX8IXEWcpBAqJQiEf7UJQwLA4oOsdWrtMxdWwYTrlO+OCJA5
zkyEC76rooe7YErDC028th+DwsjfspC0uS91jYSseo3re3X27PpdRFaByyuagRnv
J075HoP2BNYP12uPBlC/aAeGrEvbjEq48nJ5Wr3NKb2DngLi2Zqv9METZBPwEEwv
MUr80x9H5GZIKJG/t10HRZ0iCECVlGy9fXlkOlGxuqpZGz7gNL/+EQQgNekfO3sQ
O0kmkQBRShO4M1HoDm66l30td00N6HuzfCAfzrfC0eL/xH+pN98GKY4aPzfkn+y/
w7J2y19P8QA7O8KfBn/dXXwxqxlREhuwYeVIMBc0LpipXTfz69xNzFL8CdrWWasG
4gE09PsitWF6d/yAtRflW7ziN0LKzrPdfcbsvYLfF4zEm3CdGOuSlycbINS8YUxJ
RptGvTsPvfXk3hSqYSdh5icQa8jZ/TSkptIrTWTrgVvTXO1WvyBVuecZoSkUIpul
nEdIEREWUI0=
=jlnS
-----END PGP SIGNATURE-----

--Sig_/iELrG1J2OJ7rTPd9o3UZ2da--
