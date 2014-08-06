Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbaHFIrl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 04:47:41 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55981 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722AbaHFIri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 04:47:38 -0400
Date: Wed, 6 Aug 2014 10:47:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140806084708.GR9918@twins.programming.kicks-ass.net>
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1406843709-23396-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140801150926.GA845@redhat.com>
 <20140801183251.GJ4784@linux.vnet.ibm.com>
 <20140801194417.GA27141@linux.vnet.ibm.com>
 <20140802144719.GA18018@redhat.com>
 <20140802225857.GC8101@linux.vnet.ibm.com>
 <20140805205711.7a52076c@gandalf.local.home>
 <20140806012139.GY8101@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vsq8Qt3EIJRbM1D8"
Content-Disposition: inline
In-Reply-To: <20140806012139.GY8101@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vsq8Qt3EIJRbM1D8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 05, 2014 at 06:21:39PM -0700, Paul E. McKenney wrote:
> > Yeah, idle threads can be affected by the trampolines. That is, we can
> > still hook a trampoline to some function in the idle loop.
> >=20
> > But we should be able to make the hardware call that puts the CPU to
> > sleep a quiescent state too. May need to be arch dependent. :-/
>=20
> OK, my plan for this eventuality is to do the following:
>=20
> 1.	Ignore the ->on_rq field, as idle tasks are always on a runqueue.
>=20
> 2.	Watch the context-switch counter.
>=20
> 3.	Ignore dyntick-idle state for idle tasks.
>=20
> 4.	If there is no quiescent state from a given idle task after
> 	a few seconds, schedule rcu_tasks_kthread() on top of the
> 	offending CPU.
>=20
> Your idea is an interesting one, but does require another set of
> dyntick-idle-like functions and counters.  Or moving the current
> rcu_idle_enter() and rcu_idle_exit() calls deeper into the idle loop.
>=20
> Not sure which is a better approach.  Alternatively, we could just
> rely on #4 above, on the grounds that battery life should not be
> too badly degraded by the occasional RCU-tasks interference.
>=20
> Note that this is a different situation than NO_HZ_FULL in realtime
> environments, where the worst case causes trouble even if it happens
> very infrequently.

Or you could shoot all CPUs with resched_cpu() which would have them
cycle through schedule() even if there's nothing but the idle thread to
run. That guarantees they'll go to sleep again in a !trampoline.

But I still very much hate the polling stuff...

Can't we abuse the preempt notifiers? Say we make it possible to install
preemption notifiers cross-task, then the task-rcu can install a
preempt-out notifier which completes the rcu-task wait.

After all, since we tagged it it was !running, and being scheduled out
means it ran (once) and therefore isn't on a trampoline anymore.

And the tick, which checks to see if the task got to userspace can do
the same, remove the notifier and then complete.



--vsq8Qt3EIJRbM1D8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT4euMAAoJEHZH4aRLwOS6VCIP/1yH16ZUpfnWulTRS3Qqmcm/
KhU/fGIw8pphd9g5dUqqAEhHT5rDjfcuo4kwn0I2Tvttoz7HaOaWkWYe0B6Joi7O
IGRfUFK4s7vB5nm+VPAJXworw6EnHVcVWXFM3PdBOl+6CpQxADUgX6GYVf6ytI6G
XPJ7VmUTr2v2iQA5u0dtV8Hffc9YAen3PPffs6xA3G3tysPwm6SiMAnZbYBuqQrQ
xx6KfVi8z6kxcgWdM1nnffqRYcHS+NWxC34y6Vrtn/TUFn7gien9TsOmBYa6fD08
5hRaTrMYV1vZr0+bfmRRAeNSLyI4GSyPe85/np8tDgvWm6/MNEBSoKuQkOeYtubf
6wgeTbrNuIlGYdiArQF1fe2Re+u11yNCnEnXWZ7xIyJGnGLWmbFnR/dfiPIczvKq
Lqw+SFsyQiv/Xd2ndC8H9gtmfDFXB2YreOSel9oS7C7vpVbGYDLyVAMY/hiMyVoE
1cgwLjxMHD3JyC4QQjIRv6FNOX1XSZsj7vBBq6qZshWleIp2dF24PaDgzd2W4Wt2
t62lNXap2XuvPRp7zmu2K0PpNzwpFwOom2tQFbhzXlvLLGXhfRt4r7+wDT0sHDv0
464xQlHApIMXI3xb2zb1uDmHjhmlprOcm9colvkiUgifpYk9XZLiqBFg9zbdRnwF
4f9vxMRvnSdkSaHNItc5
=4CtW
-----END PGP SIGNATURE-----

--vsq8Qt3EIJRbM1D8--
