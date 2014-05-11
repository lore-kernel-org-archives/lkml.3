Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbaEKQfj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 12:35:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:59874 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbaEKQfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 12:35:38 -0400
Date: Sun, 11 May 2014 18:35:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <dongsheng081251@gmail.com>
Cc: "yangds.fnst" <yangds.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        bsegall@google.com
Subject: Re: Fwd: [PATCH] sched: Distinguish sched_wakeup event when wake up
 a task which did schedule out or not.
Message-ID: <20140511163531.GG30445@twins.programming.kicks-ass.net>
References: <53683B14.3060702@cn.fujitsu.com>
 <1399341154-11785-1-git-send-email-yangds.fnst@cn.fujitsu.com>
 <20140510152902.GW11096@twins.programming.kicks-ass.net>
 <536F90BE.2080806@gmail.com>
 <CA+qeAOr_PrBuo+qfjNoaZyHF21p=8UgQy1oZOjAxahhYTyrvLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZbmePlECXulV3R7u"
Content-Disposition: inline
In-Reply-To: <CA+qeAOr_PrBuo+qfjNoaZyHF21p=8UgQy1oZOjAxahhYTyrvLQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZbmePlECXulV3R7u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 11, 2014 at 11:24:22PM +0800, Dongsheng Yang wrote:
> Actually, this patch does not attempt to solve the race condition.
> It only want to avoid sched:sched_wakeup with success=3D=3Dtrue in
> a fake wakeup, as explained below.
>=20
> > So the fundamental wait loop is:
> >
> >    for (;;) {
> >         set_current_state(TASK_UNINTERRUPTIBLE);
> >         if (cond)
> >                 break;
> >         schedule();
> >    }
> >    __set_task_state(TASK_RUNNING);
> >
> > And the fundamental wakeup is:
> >
> >    cond =3D true;
> >    wake_up_process(TASK_NORMAL);
> >
> > And this is very much on purpose a lock-free but strictly ordered
> > scenario. It is a variation of:
> >
> >    X =3D Y =3D 0
> >
> >    (wait)       (wake)
> >    [w] X =3D 1    [w] Y =3D 1
> >    MB           MB
> >    [r] Y                [r] X
> >
> > [ where: X :=3D state, Y :=3D cond ]
> >
> > And we all 'know' that the only provided guarantee is that:
> >    X=3D=3D0 && Y=3D=3D0
> > is impossible -- but only that, all 3 other states are observable.
> >
> > This guarantee means that its impossible to both miss the condition and
> > the wakeup; iow. it guarantees fwd progress.
> >
> > OTOH its fundamentally racy, nothing guarantees we will not 'observe' b=
oth
> > the condition and the wakeup.
> >
> > The setting of .success=3Dfalse when ->on_rq is actively wrong, suppose
> > the waiter has already observed cond=3D=3Dfalse but has not yet gotten =
to
> > schedule(), at that point the wakeup happens and sees ->on_rq=3D=3D1. T=
he
> > wakeup is still very much a real wakeup.
>=20
>=20
> Yes, if a wakeup happens before schedule(), wakeup
> sees ->on_rq=3D=3D1. Then we can get an event with .success=3D=3Dfalse.
> But I think it is not a real wakeup. :(
>=20
> Yes, at this moment, maybe the task is already out of run queue.
> But *this* wakeup did not move it back to run queue, it only
> change the state of it to TASK_RUNNING. I believe the next
> wakeup for this task will do the real wake up moving it back
> to run queue.
>=20
> And if scheduler really wake it up, we can get an event with success=3D=
=3Dtrue.
>=20
> Anyway, what I want with this patch is to make scheduler raise accurate
> events when waking up a task.
>=20
> If a wakeup only change the state of task, raise a event with success=3D=
=3Dfalse.
> If a wakeup move a task back to runqueue, .success=3D=3Dtrue.
>=20
> It means, we do not need to care about the task is on_rq or not currently,
> the value of .success is decided by the behavior we did in the function
> of try_to_wake_up().
>=20
> Wish I explain myself clearly.

So if the wait side has already observed cond=3D=3Dfalse, then without the
wakeup, which still potentially has ->on_rq =3D=3D true, it would block.
Therefore the wakeup is a _real_ wakeup.

We fundamentally cannot know, on the wake side, if the wait side has or
has not observed cond, and therefore the distinction you're trying to
make is a false one.

--ZbmePlECXulV3R7u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTb6bNAAoJEHZH4aRLwOS60LYP/2QLjQD8PAz46dAC6M/rdhQA
5xMBWODgPV0G8iA0iDLPKOEh56ttzuN/1UxPjPEfqAJXMc/Rpc8HDKlFN7vh+Bbu
WKWwrNlulMnx6bOwqODT3yhfdLBCv3Q3Jh/Ofv27qBcvC/el7M/Il68kWTS1YbHK
qLrT6ER7HKWBHtHypQwk7bbV+m4YeWpaqyiDL+oiSNjle3GVNltv+O5k1Cz9PmkP
HjREzcWeWXgIeG0Xn+xZuJcF5jXsC4xTzB2AParOkx5T6+sHnPemBrtl/trbykXu
XRs9QXf9Ru/Uegwjcv5EMpJ706hMF1WuvujnzxO5aM6v35fG5M9InyV01zqlJVpk
SRU+Bi82FD0sTCAysslNVTzl990ydBY2PITthGipJpSvTBohyF7mS07fGxl15j5c
xV7COilMuDlvMCCAFUi/EHdKhsQV33lZfaQmv+O3RKhGnJJ9J1TjOOKk9Sea/Ib5
eHVTzhELlAp7Hsso7zdelqQGUjyvus22OZQfteNItgMZvpuPuu/+ZEsxzrhpVl59
24X/+A0F2ixPxsECDf5gtOZJLY6tQl0VN7PQKDhtE/vLfI1yN1OX+amXvBvCVKO1
DFCCGgVqQpvqd5abPm4zx5FAHF6qS6+qqeZ/hB1BeZBsXLK60MIgVLTPlX3BnWux
TFyjND/aR68BpoPW5MRa
=QJlM
-----END PGP SIGNATURE-----

--ZbmePlECXulV3R7u--
