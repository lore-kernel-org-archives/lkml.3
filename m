Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933918AbaE3QRD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:17:03 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49105 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378AbaE3QRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:17:00 -0400
Date: Fri, 30 May 2014 18:16:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Jet Chen <jet.chen@intel.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [prink]  BUG: spinlock lockup suspected on CPU#0, swapper/1
Message-ID: <20140530161647.GD11096@twins.programming.kicks-ass.net>
References: <538808FD.3060707@intel.com>
 <20140530155051.GD2419@quack.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jvwwc3lboJHenLjr"
Content-Disposition: inline
In-Reply-To: <20140530155051.GD2419@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jvwwc3lboJHenLjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2014 at 05:50:51PM +0200, Jan Kara wrote:
> > [    7.492350] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > [    7.492350] [ INFO: possible circular locking dependency detected ]
> > [    7.492350] 3.15.0-rc5-00567-gbafe980 #1 Not tainted
> > [    7.492350] -------------------------------------------------------
> > [    7.492350] swapper/1 is trying to acquire lock:
> > [    7.492350]  (&irq_desc_lock_class){-.-...}, at: [<8107dc8c>] __irq_=
get_desc_lock+0x3c/0x70
> > [    7.492350]=20
> > [    7.492350] but task is already holding lock:
> > [    7.492350]  (&port_lock_key){......}, at: [<815f5b27>] serial8250_s=
tartup+0x337/0x720
> > [    7.492350]=20
> > [    7.492350] which lock already depends on the new lock.
> > [    7.492350]=20
> > [    7.492350]=20
> > [    7.492350] the existing dependency chain (in reverse order) is:
> > [    7.492350]=20
> > -> #2 (&port_lock_key){......}:
> > [    7.492350]        [<810750e5>] lock_acquire+0x85/0x190
> > [    7.492350]        [<81baed9d>] _raw_spin_lock_irqsave+0x4d/0x60
> > [    7.492350]        [<8106eb1c>] down_trylock+0xc/0x30
> > [    7.492350]        [<8107b795>] console_trylock+0x15/0xb0
> > [    7.492350]        [<8107be8f>] vprintk_emit+0x14f/0x4d0
> > [    7.492350]        [<81b969b9>] printk+0x38/0x3a
> > [    7.492350]        [<82137f78>] print_ICs+0x5b/0x3e7
> > [    7.492350]        [<8212bb41>] do_one_initcall+0x8b/0x128
> > [    7.492350]        [<8212bd7d>] kernel_init_freeable+0x19f/0x236
> > [    7.492350]        [<81b9238b>] kernel_init+0xb/0xd0
> > [    7.492350]        [<81bb0080>] ret_from_kernel_thread+0x20/0x30
>
>   But this looks really strange. How can we possibly get port_lock_key in
> down_trylock() which calls raw_spin_lock_irqsave() on console_sem->lock?
> That looks like some strange lockdep key aliasing issue? Peter do you have
> any idea?

No, strange that, I can't say I've ever seen a bogus stracktrace in
lockdep reports like this.

So this is through: check_prev_add()->save_trace(). And that doesn't
reuse entries, at worst it can truncate a trace when we run out of
entries, but the above looks complete since it terminates in
lock_acquire(), which is the right place to be.

But its worse than that, the above trace should link i8259A_lock to
port_lock_key, and I can't see where we would have taken i8259A_lock
either.

So not only does it not terminate at taking the right lock, it doesn't
even take the previous lock.

> > -> #1 (i8259A_lock){-.....}:
> > [    7.492350]        [<810750e5>] lock_acquire+0x85/0x190
> > [    7.492350]        [<81baed9d>] _raw_spin_lock_irqsave+0x4d/0x60
> > [    7.492350]        [<81005af1>] unmask_8259A_irq+0x11/0x60
> > [    7.492350]        [<81005b4b>] enable_8259A_irq+0xb/0x10
> > [    7.492350]        [<8107fffb>] irq_enable+0x2b/0x40
> > [    7.492350]        [<8108005d>] irq_startup+0x4d/0x60
> > [    7.492350]        [<8107f2bc>] __setup_irq+0x39c/0x460
> > [    7.492350]        [<8107f433>] setup_irq+0x33/0x80
> > [    7.492350]        [<8212db15>] setup_default_timer_irq+0xf/0x11
> > [    7.492350]        [<8212db2d>] hpet_time_init+0x16/0x18
> > [    7.492350]        [<8212daff>] x86_late_time_init+0x9/0x10
> > [    7.492350]        [<8212ba3d>] start_kernel+0x331/0x3aa
> > [    7.492350]        [<8212b380>] i386_start_kernel+0x12e/0x131
> > [    7.492350]=20

And this one looks legit, weird that.

--jvwwc3lboJHenLjr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTiK7vAAoJEHZH4aRLwOS6+1wP/Aw5E9C1BUEQc2sgSLjbQjfj
obfpDgQOk5196Nl3No3RSs7bjz2iz7aV/mn8Bqg8eg54/SQnMh2lpJjI5oK3lyDg
EEmN+88yq8vWnP+juTFp45zdxgZY5ZRVQHTWgnfS16pzvEctqZxoydtKc+xPF5O4
sPxqzwrv0iAG2VwfUye7ZXtN20HBSqwyVbzyWgsTqDX4BmW+CNVrIiKCQeAHOiFL
UNUm2SS/idK5g/pBBEV/Bq1SteHe1VR03BVpug3Uj3XtP6/2TlfQkE2Uz1GPOSpJ
07MtocrRQaBeRa05P5NMTvhWgs7ag209MxuFVhvFigI733vT3Cx3Ejra1XJFRQA9
0MFcXekHXUu3BBMIwp56BjfaXqlT4tU7aeRrlz3WL0rrtHNMO7cTgDJM6O7aubg6
cSlk3CC5NNj5lC5Hdt8Jy+b2kjGwbjjBDuCj1YKvNQuDGxrCy0v1JTXnxJyxmSFO
4YlPHKXijKL0KpZ9uorMh4iHklU5AWteVIvo7miQbMAmh+Nv/GUeP1cwCQerA4pm
vroYiAxLl0qthwvluBzfBtAYhkhZfy/+BLaq+zXkAV1hrFHosF7WoeMtiIFCkzA7
eod4VASjoJE7kZFYHfhalW3udLB5y9vS8Qi+32X6NXhzyfnCkZbE+5sTsZENRB2l
MYeKp55t/5NfMAsROp0Q
=rj8x
-----END PGP SIGNATURE-----

--jvwwc3lboJHenLjr--
