Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbaA0MmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 07:42:14 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:51937 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaA0MmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 07:42:13 -0500
Date: Mon, 27 Jan 2014 13:40:11 +0100
From: Henrik Austad <henrik@austad.us>
To: Luca Abeni <luca.abeni@unitn.it>
Cc: Juri Lelli <juri.lelli@gmail.com>, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, rostedt@goodmis.org,
        oleg@redhat.com, fweisbec@gmail.com, darren@dvhart.com,
        johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@gmail.com, liming.wang@windriver.com,
        jkacur@redhat.com, harald.gustafsson@ericsson.com,
        vincent.guittot@linaro.org, bruce.ashfield@windriver.com,
        linux-doc@vger.kernel.org, rob@landley.net
Subject: Re: [PATCH] sched/deadline: Add sched_dl documentation
Message-ID: <20140127124011.GA16809@austad.us>
References: <1390821615-23247-1-git-send-email-juri.lelli@gmail.com>
 <20140127115316.GA16595@austad.us>
 <52E65172.6070809@unitn.it>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <52E65172.6070809@unitn.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2014 at 01:30:42PM +0100, Luca Abeni wrote:
> Hi Henrik,
>=20
> On 01/27/2014 12:53 PM, Henrik Austad wrote:
> [...]
> >>+ In more details, the CBS algorithm assigns scheduling deadlines to
> >>+ tasks in the following way:
> >>+
> >>+  - Each SCHED_DEADLINE task is characterised by the "runtime",
> >>+    "deadline", and "period" parameters;

> >>+
> >>+  - The state of the task is described by a "scheduling deadline", and
> >>+    a "current runtime". These two parameters are initially set to 0;
> >>+
> >>+  - When a SCHED_DEADLINE task wakes up (becomes ready for execution),
> >>+    the scheduler checks if
> >>+
> >>+                    current runtime                runtime
> >>+         ---------------------------------- > ----------------
> >>+         scheduling deadline - current time         period
> >>+
> >>+    then, if the scheduling deadline is smaller than the current time,=
 or
> >>+    this condition is verified, the scheduling deadline and the
> >>+    current budget are re-initialised as
> >
> >Current runtime: time spent running _this_ period? or is _remaining_
> >runtime this period? I get the feeling it's the latter.
> >
> >So, roughly, it is the ration
> >
> >       remaining_runtime / relative_time_to_deadline
> >
> >which needs to be greater than the assigned CPU bandwidth, and if so, the
> >budget should be replensihed?
> >
> >Shouldn't there be something about not refilling the budget before a new
> >period has started?
> Uh... Maybe the description above can be improved :)
> Do you think that using "remaining runtime" instead of "current runtime"
> would help? If yes, I'll make this change.

Yes, in my vocabularly, "remaining" !=3D "current" :), so changing to=20
'remaining runtime' would be nice.

> Also, I see that some of your questions are answered by some items below.=
=2E.

Yes, but I left the comments to indicate that the order was a bit=20
confusing.

> Do you think that changing the order of the items in the presentation wou=
ld
> improve the readability? If you suggest a better ordering, I'll try to
> rewrite the algorithm's description according to it.

Could be, at least the ratio-caclulation was a bit confusing until I'd read=
=20
the entire section.

My preferred order (I've just cut'n'pased from the original email here)

+  - The state of the task is described by a "scheduling deadline", and
+    a "current runtime". These two parameters are initially set to 0;
+
+  - Each SCHED_DEADLINE task is characterised by the "runtime",
+    "deadline", and "period" parameters;
+



+  - When a SCHED_DEADLINE task executes for an amount of time t, its
+    current runtime is decreased as
+
+         current runtime =3D current runtime - t
+
+    (technically, the runtime is decreased at every tick, or when the
+    task is descheduled / preempted);
+
+  - When the current runtime becomes less or equal than 0, the task is
+    said to be "throttled" (also known as "depleted" in real-time literatu=
re)
+    and cannot be scheduled until its scheduling deadline. The "replenishm=
ent
+    time" for this task (see next item) is set to be equal to the current
+    value of the scheduling deadline;
+
+  - When the current time is equal to the replenishment time of a
+    throttled task, the scheduling deadline and the current runtime are
+    updated as
+
+         scheduling deadline =3D scheduling deadline + period
+         current runtime =3D current runtime + runtime




+  - When a SCHED_DEADLINE task wakes up (becomes ready for execution),
+    the scheduler checks if
+
+                    current runtime                runtime
+         ---------------------------------- > ----------------
+         scheduling deadline - current time         period
+
+    then, if the scheduling deadline is smaller than the current time, or
+    this condition is verified, the scheduling deadline and the
+    current budget are re-initialised as
+
+         scheduling deadline =3D current time + deadline
+         current runtime =3D runtime
+
+    otherwise, the scheduling deadline and the current runtime are
+    left unchanged;
+

Emphasis on -my- preferred order. :)

Either way, I'm quite happy with this documentation-update, this is just=20
nitpick :)

--=20
Henrik Austad

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlLmU6sACgkQ6k5VT6v45ll0bACgqI3M7Uax22+iaNzFoI1aMTOe
btUAnRHGT2rrOPPNYkDjlIgcDw1JXV2c
=wYBB
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
