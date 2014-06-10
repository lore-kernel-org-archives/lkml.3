Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaFJOsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 10:48:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:49851 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaFJOsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 10:48:36 -0400
Date: Tue, 10 Jun 2014 16:48:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: safety of *mutex_unlock() (Was: [BUG] signal: sighand
 unprotected when accessed by /proc)
Message-ID: <20140610144830.GD3213@twins.programming.kicks-ass.net>
References: <20140603172632.GA27956@redhat.com>
 <CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com>
 <20140603200125.GB1105@redhat.com>
 <20140606203350.GU4581@linux.vnet.ibm.com>
 <20140608130718.GA11129@redhat.com>
 <20140609162613.GE4581@linux.vnet.ibm.com>
 <20140609181553.GA13681@redhat.com>
 <20140609142956.3d79e9d1@gandalf.local.home>
 <CA+55aFyO8bb7fS3AaQzfMq7geERQ1JpSdcRZ9Fbs5-tZP0oRXg@mail.gmail.com>
 <20140610125655.GJ4581@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="80KdhljSN0pKc7w4"
Content-Disposition: inline
In-Reply-To: <20140610125655.GJ4581@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--80KdhljSN0pKc7w4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 10, 2014 at 05:56:55AM -0700, Paul E. McKenney wrote:
> On Mon, Jun 09, 2014 at 11:51:09AM -0700, Linus Torvalds wrote:

> > This is subtle, and it is basically unavoidable. If a mutex (or
> > counting semaphore) has a fast-path - and a mutex/semaphore without a
> > fast-path is shit - then this issue will exist. Exactly because the
> > fast-path will depend on just one part of the whole big mutex
> > structure, and the slow-path will have other pieces to it.
> >=20
> > There might be reasonable ways to avoid this issue (having the
> > fastpath locking field share memory with the slow-path locking, for
> > example), but it's not how our semaphores and mutexes work, and I
> > suspect it cannot be the case in general (because it limits you too
> > badly in how to implement the mutex). As a result, this is all "by
> > design" as opposed to being a bug.
>=20
> So to safely free a structure containing a mutex, is there some better
> approach than the following?
>=20
> 	mutex_lock(mem->mutex);
> 	kill_it =3D !--mem->refcount;
> 	rcu_read_lock();
> 	mutex_unlock(mem->mutex);
> 	rcu_read_unlock();
> 	if (kill_it)
> 		kfree_rcu(mem, rh); /* rh is the rcu_head field in mem. */
>=20
> For example, is there some other way to know that all the prior lock
> releases have finished their post-release accesses?

So Thomas posted a patch curing rt_mutex, and for that we really _have_
to because it needs to replace a spinlock_t. But for the regular mutex
its better (from a performance pov) to not do this.

By releasing early and checking for pending waiters later we allow
earlier lock stealing, which is good for throughput.

Back to your example, I think your example is misleading in that it
states: 'a structure containing a mutex'. The problem only arises when
that mutex is used as part of the life-time management of said
structure.

If it has regular (atomic_t or atomic_long_t or spinlock_t) reference
counting, we know the mutex_unlock() must have competed by the time we
do put_*(), and if that put was the last one, there cannot have been
another, otherwise your reference counting is broken.

--80KdhljSN0pKc7w4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTlxq+AAoJEHZH4aRLwOS6xvcP/32YbwvxVJ5PLmtBgN25Tb40
+hOKoWzbk7V2hTVsUKqgoDFjaxKe5kvNZppuxihATC3wjNhI+DXQJy8AZQrE1A6w
8rJ1zx5kmnv42bHQX9scTJB25qJUFdaso4ADPdk4jKuNJ5/9n4JtRy72hvAjZFvw
mr2ec88OQOrJ4dPB4usdw1039ua8a8XNQQFj5N9b73XwMo3tikdecezhBpk9mfOG
McvgV+F/cAbY0XueGjxx6DTlvl111rd5P6mQsyM7psTPelsGZVfc2EGesrPxt1HP
yY730nG7/HseyPAbo8X7ZmRm/HLK2QGxoGEbrhuadN1qXe1W2iheaIqQkepNCKIP
eddwY1buj4z1JFzLYh/gsTtQbUo/XqfhB5t436Hek+d1JCaeF0cWyTSx6WFkhYwO
rS9z8s+WS2Bqd4X158FX9zlE7NpGHc1MorMCA/EBjh/7Wc1Ai21UHsMoLnO174id
8/kdD04agQZlWlzHNhY9Wlp2NRsNMr6UfQgA/cVA2SA7Mee9/o+yXyE5fKuCy5I/
v0hFjOA7llxu9F5yYW1HayAmwo2KFz9efd+5fMv/sYKQ3hMm2KWO+MV9qQ9DAMGc
41w+JoPvckY+0l+m2LpHF+n/flQlqj6oQKL70ix0vcvmeyrMbziSL7MmEwthr7dU
laBe4xrjrcjKhVPF7jxM
=yPl1
-----END PGP SIGNATURE-----

--80KdhljSN0pKc7w4--
