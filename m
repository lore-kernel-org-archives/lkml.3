Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbaE0SZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:25:57 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33374 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaE0SZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:25:56 -0400
Date: Tue, 27 May 2014 20:25:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH 3.14-rt] sched/numa: Fix task_numa_free() lockdep splat
Message-ID: <20140527182541.GH11096@twins.programming.kicks-ass.net>
References: <20140509181214.GK29014@linutronix.de>
 <1400297819.9493.11.camel@marge.simpson.net>
 <20140527141836.4f466086@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a1taQt+5gib656GU"
Content-Disposition: inline
In-Reply-To: <20140527141836.4f466086@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a1taQt+5gib656GU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 27, 2014 at 02:18:36PM -0400, Steven Rostedt wrote:
> [ moving this to LKML from linux-rt-users, as that's where it should be ]
>=20
> On Sat, 17 May 2014 05:36:59 +0200
> Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
>=20
> > 3.14-rt being build with a non-rt config is unlikely, but..
> >=20
> > >From 60e69eed85bb7b5198ef70643b5895c26ad76ef7 Mon Sep 17 00:00:00 2001
> > From: Mike Galbraith <bitbucket@online.de>
> > Date: Mon, 7 Apr 2014 10:55:15 +0200
> > Subject: [PATCH] sched/numa: Fix task_numa_free() lockdep splat
> >=20
> > Sasha reported that lockdep claims that the following commit:
> > made numa_group.lock interrupt unsafe:
> >=20
> >   156654f491dd ("sched/numa: Move task_numa_free() to __put_task_struct=
()")
> >=20
> > While I don't see how that could be, given the commit in question moved
> > task_numa_free() from one irq enabled region to another, the below does
> > make both gripes and lockups upon gripe with numa=3Dfake=3D4 go away.
>=20
> It wasn't the irqs that was causing the lockdep splat, but the
> softirqs. You moved it into __put_task_struct() which is called as a
> rcu callback that gets called from soft irqs. So yes, you need to
> prevent softirqs from happening whenever you take the lock.
> spin_lock_irq() is a bigger hammer than needed. The patch below should
> be good enough.
>=20
> I kept the double_lock_irq() as there is no double_lock_bh(). Should we
> bother to make one?

Nope, its really IRQs.

do_exit()
  exit_itimers()
    itimer_delete()
      spin_lock_irqsave(&timer->it_lock, &flags);
      timer_delete_hook(timer);
        kc->timer_del(timer) :=3D posix_cpu_timer_del()
          put_task_struct()
            __put_task_struct()
              task_numa_free()
                spin_lock(&grp->lock);

Which nests the grp->lock inside the timer->it_lock, and where the
timer->it_lock is IRQ-safe, the grp->lock is not.

This allows for IRQ deadlocks.



--a1taQt+5gib656GU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThNigAAoJEHZH4aRLwOS6CNkP/2VOcM1IJzxgAnQ/HRCCzCCQ
7zKQtE5uPJC3EQcsIHAZnIyvT03ZJBDgESLxeFL30DpnZdMw6IWGkSnLq8tlrbR2
PvFiC2hUrEh3FRRkgg9GCW3hvxV+BN1wMCFPuYgjfuYxDIfocI5+yaRHGLEII4bO
FMi8WJf3LU7hlAns1j4TneUd/huwoKFACPQM16vfr+qr8aI1Zi9/rKflJcBR9MKS
N9pNNcji0Er+4PxzytEVCQpJyc88i7Yh967+JlusI7dj2nJ9UeV5ZAKjySHk62zV
fWNHT78WIqc3GcBOy96bdRZlXvqVqyCGBw5JthpouvsDdqdXziBjLroRczgarh+x
4moIPpjb6PlFl9EBaMO9QOARBP/GniWhbdWJex6MGRO7SCvm0Q9CkNK4LxwJr8J9
EzU+kQdYCgXNAdXGpVbgIUbjD+RiXf8gyMJaQ9/yKgV6CzfXGZReJpRbh/aWmEFg
k77pabDfFpoqia9CrioEKH0PGljm0EKLlWJu4zqOUfxOIG64a1lSM/7tidODxojC
p/ihd0fxs29s6pqfQzksZKpavvvT/0rme+bsBiCMsgZXH4qSkuawKfo7l7RInLyA
BrxVFfvZpsiVgbMH/vT325fzK7/nDobXU8REXdq4QfesyLZS3RRJR19REaMk4cKE
qp9oF1EGyF03OiQ37I2J
=8LYl
-----END PGP SIGNATURE-----

--a1taQt+5gib656GU--
