Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbaHJPAY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 11:00:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:58582 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaHJPAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 11:00:23 -0400
Date: Sun, 10 Aug 2014 17:00:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140810150005.GU9918@twins.programming.kicks-ass.net>
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140808191326.GE3935@laptop>
 <20140808205826.GG5821@linux.vnet.ibm.com>
 <20140809183355.GP9918@twins.programming.kicks-ass.net>
 <20140810013829.GP5821@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SCaOIQf4OfYbUof5"
Content-Disposition: inline
In-Reply-To: <20140810013829.GP5821@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SCaOIQf4OfYbUof5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 09, 2014 at 06:38:29PM -0700, Paul E. McKenney wrote:
> On Sat, Aug 09, 2014 at 08:33:55PM +0200, Peter Zijlstra wrote:
> > On Fri, Aug 08, 2014 at 01:58:26PM -0700, Paul E. McKenney wrote:
> > >=20
> > > > And on that, you probably should change rcu_sched_rq() to read:
> > > >=20
> > > > 	this_cpu_inc(rcu_sched_data.passed_quiesce);
> > > >=20
> > > > That avoids touching the per-cpu data offset.
> > >=20
> > > Hmmm...  Interrupts are disabled,
> >=20
> > No they are not, __schedule()->rcu_note_context_switch()->rcu_sched_qs()
> > is only called with preemption disabled.
> >=20
> > We only disable IRQs later, where we take the rq->lock.
>=20
> You want me not to disable irqs before invoking rcu_preempt_qs() from
> rcu_preempt_note_context_switch(), I get that.  But right now, they
> really are disabled courtesy of the local_irq_save() before the call
> to rcu_preempt_qs() from rcu_preempt_note_context_switch().

Ah, confusion there, I said rcu_sched_qs(), you're talking about
rcu_preempt_qs().

Yes the call to rcu_preempt_qs() is unconditionally wrapped in IRQ
disable.

> > void rcu_sched_qs(int cpu)
> > {
> > 	if (trace_rcu_grace_period_enabled()) {
> > 		if (!__this_cpu_read(rcu_sched_data.passed_quiesce))
> > 			trace_rcu_grace_period(...);
> > 	}
> > 	__this_cpu_write(rcu_sched_data.passed_quiesce, 1);
> > }
> >=20
> > Would further avoid emitting the conditional in the normal case where
> > the tracepoint is inactive.
>=20
> It might be better to avoid storing to rcu_sched_data.passed_quiesce when
> it is already 1, though the difference would be quite hard to measure.
> In that case, this would work nicely:
>=20
> static void rcu_preempt_qs(int cpu)
> {
> 	if (rdp->passed_quiesce =3D=3D 0) {
> 		trace_rcu_grace_period(TPS("rcu_preempt"), rdp->gpnum, TPS("cpuqs"));
> 	> 	__this_cpu_write(rcu_sched_data.passed_quiesce, 1);
> 	}
> 	current->rcu_read_unlock_special &=3D ~RCU_READ_UNLOCK_NEED_QS;
> }

Yes, that's a consideration, fair enough. Again note the confusion
between sched/preempt. But yes, both can use this 'cleanup'.

--SCaOIQf4OfYbUof5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT54jvAAoJEHZH4aRLwOS6W+4P/1SkcVPDOqtFlSacYHZninQ7
/KFvX8i2vk9W1SCpn6NBsLsIXNwwAsGTAIfd0nVvparYW5ePU++8u+skLs2OBQ/z
U20N+ErYTRfg7kZqTJhpAuJkdIo3WwV1Vedt7fdRfxDF/svi+uVQhrccKsui6/mI
rPDvAe6YaR0iWklODbAksC2vtAQsvoE8q+bCqJhZrVp2CnRVGdFAAsaKvLI9cPbt
l6sikmYyjXDJx/h3/CwPd/bqalqVPdfWV4QbOvjgZQXrlQPGeNjFw9tPjvVH3yik
33gvEq84sztbo2uADmzoiImXc2rXd75PLDFYSXU+3O2bZ1Cv5xCYJcHZ0mP4vOqV
D95pEvfX68w8a4vJl97V+EFKhNBxsGOpUhyFBaSv0rWTrUOH5x+XRbKXlvgSyZk4
MTaE76DEw9kfRCP/z9gy4aqwIv5CHjtqCdGYtmrrd982gAZlDcyCmITW8jsd55ln
da0durb/aQNXpw/Rl8yvDPwOthyj8y/dWqu6m1xACbkOWMnhSvoc/YCcHbs5yDuO
Nv63aco9ncYTXyY9ZNopJ9MsqUVvNFfAHLEQ9knRLQGUtHs5CLZ2fcR3EsoJeNNc
2pI2ZJfEWhZRDos4iGPxzdwYDdOxASerQJdeIk0tXZeLYXJKUQ+JeZOXZQL8UCpf
ivNBF/9kHiGYwYL32Xl7
=hO3x
-----END PGP SIGNATURE-----

--SCaOIQf4OfYbUof5--
