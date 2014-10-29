Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbaJ2XTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 19:19:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756704AbaJ2XTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 19:19:41 -0400
Date: Thu, 30 Oct 2014 10:19:32 +1100
From: NeilBrown <neilb@suse.de>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] workqueue: allow rescuer thread to do more work.
Message-ID: <20141030101932.2241daa7@notabene.brown>
In-Reply-To: <20141029143210.GA25226@htj.dyndns.org>
References: <20141029172608.39119c80@notabene.brown>
	<20141029143210.GA25226@htj.dyndns.org>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.23; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/2HMPrbs=0um3oTCYCqdwsaf"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/2HMPrbs=0um3oTCYCqdwsaf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Oct 2014 10:32:10 -0400 Tejun Heo <tj@kernel.org> wrote:

> Hello, Neil.
>=20
> On Wed, Oct 29, 2014 at 05:26:08PM +1100, NeilBrown wrote:
> > Hi Tejun,
> >   I haven't tested this patch yet so this really is an 'RFC'.
> > In general ->nr_active should only be accessed under the pool->lock,
> > but a miss-read here will at most cause a very occasional 100ms delay so
> > shouldn't be a big problem.  The only thread likely to change ->nr_acti=
ve is
> > this thread, so such a delay would be extremely unlikely.
> >=20
> > Thanks,
> > NeilBrown
> >=20
> >=20
> > diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> > index 09b685daee3d..d0a8b101c5d9 100644
> > --- a/kernel/workqueue.c
> > +++ b/kernel/workqueue.c
> > @@ -2244,16 +2244,18 @@ repeat:
> >  		spin_lock_irq(&pool->lock);
> >  		rescuer->pool =3D pool;
> > =20
> > -		/*
> > -		 * Slurp in all works issued via this workqueue and
> > -		 * process'em.
> > -		 */
> > -		WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
> > -		list_for_each_entry_safe(work, n, &pool->worklist, entry)
> > -			if (get_work_pwq(work) =3D=3D pwq)
> > -				move_linked_works(work, scheduled, &n);
> > +		do {
> > +			/*
> > +			 * Slurp in all works issued via this workqueue and
> > +			 * process'em.
> > +			 */
> > +			WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
> > +			list_for_each_entry_safe(work, n, &pool->worklist, entry)
> > +				if (get_work_pwq(work) =3D=3D pwq)
> > +					move_linked_works(work, scheduled, &n);
> > =20
> > -		process_scheduled_works(rescuer);
> > +			process_scheduled_works(rescuer);
> > +		} while (need_more_worker(pool) && pwq->nr_active);
>=20
> need_more_worker(pool) is always true for unbound pools as long as
> there are work items queued, so the above condition may stay true
> longer than it needs to.

Because ->nr_running isn't maintained for WORKER_UNBOUND (which is part of
WORKER_NOT_RUNNING) - got it.

>                           Given that workder depletion is pool-wide
> event, maybe it'd make sense to trigger rescuers immediately while
> workers are in short supply?  e.g. while there's a manager stuck in
> maybe_create_worker() with the mayday timer already triggered?

So what if I change "need_more_worker" to "need_to_create_worker" ?
Then it will stop as soon as there in an idle worker thread.
That is the condition that keeps maybe_create_worker() looping.
??

Thanks,
NeilBrown


--Sig_/2HMPrbs=0um3oTCYCqdwsaf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVFF2BDnsnt1WYoG5AQIVJRAAkQG0Lfp0xE9lNK7d5ztX57+1Y2ONKete
HIIQh1OCBlYmmZ2g/ZuhOB/LJ++3uNrTBJRk/6ofisoqptRIRSEVQefT47jSr5/m
LELNCq8pnEDNWevz8xttWwP4GaRfGMfs0m5C3daaUXiXoY0d9QUsUlN5U7JeNIHq
hDpSjDYV86qDaEivHL0fAnWjVZ+LC6qml1gBLSuD4xQwVSj+QEquboqKbZjL/b2Q
EvFFFlu60b4AprqVEigMDxohbf5R3F05PtTOLvkeSBMezOynpyHRYKAUpDPpLIfk
2X35AEJNvk+Fg5oU5sjzXDtCVmdTAZeDMZ7VJca5+CvcLQzjLSKxP7BKNZ41NNP9
pbA+wYjp5sWOVoz83W18LCg8IVhhTbnnqWr7DNC79KaO93n6rQMJWEfk799638On
O+aY6sNJWD+ItrbqYkxlUtokDSNvhYjMpnJ2G5ukXr8BesXeCUc7ZeGGiP6qnirE
3AuyXMetCkLJDFk34rhlK/wYMsBmcrLHiSU5+j3fFFReiRfZjGU9PWKSg31AkLCs
mT/ERuyH2qQJQ3zFhK6mGovfcHZSRPXY4c5fhDlV8l4YRnfEBFlBFwFe38KSlAt8
u2ZFfg1ozgrYCuxSqlNW4K/U+W666ISszYgM9d7DMkUzQb//3isZd6FkQ7o2ekgb
s9ACxMyNd+Y=
=Yb3P
-----END PGP SIGNATURE-----

--Sig_/2HMPrbs=0um3oTCYCqdwsaf--
