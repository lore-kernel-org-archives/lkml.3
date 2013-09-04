Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761421Ab3IDEYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 00:24:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42230 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab3IDEYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 00:24:50 -0400
Date: Wed, 4 Sep 2013 14:24:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20130904142430.1da14a0ca9fd274d3c41ce66@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__4_Sep_2013_14_24_30_+1000_qk/+2bdO0tdB9EHm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__4_Sep_2013_14_24_30_+1000_qk/+2bdO0tdB9EHm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/x86/include/asm/spinlock.h between commit bc08b449ee14 ("lockref:
implement lockless reference count updates using cmpxchg()") from Linus'
tree and commit 545ac13892ab ("x86, spinlock: Replace pv spinlocks with
pv ticketlocks") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/include/asm/spinlock.h
index e0e6684,8963bfe..0000000
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@@ -34,11 -37,31 +37,36 @@@
  # define UNLOCK_LOCK_PREFIX
  #endif
 =20
 +static __always_inline int arch_spin_value_unlocked(arch_spinlock_t lock)
 +{
 +	return lock.tickets.head =3D=3D lock.tickets.tail;
 +}
 +
+ /* How long a lock should spin before we consider blocking */
+ #define SPIN_THRESHOLD	(1 << 15)
+=20
+ extern struct static_key paravirt_ticketlocks_enabled;
+ static __always_inline bool static_key_false(struct static_key *key);
+=20
+ #ifdef CONFIG_PARAVIRT_SPINLOCKS
+=20
+ static inline void __ticket_enter_slowpath(arch_spinlock_t *lock)
+ {
+ 	set_bit(0, (volatile unsigned long *)&lock->tickets.tail);
+ }
+=20
+ #else  /* !CONFIG_PARAVIRT_SPINLOCKS */
+ static __always_inline void __ticket_lock_spinning(arch_spinlock_t *lock,
+ 							__ticket_t ticket)
+ {
+ }
+ static inline void __ticket_unlock_kick(arch_spinlock_t *lock,
+ 							__ticket_t ticket)
+ {
+ }
+=20
+ #endif /* CONFIG_PARAVIRT_SPINLOCKS */
+=20
  /*
   * Ticket locks are conceptually two parts, one indicating the current he=
ad of
   * the queue, and the other indicating the current tail. The lock is acqu=
ired

--Signature=_Wed__4_Sep_2013_14_24_30_+1000_qk/+2bdO0tdB9EHm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSJrYGAAoJEECxmPOUX5FEn7AQAKdebEoK+3lwINgtJv70Mcb4
ruNwriKKz2oYSXFwvh7PtcWxPhxpbwfZ2FBcFvYm9GYg2oF8TwC/hKLX1yVUCQVy
xik69sseShbnzFIcfHwm5uCJ+VvZPpyAYtl1ySoXq2IzZmCFIJA7CrbxlME2LTTQ
WxpatR83xPyFtp1X4iu0PRL2OrDmia4Clnl/xzLGs8Qdx/aSnVQLOLKxZaUSbx6R
t4uz9Pjve24CDIEfAD0h9gmhreiNqEHLqo/Y4J7zy14B7B1vzt9piablT2+pHQT1
2wCuPX/0zwEVKA/dlUcTT6mrYbt50OledOAq54+N3s1qowlXhqdIUg0Bk7bkei3J
6k3f6csh37QCx7F0StNGkCj7ryZi3Gex3uNfCXG2NcdbtFLaHCMpwfUCV1kU+4sv
AZ0CK30Mzwzmc1/bvcHXoGuqCMDUklVbd4CpXsuYi3jSrsU7cuzLvKdPfF1ZT0q4
PEhW28g+e46L2uIDvYghuVZ6n9LqXBwirs9oxPIflXBIW19ZyW6lY822TIubAmuu
cy647q6yE7N2m5H8DJRkMSgoVEXJgj2i843IXyQfFrtQsDvTBuuid0S9x8hqfe7k
TlOHhb6qo9f8clFW2Esk5ZtoYOCddULujouQ0mNGLjEMlYEcigwWQuBeZoCZVp1Q
kcBApV+x3Bslod9QmV6H
=oG5H
-----END PGP SIGNATURE-----

--Signature=_Wed__4_Sep_2013_14_24_30_+1000_qk/+2bdO0tdB9EHm--
