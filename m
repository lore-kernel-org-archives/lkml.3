Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902AbaFCQUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 12:20:04 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41195 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356AbaFCQUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 12:20:02 -0400
Date: Tue, 3 Jun 2014 18:19:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        nicolas.pitre@linaro.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 0/8] sched,idle: need resched polling rework
Message-ID: <20140603161950.GB30445@twins.programming.kicks-ass.net>
References: <20140411134243.160989490@infradead.org>
 <CALCETrWJZ1-T+qOY9v=KBOSJkck7YYe7khw_dYPc9Ar8WFgMKw@mail.gmail.com>
 <20140522125818.GV30445@twins.programming.kicks-ass.net>
 <20140522130931.GV13658@twins.programming.kicks-ass.net>
 <CALCETrVBVOjs0EVqEz3qKtSHQg1agJzAyG4Ohqueky-zPF7uKA@mail.gmail.com>
 <20140529064827.GI19143@laptop.programming.kicks-ass.net>
 <CALCETrWnG7fSuinDv+GAHsnTLJ-6xn+_1LB2XdLGVXcC=TQURA@mail.gmail.com>
 <20140603104347.GT11096@twins.programming.kicks-ass.net>
 <20140603140223.GA13658@twins.programming.kicks-ass.net>
 <CALCETrW3cr_RLnMeMtutM5H+3cJSerUxXuEmiT9miDOEmkpANw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="c1TZOjW/0w0yugbT"
Content-Disposition: inline
In-Reply-To: <CALCETrW3cr_RLnMeMtutM5H+3cJSerUxXuEmiT9miDOEmkpANw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--c1TZOjW/0w0yugbT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 09:05:03AM -0700, Andy Lutomirski wrote:
> On Tue, Jun 3, 2014 at 7:02 AM, Peter Zijlstra <peterz@infradead.org> wro=
te:
> > On Tue, Jun 03, 2014 at 12:43:47PM +0200, Peter Zijlstra wrote:
> >> We need rq->curr, rq->idle 'sleeps' with polling set and nr clear, but
> >> it obviously has no effect setting that if its not actually the current
> >> task.
> >>
> >> Touching rq->curr needs holding rcu_read_lock() though, to make sure t=
he
> >> task stays around, still shouldn't be a problem.
> >
> >> @@ -1581,8 +1604,14 @@ void scheduler_ipi(void)
> >>
> >>  static void ttwu_queue_remote(struct task_struct *p, int cpu)
> >>  {
> >> -     if (llist_add(&p->wake_entry, &cpu_rq(cpu)->wake_list))
> >> -             smp_send_reschedule(cpu);
> >> +     struct rq *rq =3D cpu_rq(cpu);
> >> +
> >> +     if (llist_add(&p->wake_entry, &rq->wake_list)) {
> >> +             rcu_read_lock();
> >> +             if (!set_nr_if_polling(rq->curr))
> >> +                     smp_send_reschedule(cpu);
> >> +             rcu_read_unlock();
> >> +     }
> >>  }
> >
> > Hrmm, I think that is still broken, see how in schedule() we clear NR
> > before setting the new ->curr.
> >
> > So I think I had a loop on rq->curr the last time we talked about this,
> > but alternatively we could look at clearing NR after setting a new curr.
> >
> > I think I once looked at why it was done before, of course I can't
> > actually remember the details :/
>=20
> Wouldn't this be a little simpler and maybe even faster if we just
> changed the idle loop to make TIF_POLLING_NRFLAG be a real indication
> that the idle task is running and actively polling?  That is, change
> the end of cpuidle_idle_loop to:
>=20
>                 preempt_set_need_resched();
>                 tick_nohz_idle_exit();
>                 clear_tsk_need_resched(current);
>                 __current_clr_polling();
>                 smp_mb__after_clear_bit();
>                 WARN_ON_ONCE(test_thread_flag(TIF_POLLING_NRFLAG));
>                 sched_ttwu_pending();
>                 schedule_preempt_disabled();
>                 __current_set_polling();
>=20
> This has the added benefit that the optimistic version of the cmpxchg
> loop would be safe again.  I'm about to test this with this variant.
> I'll try and send a comprehensible set of patches in a few hours.
>=20
> Can you remind me what the benefit was of letting polling be set when
> the idle thread schedules?=20

Hysterical raisins, I don't think there's an actual reason, so yes, that
might be the best option indeed.

> It seems racy to me: it probably prevents
> any safe use of the polling bit without holding the rq lock.  I guess
> there's some benefit to having polling be set for as long as possible,
> but it only helps if there are wakeups in very rapid succession, and
> it costs a couple of extra bit ops per idle entry.

So you could cheat and set it in pick_next_task_idle() and clear in
put_prev_task_idle(), that way the entire idle loop, when running has it
set.

And then there was the idle injection loop crap trainwreck, which I
should send patches for..=20

--c1TZOjW/0w0yugbT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjfWmAAoJEHZH4aRLwOS6zEQP/31h7ziwGx3/wDiN1Vtyb8uO
rtLHlyTqjFanis7oy5AuKJTAnynpFVyB/7kSV2tCU3w/L3X/pfTVH7gxRof0JEwO
pBmaTJ4sCjNTEm73PcV23Lzy4WaqzoBw1udQ2Dvv/kNfQELDzH5FMiBX9UthAGTW
E57QyQp01OrYptw0DgrpUeC0eb33jIs/rH20Uq/NYSCruiMTc1tiHkfoiarpdfYg
AdrvRF4ZgRZGAo1SvmQZGfRSDP0x2v7BXqXxFJIMhBWwziqoMZKKOnmHC4+MW52h
iQTDeL0KYZWmbnby4fkH7gistAwNToh2wxRqm/kvZPUBpYiHu8xm1kP2q1cwilFP
KMH7ZFaGNTkuhjv2uuVTwdfhgIKHTMl5wxeNJE7dYpBAJatDhaplbPYvXZATd2Xv
c+BY0Oqg8HT0ld2+HppDe0H5avGBw9LFMrn7tXE8I8/1N5fgzVrak+0iRbzKB1ea
uXo3zXs23nq01MZlBLa2DkYMuekyWYXg6Mv5vyxQfqKvydXErGi6RiosMtJfzyYg
yq0SLKFzf1IZQJ9wdDiCJvCO7hC1oPcz6sDyDu2ZDR3EvwL0hhfkrfMIryjGgZd7
Coig/NB7lWYxwSSQTCCg4GKhTsVd1Zuv3hOTGceMWrop44sADcTHKMzvMDAzkeS9
hIzq2u6KX1NoGZfRj4e5
=sxVT
-----END PGP SIGNATURE-----

--c1TZOjW/0w0yugbT--
