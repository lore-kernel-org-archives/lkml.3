Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751555AbaKKAhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 19:37:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56243 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbaKKAh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 19:37:29 -0500
Date: Tue, 11 Nov 2014 09:04:02 +1100
From: NeilBrown <neilb@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        Dongsu Park <dongsu.park@profitbricks.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] workqueue: allow rescuer thread to do more work.
Message-ID: <20141111090402.35fa0700@notabene.brown>
In-Reply-To: <20141110085250.GB15948@quack.suse.cz>
References: <20141029172608.39119c80@notabene.brown>
	<20141029143210.GA25226@htj.dyndns.org>
	<20141030101932.2241daa7@notabene.brown>
	<20141104142240.GD14459@htj.dyndns.org>
	<20141106165811.GA2338@gmail.com>
	<545C368C.5040704@cn.fujitsu.com>
	<20141110162848.6f2246bb@notabene.brown>
	<20141110085250.GB15948@quack.suse.cz>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.24; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/SB31ldLPAPOAMu_Q+qL_B6/"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/SB31ldLPAPOAMu_Q+qL_B6/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Nov 2014 09:52:50 +0100 Jan Kara <jack@suse.cz> wrote:

> On Mon 10-11-14 16:28:48, NeilBrown wrote:
> > On Fri, 7 Nov 2014 11:03:40 +0800 Lai Jiangshan <laijs@cn.fujitsu.com> =
wrote:
> > > On 11/07/2014 12:58 AM, Dongsu Park wrote:
> > > > Hi Tejun & Neil,
> > > >=20
> > > > On 04.11.2014 09:22, Tejun Heo wrote:
> > > >> On Thu, Oct 30, 2014 at 10:19:32AM +1100, NeilBrown wrote:
> > > >>>>                           Given that workder depletion is pool-w=
ide
> > > >>>> event, maybe it'd make sense to trigger rescuers immediately whi=
le
> > > >>>> workers are in short supply?  e.g. while there's a manager stuck=
 in
> > > >>>> maybe_create_worker() with the mayday timer already triggered?
> > > >>>
> > > >>> So what if I change "need_more_worker" to "need_to_create_worker"=
 ?
> > > >>> Then it will stop as soon as there in an idle worker thread.
> > > >>> That is the condition that keeps maybe_create_worker() looping.
> > > >>> ??
> > > >>
> > > >> Yeah, that'd be a better condition and can work out.  Can you plea=
se
> > > >> write up a patch to do that and do some synthetic tests excercising
> > > >> the code path?  Also please cc Lai Jiangshan <laijs@cn.fujitsu.com>
> > > >> when posting the patch.
> > > >=20
> > > > This issue looks exactly like what I've encountered occasionally in=
 our test
> > > > setup. (with a custom kernel based on 3.12, MD/raid1, dm-multipath,=
 etc.)
> > > > When a system suffers from high memory pressure, and at the same ti=
me
> > > > underlying devices of RAID arrays are repeatedly removed and re-add=
ed,
> > > > then sometimes the whole system gets locked up on a worker pool's l=
ock.
> > > > So I had to fix our custom MD code to allocate a separate ordered w=
orkqueue
> > > > with WQ_MEM_RECLAIM, apart from md_wq or md_misc_wq.
> > > > Then the lockup seemed to have disappeared.
> > > >=20
> > > > Now that I read the Neil's patch, which looks like an ultimate solu=
tion
> > > > to the problem I have seen. I'm really looking forward to seeing th=
is
> > > > change in mainline.
> > > >=20
> > > > How about the attached patch? Based on the Neil's patch, I replaced
> > > > need_more_worker() with need_to_create_worker() as Tejun suggested.
> > > >=20
> > > > Test is running with this patch, which seems to be working for now.
> > > > But I'm going to observe the test result carefully for a few more d=
ays.
> > > >=20
> > > > Regards,
> > > > Dongsu
> > > >=20
> > > > ----
> > > >>From de9aadd6fb742ea8acce4245a27946d3f233ab7f Mon Sep 17 00:00:00 2=
001
> > > > From: Dongsu Park <dongsu.park@profitbricks.com>
> > > > Date: Wed, 5 Nov 2014 17:28:07 +0100
> > > > Subject: [RFC PATCH] workqueue: allow rescuer thread to do more work
> > > >=20
> > > > Original commit message from NeilBrown <neilb@suse.de>:
> > > > =3D=3D=3D=3D
> > > > When there is serious memory pressure, all workers in a pool could =
be
> > > > blocked, and a new thread cannot be created because it requires mem=
ory
> > > > allocation.
> > > >=20
> > > > In this situation a WQ_MEM_RECLAIM workqueue will wake up the rescu=
er
> > > > thread to do some work.
> > > >=20
> > > > The rescuer will only handle requests that are already on ->worklis=
t.
> > > > If max_requests is 1, that means it will handle a single request.
> > > >=20
> > > > The rescuer will be woken again in 100ms to handle another max_requ=
ests
> > > > requests.
> > >=20
> > >=20
> > > I also observed this problem by review when I was developing
> > > the per-pwq-worklist patchset which has a side-affect that it also na=
turally
> > > fix the problem.
> > >=20
> > > However, it is nothing about correctness and I made promise to Freder=
ic Weisbecker
> > > for working on unbound pool for power-saving, then the per-pwq-workli=
st patchset
> > > is put off. So I have to ack it.
> >=20
> > Thanks!
> > However testing showed that the patch isn't quite right.
> > The test on ->nr_active is not correct.  I was meaning to test "are the=
re
> > any requests that have been activated but not yet serviced", but this t=
est
> > only covers the first half.
> >=20
> > If a queue allows a number of active requests (max_active > 1), and sev=
eral
> > are blocked waiting for something (e.g. more memory), then max_active w=
ill be
> > positive even though there is no useful work for the rescuer thread to =
do -
> > so it will spin.
> >=20
> > Jan Kara and I came up with a different patch which testing has shown is
> > quite successful.  However it makes changes to when mayday_clear_cpu() =
is
> > set, and that isn't relevant in the current kernel.
> >=20
> > I've ported the patch to -mainline, but haven't really tested it proper=
ly
> > (just compile tested so far).
> > That version is below.
> ...
> >=20
> > From: NeilBrown <neilb@suse.de>
> > Subject: workqueue: Make rescuer thread process more works
> >=20
> > Currently workqueue rescuer thread processes at most max_active works f=
rom a
> > workqueue before it goes back to sleep for 100 ms. Especially for workq=
ueues
> > with low max_active this leads to rescuer being very slow and when queu=
ed
> > work is blocking reclaim it leads to machine taking very long time (min=
utes
> > or more) to recover from a situation when new workers cannot be created.
> >=20
> > Fix the problem by going through worklist until either new worker is cr=
eated
> > or all no new works can be found.
> >=20
> > We remove and re-add the pool_workqueue to the mayday list so that each=
 pool_workqueue
> > so that no one pool_workqueue can starve the others.
> >=20
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > Signed-off-by: NeilBrown <neilb@suse.de>
> >=20
> > diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> > index 09b685daee3d..19ecee70e3e9 100644
> > --- a/kernel/workqueue.c
> > +++ b/kernel/workqueue.c
> > @@ -2253,6 +2253,10 @@ repeat:
> >  			if (get_work_pwq(work) =3D=3D pwq)
> >  				move_linked_works(work, scheduled, &n);
> > =20
> > +		if (!list_empty(scheduled) && need_to_create_worker(pool))
> > +			/* Try again, in case more requests get added */
> > +			if (list_empty(&pwq->mayday_node))
> > +				list_add_tail(&pwq->mayday_node, &wq->maydays);
> >  		process_scheduled_works(rescuer);
>   This is certainly missing locking - we need to hold wq_mayday_lock when
> changing wq->maydays list. Otherwise the patch looks good to me.
>=20
> 								Honza


Thanks... I can't just take wq_mayday_lock to cover that code as we already
have pool->lock and they nest the other way.

What do people think of this approach?

We hold onto wq_mayday_lock a bit longer, until we know if there is  really
any work to do.
The bit I'm least sure of is moving worker_attach_to_pool() after
"rescuer->pool =3D pool".  Might that be a problem?

Thanks,
NeilBrown



diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 09b685daee3d..f2db6073c498 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2235,11 +2235,6 @@ repeat:
 		struct work_struct *work, *n;
=20
 		__set_current_state(TASK_RUNNING);
-		list_del_init(&pwq->mayday_node);
-
-		spin_unlock_irq(&wq_mayday_lock);
-
-		worker_attach_to_pool(rescuer, pool);
=20
 		spin_lock_irq(&pool->lock);
 		rescuer->pool =3D pool;
@@ -2253,8 +2248,16 @@ repeat:
 			if (get_work_pwq(work) =3D=3D pwq)
 				move_linked_works(work, scheduled, &n);
=20
-		process_scheduled_works(rescuer);
+		if (list_empty(scheduled) || !need_to_create_worker(pool))
+			/* We can let go of this one  now */
+			list_del_init(&pwq->mayday_node);
+		spin_unlock_irq(&wq_mayday_lock);
+
+		if (!list_empty(scheduled)) {
+			worker_attach_to_pool(rescuer, pool);
=20
+			process_scheduled_works(rescuer);
+		}
 		/*
 		 * Put the reference grabbed by send_mayday().  @pool won't
 		 * go away while we're still attached to it.

--Sig_/SB31ldLPAPOAMu_Q+qL_B6/
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVGE2Ujnsnt1WYoG5AQLqbA//U3kY4QgWEjsY1Qq3i+auxkfFk1Zq/M2d
IjeyzsfjpAKDtFBSYFz1X6DJ3V+FYAli1XmGHrsRu5Ch/uqfpMrTAKuDywtm79Pq
axKW6nQ5WYvordjJaGxEYtwMvqVWzKgOSlwSyJBVSfQP1el+PYqtKau72Gjrwkbo
WDolpMFkQNFbXLXSyhE3rgvoI1+W8XCLg3+9r3+gkvMoK5YYijK7eIiIA3arODmo
1fsK5nQP5OgLsXC9+W836bB9QDqbsLKBphozNvB4xA/1taBbN+6TS1BEzttVcm4O
pIcGYpmQE3xV0lgq+cFSJSmOSNtqIBHCAG6ZUB1hBzYUPsWw2s6Qb6w14jFljfVq
kY9BtJacmH5n9mNMZ2IzKuopCMWlnmjv2bLDWIzRM6BieJButFFeMtVHaxbVgBXd
TkUQZbxQrqPafV17PKyZWGTbXW/uD4BWC8Dn6SsqGr53WCqxO2/j3VkgProRtc67
x1XJW2gEDZBBSTvcDSlm70LVR06LiVDwfmsgzj4VWE3e0yOcfGX0RD3Ox+AFds1d
rEPh42ln4Gal8t3yCffziWdp1XBkfPkKRzIPwlkr8RKsU/l6EDdTVIupZanX/YkR
aEOczEmXb4u5E5ZE+YK9WP0PMC941xAG6PjjvI54V8+RRQpMVF23BQ4O0WwVDfEx
1pMoeyiXvmg=
=yTwk
-----END PGP SIGNATURE-----

--Sig_/SB31ldLPAPOAMu_Q+qL_B6/--
