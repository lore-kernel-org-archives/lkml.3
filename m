Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751252AbaHIGQF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 02:16:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46547 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaHIGQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 02:16:02 -0400
Date: Sat, 9 Aug 2014 08:15:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140809061514.GK9918@twins.programming.kicks-ass.net>
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140808191326.GE3935@laptop>
 <20140808205826.GG5821@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uoMAg3++HhpTySgs"
Content-Disposition: inline
In-Reply-To: <20140808205826.GG5821@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uoMAg3++HhpTySgs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 08, 2014 at 01:58:26PM -0700, Paul E. McKenney wrote:
> On Fri, Aug 08, 2014 at 09:13:26PM +0200, Peter Zijlstra wrote:
> >=20
> >=20
> > So I think you can make the entire thing work with
> > rcu_note_context_switch().
> >=20
> > If we have the sync thing do something like:
> >=20
> >=20
> > 	for_each_task(t) {
> > 		atomic_inc(&rcu_tasks);
> > 		atomic_or(&t->rcu_attention, RCU_TASK);
> > 		smp_mb__after_atomic();
> > 		if (!t->on_rq) {
> > 			if (atomic_test_and_clear(&t->rcu_attention, RCU_TASK))
> > 				atomic_dec(&rcu_tasks);
> > 		}
> > 	}
> >=20
> > 	wait_event(&rcu_tasks_wq, !atomic_read(&rcu_tasks));
> >=20
> >=20
> > And then we have rcu_task_note_context_switch() (as called from
> > rcu_note_context_switch) do:
> >=20
> >=20
> > 	/* we want actual context switches, ignore preemption */
> > 	if (preempt_count() & PREEMPT_ACTIVE)
> > 		return;
> >=20
> > 	/* if not marked for RCU attention, bail */
> > 	if (!(atomic_read(&t->rcu_attention) & RCU_TASK))
> > 		return;
> >=20
> > 	/* raced with sync_rcu_task(), all done */
> > 	if (!atomic_test_and_clear(&t->rcu_attention, RCU_TASK))
> > 		return;
> >=20
> > 	/* not the last.. */
> > 	if (!atomic_dec_and_test(&rcu_tasks))
> > 		return;
> >=20
> > 	wake_up(&rcu_task_rq);
> >=20
> >=20
> > The idea is to share rcu_attention with rcu_preempt, such that we only
> > touch a single 'extra' cacheline in case RCU doesn't need to pay
> > attention to this task.
> >=20
> > Also, it would be good if we can manage to squeeze this variable in a
> > cacheline that's already touched by the schedule() so as not to incur
> > undue overhead.
>=20
> This approach does not get me the idle tasks and the NO_HZ_FULL usermode
> tasks.  I am pretty sure that I am stuck polling in those cases, so I
> might as well poll.

That's so wrong its not funny. If you need some abortion to deal with
NOHZ_FULL then put it under CONFIG_NOHZ_FULL, don't burden the entire
world with it.

Also, I thought RCU already knew which CPUs were in nohz_full userspace,
so we can insta check that in the sync, together with the !->on_rq test,
if the task is running on a nohz_full cpu in rcu quiescent state, also
clear the task.

As for idle tasks, I'm not sure about those, I think that we should say
NO to anything that would require waking idle CPUs, push the pain to
ftrace/kprobes, we should _not_ be waking idle cpus.

--uoMAg3++HhpTySgs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT5bxtAAoJEHZH4aRLwOS66XQP/1BVNXdyOm5jL43rn0KTvjUa
uTlF9GV3AOu/tdXZczUy2mDN43BwTWXHSVeNjPwLFEmA9PT4lhOIERTJsfkJW7N1
fI6BcVowUQxYLdpD+Hh+LMCTvleiOLG/+GB2n639vYR/2svqijyTZPZWe7hBisQ/
0p/12Q3Q4LGZoUn53HXrh3Qs58LeSNWfZgWlGljND/4IfBDrJ7P6+IUWZhYDJtli
a3DVgqeiHf1gBLHPrvsot4AqAOGDfEIr90WqylwyaM6pCbLj4Do8jgqF9+nI1taA
C9RAeGgVQY6hK1hwU4WxZd2HEXxRF8/xdJC7TQbxs5dhQkwKuDkPqQxLExHit94v
HG9fakOG3sKHgbeAtHvo45I9w06Z1Y1JClPdhL6tE4ZK5ntRyW12vgWcyE8CGy3U
3dtHR+PBaMSvrbWAKdMStr9VilY8vhwjUdS5aQumxWTeoGWOYf5eXloPhdbBqecL
Q3cjo9LMix0QjvXRYLLq+JXH/aBaFiWBi/R+mBv+tgH8mvSNjo1jEtckmZUP0inb
k1hEpRM4xOVYhdXRomQCvcvFz4vH3Y6kcF/Q1M0rNdU8Ro2UNYtVmQebQFUhNapX
ERyX6caMiRkz8nfnOYCzbZ3KUvmdaXtp1VkYXXEt/QIDKFS54r3IyiMCZHMv1xEZ
IFMoyg5f/sKo20byUAie
=eKCU
-----END PGP SIGNATURE-----

--uoMAg3++HhpTySgs--
