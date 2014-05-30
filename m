Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826AbaE3QT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:19:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50067 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378AbaE3QT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:19:58 -0400
Date: Fri, 30 May 2014 18:19:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Jet Chen <jet.chen@intel.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [prink]  BUG: spinlock lockup suspected on CPU#0, swapper/1
Message-ID: <20140530161948.GZ13658@twins.programming.kicks-ass.net>
References: <538808FD.3060707@intel.com>
 <20140530155051.GD2419@quack.suse.cz>
 <20140530161647.GD11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V2AZ19bMCakBLong"
Content-Disposition: inline
In-Reply-To: <20140530161647.GD11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V2AZ19bMCakBLong
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 30, 2014 at 06:16:47PM +0200, Peter Zijlstra wrote:
> On Fri, May 30, 2014 at 05:50:51PM +0200, Jan Kara wrote:
> > > [    7.492350] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > [    7.492350] [ INFO: possible circular locking dependency detected ]
> > > [    7.492350] 3.15.0-rc5-00567-gbafe980 #1 Not tainted
> > > [    7.492350] -------------------------------------------------------
> > > [    7.492350] swapper/1 is trying to acquire lock:
> > > [    7.492350]  (&irq_desc_lock_class){-.-...}, at: [<8107dc8c>] __ir=
q_get_desc_lock+0x3c/0x70
> > > [    7.492350]=20
> > > [    7.492350] but task is already holding lock:
> > > [    7.492350]  (&port_lock_key){......}, at: [<815f5b27>] serial8250=
_startup+0x337/0x720
> > > [    7.492350]=20
> > > [    7.492350] which lock already depends on the new lock.
> > > [    7.492350]=20
> > > [    7.492350]=20
> > > [    7.492350] the existing dependency chain (in reverse order) is:
> > > [    7.492350]=20
> > > -> #2 (&port_lock_key){......}:
> > > [    7.492350]        [<810750e5>] lock_acquire+0x85/0x190
> > > [    7.492350]        [<81baed9d>] _raw_spin_lock_irqsave+0x4d/0x60
> > > [    7.492350]        [<8106eb1c>] down_trylock+0xc/0x30
> > > [    7.492350]        [<8107b795>] console_trylock+0x15/0xb0
> > > [    7.492350]        [<8107be8f>] vprintk_emit+0x14f/0x4d0
> > > [    7.492350]        [<81b969b9>] printk+0x38/0x3a
> > > [    7.492350]        [<82137f78>] print_ICs+0x5b/0x3e7
> > > [    7.492350]        [<8212bb41>] do_one_initcall+0x8b/0x128
> > > [    7.492350]        [<8212bd7d>] kernel_init_freeable+0x19f/0x236
> > > [    7.492350]        [<81b9238b>] kernel_init+0xb/0xd0
> > > [    7.492350]        [<81bb0080>] ret_from_kernel_thread+0x20/0x30
> >
> >   But this looks really strange. How can we possibly get port_lock_key =
in
> > down_trylock() which calls raw_spin_lock_irqsave() on console_sem->lock?
> > That looks like some strange lockdep key aliasing issue? Peter do you h=
ave
> > any idea?
>=20
> No, strange that, I can't say I've ever seen a bogus stracktrace in
> lockdep reports like this.
>=20
> So this is through: check_prev_add()->save_trace(). And that doesn't
> reuse entries, at worst it can truncate a trace when we run out of
> entries, but the above looks complete since it terminates in
> lock_acquire(), which is the right place to be.
>=20
> But its worse than that, the above trace should link i8259A_lock to
> port_lock_key, and I can't see where we would have taken i8259A_lock
> either.

Oh, wait, I missed it, that would be: print_ICs()->print_PIC(), it takes
that lock there.

--V2AZ19bMCakBLong
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTiK+kAAoJEHZH4aRLwOS6Gp8P/0K3cYmQYHZrBcLWwTMLCK8K
5RiMeFuinURegIengZAgl1PJUQ/IypnN8WIxUch0QeG82jC9hW+3R3l4KcdiwcJk
AI6pDhRCwP6MCCGFzJQJKztE5ppkaVlayuWSGoD4zw5c73WVJURfrMqLm0hlqdms
3kzBA/95Ih46TqLFvIIWTjcUELqh2XCSsMtcgMHSNJpMdiKhfGOwb7bwzuiz2t9Z
HoOnKfwKbIa5AY+qanMLvTO9XjIqmS2WhitjeD0sXasrjMU/Os/KZPNLCAQdc/rK
Vw+Jf7gxsdTuVd+Yxua5M7i+1JS+RpVcQKRtfJQQ9t6ZsMDCuQMpml8l1RzfIl5Y
pIyMPTJ0K5ekAD/711SY479ZheEGNgd2G1azn7GsgRGsKcK7uhCSJw+YPR1MLjAM
uLd2xj0zM+FHsBIdPsXrFTRELFePUPIjXggI4ps+aLmtHGvfTaMBTm3S3GWBG2u5
654tmCpUWEbzWw8K+oa9He2ZL507ZASAxvsOfPCBtLiD8IVztDBboKmpVSmv7GYR
/k/FuehksO8WpUZvQwpLOQLNXo6YKNHsb8iHKvBX3SN2A5NpnXkdNiKR/r5qdoeL
WowAT4asb+BjX8g5VhkEmy3onzYo/qQpiaL2eaJOAgBT0fvXLaPM5KTrLnEFRyTb
7xDOyu+15T6Js6QhjJFt
=7RIZ
-----END PGP SIGNATURE-----

--V2AZ19bMCakBLong--
