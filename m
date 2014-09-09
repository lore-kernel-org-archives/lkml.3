Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbaIIJmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:42:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57218 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbaIIJmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:42:44 -0400
Date: Tue, 9 Sep 2014 11:42:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andreea-Cristina Bernat <bernat.ada@gmail.com>
Cc: paulus@samba.org, mingo@redhat.com, acme@kernel.org,
        linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] kernel: events: core: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Message-ID: <20140909094235.GD19379@twins.programming.kicks-ass.net>
References: <20140822132605.GA20130@ada>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1ExXuwkHt/ur4MCY"
Content-Disposition: inline
In-Reply-To: <20140822132605.GA20130@ada>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1ExXuwkHt/ur4MCY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 22, 2014 at 04:26:05PM +0300, Andreea-Cristina Bernat wrote:
> The use of "rcu_assign_pointer()" is NULLing out the pointer.
> According to RCU_INIT_POINTER()'s block comment:
> "1.   This use of RCU_INIT_POINTER() is NULLing out the pointer"
> it is better to use it instead of rcu_assign_pointer() because it has a
> smaller overhead.
>=20
> The following Coccinelle semantic patch was used:
> @@
> @@
>=20
> - rcu_assign_pointer
> + RCU_INIT_POINTER
>   (..., NULL)
>=20
> Signed-off-by: Andreea-Cristina Bernat <bernat.ada@gmail.com>
> ---
>  kernel/events/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 0d735be..4b84dd5 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -5744,7 +5744,7 @@ static void swevent_hlist_release(struct swevent_ht=
able *swhash)
>  	if (!hlist)
>  		return;
> =20
> -	rcu_assign_pointer(swhash->swevent_hlist, NULL);
> +	RCU_INIT_POINTER(swhash->swevent_hlist, NULL);
>  	kfree_rcu(hlist, rcu_head);
>  }

Paul, why not do something like the below and do away with all this
nonsense?

---
 include/linux/rcupdate.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index d231aa17b1d7..38c3e629ae70 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -623,7 +623,13 @@ static inline void rcu_preempt_sleep_check(void)
  * please be careful when making changes to rcu_assign_pointer() and the
  * other macros that it invokes.
  */
-#define rcu_assign_pointer(p, v) smp_store_release(&p, RCU_INITIALIZER(v))
+#define rcu_assign_pointer(p, v)					\
+do {									\
+	if (__builtin_constant_p(v) && v =3D=3D NULL)			\
+		p =3D RCU_INITIALIZER(v);					\
+	else								\
+		smp_store_release(&p, RCU_INITIALIZER(v));		\
+} while (0)
=20
 /**
  * rcu_access_pointer() - fetch RCU pointer with no dereferencing

--1ExXuwkHt/ur4MCY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDsuLAAoJEHZH4aRLwOS61A0P/RyDPsGVi/i0vSTuYouNhhA8
idGm7xanORRa5J7mmqu8kwbmo60Fc+asewHKEE5yJt4oBMwvAipKcqSaimDA43Bu
2ldsRPtOPNwsBJ/pp9rBFPUbgpWHr+8C0rBV5qWWVtldzrHmzuaE+ItZ9QE5MGqI
GlvC2aXARc6WcnFZqXwki110nZC3OC+ggBhcFhEqW1cvNqlVg0qx+KlYJqJI1pDg
biWrjRn+f1s3498uct/LzM9fuQorS5lr3Qc4+M1Tu4LbckGlkNQVLh3GuVdzfh5N
mEl8CBkWtQrhdCT6A+2KuPB2nyRxaRTDkwMBJl7f4h2IjfucIZR5yhsUfGz40jce
lB6j2FKPo/9BPx4D7IGlDmws8Q3QGQphWdP5JoZZOGs38PzqWpk19abQnBHtN32f
YgPqE1vHnN96DxgjuPdIL2qWGSglMAP9CDR9ahE3bbWqd1kepGT4ohr4diJHT0o5
5EP7wVOZjh6AU3Q71qqfKUDFeAQtWxCQkfAG/uxDVEDrh4HwGhWYAiikIADlyBUK
iurfNfbqLxYJA2ZrKaYwiBrE6XpRr88EyukcMFcGt27dL8GpvPfv0w4kdGVla++B
2KFR08beypx3npLNqrfgHOh6MP06vDEtOrmqoowRT5E5sp7RsKU3USwc+c4UEIJA
5OOm6+nK+MIJ4l5fhaZq
=s4RD
-----END PGP SIGNATURE-----

--1ExXuwkHt/ur4MCY--
