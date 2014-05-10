Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbaEJP3T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 11:29:19 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51586 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaEJP3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 11:29:18 -0400
Date: Sat, 10 May 2014 17:29:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: rostedt@goodmis.org, bsegall@google.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: Distinguish sched_wakeup event when wake up a
 task which did schedule out or not.
Message-ID: <20140510152902.GW11096@twins.programming.kicks-ass.net>
References: <53683B14.3060702@cn.fujitsu.com>
 <1399341154-11785-1-git-send-email-yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KMIs29sPfC/9Gbii"
Content-Disposition: inline
In-Reply-To: <1399341154-11785-1-git-send-email-yangds.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KMIs29sPfC/9Gbii
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 06, 2014 at 10:52:34AM +0900, Dongsheng Yang wrote:
> ttwu_do_wakeup() is called when the task's state is switched back to
> TASK_RUNNING, whether or not the task actually scheduled out. Tracing
> the wakeup event when the task never scheduled out is quite confusing.
>=20
> This patch take the use of 'success' parameter in sched_wakeup tracepoint,
> to indicate that the task we are waking up did schedule out or just
> change its state to TASK_RUNNING.
>=20
> success is true:
> 	task was out of run queue and sleeping, we are really wake it up.
> success is false:
> 	taks was on run queue all the time and we just change its state
> 	to TASK_RUNNING.

No, I think this patch is crap and doesn't actually change anything
much, at best it simply reduces the size of the race window.

I also think you're trying to solve something that cannot be solved.

So the fundamental wait loop is:

  for (;;) {
	set_current_state(TASK_UNINTERRUPTIBLE);
	if (cond)
		break;
	schedule();
  }
  __set_task_state(TASK_RUNNING);

And the fundamental wakeup is:

  cond =3D true;
  wake_up_process(TASK_NORMAL);

And this is very much on purpose a lock-free but strictly ordered
scenario. It is a variation of:

  X =3D Y =3D 0

  (wait)	(wake)
  [w] X =3D 1	[w] Y =3D 1
  MB		MB
  [r] Y		[r] X

[ where: X :=3D state, Y :=3D cond ]

And we all 'know' that the only provided guarantee is that:
  X=3D=3D0 && Y=3D=3D0
is impossible -- but only that, all 3 other states are observable.

This guarantee means that its impossible to both miss the condition and
the wakeup; iow. it guarantees fwd progress.

OTOH its fundamentally racy, nothing guarantees we will not 'observe' both
the condition and the wakeup.

The setting of .success=3Dfalse when ->on_rq is actively wrong, suppose
the waiter has already observed cond=3D=3Dfalse but has not yet gotten to
schedule(), at that point the wakeup happens and sees ->on_rq=3D=3D1. The
wakeup is still very much a real wakeup.

If it were not for that wakeup the waiter would have gone to sleep and
missed the update of condition.

So no.. not going to happen. And certainly not with such a crappy
Changelog.

And a frozen seafood of choice lobbed at Steven for not seeing this :-)


--KMIs29sPfC/9Gbii
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbkW+AAoJEHZH4aRLwOS6ptAP/3xaiKzBNh1guUGT2iJmmGSd
ekewxG8+XF7kf1UdH+Z1XCKDtGOoU6ADNtVpNaTrtanLs5eFVMM5t2ceu/jXVDRy
X8C9rvITdyai6/ItSB2XQW7z97Isk0UpMKxRGIgeSnhk2sb2R9LenfvA8tnPaoFc
fKb9n6uZeNXDSmg964DnngS3Xlnt/f5zbsxzFtHNKvhVLfbjRyLlzcmliYyLXU8B
8qjq9zXIFoSiddbDYk5uPnvm7kaPawoxmPr8woWwOoXlMLPQ8O8HswHkYXQL6k8a
o663vvRub7kkYKzuJQ7mo0B/7XkFJ9yoJQ/g0PaBja68IQSRPbbBgGIp5cC7YMy/
vV/pzYw9XrWgg827YxFpsf9X6Kc+LBYmOyM9EHRcnQuc2ceRIuf+kECQyDxCPWPX
IUM/lXqFNNp2DMJViikDa3PkBLnnKJax44evxd395n4Xu7mtbO06YTd0w6/4R/Bu
glV/dUzRTCXSgiHVrCXKFTpcY71hOhRyw92eirRlaL7JebnOeQWruYQb9p/vwQn7
gTQzUk2jXy30+88VkD5TaTRXs/8i2jLL+XlhAxMCiMoHiJJAluEvS/chzFOWzcNo
x8MxdxflPCAbcsN+G74qAeCYdMW4YBweR1A9VWztxEsiagQZp5uYCMAJQCoZNx2I
nBgdpqdV9lTZQHWrkA3b
=F/Fv
-----END PGP SIGNATURE-----

--KMIs29sPfC/9Gbii--
