Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbaHHOep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 10:34:45 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45451 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbaHHOen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 10:34:43 -0400
Date: Fri, 8 Aug 2014 16:34:13 +0200
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
Message-ID: <20140808143413.GB9918@twins.programming.kicks-ass.net>
References: <20140807150031.GB5821@linux.vnet.ibm.com>
 <20140807152600.GW9918@twins.programming.kicks-ass.net>
 <20140807172753.GG3588@twins.programming.kicks-ass.net>
 <20140807184635.GI3588@twins.programming.kicks-ass.net>
 <20140807154907.6f59cf6e@gandalf.local.home>
 <20140807155326.18481e66@gandalf.local.home>
 <20140807200813.GB3935@laptop>
 <20140807171823.1a481290@gandalf.local.home>
 <20140808064020.GZ9918@twins.programming.kicks-ass.net>
 <20140808101221.21056900@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rIsG1lUQFG2vxuoz"
Content-Disposition: inline
In-Reply-To: <20140808101221.21056900@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rIsG1lUQFG2vxuoz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 08, 2014 at 10:12:21AM -0400, Steven Rostedt wrote:
> > Ok, so they're purely used in the function prologue/epilogue callchain.
>=20
> No, they are also used by optimized kprobes. This is why optimized
> kprobes depend on !CONFIG_PREEMPT. [ added Masami to the discussion ].

How do those work? Is that one where the INT3 relocates the instruction
stream into an alternative 'text' and that JMPs back into the original
stream at the end?

And what is there to make sure the kprobe itself doesn't do 'funny'?

> Which reminds me. On !CONFIG_PREEMPT, call_rcu_task() should be
> equivalent to call_rcu_sched().

Sure, as long as you make absolutely sure none of that code ends up
calling cond_resched()/might_sleep() etc. Which I think you already said
was true, so no worries there.

> > And you don't want to use synchronize_tasks() because registering a tra=
ce
> > functions is atomic ?
>=20
> No. Has nothing to do with registering the trace function. The issue is
> that we have no idea when a task happens to be on a trampoline after it
> is registered. For example:
>=20
> ops adds a callback to sys_read:
>=20
> sys_read() {
>  call trampoline ->
>     set up regs for function call.
>     <interrupt>
>       preempt_schedule();
>=20
>       [ new task runs for long time ]
>=20
>=20
> While this new task is running, we remove the trampoline and want to
> free it. Say this new task keeps the other task from running for
> minutes! We call synchronize_sched() or any other rcu call, and all
> grace periods finish and we free the trampoline. The sys_read() no
> longer calls our trampoline. Doesn't matter, because that task is still
> on it. Now we schedule that task back. It's on a trampoline that has
> just been freed! BOOM. It's executing code that no longer exits.

Sure, I get that part. What I was getting as is _WHY_ you need
call_rcu_task(), why isn't synchronize_tasks() good enough?

> > No need for extra allocations and fancy means of getting rid of them,
> > and only a few bytes extra wrt the existing function.
>=20
> This doesn't address the issue we want to solve.
>=20
> Say we have 1000 functions we want to trace with 1000 different
> callbacks. Each of theses functions has one call back. How do you solve
> that with your solution? Today, we do the list for every function. That
> is, for each of these 1000 functions, we run through 1000 ops looking
> for the ops that registered for this function. Not very efficient is it?

Ah, but you didn't say that, didn't you :-)

> What we want to do today, is to create a dynamic trampoline for each of
> theses 1000 functions. Each function will call a separate trampoline
> that will only call the function that was registered to it. That way,
> we can have 1000 different ops registered to 1000 different functions
> and still have the same performance.

And how will you limit the amount of memory tied up in this? This looks
like a good way to tie up an immense amount of memory fast.

--rIsG1lUQFG2vxuoz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT5N/lAAoJEHZH4aRLwOS6wcMP/1PvK2IY+V81NHhZydTgGpoN
0QGdApQjd5Z6S3d8UYMru/8kV5297gVsklLtGqnNyTx7fRy8o2PQstT27EN9JB12
JQOqpO2FiLlm90V7buvEIy7XPOr9yLvp8C5dK8MexppGvNtXAHSp1OvOd2HVz6KV
s0z0+5yndJKDvfqIwe6fv6fAqsq1Ff7wTIuWIMnVNHe1J4AqP6vNIT0nZ9gQo8fK
NS4+C2ktqUr4x/69DmsL5nzVfZTL9gJmdY8pPt3iCmXTDD5r1j0nDoocOsFaBR2X
Sf0SX2xkqJw2nNbdJ8IiA5/MEi8mmbFC4DKa4dY81hHS9o5ofKDJeQxzyE5Vf7ni
/Zx0Ddr+qc2WXF0JLEk8ZTaNni3Bev76claFJyB8zQ1lDyZBnV642ZyvUTtlM1Yq
/nrAV+1jTbx6xWzDhG3PXkarU1HXgSv7sWoFaVdESENmR8uWwAf/80++gaIFxfBS
vOe1RfBe8DGYdrcl2Guc04NVialhPGoUCI2Cp7+dqyF9n10B/bOo19sNlBIa18kn
gWuwFF+qQDXg0f0bOCeBsEFosb/vIzrDsbVIxsfMYwjINntgfoezfeT1H1Aov9Be
stnr2SwV0VtFCZtWX32ePaiaioKbz3gd1uQPL38rySDx2o2euY8Z1GsKtbriX5nn
oaP4RtUPo1ac3mbFp/Bt
=B22H
-----END PGP SIGNATURE-----

--rIsG1lUQFG2vxuoz--
