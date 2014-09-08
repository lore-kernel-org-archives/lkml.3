Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaIHIjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:39:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:37892 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbaIHIjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:39:12 -0400
Date: Mon, 8 Sep 2014 10:39:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yan Zheng <zheng.z.yan@intel.com>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        Vince Weaver <vincent.weaver@maine.edu>
Subject: Re: Possible race between CPU hotplug and perf_pmu_migrate_context
Message-ID: <20140908083905.GL16043@twins.programming.kicks-ass.net>
References: <20140901181808.GA6427@leverpostej>
 <20140901190534.GC5806@worktop.ger.corp.intel.com>
 <20140902185807.GA7434@leverpostej>
 <20140903115013.GA3127@leverpostej>
 <20140904104402.GS4783@worktop.ger.corp.intel.com>
 <20140904110740.GB32228@leverpostej>
 <20140905151640.GN19379@twins.programming.kicks-ass.net>
 <CA+55aFwhKyjNHuSThuPOejq1uLTXoqHwAtG8cfcx-Sqp83RKSg@mail.gmail.com>
 <20140905165956.GA28623@leverpostej>
 <CA+55aFwqhPLjTyiwVs2F9p8BPxMV=FOTgLpcHcV2rUPvTt71ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9JSHP372f+2dzJ8X"
Content-Disposition: inline
In-Reply-To: <CA+55aFwqhPLjTyiwVs2F9p8BPxMV=FOTgLpcHcV2rUPvTt71ow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9JSHP372f+2dzJ8X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 05, 2014 at 10:31:49AM -0700, Linus Torvalds wrote:
> So quite frankly, the whole perf_pmu_migrate_context() thing looks
> completely and fundamentally broken.
>=20
> Your patch doesn't really solve anything in general, and would need to
> be extended to do that get_online_cpus() around every single case
> where we read it. Which isn't really acceptable.
>=20
> perf_pmu_migrate_context() is just f*cked up. It needs to be reverted.
> It seems to think that "the event->ctx" pointer is a RCU-protected
> pointer, but it really isn't. Its lifetime is protected by
> refcounting, and the pointer access itself isn't protected by
> anything, because "event->ctx" isn't supposed to change over the
> lifetime of "event". Nobody does all the necessary rcu_read_[un]lock()
> around it, nor access it with rcu_dereference(), because all users
> know that it's just fixed.

Its worse; there's a second site that does exactly the same broken thing
:/

The 'move_group' logic in sys_perf_event_open() migrates a software
event into a hardware context when creating event groups.

> Quite frankly, I think commit 0cda4c023132 ("perf: Introduce
> perf_pmu_migrate_context()") is unfixably broken. The whole thing
> needs to be re-thought. It violates everything that everybody else
> does with the context. No amount of (sane) locking can fix the
> breakage, I suspect.

So yes and no; yes for sanity and consistency, no because after we've
done perf_remove_from_context() the event itself is inactive and we only
need to 'worry' about external (mostly userspace and exit paths)
interaction.

The hard exclusion provided by a rwsem/hotplug lock can do this, but I
agree its quite horrible.

> A possible (but unfortunate) real fix is to try to keep the broken
> code around, and make its broken assumptions be actually true. Make
> "event->ctx" truly be an RCU pointer. Add the RCU annotations, add the
> required rcu read-locking, and make everything really do what that
> currently completely broken perf_pmu_migrate_context() thinks it does.

I'm not entirely sure RCU works here.

>    That implies, for example, that any time you use the thing in a
> sleeping context, you'd need to do something like this (possibly with
> a helper function to do that: "get_event_ctx()"
>=20
>         rcu_read_lock();
>         ctx =3D rcu_dereference(event->rcu);
>         get_ctx(ctx);
>         rcu_read_unlock();
>=20
>         .. you can now sleep here and use 'ctx' ...
>=20
>         put_ctx(ctx);
>=20
>     and if you don't need to sleep, you can just do
>=20
>         rcu_read_lock();
>         ctx =3D rcu_dereference(event->ctx);
>         .. use ctx in an atomic context ...
>         rcu_read_unlock();
>=20
> but that is a much bigger patch than either of the "introduce a
> completely broken ad-hoc lock around just one random use case"
> patches.

So the problem with an RCU like approach is that it would allow multiple
users to see different ctxs. Even calling synchronize_rcu() in between
doesn't really solve that because we don't clear the event->ctx pointer
after remove_from_context, install_in_context simply sets a new one.

If we were to clear the context pointer, all usage sites would have to
read/wait until there's a valid pointer again, at which point we've just
build a rwsem with rcu.

> Alternatively (and this sounds like the better fix), use some way to
> avoid that broken perf_pmu_migrate_context() model entirely. Never
> "migrate" events. Create completely new ones on the new CPU, and leave
> the old stale ones alone even on dead CPU's (they will presumably not
> actually be activated, and who the hell cares?).

That appears to simply move the problem; instead of event->ctx being the
problem we then get filp->private_data the exact same problem. It might
be a better delimited problem perhaps, but adds a little complexity
because we need to copy the event state around.

Similarly we can't use RCU here because allowing concurrent operations
on different 'versions' of the event makes it very 'interesting' to sync
state between the old and new object.

> Or even just say: "if somebody takes down a CPU with existing uncore
> events, those events are now effectively dead". Don't try to migrate
> them, don't try to create new events on another CPU, just let it go.
> The CPU is down, the events are inactive.

Which, is indeed very attractive; whoever with the additional
'move_group' problem I'm not entirely seeing how we can make that
happen. It would end up disallowing certain event groups that are
currently possible. Most notable a software group leader with hardware
events -- a most useful construct for those people who don't have
interrupts on their hardware PMUs.

Lemme ponder this a bit more.

--9JSHP372f+2dzJ8X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDWspAAoJEHZH4aRLwOS6LDEP/Re5uv2Rx8/+YbOnecDFpF0C
zmyl+RHaOW6NBy3AkJfRyif+822NbsjyfQ3oobf1/ItdNqS4Z6vl5Sd0nr8v5KmX
qLUr5aKUUY51rdiP45rk2prvvnUM7w4N4Efn4IhISmwAEwtKDocLd8cGJKH3qhdl
iGACGCIFIXVJhxmaKAA7jTP0yQ8KxpWjzcUnIT1UDwMLfgdQ8bTueDFNlfqjedkH
+Vf5ZZuq8XMoVh1vLuFAdY4UUJXMnbnyWVeZvBD6QmJaNGNVgvHRnUKwqU8lkMBd
CZPSahFQxl5Uf1iXMHdOBCgRrWO5h6yqB+r5RLeDAcZ93gYOsZ6W/QmY++CYXrZ7
MR/2duUUB9G+hq8y5OiRCAzOsWMDQIbz0ls/XCkSJP0obKqbYNqor/ksgZjMlHv1
MbHnoc6m4m/nRJCRsB7KjaSGYuOlPmezHDhsmXNpA7k5dFWgTeK6K69u1mt4G+S7
GhApj0yw5IPHTA6vMWBGfv/ShkUsKCYCeOx4yKGBr83X8W1LRg31cyQcgWkvXrZK
YFkad1tYMSbIbFmdvXbwRLKUufeehe7wEZbhSL3rBZFkJTQb/ccK1UbcXsmCYJZ1
lhDabOTAWHyCt8CE66AUAFWqFriNZKsY4+JxvJdtOp8P11MalvtZu5laLwvmnMfj
Q3W1d2lw6hVRyJk/6PYL
=w1MQ
-----END PGP SIGNATURE-----

--9JSHP372f+2dzJ8X--
