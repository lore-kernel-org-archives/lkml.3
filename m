Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751018AbaKJF27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 00:28:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58247 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbaKJF26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 00:28:58 -0500
Date: Mon, 10 Nov 2014 16:28:48 +1100
From: NeilBrown <neilb@suse.de>
To: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Cc: Dongsu Park <dongsu.park@profitbricks.com>, <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH/RFC] workqueue: allow rescuer thread to do more work.
Message-ID: <20141110162848.6f2246bb@notabene.brown>
In-Reply-To: <545C368C.5040704@cn.fujitsu.com>
References: <20141029172608.39119c80@notabene.brown>
	<20141029143210.GA25226@htj.dyndns.org>
	<20141030101932.2241daa7@notabene.brown>
	<20141104142240.GD14459@htj.dyndns.org>
	<20141106165811.GA2338@gmail.com>
	<545C368C.5040704@cn.fujitsu.com>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.24; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/q.hA888dTM6=aQFh2lThGSq"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/q.hA888dTM6=aQFh2lThGSq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 7 Nov 2014 11:03:40 +0800 Lai Jiangshan <laijs@cn.fujitsu.com> wrot=
e:

>=20
>=20
> On 11/07/2014 12:58 AM, Dongsu Park wrote:
> > Hi Tejun & Neil,
> >=20
> > On 04.11.2014 09:22, Tejun Heo wrote:
> >> On Thu, Oct 30, 2014 at 10:19:32AM +1100, NeilBrown wrote:
> >>>>                           Given that workder depletion is pool-wide
> >>>> event, maybe it'd make sense to trigger rescuers immediately while
> >>>> workers are in short supply?  e.g. while there's a manager stuck in
> >>>> maybe_create_worker() with the mayday timer already triggered?
> >>>
> >>> So what if I change "need_more_worker" to "need_to_create_worker" ?
> >>> Then it will stop as soon as there in an idle worker thread.
> >>> That is the condition that keeps maybe_create_worker() looping.
> >>> ??
> >>
> >> Yeah, that'd be a better condition and can work out.  Can you please
> >> write up a patch to do that and do some synthetic tests excercising
> >> the code path?  Also please cc Lai Jiangshan <laijs@cn.fujitsu.com>
> >> when posting the patch.
> >=20
> > This issue looks exactly like what I've encountered occasionally in our=
 test
> > setup. (with a custom kernel based on 3.12, MD/raid1, dm-multipath, etc=
.)
> > When a system suffers from high memory pressure, and at the same time
> > underlying devices of RAID arrays are repeatedly removed and re-added,
> > then sometimes the whole system gets locked up on a worker pool's lock.
> > So I had to fix our custom MD code to allocate a separate ordered workq=
ueue
> > with WQ_MEM_RECLAIM, apart from md_wq or md_misc_wq.
> > Then the lockup seemed to have disappeared.
> >=20
> > Now that I read the Neil's patch, which looks like an ultimate solution
> > to the problem I have seen. I'm really looking forward to seeing this
> > change in mainline.
> >=20
> > How about the attached patch? Based on the Neil's patch, I replaced
> > need_more_worker() with need_to_create_worker() as Tejun suggested.
> >=20
> > Test is running with this patch, which seems to be working for now.
> > But I'm going to observe the test result carefully for a few more days.
> >=20
> > Regards,
> > Dongsu
> >=20
> > ----
> >>From de9aadd6fb742ea8acce4245a27946d3f233ab7f Mon Sep 17 00:00:00 2001
> > From: Dongsu Park <dongsu.park@profitbricks.com>
> > Date: Wed, 5 Nov 2014 17:28:07 +0100
> > Subject: [RFC PATCH] workqueue: allow rescuer thread to do more work
> >=20
> > Original commit message from NeilBrown <neilb@suse.de>:
> > =3D=3D=3D=3D
> > When there is serious memory pressure, all workers in a pool could be
> > blocked, and a new thread cannot be created because it requires memory
> > allocation.
> >=20
> > In this situation a WQ_MEM_RECLAIM workqueue will wake up the rescuer
> > thread to do some work.
> >=20
> > The rescuer will only handle requests that are already on ->worklist.
> > If max_requests is 1, that means it will handle a single request.
> >=20
> > The rescuer will be woken again in 100ms to handle another max_requests
> > requests.
>=20
>=20
> I also observed this problem by review when I was developing
> the per-pwq-worklist patchset which has a side-affect that it also natura=
lly
> fix the problem.
>=20
> However, it is nothing about correctness and I made promise to Frederic W=
eisbecker
> for working on unbound pool for power-saving, then the per-pwq-worklist p=
atchset
> is put off. So I have to ack it.

Thanks!
However testing showed that the patch isn't quite right.
The test on ->nr_active is not correct.  I was meaning to test "are there
any requests that have been activated but not yet serviced", but this test
only covers the first half.

If a queue allows a number of active requests (max_active > 1), and several
are blocked waiting for something (e.g. more memory), then max_active will =
be
positive even though there is no useful work for the rescuer thread to do -
so it will spin.

Jan Kara and I came up with a different patch which testing has shown is
quite successful.  However it makes changes to when mayday_clear_cpu() is
set, and that isn't relevant in the current kernel.

I've ported the patch to -mainline, but haven't really tested it properly
(just compile tested so far).
That version is below.

thanks,
NeilBrown


>=20
> >=20
> > I've seen a machine (running a 3.0 based "enterprise" kernel) with
> > thousands of requests queued for xfslogd, which has a max_requests of 1,
> > and is needed for retiring all 'xfs' write requests.  When one of the
> > worker pools gets into this state, it progresses extremely slowly and
> > possibly never recovers (only waited an hour or two).
> >=20
> > So if, after handling everything on worklist, there is again something
> > on worklist (counted in nr_active), and if the queue is still congested,
> > keep processing instead of waiting for the next wake-up.
> > =3D=3D=3D=3D
> >=20
> > Dongsu Park: replaced need_more_worker() with need_to_create_worker(),
> > as suggested by Tejun.
> >=20
> > Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
> > Link: https://lkml.org/lkml/2014/10/29/55
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Original-by: NeilBrown <neilb@suse.de>
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > ---
> >  kernel/workqueue.c | 23 +++++++++++++----------
> >  1 file changed, 13 insertions(+), 10 deletions(-)
> >=20
> > diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> > index 09b685d..4d20225 100644
> > --- a/kernel/workqueue.c
> > +++ b/kernel/workqueue.c
> > @@ -2244,16 +2244,19 @@ repeat:
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
> > -
> > -		process_scheduled_works(rescuer);
> > +		do {
> > +			/*
> > +			 * Slurp in all works issued via this workqueue and
> > +			 * process'em.
> > +			 */
> > +			WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
> > +			list_for_each_entry_safe(work, n, &pool->worklist,
> > +					entry)
> > +				if (get_work_pwq(work) =3D=3D pwq)
> > +					move_linked_works(work, scheduled, &n);
> > +
> > +			process_scheduled_works(rescuer);
> > +		} while (need_to_create_worker(pool) && pwq->nr_active);
> > =20
> >  		/*
> >  		 * Put the reference grabbed by send_mayday().  @pool won't


From: NeilBrown <neilb@suse.de>
Subject: workqueue: Make rescuer thread process more works

Currently workqueue rescuer thread processes at most max_active works from a
workqueue before it goes back to sleep for 100 ms. Especially for workqueues
with low max_active this leads to rescuer being very slow and when queued
work is blocking reclaim it leads to machine taking very long time (minutes
or more) to recover from a situation when new workers cannot be created.

Fix the problem by going through worklist until either new worker is created
or all no new works can be found.

We remove and re-add the pool_workqueue to the mayday list so that each poo=
l_workqueue
so that no one pool_workqueue can starve the others.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 09b685daee3d..19ecee70e3e9 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2253,6 +2253,10 @@ repeat:
 			if (get_work_pwq(work) =3D=3D pwq)
 				move_linked_works(work, scheduled, &n);
=20
+		if (!list_empty(scheduled) && need_to_create_worker(pool))
+			/* Try again, in case more requests get added */
+			if (list_empty(&pwq->mayday_node))
+				list_add_tail(&pwq->mayday_node, &wq->maydays);
 		process_scheduled_works(rescuer);
=20
 		/*

--Sig_/q.hA888dTM6=aQFh2lThGSq
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVGBNEDnsnt1WYoG5AQJJZQ//dWl/Ba2hhaWWG8+8Uc78W5gB1m7HNAr3
kMaAsO30YpPhCmhmQsJWHLWckx8QXI93F7/ae3/FkcqmvvvXBF5QKGx5Nr4SHCW9
wLlStn/45q5B/WyJO8qNgYoBzusolk7VAnuK7Ib8InnJA807knzVDZbP4LJV4aSB
MVkmLWO9PCHmMNraSdnA13oLLHTdYjeAYIhVV3V4kG2DxBR9lzUq0AGTdL9mxt12
KvHfec89EUtdI/7+GMnCDZsaJODVclh/n6XmUfR10QMVfinI/GrPXTvLVE+8JCeR
hqNwMnWimuKclsQrxTrW09Nb6u8yq7xqaEojNR2CYydiyEHb1a0tbCKmlzbVZaLj
aS8CDV7HIekBpeaUAiJe41X/W8BmAvtK92F2q5EVI1vCcH1sAicHqF/BtvGMzf4e
6qlKiqJI5xjFdkYewkA7xJiV869b4qmeBF7JI/ZR+PMoO43w9XnP0SAxcqIm2oaf
S7CdS+6PfmGCribsIXrVtBjtA2xvRbCQitBEl3ynBPFLx7ikmg8HrAZiUN8RioFX
0A6B6AYJ2DYIu3vAir4cFl7HT9vbYQZ8xhXl+/4LPH38Yt5a6OzDj1/UYarXE7Vr
ZaBAYpAcfWCJhWwmBPrpK+MzqSkCCdYySzQaK65jMpfefD1j5hxZubYtK6Nj7oy3
zPwJ1qeE7AY=
=q1FK
-----END PGP SIGNATURE-----

--Sig_/q.hA888dTM6=aQFh2lThGSq--
