Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbaHISeX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 14:34:23 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43719 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaHISeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 14:34:21 -0400
Date: Sat, 9 Aug 2014 20:33:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140809183355.GP9918@twins.programming.kicks-ass.net>
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140808191326.GE3935@laptop>
 <20140808205826.GG5821@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K9fR5eBdO1VxXkhU"
Content-Disposition: inline
In-Reply-To: <20140808205826.GG5821@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K9fR5eBdO1VxXkhU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 08, 2014 at 01:58:26PM -0700, Paul E. McKenney wrote:
>=20
> > And on that, you probably should change rcu_sched_rq() to read:
> >=20
> > 	this_cpu_inc(rcu_sched_data.passed_quiesce);
> >=20
> > That avoids touching the per-cpu data offset.
>=20
> Hmmm...  Interrupts are disabled,

No they are not, __schedule()->rcu_note_context_switch()->rcu_sched_qs()
is only called with preemption disabled.

We only disable IRQs later, where we take the rq->lock.

> so no need to further disable
> interrupts.  Storing 1 works fine, no need to increment.  If I followed
> the twisty per_cpu passages correctly, my guess is that you would like
> me to do something like this:
>=20
> 	__this_cpu_write(rcu_sched_data.passed_quiesce, 1);
>=20
> Does that work?

Yeah, should be more or less similar, the inc might be encoded shorter
due to not requiring an immediate, but who cares :-)

void rcu_sched_qs(int cpu)
{
	if (trace_rcu_grace_period_enabled()) {
		if (!__this_cpu_read(rcu_sched_data.passed_quiesce))
			trace_rcu_grace_period(...);
	}
	__this_cpu_write(rcu_sched_data.passed_quiesce, 1);
}

Would further avoid emitting the conditional in the normal case where
the tracepoint is inactive.

Steve does it make sense to have __DO_TRACE() emit __trace_##name() to
avoid the double static_branch thing?

> > And it would be very good if we could avoid the unconditional IRQ flag
> > fiddling in rcu_preempt_note_context_switch(), them expensive, this
> > looks entirely feasibly in the 'normal' case where
> > t->rcu_read_unlock_special doesn't have RCU_READ_UNLOCK_NEED_QS set.
>=20
> Agreed, but sometimes RCU_READ_UNLOCK_NEED_QS is set.
>=20
> That said, I should probably revisit RCU_READ_UNLOCK_NEED_QS.  A lot has
> changed since I wrote that code.

Sure, but a conditional testing RCU_READ_UNLOCK_NEED_QS is far cheaper
than poking the IRQ flags. That said, its not entirely clear to me why
that needs IRQs disabled at all, then again I didn't look long and I'm
sure its all subtle.

--K9fR5eBdO1VxXkhU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT5mmTAAoJEHZH4aRLwOS61tgP/jfwtyg6uTt582Al8PEtGccq
iUxiQYUZRElI46gIpDN7sppWYdNsnrXvBXU/CSa/eGVMLBi51dPhRQxiE0WHFG1j
V63aQPYozAb/curyTSGgIwEBxwp/tyKdHlsheJ5XpXHm3kx1R1TkkT8ZCiS1ltTK
W/w/D+I6gKlPc3uypjQg+urCkSPVOFZn8ZvI87mxVS9PxcBk5kXN20p/1b9vmZop
uyNkIm4Nsxve+hISd96cCC6Kd+bz3GE9gb/lNmS5HN7Zoo06OpgtkxNv+ZDEsQuq
qmpLA/W6LptojV+lDLiHiuHNd+gNeEphwr2PAdxQdWz2WLH9I1pQVhQYey93yFEL
JDT0TVDkbJ6l6J2i8l5kh0toK+5c27GrxkSdQhXWZvztF4q8a0JYM8wBHyWvcKva
uI/NGQm7r7wxETTrgYLE2kiUdFr8M0WJqKgwzxkpNXdyoOjOyAWRB8RkPf8Gj7vL
bxKSYRWFd8Xpw0nAyyBuvKa9R+Wmg+COs6C4jF/OGPcW5KmTPwoeeR1/nJcSu+b9
iRaQLakH3qdziUkZwUKoH1/HMboCjirxVCDgBj2CHw8582qNaLeZF4LrWonmz7iq
Z6JAEsA1HNGvofmiMoggDct7TaUD+y9JZOMpo0108u6wM86n1TtAd3FkVp5fsS2J
qmeSm7Pn9crjw63UbL1l
=pX90
-----END PGP SIGNATURE-----

--K9fR5eBdO1VxXkhU--
