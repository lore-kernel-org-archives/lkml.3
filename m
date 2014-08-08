Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbaHHPRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 11:17:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:52215 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbaHHPRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 11:17:01 -0400
Date: Fri, 8 Aug 2014 17:16:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        bobby.prani@gmail.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140808151643.GD9918@twins.programming.kicks-ass.net>
References: <20140807172753.GG3588@twins.programming.kicks-ass.net>
 <20140807184635.GI3588@twins.programming.kicks-ass.net>
 <20140807154907.6f59cf6e@gandalf.local.home>
 <20140807155326.18481e66@gandalf.local.home>
 <20140807200813.GB3935@laptop>
 <20140807171823.1a481290@gandalf.local.home>
 <20140808064020.GZ9918@twins.programming.kicks-ass.net>
 <20140808101221.21056900@gandalf.local.home>
 <20140808143413.GB9918@twins.programming.kicks-ass.net>
 <20140808105858.171da847@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wgjXbY2g0o4l+9xG"
Content-Disposition: inline
In-Reply-To: <20140808105858.171da847@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wgjXbY2g0o4l+9xG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 08, 2014 at 10:58:58AM -0400, Steven Rostedt wrote:
> On Fri, 8 Aug 2014 16:34:13 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> > On Fri, Aug 08, 2014 at 10:12:21AM -0400, Steven Rostedt wrote:
> > > > Ok, so they're purely used in the function prologue/epilogue callch=
ain.
> > >=20
> > > No, they are also used by optimized kprobes. This is why optimized
> > > kprobes depend on !CONFIG_PREEMPT. [ added Masami to the discussion ].
> >=20
> > How do those work? Is that one where the INT3 relocates the instruction
> > stream into an alternative 'text' and that JMPs back into the original
> > stream at the end?
>=20
> No, it's where we replace the 'int3' with a jump to a trampoline that
> simulates an INT3. Speeds things up quite a bit.

Ah, ok.=20

> > And what is there to make sure the kprobe itself doesn't do 'funny'?
>=20
> Well, kprobes, like function callbacks are just restricted like
> interrupt handlers are. If they break, they break. They should know
> better ;-)

But is there debugging infrastructure to test they don't do funny? Or
are we just going to wait for some random runtime weirdness and then
pull our hair out?

So do we run these handlers with preempt_disable() or anything like
that? (maybe only as a debug option).

> > Sure, as long as you make absolutely sure none of that code ends up
> > calling cond_resched()/might_sleep() etc. Which I think you already said
> > was true, so no worries there.
>=20
> Right. There's no guarantees that someone wont do such a stupid thing.
> But then, there's no guarantees that someone wont register an NMI
> callback with the same code too.

Well, kprobes is 'special' in that it it almost encourages random non
kernel devs to write modules for it, so it gets extra special creative
crap in.

I'm fairly sure you'll get your ftrace handler right, because that's
only you and maybe a few other people ever touching that code. Not so
with kprobes.

> > Sure, I get that part. What I was getting as is _WHY_ you need
> > call_rcu_task(), why isn't synchronize_tasks() good enough?
>=20
> Oh, because that synchronize_tasks() may take minutes. And that means
> we wont be able to return for a long time. The only thing I can really
> see using call_rcu_task() is something that needs to free its data. Why
> wait around when all you're going to do is call free? It's basically
> just a garbage collector.

Well the waiting has the advantage of being a natural throttle on the
amount of memory tied up in the whole scheme.

> > > What we want to do today, is to create a dynamic trampoline for each =
of
> > > theses 1000 functions. Each function will call a separate trampoline
> > > that will only call the function that was registered to it. That way,
> > > we can have 1000 different ops registered to 1000 different functions
> > > and still have the same performance.
> >=20
> > And how will you limit the amount of memory tied up in this? This looks
> > like a good way to tie up an immense amount of memory fast.
>=20
> Well, these operations are currently only allowed by root. Thus, it's
> the thing that root should be careful about. The trampolines are small,
> and it will take a hell of a lot of callbacks to cause issues.

You said 10e3 order things, I then give you a small 32bit arm system.

The thing is, even root is a clueless idiot most of the times, yes we'll
let him shoot his foot off and give him enough rope to hang himself, and
we'll even show him how to tie the knot at times, but how is he to know
that this script that 'worked' now causes his machine to OOM and behave
brick like?

> The thing I'm worried about is to make sure they get freed. Otherwise a
> leak will cause more issues than anything else. Which also means we
> need to have a way to expedite call_rcu_tasks() if need be.

No.. for one, that doesn't follow. Things will get freed (eventually)
even without expedite, and secondly implementing expedite would mean
force scheduling tasks etc. And we're just so not going to do that.



--wgjXbY2g0o4l+9xG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT5OnbAAoJEHZH4aRLwOS6OfkQALHDenpvf03OX6wJMj0ekTAz
+Rj26BK67oIdNG7muJOgCAWnfh+Bo/vCi2Ygd8kLqAQrOoiWFwo8N7e5o/kYW/5j
gTNa+1GC8nrf8UCLfk1y/H3UEaGooxRB62lpyJu581VTxfEyks/nO1ga0vi9kIhQ
UWR2wgxQ4uxc9ptH2uqTASt+xPF0r2NB+4bN3gfazwb2/6m/Cq/6cmQHOid5SaMy
ZZeMXEQzBCZ0MH3nQTfG1AlIU9XtGoXDeupoaHdA3BRKfvCGQk0hmG2H8xBrkQdE
7kWOGOg33ky/owdyyT1EAWrcG9RYPyXsAOSfGSrtoKy8kPVTn3EMd5fn3ImuMJHt
yOAyPKa3pgzv+P6ze67gcC0EaobDPIxVKGKDZvohQucbKnvrxYngtQ9wCmn3wnXA
G5Fz2L7NKND6zCiJHgzwNqy2uEPVrkUKsm1w19lIK2oMsElv44CI1kEK5MRZADqY
OymWyuUGR1RAklBiqUEFv1QpWZWdyScaxpiLMmiFuKDvsmUAfLyddBAPEZvb2lMZ
V6sLMkXUlZM7fs8Ca5AYjWlj5NjVDtyjrHPA3cq9l15fcO7lLOrExP/JdfMETrd/
c5BK5yJRX0lihla1+n+B7Fl5A2vXb1yluaF58vx6Xgp9AOg+5HBcZXBJQkRGW2Mv
FxI1W+m2regW3IyMdnOg
=3UT6
-----END PGP SIGNATURE-----

--wgjXbY2g0o4l+9xG--
