Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbaHJINO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 04:13:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:57717 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaHJINK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 04:13:10 -0400
Date: Sun, 10 Aug 2014 10:12:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140810081254.GS9918@twins.programming.kicks-ass.net>
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140808191326.GE3935@laptop>
 <20140808205826.GG5821@linux.vnet.ibm.com>
 <20140809061514.GK9918@twins.programming.kicks-ass.net>
 <20140809160137.GJ5821@linux.vnet.ibm.com>
 <20140809181920.GO9918@twins.programming.kicks-ass.net>
 <20140810012612.GN5821@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tCudArHln/pcmL9z"
Content-Disposition: inline
In-Reply-To: <20140810012612.GN5821@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tCudArHln/pcmL9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 09, 2014 at 06:26:12PM -0700, Paul E. McKenney wrote:
> On Sat, Aug 09, 2014 at 08:19:20PM +0200, Peter Zijlstra wrote:
> > On Sat, Aug 09, 2014 at 09:01:37AM -0700, Paul E. McKenney wrote:
> > > > That's so wrong its not funny. If you need some abortion to deal wi=
th
> > > > NOHZ_FULL then put it under CONFIG_NOHZ_FULL, don't burden the enti=
re
> > > > world with it.
> > >=20
> > > Peter, the polling approach actually -reduces- the common-case
> > > per-context-switch burden, as in when RCU-tasks isn't doing anything.
> > > See your own code above.
> >=20
> > I'm not seeing it, CONFIG_PREEMPT already touches a per task cacheline
> > for each context switch. And for !PREEMPT this thing should pretty much
> > reduce to rcu_sched.
>=20
> Except when you do the wakeup operation, in which case you have something
> that is either complex, slow and non-scalable, or both.  I am surprised
> that you want anything like that on that path.

Its a nr_cpus problem at that point, which is massively better than a
nr_tasks problem, and I'm sure we've solved this counter thing many
times, we can do it again.

But for clarity of purpose the single atomic+waitqueue is far easier.

> > Would not the thing I proposed be a valid rcu_preempt implementation?
> > one where its rcu read side primitives run from (voluntary) schedule()
> > to (voluntary) schedule() call and therefore entirely cover smaller
> > sections.
>=20
> In theory, sure.  In practice, blocking on tasks that are preempted
> outside of an RCU read-side critical section would not be a good thing
> for normal RCU, which has frequent update operations.  Among other things.

Sure, just looking for parallels and verifying understanding here. By
the very nature of not having read side primitives to limit coverage its
a pessimistic thing.

> > > > As for idle tasks, I'm not sure about those, I think that we should=
 say
> > > > NO to anything that would require waking idle CPUs, push the pain to
> > > > ftrace/kprobes, we should _not_ be waking idle cpus.
> > >=20
> > > So the current patch set wakes an idle task once per RCU-tasks grace
> > > period, but only when that idle task did not otherwise get awakened.
> > > This is not a real problem.
> >=20
> > And on the other hand we're trying to reduce random wakeups, so this
> > sure is a problem. If we don't start, we don't have to fix later.
>=20
> I doubt that a wakeup at the end of certain ftrace operations is going
> to be a real problem.

But its not ftrace, its rcu_task, and if we put it out there, we'll grow
more and more customers, and soon we'll always have users and never let
CPUs sleep.

That's how these things go, so we should really try and push back on
these things, and that's the thing that worries me most in this
discussion, you seem very happy to provide what's asked for without due
consideration of the negatives.

> > > So I don't believe that the current wakeup rate is a problem, and it
> > > can be reduced if it proves to be a problem.
> >=20
> > How about we simply assume 'idle' code, as defined by the rcu idle hooks
> > are safe? Why do we want to bend over backwards to cover this?
>=20
> Steven covered this earlier in this thread.  One addition might be "For
> the same reason that event tracing provides the _rcuidle suffix."

I really don't think its worth the cost.

--tCudArHln/pcmL9z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT5ymGAAoJEHZH4aRLwOS6SkAP/2o/9QXodOtrFFQcA4jUOINM
jT1EafKs/wbGPdw7mzqMPahVerJm66D0PmCLGqbnox/btlmgLjA2UgIxIvS42xN3
Lwfj/M4u0o/aYxH8plbW7kJ/laBhbQ0x5hXsKRdGa5xfT2hePXoSgnIM58MYpCFO
DfsHSwdSAUEH9Z9x7d8vPEUpINe+ZaZX0g94vvTG9k1lsB8qhU8Bz2fw6oSsbNne
GmDw8oiuZ2nV4ioT5vh59TSmuynKLTTeHq4JYYMSTBY4zz+Z04PYjOYnDWVWM03m
KKFDI6Hn8KBZ1KIFfjdmsVR/B6x8dDzAa/Wn1LKgsi/YyeATqT1kr+wP92nYtE0n
uufSuYwXxPY7gg/ae7c0h7O0Gzg/4fVOgQwokIO/g0dgqvE0/Zc00MDuxMrBoCPP
xciciZprwB0MUhOeTXa7Gg8uN5R/RkgnYUH5qvR6smyx43od/TbMaCfWEGJqrs9F
/GA1CGOHLKCdikhQ/bTRcUiOf3LzqQUOzB2vBCRkWOLbC+l+HXM4VtnL6dTO+zq7
svxH1Ab4eaNoUn6CbkLwECoNS0D4UrtfDzf18pxLiYk4WKXmj9wvpY8KsER+bM8d
mNPTAoT2CDhIdqgpJovMZxU7JIYtM7X+e7KMcmILurY9p9O5H+N8QyhSrhOV6aXN
ZxHTkoo7AfjqzI5MQ9pn
=/igv
-----END PGP SIGNATURE-----

--tCudArHln/pcmL9z--
