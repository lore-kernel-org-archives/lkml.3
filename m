Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbaFCHUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:20:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51653 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaFCHUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:20:37 -0400
Date: Tue, 3 Jun 2014 09:20:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, John David Anglin <dave.anglin@bell.net>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH v2] introduce atomic_pointer to fix a race condition in
 cancelable mcs spinlocks
Message-ID: <20140603072005.GG11096@twins.programming.kicks-ass.net>
References: <alpine.LRH.2.02.1406011342470.20831@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1406021158360.20627@file01.intranet.prod.int.rdu2.redhat.com>
 <20140602162525.GH16155@laptop.programming.kicks-ass.net>
 <CA+55aFzwrqkwD=G=w2m7TdXTpsMFjV7XUMXv5DMPGr=5x5YGCQ@mail.gmail.com>
 <alpine.LRH.2.02.1406021622200.5874@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fcasAdn045BL8lzs"
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1406021622200.5874@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fcasAdn045BL8lzs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 02, 2014 at 04:46:32PM -0400, Mikulas Patocka wrote:
> It's not only parisc - tile32, arc, metag (maybe hexagon) are broken too,=
=20
> because they don't have cmpxchg in hardware.

metag actually does, and the lock1 thing is a fallback/test thing:

config METAG_ATOMICITY_LOCK1
	depends on SMP
	bool "lock1"
	help
	  This option uses the LOCK1 instruction for atomicity. This is mainly
	  provided as a debugging aid if the lnkget/lnkset atomicity primitive
	  isn't working properly.

Then again, metag has qualiteee bits like:

config METAG_SMP_WRITE_REORDERING
	bool
	help
	  This attempts to prevent cache-memory incoherence due to external
	  reordering of writes from different hardware threads when SMP is
	  enabled. It adds fences (system event 0) to smp_mb and smp_rmb in an
	  attempt to catch some of the cases, and also before writes to shared
	  memory in LOCK1 protected atomics and spinlocks.
	  This will not completely prevent cache incoherency on affected cores.

Which makes me back away slowly before starting to run.

And there is sane arc hardware:

config ARC_HAS_LLSC
	bool "Insn: LLOCK/SCOND (efficient atomic ops)"
	default y
	depends on ARC_CPU_770 && !ARC_CANT_LLSC

tile32 is indeed equally wrecked, but at least they have a tile64 system
that is useful (albeit somewhat strange).

Same for sparc32, there's sparc64 which is sane.

parisc otoh is a dead arch that never got sane.

--fcasAdn045BL8lzs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjXclAAoJEHZH4aRLwOS6GfUP/0PvUigk+xCoOmj+kbq410lS
SNVKxiitcZ0Gl5Ha0Y2vWUxquWbCzylbinbaYmA7wbvaAkNYdKFgkuNBXtmACuZ7
hRlrImpQR3u0pdKFvK4/y+dAOOPSj7hZdt45vphZWCUqdWfnraSPPnZOGFIbn52G
Ray4hZ4TrO6NwBaOp1oMHrXUEcpiAPm+ZOf4GJUfGUfKhAj1d41SOc0s8B6aOXLr
Z/XacD2RfCYsxPfaWksyaL+ZnoTf3uRrFCdqLGidEPfR7tsq1Apc53xIHxCDoW/t
ZvELSNtCcGIuTt40NvbddKtdqJ+J0iYHdx+6Kn5uv/AZFIRFdusllHezcptBkUbC
kb3V8bux3LELsz+xmq6fvADENLNwdpTFU1ysLmrbRJdn4AmGj1sITyhh0QuiZYCQ
oY8D3UPNfAmThcoOO5YORPFbzR0wiapwxxoQ9szhSapM+QLIavWHZcM9r7/2blkO
yZRqXW+zqEMH/YGO7INPjz0Coj1dWPyjY8DxgK0xze+v7F08b/oqMe+XJGv3rD3X
qhcxHpTJIrsIR7sTS64dqWLyiVezvDgSTYajpaXNGPfBa31Vr99VKf2V9Lukf89H
p+hgRUPPEOC/pSFTG6HTcBWYQOSwGfWOpPmp5E+uGBvBFu2/yxNtGC4u+yMfeKwe
wLXeC3SPjYgX+tt+GuL4
=twhr
-----END PGP SIGNATURE-----

--fcasAdn045BL8lzs--
